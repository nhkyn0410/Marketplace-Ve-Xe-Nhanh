import { Logger, type HttpException } from "@nestjs/common";
import type { Request } from "express";
import { beforeEach, describe, expect, it, vi } from "vitest";
import { parseAppConfig } from "../../config/env.config";
import { AuthController } from "./auth.controller";
import { AuthService, type LoginResult } from "./auth.service";

function setup() {
  const auth = {
    api: {
      sendVerificationOTP: vi.fn().mockResolvedValue({}),
      signInEmailOTP: vi.fn(),
      signInSocial: vi.fn(),
      getSession: vi.fn()
    }
  };
  const prisma = {
    operatorProfile: { findUnique: vi.fn() },
    operatorAccount: { findUnique: vi.fn() },
    employeeAccount: { findUnique: vi.fn() },
    platformAccount: { findUnique: vi.fn() }
  };
  const tokens = {
    mintAccessToken: vi
      .fn()
      .mockResolvedValue({ accessToken: "tok", tokenType: "Bearer", expiresInSeconds: 900 })
  };
  const credentials = { verify: vi.fn(), hash: vi.fn() };
  const rateLimiter = {
    assertCanRequest: vi.fn().mockResolvedValue(undefined),
    assertCanAttemptLogin: vi.fn().mockResolvedValue(undefined)
  };
  const history = { record: vi.fn().mockResolvedValue(undefined) };
  const config = {
    AUTH_ALLOWED_CALLBACK_ORIGINS: ["http://localhost:3000", "vexenhanh://"]
  };

  const service = new AuthService(
    auth as never,
    config as never,
    prisma as never,
    tokens as never,
    credentials as never,
    rateLimiter as never,
    history as never
  );
  return { service, auth, config, prisma, tokens, credentials, rateLimiter, history };
}

async function statusOf(promise: Promise<unknown>): Promise<number> {
  try {
    await promise;
    return 0;
  } catch (error) {
    return (error as HttpException).getStatus();
  }
}

const ACTIVE_OPERATOR = { id: "op-1", operatorSlug: "phuongtrang", status: "ACTIVE" };
const OWNER = {
  id: "acc-1",
  operatorId: "op-1",
  operatorSlug: "phuongtrang",
  username: "owner01",
  passwordHash: "scrypt$x$y",
  role: "OPERATOR_OWNER",
  status: "ACTIVE"
};

describe("AuthService.operatorLogin", () => {
  let ctx: ReturnType<typeof setup>;
  beforeEach(() => {
    ctx = setup();
  });

  it("từ chối owner có operatorId lệch với tenant resolve theo slug (cách ly tenant)", async () => {
    // `operator_accounts.operator_slug` là bản sao denormalized. Nếu nó lệch với
    // operator_profiles (đổi slug, tenant xoá rồi tạo lại) thì tra theo slug trả về account của
    // TENANT KHÁC — phải bị từ chối, nếu không tenant bị SUSPENDED vẫn login được và claim
    // operatorId/operatorSlug trong JWT sẽ trỏ hai tenant khác nhau.
    ctx.prisma.operatorProfile.findUnique.mockResolvedValue(ACTIVE_OPERATOR);
    ctx.prisma.operatorAccount.findUnique.mockResolvedValue({ ...OWNER, operatorId: "op-KHAC" });
    ctx.prisma.employeeAccount.findUnique.mockResolvedValue(null);

    expect(await statusOf(ctx.service.operatorLogin("phuongtrang/owner01", "p", {}))).toBe(401);
    expect(ctx.tokens.mintAccessToken).not.toHaveBeenCalled();
    expect(ctx.history.record).toHaveBeenCalledWith(
      expect.objectContaining({ result: "failure", reason: "unknown_account" })
    );
  });

  it("mint claim operatorSlug từ DB chứ không phải từ input người dùng", async () => {
    ctx.prisma.operatorProfile.findUnique.mockResolvedValue(ACTIVE_OPERATOR);
    ctx.prisma.operatorAccount.findUnique.mockResolvedValue(OWNER);
    ctx.credentials.verify.mockResolvedValue(true);

    await ctx.service.operatorLogin("PhuongTrang/owner01", "p", {});

    expect(ctx.tokens.mintAccessToken).toHaveBeenCalledWith(
      expect.objectContaining({ operatorId: "op-1", operatorSlug: ACTIVE_OPERATOR.operatorSlug })
    );
  });

  it("giới hạn tần suất trước khi chạm DB hay chạy scrypt (Security §11)", async () => {
    ctx.rateLimiter.assertCanAttemptLogin.mockRejectedValue(new Error("limited"));

    await expect(
      ctx.service.operatorLogin("phuongtrang/owner01", "p", { ip: "1.2.3.4" })
    ).rejects.toThrow();
    expect(ctx.rateLimiter.assertCanAttemptLogin).toHaveBeenCalledWith(
      "phuongtrang/owner01",
      "1.2.3.4"
    );
    expect(ctx.prisma.operatorProfile.findUnique).not.toHaveBeenCalled();
    expect(ctx.credentials.verify).not.toHaveBeenCalled();
  });

  it("rejects when identifier is not operator namespace (FR-IAM-02c)", async () => {
    expect(await statusOf(ctx.service.operatorLogin("a@b.com", "p", {}))).toBe(401);
    expect(ctx.prisma.operatorProfile.findUnique).not.toHaveBeenCalled();
  });

  it("returns generic 401 when operator not found (no leak) and runs dummy verify", async () => {
    ctx.prisma.operatorProfile.findUnique.mockResolvedValue(null);
    expect(await statusOf(ctx.service.operatorLogin("phuongtrang/owner01", "p", {}))).toBe(401);
    expect(ctx.credentials.verify).toHaveBeenCalledTimes(1); // dummy hash, timing equalised
  });

  it("returns generic 401 on bad password and records failure", async () => {
    ctx.prisma.operatorProfile.findUnique.mockResolvedValue(ACTIVE_OPERATOR);
    ctx.prisma.operatorAccount.findUnique.mockResolvedValue(OWNER);
    ctx.credentials.verify.mockResolvedValue(false);

    expect(await statusOf(ctx.service.operatorLogin("phuongtrang/owner01", "bad", {}))).toBe(401);
    expect(ctx.history.record).toHaveBeenCalledWith(
      expect.objectContaining({ result: "failure", reason: "bad_password" })
    );
  });

  it("returns 403 when account is locked", async () => {
    ctx.prisma.operatorProfile.findUnique.mockResolvedValue(ACTIVE_OPERATOR);
    ctx.prisma.operatorAccount.findUnique.mockResolvedValue({ ...OWNER, status: "LOCKED" });
    ctx.credentials.verify.mockResolvedValue(true);

    expect(await statusOf(ctx.service.operatorLogin("phuongtrang/owner01", "good", {}))).toBe(403);
  });

  it("returns 403 when the tenant operator is suspended", async () => {
    ctx.prisma.operatorProfile.findUnique.mockResolvedValue({ ...ACTIVE_OPERATOR, status: "SUSPENDED" });
    ctx.prisma.operatorAccount.findUnique.mockResolvedValue(OWNER);
    ctx.credentials.verify.mockResolvedValue(true);

    expect(await statusOf(ctx.service.operatorLogin("phuongtrang/owner01", "good", {}))).toBe(403);
  });

  it("issues an operator token on success with tenant claims", async () => {
    ctx.prisma.operatorProfile.findUnique.mockResolvedValue(ACTIVE_OPERATOR);
    ctx.prisma.operatorAccount.findUnique.mockResolvedValue(OWNER);
    ctx.credentials.verify.mockResolvedValue(true);

    const result = await ctx.service.operatorLogin("phuongtrang/owner01", "good", {});
    expect(result).toMatchObject({ accessToken: "tok", scope: "operator", role: "OPERATOR_OWNER" });
    expect(ctx.tokens.mintAccessToken).toHaveBeenCalledWith(
      expect.objectContaining({ sub: "acc-1", scope: "operator", operatorId: "op-1", operatorSlug: "phuongtrang" })
    );
    expect(ctx.history.record).toHaveBeenCalledWith(expect.objectContaining({ result: "success" }));
  });

  it("falls back to employee_accounts when not an owner", async () => {
    ctx.prisma.operatorProfile.findUnique.mockResolvedValue(ACTIVE_OPERATOR);
    ctx.prisma.operatorAccount.findUnique.mockResolvedValue(null);
    ctx.prisma.employeeAccount.findUnique.mockResolvedValue({
      id: "emp-1",
      operatorId: "op-1",
      username: "driver042",
      passwordHash: "scrypt$x$y",
      role: "DRIVER",
      status: "ACTIVE"
    });
    ctx.credentials.verify.mockResolvedValue(true);

    const result = await ctx.service.operatorLogin("phuongtrang/driver042", "good", {});
    expect(result.role).toBe("DRIVER");
  });
});

describe("AuthService.platformLogin", () => {
  let ctx: ReturnType<typeof setup>;
  beforeEach(() => {
    ctx = setup();
  });

  it("rejects an operator-namespace identifier", async () => {
    expect(await statusOf(ctx.service.platformLogin("phuongtrang/owner01", "p", {}))).toBe(401);
  });

  it("issues a platform token on success", async () => {
    ctx.prisma.platformAccount.findUnique.mockResolvedValue({
      id: "padm-1",
      username: "khanh",
      passwordHash: "scrypt$x$y",
      role: "PLATFORM_ADMIN",
      status: "ACTIVE"
    });
    ctx.credentials.verify.mockResolvedValue(true);

    const result = await ctx.service.platformLogin("platform/khanh", "good", {});
    expect(result).toMatchObject({ scope: "platform", role: "PLATFORM_ADMIN" });
  });

  it("account không tồn tại → 401 và VẪN chạy dummy verify (chống enumeration bằng timing)", async () => {
    ctx.prisma.platformAccount.findUnique.mockResolvedValue(null);

    expect(await statusOf(ctx.service.platformLogin("platform/khong-co", "p", {}))).toBe(401);
    // Bỏ dummy verify là tạo ra chênh lệch thời gian đủ để dò xem username nào có thật.
    expect(ctx.credentials.verify).toHaveBeenCalledOnce();
    expect(ctx.history.record).toHaveBeenCalledWith(
      expect.objectContaining({ scope: "platform", result: "failure", reason: "unknown_account" })
    );
  });

  it("account bị khoá → 403 (chỉ sau khi mật khẩu đã đúng, không leak trạng thái)", async () => {
    ctx.prisma.platformAccount.findUnique.mockResolvedValue({
      id: "padm-2",
      username: "kh2",
      passwordHash: "scrypt$x$y",
      role: "PLATFORM_SUPPORT",
      status: "LOCKED"
    });
    ctx.credentials.verify.mockResolvedValue(true);

    expect(await statusOf(ctx.service.platformLogin("platform/kh2", "good", {}))).toBe(403);
    expect(ctx.tokens.mintAccessToken).not.toHaveBeenCalled();
  });

  it("giới hạn tần suất áp cho cả cổng platform", async () => {
    ctx.rateLimiter.assertCanAttemptLogin.mockRejectedValue(new Error("limited"));
    await expect(ctx.service.platformLogin("platform/khanh", "p", {})).rejects.toThrow();
    expect(ctx.prisma.platformAccount.findUnique).not.toHaveBeenCalled();
  });
});

describe("AuthService passenger OTP", () => {
  let ctx: ReturnType<typeof setup>;
  beforeEach(() => {
    ctx = setup();
  });

  it("rate-limits then sends an OTP on request", async () => {
    await ctx.service.requestOtp("a@b.com");
    expect(ctx.rateLimiter.assertCanRequest).toHaveBeenCalledWith("a@b.com");
    expect(ctx.auth.api.sendVerificationOTP).toHaveBeenCalledWith({
      body: { email: "a@b.com", type: "sign-in" }
    });
  });

  it("does not send when rate limit throws", async () => {
    ctx.rateLimiter.assertCanRequest.mockRejectedValue(new Error("limited"));
    await expect(ctx.service.requestOtp("a@b.com")).rejects.toThrow();
    expect(ctx.auth.api.sendVerificationOTP).not.toHaveBeenCalled();
  });

  it("issues a passenger token after a valid OTP", async () => {
    ctx.auth.api.signInEmailOTP.mockResolvedValue({ user: { id: "user-9" } });
    const result = await ctx.service.verifyOtp("a@b.com", "123456", {});
    expect(result).toMatchObject({ scope: "passenger", role: "PASSENGER" });
    expect(ctx.tokens.mintAccessToken).toHaveBeenCalledWith(
      expect.objectContaining({ sub: "user-9", scope: "passenger" })
    );
  });

  it("returns generic 401 and records failure on invalid OTP", async () => {
    // Better Auth ném APIError có `status` cho lỗi phía client.
    ctx.auth.api.signInEmailOTP.mockRejectedValue(
      Object.assign(new Error("bad otp"), { status: "UNAUTHORIZED" })
    );
    expect(await statusOf(ctx.service.verifyOtp("a@b.com", "000000", {}))).toBe(401);
    expect(ctx.history.record).toHaveBeenCalledWith(
      expect.objectContaining({ result: "failure", reason: "otp_invalid" })
    );
  });

  it("KHÔNG biến lỗi hạ tầng thành 401 và không ghi audit sai sự thật", async () => {
    // Postgres/Redis chết ném Error thường (không có `status`). Map nó thành 401 sẽ ghi
    // `otp_invalid` vào audit append-only — làm hỏng chính bằng chứng dùng để điều tra sau này.
    ctx.auth.api.signInEmailOTP.mockRejectedValue(new Error("Connection terminated"));

    await expect(ctx.service.verifyOtp("a@b.com", "000000", {})).rejects.toThrow(
      "Connection terminated"
    );
    expect(ctx.history.record).not.toHaveBeenCalled();
  });
});

describe("AuthService OAuth + session exchange", () => {
  let ctx: ReturnType<typeof setup>;
  beforeEach(() => {
    ctx = setup();
  });

  it("returns the provider redirect URL for a supported provider", async () => {
    ctx.auth.api.signInSocial.mockResolvedValue({
      url: "https://accounts.google.com/o/oauth2/auth?x=1",
      redirect: true
    });
    const url = await ctx.service.oauthInit("google", "http://localhost:3000/cb");
    expect(url).toBe("https://accounts.google.com/o/oauth2/auth?x=1");
    expect(ctx.auth.api.signInSocial).toHaveBeenCalledWith(
      expect.objectContaining({
        body: expect.objectContaining({ provider: "google", disableRedirect: true })
      })
    );
  });

  it("rejects an unsupported OAuth provider with 400", async () => {
    expect(await statusOf(ctx.service.oauthInit("twitter", undefined))).toBe(400);
    expect(ctx.auth.api.signInSocial).not.toHaveBeenCalled();
  });

  it("v1 chỉ hỗ trợ Google — Facebook và Apple bị từ chối (defer v1.x)", async () => {
    for (const provider of ["facebook", "apple"]) {
      expect(await statusOf(ctx.service.oauthInit(provider, undefined))).toBe(400);
    }
    expect(ctx.auth.api.signInSocial).not.toHaveBeenCalled();
  });

  it("chặn callbackURL ngoài allowlist — open redirect sau xác thực", async () => {
    // Better Auth lưu nguyên callbackURL vào state rồi redirect tới đó SAU KHI đã set session
    // cookie; middleware origin-check của nó thoát sớm khi gọi server-side → phải chặn ở đây.
    for (const evil of [
      "https://vexenhanh-dangnhap.evil/",
      "http://localhost:3000.evil.com/cb",
      "javascript:alert(1)"
    ]) {
      expect(await statusOf(ctx.service.oauthInit("google", evil))).toBe(400);
    }
    expect(ctx.auth.api.signInSocial).not.toHaveBeenCalled();
  });

  it("cho phép deep-link scheme của mobile trong allowlist", async () => {
    ctx.auth.api.signInSocial.mockResolvedValue({ url: "https://accounts.google.com/x", redirect: true });
    await expect(
      ctx.service.oauthInit("google", "vexenhanh://oauth/callback")
    ).resolves.toBeTruthy();
  });

  it("returns 502 when the provider returns no URL", async () => {
    ctx.auth.api.signInSocial.mockResolvedValue({ redirect: true });
    expect(await statusOf(ctx.service.oauthInit("google", undefined))).toBe(502);
  });

  it("exchanges a valid Better Auth session for a passenger token", async () => {
    ctx.auth.api.getSession.mockResolvedValue({ user: { id: "user-oauth-1" } });
    const result = await ctx.service.exchangeSession(new Headers(), {});
    expect(result).toMatchObject({ scope: "passenger", role: "PASSENGER" });
    expect(ctx.tokens.mintAccessToken).toHaveBeenCalledWith(
      expect.objectContaining({ sub: "user-oauth-1", scope: "passenger" })
    );
  });

  it("rejects session exchange when there is no session", async () => {
    ctx.auth.api.getSession.mockResolvedValue(null);
    expect(await statusOf(ctx.service.exchangeSession(new Headers(), {}))).toBe(401);
  });
});

describe("AuthController trusted client IP", () => {
  it("passes a Cloudflare-confirmed IP to credential login", async () => {
    const { controller, operatorLogin } = setupAuthController();

    await controller.operatorLogin(
      { identifier: "phuongtrang/owner01", password: "password" },
      proxyRequest("203.0.113.10", "203.0.113.10")
    );

    expect(operatorLogin).toHaveBeenCalledWith(
      "phuongtrang/owner01",
      "password",
      expect.objectContaining({ ip: "203.0.113.10" })
    );
  });

  it("omits an unconfirmed IP and emits an operational warning", async () => {
    const warn = vi.spyOn(Logger.prototype, "warn").mockImplementation(() => undefined);
    const { controller, operatorLogin } = setupAuthController();

    try {
      await controller.operatorLogin(
        { identifier: "phuongtrang/owner01", password: "password" },
        proxyRequest("192.0.2.99", "203.0.113.10")
      );

      expect(operatorLogin).toHaveBeenCalledWith(
        "phuongtrang/owner01",
        "password",
        expect.objectContaining({ ip: undefined })
      );
      expect(warn).toHaveBeenCalledWith(expect.stringContaining("cfRay=test-ray-SIN"));
    } finally {
      warn.mockRestore();
    }
  });
});

function setupAuthController() {
  const result: LoginResult = {
    accessToken: "access-token",
    tokenType: "Bearer",
    expiresInSeconds: 900,
    scope: "operator",
    role: "OPERATOR_OWNER"
  };
  const operatorLogin = vi.fn().mockResolvedValue(result);
  const authService = { operatorLogin } as unknown as AuthService;
  const config = parseAppConfig({
    NODE_ENV: "production",
    BETTER_AUTH_SECRET: "test-secret",
    BETTER_AUTH_URL: "https://api.example.com",
    JWT_ACCESS_PRIVATE_KEY: "test-key",
    RESEND_API_KEY: "test-resend-key"
  });

  return { controller: new AuthController(authService, config), operatorLogin };
}

function proxyRequest(ip: string, cfConnectingIp: string): Request {
  return {
    ip,
    headers: {
      "cf-connecting-ip": cfConnectingIp,
      "cf-ray": "test-ray-SIN",
      "user-agent": "vitest"
    }
  } as unknown as Request;
}
