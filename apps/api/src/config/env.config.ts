import { existsSync } from "node:fs";
import { resolve } from "node:path";
import { z } from "zod";

/** DI token cho cấu hình môi trường đã validate. */
export const APP_CONFIG = Symbol("APP_CONFIG");

/**
 * Schema env — nguồn chân lý cho biến môi trường app cần (Zod, ADR-010).
 * Connection string để `optional` ở foundation; siết `required` khi module tương ứng
 * được wire (DatabaseModule / MongoAuditModule) + provision dịch vụ thật.
 */
/** Coi chuỗi rỗng / toàn whitespace như "không set" (quy ước env phổ biến). */
const emptyToUndefined = (value: unknown): unknown =>
  typeof value === "string" && value.trim() === "" ? undefined : value;

const optionalString = z.preprocess(
  emptyToUndefined,
  z.string().min(1).optional(),
);

// So lại dạng chuẩn: Buffer.from bỏ qua bit đệm/ký tự lạ nên chuỗi gõ sai vẫn "decode được" thành key khác.
const optionalBase64Key32 = z.preprocess(
  emptyToUndefined,
  z
    .string()
    .regex(/^[A-Za-z0-9+/]+={0,2}$/, "must be standard base64")
    .refine(
      (value) => {
        const key = Buffer.from(value, "base64");
        return key.length === 32 && key.toString("base64") === value;
      },
      "must be canonical base64 of exactly 32 bytes",
    )
    .optional(),
);

/** Danh sách exact origin phân tách bằng dấu phẩy; rỗng = không set. */
const webOriginList = z.preprocess(
  (value) =>
    typeof value === "string" && value.trim().length > 0
      ? value
          .split(",")
          .map((origin) => origin.trim())
          .filter(Boolean)
      : undefined,
  z
    .array(z.string().refine(isExactOrigin, "must be an exact origin (scheme://host[:port], no path/wildcard)"))
    .min(1)
    .optional(),
);

export const envSchema = z
  .object({
    NODE_ENV: z.preprocess(
      emptyToUndefined,
      z.enum(["development", "test", "production"]).default("development"),
    ),
    PORT: z.preprocess(
      emptyToUndefined,
      z.coerce.number().int().positive().max(65535).default(3000),
    ),
    // Số proxy tin cậy tính từ socket gần app nhất. Local mặc định 0 (không tin forwarded IP).
    TRUST_PROXY_HOPS: z.preprocess(
      emptyToUndefined,
      z.coerce.number().int().nonnegative().default(0),
    ),

    // Postgres (Prisma) — operational DB
    DATABASE_URL: optionalString,
    // Mongo audit (Mongoose, cluster RIÊNG — ADR-011)
    MONGODB_AUDIT_URI: optionalString,

    // Redis / BullMQ (ADR-015 / ADR-016 — FND-004)
    REDIS_URL: optionalString,
    BULLMQ_PREFIX: optionalString,
    BULL_BOARD_TOKEN: optionalString,

    // Logging (Pino — ADR-026 / FND-006)
    LOG_LEVEL: z.preprocess(
      emptyToUndefined,
      z
        .enum(["fatal", "error", "warn", "info", "debug", "trace", "silent"])
        .default("info"),
    ),

    // Observability (ADR-026 — FND-006)
    SENTRY_DSN: optionalString,
    SENTRY_ENVIRONMENT: optionalString,
    SENTRY_TRACES_SAMPLE_RATE: z.preprocess(
      emptyToUndefined,
      z.coerce.number().min(0).max(1).default(0.1),
    ),
    OTEL_SERVICE_NAME: z.preprocess(
      emptyToUndefined,
      z.string().min(1).default("vexenhanh-api"),
    ),

    // ── IAM / Auth (TASK-IAM-001) ──
    // Better Auth (ADR-017). Secret bắt buộc ở production (validate khi wire).
    BETTER_AUTH_SECRET: optionalString,
    BETTER_AUTH_URL: z.preprocess(
      emptyToUndefined,
      z.url().default("http://localhost:3000"),
    ),
    // JWT access RS256 (Security §5.1). Key = PEM (raw hoặc base64). Thiếu ở dev → sinh ephemeral.
    JWT_ACCESS_PRIVATE_KEY: optionalString,
    JWT_ACCESS_PUBLIC_KEY: optionalString,
    JWT_ACCESS_TTL_SECONDS: z.preprocess(
      emptyToUndefined,
      z.coerce.number().int().positive().default(900),
    ),
    JWT_ISSUER: z.preprocess(
      emptyToUndefined,
      z.string().min(1).default("vexenhanh"),
    ),
    // Refresh token opaque (Security §5.1, ADR-017: 30 ngày). Mặc định = trần = 30 ngày:
    // env chỉ để RÚT NGẮN khi kiểm thử hết hạn, không để kéo dài một quyết định bảo mật.
    // Đặt vượt trần thì app không khởi động (fail-fast), thay vì âm thầm cấp phiên 1 năm.
    REFRESH_TOKEN_TTL_SECONDS: z.preprocess(
      emptyToUndefined,
      z.coerce
        .number()
        .int()
        .positive()
        .max(30 * 24 * 60 * 60)
        .default(30 * 24 * 60 * 60),
    ),
    // AES-256-GCM key mã hóa TOTP secret (TASK-IAM-004). Production bắt buộc tách khỏi
    // BETTER_AUTH_SECRET; dev thiếu key thì MfaService mới dùng derivation ổn định có domain separation.
    MFA_ENCRYPTION_KEY: optionalBase64Key32,
    // OAuth Passenger (ADR-020) — v1 chỉ Google; Facebook/Apple defer v1.x (ADR-028: v1 không lên
    // store nên App Store Guideline 4.8 không ép Apple Sign-In). Giữ biến để bật lại không cần sửa schema.
    GOOGLE_CLIENT_ID: optionalString,
    GOOGLE_CLIENT_SECRET: optionalString,
    FACEBOOK_CLIENT_ID: optionalString,
    FACEBOOK_CLIENT_SECRET: optionalString,
    APPLE_CLIENT_ID: optionalString,
    APPLE_CLIENT_SECRET: optionalString,
    /**
     * Origin được phép nhận redirect sau OAuth. `callbackURL` do client gửi lên KHÔNG được tin:
     * Better Auth lưu nguyên nó vào state rồi redirect tới đó sau khi đã set session cookie
     * → open redirect ở trạng thái đã đăng nhập (nền phishing rất thuyết phục). Mặc định chỉ
     * localhost cho dev; production phải khai tường minh.
     */
    AUTH_ALLOWED_CALLBACK_ORIGINS: z.preprocess(
      (value) =>
        typeof value === "string" && value.trim().length > 0
          ? value
              .split(",")
              .map((origin) => origin.trim())
              .filter(Boolean)
          : undefined,
      z
        .array(z.string().min(1))
        .default([
          "http://localhost:3000",
          "vexenhanh://",
          "vexenhanh-operator://",
        ]),
    ),
    // Email OTP delivery (Resend required for delivery; dev fallback never prints OTP).
    RESEND_API_KEY: optionalString,
    FCM_PROJECT_ID: optionalString,
    FCM_CLIENT_EMAIL: z.preprocess(emptyToUndefined, z.email().optional()),
    FCM_PRIVATE_KEY: optionalString,
    APNS_TEAM_ID: optionalString,
    APNS_KEY_ID: optionalString,
    APNS_PRIVATE_KEY: optionalString,
    APNS_TOPIC: optionalString,
    APNS_SANDBOX: z.enum(["true", "false"]).default("true"),
    RESEND_FROM_EMAIL: z.preprocess(
      emptyToUndefined,
      z.email().default("no-reply@vexenhanh.com"),
    ),
    // Goong REST (ADR-027, TASK-TRN-002): tính khoảng cách/thời gian khi cấu hình route. Thiếu ở dev →
    // ước lượng đường chim bay (Q8); production bắt buộc để số liệu route không phải ước lượng.
    GOONG_API_KEY: optionalString,
    // Web auth cookie mode (TASK-IAM-006, API §7.1.2, Deploy §4). Exact origin của TỪNG app web (không wildcard,
    // không path) — tách theo app để phiên cookie chỉ dùng được từ đúng cổng của scope (operator ↔ Operator OS,
    // platform ↔ Admin). Thiếu ở dev/test → localhost 3002/3003; production bắt buộc khai HTTPS.
    // KHÔNG dùng lại AUTH_ALLOWED_CALLBACK_ORIGINS (danh sách redirect OAuth, khác mục đích).
    OPERATOR_WEB_ORIGINS: webOriginList,
    ADMIN_WEB_ORIGINS: webOriginList,
    // Khoá HMAC ký CSRF token double-submit (base64 32 byte, tách khỏi mọi key khác). Thiếu ở dev → ephemeral.
    WEB_CSRF_SECRET: optionalBase64Key32,
    // Kho object công khai — Cloudflare R2 (ADR-018, TASK-TRN-009). Đủ cả năm biến → dùng R2; bỏ trống cả năm →
    // lưu ổ đĩa local ở `STORAGE_LOCAL_DIR` (chỉ dev / test); production bắt buộc đủ.
    R2_ACCOUNT_ID: optionalString,
    R2_ACCESS_KEY_ID: optionalString,
    R2_SECRET_ACCESS_KEY: optionalString,
    R2_PUBLIC_BUCKET: optionalString,
    // Gốc địa chỉ công khai của bucket (CDN / custom domain), vd `https://cdn.vexenhanh.com`.
    R2_PUBLIC_BASE_URL: z.preprocess(emptyToUndefined, z.url().optional()),
    STORAGE_LOCAL_DIR: optionalString,
    // Bucket private cho giấy tờ KYC (ADR-018, TASK-OPR-001), dùng chung tài khoản R2 ở trên. Production chưa khai
    // thì API tải / xem giấy tờ trả 503 — nơi lưu KYC production chờ OQ-21; dev / test bỏ trống thì lưu ổ đĩa.
    R2_PRIVATE_BUCKET: optionalString,
    // Hạn dùng link bảo mật của hồ sơ đăng ký nhà xe (Security §5: mặc định 72 giờ; DB chặn quá 30 ngày).
    OPERATOR_APPLICATION_LINK_TTL_HOURS: z.preprocess(
      emptyToUndefined,
      z.coerce.number().int().positive().max(720).default(72),
    ),
    // Cổng thanh toán (ADR-019, TASK-BTP-003). Tới khi có giấy phép trung gian thanh toán (OQ-22) chỉ dùng sandbox:
    // URL mặc định là sandbox. Thiếu khóa một cổng → cổng đó tắt (tạo payment trả 503); riêng dev / test thiếu khóa thì
    // dùng cổng giả lập trong API (`/v1/dev/payment-gateway/*`) — KHÔNG bao giờ ở production. IPN của MoMo gửi về
    // `BETTER_AUTH_URL` (origin công khai của API); IPN VNPay khai ở cổng quản trị merchant.
    VNPAY_TMN_CODE: optionalString,
    VNPAY_HASH_SECRET: optionalString,
    VNPAY_PAYMENT_URL: z.preprocess(emptyToUndefined, z.url().default("https://sandbox.vnpayment.vn/paymentv2/vpcpay.html")),
    // API truy vấn / hoàn tiền của VNPay (TASK-BTP-005).
    VNPAY_API_URL: z.preprocess(emptyToUndefined, z.url().default("https://sandbox.vnpayment.vn/merchant_webapi/api/transaction")),
    MOMO_PARTNER_CODE: optionalString,
    MOMO_ACCESS_KEY: optionalString,
    MOMO_SECRET_KEY: optionalString,
    MOMO_ENDPOINT: z.preprocess(emptyToUndefined, z.url().default("https://test-payment.momo.vn")),
    // payOS không có sandbox riêng: chỉ thử tiền thật ở local trước khi giải quyết OQ-22.
    PAYOS_CLIENT_ID: optionalString,
    PAYOS_API_KEY: optionalString,
    PAYOS_CHECKSUM_KEY: optionalString,
    PAYOS_API_URL: z.preprocess(emptyToUndefined, z.url().default("https://api-merchant.payos.vn")),
    PAYMENT_DEMO_ENABLED: z.preprocess(emptyToUndefined, z.enum(["true", "false"]).default("false").transform((value) => value === "true")),
    // Gốc web Marketplace: cổng đưa khách về `{gốc}/bookings/{bookingId}/payment/result` (chỉ hiển thị kết quả).
    PAYMENT_RETURN_BASE_URL: z.preprocess(emptyToUndefined, z.url().default("http://localhost:3001")),
    // Khóa HMAC sinh QR vé (TASK-BTP-004, BR-29; base64 32 byte, tách khỏi mọi khóa khác). Đổi khóa = mọi QR cũ mất hiệu
    // lực. Thiếu ở dev / test → khóa cố định chỉ cho dev (QR vẫn đúng sau khi khởi động lại); production bắt buộc.
    TICKET_QR_SECRET: optionalBase64Key32,
  })
  .superRefine((env, ctx) => {
    // Một origin thuộc cả hai app thì không biết ràng phiên với scope nào → từ chối ở mọi môi trường.
    const operatorOrigins = new Set(env.OPERATOR_WEB_ORIGINS ?? []);
    if ((env.ADMIN_WEB_ORIGINS ?? []).some((origin) => operatorOrigins.has(origin))) {
      ctx.addIssue({
        code: "custom",
        path: ["ADMIN_WEB_ORIGINS"],
        message: "OPERATOR_WEB_ORIGINS and ADMIN_WEB_ORIGINS must not share an origin.",
      });
    }
    // Khai dở cấu hình R2 thì từ chối ở mọi môi trường: nếu lặng lẽ rơi về ổ đĩa local, file "đã tải lên"
    // sẽ không nằm ở R2 như người cấu hình tưởng.
    const r2Keys = [
      "R2_ACCOUNT_ID",
      "R2_ACCESS_KEY_ID",
      "R2_SECRET_ACCESS_KEY",
      "R2_PUBLIC_BUCKET",
      "R2_PUBLIC_BASE_URL",
    ] as const;
    const r2Set = r2Keys.filter((key) => env[key]);
    if (r2Set.length > 0 && r2Set.length < r2Keys.length) {
      for (const key of r2Keys.filter((name) => !env[name])) {
        ctx.addIssue({ code: "custom", path: [key], message: `${key} is required when any R2_* variable is set.` });
      }
    }
    // Khai dở khóa một cổng thanh toán → từ chối (không lặng lẽ tắt cổng / rơi về cổng giả lập).
    for (const keys of [
      ["VNPAY_TMN_CODE", "VNPAY_HASH_SECRET"],
      ["MOMO_PARTNER_CODE", "MOMO_ACCESS_KEY", "MOMO_SECRET_KEY"],
      ["PAYOS_CLIENT_ID", "PAYOS_API_KEY", "PAYOS_CHECKSUM_KEY"],
      ["FCM_PROJECT_ID", "FCM_CLIENT_EMAIL", "FCM_PRIVATE_KEY"],
      ["APNS_TEAM_ID", "APNS_KEY_ID", "APNS_PRIVATE_KEY", "APNS_TOPIC"],
    ] as const) {
      if (keys.some((key) => env[key]) && !keys.every((key) => env[key])) {
        for (const key of keys.filter((name) => !env[name])) {
          ctx.addIssue({ code: "custom", path: [key], message: `${key} is required when the gateway is configured.` });
        }
      }
    }
    if (env.NODE_ENV === "production" && env.PAYOS_CLIENT_ID) {
      ctx.addIssue({ code: "custom", path: ["PAYOS_CLIENT_ID"], message: "Live payOS is restricted to local development until OQ-22 is resolved." });
    }
    if (env.PAYMENT_DEMO_ENABLED && env.PAYOS_CLIENT_ID) {
      ctx.addIssue({ code: "custom", path: ["PAYMENT_DEMO_ENABLED"], message: "Demo payments cannot be enabled with live payOS credentials." });
    }
    // Production fail-fast: secret/key bắt buộc, base URL phải https non-localhost (sec H1/M4).
    if (env.NODE_ENV !== "production") {
      return;
    }
    if (r2Set.length === 0) {
      for (const key of r2Keys) {
        ctx.addIssue({ code: "custom", path: [key], message: `${key} is required in production.` });
      }
    }
    // RESEND_API_KEY bắt buộc: production không được rơi về dev fallback không gửi OTP.
    for (const key of [
      "BETTER_AUTH_SECRET",
      "JWT_ACCESS_PRIVATE_KEY",
      "MFA_ENCRYPTION_KEY",
      "RESEND_API_KEY",
      "GOONG_API_KEY",
      "WEB_CSRF_SECRET",
      "OPERATOR_WEB_ORIGINS",
      "ADMIN_WEB_ORIGINS",
      "TICKET_QR_SECRET",
    ] as const) {
      if (!env[key]) {
        ctx.addIssue({
          code: "custom",
          path: [key],
          message: `${key} is required in production.`,
        });
      }
    }
    for (const key of ["OPERATOR_WEB_ORIGINS", "ADMIN_WEB_ORIGINS"] as const) {
      for (const origin of env[key] ?? []) {
        if (!origin.startsWith("https://") || origin.includes("localhost")) {
          ctx.addIssue({
            code: "custom",
            path: [key],
            message: `${key} must list non-localhost HTTPS origins in production.`,
          });
        }
      }
    }
    if (
      env.WEB_CSRF_SECRET &&
      (env.WEB_CSRF_SECRET === env.MFA_ENCRYPTION_KEY || env.WEB_CSRF_SECRET === env.BETTER_AUTH_SECRET)
    ) {
      ctx.addIssue({
        code: "custom",
        path: ["WEB_CSRF_SECRET"],
        message: "WEB_CSRF_SECRET must be separate from other secrets.",
      });
    }
    if (
      env.BETTER_AUTH_URL.startsWith("http://") ||
      env.BETTER_AUTH_URL.includes("localhost")
    ) {
      ctx.addIssue({
        code: "custom",
        path: ["BETTER_AUTH_URL"],
        message:
          "BETTER_AUTH_URL must be a non-localhost HTTPS URL in production.",
      });
    }
  });

export type AppConfig = z.infer<typeof envSchema>;

/** Origin mặc định cho dev/test khi chưa khai env (Deploy §4: Operator OS 3002, Admin 3003). */
export const LOCAL_OPERATOR_WEB_ORIGIN = "http://localhost:3002";
export const LOCAL_ADMIN_WEB_ORIGIN = "http://localhost:3003";

type WebOriginConfig = Pick<AppConfig, "OPERATOR_WEB_ORIGINS" | "ADMIN_WEB_ORIGINS">;

/** Origin web → scope phiên được phép dùng từ origin đó (operator ↔ Operator OS, platform ↔ Admin). */
export function webOriginScopes(config: WebOriginConfig): ReadonlyMap<string, "operator" | "platform"> {
  return new Map<string, "operator" | "platform">([
    ...(config.OPERATOR_WEB_ORIGINS ?? [LOCAL_OPERATOR_WEB_ORIGIN]).map((origin) => [origin, "operator"] as const),
    ...(config.ADMIN_WEB_ORIGINS ?? [LOCAL_ADMIN_WEB_ORIGIN]).map((origin) => [origin, "platform"] as const),
  ]);
}

/** Danh sách origin web được phép gọi API bằng cookie (CORS + kiểm `Origin` của CSRF). */
export function webAllowedOrigins(config: WebOriginConfig): readonly string[] {
  return [...webOriginScopes(config).keys()];
}

/** Origin hợp lệ = đúng dạng `scheme://host[:port]` mà trình duyệt gửi trong header `Origin`. */
function isExactOrigin(value: string): boolean {
  try {
    const url = new URL(value);
    return (url.protocol === "https:" || url.protocol === "http:") && url.origin === value;
  } catch {
    return false;
  }
}

/** Parse + validate env (fail-fast, thông báo rõ). Tách khỏi I/O để unit-test được. */
export function parseAppConfig(
  source: Record<string, unknown> = process.env,
): AppConfig {
  const result = envSchema.safeParse(source);

  if (!result.success) {
    const issues = result.error.issues
      .map(
        (issue) => `  - ${issue.path.join(".") || "(root)"}: ${issue.message}`,
      )
      .join("\n");
    throw new Error(`Invalid environment configuration:\n${issues}`);
  }

  return result.data;
}

let cached: AppConfig | undefined;

/**
 * Nạp env 2 phần rồi validate (Node 24 `process.loadEnvFile`):
 *   1) `.env`            → chọn môi trường (`NODE_ENV`).
 *   2) `.env.{NODE_ENV}` → giá trị theo môi trường (vd `.env.development`).
 * Precedence (cao→thấp): env thật (shell/Render) > `.env` > `.env.{NODE_ENV}`
 * (`loadEnvFile` KHÔNG override biến đã set). Trên Render/Docker không có file
 * `.env*` (đã .gitignore + .dockerignore) → đọc env thật từ env group/secrets.
 * Kết quả được cache (gọi nhiều lần an toàn).
 */
export function loadAppConfig(): AppConfig {
  if (cached) {
    return cached;
  }

  const cwd = process.cwd();
  loadEnvFileIfExists(resolve(cwd, ".env"));

  const nodeEnv = process.env.NODE_ENV?.trim() || "development";
  loadEnvFileIfExists(resolve(cwd, `.env.${nodeEnv}`));

  cached = parseAppConfig(process.env);
  return cached;
}

function loadEnvFileIfExists(path: string): void {
  if (existsSync(path)) {
    process.loadEnvFile(path);
  }
}
