import { Body, Controller, Get, Headers, HttpCode, Inject, Param, Post, Query } from "@nestjs/common";
import { ApiBody, ApiHeader, ApiParam, ApiQuery, ApiResponse, ApiTags, getSchemaPath } from "@nestjs/swagger";
import { createZodDto, ZodResponse } from "nestjs-zod";
import { z } from "zod";
import { LoyaltyTier } from "../database/prisma.types";
import { CurrentUser } from "../iam/auth/current-user.decorator";
import type { VerifiedAccessToken } from "../iam/auth/token.service";
import type { Authorization } from "../iam/role/authorization";
import { Authorize, Authz } from "../iam/role/authorize.decorator";
import { ProblemDetailsDto } from "../openapi/openapi.dto";
import { AdminLoyaltyService } from "./admin-loyalty.service";
import {
  LoyaltyMemberDto,
  LoyaltyReportDto,
  LoyaltyReportQueryDto,
  LoyaltyTransactionPageDto,
  MemberLookupQueryDto,
  PointAdjustInputDto,
  TransactionListQueryDto,
  type LoyaltyMember,
  type LoyaltyReport,
  type LoyaltyTransactionPage,
} from "./dto/loyalty.dto";
import { idempotencyKeyInvalid } from "./loyalty.errors";

const problemContent = {
  "application/problem+json": { schema: { $ref: getSchemaPath(ProblemDetailsDto) } },
};
const IDEMPOTENCY_KEY = /^[A-Za-z0-9_-]{8,128}$/;
/** Mã người dùng do Better Auth sinh (không phải UUID). */
class UserIdParamDto extends createZodDto(z.object({ userId: z.string().trim().min(1).max(64) })) {}

// API §7.5, FR-LOY-11/12, UC-39 — PlatformAdmin (`loyalty:manage`, chỉ role Platform). Tham số chương trình: `/admin/policies/LOYALTY`.
@ApiTags("admin-loyalty")
@Controller("admin/loyalty")
/** VXN Plus: tài khoản thành viên, điều chỉnh điểm, báo cáo (Figma ADM-12b/c/d; TASK-LOY-001). */
export class AdminLoyaltyController {
  constructor(@Inject(AdminLoyaltyService) private readonly loyalty: AdminLoyaltyService) {}

  @Get("accounts")
  @Authorize("loyalty:manage")
  @ApiQuery({ name: "email", required: true, type: String, format: "email" })
  @ZodResponse({ status: 200, description: "Tài khoản thành viên của hành khách.", type: LoyaltyMemberDto })
  @ApiResponse({ status: 404, description: "`LOYALTY_MEMBER_NOT_FOUND`.", content: problemContent })
  member(@Authz() authz: Authorization, @Query() query: MemberLookupQueryDto): Promise<LoyaltyMember> {
    return this.loyalty.member(authz, query.email);
  }

  @Get("accounts/:userId/transactions")
  @Authorize("loyalty:manage")
  @ApiParam({ name: "userId", type: String })
  @ApiQuery({ name: "offset", required: false, type: Number, minimum: 0 })
  @ApiQuery({ name: "limit", required: false, type: Number, minimum: 1, maximum: 50 })
  @ZodResponse({ status: 200, description: "Sổ điểm, mới nhất trước (chỉ ghi thêm).", type: LoyaltyTransactionPageDto })
  @ApiResponse({ status: 404, description: "`LOYALTY_MEMBER_NOT_FOUND`.", content: problemContent })
  transactions(@Authz() authz: Authorization, @Param() params: UserIdParamDto, @Query() query: TransactionListQueryDto): Promise<LoyaltyTransactionPage> {
    return this.loyalty.transactions(authz, params.userId, query);
  }

  @Post("accounts/:userId/adjustments")
  @HttpCode(201)
  @Authorize("loyalty:manage", { requireReauth: true })
  @ApiParam({ name: "userId", type: String })
  @ApiHeader({ name: "Idempotency-Key", required: true, description: "8–128 ký tự `[A-Za-z0-9_-]`; gửi lặp cùng khóa không ghi thêm giao dịch." })
  @ApiBody({ type: PointAdjustInputDto })
  @ZodResponse({ status: 201, description: "Tài khoản sau điều chỉnh (gửi lại cùng khóa → không ghi thêm).", type: LoyaltyMemberDto })
  @ApiResponse({ status: 400, description: "Dữ liệu / `Idempotency-Key` không hợp lệ.", content: problemContent })
  @ApiResponse({ status: 404, description: "`LOYALTY_MEMBER_NOT_FOUND`.", content: problemContent })
  @ApiResponse({ status: 409, description: "`LOYALTY_INSUFFICIENT_POINTS` / `LOYALTY_REQUEST_CONFLICT`.", content: problemContent })
  @ApiResponse({ status: 503, description: "Chưa ghi được audit — không đổi gì.", content: problemContent })
  adjust(
    @Authz() authz: Authorization,
    @CurrentUser() actor: VerifiedAccessToken,
    @Param() params: UserIdParamDto,
    @Headers("idempotency-key") idempotencyKey: string | undefined,
    @Body() input: PointAdjustInputDto,
  ): Promise<LoyaltyMember> {
    if (!idempotencyKey || !IDEMPOTENCY_KEY.test(idempotencyKey)) {
      throw idempotencyKeyInvalid();
    }
    return this.loyalty.adjust(authz, actor, params.userId, input, idempotencyKey);
  }

  @Get("reports")
  @Authorize("loyalty:manage")
  @ApiQuery({ name: "year", required: true, type: Number })
  @ApiQuery({ name: "quarter", required: true, type: Number, minimum: 1, maximum: 4 })
  @ApiQuery({ name: "tier", required: false, enum: LoyaltyTier })
  @ZodResponse({ status: 200, description: "Báo cáo chương trình theo tháng của quý.", type: LoyaltyReportDto })
  report(@Authz() authz: Authorization, @Query() query: LoyaltyReportQueryDto): Promise<LoyaltyReport> {
    return this.loyalty.report(authz, query);
  }
}
