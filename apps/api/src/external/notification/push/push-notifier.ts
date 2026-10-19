import type { AppConfig } from "../../../config/env.config";
import { connect } from "node:http2";
import { cert, getApps, initializeApp } from "firebase-admin/app";
import { getMessaging } from "firebase-admin/messaging";

export const PUSH_NOTIFIER = Symbol("PUSH_NOTIFIER");
export type PushMessage = { provider: string; token: string; title: string; body: string; notificationId: string };
export interface PushNotifier { send(message: PushMessage): Promise<"SENT" | "UNREGISTERED" | "UNAVAILABLE"> }

/** Gửi push qua adapter FCM hoặc APNs theo cấu hình server, không ghi token vào log. */
export class ServerPushNotifier implements PushNotifier {
  constructor(private readonly config: AppConfig) {}

  /** Gửi một thông báo tới một thiết bị, phân biệt token hết hạn với lỗi tạm thời. */
  async send(message: PushMessage): Promise<"SENT" | "UNREGISTERED" | "UNAVAILABLE"> {
    return message.provider === "FCM" ? this.fcm(message) : this.apns(message);
  }

  private async fcm(message: PushMessage): Promise<"SENT" | "UNREGISTERED" | "UNAVAILABLE"> {
    const { FCM_PROJECT_ID: projectId, FCM_CLIENT_EMAIL: clientEmail, FCM_PRIVATE_KEY: privateKey } = this.config;
    if (!projectId || !clientEmail || !privateKey) return "UNAVAILABLE";
    const name = `vxn-push-${projectId}`;
    const app = getApps().find((item) => item.name === name) ?? initializeApp({ credential: cert({ projectId, clientEmail, privateKey: privateKey.replace(/\\n/g, "\n") }) }, name);
    try {
      await getMessaging(app).send({ token: message.token, notification: { title: message.title, body: message.body }, data: { notificationId: message.notificationId }, android: { collapseKey: message.notificationId }, apns: { headers: { "apns-collapse-id": message.notificationId } } });
      return "SENT";
    } catch (error) {
      const code = (error as { code?: string }).code;
      if (code === "messaging/registration-token-not-registered" || code === "messaging/invalid-registration-token") return "UNREGISTERED";
      throw new Error(`FCM delivery failed (${code ?? "unknown"}).`);
    }
  }

  private async apns(message: PushMessage): Promise<"SENT" | "UNREGISTERED" | "UNAVAILABLE"> {
    const { APNS_TEAM_ID: teamId, APNS_KEY_ID: keyId, APNS_PRIVATE_KEY: privateKey, APNS_TOPIC: topic } = this.config;
    if (!teamId || !keyId || !privateKey || !topic) return "UNAVAILABLE";
    const { importPKCS8, SignJWT } = await import("jose");
    const key = await importPKCS8(privateKey.replace(/\\n/g, "\n"), "ES256");
    const jwt = await new SignJWT({}).setProtectedHeader({ alg: "ES256", kid: keyId }).setIssuer(teamId).setIssuedAt().sign(key);
    return new Promise((resolve, reject) => {
      const session = connect(this.config.APNS_SANDBOX === "true" ? "https://api.sandbox.push.apple.com" : "https://api.push.apple.com");
      let settled = false;
      const finish = (error: Error | null, result?: "SENT" | "UNREGISTERED") => {
        if (settled) return;
        settled = true;
        clearTimeout(timer);
        session.destroy();
        if (error) reject(error); else resolve(result!);
      };
      const timer = setTimeout(() => finish(new Error("APNs request timed out.")), 10000);
      session.on("error", () => finish(new Error("APNs connection failed.")));
      const request = session.request({ ":method": "POST", ":path": `/3/device/${encodeURIComponent(message.token)}`, authorization: `bearer ${jwt}`, "apns-topic": topic, "apns-push-type": "alert", "apns-priority": "10", "apns-collapse-id": message.notificationId });
      let status = 0;
      let body = "";
      request.on("response", (headers) => { status = Number(headers[":status"]); });
      request.setEncoding("utf8");
      request.on("data", (chunk: string) => { body += chunk; });
      request.on("error", () => finish(new Error("APNs request failed.")));
      request.on("end", () => {
        const reason = (() => { try { return (JSON.parse(body) as { reason?: string }).reason; } catch { return undefined; } })();
        if (status === 200) finish(null, "SENT");
        else if (status === 410 || reason === "BadDeviceToken" || reason === "Unregistered") finish(null, "UNREGISTERED");
        else finish(new Error(`APNs delivery failed (${status}).`));
      });
      request.end(JSON.stringify({ aps: { alert: { title: message.title, body: message.body }, sound: "default" }, notificationId: message.notificationId }));
    });
  }
}
