import type { HttpException } from "@nestjs/common";
import { beforeEach, describe, expect, it, vi } from "vitest";
import { AuthService } from "./auth.service";

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
  const rateLimiter = { assertCanRequest: vi.fn().mockResolvedValue(undefined) };
  const history = { record: vi.fn().mockResolvedValue(undefined) };

  const service = new AuthService(
    auth as never,
    prisma as never,
    tokens as never,
    credentials as never,
    rateLimiter as never,
    history as never
  );
  return { service, auth, prisma, tokens, credentials, rateLimiter, history };
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
    ctx.auth.api.signInEmailOTP.mockRejectedValue(new Error("bad otp"));
    expect(await statusOf(ctx.service.verifyOtp("a@b.com", "000000", {}))).toBe(401);
    expect(ctx.history.record).toHaveBeenCalledWith(
      expect.objectContaining({ result: "failure", reason: "otp_invalid" })
    );
  });
});
