import type { HttpException } from "@nestjs/common";
import type Redis from "ioredis";
import { beforeEach, describe, expect, it, vi } from "vitest";
import type { AppConfig } from "../../config/env.config";
import { REAUTH_PROOF_TTL_SECONDS, SessionCache } from "./session-cache";

const config = { JWT_ACCESS_TTL_SECONDS: 900 } as AppConfig;

async function statusOf(promise: Promise<unknown>): Promise<number> {
  try {
    await promise;
    return 0;
  } catch (error) {
    return (error as HttpException).getStatus();
  }
}

describe("SessionCache", () => {
  const batch = { set: vi.fn(), del: vi.fn(), exec: vi.fn() };
  const redis = {
    mget: vi.fn(),
    set: vi.fn(),
    exists: vi.fn(),
    multi: vi.fn(() => batch),
  };
  const cache = new SessionCache(redis as unknown as Redis, config);

  beforeEach(() => {
    vi.clearAllMocks();
    redis.set.mockResolvedValue("OK");
    batch.exec.mockResolvedValue([]);
  });

  it("khoá revoked thắng khoá active — lần ghi cache muộn không hồi sinh được phiên", async () => {
    redis.mget.mockResolvedValue(["1", "1"]);
    expect(await cache.lookup("s1")).toBe("revoked");
    expect(redis.mget).toHaveBeenCalledWith("session:revoked:s1", "session:s1");

    redis.mget.mockResolvedValue([null, "1"]);
    expect(await cache.lookup("s1")).toBe("active");

    redis.mget.mockResolvedValue([null, null]);
    expect(await cache.lookup("s1")).toBe("unknown");
  });

  it("markActive / markRevoked dùng TTL access token; revoke xoá luôn cache active + bằng chứng re-auth", async () => {
    await cache.markActive("s1");
    expect(redis.set).toHaveBeenCalledWith("session:s1", "1", "EX", 900);

    await cache.markRevoked(["s1", "s2"]);
    expect(batch.set).toHaveBeenCalledWith("session:revoked:s1", "1", "EX", 900);
    expect(batch.set).toHaveBeenCalledWith("session:revoked:s2", "1", "EX", 900);
    expect(batch.del).toHaveBeenCalledWith("session:s1", "reauth:s1");
    expect(batch.exec).toHaveBeenCalledOnce();
  });

  it("markRevoked với danh sách rỗng không chạm Redis", async () => {
    await cache.markRevoked([]);
    expect(redis.multi).not.toHaveBeenCalled();
  });

  it("bằng chứng re-auth sống 5 phút", async () => {
    await cache.grantReauth("s1");
    expect(redis.set).toHaveBeenCalledWith("reauth:s1", "1", "EX", REAUTH_PROOF_TTL_SECONDS);
    expect(REAUTH_PROOF_TTL_SECONDS).toBe(300);

    redis.exists.mockResolvedValue(1);
    expect(await cache.hasReauth("s1")).toBe(true);
  });

  it("Redis lỗi → 503 ở mọi thao tác, kể cả lỗi nằm TRONG kết quả MULTI", async () => {
    redis.mget.mockRejectedValue(new Error("Command timed out"));
    expect(await statusOf(cache.lookup("s1"))).toBe(503);

    redis.set.mockRejectedValue(new Error("Command timed out"));
    expect(await statusOf(cache.markActive("s1"))).toBe(503);
    expect(await statusOf(cache.grantReauth("s1"))).toBe(503);

    // `exec` không ném khi từng lệnh lỗi — bỏ qua mảng kết quả là tưởng đã revoke mà thật ra chưa.
    batch.exec.mockResolvedValue([[new Error("OOM"), null], [null, 1]]);
    expect(await statusOf(cache.markRevoked(["s1"]))).toBe(503);

    batch.exec.mockRejectedValue(new Error("Command timed out"));
    expect(await statusOf(cache.markRevoked(["s1"]))).toBe(503);
  });
});
