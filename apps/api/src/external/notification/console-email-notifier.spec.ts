import { Logger } from "@nestjs/common";
import { describe, expect, it, vi } from "vitest";
import { ConsoleEmailNotifier } from "./console-email-notifier";

describe("ConsoleEmailNotifier", () => {
  it("never writes an OTP to the console when Resend is not configured", async () => {
    vi.stubEnv("NODE_ENV", "development");
    const log = vi.spyOn(Logger.prototype, "log").mockImplementation(() => undefined);
    const warn = vi.spyOn(Logger.prototype, "warn").mockImplementation(() => undefined);

    try {
      await expect(
        new ConsoleEmailNotifier().sendOtp({
          email: "person@example.com",
          otp: "123456",
          purpose: "sign-in"
        })
      ).rejects.toThrow(/RESEND_API_KEY/);
      expect(JSON.stringify([...log.mock.calls, ...warn.mock.calls])).not.toContain("123456");
    } finally {
      log.mockRestore();
      warn.mockRestore();
      vi.unstubAllEnvs();
    }
  });
});
