import "./instrument-worker";
import "reflect-metadata";
import { NestFactory } from "@nestjs/core";
import { createAppLogger, createNestLogger } from "./common/observability/logger";
import { loadAppConfig } from "./config/env.config";
import { WorkerModule } from "./worker.module";

const config = loadAppConfig();
const logger = createAppLogger(config, "worker");

async function bootstrapWorker(): Promise<void> {
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
