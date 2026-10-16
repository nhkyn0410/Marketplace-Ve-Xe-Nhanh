import { Body, Controller, Get, HttpCode, Inject, Param, Post, Query } from "@nestjs/common";
import { ApiBody, ApiParam, ApiResponse, ApiTags, getSchemaPath } from "@nestjs/swagger";
import { ZodResponse } from "nestjs-zod";
import { CurrentUser } from "../iam/auth/current-user.decorator";
import type { VerifiedAccessToken } from "../iam/auth/token.service";
import type { Authorization } from "../iam/role/authorization";
import { Authorize, Authz } from "../iam/role/authorize.decorator";
import { ProblemDetailsDto } from "../openapi/openapi.dto";
import { AdminOperatorService } from "./admin-operator.service";
import {
  AdminBankChangeApproveDto,
  AdminBankChangeDto,
  type AdminBankChange,
  AdminBankChangeRejectDto,
  AdminOperatorIdParamDto,
  AdminOperatorListQueryDto,
  AdminOperatorPageDto,
  type AdminOperatorPage,
  AdminOperatorSuspendDto,
} from "./dto/admin-operator.dto";

const problemContent = {
  "application/problem+json": { schema: { $ref: getSchemaPath(ProblemDetailsDto) } },
};
const ID_PARAM = { name: "id", type: String, format: "uuid" } as const;

// API §7.5 — Admin quản lý nhà xe (FR-ADM-02/03, UC-23 A6). Quyền `user:manage` (PLATFORM_ADMIN); tạm khóa / mở lại
// cần xác nhận lại danh tính (Figma ADM-02f có ô TOTP).
@ApiTags("admin-operators")
@Controller("admin/operators")
/** Nhà xe đã được duyệt. */
export class AdminOperatorController {
  constructor(@Inject(AdminOperatorService) private readonly operators: AdminOperatorService) {}

  /** Mới tạo trước; tìm tên / mã / chủ nhà xe, lọc trạng thái; kèm số tuyến và chuyến đang mở bán. */
  @Get()
  @Authorize("user:manage")
  @ZodResponse({ status: 200, description: "Một trang nhà xe.", type: AdminOperatorPageDto })
  list(@Authz() authz: Authorization, @Query() query: AdminOperatorListQueryDto): Promise<AdminOperatorPage> {
    return this.operators.list(authz, query);
  }

  /** `ACTIVE` → `SUSPENDED` kèm lý do; thu hồi mọi phiên của nhà xe, email chủ nhà xe (audited). */
  @Post(":id/suspend")
  @HttpCode(204)
  @Authorize("user:manage", { requireReauth: true })
  @ApiParam(ID_PARAM)
  @ApiBody({ type: AdminOperatorSuspendDto })
  @ApiResponse({ status: 204, description: "Đã tạm khóa." })
  @ApiResponse({ status: 404, description: "`OPERATOR_NOT_FOUND`.", content: problemContent })
  @ApiResponse({ status: 409, description: "`OPERATOR_STATE_INVALID` — đang bị khóa rồi.", content: problemContent })
  @ApiResponse({ status: 503, description: "Chưa ghi được audit — không đổi gì.", content: problemContent })
  suspend(
    @Authz() authz: Authorization,
    @CurrentUser() actor: VerifiedAccessToken,
    @Param() params: AdminOperatorIdParamDto,
    @Body() input: AdminOperatorSuspendDto,
  ): Promise<void> {
    return this.operators.suspend(authz, actor, params.id, input.reason);
  }

  /** `SUSPENDED` → `ACTIVE` (audited, email chủ nhà xe). */
  @Post(":id/unsuspend")
  @HttpCode(204)
  @Authorize("user:manage", { requireReauth: true })
  @ApiParam(ID_PARAM)
  @ApiResponse({ status: 204, description: "Đã mở khóa." })
  @ApiResponse({ status: 404, description: "`OPERATOR_NOT_FOUND`.", content: problemContent })
  @ApiResponse({ status: 409, description: "`OPERATOR_STATE_INVALID` — không bị khóa.", content: problemContent })
  @ApiResponse({ status: 503, description: "Chưa ghi được audit — không đổi gì.", content: problemContent })
  unsuspend(
    @Authz() authz: Authorization,
    @CurrentUser() actor: VerifiedAccessToken,
    @Param() params: AdminOperatorIdParamDto,
  ): Promise<void> {
    return this.operators.unsuspend(authz, actor, params.id);
  }

  /** Yêu cầu đổi tài khoản nhận tiền đang chờ, kèm tài khoản đang dùng — số đầy đủ, mỗi lần xem ghi audit. */
  @Get(":id/bank-account-change")
  @Authorize("kyc:review")
  @ApiParam(ID_PARAM)
  @ZodResponse({ status: 200, description: "Yêu cầu đang chờ.", type: AdminBankChangeDto })
  @ApiResponse({
    status: 404,
    description: "`OPERATOR_NOT_FOUND` / `BANK_ACCOUNT_CHANGE_NOT_FOUND`.",
    content: problemContent,
  })
  @ApiResponse({ status: 503, description: "Chưa ghi được audit.", content: problemContent })
  getBankChange(
    @Authz() authz: Authorization,
    @CurrentUser() actor: VerifiedAccessToken,
    @Param() params: AdminOperatorIdParamDto,
  ): Promise<AdminBankChange> {
    return this.operators.getBankChange(authz, actor, params.id);
  }

  /** Xác minh: tài khoản mới dùng cho các kỳ chi trả sau, tài khoản cũ thôi dùng (audited, email chủ nhà xe). */
  @Post(":id/bank-account-change/approve")
  @HttpCode(204)
  @Authorize("kyc:review", { requireReauth: true })
  @ApiParam(ID_PARAM)
  @ApiBody({ type: AdminBankChangeApproveDto })
  @ApiResponse({ status: 204, description: "Đã xác minh." })
  @ApiResponse({ status: 404, description: "`BANK_ACCOUNT_CHANGE_NOT_FOUND` — đã xử lý / không còn chờ.", content: problemContent })
  @ApiResponse({ status: 503, description: "Chưa ghi được audit — không đổi gì.", content: problemContent })
  approveBankChange(
    @Authz() authz: Authorization,
    @CurrentUser() actor: VerifiedAccessToken,
    @Param() params: AdminOperatorIdParamDto,
    @Body() input: AdminBankChangeApproveDto,
  ): Promise<void> {
    return this.operators.approveBankChange(authz, actor, params.id, input.changeId);
  }

  /** Từ chối kèm lý do: tài khoản cũ giữ nguyên (audited, email chủ nhà xe). */
  @Post(":id/bank-account-change/reject")
  @HttpCode(204)
  @Authorize("kyc:review", { requireReauth: true })
  @ApiParam(ID_PARAM)
  @ApiBody({ type: AdminBankChangeRejectDto })
  @ApiResponse({ status: 204, description: "Đã từ chối." })
  @ApiResponse({ status: 404, description: "`BANK_ACCOUNT_CHANGE_NOT_FOUND` — đã xử lý / không còn chờ.", content: problemContent })
  @ApiResponse({ status: 503, description: "Chưa ghi được audit — không đổi gì.", content: problemContent })
  rejectBankChange(
    @Authz() authz: Authorization,
    @CurrentUser() actor: VerifiedAccessToken,
    @Param() params: AdminOperatorIdParamDto,
    @Body() input: AdminBankChangeRejectDto,
  ): Promise<void> {
    return this.operators.rejectBankChange(authz, actor, params.id, input.changeId, input.reason);
  }
}
