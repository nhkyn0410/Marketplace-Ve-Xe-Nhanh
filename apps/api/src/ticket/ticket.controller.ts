import { Body, Controller, Get, Headers, HttpCode, Inject, Param, ParseUUIDPipe, Post, Req } from "@nestjs/common";
import { ApiBody, ApiHeader, ApiParam, ApiResponse, ApiTags, getSchemaPath } from "@nestjs/swagger";
import type { Request } from "express";
import { ZodResponse } from "nestjs-zod";
import { BOOKING_TOKEN_HEADER } from "../booking/booking-access";
import { BookingResponseDto, type BookingResponse } from "../booking/dto/booking.dto";
import { resolveTrustedClientIp } from "../common/trusted-client-ip";
import { APP_CONFIG, type AppConfig } from "../config/env.config";
import type { VerifiedAccessToken } from "../iam/auth/token.service";
import { GuestOrPassenger, OptionalPassenger } from "../iam/role/guest-or-passenger";
import { ProblemDetailsDto } from "../openapi/openapi.dto";
import {
  TicketLookupAccessDto,
  type TicketLookupAccess,
  TicketLookupBookingListDto,
  type TicketLookupBookingList,
  TicketLookupInputDto,
  TicketLookupOtpInputDto,
  TicketLookupOtpResponseDto,
  type TicketLookupOtpResponse,
  type TicketLookupSession,
  TicketLookupSessionDto,
  TicketLookupSessionInputDto,
  TicketLookupVerifyInputDto,
  TicketResponseDto,
  type TicketResponse,
} from "./dto/ticket.dto";
import { TicketService } from "./ticket.service";

const problemContent = {
  "application/problem+json": { schema: { $ref: getSchemaPath(ProblemDetailsDto) } },
};

// API §7.2 — vé điện tử của hành khách / khách vãng lai (TASK-BTP-004).
@ApiTags("tickets")
@Controller()
/** Vé điện tử. */
export class TicketController {
  constructor(
    @Inject(TicketService) private readonly tickets: TicketService,
    @Inject(APP_CONFIG) private readonly config: AppConfig,
  ) {}

  @Get("tickets/:ticketId")
  @GuestOrPassenger("booking:create")
  @ApiParam({ name: "ticketId", type: String, format: "uuid" })
  @ApiHeader({ name: "X-Booking-Token", required: false, description: "Mã truy cập booking (khách vãng lai)." })
  @ZodResponse({ status: 200, description: "Vé kèm nội dung mã QR.", type: TicketResponseDto })
  @ApiResponse({ status: 404, description: "`TICKET_NOT_FOUND`.", content: problemContent })
  get(
    @OptionalPassenger() user: VerifiedAccessToken | null,
    @Param("ticketId", new ParseUUIDPipe()) ticketId: string,
    @Headers(BOOKING_TOKEN_HEADER) accessToken: string | undefined,
  ): Promise<TicketResponse> {
    return this.tickets.get(user, ticketId, accessToken);
  }

  /** Tra cứu vé B1: gửi mã 6 số về email liên hệ nếu email (+ mã đặt vé khi có) có đơn; phản hồi như nhau dù có hay không. */
  @Post("guest/ticket-lookup/otp")
  @HttpCode(202)
  @GuestOrPassenger("booking:create")
  @ApiBody({ type: TicketLookupOtpInputDto })
  @ZodResponse({ status: 202, description: "Đã nhận yêu cầu (mã chỉ được gửi khi đúng mã đặt vé + email, hoặc email có đơn trong 12 tháng).", type: TicketLookupOtpResponseDto })
  @ApiResponse({ status: 429, description: "`TICKET_LOOKUP_RATE_LIMITED` — quá số lần theo IP, chưa hết 60 giây chờ gửi lại, hoặc quá 5 mã / giờ / email.", content: problemContent })
  @ApiResponse({ status: 503, description: "Tra cứu tạm gián đoạn.", content: problemContent })
  requestOtp(@Req() request: Request, @Body() input: TicketLookupOtpInputDto): Promise<TicketLookupOtpResponse> {
    return this.tickets.requestOtp(resolveTrustedClientIp(request, this.config.NODE_ENV), input);
  }

  /** Tra cứu vé B2: xác minh mã → phiên tra cứu 15 phút. */
  @Post("guest/ticket-lookup/verify")
  @HttpCode(200)
  @GuestOrPassenger("booking:create")
  @ApiBody({ type: TicketLookupVerifyInputDto })
  @ZodResponse({ status: 200, description: "Phiên tra cứu.", type: TicketLookupSessionDto })
  @ApiResponse({ status: 422, description: "`TICKET_LOOKUP_OTP_INVALID` — sai mã (kèm số lần thử còn lại), hết hạn hoặc hết lượt.", content: problemContent })
  @ApiResponse({ status: 503, description: "Tra cứu tạm gián đoạn.", content: problemContent })
  verifyOtp(@Body() input: TicketLookupVerifyInputDto): Promise<TicketLookupSession> {
    return this.tickets.verifyOtp(input);
  }

  /** Tra cứu vé B3: các đơn của phiên (một đơn khi nhập mã đặt vé, ngược lại các đơn của email trong 12 tháng). */
  @Post("guest/ticket-lookup/bookings")
  @HttpCode(200)
  @GuestOrPassenger("booking:create")
  @ApiBody({ type: TicketLookupSessionInputDto })
  @ZodResponse({ status: 200, description: "Danh sách đơn + email có tài khoản không.", type: TicketLookupBookingListDto })
  @ApiResponse({ status: 404, description: "`TICKET_LOOKUP_EXPIRED` — phiên tra cứu không có hoặc đã hết hạn.", content: problemContent })
  @ApiResponse({ status: 503, description: "Tra cứu tạm gián đoạn.", content: problemContent })
  listBookings(@Body() input: TicketLookupSessionInputDto): Promise<TicketLookupBookingList> {
    return this.tickets.listBookings(input);
  }

  /** Sau OTP: mã truy cập phụ để hủy vé / gửi khiếu nại một đơn khách vãng lai trong phiên (hết hạn cùng phiên). */
  @Post("guest/ticket-lookup/booking-access")
  @HttpCode(200)
  @GuestOrPassenger("booking:create")
  @ApiBody({ type: TicketLookupInputDto })
  @ZodResponse({ status: 200, description: "Mã truy cập phụ (dùng ở header `X-Booking-Token`).", type: TicketLookupAccessDto })
  @ApiResponse({ status: 403, description: "`BOOKING_REQUIRES_LOGIN` — đơn đặt bằng tài khoản.", content: problemContent })
  @ApiResponse({ status: 404, description: "`TICKET_LOOKUP_EXPIRED` — phiên hết hạn; `BOOKING_NOT_FOUND` — đơn ngoài phạm vi phiên.", content: problemContent })
  @ApiResponse({ status: 503, description: "Tra cứu tạm gián đoạn.", content: problemContent })
  grantBookingAccess(@Body() input: TicketLookupInputDto): Promise<TicketLookupAccess> {
    return this.tickets.grantBookingAccess(input);
  }

  /** Tra cứu vé B3: booking + vé của một đơn trong phiên tra cứu đã xác minh. */
  @Post("guest/ticket-lookup")
  @HttpCode(200)
  @GuestOrPassenger("booking:create")
  @ApiBody({ type: TicketLookupInputDto })
  @ZodResponse({ status: 200, description: "Booking kèm vé.", type: BookingResponseDto })
  @ApiResponse({ status: 404, description: "`TICKET_LOOKUP_EXPIRED` — phiên không có / hết hạn; `BOOKING_NOT_FOUND` — đơn ngoài phạm vi phiên.", content: problemContent })
  @ApiResponse({ status: 503, description: "Tra cứu tạm gián đoạn.", content: problemContent })
  lookup(@Body() input: TicketLookupInputDto): Promise<BookingResponse> {
    return this.tickets.lookup(input);
  }
}
