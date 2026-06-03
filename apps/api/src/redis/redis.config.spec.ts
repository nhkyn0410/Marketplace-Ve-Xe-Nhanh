import { describe, expect, it } from "vitest";
import {
  createBullMqConnectionOptions,
  createRedisClientOptions,
  getBullMqPrefix,
  getRedisUrl
} from "./redis.config";
import { DEFAULT_REDIS_URL } from "./redis.constants";

describe("redis config", () => {
  it("uses local Redis defaults when env is empty", () => {
    expect(getRedisUrl({})).toBe(DEFAULT_REDIS_URL);
    expect(getBullMqPrefix({})).toBe("vexenhanh");
  });

  it("trims configured Redis URL and BullMQ prefix", () => {
    const env = {
      BULLMQ_PREFIX: " custom-prefix ",
      REDIS_URL: " rediss://default:secret@example.upstash.io:6379 "
    };

    expect(getRedisUrl(env)).toBe("rediss://default:secret@example.upstash.io:6379");
    expect(getBullMqPrefix(env)).toBe("custom-prefix");
  });

  it("sets Redis options expected by BullMQ and ioredis", () => {
    expect(createRedisClientOptions("test-client")).toEqual({
      connectionName: "test-client",
      enableReadyCheck: false,
      lazyConnect: true,
      maxRetriesPerRequest: null
    });

    expect(createBullMqConnectionOptions("test-bull", { REDIS_URL: "redis://cache:6379" })).toEqual({
      connectionName: "test-bull",
      enableReadyCheck: false,
      lazyConnect: true,
      maxRetriesPerRequest: null,
      url: "redis://cache:6379"
    });
  });
});

