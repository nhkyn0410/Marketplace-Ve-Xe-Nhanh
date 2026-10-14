import { Body, Controller, HttpCode, Inject, Param, Post, Put } from "@nestjs/common";
import { ApiBody, ApiParam, ApiResponse, ApiTags, getSchemaPath } from "@nestjs/swagger";
import { ZodResponse } from "nestjs-zod";
import { CurrentUser } from "../iam/auth/current-user.decorator";
import type { VerifiedAccessToken } from "../iam/auth/token.service";
import { Authorize, Authz } from "../iam/role/authorize.decorator";
import type { Authorization } from "../iam/role/authorization";
import { ProblemDetailsDto } from "../openapi/openapi.dto";
import {
  VehicleImagesInputDto,
  VehicleImagesResponseDto,
  type VehicleImagesResponse,
  VehicleImageUploadInputDto,
  VehicleImageUploadResponseDto,
  type VehicleImageUploadResponse,
} from "./dto/vehicle-image.dto";
import { VehicleImageService } from "./vehicle-image.service";

const problemContent = {
  "application/problem+json": { schema: { $ref: getSchemaPath(ProblemDetailsDto) } },
};

// API §7.3 — ảnh công khai của xe (TASK-TRN-009, BR-76). Cùng quyền với sửa xe: `vehicle:manage`.
@ApiTags("operator-vehicles")
@Controller("operator/vehicles/:vehicleId/images")
/** API tải lên và sắp xếp bộ ảnh của một xe. */
export class VehicleImageController {
  constructor(@Inject(VehicleImageService) private readonly images: VehicleImageService) {}

  /** Cấp URL để trình duyệt tải thẳng một ảnh lên kho (hiệu lực 5 phút). */
  @Post("upload-url")
  @HttpCode(200)
  @Authorize("vehicle:manage")
  @ApiParam({ name: "vehicleId", type: String, format: "uuid" })
  @ApiBody({ type: VehicleImageUploadInputDto })
  @ZodResponse({ status: 200, description: "URL tải lên và khóa object.", type: VehicleImageUploadResponseDto })
  @ApiResponse({ status: 400, description: "Loại file hoặc dung lượng không hợp lệ.", content: problemContent })
  @ApiResponse({ status: 404, description: "`VEHICLE_NOT_FOUND` (kể cả khác tenant).", content: problemContent })
  @ApiResponse({ status: 429, description: "`VEHICLE_IMAGE_UPLOAD_RATE_LIMITED`.", content: problemContent })
  @ApiResponse({ status: 503, description: "Kho lưu ảnh không phản hồi.", content: problemContent })
  createUploadUrl(
    @CurrentUser() actor: VerifiedAccessToken,
    @Authz() authz: Authorization,
    @Param("vehicleId") vehicleId: string,
    @Body() input: VehicleImageUploadInputDto,
  ): Promise<VehicleImageUploadResponse> {
    return this.images.createUploadUrl(actor, authz, vehicleId, input);
  }

  /** Thay toàn bộ bộ ảnh của xe theo thứ tự gửi lên; phần tử đầu là ảnh đại diện. */
  @Put()
  @Authorize("vehicle:manage")
  @ApiParam({ name: "vehicleId", type: String, format: "uuid" })
  @ApiBody({ type: VehicleImagesInputDto })
  @ZodResponse({ status: 200, description: "Bộ ảnh sau khi thay.", type: VehicleImagesResponseDto })
  @ApiResponse({ status: 400, description: "Dữ liệu không hợp lệ (chú thích quá dài, ảnh lặp).", content: problemContent })
  @ApiResponse({ status: 404, description: "`VEHICLE_NOT_FOUND` (kể cả khác tenant).", content: problemContent })
  @ApiResponse({
    status: 422,
    description: "`VEHICLE_IMAGE_INVALID` / `VEHICLE_IMAGE_LIMIT_EXCEEDED`.",
    content: problemContent,
  })
  @ApiResponse({ status: 503, description: "Kho lưu ảnh không phản hồi.", content: problemContent })
  replace(
    @Authz() authz: Authorization,
    @Param("vehicleId") vehicleId: string,
    @Body() input: VehicleImagesInputDto,
  ): Promise<VehicleImagesResponse> {
    return this.images.replace(authz, vehicleId, input);
  }
}
