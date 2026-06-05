import type { INestApplication } from "@nestjs/common";
import { DocumentBuilder, SwaggerModule, type OpenAPIObject } from "@nestjs/swagger";
import { cleanupOpenApiDoc } from "nestjs-zod";

export const API_VERSION_PREFIX = "v1";
export const OPENAPI_DOCS_PATH = `${API_VERSION_PREFIX}/docs`;
export const OPENAPI_JSON_PATH = `${API_VERSION_PREFIX}/openapi.json`;

export function configureApiRoutes(app: Pick<INestApplication, "setGlobalPrefix">): void {
  app.setGlobalPrefix(API_VERSION_PREFIX);
}

export function buildOpenApiDocument(app: INestApplication): OpenAPIObject {
  const config = new DocumentBuilder()
    .setTitle("Marketplace Ve Xe Nhanh API")
    .setDescription("Managed marketplace API for passenger, operator, and platform workflows.")
    .setVersion("0.0.0")
    .setOpenAPIVersion("3.1.0")
    .build();

  return cleanupOpenApiDoc(SwaggerModule.createDocument(app, config), { version: "3.1" });
}

export function setupOpenApi(app: INestApplication): OpenAPIObject {
  const document = buildOpenApiDocument(app);

  SwaggerModule.setup(OPENAPI_DOCS_PATH, app, document, {
    customSiteTitle: "Marketplace Ve Xe Nhanh API",
    jsonDocumentUrl: `/${OPENAPI_JSON_PATH}`,
    raw: ["json"]
  });

  return document;
}
