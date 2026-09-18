import type { ConnectionOptions } from "bullmq";
import type { RedisOptions } from "ioredis";

/** DI token của client ioredis dùng chung cho đường request (rate limit, phiên). */
export const REDIS_CLIENT = Symbol("REDIS_CLIENT");

export const DEFAULT_REDIS_URL = "redis://localhost:6379";
const DEFAULT_BULLMQ_PREFIX = "vexenhanh";
/** Chờ Redis tối đa bao lâu trên đường request trước khi trả 503. */
const REQUEST_REDIS_COMMAND_TIMEOUT_MS = 1000;

type Env = Record<string, string | undefined>;

export function getRedisUrl(env: Env = process.env): string {
  return env.REDIS_URL?.trim() || DEFAULT_REDIS_URL;
}

export function getBullMqPrefix(env: Env = process.env): string {
  return env.BULLMQ_PREFIX?.trim() || DEFAULT_BULLMQ_PREFIX;
}

export function createRedisClientOptions(connectionName: string): RedisOptions {
  return {
    connectionName,
    enableReadyCheck: false,
    lazyConnect: true,
    maxRetriesPerRequest: null,
  };
}

/**
 * Client cho đường request (rate limit, phiên). KHÁC BullMQ ở ba option — BullMQ bắt buộc
 * `maxRetriesPerRequest: null` cho lệnh blocking nên KHÔNG được sửa `createRedisClientOptions`.
 * Đo 17/09/2026 (Redis dừng rồi chạy lại, ioredis 5.11):
 * - `maxRetriesPerRequest: null` → Redis chết thì lệnh xếp hàng CHỜ MÃI, request treo thay vì 503.
 * - `commandTimeout` → cần cho ca Redis chết giữa chừng mà TCP vẫn mở (chỉ `retries: 1` vẫn treo).
 * - `enableReadyCheck: true` → với `false`, client kẹt ở trạng thái "ready" không có kết nối thật
 *   sau lần reconnect hụt: Redis sống lại rồi mà API vẫn 503 MÃI tới khi restart. Bật lên thì hồi
 *   phục sau ~2 giây.
 */
export function createRequestRedisClientOptions(
  connectionName: string,
): RedisOptions {
  return {
    ...createRedisClientOptions(connectionName),
    enableReadyCheck: true,
    maxRetriesPerRequest: 1,
    commandTimeout: REQUEST_REDIS_COMMAND_TIMEOUT_MS,
  };
}

export function createBullMqConnectionOptions(
  connectionName: string,
  env: Env = process.env,
): ConnectionOptions {
  return {
    ...createRedisClientOptions(connectionName),
    url: getRedisUrl(env),
  };
}
