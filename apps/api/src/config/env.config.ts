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

const optionalString = z.preprocess(emptyToUndefined, z.string().min(1).optional());

export const envSchema = z.object({
  NODE_ENV: z.preprocess(
    emptyToUndefined,
    z.enum(["development", "test", "production"]).default("development")
  ),
  PORT: z.preprocess(
    emptyToUndefined,
    z.coerce.number().int().positive().max(65535).default(3000)
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
    z.enum(["fatal", "error", "warn", "info", "debug", "trace", "silent"]).default("info")
  ),

  // Observability (ADR-026 — FND-006)
  SENTRY_DSN: optionalString,
  SENTRY_ENVIRONMENT: optionalString,
  SENTRY_TRACES_SAMPLE_RATE: z.preprocess(
    emptyToUndefined,
    z.coerce.number().min(0).max(1).default(0.1)
  ),
  OTEL_SERVICE_NAME: z.preprocess(
    emptyToUndefined,
    z.string().min(1).default("vexenhanh-api")
  ),

  // ── IAM / Auth (TASK-IAM-001) ──
  // Better Auth (ADR-017). Secret bắt buộc ở production (validate khi wire).
  BETTER_AUTH_SECRET: optionalString,
  BETTER_AUTH_URL: z.preprocess(
    emptyToUndefined,
    z.url().default("http://localhost:3000")
  ),
  // JWT access RS256 (Security §5.1). Key = PEM (raw hoặc base64). Thiếu ở dev → sinh ephemeral.
  JWT_ACCESS_PRIVATE_KEY: optionalString,
  JWT_ACCESS_PUBLIC_KEY: optionalString,
  JWT_ACCESS_TTL_SECONDS: z.preprocess(
    emptyToUndefined,
    z.coerce.number().int().positive().default(900)
  ),
  JWT_ISSUER: z.preprocess(emptyToUndefined, z.string().min(1).default("vexenhanh")),
  // OAuth Passenger (ADR-020) — optional, chỉ bật provider khi có credential.
  GOOGLE_CLIENT_ID: optionalString,
  GOOGLE_CLIENT_SECRET: optionalString,
  FACEBOOK_CLIENT_ID: optionalString,
  FACEBOOK_CLIENT_SECRET: optionalString,
  APPLE_CLIENT_ID: optionalString,
  APPLE_CLIENT_SECRET: optionalString,
  // Email OTP delivery (Resend optional; dev = console adapter).
  RESEND_API_KEY: optionalString,
  RESEND_FROM_EMAIL: z.preprocess(
    emptyToUndefined,
    z.email().default("no-reply@vexenhanh.com")
  )
});

export type AppConfig = z.infer<typeof envSchema>;

/** Parse + validate env (fail-fast, thông báo rõ). Tách khỏi I/O để unit-test được. */
export function parseAppConfig(source: Record<string, unknown> = process.env): AppConfig {
  const result = envSchema.safeParse(source);

  if (!result.success) {
    const issues = result.error.issues
      .map((issue) => `  - ${issue.path.join(".") || "(root)"}: ${issue.message}`)
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
