import { trace } from "@opentelemetry/api";

export function getTracer(serviceName: string) {
  return trace.getTracer(serviceName);
}

export function getCurrentTraceId(): string | undefined {
  const spanContext = trace.getActiveSpan()?.spanContext();

  if (!spanContext || spanContext.traceId === "00000000000000000000000000000000") {
    return undefined;
  }

  return spanContext.traceId;
}
