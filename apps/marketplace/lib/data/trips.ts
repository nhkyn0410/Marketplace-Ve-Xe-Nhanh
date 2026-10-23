import { DataResult, unavailable } from "./result";
import {
  TripDetailData,
  TripSearchFacets,
  TripSearchResultItem,
  TripSearchSummary
} from "./types";

/**
 * Tham số tìm kiếm chuyến xe.
 */
export interface SearchTripsParams {
  readonly origin?: string;
  readonly destination?: string;
  readonly date?: string;
  readonly passengers?: number;
  readonly timeRange?: string;
  readonly minPriceVnd?: string;
  readonly maxPriceVnd?: string;
  readonly seatType?: string;
  readonly vehicleType?: string;
  readonly operatorId?: string;
  readonly sortBy?: "earliest" | "price_asc" | "rating_desc" | "fastest";
}

/**
 * Kết quả tìm kiếm chuyến xe từ server API.
 * Endpoint: GET /trips/search (chưa có trong hợp đồng API).
 */
export async function searchTrips(
  _params?: SearchTripsParams
): Promise<
  DataResult<{
    readonly summary: TripSearchSummary;
    readonly facets: TripSearchFacets;
    readonly trips: readonly TripSearchResultItem[];
  }>
> {
  return Promise.resolve(unavailable("GET /trips/search"));
}

/**
 * Lấy thông tin chi tiết một chuyến xe.
 * Endpoint: GET /trips/{tripId} (chưa có trong hợp đồng API).
 */
export async function getTripDetails(
  tripId: string
): Promise<DataResult<TripDetailData>> {
  return Promise.resolve(unavailable(`GET /trips/${tripId}`));
}

