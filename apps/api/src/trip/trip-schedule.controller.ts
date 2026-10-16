import { Body, Controller, Get, HttpCode, Inject, Param, Post, Put } from "@nestjs/common";
import { ApiBody, ApiParam, ApiResponse, ApiTags, getSchemaPath } from "@nestjs/swagger";
import { ZodResponse } from "nestjs-zod";
import { CurrentUser } from "../iam/auth/current-user.decorator";
import type { VerifiedAccessToken } from "../iam/auth/token.service";
import { Authorize, Authz } from "../iam/role/authorize.decorator";
import type { Authorization } from "../iam/role/authorization";
import { ProblemDetailsDto } from "../openapi/openapi.dto";
import {
  TripScheduleGenerateInputDto,
  TripScheduleGenerateResponseDto,
  type TripScheduleGenerateResponse,
  TripScheduleInputDto,
  TripScheduleListResponseDto,
  type TripScheduleListResponse,
  TripScheduleResponseDto,
  type TripScheduleResponse,
} from "./dto/trip-schedule.dto";
import { TripScheduleService } from "./trip-schedule.service";

const problemContent = {
  "application/problem+json": { schema: { $ref: getSchemaPath(ProblemDetailsDto) } },
};
const ID_PARAM = { name: "scheduleId", type: String, format: "uuid" } as const;

// API §7.3 — chỉ Owner (`trip:manage`, như chuyến); tenant lấy từ JWT, không từ body/path.
@ApiTags("operator-trip-schedules")
@Controller("operator/trip-schedules")
/** API lịch chuyến lặp lại của nhà xe (TASK-TRN-007). */
export class TripScheduleController {
  constructor(@Inject(TripScheduleService) private readonly schedules: TripScheduleService) {}

  /** Các lịch của nhà xe. */
  @Get()
  @Authorize("trip:manage")
  @ZodResponse({ status: 200, description: "Lịch còn hiệu lực trước.", type: TripScheduleListResponseDto })
  list(@Authz() authz: Authorization): Promise<TripScheduleListResponse> {
    return this.schedules.list(authz);
  }

  /** Chi tiết một lịch. */
  @Get(":scheduleId")
  @Authorize("trip:manage")
  @ApiParam(ID_PARAM)
  @ZodResponse({ status: 200, description: "Lịch chuyến lặp lại.", type: TripScheduleResponseDto })
  @ApiResponse({ status: 404, description: "`TRIP_SCHEDULE_NOT_FOUND` (kể cả khác tenant).", content: problemContent })
  get(@Authz() authz: Authorization, @Param("scheduleId") scheduleId: string): Promise<TripScheduleResponse> {
    return this.schedules.get(authz, scheduleId);
  }

  /** Tạo lịch (chưa sinh chuyến). */
  @Post()
  @HttpCode(201)
  @Authorize("trip:manage")
  @ApiBody({ type: TripScheduleInputDto })
  @ZodResponse({ status: 201, description: "Lịch đã tạo.", type: TripScheduleResponseDto })
  @ApiResponse({ status: 400, description: "Dữ liệu không hợp lệ (ngày kết thúc trước ngày bắt đầu…).", content: problemContent })
  @ApiResponse({ status: 422, description: "`ROUTE_UNAVAILABLE` / `VEHICLE_UNAVAILABLE`.", content: problemContent })
  create(
    @CurrentUser() actor: VerifiedAccessToken,
    @Authz() authz: Authorization,
    @Body() input: TripScheduleInputDto,
  ): Promise<TripScheduleResponse> {
    return this.schedules.create(actor, authz, input);
  }

  /** Thay toàn bộ quy tắc của lịch; chuyến đã sinh giữ nguyên. */
  @Put(":scheduleId")
  @Authorize("trip:manage")
  @ApiParam(ID_PARAM)
  @ApiBody({ type: TripScheduleInputDto })
  @ZodResponse({ status: 200, description: "Lịch sau khi sửa.", type: TripScheduleResponseDto })
  @ApiResponse({ status: 400, description: "Dữ liệu không hợp lệ.", content: problemContent })
  @ApiResponse({ status: 404, description: "`TRIP_SCHEDULE_NOT_FOUND`.", content: problemContent })
  @ApiResponse({ status: 422, description: "`ROUTE_UNAVAILABLE` / `VEHICLE_UNAVAILABLE`.", content: problemContent })
  update(
    @CurrentUser() actor: VerifiedAccessToken,
    @Authz() authz: Authorization,
    @Param("scheduleId") scheduleId: string,
    @Body() input: TripScheduleInputDto,
  ): Promise<TripScheduleResponse> {
    return this.schedules.update(actor, authz, scheduleId, input);
  }

  /** Sinh chuyến nháp cho các ngày khớp lịch còn ở tương lai; tuỳ chọn mở bán ngay chuyến đủ điều kiện. */
  @Post(":scheduleId/generate")
  @HttpCode(200)
  @Authorize("trip:manage")
  @ApiParam(ID_PARAM)
  @ApiBody({ type: TripScheduleGenerateInputDto })
  @ZodResponse({ status: 200, description: "Chuyến đã sinh và ngày bỏ qua.", type: TripScheduleGenerateResponseDto })
  @ApiResponse({ status: 404, description: "`TRIP_SCHEDULE_NOT_FOUND`.", content: problemContent })
  @ApiResponse({ status: 422, description: "`ROUTE_UNAVAILABLE` / `VEHICLE_UNAVAILABLE`.", content: problemContent })
  generate(
    @CurrentUser() actor: VerifiedAccessToken,
    @Authz() authz: Authorization,
    @Param("scheduleId") scheduleId: string,
    @Body() input: TripScheduleGenerateInputDto,
  ): Promise<TripScheduleGenerateResponse> {
    return this.schedules.generate(actor, authz, scheduleId, input);
  }
}
