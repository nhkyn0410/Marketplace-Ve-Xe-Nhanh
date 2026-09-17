import { Inject, Injectable } from "@nestjs/common";
import type Redis from "ioredis";
import { APP_CONFIG, type AppConfig } from "../../config/env.config";
import { REDIS_CLIENT } from "../../redis/redis.constants";
import { serviceUnavailable } from "../auth/auth.errors";

/** Tên khoá nằm ở MỘT chỗ: người ghi (`.5`) và người đọc (guard) lệch một chữ là revoke âm thầm vô hiệu. */
const revokedKey = (sid: string): string => `session:revoked:${sid}`;

@Injectable()
export class SessionRevocationStore {
  constructor(
    @Inject(REDIS_CLIENT) private readonly redis: Redis,
    @Inject(APP_CONFIG) private readonly config: AppConfig,
  ) {}

  async isRevoked(sid: string): Promise<boolean> {
    try {
      return (await this.redis.exists(revokedKey(sid))) === 1;
    } catch {
      throw serviceUnavailable();
    }
  }

  /** TTL = TTL access token: quá mốc đó token tự hết hạn, khoá không còn việc gì. `.5` nối vào luồng revoke. */
  async markRevoked(sid: string): Promise<void> {
    try {
      await this.redis.set(
        revokedKey(sid),
        "1",
        "EX",
        this.config.JWT_ACCESS_TTL_SECONDS,
      );
    } catch {
      throw serviceUnavailable();
    }
  }
}
