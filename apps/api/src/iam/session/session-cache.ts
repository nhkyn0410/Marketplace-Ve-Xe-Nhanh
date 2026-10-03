import { Inject, Injectable } from "@nestjs/common";
import type Redis from "ioredis";
import { APP_CONFIG, type AppConfig } from "../../config/env.config";
import { REDIS_CLIENT } from "../../redis/redis.config";
import { serviceUnavailable } from "../auth/auth.errors";

/** Bằng chứng re-auth sống 5 phút (FR-IAM-10, quyết định Q3). */
export const REAUTH_PROOF_TTL_SECONDS = 300;

/**
 * Tên khoá nằm ở MỘT chỗ: người ghi (revoke) và người đọc (guard) lệch một chữ là revoke âm thầm
 * vô hiệu — không test nào đỏ nếu mỗi bên tự viết chuỗi của mình.
 */
const keys = {
  active: (sid: string) => `session:${sid}`,
  revoked: (sid: string) => `session:revoked:${sid}`,
  reauth: (sid: string) => `reauth:${sid}`,
};

export type CachedSessionState = "active" | "revoked" | "unknown";

/**
 * Trạng thái phiên trên Redis cho hot path (ADR-015/017). Redis lỗi → 503, KHÔNG coi như "không
 * có khoá" — đoán "chưa revoke" khi Redis chết chính là fail-open.
 */
@Injectable()
export class SessionCache {
  constructor(
    @Inject(REDIS_CLIENT) private readonly redis: Redis,
    @Inject(APP_CONFIG) private readonly config: AppConfig,
  ) {}

  async lookup(sid: string): Promise<CachedSessionState> {
    const [revoked, active] = await this.run(() =>
      this.redis.mget(keys.revoked(sid), keys.active(sid)),
    );
    // Đọc `revoked` TRƯỚC: một request cache-miss có thể ghi `active` ngay sau khi revoke vừa
    // chạy xong. Khoá revoked thắng thì lần ghi muộn đó không hồi sinh được phiên.
    if (revoked !== null) {
      return "revoked";
    }
    return active !== null ? "active" : "unknown";
  }

  async markActive(sid: string): Promise<void> {
    await this.run(() =>
      this.redis.set(keys.active(sid), "1", "EX", this.config.JWT_ACCESS_TTL_SECONDS),
    );
  }

  /**
   * TTL = TTL access token: token phát trước lúc revoke hết hạn trước khi khoá này hết, sau đó
   * khoá không còn việc gì để chặn.
   */
  async markRevoked(sids: readonly string[]): Promise<void> {
    if (sids.length === 0) {
      return;
    }
    const batch = this.redis.multi();
    for (const sid of sids) {
      batch.set(keys.revoked(sid), "1", "EX", this.config.JWT_ACCESS_TTL_SECONDS);
      batch.del(keys.active(sid), keys.reauth(sid));
    }
    const results = await this.run(() => batch.exec());
    // `exec` không ném khi TỪNG lệnh lỗi — lỗi nằm trong mảng kết quả.
    if (!results || results.some(([error]) => error)) {
      throw serviceUnavailable();
    }
  }

  async grantReauth(sid: string): Promise<void> {
    await this.run(() =>
      this.redis.set(keys.reauth(sid), "1", "EX", REAUTH_PROOF_TTL_SECONDS),
    );
  }

  /** Q3: IAM-002 chỉ cấp bằng chứng; guard `@RequireReauth()` do task tiêu thụ đầu tiên viết. */
  async hasReauth(sid: string): Promise<boolean> {
    return (await this.run(() => this.redis.exists(keys.reauth(sid)))) === 1;
  }

  private async run<T>(command: () => Promise<T>): Promise<T> {
    try {
      return await command();
    } catch {
      throw serviceUnavailable();
    }
  }
}
