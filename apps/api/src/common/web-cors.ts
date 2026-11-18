import type { INestApplication } from "@nestjs/common";
import type { CorsOptions } from "@nestjs/common/interfaces/external/cors-options.interface";
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
 * Route tải lên của kho ổ đĩa dev (`LocalStorageController`, thay presigned PUT của R2). Trình duyệt PUT thẳng tệp vào
 * đây từ origin của web — kể cả Marketplace (tệp đính kèm khiếu nại), origin không nằm trong danh sách credentialed.
 */
const DEV_STORAGE_UPLOAD_PATH = "/v1/dev-storage/upload";

type OriginCallback = (error: Error | null, allow?: string | boolean) => void;

/** Echo đúng origin thuộc danh sách (kèm `Vary: Origin`); origin lạ không nhận header CORS nào. */
function exactOrigin(allowed: ReadonlySet<string>) {
  return (origin: string | undefined, callback: OriginCallback) =>
    callback(null, origin !== undefined && allowed.has(origin) ? origin : false);
}

/**
 * CORS credentialed cho Operator OS/Admin (TASK-IAM-006): echo đúng origin thuộc `OPERATOR_WEB_ORIGINS` ∪ `ADMIN_WEB_ORIGINS`
 * kèm `Vary: Origin`, tuyệt đối không `*`. Origin lạ không nhận header CORS nào → trình duyệt chặn.
 * Preflight `OPTIONS` được middleware trả lời trước khi tới guard nên không qua auth/CSRF.
 * Riêng route tải lên của kho dev: thêm origin web hành khách (origin của `PAYMENT_RETURN_BASE_URL`), chỉ `PUT`, **không**
 * credentials — như CORS của bucket R2 cho presigned PUT; quyền ghi nằm ở token HMAC có hạn trong URL, không ở cookie.
 */
export function configureWebCors(
  app: Pick<INestApplication, "enableCors">,
  config: Pick<AppConfig, "OPERATOR_WEB_ORIGINS" | "ADMIN_WEB_ORIGINS" | "PAYMENT_RETURN_BASE_URL">,
): void {
  const allowed = new Set(webAllowedOrigins(config));
  const web: CorsOptions = {
    origin: exactOrigin(allowed),
    credentials: true,
    methods: ["GET", "HEAD", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"],
    allowedHeaders: [...CORS_ALLOWED_HEADERS],
    exposedHeaders: [...CORS_EXPOSED_HEADERS],
    maxAge: 600,
  };
  const devUpload: CorsOptions = {
    origin: exactOrigin(new Set([...allowed, new URL(config.PAYMENT_RETURN_BASE_URL).origin])),
    credentials: false,
    methods: ["PUT"],
    allowedHeaders: ["Content-Type"],
    maxAge: 600,
  };
  app.enableCors((request: { url?: string }, callback: (error: Error | null, options: CorsOptions) => void) =>
    callback(null, request.url?.split("?")[0] === DEV_STORAGE_UPLOAD_PATH ? devUpload : web),
  );
}
