import { Module } from "@nestjs/common";
import { MongooseModule } from "@nestjs/mongoose";
import { APP_CONFIG, type AppConfig } from "../config/env.config";
import { MongoHealthService } from "./mongo-health.service";

@Module({
  imports: [
    MongooseModule.forRootAsync({
      inject: [APP_CONFIG],
      useFactory: (config: AppConfig) => {
        if (!config.MONGODB_AUDIT_URI) {
          throw new Error("MONGODB_AUDIT_URI is required to initialize MongoAuditModule.");
        }

        return {
          uri: config.MONGODB_AUDIT_URI
        };
      }
    })
  ],
  providers: [MongoHealthService],
  exports: [MongooseModule, MongoHealthService]
})
export class MongoAuditModule {}
