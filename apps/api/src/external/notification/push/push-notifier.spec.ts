import { beforeEach, describe, expect, it, vi } from "vitest";
import { EventEmitter } from "node:events";
import { generateKeyPairSync, verify } from "node:crypto";
import { parseAppConfig } from "../../../config/env.config";
import { ServerPushNotifier } from "./push-notifier";

const mocks = vi.hoisted(() => ({ send: vi.fn(), initializeApp: vi.fn(() => ({ name: "push-test" })), cert: vi.fn(), connect: vi.fn() }));
vi.mock("firebase-admin/app", () => ({ getApps: () => [], initializeApp: mocks.initializeApp, cert: mocks.cert }));
vi.mock("firebase-admin/messaging", () => ({ getMessaging: () => ({ send: mocks.send }) }));
vi.mock("node:http2", () => ({ connect: mocks.connect }));
const message = { provider: "FCM", token: "secret-device-token", title: "Có cập nhật", body: "Mở ứng dụng", notificationId: "notification-id" };

describe("Adapter push FCM/APNs", () => {
  beforeEach(() => vi.clearAllMocks());
  it("không gọi nhà cung cấp khi chưa cấu hình", async () => {
    const notifier = new ServerPushNotifier(parseAppConfig({}));
    expect(await notifier.send(message)).toBe("UNAVAILABLE");
    expect(await notifier.send({ ...message, provider: "APNS" })).toBe("UNAVAILABLE");
    expect(mocks.send).not.toHaveBeenCalled();
  });
  it("FCM gửi khóa gom thông báo và nhận diện thiết bị không còn đăng ký", async () => {
    const notifier = new ServerPushNotifier(parseAppConfig({ FCM_PROJECT_ID: "test-project", FCM_CLIENT_EMAIL: "service@example.com", FCM_PRIVATE_KEY: "key" }));
    mocks.send.mockResolvedValueOnce("sent");
    expect(await notifier.send(message)).toBe("SENT");
    expect(mocks.send.mock.calls[0]![0]).toMatchObject({ token: message.token, data: { notificationId: message.notificationId }, android: { collapseKey: message.notificationId } });
    mocks.send.mockRejectedValueOnce({ code: "messaging/registration-token-not-registered" });
    expect(await notifier.send(message)).toBe("UNREGISTERED");
    mocks.send.mockRejectedValueOnce(new Error(message.token));
    await expect(notifier.send(message)).rejects.toThrow("FCM delivery failed (unknown).");
  });
  it("APNs ký ES256 và gửi HTTP/2 đúng topic, sandbox, mã gom thông báo", async () => {
    const { privateKey, publicKey } = generateKeyPairSync("ec", { namedCurve: "P-256" });
    const request = Object.assign(new EventEmitter(), { setEncoding: vi.fn(), end: vi.fn(() => queueMicrotask(() => { request.emit("response", { ":status": 200 }); request.emit("end"); })) });
    const session = Object.assign(new EventEmitter(), { request: vi.fn((_headers: Record<string, string>) => request), destroy: vi.fn() });
    mocks.connect.mockReturnValue(session);
    const notifier = new ServerPushNotifier(parseAppConfig({ APNS_TEAM_ID: "team", APNS_KEY_ID: "key", APNS_PRIVATE_KEY: privateKey.export({ type: "pkcs8", format: "pem" }).toString(), APNS_TOPIC: "com.vxn.passenger" }));
    expect(await notifier.send({ ...message, provider: "APNS", token: "a".repeat(64) })).toBe("SENT");
    expect(mocks.connect).toHaveBeenCalledWith("https://api.sandbox.push.apple.com");
    const headers = session.request.mock.calls[0]![0] as Record<string, string>;
    expect(headers).toMatchObject({ ":method": "POST", "apns-topic": "com.vxn.passenger", "apns-push-type": "alert", "apns-collapse-id": message.notificationId });
    const parts = headers.authorization!.slice(7).split(".");
    expect(JSON.parse(Buffer.from(parts[0]!, "base64url").toString())).toMatchObject({ alg: "ES256", kid: "key" });
    expect(verify("sha256", Buffer.from(`${parts[0]}.${parts[1]}`), { key: publicKey, dsaEncoding: "ieee-p1363" }, Buffer.from(parts[2]!, "base64url"))).toBe(true);
    expect(session.destroy).toHaveBeenCalled();
  });
});
