import type Redis from "ioredis";
import { describe, expect, it } from "vitest";
import {
  MAX_PER_EMAIL,
  MAX_PER_IP,
  MAX_UPLOADS_PER_APPLICATION,
  OperatorApplicationRateLimiter,
  RATE_WINDOW_SECONDS,
} from "./operator-application-rate-limiter";

/** Redis giả cho script INCR + EXPIRE; `fail` dựng tình huống Redis lỗi. */
function fakeRedis(fail = false) {
  const counters = new Map<string, number>();
  const ttl = new Map<string, number>();
  const redis = {
    async eval(_script: string, _keys: number, key: string, seconds: number) {
      if (fail) {
        throw new Error("ECONNREFUSED");
      }
      const next = (counters.get(key) ?? 0) + 1;
      counters.set(key, next);
      if (next === 1) {
        ttl.set(key, seconds);
      }
      return next;
    },
  };
  return { redis: redis as unknown as Redis, counters, ttl };
}

async function statusOf(promise: Promise<unknown>): Promise<{ status?: number; code?: string }> {
  try {
    await promise;
    return {};
  } catch (error) {
    return {
      status: (error as { getStatus?: () => number }).getStatus?.(),
      code: (error as { getResponse?: () => { code?: string } }).getResponse?.().code,
    };
  }
}

const LIMITED = { status: 429, code: "OPERATOR_APPLICATION_RATE_LIMITED" };

describe("OperatorApplicationRateLimiter", () => {
  it(`mỗi email tối đa ${MAX_PER_EMAIL} lần / giờ cho mỗi hành động; bộ đếm có hạn`, async () => {
    const { redis, ttl } = fakeRedis();
    const limiter = new OperatorApplicationRateLimiter(redis);
    for (let attempt = 0; attempt < MAX_PER_EMAIL; attempt += 1) {
      await limiter.assertPublicRequest("create", "a@x.vn", `10.0.0.${attempt}`);
    }
    expect(await statusOf(limiter.assertPublicRequest("create", "a@x.vn", "10.0.0.99"))).toEqual(LIMITED);
    // Hành động khác, email khác: bộ đếm riêng.
    await expect(limiter.assertPublicRequest("access-link", "a@x.vn", "10.0.0.1")).resolves.toBeUndefined();
    await expect(limiter.assertPublicRequest("create", "b@x.vn", "10.0.0.1")).resolves.toBeUndefined();
    expect(new Set(ttl.values())).toEqual(new Set([RATE_WINDOW_SECONDS]));
  });

  it(`mỗi IP tối đa ${MAX_PER_IP} lần / giờ dù đổi email (chặn spam form); không rõ IP thì chỉ đếm theo email`, async () => {
    const { redis, counters } = fakeRedis();
    const limiter = new OperatorApplicationRateLimiter(redis);
    for (let attempt = 0; attempt < MAX_PER_IP; attempt += 1) {
      await limiter.assertPublicRequest("create", `u${attempt}@x.vn`, "203.0.113.7");
    }
    expect(await statusOf(limiter.assertPublicRequest("create", "new@x.vn", "203.0.113.7"))).toEqual(LIMITED);
    await expect(limiter.assertPublicRequest("create", "other@x.vn", undefined)).resolves.toBeUndefined();
    expect([...counters.keys()].some((key) => key.includes("undefined"))).toBe(false);
  });

  it(`xin URL tải giấy tờ: tối đa ${MAX_UPLOADS_PER_APPLICATION} lần / hồ sơ / giờ`, async () => {
    const limiter = new OperatorApplicationRateLimiter(fakeRedis().redis);
    for (let attempt = 0; attempt < MAX_UPLOADS_PER_APPLICATION; attempt += 1) {
      await limiter.assertDocumentUpload("app-1");
    }
    expect(await statusOf(limiter.assertDocumentUpload("app-1"))).toEqual(LIMITED);
    await expect(limiter.assertDocumentUpload("app-2")).resolves.toBeUndefined();
  });

  it("Redis lỗi → 503, không cho qua", async () => {
    const limiter = new OperatorApplicationRateLimiter(fakeRedis(true).redis);
    expect(await statusOf(limiter.assertPublicRequest("create", "a@x.vn", "10.0.0.1"))).toEqual({
      status: 503,
      code: "SERVICE_UNAVAILABLE",
    });
    expect((await statusOf(limiter.assertDocumentUpload("app-1"))).status).toBe(503);
  });
});
