import { Inject, Injectable } from "@nestjs/common";
import type Redis from "ioredis";
import { REDIS_CLIENT } from "../redis/redis.config";
import { vehicleImageStorageUnavailable, vehicleImageUploadRateLimited } from "./vehicle.errors";

/** Mỗi tài khoản xin tối đa 120 URL tải ảnh trong 10 phút — đủ cho 15 xe × 8 ảnh, chặn vòng lặp xin URL. */
export const UPLOAD_URL_MAX = 120;
export const UPLOAD_URL_WINDOW_SECONDS = 600;

/**
 * Giới hạn tần suất xin URL tải ảnh theo tài khoản (LLD §6.12 bước 2): mỗi URL là một quyền ghi vào kho công
 * khai. Redis lỗi thì từ chối (503), không cho qua — cùng nguyên tắc với các bộ đếm khác (ADR-015).
 */
@Injectable()
export class VehicleImageUploadLimiter {
  constructor(@Inject(REDIS_CLIENT) private readonly redis: Redis) {}

  async assertWithinLimit(accountId: string): Promise<void> {
    const key = `vehicle-image:upload-url:${accountId}`;
    let count: number;
    try {
      // `SET … NX` trước `INCR` trong một MULTI: khóa luôn có hạn, không kẹt vĩnh viễn nếu tiến trình chết giữa chừng.
      const results = await this.redis
        .multi()
        .set(key, 0, "EX", UPLOAD_URL_WINDOW_SECONDS, "NX")
        .incr(key)
        .exec();
      const [error, value] = results?.[1] ?? [new Error("Redis transaction aborted"), null];
      if (error) {
        throw error;
      }
      count = Number(value);
    } catch {
      throw vehicleImageStorageUnavailable();
    }
    if (count > UPLOAD_URL_MAX) {
      throw vehicleImageUploadRateLimited();
    }
  }
}
