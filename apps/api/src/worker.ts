import "reflect-metadata";
import { NestFactory } from "@nestjs/core";
import { loadAppConfig } from "./config/env.config";
import { WorkerModule } from "./worker.module";

async function bootstrapWorker(): Promise<void> {
  loadAppConfig(); // nạp .env + validate (fail-fast) trước khi bootstrap worker
  const app = await NestFactory.createApplicationContext(WorkerModule);
  app.enableShutdownHooks();

  console.log("Worker bootstrap complete. BullMQ processors are registered.");
}

void bootstrapWorker().catch((error: unknown) => {
  console.error("Worker bootstrap failed.", error);
  process.exit(1);
});
