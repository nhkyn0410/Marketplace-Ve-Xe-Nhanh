import type Redis from "ioredis";
import { describe, expect, it } from "vitest";
import {
  UPLOAD_URL_MAX,
  UPLOAD_URL_WINDOW_SECONDS,
  VehicleImageUploadLimiter,
} from "./vehicle-image-upload-limiter";

/** Redis giả chỉ đủ cho `MULTI SET NX EX; INCR`. `fail` để dựng tình huống Redis lỗi. */
function fakeRedis(fail: "none" | "throw" | "aborted" | "command" = "none") {
  const counters = new Map<string, number>();
  const ttl = new Map<string, number>();
  const redis = {
    multi() {
      const steps: (() => [Error | null, unknown])[] = [];
      const chain = {
        set(key: string, value: number, _ex: string, seconds: number, _nx: string) {
          steps.push(() => {
            if (!counters.has(key)) {
              counters.set(key, value);
              ttl.set(key, seconds);
            }
            return [null, "OK"];
          });
          return chain;
        },
        incr(key: string) {
          steps.push(() => {
            if (fail === "command") {
              return [new Error("WRONGTYPE"), null];
            }
            counters.set(key, (counters.get(key) ?? 0) + 1);
            return [null, counters.get(key)];
          });
          return chain;
        },
        async exec() {
          if (fail === "throw") {
            throw new Error("ECONNREFUSED");
          }
          return fail === "aborted" ? null : steps.map((step) => step());
        },
      };
      return chain;
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

describe("VehicleImageUploadLimiter", () => {
  it(`cho qua ${UPLOAD_URL_MAX} lần trong một cửa sổ, lần kế tiếp → 429; bộ đếm có hạn`, async () => {
    const { redis, ttl } = fakeRedis();
    const limiter = new VehicleImageUploadLimiter(redis);
    for (let attempt = 0; attempt < UPLOAD_URL_MAX; attempt += 1) {
      await limiter.assertWithinLimit("account-1");
    }
    expect(await statusOf(limiter.assertWithinLimit("account-1"))).toEqual({
      status: 429,
      code: "VEHICLE_IMAGE_UPLOAD_RATE_LIMITED",
    });
    expect([...ttl.values()]).toEqual([UPLOAD_URL_WINDOW_SECONDS]);
  });

  it("đếm riêng theo tài khoản", async () => {
    const { redis } = fakeRedis();
    const limiter = new VehicleImageUploadLimiter(redis);
    for (let attempt = 0; attempt < UPLOAD_URL_MAX; attempt += 1) {
      await limiter.assertWithinLimit("account-1");
    }
    await expect(limiter.assertWithinLimit("account-2")).resolves.toBeUndefined();
  });

  it.each(["throw", "aborted", "command"] as const)("Redis lỗi (%s) → 503, không cho qua", async (fail) => {
    const limiter = new VehicleImageUploadLimiter(fakeRedis(fail).redis);
    expect(await statusOf(limiter.assertWithinLimit("account-1"))).toEqual({
      status: 503,
      code: "SERVICE_UNAVAILABLE",
    });
  });
});
