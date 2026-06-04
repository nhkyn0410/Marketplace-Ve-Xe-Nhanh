import type { LoggerService } from "@nestjs/common";
import type { RequestHandler, Request, Response } from "express";
import pino, { type Logger, type LogFn } from "pino";
import pinoHttp from "pino-http";
import type { AppConfig } from "../../config/env.config";
import { getCurrentTraceId } from "./tracing";
import { getRequestId } from "./request-context";

type RuntimeName = "api" | "worker";
type PinoLogMethod = "fatal" | "error" | "warn" | "info" | "debug" | "trace";

const REDACT_PATHS = [
  "req.headers.authorization",
  "req.headers.cookie",
  "req.headers['x-bull-board-token']",
  "req.headers['x-api-key']",
  "authorization",
  "cookie",
  "password",
  "otp",
  "token",
  "accessToken",
  "refreshToken",
  "apiKey"
];

export function createAppLogger(
  config: Pick<AppConfig, "LOG_LEVEL" | "NODE_ENV" | "OTEL_SERVICE_NAME">,
  runtime: RuntimeName
): Logger {
  return pino({
    name: config.OTEL_SERVICE_NAME,
    level: config.LOG_LEVEL,
    base: {
      service: config.OTEL_SERVICE_NAME,
      runtime,
      environment: config.NODE_ENV
    },
    timestamp: pino.stdTimeFunctions.isoTime,
    redact: {
      paths: REDACT_PATHS,
      censor: "[Redacted]"
    }
  });
}

export function createNestLogger(logger: Logger): LoggerService {
  return new PinoNestLogger(logger);
}

export function createHttpLoggerMiddleware(logger: Logger): RequestHandler {
  const httpLogger = pinoHttp<Request, Response>({
    logger,
    quietReqLogger: true,
    genReqId: () => getRequestId() ?? "unknown",
    customAttributeKeys: {
      reqId: "requestId",
      responseTime: "durationMs"
    },
    customLogLevel: (_request, response, error) => {
      if (error || response.statusCode >= 500) {
        return "error";
      }

      if (response.statusCode >= 400) {
        return "warn";
      }

      return "info";
    },
    customProps: () => ({
      requestId: getRequestId(),
      traceId: getCurrentTraceId()
    })
  });

  return (request, response, next): void => {
    httpLogger(request, response, next);
  };
}

class PinoNestLogger implements LoggerService {
  constructor(private readonly logger: Logger) {}

  log(message: unknown, ...optionalParams: unknown[]): void {
    this.write("info", message, optionalParams);
  }

  error(message: unknown, ...optionalParams: unknown[]): void {
    this.write("error", message, optionalParams);
  }

  warn(message: unknown, ...optionalParams: unknown[]): void {
    this.write("warn", message, optionalParams);
  }

  debug(message: unknown, ...optionalParams: unknown[]): void {
    this.write("debug", message, optionalParams);
  }

  verbose(message: unknown, ...optionalParams: unknown[]): void {
    this.write("trace", message, optionalParams);
  }

  fatal(message: unknown, ...optionalParams: unknown[]): void {
    this.write("fatal", message, optionalParams);
  }

  private write(level: PinoLogMethod, message: unknown, optionalParams: unknown[]): void {
    const log = this.logger[level] as LogFn;
    const meta = buildLogMeta(level, message, optionalParams);
    const text = getLogMessage(message);

    log.call(this.logger, meta, text);
  }
}

function buildLogMeta(
  level: PinoLogMethod,
  message: unknown,
  optionalParams: unknown[]
): Record<string, unknown> {
  const meta: Record<string, unknown> = {
    requestId: getRequestId(),
    traceId: getCurrentTraceId(),
    context: getContext(optionalParams)
  };

  if (message instanceof Error) {
    meta.err = message;
  } else if (typeof message === "object" && message !== null) {
    meta.data = message;
  }

  if (level === "error") {
    meta.stack = getStack(optionalParams);
  }

  return meta;
}

function getLogMessage(message: unknown): string {
  if (message instanceof Error) {
    return message.message;
  }

  if (typeof message === "string") {
    return message;
  }

  return "Nest application log";
}

function getContext(optionalParams: unknown[]): string | undefined {
  const last = optionalParams.at(-1);
  return typeof last === "string" ? last : undefined;
}

function getStack(optionalParams: unknown[]): string | undefined {
  const first = optionalParams[0];
  return typeof first === "string" ? first : undefined;
}
