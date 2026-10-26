import { applyDecorators, Body, Controller, Get, HttpCode, Inject, Param, ParseUUIDPipe, Post, Put, Query } from "@nestjs/common";
import { ApiBody, ApiParam, ApiQuery, ApiResponse, ApiTags, getSchemaPath } from "@nestjs/swagger";
import { createZodDto, ZodResponse } from "nestjs-zod";
import { z } from "zod";
import { PromotionScope } from "../database/prisma.types";
import { CurrentUser } from "../iam/auth/current-user.decorator";
import type { VerifiedAccessToken } from "../iam/auth/token.service";
import { Authorize, Authz } from "../iam/role/authorize.decorator";
import type { Authorization } from "../iam/role/authorization";
import { GuestOrPassenger, OptionalPassenger } from "../iam/role/guest-or-passenger";
import { ProblemDetailsDto } from "../openapi/openapi.dto";
import {
  PermissionDto,
  PermissionInputDto,
  PermissionListQueryDto,
  PermissionPageDto,
  PROMOTION_DISPLAY,
  PromotionCheckDto,
  PromotionCheckInputDto,
  PromotionDto,
  PromotionInputDto,
  PromotionListQueryDto,
  PromotionPageDto,
  PromotionStatusInputDto,
  PromotionRouteOptionsDto,
  type Permission,
  type PermissionPage,
  type Promotion,
  type PromotionCheck,
  type PromotionPage,
} from "./dto/promotion.dto";
import { PromotionService } from "./promotion.service";

const problemContent = {
  "application/problem+json": { schema: { $ref: getSchemaPath(ProblemDetailsDto) } },
};
const PROMOTION_PARAM = { name: "promotionId", type: String, format: "uuid" } as const;

class ScopeQueryDto extends createZodDto(z.object({ scope: z.enum(PromotionScope).default(PromotionScope.PLATFORM) })) {}
class ParticipationInputDto extends createZodDto(z.object({ joined: z.boolean() })) {}

function listQueries(): MethodDecorator {
  return applyDecorators(
    ApiQuery({ name: "scope", required: false, enum: PromotionScope }),
    ApiQuery({ name: "display", required: false, enum: PROMOTION_DISPLAY }),
    ApiQuery({ name: "q", required: false, type: String }),
    ApiQuery({ name: "routeId", required: false, type: String, format: "uuid" }),
    ApiQuery({ name: "cursor", required: false, type: String, format: "uuid" }),
    ApiQuery({ name: "limit", required: false, type: Number, minimum: 1, maximum: 100 }),
  );
}

// FR-PROM-01..03, FR-ADM-12 — PlatformAdmin (`promotion:configure`, chỉ role Platform).
@ApiTags("admin-promotions")
@Controller("admin")
/** Khuyến mãi nền tảng, khuyến mãi của các nhà xe, quyền tự tạo khuyến mãi của nhà xe (Figma ADM-11a/b; TASK-PROM-001). */
export class AdminPromotionController {
  constructor(@Inject(PromotionService) private readonly promotions: PromotionService) {}

  /** Các tuyến đang hoạt động để chọn phạm vi khuyến mãi nền tảng. */
  @Get("promotion-routes")
  @Authorize("promotion:configure")
  @ZodResponse({ status: 200, type: PromotionRouteOptionsDto })
  routeOptions(@Authz() authz: Authorization) { return this.promotions.routeOptions(authz); }

  @Get("promotions")
  @Authorize("promotion:configure")
  @listQueries()
  @ApiQuery({ name: "operatorId", required: false, type: String, format: "uuid" })
  @ZodResponse({ status: 200, description: "Khuyến mãi theo phạm vi, mới tạo trước, kèm số liệu.", type: PromotionPageDto })
  list(@Authz() authz: Authorization, @Query() scope: ScopeQueryDto, @Query() query: PromotionListQueryDto): Promise<PromotionPage> {
    return this.promotions.adminList(authz, scope.scope, query);
  }

  @Get("promotions/:promotionId")
  @Authorize("promotion:configure")
  @ApiParam(PROMOTION_PARAM)
  @ZodResponse({ status: 200, description: "Khuyến mãi.", type: PromotionDto })
  @ApiResponse({ status: 404, description: "`PROMOTION_NOT_FOUND`.", content: problemContent })
  get(@Authz() authz: Authorization, @Param("promotionId", new ParseUUIDPipe()) promotionId: string): Promise<Promotion> {
    return this.promotions.get(authz, promotionId);
  }

  @Post("promotions")
  @HttpCode(201)
  @Authorize("promotion:configure")
  @ApiBody({ type: PromotionInputDto })
  @ZodResponse({ status: 201, description: "Đã tạo khuyến mãi nền tảng (nháp).", type: PromotionDto })
  @ApiResponse({ status: 409, description: "`PROMOTION_CODE_TAKEN`.", content: problemContent })
  create(@CurrentUser() actor: VerifiedAccessToken, @Authz() authz: Authorization, @Body() input: PromotionInputDto): Promise<Promotion> {
    return this.promotions.create(authz, actor, input);
  }

  @Put("promotions/:promotionId")
  @Authorize("promotion:configure")
  @ApiParam(PROMOTION_PARAM)
  @ApiBody({ type: PromotionInputDto })
  @ZodResponse({ status: 200, description: "Đã sửa.", type: PromotionDto })
  @ApiResponse({ status: 409, description: "`PROMOTION_STATE_INVALID` (đã có đơn dùng mã / đã kết thúc) / `PROMOTION_CODE_TAKEN`.", content: problemContent })
  update(@CurrentUser() actor: VerifiedAccessToken, @Authz() authz: Authorization, @Param("promotionId", new ParseUUIDPipe()) promotionId: string, @Body() input: PromotionInputDto): Promise<Promotion> {
    return this.promotions.update(authz, actor, promotionId, input);
  }

  @Post("promotions/:promotionId/status")
  @HttpCode(200)
  @Authorize("promotion:configure")
  @ApiParam(PROMOTION_PARAM)
  @ApiBody({ type: PromotionStatusInputDto })
  @ZodResponse({ status: 200, description: "Đã đổi trạng thái (gồm tạm dừng / kết thúc khuyến mãi của nhà xe).", type: PromotionDto })
  @ApiResponse({ status: 409, description: "`PROMOTION_STATE_INVALID`.", content: problemContent })
  setStatus(@CurrentUser() actor: VerifiedAccessToken, @Authz() authz: Authorization, @Param("promotionId", new ParseUUIDPipe()) promotionId: string, @Body() input: PromotionStatusInputDto): Promise<Promotion> {
    return this.promotions.setStatus(authz, actor, promotionId, input);
  }

  @Get("promotion-permissions")
  @Authorize("promotion:configure")
  @ApiQuery({ name: "q", required: false, type: String })
  @ApiQuery({ name: "enabled", required: false, enum: ["yes", "no"] })
  @ApiQuery({ name: "cursor", required: false, type: String, format: "uuid" })
  @ApiQuery({ name: "limit", required: false, type: Number, minimum: 1, maximum: 100 })
  @ZodResponse({ status: 200, description: "Nhà xe + quyền tự tạo khuyến mãi.", type: PermissionPageDto })
  permissions(@Authz() authz: Authorization, @Query() query: PermissionListQueryDto): Promise<PermissionPage> {
    return this.promotions.listPermissions(authz, query);
  }

  @Put("promotion-permissions/:operatorId")
  @Authorize("promotion:configure")
  @ApiParam({ name: "operatorId", type: String, format: "uuid" })
  @ApiBody({ type: PermissionInputDto })
  @ZodResponse({ status: 200, description: "Đã lưu quyền + giới hạn.", type: PermissionDto })
  @ApiResponse({ status: 422, description: "`PROMOTION_GUARDRAIL` — tuyến không thuộc nhà xe.", content: problemContent })
  setPermission(@CurrentUser() actor: VerifiedAccessToken, @Authz() authz: Authorization, @Param("operatorId", new ParseUUIDPipe()) operatorId: string, @Body() input: PermissionInputDto): Promise<Permission> {
    return this.promotions.upsertPermission(authz, actor, operatorId, input);
  }
}

// FR-PROM-04 — chủ nhà xe (`promotion:manage` phạm vi tenant): khuyến mãi của nhà xe trong giới hạn, tham gia khuyến mãi nền tảng.
@ApiTags("operator-promotions")
@Controller("operator")
/** Khuyến mãi của nhà xe (Figma "Nhà xe · Khuyến mãi" 01–03). */
export class OperatorPromotionController {
  constructor(@Inject(PromotionService) private readonly promotions: PromotionService) {}

  @Get("promotions")
  @Authorize("promotion:manage")
  @listQueries()
  @ZodResponse({ status: 200, description: "`scope=OPERATOR`: khuyến mãi của nhà xe; `PLATFORM`: khuyến mãi nền tảng để tham gia.", type: PromotionPageDto })
  list(@Authz() authz: Authorization, @Query() scope: ScopeQueryDto, @Query() query: PromotionListQueryDto): Promise<PromotionPage> {
    return this.promotions.operatorList(authz, scope.scope, query);
  }

  @Get("promotion-permission")
  @Authorize("promotion:manage")
  @ZodResponse({ status: 200, description: "Quyền + giới hạn Vé Xe Nhanh cấp cho nhà xe.", type: PermissionDto })
  permission(@Authz() authz: Authorization): Promise<Permission> {
    return this.promotions.operatorPermission(authz);
  }

  @Get("promotions/:promotionId")
  @Authorize("promotion:manage")
  @ApiParam(PROMOTION_PARAM)
  @ZodResponse({ status: 200, description: "Khuyến mãi.", type: PromotionDto })
  @ApiResponse({ status: 404, description: "`PROMOTION_NOT_FOUND`.", content: problemContent })
  get(@Authz() authz: Authorization, @Param("promotionId", new ParseUUIDPipe()) promotionId: string): Promise<Promotion> {
    return this.promotions.get(authz, promotionId);
  }

  @Post("promotions")
  @HttpCode(201)
  @Authorize("promotion:manage")
  @ApiBody({ type: PromotionInputDto })
  @ZodResponse({ status: 201, description: "Đã tạo khuyến mãi (nháp).", type: PromotionDto })
  @ApiResponse({ status: 409, description: "`PROMOTION_CODE_TAKEN`.", content: problemContent })
  @ApiResponse({ status: 422, description: "`PROMOTION_GUARDRAIL` — chưa được cấp quyền / vượt giới hạn.", content: problemContent })
  create(@CurrentUser() actor: VerifiedAccessToken, @Authz() authz: Authorization, @Body() input: PromotionInputDto): Promise<Promotion> {
    return this.promotions.create(authz, actor, input);
  }

  @Put("promotions/:promotionId")
  @Authorize("promotion:manage")
  @ApiParam(PROMOTION_PARAM)
  @ApiBody({ type: PromotionInputDto })
  @ZodResponse({ status: 200, description: "Đã sửa.", type: PromotionDto })
  @ApiResponse({ status: 409, description: "`PROMOTION_STATE_INVALID` / `PROMOTION_CODE_TAKEN`.", content: problemContent })
  @ApiResponse({ status: 422, description: "`PROMOTION_GUARDRAIL`.", content: problemContent })
  update(@CurrentUser() actor: VerifiedAccessToken, @Authz() authz: Authorization, @Param("promotionId", new ParseUUIDPipe()) promotionId: string, @Body() input: PromotionInputDto): Promise<Promotion> {
    return this.promotions.update(authz, actor, promotionId, input);
  }

  @Post("promotions/:promotionId/status")
  @HttpCode(200)
  @Authorize("promotion:manage")
  @ApiParam(PROMOTION_PARAM)
  @ApiBody({ type: PromotionStatusInputDto })
  @ZodResponse({ status: 200, description: "Đã đổi trạng thái.", type: PromotionDto })
  @ApiResponse({ status: 409, description: "`PROMOTION_STATE_INVALID`.", content: problemContent })
  @ApiResponse({ status: 422, description: "`PROMOTION_GUARDRAIL` — kích hoạt khi vượt giới hạn hiện tại.", content: problemContent })
  setStatus(@CurrentUser() actor: VerifiedAccessToken, @Authz() authz: Authorization, @Param("promotionId", new ParseUUIDPipe()) promotionId: string, @Body() input: PromotionStatusInputDto): Promise<Promotion> {
    return this.promotions.setStatus(authz, actor, promotionId, input);
  }

  @Put("promotions/:promotionId/participation")
  @Authorize("promotion:manage")
  @ApiParam(PROMOTION_PARAM)
  @ApiBody({ type: ParticipationInputDto })
  @ZodResponse({ status: 200, description: "Đã tham gia / rời khuyến mãi nền tảng (nhà xe chịu phần giảm).", type: PromotionDto })
  @ApiResponse({ status: 404, description: "`PROMOTION_NOT_FOUND`.", content: problemContent })
  @ApiResponse({ status: 409, description: "`PROMOTION_STATE_INVALID` — đã kết thúc.", content: problemContent })
  participate(@CurrentUser() actor: VerifiedAccessToken, @Authz() authz: Authorization, @Param("promotionId", new ParseUUIDPipe()) promotionId: string, @Body() input: ParticipationInputDto): Promise<Promotion> {
    return this.promotions.setParticipation(authz, actor, promotionId, input.joined);
  }
}

// FR-MKT-10 — khách vãng lai / hành khách báo trước số tiền giảm khi chọn mã.
@ApiTags("promotions")
@Controller("promotions")
/** Kiểm mã khuyến mãi cho một chuyến (không giữ lượt dùng). */
export class PublicPromotionController {
  constructor(@Inject(PromotionService) private readonly promotions: PromotionService) {}

  @Post("check")
  @HttpCode(200)
  @GuestOrPassenger("booking:create")
  @ApiBody({ type: PromotionCheckInputDto })
  @ZodResponse({ status: 200, description: "Số tiền giảm + tổng sau giảm.", type: PromotionCheckDto })
  @ApiResponse({ status: 409, description: "`PROMOTION_EXHAUSTED` / `VOUCHER_NOT_AVAILABLE` (voucher đang dùng cho đơn khác).", content: problemContent })
  @ApiResponse({
    status: 422,
    description: "`PROMOTION_INVALID` / `VOUCHER_NOT_AVAILABLE` (chưa đăng nhập) / `VOUCHER_EXPIRED` / `VOUCHER_NOT_APPLICABLE`.",
    content: problemContent,
  })
  check(@OptionalPassenger() user: VerifiedAccessToken | null, @Body() input: PromotionCheckInputDto): Promise<PromotionCheck> {
    return this.promotions.check(input, user?.sub ?? null);
  }
}
