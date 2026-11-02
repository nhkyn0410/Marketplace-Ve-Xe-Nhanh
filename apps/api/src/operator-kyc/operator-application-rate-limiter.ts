import { Inject, Injectable } from "@nestjs/common";
import type Redis from "ioredis";
import { REDIS_CLIENT } from "../redis/redis.config";
import { applicationRateLimited, applicationServiceUnavailable } from "./operator-application.errors";

/** Một giờ — cửa sổ đếm của mọi giới hạn dưới đây. */
export const RATE_WINDOW_SECONDS = 3600;
/** Tạo hồ sơ / xin lại link: tối đa 3 lần mỗi email và 10 lần mỗi IP trong một giờ (Security §11 spam form). */
export const MAX_PER_EMAIL = 3;
export const MAX_PER_IP = 10;
/** Xin URL tải giấy tờ: tối đa 30 lần / hồ sơ / giờ — đủ thay cả ba giấy tờ nhiều lần. */
export const MAX_UPLOADS_PER_APPLICATION = 30;

export type RateAction = "create" | "access-link";

/**
 * INCR + EXPIRE trong MỘT lệnh: tách hai lệnh thì lỗi đúng khe giữa sẽ để lại key không TTL, khóa vĩnh viễn
 * (cùng cách `OtpRateLimiter`).
 */
const INCR_WITH_TTL = `
local c = redis.call('INCR', KEYS[1])
if c == 1 then redis.call('EXPIRE', KEYS[1], ARGV[1]) end
return c
`;

/**
 * Giới hạn tần suất của luồng đăng ký nhà xe (UC-10 A6). Đếm cả khi email chưa có hồ sơ nào để phản hồi không lộ
 * email đã đăng ký hay chưa. Redis lỗi thì từ chối (503), không cho qua (ADR-015).
 */
@Injectable()
export class OperatorApplicationRateLimiter {
  constructor(@Inject(REDIS_CLIENT) private readonly redis: Redis) {}

  /** IP không xác định được (proxy lạ) thì chỉ đếm theo email, không gom mọi người vào một bucket. */
  async assertPublicRequest(action: RateAction, email: string, ip: string | undefined): Promise<void> {
    const counts = await Promise.all([
      this.hit(`opr-app:${action}:email:${email}`),
      ...(ip ? [this.hit(`opr-app:${action}:ip:${ip}`)] : []),
    ]);
    if (counts[0]! > MAX_PER_EMAIL || (counts[1] ?? 0) > MAX_PER_IP) {
      throw applicationRateLimited();
    }
  }

  async assertDocumentUpload(applicationId: string): Promise<void> {
    if ((await this.hit(`opr-app:upload:${applicationId}`)) > MAX_UPLOADS_PER_APPLICATION) {
      throw applicationRateLimited();
    }
  }

  private async hit(key: string): Promise<number> {
    try {
      return Number(await this.redis.eval(INCR_WITH_TTL, 1, key, RATE_WINDOW_SECONDS));
    } catch {
      throw applicationServiceUnavailable();
    }
  }
}
