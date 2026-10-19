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
import { TicketLookupInputDto, TicketResponseDto, type TicketResponse } from "./dto/ticket.dto";
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

  /** Tra cứu booking + vé bằng mã booking và số điện thoại / email liên hệ lúc đặt. */
  @Post("guest/ticket-lookup")
  @HttpCode(200)
  @GuestOrPassenger("booking:create")
  @ApiBody({ type: TicketLookupInputDto })
  @ZodResponse({ status: 200, description: "Booking kèm vé.", type: BookingResponseDto })
  @ApiResponse({ status: 404, description: "`BOOKING_NOT_FOUND` — sai mã hoặc liên hệ.", content: problemContent })
  @ApiResponse({ status: 429, description: "`TICKET_LOOKUP_RATE_LIMITED`.", content: problemContent })
  @ApiResponse({ status: 503, description: "Tra cứu tạm gián đoạn.", content: problemContent })
  lookup(@Req() request: Request, @Body() input: TicketLookupInputDto): Promise<BookingResponse> {
    return this.tickets.lookup(resolveTrustedClientIp(request, this.config.NODE_ENV), input);
  }
}
