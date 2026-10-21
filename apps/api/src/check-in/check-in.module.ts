import { Module } from "@nestjs/common";
import { AuditModule } from "../audit/audit.module";
import { DatabaseModule } from "../database/database.module";
import { IamModule } from "../iam/iam.module";
import { EmployeeOperationsController } from "./employee-operations.controller";
import { EmployeeOperationsService } from "./employee-operations.service";

/** Operation & Check-in (DOMAIN-MAP `check-in/`) — TASK-EMP-002 phần backend: soát vé, danh sách khách, trạng thái vận hành. */
@Module({
  imports: [DatabaseModule, IamModule, AuditModule],
  controllers: [EmployeeOperationsController],
  providers: [EmployeeOperationsService],
})
export class CheckInModule {}
