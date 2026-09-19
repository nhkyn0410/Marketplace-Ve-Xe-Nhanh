import * as Sentry from "@sentry/nestjs";
import type { AppConfig } from "../../config/env.config";

type RuntimeName = "api" | "worker";

let initialized = false;

export function initSentry(
  config: Pick<
    AppConfig,
    | "NODE_ENV"
    | "SENTRY_DSN"
    | "SENTRY_ENVIRONMENT"
    | "SENTRY_TRACES_SAMPLE_RATE"
    | "OTEL_SERVICE_NAME"
  >,
  runtime: RuntimeName
): void {
  if (initialized || !config.SENTRY_DSN) {
    return;
  }

  Sentry.init({
    dsn: config.SENTRY_DSN,
    environment: config.SENTRY_ENVIRONMENT ?? config.NODE_ENV,
    tracesSampleRate: config.SENTRY_TRACES_SAMPLE_RATE,
    sendDefaultPii: false,
    // Mặc định SDK đính kèm body request (≤10KB) vào event lỗi — với route auth đó là password,
    // OTP, refresh token, mã MFA, challenge token gửi sang bên thứ ba. `sendDefaultPii` KHÔNG tắt được.
    integrations: [Sentry.httpIntegration({ maxIncomingRequestBodySize: "none" })],
    beforeSend: scrubSentryEvent,
    beforeSendTransaction: scrubSentryEvent
  });
  Sentry.setTag("service", config.OTEL_SERVICE_NAME);
  Sentry.setTag("runtime", runtime);

  initialized = true;
}

const SENSITIVE_HEADERS = ["authorization", "cookie", "x-api-key", "x-bull-board-token"];

/** Lớp chặn cuối: bỏ body + header mang credential khỏi event, dù integration nào đã gắn vào. */
export function scrubSentryEvent<T extends { request?: { data?: unknown; headers?: Record<string, string> } }>(
  event: T
): T {
  if (event.request) {
    delete event.request.data;
    for (const name of Object.keys(event.request.headers ?? {})) {
      if (SENSITIVE_HEADERS.includes(name.toLowerCase())) {
        delete event.request.headers![name];
      }
    }
  }
  return event;
}

export function isSentryInitialized(): boolean {
  return initialized;
}
