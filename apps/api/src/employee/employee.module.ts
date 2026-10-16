import { Module } from "@nestjs/common";
import { AuditModule } from "../audit/audit.module";
import { DatabaseModule } from "../database/database.module";
import { IamModule } from "../iam/iam.module";
import { EmployeeAssignmentController } from "./employee-assignment.controller";
import { EmployeeAssignmentService } from "./employee-assignment.service";

/** TASK-EMP-001 (phía Operator OS) — phân công tài xế cho chuyến (DOMAIN-MAP `employee/`), audit Mongo. */
@Module({
  imports: [DatabaseModule, IamModule, AuditModule],
  controllers: [EmployeeAssignmentController],
  providers: [EmployeeAssignmentService],
})
export class EmployeeModule {}
