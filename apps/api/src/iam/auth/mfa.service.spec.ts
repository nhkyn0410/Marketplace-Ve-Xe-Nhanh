import { createHash, randomBytes } from "node:crypto";
import { HttpException } from "@nestjs/common";
import type Redis from "ioredis";
import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";
import type { AppConfig } from "../../config/env.config";
import type { PrismaService } from "../../database/prisma.service";
import { SubjectType } from "../../database/prisma.types";
import type { SessionService } from "../session/session.service";
import { accountLocked } from "./auth.errors";
import type { LoginHistoryService } from "./login-history.service";
import {
  hashMfaBackupCode,
  MFA_BACKUP_CODE_COUNT,
  MFA_CHALLENGE_SCRIPTS,
  MFA_CHALLENGE_TTL_SECONDS,
  MfaService,
} from "./mfa.service";
import type { OtpRateLimiter } from "./otp-rate-limiter";
import { generateTotp, sealMfaValue } from "./totp";

/**
 * Giả lập đúng ngữ nghĩa từng script Redis của MfaService (HASH `{payload, attempts}` + lease).
 * Hành vi thật của Lua được kiểm ở `mfa.int.spec.ts` trên Redis thật.
 */
function createRedisFake() {
  const values = new Map<string, { payload: string; attempts: number; expiresIn: number }>();
  const locks = new Map<string, string>();
  const evalScript = vi.fn(async (script: string, _keyCount: number, ...args: string[]) => {
    switch (script) {
      case MFA_CHALLENGE_SCRIPTS.create: {
        const [key, payload, ttl] = args as [string, string, string];
        if (values.has(key)) return 0;
        values.set(key, { payload, attempts: 0, expiresIn: Number(ttl) });
        return 1;
      }
      case MFA_CHALLENGE_SCRIPTS.claim: {
        const [key, lockKey, lockToken, , max] = args as [string, string, string, string, string];
        const stored = values.get(key);
        if (!stored) return ["MISSING"];
        if (locks.has(lockKey)) return ["BUSY"];
        locks.set(lockKey, lockToken);
        stored.attempts += 1;
        if (stored.attempts > Number(max)) {
          values.delete(key);
          locks.delete(lockKey);
          return ["LIMIT"];
        }
        return ["OK", stored.payload];
      }
      case MFA_CHALLENGE_SCRIPTS.release: {
        const [key, lockKey, lockToken, max] = args as [string, string, string, string];
        if (locks.get(lockKey) !== lockToken) return 0;
        if ((values.get(key)?.attempts ?? 0) >= Number(max)) values.delete(key);
        locks.delete(lockKey);
        return 1;
      }
      case MFA_CHALLENGE_SCRIPTS.consume: {
        const [key, lockKey, lockToken] = args as [string, string, string];
        if (locks.get(lockKey) !== lockToken) return 0;
        locks.delete(lockKey);
        return values.delete(key) ? 1 : 0;
      }
      default:
        throw new Error("script lạ");
    }
  });
  return {
    redis: { eval: evalScript } as unknown as Redis,
    evalScript,
    values,
    expireAll: () => values.clear(),
  };
}

function problemOf(error: unknown): { status: number; code?: string } {
  const exception = error as HttpException;
  return {
    status: exception.getStatus(),
    code: (exception.getResponse() as { code?: string }).code,
  };
}

async function problem(promise: Promise<unknown>): Promise<{ status: number; code?: string }> {
  try {
    await promise;
  } catch (error) {
    return problemOf(error);
  }
  throw new Error("expected rejection");
}

const INVALID = { status: 401, code: "AUTH_INVALID_CREDENTIALS" };
const UNAVAILABLE = { status: 503, code: "SERVICE_UNAVAILABLE" };
const ctx = { ip: "1.2.3.4", userAgent: "vitest" };
const admin = { subjectType: SubjectType.PLATFORM, subjectId: "admin-1", label: "platform/admin" };
const owner = {
  subjectType: SubjectType.OPERATOR,
  subjectId: "owner-1",
  operatorId: "operator-1",
  label: "phuongtrang/owner",
};

describe("MfaService", () => {
  const now = 1_800_000_000_000;
  const encryptionKey = randomBytes(32);
  const config = {
    NODE_ENV: "test",
    BETTER_AUTH_SECRET: "stable-test-secret",
    MFA_ENCRYPTION_KEY: encryptionKey.toString("base64"),
  } as AppConfig;
  const credentialFindUnique = vi.fn();
  const credentialCreate = vi.fn();
  const credentialUpdateMany = vi.fn();
  const backupFindUnique = vi.fn();
  const backupUpdateMany = vi.fn();
  const tx = {
    mfaCredential: {
      findUnique: credentialFindUnique,
      create: credentialCreate,
      updateMany: credentialUpdateMany,
    },
    mfaBackupCode: {
      findUnique: backupFindUnique,
      updateMany: backupUpdateMany,
    },
  };
  // Bảng MFA chỉ mở cho ngữ cảnh system (RLS) → MfaService KHÔNG được gọi thẳng `prisma.mfa*`.
  const withSystem = vi.fn((work: (client: typeof tx) => Promise<unknown>) => work(tx));
  const prisma = { withSystem } as unknown as PrismaService;
  const recordEvent = vi.fn();
  const sessions = { recordEvent } as unknown as SessionService;
  const limiter = {
    assertMfaNotLocked: vi.fn(),
    recordMfaFailure: vi.fn(),
    clearMfaFailures: vi.fn(),
  };
  const loginHistory = { record: vi.fn() };
  const precheck = vi.fn();
  let redisFake: ReturnType<typeof createRedisFake>;
  let service: MfaService;

  /** Credential đã enroll với secret cho trước — AAD khoá vào đúng chủ thể như code thật. */
  function enrolledCredential(secret: string, subject: { subjectType: SubjectType; subjectId: string } = admin) {
    return {
      id: "mfa-1",
      secretCiphertext: sealMfaValue(secret, encryptionKey, `mfa-secret:${subject.subjectType}:${subject.subjectId}`),
      lastTotpCounter: null,
    };
  }

  function createService(serviceConfig: AppConfig = config): MfaService {
    return new MfaService(
      serviceConfig,
      prisma,
      redisFake.redis,
      sessions,
      limiter as unknown as OtpRateLimiter,
      loginHistory as unknown as LoginHistoryService,
    );
  }

  const verify = (token: string, code: string) => service.verifyChallenge(token, code, ctx, precheck);
  const secretOf = (uri: string | undefined) => new URL(uri!).searchParams.get("secret")!;

  beforeEach(() => {
    vi.useFakeTimers({ toFake: ["Date"] });
    vi.setSystemTime(now);
    vi.clearAllMocks();
    credentialFindUnique.mockResolvedValue(null);
    credentialCreate.mockResolvedValue({ id: "mfa-1" });
    credentialUpdateMany.mockResolvedValue({ count: 1 });
    backupFindUnique.mockResolvedValue(null);
    backupUpdateMany.mockResolvedValue({ count: 1 });
    limiter.assertMfaNotLocked.mockResolvedValue(undefined);
    limiter.recordMfaFailure.mockResolvedValue(undefined);
    limiter.clearMfaFailures.mockResolvedValue(undefined);
    loginHistory.record.mockResolvedValue(undefined);
    precheck.mockResolvedValue("checked-owner");
    redisFake = createRedisFake();
    service = createService();
  });

  afterEach(() => vi.useRealTimers());

  it("enrolls with a sealed Redis payload and exactly ten one-time backup codes", async () => {
    const started = await service.begin(owner, ctx);
    expect(started).toMatchObject({
      mfaRequired: true,
      enrollmentRequired: true,
      challengeExpiresIn: MFA_CHALLENGE_TTL_SECONDS,
    });
    const secret = secretOf(started.otpAuthUri);
    const [storedKey, stored] = [...redisFake.values.entries()][0]!;
    expect(stored.expiresIn).toBe(300);
    expect(stored.payload).not.toContain(secret);
    expect(stored.payload).not.toContain("owner-1");
    expect(storedKey).not.toContain(started.challengeToken);
    // Key = SHA-256 của token; hash tag `{…}` để challenge và lock cùng slot trên Redis Cluster.
    const hash = createHash("sha256").update(started.challengeToken).digest("hex");
    expect(storedKey).toBe(`mfa:challenge:{${hash}}`);
    // Enrollment chưa proof → CHƯA ghi gì vào Postgres.
    expect(credentialCreate).not.toHaveBeenCalled();
    expect(recordEvent).toHaveBeenCalledWith(
      expect.objectContaining({ action: "auth.mfa.challenge_issued", after: ctx }),
    );

    const verified = await verify(started.challengeToken, generateTotp(secret, { timestampMs: now }));

    expect(verified).toMatchObject({
      subjectType: SubjectType.OPERATOR,
      subjectId: "owner-1",
      operatorId: "operator-1",
      enrolled: true,
      method: "totp",
      checked: "checked-owner",
    });
    expect(precheck).toHaveBeenCalledWith({
      subjectType: SubjectType.OPERATOR,
      subjectId: "owner-1",
      operatorId: "operator-1",
    });
    expect(verified.backupCodes).toHaveLength(MFA_BACKUP_CODE_COUNT);
    expect(new Set(verified.backupCodes).size).toBe(MFA_BACKUP_CODE_COUNT);

    const createInput = credentialCreate.mock.calls[0]![0].data;
    expect(createInput.secretCiphertext).not.toContain(secret);
    expect(createInput.backupCodes.create).toEqual(
      verified.backupCodes!.map((code) => ({ codeHash: hashMfaBackupCode(code) })),
    );
    const persisted = JSON.stringify(createInput, (_key, value: unknown) =>
      typeof value === "bigint" ? value.toString() : value,
    );
    for (const code of verified.backupCodes!) {
      expect(persisted).not.toContain(code);
    }
    expect(redisFake.values.size).toBe(0);
    expect(withSystem).toHaveBeenCalled();
    expect(limiter.clearMfaFailures).toHaveBeenCalledWith("operator:owner-1");
    const audit = JSON.stringify(recordEvent.mock.calls);
    expect(audit).not.toContain(secret);
    expect(audit).not.toContain(verified.backupCodes![0]!);
  });

  it("enrollment: TOTP sai không ghi Postgres, đếm vào trần lần sai + lịch sử đăng nhập có IP", async () => {
    const started = await service.begin(admin, ctx);
    const secret = secretOf(started.otpAuthUri);
    const wrong = generateTotp(secret, { timestampMs: now + 10 * 30_000 });

    expect(await problem(verify(started.challengeToken, wrong))).toEqual(INVALID);
    expect(credentialCreate).not.toHaveBeenCalled();
    expect(redisFake.values.size).toBe(1);
    expect(limiter.recordMfaFailure).toHaveBeenCalledWith("platform:admin-1");
    expect(loginHistory.record).toHaveBeenCalledWith(
      expect.objectContaining({ result: "failure", reason: "mfa_invalid", targetId: "admin-1", ...ctx }),
    );

    await expect(verify(started.challengeToken, generateTotp(secret, { timestampMs: now }))).resolves.toMatchObject({
      enrolled: true,
    });
  });

  it("hai enrollment song song của cùng account: bản thứ hai đụng unique → 401, không ghi đè secret", async () => {
    const started = await service.begin(admin, ctx);
    credentialCreate.mockRejectedValueOnce(Object.assign(new Error("unique"), { code: "P2002" }));

    expect(
      await problem(verify(started.challengeToken, generateTotp(secretOf(started.otpAuthUri), { timestampMs: now }))),
    ).toEqual(INVALID);
  });

  it("challenge hết hạn và lần sai thứ 5 → cùng 401 generic", async () => {
    const expired = await service.begin(admin, ctx);
    redisFake.expireAll();
    expect(await problem(verify(expired.challengeToken, "000000"))).toEqual(INVALID);

    const limited = await service.begin(admin, ctx);
    for (let attempt = 0; attempt < 5; attempt += 1) {
      expect(await problem(verify(limited.challengeToken, "000000"))).toEqual(INVALID);
    }
    expect(redisFake.values.size).toBe(0);
    expect(await problem(verify(limited.challengeToken, "000000"))).toEqual(INVALID);
    expect(credentialCreate).not.toHaveBeenCalled();
  });

  it("⭐ payload bị sửa / ghép sang token khác (ai đó ghi được Redis) → 401, không bao giờ tới precheck", async () => {
    const victim = await service.begin(owner, ctx);
    const attacker = await service.begin(admin, ctx);
    const [victimKey, attackerKey] = [...redisFake.values.keys()] as [string, string];
    // Ghép payload hợp lệ của challenge kia vào key này: AAD gắn hash token nên không mở được.
    redisFake.values.get(victimKey)!.payload = redisFake.values.get(attackerKey)!.payload;
    expect(await problem(verify(victim.challengeToken, "000000"))).toEqual(INVALID);
    expect(await problem(verify(attacker.challengeToken, "000000"))).toEqual(INVALID);

    // Tự dựng payload JSON trần (không có key): không mở được.
    const forged = await service.begin(admin, ctx);
    const forgedKey = [...redisFake.values.keys()].at(-1)!;
    redisFake.values.get(forgedKey)!.payload = JSON.stringify({
      version: 1,
      subjectType: "PLATFORM",
      subjectId: "victim",
      enrollmentRequired: false,
    });
    expect(await problem(verify(forged.challengeToken, "000000"))).toEqual(INVALID);
    expect(precheck).not.toHaveBeenCalled();
    expect(credentialFindUnique).toHaveBeenCalledTimes(3); // chỉ ba lần `begin`; verify không đọc DB
  });

  it("secret khoá vào chủ thể: ciphertext của account khác không dùng được", async () => {
    const secret = "GEZDGNBVGY3TQOJQGEZDGNBVGY3TQOJQ";
    credentialFindUnique.mockResolvedValue(enrolledCredential(secret, owner));
    const started = await service.begin(admin, ctx); // credential của admin mang secret khoá cho owner

    await expect(verify(started.challengeToken, generateTotp(secret, { timestampMs: now }))).rejects.toThrow();
    expect(credentialUpdateMany).not.toHaveBeenCalled();
  });

  it("consumes one challenge once and uses a DB CAS to stop concurrent TOTP replay", async () => {
    const secret = "GEZDGNBVGY3TQOJQGEZDGNBVGY3TQOJQ";
    credentialFindUnique.mockResolvedValue(enrolledCredential(secret));
    credentialUpdateMany.mockResolvedValueOnce({ count: 1 }).mockResolvedValueOnce({ count: 0 });
    const first = await service.begin(admin, ctx);
    const second = await service.begin(admin, ctx);
    const code = generateTotp(secret, { timestampMs: now });

    await expect(verify(first.challengeToken, code)).resolves.toMatchObject({ method: "totp", enrolled: false });
    expect(await problem(verify(first.challengeToken, code))).toEqual(INVALID);
    expect(await problem(verify(second.challengeToken, code))).toEqual(INVALID);
    expect(credentialUpdateMany).toHaveBeenCalledTimes(2);
    // CAS: chỉ ghi khi counter mới LỚN HƠN counter đã dùng — chốt chống replay đồng thời.
    expect(credentialUpdateMany.mock.calls[0]![0].where).toEqual({
      id: "mfa-1",
      OR: [{ lastTotpCounter: null }, { lastTotpCounter: { lt: BigInt(now / 30_000) } }],
    });
  });

  it("TOTP dạng `123 456` (như app hiển thị) vẫn được chấp nhận", async () => {
    const secret = "GEZDGNBVGY3TQOJQGEZDGNBVGY3TQOJQ";
    credentialFindUnique.mockResolvedValue(enrolledCredential(secret));
    const started = await service.begin(admin, ctx);
    const code = generateTotp(secret, { timestampMs: now });

    await expect(verify(started.challengeToken, `${code.slice(0, 3)} ${code.slice(3)}`)).resolves.toMatchObject({
      method: "totp",
    });
  });

  it("consumes a backup code atomically only once", async () => {
    credentialFindUnique.mockResolvedValue(enrolledCredential("JBSWY3DPEHPK3PXP", owner));
    backupFindUnique.mockResolvedValue({ id: "backup-1", usedAt: null });
    backupUpdateMany.mockResolvedValueOnce({ count: 1 }).mockResolvedValueOnce({ count: 0 });
    const first = await service.begin(owner, ctx);
    const second = await service.begin(owner, ctx);
    const backupCode = "10203-40506-70809-A0B0C";

    await expect(verify(first.challengeToken, backupCode)).resolves.toMatchObject({ method: "backup_code" });
    expect(await problem(verify(second.challengeToken, backupCode))).toEqual(INVALID);
    expect(backupUpdateMany).toHaveBeenCalledWith({
      where: { id: "backup-1", credentialId: "mfa-1", usedAt: null },
      data: { usedAt: expect.any(Date) },
    });
    expect(recordEvent).toHaveBeenCalledWith(expect.objectContaining({ action: "auth.mfa.backup_code_used" }));
  });

  it("⭐ precheck từ chối (account bị khoá) → proof KHÔNG bị tiêu, challenge chết, lỗi của precheck đi ra", async () => {
    credentialFindUnique.mockResolvedValue(enrolledCredential("JBSWY3DPEHPK3PXP"));
    backupFindUnique.mockResolvedValue({ id: "backup-1", usedAt: null });
    precheck.mockRejectedValueOnce(accountLocked());
    const started = await service.begin(admin, ctx);

    expect(await problem(verify(started.challengeToken, "10203-40506-70809-A0B0C"))).toMatchObject({ status: 403 });
    expect(backupUpdateMany).not.toHaveBeenCalled();
    expect(redisFake.values.size).toBe(0);

    // Enrollment: account bị khoá thì secret (có thể của kẻ tấn công) không được lưu.
    credentialFindUnique.mockResolvedValue(null);
    precheck.mockRejectedValueOnce(accountLocked());
    const enrolling = await service.begin(admin, ctx);
    const code = generateTotp(secretOf(enrolling.otpAuthUri), { timestampMs: now });
    expect(await problem(verify(enrolling.challengeToken, code))).toMatchObject({ status: 403 });
    expect(credentialCreate).not.toHaveBeenCalled();
  });

  it("⭐ chủ thể đã chạm trần lần sai → lỗi của limiter (429) kể cả mã đúng, challenge bị huỷ", async () => {
    const secret = "GEZDGNBVGY3TQOJQGEZDGNBVGY3TQOJQ";
    credentialFindUnique.mockResolvedValue(enrolledCredential(secret));
    const started = await service.begin(admin, ctx);
    limiter.assertMfaNotLocked.mockRejectedValueOnce(new HttpException({ code: "AUTH_LOGIN_RATE_LIMITED" }, 429));

    expect(await problem(verify(started.challengeToken, generateTotp(secret, { timestampMs: now })))).toEqual({
      status: 429,
      code: "AUTH_LOGIN_RATE_LIMITED",
    });
    expect(limiter.assertMfaNotLocked).toHaveBeenCalledWith("platform:admin-1");
    expect(credentialUpdateMany).not.toHaveBeenCalled();
    expect(redisFake.values.size).toBe(0);
    // Chạm trần phải để lại audit (dấu hiệu lộ mật khẩu), không chỉ log.
    expect(recordEvent).toHaveBeenCalledWith(expect.objectContaining({ action: "auth.mfa.locked", after: ctx }));
  });

  it.each(["create", "claim", "release", "consume"] as const)(
    "Redis lỗi ở script `%s` → 503 fail-closed, không ghi gì vào Postgres",
    async (failing) => {
      const secret = "GEZDGNBVGY3TQOJQGEZDGNBVGY3TQOJQ";
      credentialFindUnique.mockResolvedValue(enrolledCredential(secret));
      const passthrough = redisFake.evalScript.getMockImplementation()!;
      redisFake.evalScript.mockImplementation(async (script: string, keyCount: number, ...args: string[]) => {
        if (script === MFA_CHALLENGE_SCRIPTS[failing]) {
          throw new Error("ECONNRESET");
        }
        return passthrough(script, keyCount, ...args);
      });

      if (failing === "create") {
        expect(await problem(service.begin(admin, ctx))).toEqual(UNAVAILABLE);
        return;
      }
      const started = await service.begin(admin, ctx);
      const code = failing === "release" ? "000000" : generateTotp(secret, { timestampMs: now });
      expect(await problem(verify(started.challengeToken, code))).toEqual(UNAVAILABLE);
      expect(credentialUpdateMany).not.toHaveBeenCalled();
      expect(credentialCreate).not.toHaveBeenCalled();
    },
  );

  it("re-auth dùng cùng proof atomic, bộ đếm lần sai RIÊNG với login; audit mang tenant + IP; replay → null", async () => {
    const secret = "GEZDGNBVGY3TQOJQGEZDGNBVGY3TQOJQ";
    credentialFindUnique.mockResolvedValue(enrolledCredential(secret, owner));
    credentialUpdateMany.mockResolvedValueOnce({ count: 1 }).mockResolvedValueOnce({ count: 0 });
    const subject = { subjectType: owner.subjectType, subjectId: owner.subjectId, operatorId: owner.operatorId };
    const code = generateTotp(secret, { timestampMs: now });

    await expect(service.verifyForSubject(subject, code, ctx)).resolves.toBe("totp");
    await expect(service.verifyForSubject(subject, code, ctx)).resolves.toBeNull();
    await expect(service.verifyForSubject(subject, "000000", ctx)).resolves.toBeNull();
    // Phiên bị đánh cắp cố ý sai re-auth không được khoá luôn đường login MFA của chủ account.
    expect(limiter.assertMfaNotLocked).toHaveBeenCalledWith("reauth:operator:owner-1");
    expect(limiter.recordMfaFailure).toHaveBeenCalledTimes(1);
    expect(limiter.recordMfaFailure).toHaveBeenCalledWith("reauth:operator:owner-1");
    expect(limiter.clearMfaFailures).toHaveBeenCalledWith("reauth:operator:owner-1");
    expect(recordEvent).toHaveBeenCalledWith(
      expect.objectContaining({ action: "auth.mfa.verified", operatorId: "operator-1", after: ctx }),
    );
  });

  it("rejects a missing production encryption key at startup", () => {
    expect(() => createService({ NODE_ENV: "production" } as AppConfig)).toThrow(/MFA_ENCRYPTION_KEY/);
  });
});
