import { Module } from "@nestjs/common";
import { AuditModule } from "../audit/audit.module";
import { APP_CONFIG } from "../config/env.config";
import { DatabaseModule } from "../database/database.module";
import { IamModule } from "../iam/iam.module";
import { SeatHoldModule } from "../seat-hold/seat-hold.module";
import { createTicketQrSigner, TICKET_QR } from "../ticket/ticket-qr";
import { BookingController } from "./booking.controller";
import { BookingService } from "./booking.service";
import { OperatorBookingController } from "./operator-booking.controller";
import { OperatorBookingService } from "./operator-booking.service";

/**
 * Booking/Ticket/Payment (DOMAIN-MAP `booking/`) — TASK-BTP-002: tạo + xem booking; TASK-OPR-003: màn Đặt vé của nhà xe.
 */
@Module({
  imports: [DatabaseModule, IamModule, SeatHoldModule, AuditModule],
  controllers: [BookingController, OperatorBookingController],
  providers: [BookingService, OperatorBookingService, { provide: TICKET_QR, inject: [APP_CONFIG], useFactory: createTicketQrSigner }],
  exports: [BookingService, TICKET_QR],
})
export class BookingModule {}
