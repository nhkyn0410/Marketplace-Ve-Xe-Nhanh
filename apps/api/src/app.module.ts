import { Module } from "@nestjs/common";
import { SentryModule } from "@sentry/nestjs/setup";
import { AppController } from "./app.controller";
import { AuditModule } from "./audit/audit.module";
import { AppConfigModule } from "./config/app-config.module";
import { DatabaseModule } from "./database/database.module";
import { MongoAuditModule } from "./database/mongo-audit.module";
import { QueueModule } from "./queue/queue.module";

@Module({
  imports: [
    SentryModule.forRoot(),
    AppConfigModule,
    DatabaseModule,
    MongoAuditModule,
    AuditModule,
    QueueModule
  ],
  controllers: [AppController]
})
export class AppModule {}
