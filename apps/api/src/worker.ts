import "reflect-metadata";
import { NestFactory } from "@nestjs/core";
import { WorkerModule } from "./worker.module";

async function bootstrapWorker(): Promise<void> {
  const app = await NestFactory.createApplicationContext(WorkerModule);
  app.enableShutdownHooks();

  console.log("Worker bootstrap complete. BullMQ processors are registered.");
}

void bootstrapWorker().catch((error: unknown) => {
  console.error("Worker bootstrap failed.", error);
  process.exit(1);
});
