import { Module } from "@nestjs/common";
import { NestFactory } from "@nestjs/core";
import type { NestExpressApplication } from "@nestjs/platform-express";
import type { Express } from "express";
import type { AddressInfo } from "node:net";
import { describe, expect, it } from "vitest";
import { configureApiRoutes, setupOpenApi } from "../openapi/openapi";
import { configureSecurityHeaders } from "./security-headers";

@Module({})
class SecurityHeadersTestModule {}

describe("configureSecurityHeaders", () => {
  it.each(["development", "production"] as const)(
    "sets safe headers and keeps Swagger usable in %s",
    async (environment) => {
      const app = await NestFactory.create<NestExpressApplication>(SecurityHeadersTestModule, {
        logger: false
      });

      try {
        configureSecurityHeaders(app, environment);
        const expressApp = app.getHttpAdapter().getInstance() as Express;
        expressApp.get("/v1/health", (_request, response) => response.json({ ok: true }));
        configureApiRoutes(app);
        setupOpenApi(app);

        await app.listen(0, "127.0.0.1");
        const address = app.getHttpServer().address() as AddressInfo;
        const baseUrl = `http://127.0.0.1:${address.port}`;
        const options = { headers: { connection: "close" } };
        const health = await fetch(`${baseUrl}/v1/health`, options);
        const docs = await fetch(`${baseUrl}/v1/docs`, options);
        const docsScript = await fetch(`${baseUrl}/v1/docs/swagger-ui-bundle.js`, options);
        const missingRoute = await fetch(`${baseUrl}/v1/no-such-route`, options);
        const docsHtml = await docs.text();
        await health.arrayBuffer();
        await docsScript.arrayBuffer();
        await missingRoute.arrayBuffer();

        expect(health.status).toBe(200);
        expect(docs.status).toBe(200);
        expect(docsScript.status).toBe(200);
        expect(missingRoute.status).toBe(404);
        expect(docsHtml).toContain("Marketplace Ve Xe Nhanh API");
        for (const response of [health, docs, docsScript, missingRoute]) {
          expect(response.headers.get("x-powered-by")).toBeNull();
          expect(response.headers.get("x-content-type-options")).toBe("nosniff");
          expect(response.headers.get("referrer-policy")).toBeTruthy();
          expect(response.headers.get("content-security-policy")).toBeNull();
        }
        expect(health.headers.has("strict-transport-security")).toBe(environment === "production");
      } finally {
        await app.close();
      }
    }
  );
});
