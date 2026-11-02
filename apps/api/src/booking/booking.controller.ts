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
  type BookingResponse,
  type CreatedBooking,
} from "./dto/booking.dto";

const problemContent = {
  "application/problem+json": { schema: { $ref: getSchemaPath(ProblemDetailsDto) } },
};

// API §7.2 — khách vãng lai hoặc hành khách đã đăng nhập (`booking:create`, phạm vi `own`).
@ApiTags("bookings")
@Controller("bookings")
/** Đặt vé (TASK-BTP-002). */
export class BookingController {
  constructor(@Inject(BookingService) private readonly bookings: BookingService) {}

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
}
