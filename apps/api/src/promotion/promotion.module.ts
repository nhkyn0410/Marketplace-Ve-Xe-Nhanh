import { Module } from "@nestjs/common";
import { AuditModule } from "../audit/audit.module";
import { DatabaseModule } from "../database/database.module";
import { IamModule } from "../iam/iam.module";
import { AdminPromotionController, OperatorPromotionController, PublicPromotionController } from "./promotion.controller";
import { PromotionService } from "./promotion.service";

/** Promotion (DOMAIN-MAP `promotion/`) — TASK-PROM-001: khuyến mãi nền tảng / nhà xe, quyền nhà xe, tham gia, kiểm mã. */
@Module({
  imports: [DatabaseModule, IamModule, AuditModule],
  controllers: [AdminPromotionController, OperatorPromotionController, PublicPromotionController],
  providers: [PromotionService],
})
export class PromotionModule {}
