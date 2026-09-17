import { randomUUID } from "node:crypto";
import { AuditService } from "../../audit/audit.service";
import { PrismaService } from "../../database/prisma.service";
import {
  type AuthSession,
  SessionRevokeReason,
  type SubjectType,
} from "../../database/prisma.types";
import type { RequestContext } from "../auth/auth.service";
import { RefreshTokenService } from "./refresh-token.service";
import { Inject, Injectable } from "@nestjs/common";
import { APP_CONFIG, type AppConfig } from "../../config/env.config";
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

@Injectable()
export class SessionService {
  constructor(
    @Inject(APP_CONFIG) private readonly config: AppConfig,
    private readonly prisma: PrismaService,
    private readonly refreshTokens: RefreshTokenService,
    private readonly audit: AuditService,
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
    return { session, refreshToken: token };
  }

  async rotate(rawToken: string, ctx: RequestContext): Promise<IssuedSession> {
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

    const { token, hash } = this.refreshTokens.mint();
    const now = new Date();

    try {
      const next = await this.prisma.$transaction(async (tx) => {
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
      return { session: next, refreshToken: token };
    } catch (error) {
      if (error instanceof LostRotationRace) {
        await this.handleReuse(current);
        throw sessionExpired();
      }
      throw error;
    }
  }

  async revokeSession(sid: string, reason: SessionRevokeReason): Promise<void> {
    await this.prisma.authSession.updateMany({
      where: { id: sid, revokedAt: null },
      data: { revokedAt: new Date(), revokedReason: reason },
    });
  }

  /** FR-IAM-16. Tra theo `family_id` — lý do `.2` thêm index riêng cho cột này. */
  async revokeFamily(
    familyId: string,
    reason: SessionRevokeReason,
  ): Promise<number> {
    const { count } = await this.prisma.authSession.updateMany({
      where: { familyId, revokedAt: null },
      data: { revokedAt: new Date(), revokedReason: reason },
    });
    return count;
  }
  /** FR-IAM-16. Tra theo `user_ref` — dùng index `(user_ref, family_id)` của DB §7. */
  async revokeAllForSubject(
    type: SubjectType,
    id: string,
    reason: SessionRevokeReason,
  ): Promise<number> {
    const { count } = await this.prisma.authSession.updateMany({
      where: { userRef: userRefOf(type, id), revokedAt: null },
      data: { revokedAt: new Date(), revokedReason: reason },
    });
    return count;
  }

  private async handleReuse(session: AuthSession): Promise<void> {
    await this.revokeFamily(
      session.familyId,
      SessionRevokeReason.REUSE_DETECTED,
    );
    await this.audit.recordAuditEvent({
      actorId: session.subjectId,
      actorRole: session.subjectType,
      action: "auth.token.reuse_detected",
      targetType: "auth_session",
      targetId: session.id,
      operatorId: session.operatorId ?? undefined,
      reason: `family ${session.familyId}`,
    });
  }
}
