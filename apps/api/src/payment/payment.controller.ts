import { Body, Controller, Headers, HttpCode, Inject, Param, ParseUUIDPipe, Post, Req } from "@nestjs/common";
import { ApiBody, ApiHeader, ApiParam, ApiResponse, ApiTags, getSchemaPath } from "@nestjs/swagger";
import type { Request } from "express";
import { ZodResponse } from "nestjs-zod";
import { BOOKING_TOKEN_HEADER } from "../booking/booking-access";
import { resolveTrustedClientIp } from "../common/trusted-client-ip";
import { APP_CONFIG, type AppConfig } from "../config/env.config";
import type { VerifiedAccessToken } from "../iam/auth/token.service";
import { GuestOrPassenger, OptionalPassenger } from "../iam/role/guest-or-passenger";
import { ProblemDetailsDto } from "../openapi/openapi.dto";
import { PaymentInputDto, PaymentResponseDto, type PaymentResponse } from "./dto/payment.dto";
import { PaymentService } from "./payment.service";

const problemContent = {
  "application/problem+json": { schema: { $ref: getSchemaPath(ProblemDetailsDto) } },
};

// API §7.2 — khách vãng lai hoặc hành khách đã đăng nhập (`payment:create`, phạm vi `own`).
@ApiTags("payments")
@Controller("bookings/:bookingId/payments")
/** Thanh toán booking qua VNPay / MoMo (TASK-BTP-003). */
export class PaymentController {
  constructor(
    @Inject(PaymentService) private readonly payments: PaymentService,
    @Inject(APP_CONFIG) private readonly config: AppConfig,
  ) {}

  /** Tạo (hoặc lấy lại) link thanh toán ở cổng đã chọn; kết quả cuối do callback của cổng quyết. */
  @Post()
  @HttpCode(201)
  @GuestOrPassenger("payment:create")
  @ApiParam({ name: "bookingId", type: String, format: "uuid" })
  @ApiHeader({ name: "X-Booking-Token", required: false, description: "Mã truy cập trả lúc tạo booking (khách vãng lai)." })
  @ApiBody({ type: PaymentInputDto })
  @ZodResponse({ status: 201, description: "Payment `PROCESSING` kèm link thanh toán.", type: PaymentResponseDto })
  @ApiResponse({ status: 404, description: "`BOOKING_NOT_FOUND`.", content: problemContent })
  @ApiResponse({ status: 409, description: "`BOOKING_EXPIRED` / `BOOKING_INVALID_STATE` / `PAYMENT_IN_PROGRESS`.", content: problemContent })
  @ApiResponse({ status: 422, description: "`PAYMENT_AMOUNT_OUT_OF_RANGE`.", content: problemContent })
  @ApiResponse({ status: 502, description: "`PAYMENT_PROVIDER_ERROR`.", content: problemContent })
  @ApiResponse({ status: 503, description: "`PAYMENT_PROVIDER_UNAVAILABLE` — cổng chưa cấu hình.", content: problemContent })
  create(
    @OptionalPassenger() user: VerifiedAccessToken | null,
    @Param("bookingId", new ParseUUIDPipe()) bookingId: string,
    @Headers(BOOKING_TOKEN_HEADER) accessToken: string | undefined,
    @Body() input: PaymentInputDto,
    @Req() request: Request,
  ): Promise<PaymentResponse> {
    return this.payments.create(user, bookingId, accessToken, input, resolveTrustedClientIp(request, this.config.NODE_ENV));
  }
}
