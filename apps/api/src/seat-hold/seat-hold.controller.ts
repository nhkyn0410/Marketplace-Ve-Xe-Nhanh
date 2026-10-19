import { Body, Controller, Delete, Get, HttpCode, Inject, Param, ParseUUIDPipe, Post, Req } from "@nestjs/common";
import { ApiBody, ApiParam, ApiResponse, ApiTags, getSchemaPath } from "@nestjs/swagger";
import type { Request } from "express";
import { ZodResponse } from "nestjs-zod";
import { resolveTrustedClientIp } from "../common/trusted-client-ip";
import { APP_CONFIG, type AppConfig } from "../config/env.config";
import type { VerifiedAccessToken } from "../iam/auth/token.service";
import { GuestOrPassenger, OptionalPassenger } from "../iam/role/guest-or-passenger";
import { ProblemDetailsDto } from "../openapi/openapi.dto";
import { SeatHoldInputDto, SeatHoldResponseDto, type SeatHoldResponse } from "./dto/seat-hold.dto";
import { SeatHoldService } from "./seat-hold.service";

const problemContent = {
  "application/problem+json": { schema: { $ref: getSchemaPath(ProblemDetailsDto) } },
};
const HOLD_PARAM = { name: "holdId", type: String, format: "uuid" } as const;

// API §7.2 — khách vãng lai hoặc hành khách đã đăng nhập (`booking:create`).
@ApiTags("seat-holds")
@Controller("seat-holds")
/** Giữ chỗ trước khi đặt vé (TASK-BTP-001). */
export class SeatHoldController {
  constructor(
    @Inject(SeatHoldService) private readonly holds: SeatHoldService,
    @Inject(APP_CONFIG) private readonly config: AppConfig,
  ) {}

  /** Giữ các chỗ của một chuyến kèm điểm đón / trả; hết hạn theo chính sách giữ chỗ (10 phút). */
  @Post()
  @HttpCode(201)
  @GuestOrPassenger("booking:create")
  @ApiBody({ type: SeatHoldInputDto })
  @ZodResponse({ status: 201, description: "Đã giữ chỗ.", type: SeatHoldResponseDto })
  @ApiResponse({ status: 404, description: "`TRIP_NOT_FOUND`.", content: problemContent })
  @ApiResponse({ status: 409, description: "`SEAT_HOLD_CONFLICT` / `SEAT_NOT_AVAILABLE` (`reasons` = mã chỗ).", content: problemContent })
  @ApiResponse({ status: 422, description: "`SEAT_HOLD_STOPS_INVALID` / `TRIP_SEAT_UNKNOWN`.", content: problemContent })
  @ApiResponse({ status: 429, description: "`SEAT_HOLD_RATE_LIMITED`.", content: problemContent })
  @ApiResponse({ status: 503, description: "Hệ thống giữ chỗ gián đoạn.", content: problemContent })
  create(
    @OptionalPassenger() user: VerifiedAccessToken | null,
    @Req() request: Request,
    @Body() input: SeatHoldInputDto,
  ): Promise<SeatHoldResponse> {
    return this.holds.create(user, resolveTrustedClientIp(request, this.config.NODE_ENV), input);
  }

  @Get(":holdId")
  @GuestOrPassenger("booking:create")
  @ApiParam(HOLD_PARAM)
  @ZodResponse({ status: 200, description: "Giữ chỗ đang hiệu lực.", type: SeatHoldResponseDto })
  @ApiResponse({ status: 404, description: "`SEAT_HOLD_EXPIRED`.", content: problemContent })
  get(@OptionalPassenger() user: VerifiedAccessToken | null, @Param("holdId", new ParseUUIDPipe()) holdId: string): Promise<SeatHoldResponse> {
    return this.holds.get(user, holdId);
  }

  @Delete(":holdId")
  @HttpCode(204)
  @GuestOrPassenger("booking:create")
  @ApiParam(HOLD_PARAM)
  @ApiResponse({ status: 204, description: "Đã bỏ giữ chỗ." })
  @ApiResponse({ status: 404, description: "`SEAT_HOLD_EXPIRED`.", content: problemContent })
  async release(@OptionalPassenger() user: VerifiedAccessToken | null, @Param("holdId", new ParseUUIDPipe()) holdId: string): Promise<void> {
    await this.holds.release(user, holdId);
  }
}
