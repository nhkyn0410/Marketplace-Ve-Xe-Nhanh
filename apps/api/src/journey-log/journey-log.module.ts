import { Module } from "@nestjs/common";
import { DatabaseModule } from "../database/database.module";
import { IamModule } from "../iam/iam.module";
import { AdminJourneyLogController, EmployeeJourneyLogController, OperatorJourneyLogController } from "./journey-log.controller";
import { JourneyLogService } from "./journey-log.service";

/** Module nhật trình vận hành (DOMAIN-MAP journey-log/). */
@Module({ imports: [DatabaseModule, IamModule], controllers: [EmployeeJourneyLogController, OperatorJourneyLogController, AdminJourneyLogController], providers: [JourneyLogService] })
export class JourneyLogModule {}
