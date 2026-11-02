import { Module } from "@nestjs/common";
import { AuditModule } from "../audit/audit.module";
import { DatabaseModule } from "../database/database.module";
import { IamModule } from "../iam/iam.module";
import { AdminCommissionController } from "./admin-commission.controller";
import { AdminCommissionService } from "./admin-commission.service";
import { CounterCommissionController } from "./counter-commission.controller";
import { CounterCommissionService } from "./counter-commission.service";

/** Hoa hồng (DOMAIN-MAP `commission/`): mức mặc định + mức riêng theo nhà xe có ngày hiệu lực (FR-ADM-07, BR-31). */
@Module({
  imports: [DatabaseModule, IamModule, AuditModule],
  controllers: [AdminCommissionController, CounterCommissionController],
  providers: [AdminCommissionService, CounterCommissionService],
})
export class CommissionModule {}
