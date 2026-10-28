import { Module } from "@nestjs/common";
import { AuditModule } from "../audit/audit.module";
import { DatabaseModule } from "../database/database.module";
import { IamModule } from "../iam/iam.module";
import { NotificationDispatchModule } from "../notification/notification-dispatch.module";
import { QueueModule } from "../queue/queue.module";
import { TripChangeService } from "./trip-change.service";
import { TripScheduleController } from "./trip-schedule.controller";
import { TripScheduleService } from "./trip-schedule.service";
import { TripController } from "./trip.controller";
import { TripService } from "./trip.service";
import { PickupWindowController } from "./pickup-window.controller";
import { OperatorDepartureController } from "./operator-departure.controller";
import { OperatorDepartureService } from "./operator-departure.service";
import { AdminTripController } from "./admin-trip.controller";
import { AdminTripService } from "./admin-trip.service";

/**
 * TASK-TRN-003 — chuyến + điểm dừng + ghế theo chuyến của nhà xe (DOMAIN-MAP `trip/`); TASK-TRN-006 — trạng thái bán
 * + khóa ghế, ghi audit Mongo; TASK-TRN-007 — lịch chuyến lặp lại; TASK-TRN-008 — đổi / hủy chuyến đã bán vé; Admin giám sát chuyến mọi nhà xe (chờ duyệt 28/10/2026).
 */
@Module({
  imports: [DatabaseModule, IamModule, AuditModule, QueueModule, NotificationDispatchModule],
  controllers: [TripController, TripScheduleController, PickupWindowController, OperatorDepartureController, AdminTripController],
  providers: [TripService, TripScheduleService, TripChangeService, OperatorDepartureService, AdminTripService],
})
export class TripModule {}
