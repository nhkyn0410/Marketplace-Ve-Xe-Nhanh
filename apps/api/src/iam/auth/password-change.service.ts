import { createHash, randomBytes } from "node:crypto";
import { Inject, Injectable, Logger } from "@nestjs/common";
import type Redis from "ioredis";
import { AuditService } from "../../audit/audit.service";
import { APP_CONFIG, type AppConfig } from "../../config/env.config";
import { PrismaService } from "../../database/prisma.service";
import { SessionRevokeReason, SubjectType } from "../../database/prisma.types";
import { REDIS_CLIENT } from "../../redis/redis.config";
import { userRefOf } from "../session/subject-type";
import { SessionService } from "../session/session.service";
import { serviceUnavailable } from "./auth.errors";
import {
  invalidPasswordChangeToken,
  passwordReuseForbidden
} from "./auth.errors";
import { CredentialService } from "./credential.service";
import { resolveEncryptionKey } from "./mfa.service";
import { OtpRateLimiter } from "./otp-rate-limiter";
import type { RequestContext } from "./auth.service";
import { openMfaValue, sealMfaValue } from "./totp";

export const PASSWORD_CHANGE_CHALLENGE_TTL_SECONDS = 5 * 60;

/** `operatorId` có với Operator / Employee, `null` với tài khoản quản trị (PLATFORM). */
export type PasswordChangePrincipal =
  | { subjectType: Extract<SubjectType, "OPERATOR" | "EMPLOYEE">; subjectId: string; operatorId: string; authEpoch: number }
  | { subjectType: Extract<SubjectType, "PLATFORM">; subjectId: string; operatorId: null; authEpoch: number };

export type PasswordChangeChallenge = {
  passwordChangeRequired: true;
  passwordChangeToken: string;
  passwordChangeExpiresIn: number;
};

type StoredChallenge = PasswordChangePrincipal & { version: 2 };

type PasswordAccount = {
  id: string;
  status: string;
  passwordHash: string;
  authEpoch: number;
  credentialDeliveryPending: boolean;
  passwordChangeRequired: boolean;
  temporaryPasswordExpiresAt: Date | null;
  /** Trạng thái nhà xe; tài khoản quản trị không thuộc nhà xe nào → luôn `ACTIVE`. */
  operator: { status: string };
};

const CONSUME_SCRIPT = `
local payload = redis.call('GET', KEYS[1])
if not payload then return false end
redis.call('DEL', KEYS[1])
return payload
`;

/** Pre-auth đổi mật khẩu tạm: token one-time, chưa tạo session và chưa đi qua MFA. */
@Injectable()
export class PasswordChangeService {
  private readonly logger = new Logger(PasswordChangeService.name);
  private readonly encryptionKey: Buffer;

  constructor(
    @Inject(APP_CONFIG) config: AppConfig,
    @Inject(REDIS_CLIENT) private readonly redis: Redis,
    private readonly prisma: PrismaService,
    private readonly credentials: CredentialService,
    private readonly sessions: SessionService,
    private readonly limiter: OtpRateLimiter,
    private readonly audit: AuditService
  ) {
    this.encryptionKey = resolveEncryptionKey(config);
  }

  async begin(principal: PasswordChangePrincipal): Promise<PasswordChangeChallenge> {
    const passwordChangeToken = randomBytes(32).toString("base64url");
    const tokenHash = hashToken(passwordChangeToken);
    const payload = sealMfaValue(
      JSON.stringify({ version: 2, ...principal } satisfies StoredChallenge),
      this.encryptionKey,
      challengeContext(tokenHash)
    );

    let created: unknown;
    try {
      created = await this.redis.set(
        challengeKey(tokenHash),
        payload,
        "EX",
        PASSWORD_CHANGE_CHALLENGE_TTL_SECONDS,
        "NX"
      );
    } catch {
      throw serviceUnavailable();
    }
    if (created !== "OK") {
      throw serviceUnavailable();
    }
    return {
      passwordChangeRequired: true,
      passwordChangeToken,
      passwordChangeExpiresIn: PASSWORD_CHANGE_CHALLENGE_TTL_SECONDS
    };
  }

  async changeRequiredPassword(
    passwordChangeToken: string,
    newPassword: string,
    ctx: RequestContext
  ): Promise<void> {
    const challenge = await this.consume(passwordChangeToken);
    const account = await this.loadAccount(challenge);
    if (
      !account ||
      account.authEpoch !== challenge.authEpoch ||
      account.credentialDeliveryPending ||
      !account.passwordChangeRequired ||
      !account.temporaryPasswordExpiresAt ||
      account.temporaryPasswordExpiresAt <= new Date() ||
      account.status !== "ACTIVE" ||
      account.operator.status !== "ACTIVE"
    ) {
      throw invalidPasswordChangeToken();
    }
    if (await this.credentials.verify(newPassword, account.passwordHash)) {
      throw passwordReuseForbidden();
    }

    const passwordHash = await this.credentials.hash(newPassword);
    await this.audit.recordAuditEvent({
      actorId: challenge.subjectId,
      action: "auth.password_change.intent",
      targetType: subjectTarget(challenge.subjectType),
      targetId: challenge.subjectId,
      operatorId: challenge.operatorId ?? undefined,
      reason: "first_login",
      after: auditContext(ctx)
    });

    await this.sessions.revokeAllForSubject(
      challenge.subjectType,
      challenge.subjectId,
      SessionRevokeReason.PASSWORD_RESET
    );

    const count = await this.updatePassword(challenge, account.passwordHash, passwordHash);
    if (count.count !== 1) {
      throw invalidPasswordChangeToken();
    }

    // Bắt phiên được tạo trong cửa sổ giữa lần revoke đầu và khi passwordHash đổi. Phần account
    // mutation khác cũng quét hai lần theo cùng mẫu; lỗi ở đây phải fail-closed, không báo đổi xong.
    await this.sessions.revokeAllForSubject(
      challenge.subjectType,
      challenge.subjectId,
      SessionRevokeReason.PASSWORD_RESET
    );

    await this.limiter.clearMfaFailures(userRefOf(challenge.subjectType, challenge.subjectId));
    void this.audit
      .recordAuditEvent({
        actorId: challenge.subjectId,
        action: "auth.password_changed",
        targetType: subjectTarget(challenge.subjectType),
        targetId: challenge.subjectId,
        operatorId: challenge.operatorId ?? undefined,
        reason: "first_login",
        after: { passwordChangeRequired: false, ...auditContext(ctx) }
      })
      .catch((error: unknown) =>
        this.logger.error({ event: "audit.write_failed", action: "auth.password_changed", error })
      );
  }

  /** Đổi hash có điều kiện (đúng epoch / hash cũ / còn hạn mật khẩu tạm) — 0 dòng = trạng thái đã đổi. */
  private updatePassword(
    challenge: StoredChallenge,
    oldHash: string,
    passwordHash: string
  ): Promise<{ count: number }> {
    const guard = {
      id: challenge.subjectId,
      authEpoch: challenge.authEpoch,
      status: "ACTIVE" as const,
      credentialDeliveryPending: false,
      passwordHash: oldHash,
      passwordChangeRequired: true,
      temporaryPasswordExpiresAt: { gt: new Date() }
    };
    const data = {
      passwordHash,
      authEpoch: { increment: 1 },
      passwordChangeRequired: false,
      temporaryPasswordExpiresAt: null
    };
    if (challenge.subjectType === SubjectType.PLATFORM) {
      // `platform_accounts` không có RLS / tenant — ngữ cảnh system của IAM.
      return this.prisma.withSystem((tx) => tx.platformAccount.updateMany({ where: guard, data }));
    }
    const operatorId = challenge.operatorId;
    return this.prisma.withTenant(operatorId, (tx) => {
      const where = { ...guard, operatorId, operator: { status: "ACTIVE" as const } };
      const tenantData = { ...data, version: { increment: 1 } };
      return challenge.subjectType === SubjectType.OPERATOR
        ? tx.operatorAccount.updateMany({ where, data: tenantData })
        : tx.employeeAccount.updateMany({ where, data: tenantData });
    });
  }

  private async consume(token: string): Promise<StoredChallenge> {
    const tokenHash = hashToken(token);
    let sealed: unknown;
    try {
      sealed = await this.redis.eval(CONSUME_SCRIPT, 1, challengeKey(tokenHash));
    } catch {
      throw serviceUnavailable();
    }
    if (typeof sealed !== "string") {
      throw invalidPasswordChangeToken();
    }
    try {
      const parsed = JSON.parse(
        openMfaValue(sealed, this.encryptionKey, challengeContext(tokenHash))
      ) as Partial<StoredChallenge>;
      if (
        parsed.version !== 2 ||
        typeof parsed.subjectId !== "string" ||
        !(
          ((parsed.subjectType === SubjectType.OPERATOR || parsed.subjectType === SubjectType.EMPLOYEE) &&
            typeof parsed.operatorId === "string") ||
          (parsed.subjectType === SubjectType.PLATFORM && parsed.operatorId === null)
        ) ||
        !Number.isSafeInteger(parsed.authEpoch) ||
        parsed.authEpoch! < 0
      ) {
        throw new Error("invalid payload");
      }
      return parsed as StoredChallenge;
    } catch {
      throw invalidPasswordChangeToken();
    }
  }

  private async loadAccount(challenge: StoredChallenge): Promise<PasswordAccount | null> {
    if (challenge.subjectType === SubjectType.PLATFORM) {
      const account = await this.prisma.withSystem((tx) =>
        tx.platformAccount.findUnique({
          where: { id: challenge.subjectId },
          select: {
            id: true,
            status: true,
            passwordHash: true,
            authEpoch: true,
            credentialDeliveryPending: true,
            passwordChangeRequired: true,
            temporaryPasswordExpiresAt: true
          }
        })
      );
      return account ? { ...account, status: String(account.status), operator: { status: "ACTIVE" } } : null;
    }
    const operatorId = challenge.operatorId;
    const select = {
      id: true,
      status: true,
      passwordHash: true,
      authEpoch: true,
      credentialDeliveryPending: true,
      passwordChangeRequired: true,
      temporaryPasswordExpiresAt: true,
      operator: { select: { status: true } }
    } as const;
    return this.prisma.withTenant<PasswordAccount | null>(operatorId, async (tx) => {
      if (challenge.subjectType === SubjectType.OPERATOR) {
        return tx.operatorAccount.findFirst({ where: { id: challenge.subjectId, operatorId }, select });
      }
      return tx.employeeAccount.findFirst({ where: { id: challenge.subjectId, operatorId }, select });
    });
  }
}

function hashToken(token: string): string {
  return createHash("sha256").update(token, "utf8").digest("hex");
}

function challengeKey(tokenHash: string): string {
  return `password-change:${tokenHash}`;
}

function challengeContext(tokenHash: string): string {
  return `password-change-challenge:${tokenHash}`;
}

function subjectTarget(subjectType: SubjectType): string {
  if (subjectType === SubjectType.PLATFORM) {
    return "platform_account";
  }
  return subjectType === SubjectType.OPERATOR ? "operator_account" : "employee_account";
}

function auditContext(ctx: RequestContext): Record<string, string> {
  const result: Record<string, string> = {};
  if (ctx.ip) {
    result.ip = maskIp(ctx.ip);
  }
  if (ctx.userAgent) {
    result.device = /android|iphone|mobile/i.test(ctx.userAgent) ? "mobile" : "web";
  }
  return result;
}

function maskIp(ip: string): string {
  if (ip.includes(":")) {
    return `${ip.split(":").slice(0, 4).join(":")}::/64`;
  }
  const parts = ip.split(".");
  return parts.length === 4 ? `${parts[0]}.${parts[1]}.${parts[2]}.0/24` : "masked";
}
