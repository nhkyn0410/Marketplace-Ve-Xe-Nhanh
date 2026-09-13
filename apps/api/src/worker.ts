import "./instrument-worker";
import "reflect-metadata";
import { NestFactory } from "@nestjs/core";
import { assertDecoratorMetadata } from "./common/assert-decorator-metadata";
import { createAppLogger, createNestLogger } from "./common/observability/logger";
import { loadAppConfig } from "./config/env.config";
import { WorkerModule } from "./worker.module";

const config = loadAppConfig();
const logger = createAppLogger(config, "worker");

async function bootstrapWorker(): Promise<void> {
  // Fail-fast: sai runtime thì dependency inject theo kiểu thành undefined mà Nest không báo.
  assertDecoratorMetadata("worker");
  const app = await NestFactory.createApplicationContext(WorkerModule, {
    logger: createNestLogger(logger)
  });
  app.enableShutdownHooks();

  logger.info("Worker bootstrap complete. BullMQ processors are registered.");
}

void bootstrapWorker().catch((error: unknown) => {
  logger.fatal({ err: error }, "Worker bootstrap failed.");
  process.exit(1);
});
