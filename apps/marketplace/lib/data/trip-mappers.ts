import type { components } from "@vexenhanh/api-client";
import type { TripDetailData, TripSearchResultItem } from "./types";
import { formatDateVi, formatTimeVi } from "../format";

/** Bộ lọc tìm chuyến được chuyển sang query của API công khai. */
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
  readonly sortBy?: "earliest" | "price_asc" | "fastest";
  readonly page?: string;
}

/** Kiểm tra số nguyên an toàn tại biên API và chuyển tiền sang chuỗi VND. */
export function apiMoney(value: number): string {
  if (!Number.isSafeInteger(value) || value < 0) throw new Error("Invalid VND integer");
  return BigInt(value).toString();
}

/** Tạo query tìm chuyến, giữ giá dưới dạng chuỗi và ngày theo giờ Việt Nam. */
export function searchQuery(params: SearchTripsParams): URLSearchParams {
  const date = new Intl.DateTimeFormat("en-CA", { timeZone: "Asia/Ho_Chi_Minh" }).format(new Date());
  const query = new URLSearchParams({ date: params.date || date, passengers: String(params.passengers ?? 1) });
  const forms: Record<string, string> = { seat: "SEATER", sleeper: "SLEEPER", cabin: "CABIN" };
  const values = {
    fromProvinceId: params.origin, toProvinceId: params.destination,
    operatorId: params.operatorId, priceMin: params.minPriceVnd, priceMax: params.maxPriceVnd,
    vehicleForm: params.seatType ? forms[params.seatType] : undefined,
    vehicleClass: params.vehicleType?.toUpperCase(), page: params.page,
    sort: params.sortBy === "price_asc" ? "price" : params.sortBy === "fastest" ? "duration" : "departure"
  };
  for (const [key, value] of Object.entries(values)) if (value) query.set(key, value);
  if (params.timeRange) {
    const [from, to] = params.timeRange.split("-");
    query.set("departureFrom", `${from}:00`);
    query.set("departureTo", to === "24" ? "23:59" : `${to}:00`);
  }
  return query;
}

const formNames = { SEATER: "Ghế ngồi", SLEEPER: "Giường nằm", CABIN: "Cabin" };
const duration = (minutes: number) => `${Math.floor(minutes / 60)} giờ ${minutes % 60} phút`;
const nextDay = (start: string, end: string) => formatDateVi(start) !== formatDateVi(end);

/** Chuyển chuyến tìm được thành thẻ kết quả, không tự tạo đánh giá hay ảnh xe. */
export function mapTripSearchItem(item: components["schemas"]["TripSearchResponseDto_Output"]["items"][number]): TripSearchResultItem {
  return {
    id: item.tripId, operatorId: item.operator.id, operatorName: item.operator.name,
    operatorCode: item.operator.name.slice(0, 2).toUpperCase(), operatorRating: 0,
    operatorRatingCountText: "Chưa có dữ liệu đánh giá", vehicleType: item.vehicleType.name,
    seatType: formNames[item.vehicleType.form], departureTime: formatTimeVi(item.pickup.plannedAt),
    departureCity: item.pickup.name, departureStation: item.pickup.name,
    arrivalTime: formatTimeVi(item.dropoff.plannedAt), arrivalCity: item.dropoff.name,
    arrivalStation: item.dropoff.name, durationText: duration(item.durationMinutes), stopCountText: "",
    isNextDay: nextDay(item.pickup.plannedAt, item.dropoff.plannedAt), priceVnd: apiMoney(item.minPrice),
    availableSeats: item.availableSeats, amenities: item.amenities.map((a) => a.name),
    imageUrl: item.vehicleCoverImageUrl ?? ""
  };
}

/** Chuyển chi tiết chuyến công khai thành dữ liệu màn hình khách hàng. */
export function mapTripDetail(trip: components["schemas"]["PublicTripDto_Output"]): TripDetailData {
  const stops = [...trip.stops].sort((a, b) => a.sequence - b.sequence);
  const prices = trip.seats.flatMap((s) => s.status === "AVAILABLE" && s.price !== null ? [BigInt(apiMoney(s.price))] : []);
  const doublePrices = trip.seats.flatMap((s) => s.status === "AVAILABLE" && s.type.endsWith("DOUBLE") && s.price !== null ? [BigInt(apiMoney(s.price))] : []);
  const min = (values: bigint[]) => values.length ? values.reduce((a, b) => a < b ? a : b).toString() : "";
  return {
    id: trip.tripId, operatorId: trip.operator.id, operatorName: trip.operator.name,
    operatorCode: trip.operator.name.slice(0, 2).toUpperCase(), operatorRating: 0,
    operatorRatingCountText: "Chưa có dữ liệu đánh giá", operatorPhone: trip.operator.hotline ?? "",
    operatorEmail: "", operatorDescription: "", vehicleTypeName: trip.vehicleType.name,
    seatTypeName: formNames[trip.vehicleType.form], vehicleClass: trip.vehicleType.class === "LIMOUSINE" ? "Limousine" : "Tiêu chuẩn",
    statusBadge: "", routeName: trip.routeName, routeMeta: formatDateVi(trip.departureAt),
    departureTime: formatTimeVi(trip.departureAt), departureStation: stops[0]?.name ?? "",
    durationText: duration(Math.round((Date.parse(trip.arrivalAt) - Date.parse(trip.departureAt)) / 60000)),
    stopsSummaryText: `${stops.length} điểm dừng`, arrivalTime: formatTimeVi(trip.arrivalAt),
    arrivalStation: stops.at(-1)?.name ?? "", isNextDay: nextDay(trip.departureAt, trip.arrivalAt),
    photos: trip.vehicleImages.map((i) => ({ url: i.url, caption: i.caption ?? "" })),
    photosCaption: "Ảnh xe từ nhà xe", remainingPhotosCount: Math.max(0, trip.vehicleImages.length - 5),
    amenities: trip.amenities.map((a) => a.name),
    timeline: stops.map((s) => ({ time: formatTimeVi(s.plannedAt), stationName: s.name, address: s.address,
      stationType: s.type === "REST_STOP" ? "rest_stop" : s.type === "BUS_STATION" ? "bus_station" : "office",
      stationTypeLabel: s.type === "REST_STOP" ? "Điểm nghỉ" : s.type === "BUS_STATION" ? "Bến xe" : s.type === "OFFICE" ? "Văn phòng" : "Điểm dừng",
      isRestStop: s.type === "REST_STOP", badges: [s.allowPickup ? "Đón khách" : "", s.allowDropoff ? "Trả khách" : ""].filter(Boolean), lat: s.latitude, lng: s.longitude })),
    seatMap: trip.seats.map((s) => ({ id: s.code, label: s.code, floor: s.deck === 2 ? 2 : 1,
      row: s.row, col: s.column, status: s.status === "AVAILABLE" ? "available" : "unavailable",
      isDouble: s.type.endsWith("DOUBLE") })),
    totalSeats: trip.seats.length, availableSeats: trip.seats.filter((s) => s.status === "AVAILABLE" && s.price !== null).length,
    priceSingleVnd: min(prices), priceDoubleVnd: min(doublePrices),
    stopSalesTimeText: `${formatTimeVi(trip.onlineSaleClosesAt)} ${formatDateVi(trip.onlineSaleClosesAt)}`,
    cancellationPolicies: trip.cancellationPolicy.tiers.map((t) => ({ condition: `Trước giờ đi ít nhất ${t.minHoursBefore} giờ`, refundPercentText: `${t.refundPercent}%` })),
    cancellationNote: trip.note ?? "Xem báo giá hoàn tiền trước khi xác nhận hủy.",
    reviewsAverage: 0, reviewsCountText: "Xem đánh giá trên trang nhà xe", reviews: []
  };
}
