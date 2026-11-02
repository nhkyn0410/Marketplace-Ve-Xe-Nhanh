import { Controller, Get, Inject, Param, ParseUUIDPipe, Query } from "@nestjs/common";
import { ApiParam, ApiQuery, ApiTags } from "@nestjs/swagger";
import { PassengerPageQuerySchema, PublicOperatorProfileSchema } from "@vexenhanh/types";
import { createZodDto, ZodResponse } from "nestjs-zod";
import { PublicOperatorProfileService } from "./public-operator-profile.service";

/** Hồ sơ công khai của nhà xe đang hoạt động. */
export class PublicOperatorProfileDto extends createZodDto(PublicOperatorProfileSchema) {}
/** Phân trang review công khai. */
export class PublicOperatorReviewsQueryDto extends createZodDto(PassengerPageQuerySchema) {}

/** Trả hồ sơ nhà xe và scorecard cho hành khách, khách vãng lai (MKT-001). */
@ApiTags("public-operators")
@Controller("operators")
export class PublicOperatorProfileController {
  constructor(@Inject(PublicOperatorProfileService) private readonly profiles: PublicOperatorProfileService) {}

  /** Đọc dữ liệu công khai và review hợp lệ của nhà xe. */
  @Get(":operatorId/public-profile")
  @ApiParam({ name: "operatorId", type: String, format: "uuid" })
  @ApiQuery({ name: "cursor", required: false, type: String, format: "uuid" })
  @ApiQuery({ name: "limit", required: false, type: Number, maximum: 100 })
  @ZodResponse({ status: 200, type: PublicOperatorProfileDto })
  get(@Param("operatorId", new ParseUUIDPipe()) operatorId: string, @Query() query: PublicOperatorReviewsQueryDto) {
    return this.profiles.get(operatorId, query);
  }
}
