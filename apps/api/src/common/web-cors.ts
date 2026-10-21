import type { INestApplication } from "@nestjs/common";
import { type AppConfig, webAllowedOrigins } from "../config/env.config";

/** Header web được gửi / được đọc (API §7.1.2). */
export const CORS_ALLOWED_HEADERS = [
  "Content-Type",
  "Authorization",
  "X-Auth-Transport",
  "X-CSRF-Token",
  "X-Request-Id",
  "Idempotency-Key",
  // Link bảo mật của hồ sơ đăng ký nhà xe (TASK-OPR-001) — trang đăng ký nằm trên origin của Operator OS.
  "X-Application-Token",
] as const;
// `Content-Disposition`: tên tệp khi tải danh sách hành khách (TASK-OPR-003) — trình duyệt chỉ cho JS đọc header được expose.
export const CORS_EXPOSED_HEADERS = ["X-CSRF-Token", "X-Request-Id", "Deprecation", "Content-Disposition"] as const;

/**
 * CORS credentialed cho Operator OS/Admin (TASK-IAM-006): echo đúng origin thuộc `OPERATOR_WEB_ORIGINS` ∪ `ADMIN_WEB_ORIGINS`
 * kèm `Vary: Origin`, tuyệt đối không `*`. Origin lạ không nhận header CORS nào → trình duyệt chặn.
 * Preflight `OPTIONS` được middleware trả lời trước khi tới guard nên không qua auth/CSRF.
 */
export function configureWebCors(
  app: Pick<INestApplication, "enableCors">,
  config: Pick<AppConfig, "OPERATOR_WEB_ORIGINS" | "ADMIN_WEB_ORIGINS">,
): void {
  const allowed = new Set(webAllowedOrigins(config));
  app.enableCors({
    origin: (origin: string | undefined, callback: (error: Error | null, allow?: string | boolean) => void) =>
      callback(null, origin !== undefined && allowed.has(origin) ? origin : false),
    credentials: true,
    methods: ["GET", "HEAD", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"],
    allowedHeaders: [...CORS_ALLOWED_HEADERS],
    exposedHeaders: [...CORS_EXPOSED_HEADERS],
    maxAge: 600,
  });
}
