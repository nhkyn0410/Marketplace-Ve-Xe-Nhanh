import { Body, Controller, Get, HttpCode, Inject, Param, Post, Put, Query } from "@nestjs/common";
import { ApiBody, ApiParam, ApiResponse, ApiTags, getSchemaPath } from "@nestjs/swagger";
import { ZodResponse } from "nestjs-zod";
import { CatalogStatus } from "../database/prisma.types";
import { CurrentUser } from "../iam/auth/current-user.decorator";
import type { VerifiedAccessToken } from "../iam/auth/token.service";
import type { Authorization } from "../iam/role/authorization";
import { Authorize, Authz } from "../iam/role/authorize.decorator";
import { ProblemDetailsDto } from "../openapi/openapi.dto";
import { AdminCatalogService } from "./admin-catalog.service";
import {
  AdminAmenityDto,
  type AmenityItem,
  AdminAmenityInputDto,
  AdminAmenityListDto,
  type AmenityList,
  AdminCatalogDeactivateDto,
  AdminCatalogIdParamDto,
  AdminCatalogItemParamDto,
  AdminCatalogRenameDto,
  AdminCatalogStatusQueryDto,
  AdminProvinceDto,
  type ProvinceItem,
  AdminProvinceInputDto,
  AdminProvinceListQueryDto,
  AdminProvincePageDto,
  type ProvincePage,
  AdminVehicleTypeDto,
  type VehicleTypeItem,
  AdminVehicleTypeInputDto,
  AdminVehicleTypeListDto,
  type VehicleTypeList,
  AdminVehicleTypeUpdateDto,
  AdminWardDto,
  type WardItem,
  AdminWardInputDto,
  AdminWardListQueryDto,
  AdminWardPageDto,
  type WardPage,
  CATALOG_KINDS,
} from "./dto/admin-catalog.dto";

const problemContent = {
  "application/problem+json": { schema: { $ref: getSchemaPath(ProblemDetailsDto) } },
};
const ID_PARAM = { name: "id", type: String, format: "uuid" } as const;
const CONFLICT = { status: 409, description: "`CATALOG_CODE_CONFLICT` — mã đã có.", content: problemContent };
const NOT_FOUND = { status: 404, description: "`CATALOG_ITEM_NOT_FOUND`.", content: problemContent };
const UNAVAILABLE = { status: 503, description: "Chưa ghi được audit — không lưu gì.", content: problemContent };

// API §7.5 `/admin/catalog/*` — danh mục chuẩn (TASK-ADM-001 phần catalog, UC-24). Quyền `catalog:manage`.
@ApiTags("admin-catalog")
@Controller("admin/catalog")
/** Tỉnh / thành, phường / xã, loại xe, tiện ích: xem mọi trạng thái, thêm, đổi tên, ngừng dùng / dùng lại. */
export class AdminCatalogController {
  constructor(@Inject(AdminCatalogService) private readonly catalog: AdminCatalogService) {}

  @Get("provinces")
  @Authorize("catalog:manage")
  @ZodResponse({ status: 200, description: "Một trang tỉnh / thành, theo mã.", type: AdminProvincePageDto })
  listProvinces(@Authz() authz: Authorization, @Query() query: AdminProvinceListQueryDto): Promise<ProvincePage> {
    return this.catalog.listProvinces(authz, query);
  }

  @Post("provinces")
  @Authorize("catalog:manage")
  @ApiBody({ type: AdminProvinceInputDto })
  @ZodResponse({ status: 201, description: "Tỉnh / thành vừa thêm.", type: AdminProvinceDto })
  @ApiResponse(CONFLICT)
  @ApiResponse(UNAVAILABLE)
  createProvince(
    @Authz() authz: Authorization,
    @CurrentUser() actor: VerifiedAccessToken,
    @Body() input: AdminProvinceInputDto,
  ): Promise<ProvinceItem> {
    return this.catalog.createProvince(authz, actor, input);
  }

  @Put("provinces/:id")
  @Authorize("catalog:manage")
  @ApiParam(ID_PARAM)
  @ApiBody({ type: AdminCatalogRenameDto })
  @ZodResponse({ status: 200, description: "Tỉnh / thành sau khi đổi tên.", type: AdminProvinceDto })
  @ApiResponse(NOT_FOUND)
  @ApiResponse(UNAVAILABLE)
  renameProvince(
    @Authz() authz: Authorization,
    @CurrentUser() actor: VerifiedAccessToken,
    @Param() params: AdminCatalogIdParamDto,
    @Body() input: AdminCatalogRenameDto,
  ): Promise<ProvinceItem> {
    return this.catalog.renameProvince(authz, actor, params.id, input);
  }

  @Get("wards")
  @Authorize("catalog:manage")
  @ZodResponse({ status: 200, description: "Một trang phường / xã, theo mã.", type: AdminWardPageDto })
  listWards(@Authz() authz: Authorization, @Query() query: AdminWardListQueryDto): Promise<WardPage> {
    return this.catalog.listWards(authz, query);
  }

  @Post("wards")
  @Authorize("catalog:manage")
  @ApiBody({ type: AdminWardInputDto })
  @ZodResponse({ status: 201, description: "Phường / xã vừa thêm.", type: AdminWardDto })
  @ApiResponse(NOT_FOUND)
  @ApiResponse(CONFLICT)
  @ApiResponse(UNAVAILABLE)
  createWard(
    @Authz() authz: Authorization,
    @CurrentUser() actor: VerifiedAccessToken,
    @Body() input: AdminWardInputDto,
  ): Promise<WardItem> {
    return this.catalog.createWard(authz, actor, input);
  }

  @Put("wards/:id")
  @Authorize("catalog:manage")
  @ApiParam(ID_PARAM)
  @ApiBody({ type: AdminCatalogRenameDto })
  @ZodResponse({ status: 200, description: "Phường / xã sau khi đổi tên.", type: AdminWardDto })
  @ApiResponse(NOT_FOUND)
  @ApiResponse(UNAVAILABLE)
  renameWard(
    @Authz() authz: Authorization,
    @CurrentUser() actor: VerifiedAccessToken,
    @Param() params: AdminCatalogIdParamDto,
    @Body() input: AdminCatalogRenameDto,
  ): Promise<WardItem> {
    return this.catalog.renameWard(authz, actor, params.id, input);
  }

  @Get("vehicle-types")
  @Authorize("catalog:manage")
  @ZodResponse({ status: 200, description: "Mọi loại xe, theo mã.", type: AdminVehicleTypeListDto })
  listVehicleTypes(@Authz() authz: Authorization, @Query() query: AdminCatalogStatusQueryDto): Promise<VehicleTypeList> {
    return this.catalog.listVehicleTypes(authz, query);
  }

  @Post("vehicle-types")
  @Authorize("catalog:manage")
  @ApiBody({ type: AdminVehicleTypeInputDto })
  @ZodResponse({ status: 201, description: "Loại xe vừa thêm.", type: AdminVehicleTypeDto })
  @ApiResponse(CONFLICT)
  @ApiResponse(UNAVAILABLE)
  createVehicleType(
    @Authz() authz: Authorization,
    @CurrentUser() actor: VerifiedAccessToken,
    @Body() input: AdminVehicleTypeInputDto,
  ): Promise<VehicleTypeItem> {
    return this.catalog.createVehicleType(authz, actor, input);
  }

  @Put("vehicle-types/:id")
  @Authorize("catalog:manage")
  @ApiParam(ID_PARAM)
  @ApiBody({ type: AdminVehicleTypeUpdateDto })
  @ZodResponse({ status: 200, description: "Loại xe sau khi sửa tên / mô tả.", type: AdminVehicleTypeDto })
  @ApiResponse(NOT_FOUND)
  @ApiResponse(UNAVAILABLE)
  updateVehicleType(
    @Authz() authz: Authorization,
    @CurrentUser() actor: VerifiedAccessToken,
    @Param() params: AdminCatalogIdParamDto,
    @Body() input: AdminVehicleTypeUpdateDto,
  ): Promise<VehicleTypeItem> {
    return this.catalog.updateVehicleType(authz, actor, params.id, input);
  }

  @Get("amenities")
  @Authorize("catalog:manage")
  @ZodResponse({ status: 200, description: "Mọi tiện ích, theo mã.", type: AdminAmenityListDto })
  listAmenities(@Authz() authz: Authorization, @Query() query: AdminCatalogStatusQueryDto): Promise<AmenityList> {
    return this.catalog.listAmenities(authz, query);
  }

  @Post("amenities")
  @Authorize("catalog:manage")
  @ApiBody({ type: AdminAmenityInputDto })
  @ZodResponse({ status: 201, description: "Tiện ích vừa thêm.", type: AdminAmenityDto })
  @ApiResponse(CONFLICT)
  @ApiResponse(UNAVAILABLE)
  createAmenity(
    @Authz() authz: Authorization,
    @CurrentUser() actor: VerifiedAccessToken,
    @Body() input: AdminAmenityInputDto,
  ): Promise<AmenityItem> {
    return this.catalog.createAmenity(authz, actor, input);
  }

  @Put("amenities/:id")
  @Authorize("catalog:manage")
  @ApiParam(ID_PARAM)
  @ApiBody({ type: AdminCatalogRenameDto })
  @ZodResponse({ status: 200, description: "Tiện ích sau khi đổi tên.", type: AdminAmenityDto })
  @ApiResponse(NOT_FOUND)
  @ApiResponse(UNAVAILABLE)
  renameAmenity(
    @Authz() authz: Authorization,
    @CurrentUser() actor: VerifiedAccessToken,
    @Param() params: AdminCatalogIdParamDto,
    @Body() input: AdminCatalogRenameDto,
  ): Promise<AmenityItem> {
    return this.catalog.renameAmenity(authz, actor, params.id, input);
  }

  /** Ngừng dùng một mục: lý do bắt buộc (audit); mục ngừng dùng không chọn được cho dữ liệu mới. */
  @Post(":kind/:id/deactivate")
  @HttpCode(204)
  @Authorize("catalog:manage")
  @ApiParam({ name: "kind", enum: CATALOG_KINDS })
  @ApiParam(ID_PARAM)
  @ApiBody({ type: AdminCatalogDeactivateDto })
  @ApiResponse({ status: 204, description: "Đã ngừng dùng." })
  @ApiResponse(NOT_FOUND)
  @ApiResponse({ status: 409, description: "`CATALOG_STATE_INVALID` — đang ngừng dùng rồi.", content: problemContent })
  @ApiResponse(UNAVAILABLE)
  deactivate(
    @Authz() authz: Authorization,
    @CurrentUser() actor: VerifiedAccessToken,
    @Param() params: AdminCatalogItemParamDto,
    @Body() input: AdminCatalogDeactivateDto,
  ): Promise<void> {
    return this.catalog.setStatus(authz, actor, params.kind, params.id, CatalogStatus.INACTIVE, input.reason);
  }

  /** Dùng lại một mục đã ngừng. */
  @Post(":kind/:id/activate")
  @HttpCode(204)
  @Authorize("catalog:manage")
  @ApiParam({ name: "kind", enum: CATALOG_KINDS })
  @ApiParam(ID_PARAM)
  @ApiResponse({ status: 204, description: "Đã dùng lại." })
  @ApiResponse(NOT_FOUND)
  @ApiResponse({ status: 409, description: "`CATALOG_STATE_INVALID` — đang dùng rồi.", content: problemContent })
  @ApiResponse(UNAVAILABLE)
  activate(
    @Authz() authz: Authorization,
    @CurrentUser() actor: VerifiedAccessToken,
    @Param() params: AdminCatalogItemParamDto,
  ): Promise<void> {
    return this.catalog.setStatus(authz, actor, params.kind, params.id, CatalogStatus.ACTIVE, null);
  }
}
