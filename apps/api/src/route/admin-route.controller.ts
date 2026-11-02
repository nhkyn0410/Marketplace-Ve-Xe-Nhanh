import { Controller, Get, Inject, Param, Query } from "@nestjs/common";
import { ApiParam, ApiResponse, ApiTags, getSchemaPath } from "@nestjs/swagger";
import { ZodResponse } from "nestjs-zod";
import { CurrentUser } from "../iam/auth/current-user.decorator";
import type { VerifiedAccessToken } from "../iam/auth/token.service";
import type { Authorization } from "../iam/role/authorization";
import { Authorize, Authz } from "../iam/role/authorize.decorator";
import { ProblemDetailsDto } from "../openapi/openapi.dto";
import { AdminRouteService } from "./admin-route.service";
import {
  AdminRouteDetailDto,
  type AdminRouteDetail,
  AdminRouteDetailQueryDto,
  AdminRouteIdParamDto,
  AdminRouteListQueryDto,
  AdminRoutePageDto,
  type AdminRoutePage,
} from "./dto/admin-route.dto";

const problemContent = {
  "application/problem+json": { schema: { $ref: getSchemaPath(ProblemDetailsDto) } },
};

// API §7.5 — Admin giám sát tuyến của mọi nhà xe (FR-NSR-13, SRS ma trận quyền; chờ duyệt 28/10/2026). Chỉ xem, quyền
// `user:manage` (như mục Nhà xe); doanh thu vé chỉ có khi người xem có thêm `payment:monitor`.
@ApiTags("admin-routes")
@Controller("admin/routes")
/** Tuyến của mọi nhà xe kèm hiệu suất theo kỳ. */
export class AdminRouteController {
  constructor(@Inject(AdminRouteService) private readonly routes: AdminRouteService) {}

  /** Lọc nhà xe / trạng thái / tỉnh đi – đến / tên, kỳ mặc định 30 ngày; xếp theo vé bán (tuyến phổ biến), doanh thu, số chuyến, lấp đầy, tên. */
  @Get()
  @Authorize("user:manage")
  @ZodResponse({ status: 200, description: "Một trang tuyến.", type: AdminRoutePageDto })
  @ApiResponse({ status: 400, description: "Query không hợp lệ (kỳ tối đa 366 ngày).", content: problemContent })
  list(@Authz() authz: Authorization, @CurrentUser() viewer: VerifiedAccessToken, @Query() query: AdminRouteListQueryDto): Promise<AdminRoutePage> {
    return this.routes.list(authz, viewer, query);
  }

  /** Chi tiết tuyến: điểm dừng theo thứ tự (tọa độ để vẽ bản đồ), số liệu kỳ, 10 chuyến sắp chạy. */
  @Get(":id")
  @Authorize("user:manage")
  @ApiParam({ name: "id", type: String, format: "uuid" })
  @ZodResponse({ status: 200, description: "Chi tiết tuyến.", type: AdminRouteDetailDto })
  @ApiResponse({ status: 404, description: "`ROUTE_NOT_FOUND`.", content: problemContent })
  detail(
    @Authz() authz: Authorization,
    @CurrentUser() viewer: VerifiedAccessToken,
    @Param() params: AdminRouteIdParamDto,
    @Query() query: AdminRouteDetailQueryDto,
  ): Promise<AdminRouteDetail> {
    return this.routes.detail(authz, viewer, params.id, query);
  }
}
