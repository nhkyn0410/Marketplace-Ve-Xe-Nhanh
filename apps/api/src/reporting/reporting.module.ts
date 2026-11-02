import { Module } from "@nestjs/common";
import { AuditModule } from "../audit/audit.module";
import { DatabaseModule } from "../database/database.module";
import { IamModule } from "../iam/iam.module";
import { AdminReportingController, OperatorReportingController } from "./reporting.controller";
import { ReportingService } from "./reporting.service";

/** Reporting (DOMAIN-MAP `reporting/`) — TASK-RPT-001 / 002: báo cáo nhà xe, báo cáo nền tảng, số liệu hai trang Tổng quan. */
@Module({
  imports: [DatabaseModule, IamModule, AuditModule],
  controllers: [OperatorReportingController, AdminReportingController],
  providers: [ReportingService],
})
export class ReportingModule {}
