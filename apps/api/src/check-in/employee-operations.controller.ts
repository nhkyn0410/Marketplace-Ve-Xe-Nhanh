import { Body, Controller, Get, HttpCode, Inject, Param, ParseUUIDPipe, Post, Query } from "@nestjs/common";
import { ApiBody, ApiParam, ApiQuery, ApiResponse, ApiTags, getSchemaPath } from "@nestjs/swagger";
import { ZodResponse } from "nestjs-zod";
import { CurrentUser } from "../iam/auth/current-user.decorator";
import type { VerifiedAccessToken } from "../iam/auth/token.service";
import { Authorize, Authz } from "../iam/role/authorize.decorator";
import type { Authorization } from "../iam/role/authorization";
import { ProblemDetailsDto } from "../openapi/openapi.dto";
import {
  CheckInInputDto,
  CheckInResultDto,
  EmployeeAssignmentDto,
  EmployeeAssignmentListDto,
  EmployeeAssignmentsQueryDto,
  TicketVerifyInputDto,
  TicketVerifyResultDto,
  TripManifestDto,
  TripOperationInputDto,
  type CheckInResult,
  type EmployeeAssignmentList,
  type TicketVerifyResult,
  type TripManifest,
} from "./dto/employee-operations.dto";
import { EmployeeOperationsService } from "./employee-operations.service";

const problemContent = {
  "application/problem+json": { schema: { $ref: getSchemaPath(ProblemDetailsDto) } },
};
const TRIP_PARAM = { name: "tripId", type: String, format: "uuid" } as const;

// API §7.4 — nhân viên nhà xe (app `employee_mobile`, Bearer). Soát vé: `checkin:perform` (mọi role Employee, chuyến được phân
// công); trạng thái chuyến: `trip:operate` (chỉ tài xế). Chủ nhà xe / Admin không gọi được (403).
@ApiTags("employee-operations")
@Controller("employee")
/** Chuyến được phân công, danh sách khách, soát vé, trạng thái vận hành (TASK-EMP-002 phần backend). */
export class EmployeeOperationsController {
  constructor(@Inject(EmployeeOperationsService) private readonly operations: EmployeeOperationsService) {}

  @Get("assignments")
  @Authorize("checkin:perform")
  @ApiQuery({ name: "from", required: false, type: String, format: "date" })
  @ApiQuery({ name: "to", required: false, type: String, format: "date" })
  @ZodResponse({ status: 200, description: "Chuyến được phân công, sắp theo giờ khởi hành.", type: EmployeeAssignmentListDto })
  assignments(@Authz() authz: Authorization, @CurrentUser() actor: VerifiedAccessToken, @Query() query: EmployeeAssignmentsQueryDto): Promise<EmployeeAssignmentList> {
    return this.operations.assignments(authz, actor, query);
  }

  @Get("trips/:tripId/passengers")
  @Authorize("checkin:perform")
  @ApiParam(TRIP_PARAM)
  @ZodResponse({ status: 200, description: "Danh sách hành khách (số điện thoại đã che).", type: TripManifestDto })
  @ApiResponse({ status: 404, description: "`ASSIGNMENT_NOT_FOUND`.", content: problemContent })
  passengers(@Authz() authz: Authorization, @CurrentUser() actor: VerifiedAccessToken, @Param("tripId", new ParseUUIDPipe()) tripId: string): Promise<TripManifest> {
    return this.operations.manifest(authz, actor, tripId);
  }

  /** Soát vé — không đổi gì, trả kết quả + thông tin đối chiếu. */
  @Post("tickets/verify")
  @HttpCode(200)
  @Authorize("checkin:perform")
  @ApiBody({ type: TicketVerifyInputDto })
  @ZodResponse({ status: 200, description: "Kết quả soát vé.", type: TicketVerifyResultDto })
  @ApiResponse({ status: 404, description: "`ASSIGNMENT_NOT_FOUND` / `TICKET_NOT_FOUND`.", content: problemContent })
  verify(@Authz() authz: Authorization, @CurrentUser() actor: VerifiedAccessToken, @Body() input: TicketVerifyInputDto): Promise<TicketVerifyResult> {
    return this.operations.verify(authz, actor, input);
  }

  /** Cho lên xe / ghi nhận vắng mặt. */
  @Post("check-ins")
  @HttpCode(200)
  @Authorize("checkin:perform")
  @ApiBody({ type: CheckInInputDto })
  @ZodResponse({ status: 200, description: "Vé sau khi check-in + số khách đã lên.", type: CheckInResultDto })
  @ApiResponse({ status: 404, description: "`ASSIGNMENT_NOT_FOUND` / `TICKET_NOT_FOUND`.", content: problemContent })
  @ApiResponse({ status: 409, description: "`CHECK_IN_REJECTED` (sai chuyến / đã hủy / đã hoàn / đã check-in) / `CHECK_IN_CLOSED`.", content: problemContent })
  checkIn(@Authz() authz: Authorization, @CurrentUser() actor: VerifiedAccessToken, @Body() input: CheckInInputDto): Promise<CheckInResult> {
    return this.operations.checkIn(authz, actor, input);
  }

  /** Tài xế đổi trạng thái vận hành: đón khách → đã khởi hành → đang chạy → hoàn thành. */
  @Post("trips/:tripId/status")
  @HttpCode(200)
  @Authorize("trip:operate")
  @ApiParam(TRIP_PARAM)
  @ApiBody({ type: TripOperationInputDto })
  @ZodResponse({ status: 200, description: "Chuyến sau khi đổi trạng thái.", type: EmployeeAssignmentDto })
  @ApiResponse({ status: 404, description: "`ASSIGNMENT_NOT_FOUND` (không phải tài xế của chuyến).", content: problemContent })
  @ApiResponse({ status: 409, description: "`TRIP_OPERATION_INVALID` (sai thứ tự / chuyến đã hủy / đã hoàn thành).", content: problemContent })
  operate(
    @Authz() authz: Authorization,
    @CurrentUser() actor: VerifiedAccessToken,
    @Param("tripId", new ParseUUIDPipe()) tripId: string,
    @Body() input: TripOperationInputDto,
  ) {
    return this.operations.operate(authz, actor, tripId, input);
  }
}
