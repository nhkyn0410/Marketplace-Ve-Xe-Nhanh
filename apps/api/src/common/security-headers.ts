import type { NestExpressApplication } from "@nestjs/platform-express";
import type { Express } from "express";
import helmet from "helmet";
import type { AppConfig } from "../config/env.config";

/** Apply response headers before routes; CSP remains pending a Swagger-compatible policy. */
export function configureSecurityHeaders(
  app: Pick<NestExpressApplication, "getHttpAdapter" | "use">,
  environment: AppConfig["NODE_ENV"]
): void {
  const expressApp = app.getHttpAdapter().getInstance() as Express;
  expressApp.disable("x-powered-by");
  app.use(helmet({
    contentSecurityPolicy: false,
    strictTransportSecurity: environment === "production"
  }));
}
