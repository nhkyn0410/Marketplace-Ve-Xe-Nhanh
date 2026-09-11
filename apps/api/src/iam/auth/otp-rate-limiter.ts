import { HttpStatus, Inject, Injectable } from "@nestjs/common";
import type Redis from "ioredis";
import { REDIS_CLIENT } from "../../redis/redis.constants";
import {
  LOGIN_MAX_PER_IDENTIFIER_PER_HOUR,
  LOGIN_MAX_PER_IP_PER_HOUR,
  LOGIN_WINDOW_SECONDS,
  OTP_COOLDOWN_SECONDS,
  OTP_MAX_PER_HOUR,
  OTP_WINDOW_SECONDS
} from "./auth.constants";
import { AuthException, otpRateLimited } from "./auth.errors";

/**
 * INCR + EXPIRE trong MỘT lệnh. Tách hai lệnh thì lỗi/timeout đúng khe giữa chúng sẽ để lại
 * key KHÔNG TTL → bucket đó bị khoá vĩnh viễn (người dùng mất luôn kênh đăng nhập).
 */
const INCR_WITH_TTL = `
local c = redis.call('INCR', KEYS[1])
if c == 1 then redis.call('EXPIRE', KEYS[1], ARGV[1]) end
return c
`;

/** Redis chết → fail-closed (KHÔNG bypass rate limit) nhưng trả đúng 503 thay vì 500 (ADR-015). */
function redisUnavailable(): AuthException {
  return new AuthException(
    HttpStatus.SERVICE_UNAVAILABLE,
    "SERVICE_UNAVAILABLE",
    "Dịch vụ tạm thời không khả dụng. Vui lòng thử lại."
  );
}

/**
 * Rate limit đường xác thực. Dùng Redis (ADR-015).
 * - OTP (SEC-OQ-07): cooldown 60s + ≤5 lần/giờ/email. Verify-attempt (3 lần/OTP) do Better Auth.
 * - Login credential (Security §11 "brute force login"): ≤10 lần/giờ/identifier và ≤30 lần/giờ/IP.
 */
@Injectable()
export class OtpRateLimiter {
  constructor(@Inject(REDIS_CLIENT) private readonly redis: Redis) {}

  async assertCanRequest(email: string): Promise<void> {
    const key = normalize(email);
    let acquired: string | null;
    try {
      // Atomic check-and-set: `SET NX EX` → null nghĩa là cooldown đang active (chống TOCTOU burst).
      acquired = await this.redis.set(
        `otp:cooldown:${key}`,
        "1",
        "EX",
        OTP_COOLDOWN_SECONDS,
        "NX"
      );
    } catch {
      throw redisUnavailable();
    }
    if (acquired === null) {
      throw otpRateLimited();
    }

    if ((await this.bump(`otp:count:${key}`, OTP_WINDOW_SECONDS)) > OTP_MAX_PER_HOUR) {
      throw otpRateLimited();
    }
  }

  /**
   * Chặn brute-force / DoS trên 3 cổng login. Đếm theo CẢ identifier lẫn IP: chỉ theo identifier
   * thì đổi identifier là lách được (mỗi lần verify tốn 128 MiB scrypt); chỉ theo IP thì
   * botnet lách được.
   */
  async assertCanAttemptLogin(identifier: string, ip?: string): Promise<void> {
    const perIdentifier = await this.bump(
      `login:id:${normalize(identifier)}`,
      LOGIN_WINDOW_SECONDS
    );
    if (perIdentifier > LOGIN_MAX_PER_IDENTIFIER_PER_HOUR) {
      throw loginRateLimited();
    }

    if (ip) {
      const perIp = await this.bump(`login:ip:${ip}`, LOGIN_WINDOW_SECONDS);
      if (perIp > LOGIN_MAX_PER_IP_PER_HOUR) {
        throw loginRateLimited();
      }
    }
  }

  private async bump(key: string, windowSeconds: number): Promise<number> {
    try {
      return Number(await this.redis.eval(INCR_WITH_TTL, 1, key, String(windowSeconds)));
    } catch {
      throw redisUnavailable();
    }
  }
}

function normalize(value: string): string {
  return value.trim().toLowerCase();
}

function loginRateLimited(): AuthException {
  return new AuthException(
    HttpStatus.TOO_MANY_REQUESTS,
    "AUTH_LOGIN_RATE_LIMITED",
    "Đăng nhập sai quá nhiều lần. Vui lòng thử lại sau."
  );
}
