import type { ConnectionOptions } from "bullmq";
import type { RedisOptions } from "ioredis";
import { DEFAULT_REDIS_URL } from "./redis.constants";

const DEFAULT_BULLMQ_PREFIX = "vexenhanh";
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

export function createRequestRedisClientOptions(
  connectionName: string,
): RedisOptions {
  return {
    ...createRedisClientOptions(connectionName),
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
