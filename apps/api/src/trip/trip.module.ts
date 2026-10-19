import { Module } from "@nestjs/common";
import { AuditModule } from "../audit/audit.module";
import { DatabaseModule } from "../database/database.module";
import { IamModule } from "../iam/iam.module";
import { TripScheduleController } from "./trip-schedule.controller";
import { TripScheduleService } from "./trip-schedule.service";
import { TripController } from "./trip.controller";
import { TripService } from "./trip.service";

/**
 * TASK-TRN-003 — chuyến + điểm dừng + ghế theo chuyến của nhà xe (DOMAIN-MAP `trip/`); TASK-TRN-006 — trạng thái bán
 * + khóa ghế, ghi audit Mongo; TASK-TRN-007 — lịch chuyến lặp lại.
 */
@Module({
  imports: [DatabaseModule, IamModule, AuditModule],
  controllers: [TripController, TripScheduleController],
  providers: [TripService, TripScheduleService],
})
export class TripModule {}
