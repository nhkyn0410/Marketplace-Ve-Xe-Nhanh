import { Module } from "@nestjs/common";
import { AuditModule } from "../audit/audit.module";
import { DatabaseModule } from "../database/database.module";
import { IamModule } from "../iam/iam.module";
import { AdminLoyaltyController } from "./admin-loyalty.controller";
import { AdminLoyaltyService } from "./admin-loyalty.service";

/** Loyalty (DOMAIN-MAP `loyalty/`) — TASK-LOY-001 phía Admin: VXN Plus; tích / thu hồi / hết hạn điểm chạy ở worker. */
@Module({
  imports: [DatabaseModule, IamModule, AuditModule],
  controllers: [AdminLoyaltyController],
  providers: [AdminLoyaltyService],
})
export class LoyaltyModule {}
