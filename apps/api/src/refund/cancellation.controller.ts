import { Body, Controller, Get, Headers, HttpCode, Inject, Param, ParseUUIDPipe, Post, Query } from "@nestjs/common";
import { ApiBody, ApiHeader, ApiParam, ApiQuery, ApiResponse, ApiTags, getSchemaPath } from "@nestjs/swagger";
import { ZodResponse } from "nestjs-zod";
import { BOOKING_TOKEN_HEADER } from "../booking/booking-access";
import type { VerifiedAccessToken } from "../iam/auth/token.service";
import { GuestOrPassenger, OptionalPassenger } from "../iam/role/guest-or-passenger";
import { ProblemDetailsDto } from "../openapi/openapi.dto";
import { CancellationService } from "./cancellation.service";
import {
  CancellationInputDto,
  CancellationQuoteDto,
  CancellationQuoteQueryDto,
  CancellationResultDto,
  type CancellationQuote,
  type CancellationResult,
} from "./dto/cancellation.dto";

const problemContent = {
  "application/problem+json": { schema: { $ref: getSchemaPath(ProblemDetailsDto) } },
};
const TOKEN_HEADER = { name: "X-Booking-Token", required: false, description: "Mã truy cập booking (khách vãng lai)." } as const;

// UC-08 — khách vãng lai (mã truy cập booking) hoặc hành khách sở hữu booking (`refund:request`, phạm vi `own`).
@ApiTags("cancellations")
@Controller("bookings/:bookingId")
/** Hủy vé / yêu cầu hoàn tiền theo chính sách lưu lúc đặt (TASK-BTP-005). */
export class CancellationController {
  constructor(@Inject(CancellationService) private readonly cancellations: CancellationService) {}

  /** Điều kiện hủy + số tiền dự kiến hoàn cho các vé đã chọn (UC-08 bước 3–6). */
  @Get("cancellation-quote")
  @GuestOrPassenger("refund:request")
  @ApiParam({ name: "bookingId", type: String, format: "uuid" })
  @ApiHeader(TOKEN_HEADER)
  @ApiQuery({ name: "ticketIds", required: true, type: String, description: "Mã vé, phân tách bằng dấu phẩy." })
  @ZodResponse({ status: 200, description: "Điều kiện hủy.", type: CancellationQuoteDto })
  @ApiResponse({ status: 404, description: "`BOOKING_NOT_FOUND`.", content: problemContent })
  @ApiResponse({ status: 422, description: "`CANCELLATION_TICKETS_INVALID`.", content: problemContent })
  quote(
    @OptionalPassenger() user: VerifiedAccessToken | null,
    @Param("bookingId", new ParseUUIDPipe()) bookingId: string,
    @Headers(BOOKING_TOKEN_HEADER) accessToken: string | undefined,
    @Query() query: CancellationQuoteQueryDto,
  ): Promise<CancellationQuote> {
    return this.cancellations.quote(user, bookingId, accessToken, query.ticketIds);
  }

  /** Hủy các vé đã chọn; số hoàn > 0 thì tạo yêu cầu hoàn tiền về phương thức đã trả. */
  @Post("cancellations")
  @HttpCode(201)
  @GuestOrPassenger("refund:request")
  @ApiParam({ name: "bookingId", type: String, format: "uuid" })
  @ApiHeader(TOKEN_HEADER)
  @ApiBody({ type: CancellationInputDto })
  @ZodResponse({ status: 201, description: "Đã hủy vé.", type: CancellationResultDto })
  @ApiResponse({ status: 404, description: "`BOOKING_NOT_FOUND`.", content: problemContent })
  @ApiResponse({
    status: 409,
    description: "`CANCELLATION_NOT_ALLOWED` (`reasons` = từng vé + lý do) / `REFUND_AMOUNT_CHANGED` (`reasons[0]` = số mới).",
    content: problemContent,
  })
  @ApiResponse({ status: 422, description: "`CANCELLATION_TICKETS_INVALID`.", content: problemContent })
  cancel(
    @OptionalPassenger() user: VerifiedAccessToken | null,
    @Param("bookingId", new ParseUUIDPipe()) bookingId: string,
    @Headers(BOOKING_TOKEN_HEADER) accessToken: string | undefined,
    @Body() input: CancellationInputDto,
  ): Promise<CancellationResult> {
    return this.cancellations.cancel(user, bookingId, accessToken, input);
  }
}
