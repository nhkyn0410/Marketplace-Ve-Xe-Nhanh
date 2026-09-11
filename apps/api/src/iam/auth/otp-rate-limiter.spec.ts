import { beforeEach, describe, expect, it, vi } from "vitest";
import type { HttpException } from "@nestjs/common";
import type Redis from "ioredis";
import {
  LOGIN_MAX_PER_IDENTIFIER_PER_HOUR,
  LOGIN_MAX_PER_IP_PER_HOUR,
  LOGIN_WINDOW_SECONDS,
  OTP_COOLDOWN_SECONDS,
  OTP_MAX_PER_HOUR,
  OTP_WINDOW_SECONDS
} from "./auth.constants";
import { OtpRateLimiter } from "./otp-rate-limiter";

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
  const evalScript = vi.fn();
  const redis = { set, eval: evalScript } as unknown as Redis;
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
      evalScript.mockResolvedValue(LOGIN_MAX_PER_IDENTIFIER_PER_HOUR + 1);

      expect(await problemOf(limiter.assertCanAttemptLogin("platform/khanh", "1.2.3.4"))).toEqual({
        status: 429,
        code: "AUTH_LOGIN_RATE_LIMITED"
      });
    });

    it("chặn khi vượt giới hạn theo IP dù mỗi identifier đều còn quota", async () => {
      evalScript
        .mockResolvedValueOnce(1)
        .mockResolvedValueOnce(LOGIN_MAX_PER_IP_PER_HOUR + 1);

      expect(await problemOf(limiter.assertCanAttemptLogin("platform/khanh", "1.2.3.4"))).toEqual({
        status: 429,
        code: "AUTH_LOGIN_RATE_LIMITED"
      });
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
