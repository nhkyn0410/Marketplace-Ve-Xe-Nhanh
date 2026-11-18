import { describe, expect, it, vi } from "vitest";
import { parseAppConfig } from "../../../config/env.config";
import { FcmJourneyDemoPush } from "./journey-demo-push";
import type { JourneyDemoSnapshot } from "@vexenhanh/types";

const mocks = vi.hoisted(() => ({ send: vi.fn(), initializeApp: vi.fn(() => ({ name: "demo-push" })) }));
vi.mock("firebase-admin/app", () => ({ getApps: () => [], initializeApp: mocks.initializeApp, cert: vi.fn() }));
vi.mock("firebase-admin/messaging", () => ({ getMessaging: () => ({ send: mocks.send }) }));

const snapshot: JourneyDemoSnapshot = {
  type: "journey_demo", schemaVersion: 1, sessionId: "f21839d3-b453-4a22-a5ab-2ceec29efeed", bookingId: "b21839d3-b453-4a22-a5ab-2ceec29efeed",
  revision: 3, stage: "travelling", routeLabel: "TP. HCM → Đà Lạt", provinceName: "Đồng Nai", etaAt: new Date(Date.now() + 180_000).toISOString(),
  progress: 500, updatedAt: new Date().toISOString(), expiresAt: new Date(Date.now() + 240_000).toISOString(), ended: false,
};

describe("FCM Android journey data-only", () => {
  it("gửi snapshot cùng collapse key và TTL, không có alert gây trùng thông báo", async () => {
    const push = new FcmJourneyDemoPush(parseAppConfig({ FCM_PROJECT_ID: "demo", FCM_CLIENT_EMAIL: "demo@example.com", FCM_PRIVATE_KEY: "test" }));
    mocks.send.mockResolvedValueOnce("message-1");
    await expect(push.send("token-secret", snapshot)).resolves.toBe("SENT");
    const payload = mocks.send.mock.calls.at(-1)![0];
    expect(payload).not.toHaveProperty("notification");
    expect(payload.data).toEqual({ type: "journey_demo", snapshot: JSON.stringify(snapshot) });
    expect(payload.android).toMatchObject({ priority: "high", collapseKey: "vxn-journey-demo" });
    expect(payload.android.ttl).toBeGreaterThan(0);
    mocks.send.mockRejectedValueOnce({ code: "messaging/registration-token-not-registered" });
    await expect(push.send("token-secret", snapshot)).resolves.toBe("UNREGISTERED");
    mocks.send.mockRejectedValueOnce(new Error("token-secret"));
    await expect(push.send("token-secret", snapshot)).rejects.toThrow("Journey demo push delivery failed.");
  });

  it("không giả gửi thành công khi thiếu Firebase", async () => {
    await expect(new FcmJourneyDemoPush(parseAppConfig({})).send("token-secret", snapshot)).resolves.toBe("UNAVAILABLE");
  });
});
