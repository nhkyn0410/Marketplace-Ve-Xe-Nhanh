import { describe, expect, it } from "vitest";
import { scrubSentryEvent } from "./sentry";

describe("scrubSentryEvent", () => {
  it("bỏ body request và header mang credential, giữ phần còn lại để debug", () => {
    const event = scrubSentryEvent({
      request: {
        url: "https://api.example.com/v1/auth/mfa/verify",
        method: "POST",
        data: { challengeToken: "challenge-secret", code: "123456" },
        headers: { Authorization: "Bearer jwt-secret", cookie: "sid=secret", "user-agent": "vitest" }
      }
    });

    expect(JSON.stringify(event)).not.toMatch(/secret|123456/);
    expect(event.request).toEqual({
      url: "https://api.example.com/v1/auth/mfa/verify",
      method: "POST",
      headers: { "user-agent": "vitest" }
    });
  });

  it("event không có request thì giữ nguyên", () => {
    const event: { message: string; request?: undefined } = { message: "boom" };
    expect(scrubSentryEvent(event)).toEqual({ message: "boom" });
  });
});
