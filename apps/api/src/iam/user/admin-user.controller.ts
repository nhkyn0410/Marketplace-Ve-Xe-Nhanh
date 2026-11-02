import { Body, Controller, Get, HttpCode, Inject, Param, Post, Put, Query } from "@nestjs/common";
import { ApiBody, ApiParam, ApiResponse, ApiTags, getSchemaPath } from "@nestjs/swagger";
import { ZodResponse } from "nestjs-zod";
import { ProblemDetailsDto } from "../../openapi/openapi.dto";
import { CurrentUser } from "../auth/current-user.decorator";
import type { VerifiedAccessToken } from "../auth/token.service";
import type { Authorization } from "../role/authorization";
import { Authorize, Authz } from "../role/authorize.decorator";
import { AdminAccountService } from "./admin-account.service";
import {
  AdminAccountIdParamDto,
  AdminAccountLockDto,
  AdminEmployeeListQueryDto,
  AdminEmployeePageDto,
  type EmployeePage,
  AdminPassengerBookingPageDto,
  type AdminPassengerBookingPage,
  AdminPassengerBookingQueryDto,
  AdminPassengerDetailDto,
  type AdminPassengerDetail,
  AdminPassengerListQueryDto,
  AdminPassengerPageDto,
  type PassengerPage,
  AdminPlatformAccountCreateDto,
  AdminPlatformAccountDto,
  type AdminPlatformAccount,
  AdminPlatformAccountListDto,
  type PlatformAccountList,
  AdminPlatformAccountListQueryDto,
  AdminPlatformPermissionsUpdateDto,
  AdminUserIdParamDto,
} from "./dto/admin-user.dto";

const problemContent = {
  "application/problem+json": { schema: { $ref: getSchemaPath(ProblemDetailsDto) } },
};
const NOT_FOUND = { status: 404, description: "`ACCOUNT_NOT_FOUND`.", content: problemContent };
const STATE = { status: 409, description: "`ACCOUNT_STATE_CONFLICT` — trạng thái không cho phép.", content: problemContent };
const UNAVAILABLE = { status: 503, description: "Chưa ghi được audit — không đổi gì.", content: problemContent };
const NOT_ASSIGNABLE = {
  status: 400,
  description: "`PERMISSION_NOT_ASSIGNABLE` — có quyền không áp dụng cho vai trò của tài khoản.",
  content: problemContent,
};
const GRANT_FORBIDDEN = {
  status: 403,
  description: "`PERMISSION_DENIED` / `PERMISSION_GRANT_FORBIDDEN` — cấp hoặc gỡ quyền mình không có (TASK-IAM-007).",
  content: problemContent,
};

// API §7.5 — Admin quản lý người dùng (FR-ADM-02/03, FR-IAM-08; Figma ADM-03a…03d). Quyền `user:manage`
// (PLATFORM_ADMIN); thao tác thay đổi cần xác nhận lại danh tính (Figma có ô TOTP).

@ApiTags("admin-users")
@Controller("admin/passengers")
/** Tài khoản hành khách. */
export class AdminPassengerController {
  constructor(@Inject(AdminAccountService) private readonly accounts: AdminAccountService) {}

  /** Mới đăng ký trước; tìm email / họ tên, lọc trạng thái. */
  @Get()
  @Authorize("user:manage")
  @ZodResponse({ status: 200, description: "Một trang hành khách.", type: AdminPassengerPageDto })
  list(@Authz() authz: Authorization, @Query() query: AdminPassengerListQueryDto): Promise<PassengerPage> {
    return this.accounts.listPassengers(authz, query);
  }

  /** Chi tiết tài khoản hành khách — mỗi lượt xem ghi audit (Security §239); tiền chỉ có với `payment:monitor`. */
  @Get(":id")
  @Authorize("user:manage")
  @ApiParam({ name: "id", type: String })
  @ZodResponse({ status: 200, description: "Chi tiết hành khách.", type: AdminPassengerDetailDto })
  @ApiResponse(NOT_FOUND)
  @ApiResponse({ status: 503, description: "Chưa ghi được nhật ký lượt xem — không trả dữ liệu.", content: problemContent })
  detail(@Authz() authz: Authorization, @CurrentUser() actor: VerifiedAccessToken, @Param() params: AdminUserIdParamDto): Promise<AdminPassengerDetail> {
    return this.accounts.passengerDetail(authz, actor, params.id);
  }

  /** Đơn đặt vé của tài khoản, mới đặt trước; kèm người đi trên từng vé. */
  @Get(":id/bookings")
  @Authorize("user:manage")
  @ApiParam({ name: "id", type: String })
  @ZodResponse({ status: 200, description: "Một trang đơn đặt vé.", type: AdminPassengerBookingPageDto })
  @ApiResponse(NOT_FOUND)
  bookings(
    @Authz() authz: Authorization,
    @CurrentUser() actor: VerifiedAccessToken,
    @Param() params: AdminUserIdParamDto,
    @Query() query: AdminPassengerBookingQueryDto,
  ): Promise<AdminPassengerBookingPage> {
    return this.accounts.passengerBookings(authz, actor, params.id, query);
  }

  /** Khóa (lý do bắt buộc): không đăng nhập / làm mới phiên được, mọi phiên bị thu hồi (audited). */
  @Post(":id/lock")
  @HttpCode(204)
  @Authorize("user:manage", { requireReauth: true })
  @ApiParam({ name: "id", type: String })
  @ApiBody({ type: AdminAccountLockDto })
  @ApiResponse({ status: 204, description: "Đã khóa." })
  @ApiResponse(NOT_FOUND)
  @ApiResponse(STATE)
  @ApiResponse(UNAVAILABLE)
  lock(
    @Authz() authz: Authorization,
    @CurrentUser() actor: VerifiedAccessToken,
    @Param() params: AdminUserIdParamDto,
    @Body() input: AdminAccountLockDto,
  ): Promise<void> {
    return this.accounts.lockPassenger(authz, actor, params.id, input.reason);
  }

  @Post(":id/unlock")
  @HttpCode(204)
  @Authorize("user:manage", { requireReauth: true })
  @ApiParam({ name: "id", type: String })
  @ApiResponse({ status: 204, description: "Đã mở khóa." })
  @ApiResponse(NOT_FOUND)
  @ApiResponse(STATE)
  @ApiResponse(UNAVAILABLE)
  unlock(@Authz() authz: Authorization, @CurrentUser() actor: VerifiedAccessToken, @Param() params: AdminUserIdParamDto): Promise<void> {
    return this.accounts.unlockPassenger(authz, actor, params.id);
  }
}

@ApiTags("admin-users")
@Controller("admin/employees")
/** Nhân viên của mọi nhà xe — Admin chỉ xem (tạo / khóa / cấp lại mật khẩu do chủ nhà xe làm). */
export class AdminEmployeeController {
  constructor(@Inject(AdminAccountService) private readonly accounts: AdminAccountService) {}

  @Get()
  @Authorize("user:manage")
  @ZodResponse({ status: 200, description: "Một trang nhân viên nhà xe.", type: AdminEmployeePageDto })
  list(@Authz() authz: Authorization, @Query() query: AdminEmployeeListQueryDto): Promise<EmployeePage> {
    return this.accounts.listEmployees(authz, query);
  }
}

@ApiTags("admin-users")
@Controller("admin/platform-accounts")
/** Tài khoản quản trị nội bộ (`platform/…`) — chỉ được cấp ở đây, không có đăng ký công khai. Quyền `access:manage` (TASK-IAM-007). */
export class AdminPlatformAccountController {
  constructor(@Inject(AdminAccountService) private readonly accounts: AdminAccountService) {}

  @Get()
  @Authorize("access:manage")
  @ZodResponse({ status: 200, description: "Mọi tài khoản quản trị.", type: AdminPlatformAccountListDto })
  list(
    @Authz() authz: Authorization,
    @CurrentUser() actor: VerifiedAccessToken,
    @Query() query: AdminPlatformAccountListQueryDto,
  ): Promise<PlatformAccountList> {
    return this.accounts.listPlatformAccounts(authz, actor, query);
  }

  /** Cấp tài khoản: mật khẩu tạm gửi email nội bộ; lần đầu đăng nhập phải đổi mật khẩu + bật TOTP. */
  @Post()
  @Authorize("access:manage", { requireReauth: true })
  @ApiBody({ type: AdminPlatformAccountCreateDto })
  @ZodResponse({ status: 201, description: "Tài khoản đã tạo; `credentialDeliveryPending` = chưa gửi được email.", type: AdminPlatformAccountDto })
  @ApiResponse({ status: 409, description: "`PLATFORM_ACCOUNT_CONFLICT` — trùng tên đăng nhập / email.", content: problemContent })
  @ApiResponse(NOT_ASSIGNABLE)
  @ApiResponse(GRANT_FORBIDDEN)
  @ApiResponse({ status: 429, description: "`ACCOUNT_TEMP_EMAIL_RATE_LIMITED`.", content: problemContent })
  @ApiResponse(UNAVAILABLE)
  create(
    @Authz() authz: Authorization,
    @CurrentUser() actor: VerifiedAccessToken,
    @Body() input: AdminPlatformAccountCreateDto,
  ): Promise<AdminPlatformAccount> {
    return this.accounts.createPlatformAccount(authz, actor, input);
  }

  /** Cấp lại mật khẩu tạm (cũng để gửi lại khi lần gửi trước lỗi); thu hồi mọi phiên. */
  @Post(":id/reset-password")
  @HttpCode(200)
  @Authorize("access:manage", { requireReauth: true })
  @ApiParam({ name: "id", type: String, format: "uuid" })
  @ZodResponse({ status: 200, description: "Tài khoản sau khi cấp lại.", type: AdminPlatformAccountDto })
  @ApiResponse(NOT_FOUND)
  @ApiResponse({ status: 409, description: "`ACCOUNT_STATE_CONFLICT` / `PLATFORM_ACCOUNT_SELF_ACTION`.", content: problemContent })
  @ApiResponse(UNAVAILABLE)
  resetPassword(
    @Authz() authz: Authorization,
    @CurrentUser() actor: VerifiedAccessToken,
    @Param() params: AdminAccountIdParamDto,
  ): Promise<AdminPlatformAccount> {
    return this.accounts.resetPlatformPassword(authz, actor, params.id);
  }

  /** Đặt lại xác thực hai lớp — kèm mật khẩu tạm mới gửi tới email của tài khoản. */
  @Post(":id/reset-mfa")
  @HttpCode(200)
  @Authorize("access:manage", { requireReauth: true })
  @ApiParam({ name: "id", type: String, format: "uuid" })
  @ZodResponse({ status: 200, description: "Tài khoản sau khi đặt lại.", type: AdminPlatformAccountDto })
  @ApiResponse(NOT_FOUND)
  @ApiResponse({ status: 409, description: "`ACCOUNT_STATE_CONFLICT` / `PLATFORM_ACCOUNT_SELF_ACTION`.", content: problemContent })
  @ApiResponse(UNAVAILABLE)
  resetMfa(
    @Authz() authz: Authorization,
    @CurrentUser() actor: VerifiedAccessToken,
    @Param() params: AdminAccountIdParamDto,
  ): Promise<AdminPlatformAccount> {
    return this.accounts.resetPlatformMfa(authz, actor, params.id);
  }

  @Post(":id/lock")
  @HttpCode(204)
  @Authorize("access:manage", { requireReauth: true })
  @ApiParam({ name: "id", type: String, format: "uuid" })
  @ApiBody({ type: AdminAccountLockDto })
  @ApiResponse({ status: 204, description: "Đã khóa." })
  @ApiResponse(NOT_FOUND)
  @ApiResponse({
    status: 409,
    description: "`ACCOUNT_STATE_CONFLICT` / `PLATFORM_ACCOUNT_SELF_ACTION` / `PLATFORM_ACCOUNT_LAST_ADMIN`.",
    content: problemContent,
  })
  @ApiResponse(UNAVAILABLE)
  lock(
    @Authz() authz: Authorization,
    @CurrentUser() actor: VerifiedAccessToken,
    @Param() params: AdminAccountIdParamDto,
    @Body() input: AdminAccountLockDto,
  ): Promise<void> {
    return this.accounts.lockPlatformAccount(authz, actor, params.id, input.reason);
  }

  @Post(":id/unlock")
  @HttpCode(204)
  @Authorize("access:manage", { requireReauth: true })
  @ApiParam({ name: "id", type: String, format: "uuid" })
  @ApiResponse({ status: 204, description: "Đã mở khóa." })
  @ApiResponse(NOT_FOUND)
  @ApiResponse(STATE)
  @ApiResponse(UNAVAILABLE)
  unlock(@Authz() authz: Authorization, @CurrentUser() actor: VerifiedAccessToken, @Param() params: AdminAccountIdParamDto): Promise<void> {
    return this.accounts.unlockPlatformAccount(authz, actor, params.id);
  }

  /** Phân quyền (FR-IAM-07, TASK-IAM-007): có hiệu lực ngay — mọi phiên của tài khoản bị thu hồi, phải đăng nhập lại. */
  @Put(":id/permissions")
  @Authorize("access:manage", { requireReauth: true })
  @ApiParam({ name: "id", type: String, format: "uuid" })
  @ApiBody({ type: AdminPlatformPermissionsUpdateDto })
  @ZodResponse({ status: 200, description: "Tài khoản sau khi phân quyền.", type: AdminPlatformAccountDto })
  @ApiResponse(NOT_ASSIGNABLE)
  @ApiResponse(GRANT_FORBIDDEN)
  @ApiResponse(NOT_FOUND)
  @ApiResponse({
    status: 409,
    description: "`PLATFORM_ACCOUNT_SELF_ACTION` / `PLATFORM_ACCOUNT_LAST_ADMIN`.",
    content: problemContent,
  })
  @ApiResponse(UNAVAILABLE)
  updatePermissions(
    @Authz() authz: Authorization,
    @CurrentUser() actor: VerifiedAccessToken,
    @Param() params: AdminAccountIdParamDto,
    @Body() input: AdminPlatformPermissionsUpdateDto,
  ): Promise<AdminPlatformAccount> {
    return this.accounts.updatePlatformPermissions(authz, actor, params.id, input);
  }
}
