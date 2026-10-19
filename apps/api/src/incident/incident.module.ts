import { Module } from "@nestjs/common";
import { AuditModule } from "../audit/audit.module";
import { DatabaseModule } from "../database/database.module";
import { IamModule } from "../iam/iam.module";
import { NotificationDispatchModule } from "../notification/notification-dispatch.module";
import { SupportModule } from "../support/support.module";
import { AdminIncidentController, EmployeeIncidentController, OperatorIncidentController } from "./incident.controller";
import { IncidentService } from "./incident.service";

/** Module sự cố vận hành (DOMAIN-MAP incident/). */
@Module({ imports: [DatabaseModule, IamModule, AuditModule, SupportModule, NotificationDispatchModule], controllers: [EmployeeIncidentController, OperatorIncidentController, AdminIncidentController], providers: [IncidentService] })
export class IncidentModule {}
