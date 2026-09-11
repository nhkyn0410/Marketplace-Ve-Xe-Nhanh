import { NestFactory } from "@nestjs/core";
import { describe, expect, it } from "vitest";
import { buildOpenApiDocument, configureApiRoutes } from "./openapi";
import { OpenApiModule } from "./openapi.module";

describe("OpenAPI generation", () => {
  it("generates an OpenAPI 3.1 contract from Zod DTO metadata", async () => {
    const app = await NestFactory.create(OpenApiModule, { logger: false });

    try {
      configureApiRoutes(app);

      const document = buildOpenApiDocument(app);

      expect(document.openapi).toBe("3.1.0");
      expect(document.paths["/v1/health"]?.get?.responses[200]).toBeDefined();
      expect(document.components?.schemas?.HealthResponseDto_Output).toBeDefined();
      expect(document.components?.schemas?.ProblemDetailsDto).toBeDefined();

      // 6 endpoint auth trong phạm vi API §7.1 phải có mặt: thiếu chúng thì `gen:api-client`
      // sinh client không có auth mà CI vẫn xanh — lỗi im lặng đã từng xảy ra thật.
      for (const path of [
        "/v1/auth/register",
        "/v1/auth/otp/request",
        "/v1/auth/otp/verify",
        "/v1/auth/oauth/{provider}",
        "/v1/auth/operator/login",
        "/v1/auth/platform/login"
      ]) {
        expect(document.paths[path]?.post, `thiếu POST ${path} trong OpenAPI`).toBeDefined();
      }

      // `requestBody` phải có: script gen chạy bằng tsx (esbuild) nên KHÔNG có `design:paramtypes`
      // → @nestjs/swagger không suy ra được kiểu của `@Body()`. Thiếu `@ApiBody` thì spec vẫn hợp lệ
      // và CI vẫn xanh, nhưng client sinh ra (TS lẫn Dart) mất sạch payload — đã xảy ra thật, phát
      // hiện khi spike openapi-generator 09/09/2026.
      for (const path of [
        "/v1/auth/register",
        "/v1/auth/otp/request",
        "/v1/auth/otp/verify",
        "/v1/auth/oauth/{provider}",
        "/v1/auth/operator/login",
        "/v1/auth/platform/login"
      ]) {
        expect(
          document.paths[path]?.post?.requestBody,
          `POST ${path} thiếu requestBody — nhớ @ApiBody({ type: ... })`
        ).toBeDefined();
      }

      // Path param phải được khai báo, nếu không spec KHÔNG hợp lệ (openapi-generator từ chối) và
      // client sinh ra gọi URL chứa literal "{provider}".
      const oauthParams = document.paths["/v1/auth/oauth/{provider}"]?.post?.parameters ?? [];
      expect(
        oauthParams.some((param) => "name" in param && param.name === "provider"),
        "thiếu @ApiParam cho {provider}"
      ).toBe(true);
    } finally {
      await app.close();
    }
  });
});
