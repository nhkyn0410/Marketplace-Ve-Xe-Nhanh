import { Module } from "@nestjs/common";
import { AuditModule } from "../audit/audit.module";
import { DatabaseModule } from "../database/database.module";
import { NotificationModule } from "../external/notification/notification.module";
import { StorageModule } from "../external/storage/storage.module";
import { IamModule } from "../iam/iam.module";
import { AdminOperatorController } from "./admin-operator.controller";
import { AdminOperatorService } from "./admin-operator.service";
import { OperatorProfileController } from "./operator-profile.controller";
import { OperatorProfileService } from "./operator-profile.service";

/**
 * Hồ sơ nhà xe (DOMAIN-MAP `operator/`): Admin xem danh sách, tạm khóa / mở lại nhà xe (FR-ADM-02/03, UC-23 A6) —
 * thu hồi phiên qua `SessionService` của `IamModule`, audit, email chủ nhà xe; xác minh đổi tài khoản nhận tiền. Phía
 * Operator OS: hồ sơ công khai, giấy tờ KYC (kho private), yêu cầu đổi tài khoản nhận tiền (TASK-OPR-001b, UC-11).
 */
@Module({
  imports: [DatabaseModule, IamModule, AuditModule, NotificationModule, StorageModule],
  controllers: [AdminOperatorController, OperatorProfileController],
  providers: [AdminOperatorService, OperatorProfileService],
})
export class OperatorModule {}
