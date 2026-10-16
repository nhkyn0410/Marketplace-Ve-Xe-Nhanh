import { Module } from "@nestjs/common";
import { DatabaseModule } from "../database/database.module";
import { IamModule } from "../iam/iam.module";
import { AdminAuditLogController } from "./admin-audit-log.controller";
import { AdminAuditLogService } from "./admin-audit-log.service";
import { AuditModule } from "./audit.module";

/**
 * Màn Nhật ký audit của Admin (UC-30). Tách khỏi `AuditModule` vì cần `IamModule` (guard `@Authorize`) mà
 * `IamModule` lại dùng `AuditModule` để ghi lịch sử đăng nhập.
 */
@Module({
  imports: [DatabaseModule, IamModule, AuditModule],
  controllers: [AdminAuditLogController],
  providers: [AdminAuditLogService],
})
export class AdminAuditLogModule {}
