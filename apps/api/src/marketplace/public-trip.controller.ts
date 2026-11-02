import { Controller, Get, Inject, Param, ParseUUIDPipe, Query } from "@nestjs/common";
import { ApiParam, ApiQuery, ApiResponse, ApiTags, getSchemaPath } from "@nestjs/swagger";
import { ZodResponse } from "nestjs-zod";
import { ProblemDetailsDto } from "../openapi/openapi.dto";
import {
  PublicTripDto,
  PublicTripQueryDto,
  type PublicTrip,
  TripSearchQueryDto,
  TripSearchResponseDto,
  type TripSearchResponse,
} from "./dto/public-trip.dto";
import { TripSearchService } from "./trip-search.service";

const problemContent = {
  "application/problem+json": { schema: { $ref: getSchemaPath(ProblemDetailsDto) } },
};

// API §7.2 — công khai (User, Guest), không cần đăng nhập.
@ApiTags("trips")
@Controller("trips")
/** Tìm chuyến + chi tiết chuyến công khai (TASK-TRN-004). */
export class PublicTripController {
  constructor(@Inject(TripSearchService) private readonly trips: TripSearchService) {}

  /** Tìm chuyến theo điểm đi / điểm đến (tỉnh / thành hoặc địa danh), ngày đi, số khách; lọc + sắp xếp + phân trang. */
  @Get("search")
  @ZodResponse({ status: 200, description: "Một trang chuyến đang mở bán khớp truy vấn.", type: TripSearchResponseDto })
  @ApiResponse({ status: 400, description: "Query không hợp lệ.", content: problemContent })
  search(@Query() query: TripSearchQueryDto): Promise<TripSearchResponse> {
    return this.trips.search(query);
  }

  /** Chi tiết chuyến đang mở bán: nhà xe, lịch trình, xe + ảnh, sơ đồ chỗ + giá, chính sách hủy. */
  @Get(":tripId")
  @ApiParam({ name: "tripId", type: String, format: "uuid" })
  @ApiQuery({ name: "pickupSequence", required: false, type: Number, minimum: 1 })
  @ApiQuery({ name: "dropoffSequence", required: false, type: Number, minimum: 1 })
  @ZodResponse({ status: 200, description: "Chi tiết chuyến.", type: PublicTripDto })
  @ApiResponse({ status: 404, description: "`TRIP_NOT_FOUND` (không tồn tại hoặc không hiển thị).", content: problemContent })
  get(@Param("tripId", new ParseUUIDPipe()) tripId: string, @Query() query: PublicTripQueryDto): Promise<PublicTrip> {
    return this.trips.getTrip(tripId, query);
  }
}
