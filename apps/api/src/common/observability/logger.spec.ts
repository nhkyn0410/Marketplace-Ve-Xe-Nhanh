import type { Logger } from "pino";
import { describe, expect, it, vi } from "vitest";
import { createAppLogger, createNestLogger } from "./logger";

describe("auth monitoring log shape", () => {
  it("puts Nest auth event fields under data for Render log queries", () => {
    const warn = vi.fn();
    const logger = createNestLogger({ warn } as unknown as Logger);

    logger.warn({
      event: "auth.proxy_ip_untrusted",
      cfRay: "test-ray-SIN"
    });

    expect(warn).toHaveBeenCalledWith(
      expect.objectContaining({
        data: { event: "auth.proxy_ip_untrusted", cfRay: "test-ray-SIN" }
      }),
      "auth.proxy_ip_untrusted"
    );
  });

  it("redacts secrets in Nest object logs without losing the event message", () => {
    const chunks: string[] = [];
    const write = vi.spyOn(process.stdout, "write").mockImplementation((chunk) => {
      chunks.push(String(chunk));
      return true;
    });

    try {
      const logger = createAppLogger(
        { LOG_LEVEL: "info", NODE_ENV: "production", OTEL_SERVICE_NAME: "test-api" },
        "api"
      );
      createNestLogger(logger).log({
        event: "auth.otp.delivery_disabled",
        otp: "otp-secret",
        password: "password-secret",
        token: "token-secret",
        accessToken: "access-secret",
        refreshToken: "refresh-secret",
        apiKey: "api-key-secret"
      });
    } finally {
      write.mockRestore();
    }

    const raw = chunks.join("");
    for (const secret of [
      "otp-secret", "password-secret", "token-secret", "access-secret", "refresh-secret", "api-key-secret"
    ]) {
      expect(raw).not.toContain(secret);
    }
    const record = JSON.parse(raw) as { data: Record<string, string>; msg: string };
    expect(record.msg).toBe("auth.otp.delivery_disabled");
    for (const key of ["otp", "password", "token", "accessToken", "refreshToken", "apiKey"]) {
      expect(record.data[key]).toBe("[Redacted]");
    }
  });

  it("redacts session cookies from HTTP response headers", () => {
    const chunks: string[] = [];
    const write = vi.spyOn(process.stdout, "write").mockImplementation((chunk) => {
      chunks.push(String(chunk));
      return true;
    });

    try {
      const logger = createAppLogger(
        { LOG_LEVEL: "info", NODE_ENV: "production", OTEL_SERVICE_NAME: "test-api" },
        "api"
      );
      logger.info({ res: { headers: { "set-cookie": ["session=secret-cookie; HttpOnly"] } } }, "request completed");
    } finally {
      write.mockRestore();
    }

    const raw = chunks.join("");
    expect(raw).not.toContain("secret-cookie");
    const record = JSON.parse(raw) as { res: { headers: Record<string, string> } };
    expect(record.res.headers["set-cookie"]).toBe("[Redacted]");
  });
});
