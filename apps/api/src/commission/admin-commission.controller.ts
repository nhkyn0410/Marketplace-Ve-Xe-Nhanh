import { Body, Controller, Get, HttpCode, Inject, Param, Post, Put } from "@nestjs/common";
import { ApiBody, ApiParam, ApiResponse, ApiTags, getSchemaPath } from "@nestjs/swagger";
import { ZodResponse } from "nestjs-zod";
import { CurrentUser } from "../iam/auth/current-user.decorator";
import type { VerifiedAccessToken } from "../iam/auth/token.service";
import type { Authorization } from "../iam/role/authorization";
import { Authorize, Authz } from "../iam/role/authorize.decorator";
import { ProblemDetailsDto } from "../openapi/openapi.dto";
import { AdminCommissionService } from "./admin-commission.service";
import {
  CommissionOverviewDto,
  type CommissionOverview,
  CommissionRuleCancelDto,
  CommissionRuleCreateDto,
  CommissionRuleDto,
  CommissionRuleIdParamDto,
  type CommissionRuleResponse,
  CommissionRuleUpdateDto,
} from "./dto/admin-commission.dto";

const problemContent = {
  "application/problem+json": { schema: { $ref: getSchemaPath(ProblemDetailsDto) } },
};
const ID_PARAM = { name: "id", type: String, format: "uuid" } as const;

// API §7.5 — hoa hồng (FR-ADM-07, BR-31, UC-25). Quyền `finance:configure` (PLATFORM_ADMIN); thay đổi cần xác nhận lại
// danh tính.
@ApiTags("admin-commission")
@Controller("admin/commission-rules")
/** Hoa hồng mặc định + mức riêng theo nhà xe. */
export class AdminCommissionController {
  constructor(@Inject(AdminCommissionService) private readonly commission: AdminCommissionService) {}

  @Get()
  @Authorize("finance:configure")
  @ZodResponse({ status: 200, description: "Mức mặc định + mức riêng.", type: CommissionOverviewDto })
  overview(@Authz() authz: Authorization): Promise<CommissionOverview> {
    return this.commission.overview(authz);
  }

  @Post()
  @HttpCode(201)
  @Authorize("finance:configure", { requireReauth: true })
  @ApiBody({ type: CommissionRuleCreateDto })
  @ZodResponse({ status: 201, description: "Mức riêng vừa thêm.", type: CommissionRuleDto })
  @ApiResponse({ status: 404, description: "`COMMISSION_RULE_NOT_FOUND` — nhà xe không tồn tại.", content: problemContent })
  @ApiResponse({ status: 409, description: "`COMMISSION_RULE_OVERLAP`.", content: problemContent })
  @ApiResponse({ status: 422, description: "`COMMISSION_PERIOD_INVALID`.", content: problemContent })
  @ApiResponse({ status: 503, description: "Chưa ghi được audit — không đổi gì.", content: problemContent })
  create(
    @Authz() authz: Authorization,
    @CurrentUser() actor: VerifiedAccessToken,
    @Body() input: CommissionRuleCreateDto,
  ): Promise<CommissionRuleResponse> {
    return this.commission.create(authz, actor, input);
  }

  @Put(":id")
  @Authorize("finance:configure", { requireReauth: true })
  @ApiParam(ID_PARAM)
  @ApiBody({ type: CommissionRuleUpdateDto })
  @ZodResponse({ status: 200, description: "Mức riêng sau khi sửa.", type: CommissionRuleDto })
  @ApiResponse({ status: 404, description: "`COMMISSION_RULE_NOT_FOUND`.", content: problemContent })
  @ApiResponse({ status: 409, description: "`COMMISSION_RULE_OVERLAP`.", content: problemContent })
  @ApiResponse({ status: 422, description: "`COMMISSION_RULE_LOCKED` / `COMMISSION_PERIOD_INVALID`.", content: problemContent })
  @ApiResponse({ status: 503, description: "Chưa ghi được audit — không đổi gì.", content: problemContent })
  update(
    @Authz() authz: Authorization,
    @CurrentUser() actor: VerifiedAccessToken,
    @Param() params: CommissionRuleIdParamDto,
    @Body() input: CommissionRuleUpdateDto,
  ): Promise<CommissionRuleResponse> {
    return this.commission.update(authz, actor, params.id, input);
  }

  /** Ngừng mức riêng: chưa bắt đầu → hủy; đang áp dụng → kết thúc ngay (audited, kèm lý do). */
  @Post(":id/cancel")
  @HttpCode(200)
  @Authorize("finance:configure", { requireReauth: true })
  @ApiParam(ID_PARAM)
  @ApiBody({ type: CommissionRuleCancelDto })
  @ZodResponse({ status: 200, description: "Mức riêng sau khi ngừng.", type: CommissionRuleDto })
  @ApiResponse({ status: 404, description: "`COMMISSION_RULE_NOT_FOUND`.", content: problemContent })
  @ApiResponse({ status: 422, description: "`COMMISSION_RULE_LOCKED` — đã kết thúc / đã hủy.", content: problemContent })
  @ApiResponse({ status: 503, description: "Chưa ghi được audit — không đổi gì.", content: problemContent })
  cancel(
    @Authz() authz: Authorization,
    @CurrentUser() actor: VerifiedAccessToken,
    @Param() params: CommissionRuleIdParamDto,
    @Body() input: CommissionRuleCancelDto,
  ): Promise<CommissionRuleResponse> {
    return this.commission.cancel(authz, actor, params.id, input.reason);
  }
}
