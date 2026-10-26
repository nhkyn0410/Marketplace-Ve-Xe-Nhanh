import { Module } from "@nestjs/common";
import { BookingModule } from "../booking/booking.module";
import { DatabaseModule } from "../database/database.module";
import { NotificationModule } from "../external/notification/notification.module";
import { IamModule } from "../iam/iam.module";
import { RedisModule } from "../redis/redis.module";
import { TicketController } from "./ticket.controller";
import { TicketService } from "./ticket.service";

/** Booking/Ticket/Payment (DOMAIN-MAP `ticket/`) — TASK-BTP-004: xem vé, tra cứu vé khách vãng lai. Phát hành ở callback thanh toán. */
@Module({
  imports: [DatabaseModule, IamModule, RedisModule, BookingModule, NotificationModule],
  controllers: [TicketController],
  providers: [TicketService],
})
export class TicketModule {}
