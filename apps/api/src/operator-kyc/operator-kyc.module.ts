import { Module } from "@nestjs/common";
import { AuditModule } from "../audit/audit.module";
import { DatabaseModule } from "../database/database.module";
import { NotificationModule } from "../external/notification/notification.module";
import { StorageModule } from "../external/storage/storage.module";
import { RedisModule } from "../redis/redis.module";
import { OperatorApplicationController } from "./operator-application.controller";
import { OperatorApplicationRateLimiter } from "./operator-application-rate-limiter";
import { OperatorApplicationService } from "./operator-application.service";

/**
 * TASK-OPR-001 — hồ sơ đăng ký nhà xe (DOMAIN-MAP `operator-kyc/`, BR-75). Giấy tờ ở kho riêng tư (`StorageModule`),
 * link bảo mật gửi qua `NotificationModule`, giới hạn tần suất qua `RedisModule`.
 */
@Module({
  imports: [DatabaseModule, AuditModule, NotificationModule, StorageModule, RedisModule],
  controllers: [OperatorApplicationController],
  providers: [OperatorApplicationService, OperatorApplicationRateLimiter],
})
export class OperatorKycModule {}
