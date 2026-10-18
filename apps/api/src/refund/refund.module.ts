import { Module } from "@nestjs/common";
import { AuditModule } from "../audit/audit.module";
import { BookingModule } from "../booking/booking.module";
import { DatabaseModule } from "../database/database.module";
import { IamModule } from "../iam/iam.module";
import { NotificationDispatchModule } from "../notification/notification-dispatch.module";
import { QueueModule } from "../queue/queue.module";
import { AdminRefundController } from "./admin-refund.controller";
import { AdminRefundService } from "./admin-refund.service";
import { CancellationController } from "./cancellation.controller";
import { CancellationService } from "./cancellation.service";

/**
 * Booking/Ticket/Payment (DOMAIN-MAP `refund/`) — TASK-BTP-005: hủy vé + yêu cầu hoàn tiền; hoàn qua cổng ở worker. TASK-ADM-002:
 * xử lý hoàn tiền phía Admin.
 */
@Module({
  imports: [DatabaseModule, IamModule, QueueModule, BookingModule, AuditModule, NotificationDispatchModule],
  controllers: [CancellationController, AdminRefundController],
  providers: [CancellationService, AdminRefundService],
})
export class RefundModule {}
