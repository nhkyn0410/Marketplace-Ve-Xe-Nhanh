import { Body, Controller, Get, Headers, HttpCode, Inject, Param, Post, Query, Req } from "@nestjs/common";
import { ApiBody, ApiHeader, ApiParam, ApiResponse, ApiTags, getSchemaPath } from "@nestjs/swagger";
import type { Request } from "express";
import { ZodResponse } from "nestjs-zod";
import { resolveTrustedClientIp } from "../common/trusted-client-ip";
import { APP_CONFIG, type AppConfig } from "../config/env.config";
import { OperatorApplicationDocumentType } from "../database/prisma.types";
import { CurrentUser } from "../iam/auth/current-user.decorator";
import type { VerifiedAccessToken } from "../iam/auth/token.service";
import type { Authorization } from "../iam/role/authorization";
import { Authorize, Authz } from "../iam/role/authorize.decorator";
import type { AccountRequestContext } from "../iam/user/account.types";
import { ProblemDetailsDto } from "../openapi/openapi.dto";
import { DocumentDownloadResponseDto, type DocumentDownloadResponse } from "./dto/operator-application.dto";
import {
  AdminApplicationDetailDto,
  type AdminApplicationDetail,
  AdminApplicationDocumentParamDto,
  AdminApplicationListQueryDto,
  AdminApplicationListResponseDto,
  type AdminApplicationListResponse,
  AdminApplicationParamDto,
  ApprovalInputDto,
  ApprovalResponseDto,
  type ApprovalResponse,
  DecisionInputDto,
  DecisionResponseDto,
  type DecisionResponse,
} from "./dto/operator-application-review.dto";
import { idempotencyKeyInvalid } from "./operator-application.errors";
import { OperatorApplicationReviewService } from "./operator-application-review.service";

const problemContent = {
  "application/problem+json": { schema: { $ref: getSchemaPath(ProblemDetailsDto) } },
};
const NOT_FOUND = { status: 404, description: "`OPERATOR_APPLICATION_NOT_FOUND`.", content: problemContent };
const NOT_SUBMITTED = {
  status: 409,
  description: "`OPERATOR_APPLICATION_INVALID_STATE` — hồ sơ không ở `SUBMITTED` (hoặc đã duyệt bằng khóa khác).",
  content: problemContent,
};
const REAUTH = { status: 401, description: "`AUTH_REAUTH_REQUIRED` — cần xác thực lại (TOTP).", content: problemContent };
const UNAVAILABLE = { status: 503, description: "Audit / email / kho giấy tờ không phản hồi.", content: problemContent };
const IDEMPOTENCY_KEY = /^[A-Za-z0-9_-]{8,128}$/;

// API §7.5 — Admin duyệt hồ sơ đăng ký nhà xe (UC-23, BR-75, TASK-ADM-001 phần hồ sơ).
@ApiTags("admin-operator-applications")
@Controller("admin/operator-applications")
/** Hàng đợi + chi tiết hồ sơ đăng ký nhà xe; duyệt (tạo Operator + Owner), yêu cầu bổ sung, từ chối. */
export class OperatorApplicationReviewController {
  constructor(
    @Inject(OperatorApplicationReviewService) private readonly reviews: OperatorApplicationReviewService,
    @Inject(APP_CONFIG) private readonly config: AppConfig,
  ) {}

  /** Hồ sơ đã gửi duyệt, mới gửi trước, kèm cảnh báo trùng thông tin định danh. */
  @Get()
  @Authorize("kyc:review")
  @ZodResponse({ status: 200, description: "Một trang hàng đợi hồ sơ.", type: AdminApplicationListResponseDto })
  list(
    @Authz() authz: Authorization,
    @Query() query: AdminApplicationListQueryDto,
  ): Promise<AdminApplicationListResponse> {
    return this.reviews.list(authz, query);
  }

  /** Chi tiết hồ sơ: thông tin, giấy tờ, tài khoản nhận tiền (che), trùng định danh, lịch sử. */
  @Get(":applicationId")
  @Authorize("kyc:review")
  @ApiParam({ name: "applicationId", type: String, format: "uuid" })
  @ZodResponse({ status: 200, description: "Chi tiết hồ sơ.", type: AdminApplicationDetailDto })
  @ApiResponse(NOT_FOUND)
  get(@Authz() authz: Authorization, @Param() params: AdminApplicationParamDto): Promise<AdminApplicationDetail> {
    return this.reviews.get(authz, params.applicationId);
  }

  /** URL xem một giấy tờ KYC (hạn 5 phút, mỗi lần cấp ghi audit). */
  @Post(":applicationId/documents/:type/download-url")
  @HttpCode(200)
  @Authorize("kyc:review")
  @ApiParam({ name: "applicationId", type: String, format: "uuid" })
  @ApiParam({ name: "type", enum: Object.values(OperatorApplicationDocumentType) })
  @ZodResponse({ status: 200, description: "URL xem giấy tờ.", type: DocumentDownloadResponseDto })
  @ApiResponse({ status: 404, description: "`OPERATOR_APPLICATION_DOCUMENT_NOT_FOUND`.", content: problemContent })
  @ApiResponse(UNAVAILABLE)
  createDocumentDownload(
    @Authz() authz: Authorization,
    @CurrentUser() actor: VerifiedAccessToken,
    @Param() params: AdminApplicationDocumentParamDto,
  ): Promise<DocumentDownloadResponse> {
    return this.reviews.createDocumentDownload(authz, actor, params.applicationId, params.type);
  }

  /** Duyệt: tạo nhà xe + tài khoản chủ nhà xe (mật khẩu tạm gửi email liên hệ), hồ sơ → `APPROVED`. */
  @Post(":applicationId/approve")
  @HttpCode(200)
  @Authorize("kyc:review", { requireReauth: true })
  @ApiParam({ name: "applicationId", type: String, format: "uuid" })
  @ApiHeader({
    name: "Idempotency-Key",
    required: true,
    description: "8–128 ký tự `[A-Za-z0-9_-]`; gửi lặp cùng khóa trả lại kết quả lần đầu.",
  })
  @ApiBody({ type: ApprovalInputDto })
  @ZodResponse({ status: 200, description: "Đã duyệt (hoặc kết quả của lần duyệt cùng khóa).", type: ApprovalResponseDto })
  @ApiResponse({ status: 400, description: "Dữ liệu / `Idempotency-Key` không hợp lệ.", content: problemContent })
  @ApiResponse(REAUTH)
  @ApiResponse(NOT_FOUND)
  @ApiResponse({
    status: 409,
    description: "`OPERATOR_SLUG_CONFLICT` hoặc `OPERATOR_APPLICATION_INVALID_STATE`.",
    content: problemContent,
  })
  @ApiResponse({ status: 429, description: "Vượt hạn mức gửi mật khẩu tạm (IAM-005).", content: problemContent })
  @ApiResponse(UNAVAILABLE)
  approve(
    @Authz() authz: Authorization,
    @CurrentUser() actor: VerifiedAccessToken,
    @Param() params: AdminApplicationParamDto,
    @Headers("idempotency-key") idempotencyKey: string | undefined,
    @Body() input: ApprovalInputDto,
    @Req() request: Request,
  ): Promise<ApprovalResponse> {
    if (!idempotencyKey || !IDEMPOTENCY_KEY.test(idempotencyKey)) {
      throw idempotencyKeyInvalid();
    }
    return this.reviews.approve(authz, actor, params.applicationId, input, idempotencyKey, this.context(request));
  }

  /** Yêu cầu bổ sung: hồ sơ → `NEEDS_INFO`, người nộp nhận email kèm nội dung và link mới. */
  @Post(":applicationId/request-info")
  @HttpCode(200)
  @Authorize("kyc:review")
  @ApiParam({ name: "applicationId", type: String, format: "uuid" })
  @ApiBody({ type: DecisionInputDto })
  @ZodResponse({ status: 200, description: "Hồ sơ đã chuyển `NEEDS_INFO`.", type: DecisionResponseDto })
  @ApiResponse(NOT_FOUND)
  @ApiResponse(NOT_SUBMITTED)
  @ApiResponse(UNAVAILABLE)
  requestInfo(
    @Authz() authz: Authorization,
    @CurrentUser() actor: VerifiedAccessToken,
    @Param() params: AdminApplicationParamDto,
    @Body() input: DecisionInputDto,
  ): Promise<DecisionResponse> {
    return this.reviews.requestInfo(authz, actor, params.applicationId, input.reason);
  }

  /** Từ chối: hồ sơ → `REJECTED`, link hết hiệu lực, người nộp nhận email kèm lý do. */
  @Post(":applicationId/reject")
  @HttpCode(200)
  @Authorize("kyc:review", { requireReauth: true })
  @ApiParam({ name: "applicationId", type: String, format: "uuid" })
  @ApiBody({ type: DecisionInputDto })
  @ZodResponse({ status: 200, description: "Hồ sơ đã chuyển `REJECTED`.", type: DecisionResponseDto })
  @ApiResponse(REAUTH)
  @ApiResponse(NOT_FOUND)
  @ApiResponse(NOT_SUBMITTED)
  @ApiResponse(UNAVAILABLE)
  reject(
    @Authz() authz: Authorization,
    @CurrentUser() actor: VerifiedAccessToken,
    @Param() params: AdminApplicationParamDto,
    @Body() input: DecisionInputDto,
  ): Promise<DecisionResponse> {
    return this.reviews.reject(authz, actor, params.applicationId, input.reason);
  }

  /** Gửi lại mật khẩu tạm cho chủ nhà xe khi lần gửi lúc duyệt lỗi (UC-23 A4). */
  @Post(":applicationId/resend-owner-credentials")
  @HttpCode(200)
  @Authorize("kyc:review", { requireReauth: true })
  @ApiParam({ name: "applicationId", type: String, format: "uuid" })
  @ZodResponse({ status: 200, description: "Đã gửi lại mật khẩu tạm.", type: ApprovalResponseDto })
  @ApiResponse(REAUTH)
  @ApiResponse(NOT_FOUND)
  @ApiResponse({
    status: 409,
    description: "`OPERATOR_APPLICATION_INVALID_STATE` (chưa duyệt) / `ACCOUNT_STATE_CONFLICT` (đã gửi được rồi).",
    content: problemContent,
  })
  @ApiResponse({ status: 429, description: "Vượt hạn mức gửi mật khẩu tạm (IAM-005).", content: problemContent })
  @ApiResponse(UNAVAILABLE)
  resendOwnerCredentials(
    @Authz() authz: Authorization,
    @CurrentUser() actor: VerifiedAccessToken,
    @Param() params: AdminApplicationParamDto,
    @Req() request: Request,
  ): Promise<ApprovalResponse> {
    return this.reviews.resendOwnerCredentials(authz, actor, params.applicationId, this.context(request));
  }

  private context(request: Request): AccountRequestContext {
    const userAgent = request.headers["user-agent"];
    return {
      ip: resolveTrustedClientIp(request, this.config.NODE_ENV),
      userAgent: typeof userAgent === "string" ? userAgent : undefined,
    };
  }
}
