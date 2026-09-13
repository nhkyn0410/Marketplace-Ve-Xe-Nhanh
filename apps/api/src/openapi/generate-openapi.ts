import "reflect-metadata";
import { mkdirSync, writeFileSync } from "node:fs";
import { dirname, resolve } from "node:path";
import { NestFactory } from "@nestjs/core";
import { assertDecoratorMetadata } from "../common/assert-decorator-metadata";
import { buildOpenApiDocument, configureApiRoutes } from "./openapi";
import { OpenApiModule } from "./openapi.module";

async function generateOpenApi(): Promise<void> {
  // Thiếu metadata thì @nestjs/swagger không suy được kiểu của `@Body()` → spec mất
  // `requestBody`, client gen ra thiếu payload, mà không có lỗi nào được báo.
  assertDecoratorMetadata("openapi:generate");
  const outputArg = process.argv.slice(2).find((arg) => arg !== "--");
  const outputPath = resolve(process.cwd(), outputArg ?? "openapi.json");
  const app = await NestFactory.create(OpenApiModule, { logger: false });

  try {
    configureApiRoutes(app);

    const document = buildOpenApiDocument(app);
    mkdirSync(dirname(outputPath), { recursive: true });
    writeFileSync(outputPath, `${JSON.stringify(document, null, 2)}\n`);
  } finally {
    await app.close();
  }
}

void generateOpenApi().catch((error: unknown) => {
  console.error(error);
  process.exit(1);
});
