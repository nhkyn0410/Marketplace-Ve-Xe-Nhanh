"use server";

import type { components } from "@vexenhanh/api-client";
import { apiRequest } from "./api";
import { ok, failed, type DataResult } from "./result";
import { mapTripDetail, mapTripSearchItem, searchQuery, type SearchTripsParams } from "./trip-mappers";
import type { TripDetailData, TripSearchResultItem, TripSearchSummary } from "./types";

export type { SearchTripsParams } from "./trip-mappers";

/** Tìm chuyến mở bán bằng bộ lọc trong hợp đồng API hiện tại. */
export async function searchTrips(params: SearchTripsParams = {}): Promise<DataResult<{
  readonly summary: TripSearchSummary;
  readonly trips: readonly TripSearchResultItem[];
  readonly pagination: { readonly page: number; readonly limit: number };
}>> {
  const query = searchQuery(params);
  const result = await apiRequest<components["schemas"]["TripSearchResponseDto_Output"]>(`/trips/search?${query}`);
  if (result.status !== "ok") return result;
  try {
    return ok({ summary: {
      originCity: result.data.items[0]?.pickup.name ?? "Điểm đi",
      destinationCity: result.data.items[0]?.dropoff.name ?? "Điểm đến",
      departureDateText: query.get("date") ?? "",
      departureDateShortText: (query.get("date") ?? "").split("-").reverse().join("/"),
      passengerCount: params.passengers ?? 1,
      totalTrips: result.data.total
    }, trips: result.data.items.map(mapTripSearchItem), pagination: { page: result.data.page, limit: result.data.limit } });
  } catch {
    return failed("GET /trips/search", "Giá vé từ hệ thống không hợp lệ.");
  }
}

/** Lấy lịch trình, giá ghế và chính sách hủy thật của chuyến xe. */
export async function getTripDetails(tripId: string): Promise<DataResult<TripDetailData>> {
  const result = await apiRequest<components["schemas"]["PublicTripDto_Output"]>(`/trips/${encodeURIComponent(tripId)}`);
  if (result.status !== "ok") return result;
  try {
    const trip = mapTripDetail(result.data);
    const operator = await apiRequest<components["schemas"]["PublicOperatorProfileDto_Output"]>(`/operators/${encodeURIComponent(result.data.operator.id)}/public-profile`);
    if (operator.status !== "ok") return ok(trip);
    return ok({ ...trip, operatorRating: operator.data.scorecard.averageRating ?? 0,
      operatorRatingCountText: `${operator.data.scorecard.reviewCount} đánh giá`, operatorEmail: operator.data.publicEmail ?? "",
      operatorDescription: operator.data.description ?? "", reviewsAverage: operator.data.scorecard.averageRating ?? 0,
      reviewsCountText: `${operator.data.scorecard.reviewCount} đánh giá nhà xe`,
      reviews: operator.data.reviews.map((r) => ({ id: r.reviewId, authorName: r.authorName, authorInitial: r.authorName.slice(0, 1),
        rating: r.rating, travelDateText: "", content: r.comment ?? "" })) });
  }
  catch { return failed("GET /trips/{tripId}", "Giá vé từ hệ thống không hợp lệ."); }
}
