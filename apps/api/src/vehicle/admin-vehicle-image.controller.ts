import { Body, Controller, Get, HttpCode, Inject, Param, Post, Query } from "@nestjs/common";
import { ApiBody, ApiParam, ApiResponse, ApiTags, getSchemaPath } from "@nestjs/swagger";
import { ZodResponse } from "nestjs-zod";
import { CurrentUser } from "../iam/auth/current-user.decorator";
import type { VerifiedAccessToken } from "../iam/auth/token.service";
import type { Authorization } from "../iam/role/authorization";
import { Authorize, Authz } from "../iam/role/authorize.decorator";
import { ProblemDetailsDto } from "../openapi/openapi.dto";
import {
  AdminRemoveVehicleImageInputDto,
  AdminVehicleImageIdParamDto,
  AdminVehicleImageListDto,
  type AdminVehicleImageList,
  AdminVehicleImageListQueryDto,
} from "./dto/admin-vehicle-image.dto";
import { AdminVehicleImageService } from "./admin-vehicle-image.service";

const problemContent = {
  "application/problem+json": { schema: { $ref: getSchemaPath(ProblemDetailsDto) } },
};

// API §7.5 — Admin rà soát / gỡ ảnh phương tiện vi phạm (TASK-ADM-003 phần ảnh xe, FR-ADM-20, BR-76).
// Quyền `content:moderate` (PLATFORM_ADMIN).
@ApiTags("admin-vehicle-images")
@Controller("admin/vehicle-images")
/** Ảnh phương tiện của mọi nhà xe để rà soát. */
export class AdminVehicleImageController {
  constructor(@Inject(AdminVehicleImageService) private readonly images: AdminVehicleImageService) {}

  /** Mới tải lên trước, lọc nhà xe / thời gian tải lên, cursor `{createdAt}_{id}`. */
  @Get()
  @Authorize("content:moderate")
  @ZodResponse({ status: 200, description: "Một trang ảnh phương tiện.", type: AdminVehicleImageListDto })
  list(@Authz() authz: Authorization, @Query() query: AdminVehicleImageListQueryDto): Promise<AdminVehicleImageList> {
    return this.images.list(authz, query);
  }

  /** Gỡ ảnh vi phạm (xóa hẳn), lý do bắt buộc; audit + email báo chủ nhà xe. */
  @Post(":imageId/remove")
  @HttpCode(204)
  @Authorize("content:moderate")
  @ApiParam({ name: "imageId", type: String, format: "uuid" })
  @ApiBody({ type: AdminRemoveVehicleImageInputDto })
  @ApiResponse({ status: 204, description: "Đã gỡ ảnh." })
  @ApiResponse({ status: 404, description: "`VEHICLE_IMAGE_NOT_FOUND`.", content: problemContent })
  @ApiResponse({ status: 503, description: "Chưa ghi được audit — ảnh chưa bị gỡ.", content: problemContent })
  remove(
    @Authz() authz: Authorization,
    @CurrentUser() actor: VerifiedAccessToken,
    @Param() params: AdminVehicleImageIdParamDto,
    @Body() input: AdminRemoveVehicleImageInputDto,
  ): Promise<void> {
    return this.images.remove(authz, actor, params.imageId, input.reason);
  }
}
