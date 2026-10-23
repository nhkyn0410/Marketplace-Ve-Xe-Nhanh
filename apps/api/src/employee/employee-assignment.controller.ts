import { Body, Controller, Get, Inject, Param, Put, Query } from "@nestjs/common";
import { ApiBody, ApiParam, ApiQuery, ApiResponse, ApiTags, getSchemaPath } from "@nestjs/swagger";
import { ZodResponse } from "nestjs-zod";
import { CurrentUser } from "../iam/auth/current-user.decorator";
import type { VerifiedAccessToken } from "../iam/auth/token.service";
import { Authorize, Authz } from "../iam/role/authorize.decorator";
import type { Authorization } from "../iam/role/authorization";
import { ProblemDetailsDto } from "../openapi/openapi.dto";
import {
  ASSIGNMENT_STATES,
  DriverAssignmentInputDto,
  TripAssignmentDto,
  TripAssignmentListQueryDto,
  TripAssignmentPageDto,
  type TripAssignment,
  type TripAssignmentPage,
} from "./dto/employee-assignment.dto";
import { EmployeeAssignmentService } from "./employee-assignment.service";

const problemContent = {
  "application/problem+json": { schema: { $ref: getSchemaPath(ProblemDetailsDto) } },
};

// API §7.3 — chỉ Owner (`employee:manage`, UC-16 "Quản lý Employee và phân công nhiệm vụ"); tenant lấy từ JWT.
@ApiTags("operator-trip-assignments")
@Controller("operator")
/** API phân công tài xế cho chuyến của nhà xe (TASK-EMP-001 phía Operator OS). */
export class EmployeeAssignmentController {
  constructor(@Inject(EmployeeAssignmentService) private readonly assignments: EmployeeAssignmentService) {}

  /** Chuyến chưa hủy khởi hành trong một ngày kèm tài xế đang phân công. */
  @Get("trip-assignments")
  @Authorize("employee:manage")
  @ApiQuery({ name: "date", required: true, type: String, format: "date" })
  @ApiQuery({ name: "routeId", required: false, type: String, format: "uuid" })
  @ApiQuery({ name: "state", required: false, enum: ASSIGNMENT_STATES })
  @ApiQuery({ name: "cursor", required: false, type: String, format: "uuid" })
  @ApiQuery({ name: "limit", required: false, type: Number, minimum: 1, maximum: 100 })
  @ZodResponse({ status: 200, description: "Một trang chuyến theo giờ khởi hành.", type: TripAssignmentPageDto })
  @ApiResponse({ status: 400, description: "Query không hợp lệ.", content: problemContent })
  list(@Authz() authz: Authorization, @Query() query: TripAssignmentListQueryDto): Promise<TripAssignmentPage> {
    return this.assignments.list(authz, query);
  }

  /** Phân công / đổi / bỏ tài xế của một chuyến. */
  @Put("trips/:tripId/driver")
  @Authorize("employee:manage")
  @ApiParam({ name: "tripId", type: String, format: "uuid" })
  @ApiBody({ type: DriverAssignmentInputDto })
  @ZodResponse({ status: 200, description: "Chuyến sau khi phân công.", type: TripAssignmentDto })
  @ApiResponse({ status: 404, description: "`TRIP_NOT_FOUND` (kể cả khác tenant).", content: problemContent })
  @ApiResponse({
    status: 409,
    description: "`DRIVER_SCHEDULE_CONFLICT` / `TRIP_NOT_ASSIGNABLE` (chuyến đã hủy / hoàn thành).",
    content: problemContent,
  })
  @ApiResponse({ status: 422, description: "`EMPLOYEE_NOT_ASSIGNABLE` / `ASSIGNMENT_REASON_REQUIRED`.", content: problemContent })
  @ApiResponse({ status: 503, description: "Chưa ghi được audit — phân công không đổi.", content: problemContent })
  assignDriver(
    @CurrentUser() actor: VerifiedAccessToken,
    @Authz() authz: Authorization,
    @Param("tripId") tripId: string,
    @Body() input: DriverAssignmentInputDto,
  ): Promise<TripAssignment> {
    return this.assignments.assignDriver(actor, authz, tripId, input);
  }
}
