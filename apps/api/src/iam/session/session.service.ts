import { randomUUID } from "node:crypto";
import { Inject, Injectable, Logger } from "@nestjs/common";
import { type AuditEventInput, AuditService } from "../../audit/audit.service";
import { APP_CONFIG, type AppConfig } from "../../config/env.config";
import { PrismaService } from "../../database/prisma.service";
import {
  type AuthSession,
  SessionRevokeReason,
  type SubjectType,
} from "../../database/prisma.types";
import type { RequestContext } from "../auth/auth.service";
import { RefreshTokenService } from "./refresh-token.service";
import { SessionCache } from "./session-cache";
import { sessionExpired } from "./session.errors";
import { userRefOf } from "./subject-type";

export type SessionSubject = {
  type: SubjectType;
  id: string;
  operatorId?: string;
};

export type IssuedSession = {
  session: AuthSession;
  /** Token thô — trả cho client đúng một lần. */
  refreshToken: string;
};

/** Thua race rotate — ném bên TRONG transaction để Prisma rollback row con. */
class LostRotationRace extends Error {}

/** Chừa cho lệch đồng hồ + độ trễ giữa lúc tạo phiên và lúc ký access token. */
const ACCESS_TOKEN_SKEW_SECONDS = 60;

/** Trần an toàn cho vòng revoke — thực tế dừng ở vòng 2 (xem `revoke`). */
const MAX_REVOKE_ROUNDS = 5;

type RevokeTarget = { familyId: string } | { userRef: string };

/** Chạy sau khi token hợp lệ, TRƯỚC khi ghi row mới — chỗ gắn rate limit theo family. */
export type BeforeRotate = (current: AuthSession) => Promise<void>;

@Injectable()
export class SessionService {
  private readonly logger = new Logger(SessionService.name);

  constructor(
    @Inject(APP_CONFIG) private readonly config: AppConfig,
    private readonly prisma: PrismaService,
    private readonly refreshTokens: RefreshTokenService,
    private readonly audit: AuditService,
    private readonly cache: SessionCache,
  ) {}

  private refreshExpiry(from: Date): Date {
    return new Date(
      from.getTime() + this.config.REFRESH_TOKEN_TTL_SECONDS * 1000,
    );
  }

  async create(
    subject: SessionSubject,
    ctx: RequestContext,
  ): Promise<IssuedSession> {
    const { token, hash } = this.refreshTokens.mint();
    const session = await this.prisma.authSession.create({
      data: {
        subjectType: subject.type,
        subjectId: subject.id,
        userRef: userRefOf(subject.type, subject.id),
        familyId: randomUUID(),
        refreshTokenHash: hash,
        expiresAt: this.refreshExpiry(new Date()),
        operatorId: subject.operatorId,
        ip: ctx.ip,
        userAgent: ctx.userAgent,
      },
    });
    this.recordEvent(
      subjectEvent(session, "auth.session.issued", {
        after: { familyId: session.familyId },
      }),
    );
    return { session, refreshToken: token };
  }

  async rotate(
    rawToken: string,
    ctx: RequestContext,
    beforeRotate?: BeforeRotate,
  ): Promise<IssuedSession> {
    const current = await this.prisma.authSession.findUnique({
      where: { refreshTokenHash: this.refreshTokens.hash(rawToken) },
    });

    if (!current || current.expiresAt <= new Date() || current.revokedAt) {
      throw sessionExpired();
    }
    // Token đã rotate rồi mà vẫn được gửi lên = dùng lại = tín hiệu tấn công.
    if (current.rotatedAt) {
      await this.handleReuse(current);
      throw sessionExpired();
    }
    await beforeRotate?.(current);

    const { token, hash } = this.refreshTokens.mint();
    const now = new Date();

    let next: AuthSession;
    try {
      next = await this.prisma.$transaction(async (tx) => {
        const created = await tx.authSession.create({
          data: {
            subjectType: current.subjectType,
            subjectId: current.subjectId,
            userRef: current.userRef,
            familyId: current.familyId,
            refreshTokenHash: hash,
            expiresAt: this.refreshExpiry(now),
            operatorId: current.operatorId,
            ip: ctx.ip,
            userAgent: ctx.userAgent,
          },
        });
        // Điều kiện `rotatedAt: null` nằm TRONG câu UPDATE, không nằm ở `if` phía
        // trên. Postgres READ COMMITTED: UPDATE thứ hai chờ khoá dòng, và khi được
        // chạy thì đánh giá lại WHERE trên phiên bản dòng mới — thấy `rotated_at`
        // đã có giá trị nên cập nhật 0 dòng. Kiểm bằng `if` thì hai request cùng lọt.
        const claimed = await tx.authSession.updateManyAndReturn({
          where: { id: current.id, rotatedAt: null, revokedAt: null },
          data: { rotatedAt: now, replacedById: created.id, lastUsedAt: now },
        });
        // PHẢI ném, không được `return null`: return là transaction COMMIT, và
        // row con vừa tạo sống sót thành một refresh token hợp lệ thứ hai.
        if (claimed.length === 0) throw new LostRotationRace();
        return created;
      });
    } catch (error) {
      if (error instanceof LostRotationRace) {
        await this.handleReuse(current);
        throw sessionExpired();
      }
      throw error;
    }

    this.recordEvent(
      subjectEvent(next, "auth.session.rotated", {
        after: { previousSessionId: current.id, familyId: next.familyId },
      }),
    );
    return { session: next, refreshToken: token };
  }

  /**
   * Hot path của guard: phiên của access token còn sống không. Cache-aside — Redis trả lời được thì
   * không chạm Postgres; miss thì hỏi Postgres rồi ghi lại. Cache được ghi LÚC MISS chứ không phải
   * lúc login/refresh: ghi lúc refresh mà Redis lỗi SAU KHI Postgres đã rotate thì client mất refresh
   * token mới, lần sau gửi token cũ bị coi là reuse và bị đá ra oan.
   */
  async assertActive(sid: string): Promise<void> {
    const cached = await this.cache.lookup(sid);
    if (cached === "revoked") {
      throw sessionExpired();
    }
    if (cached === "active") {
      return;
    }
    const session = await this.prisma.authSession.findUnique({
      where: { id: sid },
      select: { revokedAt: true },
    });
    if (!session || session.revokedAt) {
      throw sessionExpired();
    }
    await this.cache.markActive(sid);
  }

  async findById(sid: string): Promise<AuthSession | null> {
    return this.prisma.authSession.findUnique({ where: { id: sid } });
  }

  /**
   * Logout = thu hồi cả family của lần đăng nhập này. Idempotent: gọi lại vẫn không lỗi. Chỉ ghi
   * audit khi thật sự thu hồi được gì — không thì mỗi lần gọi lại (access token còn 15 phút) là một
   * bản ghi append-only không xoá được.
   */
  async logout(sid: string): Promise<void> {
    const session = await this.findById(sid);
    if (!session) {
      await this.cache.markRevoked([sid]);
      return;
    }
    const revoked = await this.revokeFamily(session.familyId, SessionRevokeReason.LOGOUT);
    if (revoked > 0) {
      this.recordEvent(subjectEvent(session, "auth.logout"));
    }
  }

  /** FR-IAM-16. Tra theo `family_id` — lý do `.2` thêm index riêng cho cột này. */
  async revokeFamily(
    familyId: string,
    reason: SessionRevokeReason,
  ): Promise<number> {
    const count = await this.revoke({ familyId }, reason);
    this.recordRevoked("auth_session_family", familyId, reason, count);
    return count;
  }

  /** FR-IAM-16. Tra theo `user_ref` — dùng index `(user_ref, family_id)` của DB §7. */
  async revokeAllForSubject(
    type: SubjectType,
    id: string,
    reason: SessionRevokeReason,
  ): Promise<number> {
    const userRef = userRefOf(type, id);
    const count = await this.revoke({ userRef }, reason);
    this.recordRevoked("auth_subject", userRef, reason, count);
    return count;
  }

  async grantReauth(sid: string): Promise<void> {
    await this.cache.grantReauth(sid);
  }

  async hasRecentReauth(sid: string): Promise<boolean> {
    return this.cache.hasReauth(sid);
  }

  /**
   * Audit best-effort và KHÔNG chờ: Mongo chết hoặc CHẬM không được làm hỏng hay kéo dài
   * refresh/logout. Chờ ở đây thì refresh treo tới ~10 giây (timeout chọn server của Mongoose) SAU
   * KHI token cũ đã bị tiêu — client bỏ cuộc, gửi lại token cũ và bị coi là reuse, cả family chết oan.
   * `requestId`/`traceId` được đọc đồng bộ ngay lúc gọi nên không mất ngữ cảnh.
   */
  recordEvent(event: AuditEventInput): void {
    this.audit.recordAuditEvent(event).catch((error: unknown) => {
      this.logger.error(`Ghi audit ${event.action} thất bại: ${String(error)}`);
    });
  }

  /**
   * Thứ tự có chủ ý:
   *
   * 1. **Redis trước Postgres.** Redis lỗi thì dừng khi Postgres chưa đổi gì — lần gọi lại chạy lại
   *    trọn vẹn. Làm ngược lại thì Postgres đã revoke, `rotate` từ chối token sớm và không bao giờ
   *    ghi lại khoá Redis: cache `session:{sid}` "active" cũ tiếp tục cho access token đi qua.
   * 2. **UPDATE lặp tới khi 0 row.** READ COMMITTED: một `rotate` đang giữ khoá row cha khiến UPDATE
   *    của ta chờ, nhưng row con nó vừa INSERT commit SAU snapshot của ta nên bị bỏ sót — kẻ trộm
   *    đang refresh sẽ giữ được một token sống. Câu UPDATE sau có snapshot mới và bắt được row con.
   *    Dừng khi một câu UPDATE đổi 0 row: nếu còn `rotate` nào đang giữ khoá một row chưa revoke,
   *    câu đó đã phải chờ nó và đổi ít nhất một row.
   * 3. **Đánh dấu Redis lần nữa** cho các row con vừa bắt được (access token của chúng mới được ký).
   */
  private async revoke(target: RevokeTarget, reason: SessionRevokeReason): Promise<number> {
    await this.blockLiveAccessTokens(target);
    let total = 0;
    for (let round = 0; round < MAX_REVOKE_ROUNDS; round++) {
      const { count } = await this.prisma.authSession.updateMany({
        where: { ...target, revokedAt: null },
        data: { revokedAt: new Date(), revokedReason: reason },
      });
      total += count;
      if (count === 0) {
        break;
      }
    }
    if (total > 0) {
      await this.blockLiveAccessTokens(target);
    }
    return total;
  }

  /**
   * Revoke trong Postgres không giết được access token đang còn hạn (JWT stateless) — phải đánh dấu
   * trên Redis. Chỉ phiên phát trong một TTL access gần nhất mới còn access token sống, nên chỉ đánh
   * dấu những phiên đó (một family 30 ngày có thể có hàng nghìn row đã rotate). Chọn theo mốc thời
   * gian chứ KHÔNG theo "row vừa đổi": gọi lại sau khi Redis lỗi thì updateMany trả 0 row, nhưng khoá
   * Redis vẫn phải được ghi.
   */
  private async blockLiveAccessTokens(where: RevokeTarget): Promise<void> {
    const cutoff = new Date(
      Date.now() -
        (this.config.JWT_ACCESS_TTL_SECONDS + ACCESS_TOKEN_SKEW_SECONDS) * 1000,
    );
    const live = await this.prisma.authSession.findMany({
      where: { ...where, issuedAt: { gte: cutoff } },
      select: { id: true },
    });
    await this.cache.markRevoked(live.map((session) => session.id));
  }

  private recordRevoked(
    targetType: string,
    targetId: string,
    reason: SessionRevokeReason,
    count: number,
  ): void {
    if (count === 0) {
      return;
    }
    this.recordEvent({
      action: "auth.session.revoked",
      targetType,
      targetId,
      reason,
      after: { count },
    });
  }

  /** Phát audit TRƯỚC khi revoke: revoke có thể 503 (Redis) và dấu vết tấn công không được mất theo. */
  private async handleReuse(session: AuthSession): Promise<void> {
    this.recordEvent(
      subjectEvent(session, "auth.token.reuse_detected", {
        reason: `family ${session.familyId}`,
      }),
    );
    await this.revokeFamily(
      session.familyId,
      SessionRevokeReason.REUSE_DETECTED,
    );
  }
}

/** Chỉ ghi id phiên/family — KHÔNG bao giờ token thô hay hash của nó. */
function subjectEvent(
  session: AuthSession,
  action: string,
  extra: Pick<AuditEventInput, "after" | "reason"> = {},
): AuditEventInput {
  return {
    actorId: session.subjectId,
    actorRole: session.subjectType,
    action,
    targetType: "auth_session",
    targetId: session.id,
    operatorId: session.operatorId ?? undefined,
    ...extra,
  };
}
