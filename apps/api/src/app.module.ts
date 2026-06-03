import { Module } from "@nestjs/common";
import { AppController } from "./app.controller";
import { AppConfigModule } from "./config/app-config.module";
import { QueueModule } from "./queue/queue.module";

@Module({
  imports: [AppConfigModule, QueueModule],
  controllers: [AppController]
})
export class AppModule {}
