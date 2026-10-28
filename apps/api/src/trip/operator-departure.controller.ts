import { Body, Controller, HttpCode, Inject, Param, ParseUUIDPipe, Post } from "@nestjs/common";
import { ApiBody, ApiParam, ApiResponse, ApiTags, getSchemaPath } from "@nestjs/swagger";
import { ZodResponse } from "nestjs-zod";
import { CurrentUser } from "../iam/auth/current-user.decorator";
import type { VerifiedAccessToken } from "../iam/auth/token.service";
import { Authorize, Authz } from "../iam/role/authorize.decorator";
import type { Authorization } from "../iam/role/authorization";
import { ProblemDetailsDto } from "../openapi/openapi.dto";
import { TripDepartureDto, TripDepartureInputDto } from "./dto/trip-departure.dto";
import { OperatorDepartureService } from "./operator-departure.service";

const problemContent = { "application/problem+json": { schema: { $ref: getSchemaPath(ProblemDetailsDto) } } };

/** API xác nhận khởi hành thực tế cho điều phối trên Operator OS. */
@ApiTags("operator-trips")
@Controller("operator/trips")
export class OperatorDepartureController {
  constructor(@Inject(OperatorDepartureService) private readonly departures: OperatorDepartureService) {}

  /** Ghi mốc khởi hành thực tế; yêu cầu lặp không đổi thời điểm đã xác nhận. */
  @Post(":tripId/departure")
  @HttpCode(200)
  @Authorize("trip:dispatch")
  @ApiParam({ name: "tripId", type: String, format: "uuid" })
  @ApiBody({ type: TripDepartureInputDto })
  @ZodResponse({ status: 200, description: "Mốc khởi hành thực tế (giờ máy chủ).", type: TripDepartureDto })
  @ApiResponse({ status: 404, description: "TRIP_NOT_FOUND (kể cả khác nhà xe).", content: problemContent })
  @ApiResponse({ status: 409, description: "TRIP_STATUS_TRANSITION_INVALID — chuyến chưa mở bán hoặc đã hủy.", content: problemContent })
  depart(@CurrentUser() actor: VerifiedAccessToken, @Authz() authz: Authorization, @Param("tripId", new ParseUUIDPipe()) tripId: string, @Body() input: TripDepartureInputDto) {
    return this.departures.depart(actor, authz, tripId, input);
  }
}
