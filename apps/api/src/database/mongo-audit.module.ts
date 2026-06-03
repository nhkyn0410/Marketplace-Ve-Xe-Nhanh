import { Module } from "@nestjs/common";
import { MongooseModule } from "@nestjs/mongoose";

const DEFAULT_MONGODB_AUDIT_URI =
  "mongodb://vexenhanh:vexenhanh_dev@localhost:27017/vexenhanh_audit?authSource=admin";

@Module({
  imports: [
    MongooseModule.forRootAsync({
      useFactory: () => ({
        uri: process.env.MONGODB_AUDIT_URI ?? DEFAULT_MONGODB_AUDIT_URI
      })
    })
  ],
  exports: [MongooseModule]
})
export class MongoAuditModule {}
