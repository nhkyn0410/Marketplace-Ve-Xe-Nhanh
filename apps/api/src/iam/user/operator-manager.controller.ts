import { Body, Controller, Get, HttpCode, Inject, Param, Patch, Post, Req } from "@nestjs/common";
import { ApiBody, ApiParam, ApiResponse, ApiTags, getSchemaPath } from "@nestjs/swagger";
import type { Request } from "express";
import { ZodResponse } from "nestjs-zod";
import { resolveTrustedClientIp } from "../../common/trusted-client-ip";
import { APP_CONFIG, type AppConfig } from "../../config/env.config";
import { ProblemDetailsDto } from "../../openapi/openapi.dto";
import { CurrentUser } from "../auth/current-user.decorator";
import type { VerifiedAccessToken } from "../auth/token.service";
import type { Authorization } from "../role/authorization";
import { Authorize, Authz } from "../role/authorize.decorator";
import type { AccountRequestContext } from "./account.types";
import {
  type ManagerAccount,
  ManagerAccountDto,
  ManagerCreateDto,
  ManagerIdParamDto,
  type ManagerList,
  ManagerListDto,
  ManagerReasonDto,
  ManagerUpdateDto,
} from "./dto/operator-manager.dto";
import { OperatorManagerService } from "./operator-manager.service";

const problemContent = {
  "application/problem+json": { schema: { $ref: getSchemaPath(ProblemDetailsDto) } },
};
const NOT_FOUND = { status: 404, description: "`ACCOUNT_NOT_FOUND` — không có tài khoản quản lý này trong nhà xe.", content: problemContent };
const STATE = { status: 409, description: "`ACCOUNT_STATE_CONFLICT` — trạng thái vừa đổi hoặc không cho phép.", content: problemContent };
const RATE_LIMITED = { status: 429, description: "Vượt giới hạn email mật khẩu tạm.", content: problemContent };
const UNAVAILABLE = { status: 503, description: "Audit hoặc thu hồi phiên không khả dụng — không đổi gì.", content: problemContent };

// API §7.3 — tài khoản quản lý Operator OS do chủ nhà xe cấp (TASK-IAM-007, tự thiết kế — chờ duyệt). Quyền `manager:manage`.

@ApiTags("operator-managers")
@Controller("operator/managers")
export class OperatorManagerController {
  constructor(
    @Inject(OperatorManagerService) private readonly managers: OperatorManagerService,
    @Inject(APP_CONFIG) private readonly config: AppConfig,
  ) {}

  @Get()
  @Authorize("manager:manage")
  @ZodResponse({ status: 200, description: "Tài khoản quản lý của nhà xe.", type: ManagerListDto })
  list(@CurrentUser() actor: VerifiedAccessToken, @Authz() authz: Authorization): Promise<ManagerList> {
    return this.managers.list(actor, authz);
  }

  /** Cấp tài khoản: mật khẩu tạm gửi email; lần đầu đăng nhập phải đổi mật khẩu + bật TOTP. */
  @Post()
  @HttpCode(201)
  @Authorize("manager:manage", { requireReauth: true })
  @ApiBody({ type: ManagerCreateDto })
  @ZodResponse({ status: 201, description: "Tài khoản đã tạo; `credentialDeliveryPending` = chưa gửi được email.", type: ManagerAccountDto })
  @ApiResponse({ status: 409, description: "`ACCOUNT_USERNAME_CONFLICT` — tên đăng nhập đã dùng trong nhà xe.", content: problemContent })
  @ApiResponse(RATE_LIMITED)
  @ApiResponse(UNAVAILABLE)
  create(
    @CurrentUser() actor: VerifiedAccessToken,
    @Authz() authz: Authorization,
    @Body() input: ManagerCreateDto,
    @Req() request: Request,
  ): Promise<ManagerAccount> {
    return this.managers.create(actor, authz, input, this.context(request));
  }

  /** Đổi quyền / khóa / mở khóa: có hiệu lực ngay — mọi phiên của tài khoản bị thu hồi. */
  @Patch(":managerId")
  @Authorize("manager:manage", { requireReauth: true })
  @ApiParam({ name: "managerId", type: String, format: "uuid" })
  @ApiBody({ type: ManagerUpdateDto })
  @ZodResponse({ status: 200, description: "Tài khoản sau khi cập nhật.", type: ManagerAccountDto })
  @ApiResponse(NOT_FOUND)
  @ApiResponse(STATE)
  @ApiResponse(UNAVAILABLE)
  update(
    @CurrentUser() actor: VerifiedAccessToken,
    @Authz() authz: Authorization,
    @Param() params: ManagerIdParamDto,
    @Body() input: ManagerUpdateDto,
    @Req() request: Request,
  ): Promise<ManagerAccount> {
    return this.managers.update(actor, authz, params.managerId, input, this.context(request));
  }

  /** Cấp lại mật khẩu tạm (cũng để gửi lại khi lần gửi trước lỗi); thu hồi mọi phiên. */
  @Post(":managerId/password-reset")
  @HttpCode(200)
  @Authorize("manager:manage", { requireReauth: true })
  @ApiParam({ name: "managerId", type: String, format: "uuid" })
  @ApiBody({ type: ManagerReasonDto })
  @ZodResponse({ status: 200, description: "Tài khoản sau khi cấp lại.", type: ManagerAccountDto })
  @ApiResponse(NOT_FOUND)
  @ApiResponse(STATE)
  @ApiResponse(RATE_LIMITED)
  @ApiResponse(UNAVAILABLE)
  resetPassword(
    @CurrentUser() actor: VerifiedAccessToken,
    @Authz() authz: Authorization,
    @Param() params: ManagerIdParamDto,
    @Body() input: ManagerReasonDto,
    @Req() request: Request,
  ): Promise<ManagerAccount> {
    return this.managers.resetPassword(actor, authz, params.managerId, input.reason, this.context(request));
  }

  /** Đặt lại xác thực hai lớp — kèm mật khẩu tạm mới gửi tới email của tài khoản. */
  @Post(":managerId/mfa-reset")
  @HttpCode(200)
  @Authorize("manager:manage", { requireReauth: true })
  @ApiParam({ name: "managerId", type: String, format: "uuid" })
  @ApiBody({ type: ManagerReasonDto })
  @ZodResponse({ status: 200, description: "Tài khoản sau khi đặt lại.", type: ManagerAccountDto })
  @ApiResponse(NOT_FOUND)
  @ApiResponse(STATE)
  @ApiResponse(RATE_LIMITED)
  @ApiResponse(UNAVAILABLE)
  resetMfa(
    @CurrentUser() actor: VerifiedAccessToken,
    @Authz() authz: Authorization,
    @Param() params: ManagerIdParamDto,
    @Body() input: ManagerReasonDto,
    @Req() request: Request,
  ): Promise<ManagerAccount> {
    return this.managers.resetMfa(actor, authz, params.managerId, input.reason, this.context(request));
  }

  private context(request: Request): AccountRequestContext {
    const userAgent = request.headers["user-agent"];
    return {
      ip: resolveTrustedClientIp(request, this.config.NODE_ENV),
      userAgent: typeof userAgent === "string" ? userAgent : undefined,
    };
  }
}
