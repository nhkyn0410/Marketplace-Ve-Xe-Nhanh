import { Body, Controller, Get, Headers, HttpCode, Inject, Param, ParseUUIDPipe, Post } from "@nestjs/common";
import { ApiBody, ApiHeader, ApiParam, ApiResponse, ApiTags, getSchemaPath } from "@nestjs/swagger";
import { ZodResponse } from "nestjs-zod";
import type { VerifiedAccessToken } from "../iam/auth/token.service";
import { GuestOrPassenger, OptionalPassenger } from "../iam/role/guest-or-passenger";
import { ProblemDetailsDto } from "../openapi/openapi.dto";
import { BOOKING_TOKEN_HEADER } from "./booking-access";
import { BookingService } from "./booking.service";
import {
  BookingInputDto,
  BookingResponseDto,
  CreatedBookingDto,
  TicketEmailResponseDto,
  type BookingResponse,
  type CreatedBooking,
} from "./dto/booking.dto";
import { TicketEmailService, type TicketEmailResult } from "./ticket-email.service";

const problemContent = {
  "application/problem+json": { schema: { $ref: getSchemaPath(ProblemDetailsDto) } },
};

// API §7.2 — khách vãng lai hoặc hành khách đã đăng nhập (`booking:create`, phạm vi `own`).
@ApiTags("bookings")
@Controller("bookings")
/** Đặt vé (TASK-BTP-002). */
export class BookingController {
  constructor(
    @Inject(BookingService) private readonly bookings: BookingService,
    @Inject(TicketEmailService) private readonly ticketEmails: TicketEmailService,
  ) {}

  /** Tạo booking chờ thanh toán từ phiên giữ chỗ còn hiệu lực; chỗ được giữ tới hạn thanh toán. */
  @Post()
  @HttpCode(201)
  @GuestOrPassenger("booking:create")
  @ApiBody({ type: BookingInputDto })
  @ZodResponse({ status: 201, description: "Đã tạo booking `PENDING_PAYMENT`.", type: CreatedBookingDto })
  @ApiResponse({ status: 404, description: "`SEAT_HOLD_EXPIRED` — giữ chỗ hết hạn / không phải của người gọi.", content: problemContent })
  @ApiResponse({
    status: 409,
    description:
      "`BOOKING_SNAPSHOT_CHANGED` (`reasons[0]` = tổng mới) / `BOOKING_ALREADY_CREATED` / `TRIP_NOT_ON_SALE` / `SEAT_NOT_AVAILABLE`.",
    content: problemContent,
  })
  @ApiResponse({ status: 422, description: "`BOOKING_PASSENGERS_MISMATCH` / `SEAT_HOLD_STOPS_INVALID`.", content: problemContent })
  @ApiResponse({ status: 503, description: "Hệ thống giữ chỗ / cơ sở dữ liệu bận.", content: problemContent })
  create(@OptionalPassenger() user: VerifiedAccessToken | null, @Body() input: BookingInputDto): Promise<CreatedBooking> {
    return this.bookings.create(user, input);
  }

  @Get(":bookingId")
  @GuestOrPassenger("booking:create")
  @ApiParam({ name: "bookingId", type: String, format: "uuid" })
  @ApiHeader({ name: "X-Booking-Token", required: false, description: "Mã truy cập trả lúc tạo booking (khách vãng lai)." })
  @ZodResponse({ status: 200, description: "Booking.", type: BookingResponseDto })
  @ApiResponse({ status: 404, description: "`BOOKING_NOT_FOUND`.", content: problemContent })
  get(
    @OptionalPassenger() user: VerifiedAccessToken | null,
    @Param("bookingId", new ParseUUIDPipe()) bookingId: string,
    @Headers(BOOKING_TOKEN_HEADER) accessToken: string | undefined,
  ): Promise<BookingResponse> {
    return this.bookings.get(user, bookingId, accessToken);
  }

  /** Gửi lại email vé điện tử tới email liên hệ của đơn (SCR-PSG-22; chờ duyệt). */
  @Post(":bookingId/tickets/email")
  @HttpCode(202)
  @GuestOrPassenger("booking:create")
  @ApiParam({ name: "bookingId", type: String, format: "uuid" })
  @ApiHeader({ name: "X-Booking-Token", required: false, description: "Mã truy cập trả lúc tạo booking (khách vãng lai)." })
  @ZodResponse({ status: 202, description: "Đã xếp hàng gửi lại vé điện tử.", type: TicketEmailResponseDto })
  @ApiResponse({ status: 404, description: "`BOOKING_NOT_FOUND`.", content: problemContent })
  @ApiResponse({ status: 409, description: "`TICKET_EMAIL_NOT_AVAILABLE` — đơn chưa có vé còn hiệu lực.", content: problemContent })
  @ApiResponse({ status: 429, description: "`TICKET_EMAIL_RATE_LIMITED` — 1 lần / phút, 5 lần / ngày.", content: problemContent })
  resendTickets(
    @OptionalPassenger() user: VerifiedAccessToken | null,
    @Param("bookingId", new ParseUUIDPipe()) bookingId: string,
    @Headers(BOOKING_TOKEN_HEADER) accessToken: string | undefined,
  ): Promise<TicketEmailResult> {
    return this.ticketEmails.resend(user, bookingId, accessToken);
  }
}
