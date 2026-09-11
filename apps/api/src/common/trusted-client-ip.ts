import type { Request } from "express";
import { isIP } from "node:net";
import type { AppConfig } from "../config/env.config";

type ClientIpRequest = Pick<Request, "headers" | "ip">;

/**
 * Production chỉ dùng IP mà chuỗi proxy đã resolve và Cloudflare cùng xác nhận.
 * Khi topology bất thường, trả `undefined` để limiter vẫn đếm theo identifier
 * nhưng không gom người dùng vào một bucket IP proxy hoặc tin IP giả mạo.
 */
export function resolveTrustedClientIp(
  request: ClientIpRequest,
  environment: AppConfig["NODE_ENV"]
): string | undefined {
  const candidate = request.ip;
  if (!candidate || isIP(candidate) === 0) {
    return undefined;
  }

  if (environment !== "production") {
    return candidate;
  }

  const cfConnectingIp = request.headers["cf-connecting-ip"];
  if (typeof cfConnectingIp !== "string" || isIP(cfConnectingIp) === 0) {
    return undefined;
  }

  return candidate === cfConnectingIp ? candidate : undefined;
}
