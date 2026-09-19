import { beforeEach, describe, expect, it, vi } from "vitest";
import { Logger, type HttpException } from "@nestjs/common";
import type Redis from "ioredis";
import {
  LOGIN_MAX_PER_IDENTIFIER_PER_HOUR,
  LOGIN_MAX_PER_IP_PER_HOUR,
  LOGIN_WINDOW_SECONDS,
  MFA_FAILURE_WINDOW_SECONDS,
  MFA_MAX_FAILURES_PER_WINDOW,
  OTP_COOLDOWN_SECONDS,
  OTP_MAX_PER_HOUR,
  OTP_WINDOW_SECONDS,
  REFRESH_MAX_PER_FAMILY_PER_HOUR,
  REFRESH_MAX_PER_IP_PER_HOUR,
  REFRESH_WINDOW_SECONDS
} from "./auth.constants";
import { ipBucket, OtpRateLimiter } from "./otp-rate-limiter";

async function problemOf(promise: Promise<unknown>): Promise<{ status: number; code?: string }> {
  try {
    await promise;
    return { status: 0 };
  } catch (error) {
    const exception = error as HttpException;
    const body = exception.getResponse() as { code?: string };
    return { status: exception.getStatus(), code: body.code };
  }
}

/**
 * SEC-OQ-07 (OTP: cooldown 60s + ≤5/giờ/email) và Security §11 (brute force login).
 * Verify-attempt (3 lần/OTP) do Better Auth `allowedAttempts` — ngoài phạm vi class này.
 */
describe("OtpRateLimiter", () => {
  const set = vi.fn();
  const get = vi.fn();
  const del = vi.fn();
  const evalScript = vi.fn();
  const redis = { set, get, del, eval: evalScript } as unknown as Redis;
  const limiter = new OtpRateLimiter(redis);

  beforeEach(() => {
    vi.clearAllMocks();
    set.mockResolvedValue("OK");
    evalScript.mockResolvedValue(1);
  });

  describe("OTP (SEC-OQ-07)", () => {
    it("đặt cooldown bằng SET NX EX đúng 60s (atomic, chống burst TOCTOU)", async () => {
      await limiter.assertCanRequest("a@example.com");

      expect(set).toHaveBeenCalledWith(
        "otp:cooldown:a@example.com",
        "1",
        "EX",
        OTP_COOLDOWN_SECONDS,
        "NX"
      );
      expect(OTP_COOLDOWN_SECONDS).toBe(60);
    });

    it("chặn khi cooldown còn hiệu lực (SET NX trả null) và không tăng counter", async () => {
      set.mockResolvedValue(null);

      expect(await problemOf(limiter.assertCanRequest("a@example.com"))).toEqual({
        status: 429,
        code: "AUTH_OTP_RATE_LIMITED"
      });
      expect(evalScript).not.toHaveBeenCalled();
    });

    it("INCR + EXPIRE đi trong MỘT script Lua — không có khe để key mất TTL", async () => {
      await limiter.assertCanRequest("a@example.com");

      const [script, keyCount, key, ttl] = evalScript.mock.calls[0] as [
        string,
        number,
        string,
        string
      ];
      expect(script).toContain("INCR");
      expect(script).toContain("EXPIRE");
      expect(keyCount).toBe(1);
      expect(key).toBe("otp:count:a@example.com");
      expect(ttl).toBe(String(OTP_WINDOW_SECONDS));
      expect(OTP_WINDOW_SECONDS).toBe(3600);
    });

    it("cho phép đúng 5 lần trong cửa sổ giờ", async () => {
      evalScript.mockResolvedValue(OTP_MAX_PER_HOUR);
      await expect(limiter.assertCanRequest("a@example.com")).resolves.toBeUndefined();
      expect(OTP_MAX_PER_HOUR).toBe(5);
    });

    it("chặn từ lần thứ 6 trong cửa sổ giờ", async () => {
      evalScript.mockResolvedValue(OTP_MAX_PER_HOUR + 1);

      expect(await problemOf(limiter.assertCanRequest("a@example.com"))).toEqual({
        status: 429,
        code: "AUTH_OTP_RATE_LIMITED"
      });
    });

    it("chuẩn hoá email (trim + lowercase) để không lách giới hạn bằng biến thể hoa/thường", async () => {
      await limiter.assertCanRequest("  A@Example.COM  ");

      expect(set).toHaveBeenCalledWith(
        "otp:cooldown:a@example.com",
        "1",
        "EX",
        OTP_COOLDOWN_SECONDS,
        "NX"
      );
      expect(evalScript.mock.calls[0][2]).toBe("otp:count:a@example.com");
    });
  });

  describe("Login (Security §11 — brute force / DoS)", () => {
    it("đếm theo cả identifier lẫn IP", async () => {
      await limiter.assertCanAttemptLogin("phuongtrang/owner01", "1.2.3.4");

      const keys = evalScript.mock.calls.map((call) => call[2]);
      expect(keys).toEqual(["login:id:phuongtrang/owner01", "login:ip:1.2.3.4"]);
      expect(evalScript.mock.calls[0][3]).toBe(String(LOGIN_WINDOW_SECONDS));
    });

    it("chặn khi vượt giới hạn theo identifier", async () => {
      const warn = vi.spyOn(Logger.prototype, "warn").mockImplementation(() => undefined);
      evalScript.mockResolvedValue(LOGIN_MAX_PER_IDENTIFIER_PER_HOUR + 1);

      try {
        expect(await problemOf(limiter.assertCanAttemptLogin("platform/khanh", "1.2.3.4"))).toEqual({
          status: 429,
          code: "AUTH_LOGIN_RATE_LIMITED"
        });
        expect(warn).toHaveBeenCalledWith({
          event: "auth.login.rate_limited",
          dimension: "identifier"
        });
      } finally {
        warn.mockRestore();
      }
    });

    it("chặn khi vượt giới hạn theo IP dù mỗi identifier đều còn quota", async () => {
      const warn = vi.spyOn(Logger.prototype, "warn").mockImplementation(() => undefined);
      evalScript
        .mockResolvedValueOnce(1)
        .mockResolvedValueOnce(LOGIN_MAX_PER_IP_PER_HOUR + 1);

      try {
        expect(await problemOf(limiter.assertCanAttemptLogin("platform/khanh", "1.2.3.4"))).toEqual({
          status: 429,
          code: "AUTH_LOGIN_RATE_LIMITED"
        });
        expect(warn).toHaveBeenCalledWith({
          event: "auth.login.rate_limited",
          dimension: "ip"
        });
      } finally {
        warn.mockRestore();
      }
    });

    it("không có IP (proxy không gửi) thì vẫn giới hạn theo identifier", async () => {
      await limiter.assertCanAttemptLogin("platform/khanh", undefined);
      expect(evalScript).toHaveBeenCalledOnce();
    });

    it("hai client IP dùng hai bucket riêng", async () => {
      await limiter.assertCanAttemptLogin("platform/khanh", "203.0.113.10");
      await limiter.assertCanAttemptLogin("platform/khanh", "198.51.100.20");

      const ipKeys = evalScript.mock.calls
        .map((call) => call[2])
        .filter((key) => String(key).startsWith("login:ip:"));
      expect(ipKeys).toEqual([
        "login:ip:203.0.113.10",
        "login:ip:198.51.100.20"
      ]);
    });
  });

  describe("Login bucket theo danh tính đã resolve (IAM-004 review)", () => {
    it("biến thể khoảng trắng/hoa-thường của cùng một account dồn về MỘT bucket", async () => {
      evalScript.mockResolvedValue(1);
      for (const variant of ["platform/khanh", "platform /khanh", "platform/	khanh", " Platform / Khanh ", "platform /khanh"]) {
        await limiter.assertCanAttemptLogin(variant);
      }
      await limiter.assertCanAttemptLogin("phuongtrang / owner01");
      await limiter.assertCanAttemptLogin("rider@Example.com ");

      const keys = new Set(evalScript.mock.calls.map((call) => call[2]));
      expect([...keys]).toEqual([
        "login:id:platform/khanh",
        "login:id:phuongtrang/owner01",
        "login:id:rider@example.com"
      ]);
    });
  });

  describe("MFA — trần lần sai theo chủ thể (IAM-004)", () => {
    it("đếm lần sai bằng INCR có TTL 24h", async () => {
      evalScript.mockResolvedValue(1);
      await limiter.recordMfaFailure("platform:padm-1");
      expect(evalScript.mock.calls[0]![2]).toBe("mfa-fail:platform:padm-1");
      expect(evalScript.mock.calls[0]![3]).toBe(String(MFA_FAILURE_WINDOW_SECONDS));
    });

    it("dưới trần thì cho qua; chạm trần → 429 AUTH_LOGIN_RATE_LIMITED", async () => {
      const warn = vi.spyOn(Logger.prototype, "warn").mockImplementation(() => undefined);
      try {
        get.mockResolvedValueOnce(String(MFA_MAX_FAILURES_PER_WINDOW - 1));
        await expect(limiter.assertMfaNotLocked("platform:padm-1")).resolves.toBeUndefined();
        get.mockResolvedValueOnce(String(MFA_MAX_FAILURES_PER_WINDOW));
        expect(await problemOf(limiter.assertMfaNotLocked("platform:padm-1"))).toEqual({
          status: 429,
          code: "AUTH_LOGIN_RATE_LIMITED"
        });
        expect(get).toHaveBeenCalledWith("mfa-fail:platform:padm-1");
      } finally {
        warn.mockRestore();
      }
    });

    it("Redis chết khi kiểm trần → 503 (fail-closed); xoá bộ đếm lỗi thì bỏ qua", async () => {
      get.mockRejectedValueOnce(new Error("ECONNREFUSED"));
      expect(await problemOf(limiter.assertMfaNotLocked("platform:padm-1"))).toEqual({
        status: 503,
        code: "SERVICE_UNAVAILABLE"
      });
      del.mockRejectedValueOnce(new Error("ECONNREFUSED"));
      await expect(limiter.clearMfaFailures("platform:padm-1")).resolves.toBeUndefined();
    });
  });

  describe("Refresh (IAM-002)", () => {
    it("đếm theo IP trong bucket riêng, không ăn chung quota login", async () => {
      await limiter.assertCanRefresh("203.0.113.10");
      expect(evalScript).toHaveBeenCalledWith(
        expect.any(String),
        1,
        "refresh:ip:203.0.113.10",
        String(REFRESH_WINDOW_SECONDS)
      );
    });

    it("chặn khi vượt giới hạn theo IP", async () => {
      evalScript.mockResolvedValue(REFRESH_MAX_PER_IP_PER_HOUR + 1);
      const warn = vi.spyOn(Logger.prototype, "warn").mockImplementation(() => undefined);
      try {
        expect(await problemOf(limiter.assertCanRefresh("203.0.113.10"))).toEqual({
          status: 429,
          code: "AUTH_REFRESH_RATE_LIMITED"
        });
      } finally {
        warn.mockRestore();
      }
    });

    it("không có IP tin cậy thì không đếm (không gom mọi người vào một bucket)", async () => {
      await limiter.assertCanRefresh(undefined);
      expect(evalScript).not.toHaveBeenCalled();
    });

    it("bucket theo family không cần IP — gọi thẳng origin không lách được", async () => {
      await limiter.assertCanRotateFamily("fam-1");
      expect(evalScript).toHaveBeenCalledWith(
        expect.any(String),
        1,
        "refresh:family:fam-1",
        String(REFRESH_WINDOW_SECONDS)
      );

      evalScript.mockResolvedValue(REFRESH_MAX_PER_FAMILY_PER_HOUR + 1);
      const warn = vi.spyOn(Logger.prototype, "warn").mockImplementation(() => undefined);
      try {
        expect(await problemOf(limiter.assertCanRotateFamily("fam-1"))).toEqual({
          status: 429,
          code: "AUTH_REFRESH_RATE_LIMITED"
        });
      } finally {
        warn.mockRestore();
      }
    });

    it("IPv6 gom theo /64 — xoay 64 bit cuối không đẻ ra bucket mới", async () => {
      await limiter.assertCanRefresh("2001:db8:abcd:12::1");
      await limiter.assertCanRefresh("2001:db8:abcd:12:ffff:ffff:ffff:ffff");
      const keys = evalScript.mock.calls.map((call) => call[2]);
      expect(keys).toEqual([
        "refresh:ip:2001:0db8:abcd:0012::/64",
        "refresh:ip:2001:0db8:abcd:0012::/64"
      ]);
    });

    it("Redis chết → 503, không rotate nửa vời", async () => {
      evalScript.mockRejectedValue(new Error("Command timed out"));
      expect(await problemOf(limiter.assertCanRefresh("203.0.113.10"))).toEqual({
        status: 503,
        code: "SERVICE_UNAVAILABLE"
      });
    });
  });

  describe("Re-auth (IAM-002)", () => {
    it("bucket chủ thể RIÊNG — gõ `sub` vào cổng login không khoá được re-auth của người khác", async () => {
      await limiter.assertCanReauth("platform:padm-1", "1.2.3.4");
      const keys = evalScript.mock.calls.map((call) => call[2]);
      expect(keys).toEqual(["reauth-attempt:platform:padm-1", "login:ip:1.2.3.4"]);
    });

    it("chặn từ lần thứ 11 theo chủ thể", async () => {
      evalScript.mockResolvedValue(LOGIN_MAX_PER_IDENTIFIER_PER_HOUR + 1);
      const warn = vi.spyOn(Logger.prototype, "warn").mockImplementation(() => undefined);
      try {
        expect(await problemOf(limiter.assertCanReauth("platform:padm-1"))).toEqual({
          status: 429,
          code: "AUTH_LOGIN_RATE_LIMITED"
        });
      } finally {
        warn.mockRestore();
      }
    });
  });

  describe("ipBucket", () => {
    it.each([
      ["203.0.113.10", "203.0.113.10"],
      ["::ffff:203.0.113.10", "203.0.113.10"],
      ["::1", "0000:0000:0000:0000::/64"],
      ["2001:db8::", "2001:0db8:0000:0000::/64"],
      ["fe80::1%eth0", "fe80:0000:0000:0000::/64"],
      ["2001:DB8:0:0:1:2:3:4", "2001:0db8:0000:0000::/64"]
    ])("%s → %s", (ip, bucket) => {
      expect(ipBucket(ip)).toBe(bucket);
    });
  });

  describe("Redis chết", () => {
    it("fail-closed với 503 SERVICE_UNAVAILABLE, KHÔNG bypass rate limit (ADR-015)", async () => {
      set.mockRejectedValue(new Error("ECONNREFUSED"));

      expect(await problemOf(limiter.assertCanRequest("a@example.com"))).toEqual({
        status: 503,
        code: "SERVICE_UNAVAILABLE"
      });
    });

    it("lỗi ở bước đếm cũng trả 503 chứ không phải 500", async () => {
      evalScript.mockRejectedValue(new Error("LOADING Redis is loading the dataset in memory"));

      expect(await problemOf(limiter.assertCanAttemptLogin("platform/khanh", "1.2.3.4"))).toEqual({
        status: 503,
        code: "SERVICE_UNAVAILABLE"
      });
    });
  });
});
