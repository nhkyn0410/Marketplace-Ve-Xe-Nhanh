// Gọi API giám sát của Admin (05 API §7.5 `/admin/routes`, `/admin/trips`, `/admin/operators/{id}`, `/admin/passengers/{id}`;
// tự thiết kế 28/10/2026, chờ duyệt). Kiểu lấy từ client sinh từ OpenAPI.
import type { components } from "@vexenhanh/api-client";
import { apiRequest } from "@vexenhanh/ui/lib/auth/api-client";

type Schemas = components["schemas"];

export type RoutePage = Schemas["AdminRoutePageDto_Output"];
export type AdminRoute = RoutePage["items"][number];
export type RouteSort = "sold" | "revenue" | "trips" | "fill" | "name";
export type RouteDetail = Schemas["AdminRouteDetailDto_Output"];
export type TripPage = Schemas["AdminTripPageDto_Output"];
export type AdminTrip = TripPage["items"][number];
export type TripStatus = AdminTrip["status"];
export type TripDetail = Schemas["AdminTripDetailDto_Output"];
export type OperatorDetail = Schemas["AdminOperatorDetailDto_Output"];
export type OperatorVehicle = Schemas["AdminOperatorVehicleListDto_Output"]["items"][number];
export type PassengerDetail = Schemas["AdminPassengerDetailDto_Output"];
export type PassengerBookingPage = Schemas["AdminPassengerBookingPageDto_Output"];
export type PassengerBooking = PassengerBookingPage["items"][number];

function query(params: Record<string, string | number | null | undefined>): string {
  const search = new URLSearchParams();
  for (const [key, value] of Object.entries(params)) {
    if (value !== null && value !== undefined && value !== "") {
      search.set(key, String(value));
    }
  }
  return search.toString();
}

export type RouteFilters = {
  q?: string;
  operatorId?: string;
  status?: string;
  originProvinceId?: string;
  destinationProvinceId?: string;
  from?: string;
  to?: string;
  sort?: RouteSort;
};

export function listRoutes(filters: RouteFilters, cursor: string | null): Promise<RoutePage> {
  return apiRequest<RoutePage>(`/admin/routes?${query({ ...filters, cursor, limit: 20 })}`);
}

export function getRoute(id: string, period?: { from: string; to: string }): Promise<RouteDetail> {
  return apiRequest<RouteDetail>(`/admin/routes/${id}?${query({ ...period })}`);
}

export type TripFilters = { from?: string; to?: string; operatorId?: string; routeId?: string; status?: string; q?: string };

export function listTrips(filters: TripFilters, cursor: string | null): Promise<TripPage> {
  return apiRequest<TripPage>(`/admin/trips?${query({ ...filters, cursor, limit: 20 })}`);
}

/** Mỗi lần gọi được ghi nhật ký lượt xem (danh sách người đi). */
export function getTrip(id: string): Promise<TripDetail> {
  return apiRequest<TripDetail>(`/admin/trips/${id}`);
}

export function getOperator(id: string): Promise<OperatorDetail> {
  return apiRequest<OperatorDetail>(`/admin/operators/${id}`);
}

export function listOperatorVehicles(id: string): Promise<OperatorVehicle[]> {
  return apiRequest<Schemas["AdminOperatorVehicleListDto_Output"]>(`/admin/operators/${id}/vehicles`).then((list) => list.items);
}

/** Mỗi lần gọi được ghi nhật ký lượt xem (dữ liệu cá nhân). */
export function getPassenger(id: string): Promise<PassengerDetail> {
  return apiRequest<PassengerDetail>(`/admin/passengers/${encodeURIComponent(id)}`);
}

export function listPassengerBookings(id: string, cursor: string | null): Promise<PassengerBookingPage> {
  return apiRequest<PassengerBookingPage>(`/admin/passengers/${encodeURIComponent(id)}/bookings?${query({ cursor, limit: 20 })}`);
}
