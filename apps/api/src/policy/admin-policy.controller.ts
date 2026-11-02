import { Body, Controller, Get, HttpCode, Inject, Param, Post, Put, Query } from "@nestjs/common";
import { ApiBody, ApiParam, ApiResponse, ApiTags, getSchemaPath } from "@nestjs/swagger";
import { ZodResponse } from "nestjs-zod";
import { PolicyType } from "../database/prisma.types";
import { CurrentUser } from "../iam/auth/current-user.decorator";
import type { VerifiedAccessToken } from "../iam/auth/token.service";
import type { Authorization } from "../iam/role/authorization";
import { Authorize, Authz } from "../iam/role/authorize.decorator";
import { ProblemDetailsDto } from "../openapi/openapi.dto";
import { AdminPolicyService } from "./admin-policy.service";
import {
  FareBandCreateDto,
  FareBandDto,
  type FareBandList,
  FareBandListDto,
  type FareBandResponse,
  PolicyCancelDto,
  PolicyDraftCreateDto,
  PolicyDraftUpdateDto,
  PolicyIdParamDto,
  PolicyOverviewDto,
  type PolicyOverview,
  PolicyOverviewQueryDto,
  PolicyPublishDto,
  PolicyTypeParamDto,
  PolicyVersionDto,
  type PolicyVersionResponse,
} from "./dto/policy.dto";

const problemContent = {
  "application/problem+json": { schema: { $ref: getSchemaPath(ProblemDetailsDto) } },
};
const TYPE_PARAM = { name: "type", enum: Object.values(PolicyType) } as const;
const ID_PARAM = { name: "id", type: String, format: "uuid" } as const;

// API §7.5 — chính sách nền tảng có phiên bản (FR-ADM-06/08, UC-25). Quyền `finance:configure` (PLATFORM_ADMIN); kích hoạt /
// hủy cần xác nhận lại danh tính (Figma ADM-06b có ô TOTP).
@ApiTags("admin-policies")
@Controller("admin")
/** Chính sách hủy / hoàn tiền, giữ chỗ, chi trả và khung giá vé. */
export class AdminPolicyController {
  constructor(@Inject(AdminPolicyService) private readonly policies: AdminPolicyService) {}

  /** Lịch sử phiên bản của một phạm vi (mới nhất trước) + nhà xe có chính sách riêng. */
  @Get("policies/:type")
  @Authorize("finance:configure")
  @ApiParam(TYPE_PARAM)
  @ZodResponse({ status: 200, description: "Các phiên bản.", type: PolicyOverviewDto })
  @ApiResponse({ status: 400, description: "`POLICY_RULES_INVALID` — phạm vi nhà xe cho loại không hỗ trợ.", content: problemContent })
  overview(
    @Authz() authz: Authorization,
    @Param() params: PolicyTypeParamDto,
    @Query() query: PolicyOverviewQueryDto,
  ): Promise<PolicyOverview> {
    return this.policies.overview(authz, params.type, query.operatorId);
  }

  /** Tạo nháp phiên bản mới (audited). */
  @Post("policies/:type/versions")
  @HttpCode(201)
  @Authorize("finance:configure")
  @ApiParam(TYPE_PARAM)
  @ApiBody({ type: PolicyDraftCreateDto })
  @ZodResponse({ status: 201, description: "Nháp vừa tạo.", type: PolicyVersionDto })
  @ApiResponse({ status: 400, description: "`POLICY_RULES_INVALID`.", content: problemContent })
  @ApiResponse({ status: 409, description: "`POLICY_VERSION_CONFLICT`.", content: problemContent })
  @ApiResponse({ status: 503, description: "Chưa ghi được audit — không đổi gì.", content: problemContent })
  createDraft(
    @Authz() authz: Authorization,
    @CurrentUser() actor: VerifiedAccessToken,
    @Param() params: PolicyTypeParamDto,
    @Body() input: PolicyDraftCreateDto,
  ): Promise<PolicyVersionResponse> {
    return this.policies.createDraft(authz, actor, params.type, input);
  }

  @Get("policy-versions/:id")
  @Authorize("finance:configure")
  @ApiParam(ID_PARAM)
  @ZodResponse({ status: 200, description: "Một phiên bản.", type: PolicyVersionDto })
  @ApiResponse({ status: 404, description: "`POLICY_VERSION_NOT_FOUND`.", content: problemContent })
  get(@Authz() authz: Authorization, @Param() params: PolicyIdParamDto): Promise<PolicyVersionResponse> {
    return this.policies.get(authz, params.id);
  }

  /** Sửa nháp (bản đã kích hoạt / đã hủy → 409). */
  @Put("policy-versions/:id")
  @Authorize("finance:configure")
  @ApiParam(ID_PARAM)
  @ApiBody({ type: PolicyDraftUpdateDto })
  @ZodResponse({ status: 200, description: "Nháp sau khi sửa.", type: PolicyVersionDto })
  @ApiResponse({ status: 400, description: "`POLICY_RULES_INVALID`.", content: problemContent })
  @ApiResponse({ status: 409, description: "`POLICY_VERSION_LOCKED`.", content: problemContent })
  @ApiResponse({ status: 503, description: "Chưa ghi được audit — không đổi gì.", content: problemContent })
  updateDraft(
    @Authz() authz: Authorization,
    @CurrentUser() actor: VerifiedAccessToken,
    @Param() params: PolicyIdParamDto,
    @Body() input: PolicyDraftUpdateDto,
  ): Promise<PolicyVersionResponse> {
    return this.policies.updateDraft(authz, actor, params.id, input);
  }

  /** Kích hoạt nháp: hiệu lực ở tương lai, phạm vi chưa có bản chờ hiệu lực (audited, kèm lý do). */
  @Post("policy-versions/:id/publish")
  @HttpCode(200)
  @Authorize("finance:configure", { requireReauth: true })
  @ApiParam(ID_PARAM)
  @ApiBody({ type: PolicyPublishDto })
  @ZodResponse({ status: 200, description: "Phiên bản đã kích hoạt.", type: PolicyVersionDto })
  @ApiResponse({ status: 409, description: "`POLICY_VERSION_LOCKED` / `POLICY_SCHEDULE_CONFLICT`.", content: problemContent })
  @ApiResponse({ status: 422, description: "`POLICY_EFFECTIVE_INVALID`.", content: problemContent })
  @ApiResponse({ status: 503, description: "Chưa ghi được audit — không đổi gì.", content: problemContent })
  publish(
    @Authz() authz: Authorization,
    @CurrentUser() actor: VerifiedAccessToken,
    @Param() params: PolicyIdParamDto,
    @Body() input: PolicyPublishDto,
  ): Promise<PolicyVersionResponse> {
    return this.policies.publish(authz, actor, params.id, input.changeReason);
  }

  /** Hủy nháp / hủy bản đã lên lịch chưa tới hiệu lực (audited, kèm lý do). */
  @Post("policy-versions/:id/cancel")
  @HttpCode(200)
  @Authorize("finance:configure", { requireReauth: true })
  @ApiParam(ID_PARAM)
  @ApiBody({ type: PolicyCancelDto })
  @ZodResponse({ status: 200, description: "Phiên bản đã hủy.", type: PolicyVersionDto })
  @ApiResponse({ status: 409, description: "`POLICY_VERSION_LOCKED` — đã có hiệu lực.", content: problemContent })
  @ApiResponse({ status: 503, description: "Chưa ghi được audit — không đổi gì.", content: problemContent })
  cancel(
    @Authz() authz: Authorization,
    @CurrentUser() actor: VerifiedAccessToken,
    @Param() params: PolicyIdParamDto,
    @Body() input: PolicyCancelDto,
  ): Promise<PolicyVersionResponse> {
    return this.policies.cancel(authz, actor, params.id, input.reason);
  }

  /** Khung giá trần / sàn theo dịp (FR-ADM-09, OQ-17), mới nhất trước. */
  @Get("fare-bands")
  @Authorize("finance:configure")
  @ZodResponse({ status: 200, description: "Các khung giá.", type: FareBandListDto })
  listFareBands(@Authz() authz: Authorization): Promise<FareBandList> {
    return this.policies.listFareBands(authz);
  }

  /** Thêm khung giá — nhà xe được cảnh báo khi giá nằm ngoài khung (không chặn). */
  @Post("fare-bands")
  @HttpCode(201)
  @Authorize("finance:configure", { requireReauth: true })
  @ApiBody({ type: FareBandCreateDto })
  @ZodResponse({ status: 201, description: "Khung giá vừa tạo.", type: FareBandDto })
  @ApiResponse({ status: 422, description: "`POLICY_EFFECTIVE_INVALID` — đã kết thúc.", content: problemContent })
  @ApiResponse({ status: 503, description: "Chưa ghi được audit — không đổi gì.", content: problemContent })
  createFareBand(
    @Authz() authz: Authorization,
    @CurrentUser() actor: VerifiedAccessToken,
    @Body() input: FareBandCreateDto,
  ): Promise<FareBandResponse> {
    return this.policies.createFareBand(authz, actor, input);
  }

  @Post("fare-bands/:id/cancel")
  @HttpCode(200)
  @Authorize("finance:configure", { requireReauth: true })
  @ApiParam(ID_PARAM)
  @ApiBody({ type: PolicyCancelDto })
  @ZodResponse({ status: 200, description: "Khung giá đã hủy.", type: FareBandDto })
  @ApiResponse({ status: 404, description: "`FARE_BAND_NOT_FOUND`.", content: problemContent })
  @ApiResponse({ status: 409, description: "`FARE_BAND_CLOSED`.", content: problemContent })
  @ApiResponse({ status: 503, description: "Chưa ghi được audit — không đổi gì.", content: problemContent })
  cancelFareBand(
    @Authz() authz: Authorization,
    @CurrentUser() actor: VerifiedAccessToken,
    @Param() params: PolicyIdParamDto,
    @Body() input: PolicyCancelDto,
  ): Promise<FareBandResponse> {
    return this.policies.cancelFareBand(authz, actor, params.id, input.reason);
  }
}
