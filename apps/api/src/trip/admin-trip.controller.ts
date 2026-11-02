import { Controller, Get, Inject, Param, Query } from "@nestjs/common";
import { ApiParam, ApiResponse, ApiTags, getSchemaPath } from "@nestjs/swagger";
import { ZodResponse } from "nestjs-zod";
import { CurrentUser } from "../iam/auth/current-user.decorator";
import type { VerifiedAccessToken } from "../iam/auth/token.service";
import type { Authorization } from "../iam/role/authorization";
import { Authorize, Authz } from "../iam/role/authorize.decorator";
import { ProblemDetailsDto } from "../openapi/openapi.dto";
import { AdminTripService } from "./admin-trip.service";
import {
  AdminTripDetailDto,
  type AdminTripDetail,
  AdminTripIdParamDto,
  AdminTripListQueryDto,
  AdminTripPageDto,
  type AdminTripPage,
} from "./dto/admin-trip.dto";

const problemContent = {
  "application/problem+json": { schema: { $ref: getSchemaPath(ProblemDetailsDto) } },
};

// API §7.5 — Admin giám sát chuyến của mọi nhà xe (SRS ma trận quyền; chờ duyệt 28/10/2026). Chỉ xem, quyền `user:manage`.
@ApiTags("admin-trips")
@Controller("admin/trips")
/** Chuyến của mọi nhà xe. */
export class AdminTripController {
  constructor(@Inject(AdminTripService) private readonly trips: AdminTripService) {}

  /** Khởi hành sớm trước; mặc định hôm nay + 6 ngày, lọc nhà xe / tuyến / trạng thái, tìm biển số hoặc tên tuyến. */
  @Get()
  @Authorize("user:manage")
  @ZodResponse({ status: 200, description: "Một trang chuyến.", type: AdminTripPageDto })
  @ApiResponse({ status: 400, description: "Query không hợp lệ (kỳ tối đa 92 ngày).", content: problemContent })
  list(@Authz() authz: Authorization, @Query() query: AdminTripListQueryDto): Promise<AdminTripPage> {
    return this.trips.list(authz, query);
  }

  /** Chi tiết chuyến kèm danh sách người đi — mỗi lượt xem ghi audit. */
  @Get(":id")
  @Authorize("user:manage")
  @ApiParam({ name: "id", type: String, format: "uuid" })
  @ZodResponse({ status: 200, description: "Chi tiết chuyến.", type: AdminTripDetailDto })
  @ApiResponse({ status: 404, description: "`TRIP_NOT_FOUND`.", content: problemContent })
  @ApiResponse({ status: 503, description: "Chưa ghi được nhật ký lượt xem — không trả dữ liệu.", content: problemContent })
  detail(@Authz() authz: Authorization, @CurrentUser() viewer: VerifiedAccessToken, @Param() params: AdminTripIdParamDto): Promise<AdminTripDetail> {
    return this.trips.detail(authz, viewer, params.id);
  }
}
