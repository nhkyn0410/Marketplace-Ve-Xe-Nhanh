import { Module } from "@nestjs/common";
import { MongooseModule } from "@nestjs/mongoose";
import { MongoHealthService } from "./mongo-health.service";

@Module({
  imports: [
    MongooseModule.forRootAsync({
      useFactory: () => ({
        uri: process.env.MONGODB_AUDIT_URI,
      }),
    }),
  ],
  providers: [MongoHealthService],
  exports: [MongooseModule, MongoHealthService],
})
export class MongoAuditModule {}
