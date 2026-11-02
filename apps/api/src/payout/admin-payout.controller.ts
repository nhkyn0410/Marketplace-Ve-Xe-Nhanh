import { applyDecorators, Body, Controller, Get, HttpCode, Inject, Param, ParseUUIDPipe, Post, Query } from "@nestjs/common";
import { ApiBody, ApiParam, ApiQuery, ApiResponse, ApiTags, getSchemaPath } from "@nestjs/swagger";
import { ZodResponse } from "nestjs-zod";
import { PayoutStatus } from "../database/prisma.types";
import { CurrentUser } from "../iam/auth/current-user.decorator";
import type { VerifiedAccessToken } from "../iam/auth/token.service";
import { Authorize, Authz } from "../iam/role/authorize.decorator";
import type { Authorization } from "../iam/role/authorization";
import { ProblemDetailsDto } from "../openapi/openapi.dto";
import { AdminPayoutService } from "./admin-payout.service";
import {
  AdminPayoutListQueryDto,
  AdminPayoutStatsDto,
  PayoutBankAccountDto,
  PayoutConfirmInputDto,
  PayoutDetailDto,
  PayoutPageDto,
  PayoutReasonInputDto,
  type AdminPayoutStats,
  type PayoutBankAccount,
  type PayoutDetail,
  type PayoutPage,
} from "./dto/payout.dto";

const problemContent = {
  "application/problem+json": { schema: { $ref: getSchemaPath(ProblemDetailsDto) } },
};
const ID_PARAM = { name: "payoutId", type: String, format: "uuid" } as const;
/** Lỗi chung của các route ghi. */
const WriteErrors = () =>
  applyDecorators(
    ApiResponse({ status: 404, description: "`PAYOUT_NOT_FOUND`.", content: problemContent }),
    ApiResponse({ status: 409, description: "`PAYOUT_STATUS_INVALID` / `PAYOUT_CHECKS_FAILED` (`reasons`).", content: problemContent }),
    ApiResponse({ status: 503, description: "Chưa ghi được audit — không đổi gì.", content: problemContent }),
  );

// API §7.5 — chi trả nhà xe (FR-ADM-10, FR-BTP-17, ADR-022, UC-26). Xem: `payment:monitor` (giám sát / đối soát — chỉ
// phía nền tảng); thao tác: `payout:manage` (TASK-IAM-007, tách từ `finance:configure`)
// (PLATFORM_ADMIN); xác nhận đã chi + xem đầy đủ số tài khoản cần xác nhận lại danh tính.
@ApiTags("admin-payouts")
@Controller("admin/payouts")
/** Kỳ chi trả cho nhà xe — rà soát, giữ lại, xác nhận đã chuyển khoản (TASK-BTP-006 / ADM-002). */
export class AdminPayoutController {
  constructor(@Inject(AdminPayoutService) private readonly payouts: AdminPayoutService) {}

  @Get()
  @Authorize("payment:monitor")
  @ApiQuery({ name: "period", required: false, type: String, format: "date" })
  @ApiQuery({ name: "operatorId", required: false, type: String, format: "uuid" })
  @ApiQuery({ name: "status", required: false, enum: PayoutStatus })
  @ApiQuery({ name: "q", required: false, type: String })
  @ApiQuery({ name: "cursor", required: false, type: String, format: "uuid" })
  @ApiQuery({ name: "limit", required: false, type: Number, minimum: 1, maximum: 100 })
  @ZodResponse({ status: 200, description: "Một trang kỳ chi trả, mới trước.", type: PayoutPageDto })
  list(@Authz() authz: Authorization, @Query() query: AdminPayoutListQueryDto): Promise<PayoutPage> {
    return this.payouts.list(authz, query);
  }

  @Get("stats")
  @Authorize("payment:monitor")
  @ZodResponse({ status: 200, description: "Số kỳ chờ rà soát / sẵn sàng / đang giữ, đã chi trong tháng.", type: AdminPayoutStatsDto })
  stats(@Authz() authz: Authorization): Promise<AdminPayoutStats> {
    return this.payouts.stats(authz);
  }

  @Get(":payoutId")
  @Authorize("payment:monitor")
  @ApiParam(ID_PARAM)
  @ZodResponse({ status: 200, description: "Chi tiết kỳ chi trả.", type: PayoutDetailDto })
  @ApiResponse({ status: 404, description: "`PAYOUT_NOT_FOUND`.", content: problemContent })
  get(@Authz() authz: Authorization, @Param("payoutId", new ParseUUIDPipe()) payoutId: string): Promise<PayoutDetail> {
    return this.payouts.get(authz, payoutId);
  }

  /** Rà soát xong → sẵn sàng chuyển khoản (phải qua kiểm tra trước khi chi). */
  @Post(":payoutId/review")
  @HttpCode(200)
  @Authorize("payout:manage")
  @WriteErrors()
  @ApiParam(ID_PARAM)
  @ZodResponse({ status: 200, description: "Kỳ sau khi rà soát.", type: PayoutDetailDto })
  review(@Authz() authz: Authorization, @CurrentUser() actor: VerifiedAccessToken, @Param("payoutId", new ParseUUIDPipe()) payoutId: string): Promise<PayoutDetail> {
    return this.payouts.review(authz, actor, payoutId);
  }

  @Post(":payoutId/hold")
  @HttpCode(200)
  @Authorize("payout:manage")
  @WriteErrors()
  @ApiParam(ID_PARAM)
  @ApiBody({ type: PayoutReasonInputDto })
  @ZodResponse({ status: 200, description: "Kỳ đang giữ lại.", type: PayoutDetailDto })
  hold(
    @Authz() authz: Authorization,
    @CurrentUser() actor: VerifiedAccessToken,
    @Param("payoutId", new ParseUUIDPipe()) payoutId: string,
    @Body() input: PayoutReasonInputDto,
  ): Promise<PayoutDetail> {
    return this.payouts.hold(authz, actor, payoutId, input.reason);
  }

  /** Mở lại kỳ đang giữ → chờ rà soát (chụp lại tài khoản nhận tiền đã xác minh). */
  @Post(":payoutId/release")
  @HttpCode(200)
  @Authorize("payout:manage")
  @WriteErrors()
  @ApiParam(ID_PARAM)
  @ZodResponse({ status: 200, description: "Kỳ chờ rà soát.", type: PayoutDetailDto })
  release(@Authz() authz: Authorization, @CurrentUser() actor: VerifiedAccessToken, @Param("payoutId", new ParseUUIDPipe()) payoutId: string): Promise<PayoutDetail> {
    return this.payouts.release(authz, actor, payoutId);
  }

  /** Đã chuyển khoản: mã giao dịch ngân hàng + thời điểm + ghi chú → đã chi, ghi sổ escrow. */
  @Post(":payoutId/confirm")
  @HttpCode(200)
  @Authorize("payout:manage", { requireReauth: true })
  @WriteErrors()
  @ApiParam(ID_PARAM)
  @ApiBody({ type: PayoutConfirmInputDto })
  @ZodResponse({ status: 200, description: "Kỳ đã chi.", type: PayoutDetailDto })
  @ApiResponse({ status: 422, description: "`PAYOUT_TRANSFER_TIME_INVALID`.", content: problemContent })
  confirm(
    @Authz() authz: Authorization,
    @CurrentUser() actor: VerifiedAccessToken,
    @Param("payoutId", new ParseUUIDPipe()) payoutId: string,
    @Body() input: PayoutConfirmInputDto,
  ): Promise<PayoutDetail> {
    return this.payouts.confirm(authz, actor, payoutId, input);
  }

  /** Hủy kỳ chưa chi — bút toán trả về kỳ sau. */
  @Post(":payoutId/cancel")
  @HttpCode(200)
  @Authorize("payout:manage")
  @WriteErrors()
  @ApiParam(ID_PARAM)
  @ApiBody({ type: PayoutReasonInputDto })
  @ZodResponse({ status: 200, description: "Kỳ đã hủy.", type: PayoutDetailDto })
  cancel(
    @Authz() authz: Authorization,
    @CurrentUser() actor: VerifiedAccessToken,
    @Param("payoutId", new ParseUUIDPipe()) payoutId: string,
    @Body() input: PayoutReasonInputDto,
  ): Promise<PayoutDetail> {
    return this.payouts.cancel(authz, actor, payoutId, input.reason);
  }

  /** Số tài khoản đầy đủ (ghi audit mỗi lần). */
  @Post(":payoutId/bank-reveal")
  @HttpCode(200)
  @Authorize("payout:manage", { requireReauth: true })
  @WriteErrors()
  @ApiParam(ID_PARAM)
  @ZodResponse({ status: 200, description: "Tài khoản nhận tiền đầy đủ.", type: PayoutBankAccountDto })
  revealBank(@Authz() authz: Authorization, @CurrentUser() actor: VerifiedAccessToken, @Param("payoutId", new ParseUUIDPipe()) payoutId: string): Promise<PayoutBankAccount> {
    return this.payouts.revealBank(authz, actor, payoutId);
  }
}
