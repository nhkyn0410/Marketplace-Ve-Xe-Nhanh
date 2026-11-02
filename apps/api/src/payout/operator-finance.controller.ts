import { Controller, Get, Inject, Param, ParseUUIDPipe, Query } from "@nestjs/common";
import { ApiParam, ApiQuery, ApiResponse, ApiTags, getSchemaPath } from "@nestjs/swagger";
import { ZodResponse } from "nestjs-zod";
import { PayoutStatus } from "../database/prisma.types";
import { Authorize, Authz } from "../iam/role/authorize.decorator";
import type { Authorization } from "../iam/role/authorization";
import { ProblemDetailsDto } from "../openapi/openapi.dto";
import {
  FINANCE_STATES,
  FinanceBookingPageDto,
  FinanceBookingQueryDto,
  FinanceSummaryDto,
  OperatorPayoutQueryDto,
  type FinanceBookingPage,
  type FinanceSummary,
} from "./dto/operator-finance.dto";
import { PayoutDetailDto, PayoutPageDto, type PayoutDetail, type PayoutPage } from "./dto/payout.dto";
import { OperatorFinanceService } from "./operator-finance.service";

const problemContent = {
  "application/problem+json": { schema: { $ref: getSchemaPath(ProblemDetailsDto) } },
};

// API §7.3 — tài chính của nhà xe (FR-OPR-07/08). Quyền `finance:read` phạm vi tenant (Owner); tenant lấy từ JWT.
@ApiTags("operator-finance")
@Controller("operator")
/** Tiền vé giữ hộ, giao dịch theo đơn và kỳ chi trả của nhà xe (TASK-OPR-002). */
export class OperatorFinanceController {
  constructor(@Inject(OperatorFinanceService) private readonly finance: OperatorFinanceService) {}

  @Get("finance/summary")
  @Authorize("finance:read")
  @ZodResponse({ status: 200, description: "Số dư giữ hộ, đủ điều kiện / chờ, kỳ đã chi gần nhất.", type: FinanceSummaryDto })
  summary(@Authz() authz: Authorization): Promise<FinanceSummary> {
    return this.finance.summary(authz);
  }

  @Get("finance/bookings")
  @Authorize("finance:read")
  @ApiQuery({ name: "from", required: true, type: String, format: "date" })
  @ApiQuery({ name: "to", required: true, type: String, format: "date" })
  @ApiQuery({ name: "routeId", required: false, type: String, format: "uuid" })
  @ApiQuery({ name: "state", required: false, enum: FINANCE_STATES })
  @ApiQuery({ name: "q", required: false, type: String })
  @ApiQuery({ name: "cursor", required: false, type: String, format: "uuid" })
  @ApiQuery({ name: "limit", required: false, type: Number, minimum: 1, maximum: 100 })
  @ZodResponse({ status: 200, description: "Một trang giao dịch theo đơn.", type: FinanceBookingPageDto })
  bookings(@Authz() authz: Authorization, @Query() query: FinanceBookingQueryDto): Promise<FinanceBookingPage> {
    return this.finance.bookings(authz, query);
  }

  @Get("payouts")
  @Authorize("finance:read")
  @ApiQuery({ name: "month", required: false, type: String, description: "`YYYY-MM`" })
  @ApiQuery({ name: "status", required: false, enum: PayoutStatus })
  @ApiQuery({ name: "cursor", required: false, type: String, format: "uuid" })
  @ApiQuery({ name: "limit", required: false, type: Number, minimum: 1, maximum: 100 })
  @ZodResponse({ status: 200, description: "Một trang kỳ chi trả của nhà xe.", type: PayoutPageDto })
  payouts(@Authz() authz: Authorization, @Query() query: OperatorPayoutQueryDto): Promise<PayoutPage> {
    return this.finance.payouts(authz, query);
  }

  @Get("payouts/:payoutId")
  @Authorize("finance:read")
  @ApiParam({ name: "payoutId", type: String, format: "uuid" })
  @ZodResponse({ status: 200, description: "Chi tiết kỳ chi trả.", type: PayoutDetailDto })
  @ApiResponse({ status: 404, description: "`PAYOUT_NOT_FOUND` (kể cả của nhà xe khác).", content: problemContent })
  payout(@Authz() authz: Authorization, @Param("payoutId", new ParseUUIDPipe()) payoutId: string): Promise<PayoutDetail> {
    return this.finance.payout(authz, payoutId);
  }
}
