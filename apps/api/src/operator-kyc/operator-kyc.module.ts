import { Module } from "@nestjs/common";
import { AuditModule } from "../audit/audit.module";
import { DatabaseModule } from "../database/database.module";
import { NotificationModule } from "../external/notification/notification.module";
import { StorageModule } from "../external/storage/storage.module";
import { IamModule } from "../iam/iam.module";
import { RedisModule } from "../redis/redis.module";
import { OperatorApplicationController } from "./operator-application.controller";
import { OperatorApplicationRateLimiter } from "./operator-application-rate-limiter";
import { OperatorApplicationService } from "./operator-application.service";
import { OperatorApplicationReviewController } from "./operator-application-review.controller";
import { OperatorApplicationReviewService } from "./operator-application-review.service";

/**
 * TASK-OPR-001 — hồ sơ đăng ký nhà xe (DOMAIN-MAP `operator-kyc/`, BR-75). Giấy tờ ở kho riêng tư (`StorageModule`),
 * link bảo mật gửi qua `NotificationModule`, giới hạn tần suất qua `RedisModule`. Admin duyệt hồ sơ (TASK-ADM-001)
 * tạo nhà xe + chủ nhà xe qua `AccountProvisioningService` của `IamModule`.
 */
@Module({
  imports: [DatabaseModule, AuditModule, NotificationModule, StorageModule, RedisModule, IamModule],
  controllers: [OperatorApplicationController, OperatorApplicationReviewController],
  providers: [OperatorApplicationService, OperatorApplicationReviewService, OperatorApplicationRateLimiter],
})
export class OperatorKycModule {}
