import { Body, Controller, Inject, Param, ParseIntPipe, ParseUUIDPipe, Put } from "@nestjs/common";
import { ApiTags } from "@nestjs/swagger";
import { PickupWindowInputSchema } from "@vexenhanh/types";
import { createZodDto, ZodResponse } from "nestjs-zod";
import { Authorize, Authz } from "../iam/role/authorize.decorator";
import type { Authorization } from "../iam/role/authorization";
import { TripResponseDto, type TripResponse } from "./dto/trip.dto";
import { TripService } from "./trip.service";

/** Cửa sổ đón tại một điểm riêng của chuyến. */
export class PickupWindowInputDto extends createZodDto(PickupWindowInputSchema) {}

/** API thiết lập cửa sổ đón theo điểm của chuyến. */
@ApiTags("operator-trips")
@Controller("operator/trips")
export class PickupWindowController {
  constructor(@Inject(TripService) private readonly trips: TripService) {}
  /** Lưu hai mốc đón hoặc xóa cửa sổ đã cấu hình. */
  @Put(":tripId/stops/:sequence/pickup-window")
  @Authorize("trip:manage")
  @ZodResponse({ status: 200, type: TripResponseDto })
  update(@Authz() authz: Authorization, @Param("tripId", new ParseUUIDPipe()) tripId: string, @Param("sequence", ParseIntPipe) sequence: number, @Body() input: PickupWindowInputDto): Promise<TripResponse> {
    return this.trips.setPickupWindow(authz, tripId, sequence, input);
  }
}
