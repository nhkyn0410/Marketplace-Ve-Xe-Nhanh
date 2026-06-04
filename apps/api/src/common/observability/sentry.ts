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
    sendDefaultPii: false
  });
  Sentry.setTag("service", config.OTEL_SERVICE_NAME);
  Sentry.setTag("runtime", runtime);

  initialized = true;
}

export function isSentryInitialized(): boolean {
  return initialized;
}
