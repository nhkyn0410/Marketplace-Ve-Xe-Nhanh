import { describe, expect, it } from "vitest";
import { parseAppConfig } from "./env.config";

describe("parseAppConfig", () => {
  it("applies defaults when env is empty", () => {
    const config = parseAppConfig({});

    expect(config.NODE_ENV).toBe("development");
    expect(config.PORT).toBe(3000);
    expect(config.TRUST_PROXY_HOPS).toBe(0);
    expect(config.DATABASE_URL).toBeUndefined();
    expect(config.LOG_LEVEL).toBe("info");
    expect(config.SENTRY_TRACES_SAMPLE_RATE).toBe(0.1);
    expect(config.OTEL_SERVICE_NAME).toBe("vexenhanh-api");
  });

  it("coerces PORT to a number", () => {
    expect(parseAppConfig({ PORT: "8080" }).PORT).toBe(8080);
  });

  it("coerces TRUST_PROXY_HOPS to a non-negative integer", () => {
    expect(parseAppConfig({ TRUST_PROXY_HOPS: "3" }).TRUST_PROXY_HOPS).toBe(3);
    expect(() => parseAppConfig({ TRUST_PROXY_HOPS: "-1" })).toThrow(/Invalid environment/);
    expect(() => parseAppConfig({ TRUST_PROXY_HOPS: "1.5" })).toThrow(/Invalid environment/);
  });

  it("rejects an invalid PORT", () => {
    expect(() => parseAppConfig({ PORT: "not-a-number" })).toThrow(/Invalid environment/);
  });

  it("rejects an unknown NODE_ENV", () => {
    expect(() => parseAppConfig({ NODE_ENV: "staging" })).toThrow(/Invalid environment/);
  });

  it("rejects an invalid LOG_LEVEL", () => {
    expect(() => parseAppConfig({ LOG_LEVEL: "loud" })).toThrow(/Invalid environment/);
  });

  it("rejects an invalid SENTRY_TRACES_SAMPLE_RATE", () => {
    expect(() => parseAppConfig({ SENTRY_TRACES_SAMPLE_RATE: "2" })).toThrow(
      /Invalid environment/
    );
  });

  it("keeps optional connection strings when provided", () => {
    const config = parseAppConfig({
      DATABASE_URL: "postgresql://u:p@localhost:5432/db?schema=public",
      REDIS_URL: "redis://localhost:6379"
    });

    expect(config.DATABASE_URL).toBe("postgresql://u:p@localhost:5432/db?schema=public");
    expect(config.REDIS_URL).toBe("redis://localhost:6379");
  });

  it("treats empty / whitespace strings as unset", () => {
    const config = parseAppConfig({ DATABASE_URL: "   ", PORT: "", SENTRY_DSN: "" });

    expect(config.SENTRY_DSN).toBeUndefined();
    expect(config.DATABASE_URL).toBeUndefined();
    expect(config.PORT).toBe(3000);
  });
});
