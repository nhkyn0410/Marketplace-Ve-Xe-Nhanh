import { Module } from "@nestjs/common";
import { AuditModule } from "../audit/audit.module";
import { DatabaseModule } from "../database/database.module";
import { IamModule } from "../iam/iam.module";
import { AdminPayoutController } from "./admin-payout.controller";
import { AdminPayoutService } from "./admin-payout.service";
import { OperatorFinanceController } from "./operator-finance.controller";
import { OperatorFinanceService } from "./operator-finance.service";

/** Escrow / Payout (DOMAIN-MAP `payout/`, `escrow/`) — TASK-BTP-006: kỳ chi trả (Admin) + tài chính của nhà xe; tạo kỳ ở worker. */
@Module({
  imports: [DatabaseModule, IamModule, AuditModule],
  controllers: [AdminPayoutController, OperatorFinanceController],
  providers: [AdminPayoutService, OperatorFinanceService],
})
export class PayoutModule {}
