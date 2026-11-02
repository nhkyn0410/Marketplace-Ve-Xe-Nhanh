import { Body, Controller, Get, HttpCode, Inject, Param, Post, Put, Query } from "@nestjs/common";
import { ApiBody, ApiParam, ApiResponse, ApiTags, getSchemaPath } from "@nestjs/swagger";
import { ZodResponse } from "nestjs-zod";
import { CurrentUser } from "../iam/auth/current-user.decorator";
import type { VerifiedAccessToken } from "../iam/auth/token.service";
import type { Authorization } from "../iam/role/authorization";
import { Authorize, Authz } from "../iam/role/authorize.decorator";
import { ProblemDetailsDto } from "../openapi/openapi.dto";
import {
  AdminOperatorStopPointDto,
  type AdminOperatorPoint,
  AdminOperatorStopPointListDto,
  type AdminOperatorPointList,
  AdminOperatorStopPointListQueryDto,
  AdminSharedStopPointDto,
  type SharedStopPoint,
  AdminSharedStopPointInputDto,
  AdminSharedStopPointListDto,
  type SharedStopPointList,
  AdminSharedStopPointListQueryDto,
  AdminStopPointIdParamDto,
  AdminStopPointProposalApprovalDto,
  AdminStopPointProposalDto,
  type AdminProposal,
  AdminStopPointProposalListDto,
  type AdminProposalList,
  AdminStopPointProposalListQueryDto,
  StopPointReasonInputDto,
} from "./dto/admin-stop-point.dto";
import { AdminStopPointService } from "./admin-stop-point.service";

const problemContent = {
  "application/problem+json": { schema: { $ref: getSchemaPath(ProblemDetailsDto) } },
};
const ID_PARAM = { name: "id", type: String, format: "uuid" } as const;
const UNAVAILABLE = { status: 503, description: "Chưa ghi được audit — không lưu gì.", content: problemContent };
const LOCATION_INVALID = {
  status: 422,
  description: "`CATALOG_ITEM_UNAVAILABLE` — tỉnh / phường không còn hiệu lực hoặc lệch nhau.",
  content: problemContent,
};

// API §7.5 — Admin quản lý điểm dừng (TASK-ADM-004, UC-24, BR-38, BR-81). Quyền `catalog:manage` (PLATFORM_ADMIN).

@ApiTags("admin-stop-points")
@Controller("admin/stop-points")
/** Điểm dừng dùng chung: bến xe, điểm dừng đón trả, trạm dừng nghỉ. */
export class AdminSharedStopPointController {
  constructor(@Inject(AdminStopPointService) private readonly stopPoints: AdminStopPointService) {}

  /** Danh sách mọi trạng thái, lọc loại / tỉnh / trạng thái, tìm không dấu, kèm số tuyến đang dùng. */
  @Get()
  @Authorize("catalog:manage")
  @ZodResponse({ status: 200, description: "Một trang điểm dùng chung.", type: AdminSharedStopPointListDto })
  list(@Authz() authz: Authorization, @Query() query: AdminSharedStopPointListQueryDto): Promise<SharedStopPointList> {
    return this.stopPoints.listShared(authz, query);
  }

  @Get(":id")
  @Authorize("catalog:manage")
  @ApiParam(ID_PARAM)
  @ZodResponse({ status: 200, description: "Một điểm dùng chung.", type: AdminSharedStopPointDto })
  @ApiResponse({ status: 404, description: "`STOP_POINT_NOT_FOUND`.", content: problemContent })
  get(@Authz() authz: Authorization, @Param() params: AdminStopPointIdParamDto): Promise<SharedStopPoint> {
    return this.stopPoints.getShared(authz, params.id);
  }

  /** Thêm điểm dùng chung; bến xe / điểm dừng đón trả bắt buộc căn cứ công bố (audited). */
  @Post()
  @Authorize("catalog:manage")
  @ApiBody({ type: AdminSharedStopPointInputDto })
  @ZodResponse({ status: 201, description: "Điểm vừa tạo.", type: AdminSharedStopPointDto })
  @ApiResponse({ status: 400, description: "Dữ liệu không hợp lệ (thiếu căn cứ công bố…).", content: problemContent })
  @ApiResponse(LOCATION_INVALID)
  @ApiResponse(UNAVAILABLE)
  create(
    @Authz() authz: Authorization,
    @CurrentUser() actor: VerifiedAccessToken,
    @Body() input: AdminSharedStopPointInputDto,
  ): Promise<SharedStopPoint> {
    return this.stopPoints.createShared(authz, actor, input);
  }

  /** Thay toàn bộ một điểm dùng chung, kể cả ngừng dùng (không xóa; audited). */
  @Put(":id")
  @Authorize("catalog:manage")
  @ApiParam(ID_PARAM)
  @ApiBody({ type: AdminSharedStopPointInputDto })
  @ZodResponse({ status: 200, description: "Điểm sau khi sửa.", type: AdminSharedStopPointDto })
  @ApiResponse({ status: 400, description: "Dữ liệu không hợp lệ.", content: problemContent })
  @ApiResponse({ status: 404, description: "`STOP_POINT_NOT_FOUND`.", content: problemContent })
  @ApiResponse(LOCATION_INVALID)
  @ApiResponse(UNAVAILABLE)
  update(
    @Authz() authz: Authorization,
    @CurrentUser() actor: VerifiedAccessToken,
    @Param() params: AdminStopPointIdParamDto,
    @Body() input: AdminSharedStopPointInputDto,
  ): Promise<SharedStopPoint> {
    return this.stopPoints.updateShared(authz, actor, params.id, input);
  }
}

@ApiTags("admin-stop-points")
@Controller("admin/stop-point-proposals")
/** Đề xuất đưa bến xe / điểm dừng đón trả vào danh mục dùng chung của các nhà xe. */
export class AdminStopPointProposalController {
  constructor(@Inject(AdminStopPointService) private readonly stopPoints: AdminStopPointService) {}

  /** Danh sách, lọc trạng thái / loại / nhà xe, kèm điểm dùng chung cùng loại trong 200 m. */
  @Get()
  @Authorize("catalog:manage")
  @ZodResponse({ status: 200, description: "Một trang đề xuất.", type: AdminStopPointProposalListDto })
  list(@Authz() authz: Authorization, @Query() query: AdminStopPointProposalListQueryDto): Promise<AdminProposalList> {
    return this.stopPoints.listProposals(authz, query);
  }

  @Get(":id")
  @Authorize("catalog:manage")
  @ApiParam(ID_PARAM)
  @ZodResponse({ status: 200, description: "Một đề xuất.", type: AdminStopPointProposalDto })
  @ApiResponse({ status: 404, description: "`STOP_POINT_PROPOSAL_NOT_FOUND`.", content: problemContent })
  get(@Authz() authz: Authorization, @Param() params: AdminStopPointIdParamDto): Promise<AdminProposal> {
    return this.stopPoints.getProposal(authz, params.id);
  }

  /** Duyệt theo thông tin Admin đã chỉnh → tạo điểm dùng chung (audited). */
  @Post(":id/approve")
  @HttpCode(200)
  @Authorize("catalog:manage")
  @ApiParam(ID_PARAM)
  @ApiBody({ type: AdminStopPointProposalApprovalDto })
  @ZodResponse({ status: 200, description: "Đề xuất đã duyệt.", type: AdminStopPointProposalDto })
  @ApiResponse({ status: 404, description: "`STOP_POINT_PROPOSAL_NOT_FOUND`.", content: problemContent })
  @ApiResponse({ status: 409, description: "`STOP_POINT_PROPOSAL_STATE_INVALID` — không còn Chờ duyệt.", content: problemContent })
  @ApiResponse(LOCATION_INVALID)
  @ApiResponse(UNAVAILABLE)
  approve(
    @Authz() authz: Authorization,
    @CurrentUser() actor: VerifiedAccessToken,
    @Param() params: AdminStopPointIdParamDto,
    @Body() input: AdminStopPointProposalApprovalDto,
  ): Promise<AdminProposal> {
    return this.stopPoints.approveProposal(authz, actor, params.id, input);
  }

  /** Từ chối, lý do bắt buộc (audited). */
  @Post(":id/reject")
  @HttpCode(200)
  @Authorize("catalog:manage")
  @ApiParam(ID_PARAM)
  @ApiBody({ type: StopPointReasonInputDto })
  @ZodResponse({ status: 200, description: "Đề xuất đã từ chối.", type: AdminStopPointProposalDto })
  @ApiResponse({ status: 404, description: "`STOP_POINT_PROPOSAL_NOT_FOUND`.", content: problemContent })
  @ApiResponse({ status: 409, description: "`STOP_POINT_PROPOSAL_STATE_INVALID`.", content: problemContent })
  @ApiResponse(UNAVAILABLE)
  reject(
    @Authz() authz: Authorization,
    @CurrentUser() actor: VerifiedAccessToken,
    @Param() params: AdminStopPointIdParamDto,
    @Body() input: StopPointReasonInputDto,
  ): Promise<AdminProposal> {
    return this.stopPoints.rejectProposal(authz, actor, params.id, input.reason);
  }
}

@ApiTags("admin-stop-points")
@Controller("admin/operator-stop-points")
/** Điểm dừng riêng của mọi nhà xe: xem, khóa / mở khóa (BR-81). */
export class AdminOperatorStopPointController {
  constructor(@Inject(AdminStopPointService) private readonly stopPoints: AdminStopPointService) {}

  @Get()
  @Authorize("catalog:manage")
  @ZodResponse({ status: 200, description: "Một trang điểm riêng.", type: AdminOperatorStopPointListDto })
  list(
    @Authz() authz: Authorization,
    @Query() query: AdminOperatorStopPointListQueryDto,
  ): Promise<AdminOperatorPointList> {
    return this.stopPoints.listOperatorPoints(authz, query);
  }

  /** Khóa, lý do bắt buộc → `SUSPENDED` (audited). */
  @Post(":id/suspend")
  @HttpCode(200)
  @Authorize("catalog:manage")
  @ApiParam(ID_PARAM)
  @ApiBody({ type: StopPointReasonInputDto })
  @ZodResponse({ status: 200, description: "Điểm đã khóa.", type: AdminOperatorStopPointDto })
  @ApiResponse({ status: 404, description: "`STOP_POINT_NOT_FOUND`.", content: problemContent })
  @ApiResponse({ status: 409, description: "`STOP_POINT_STATE_INVALID` — đang bị khóa rồi.", content: problemContent })
  @ApiResponse(UNAVAILABLE)
  suspend(
    @Authz() authz: Authorization,
    @CurrentUser() actor: VerifiedAccessToken,
    @Param() params: AdminStopPointIdParamDto,
    @Body() input: StopPointReasonInputDto,
  ): Promise<AdminOperatorPoint> {
    return this.stopPoints.suspend(authz, actor, params.id, input.reason);
  }

  /** Mở khóa → `ACTIVE` (audited). */
  @Post(":id/unsuspend")
  @HttpCode(200)
  @Authorize("catalog:manage")
  @ApiParam(ID_PARAM)
  @ZodResponse({ status: 200, description: "Điểm đã mở khóa.", type: AdminOperatorStopPointDto })
  @ApiResponse({ status: 404, description: "`STOP_POINT_NOT_FOUND`.", content: problemContent })
  @ApiResponse({ status: 409, description: "`STOP_POINT_STATE_INVALID` — không bị khóa.", content: problemContent })
  @ApiResponse(UNAVAILABLE)
  unsuspend(
    @Authz() authz: Authorization,
    @CurrentUser() actor: VerifiedAccessToken,
    @Param() params: AdminStopPointIdParamDto,
  ): Promise<AdminOperatorPoint> {
    return this.stopPoints.unsuspend(authz, actor, params.id);
  }
}
