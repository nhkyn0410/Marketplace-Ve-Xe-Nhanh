import type { NestExpressApplication } from "@nestjs/platform-express";

/** Áp dụng ranh giới tin cậy trước mọi middleware đọc `req.ip`. */
export function configureTrustProxy(
  app: Pick<NestExpressApplication, "set">,
  trustedProxyHops: number
): void {
  app.set("trust proxy", trustedProxyHops);
}
