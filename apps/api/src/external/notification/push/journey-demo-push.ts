import type { AppConfig } from "../../../config/env.config";
import type { JourneyDemoSnapshot } from "@vexenhanh/types";
import { cert, getApps, initializeApp } from "firebase-admin/app";
import { getMessaging } from "firebase-admin/messaging";

export const JOURNEY_DEMO_PUSH = Symbol("JOURNEY_DEMO_PUSH");
export interface JourneyDemoPush {
  send(token: string, snapshot: JourneyDemoSnapshot): Promise<"SENT" | "UNREGISTERED" | "UNAVAILABLE">;
}

/** FCM data-only: native cập nhật một thẻ; không tạo thêm alert mặc định. */
export class FcmJourneyDemoPush implements JourneyDemoPush {
  constructor(private readonly config: AppConfig) {}

  async send(token: string, snapshot: JourneyDemoSnapshot): Promise<"SENT" | "UNREGISTERED" | "UNAVAILABLE"> {
    const { FCM_PROJECT_ID: projectId, FCM_CLIENT_EMAIL: clientEmail, FCM_PRIVATE_KEY: privateKey } = this.config;
    if (!projectId || !clientEmail || !privateKey) return "UNAVAILABLE";
    const name = `vxn-push-${projectId}`;
    const app = getApps().find((item) => item.name === name) ?? initializeApp({ credential: cert({ projectId, clientEmail, privateKey: privateKey.replace(/\\n/g, "\n") }) }, name);
    try {
      await getMessaging(app).send({
        token,
        data: { type: "journey_demo", snapshot: JSON.stringify(snapshot) },
        android: { priority: "high", ttl: Math.max(0, Date.parse(snapshot.expiresAt) - Date.now()), collapseKey: "vxn-journey-demo" },
      });
      return "SENT";
    } catch (error) {
      const code = (error as { code?: string }).code;
      if (code === "messaging/registration-token-not-registered" || code === "messaging/invalid-registration-token") return "UNREGISTERED";
      throw new Error("Journey demo push delivery failed.");
    }
  }
}
