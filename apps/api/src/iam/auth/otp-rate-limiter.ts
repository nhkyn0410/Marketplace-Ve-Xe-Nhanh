import { Inject, Injectable } from "@nestjs/common";
import type Redis from "ioredis";
import { REDIS_CLIENT } from "../../redis/redis.constants";
import {
  OTP_COOLDOWN_SECONDS,
  OTP_MAX_PER_HOUR,
  OTP_WINDOW_SECONDS
} from "./auth.constants";
import { otpRateLimited } from "./auth.errors";

/**
 * Rate limit gửi OTP (SEC-OQ-07): cooldown 60s giữa các lần + ≤5 lần/giờ/email.
 * Dùng Redis (ADR-015). Verify-attempt (3 lần/OTP) do Better Auth `allowedAttempts`.
 */
@Injectable()
export class OtpRateLimiter {
  constructor(@Inject(REDIS_CLIENT) private readonly redis: Redis) {}

  async assertCanRequest(email: string): Promise<void> {
    const key = email.trim().toLowerCase();
    const cooldownKey = `otp:cooldown:${key}`;
    const countKey = `otp:count:${key}`;

    if ((await this.redis.exists(cooldownKey)) === 1) {
      throw otpRateLimited();
    }

    const count = await this.redis.incr(countKey);
    if (count === 1) {
      await this.redis.expire(countKey, OTP_WINDOW_SECONDS);
    }
    if (count > OTP_MAX_PER_HOUR) {
      throw otpRateLimited();
    }

    await this.redis.set(cooldownKey, "1", "EX", OTP_COOLDOWN_SECONDS);
  }
}
