import { Module } from "@nestjs/common";
import { AppController } from "./app.controller";
import { AppConfigModule } from "./config/app-config.module";
import { DatabaseModule } from "./database/database.module";
import { MongoAuditModule } from "./database/mongo-audit.module";
import { QueueModule } from "./queue/queue.module";

@Module({
  imports: [AppConfigModule, DatabaseModule, MongoAuditModule, QueueModule],
  controllers: [AppController]
})
export class AppModule {}
