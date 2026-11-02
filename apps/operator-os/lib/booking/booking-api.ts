// Gọi API Đặt vé cho Operator OS (05 API §7.3 `/operator/bookings`, TASK-OPR-003). Kiểu lấy từ client sinh tự OpenAPI.
import type { components } from "@vexenhanh/api-client";

import { API_BASE_URL, ApiError, apiRequest, refreshSession } from "../auth/api-client";

type Schemas = components["schemas"];

export type OperatorBookingPage = Schemas["OperatorBookingPageDto_Output"];
export type OperatorBooking = OperatorBookingPage["items"][number];
export type OperatorBookingDetail = Schemas["OperatorBookingDetailDto_Output"];
export type BookingContact = Schemas["BookingContactDto_Output"];
export type TripPassengerList = Schemas["TripPassengerListDto_Output"];
export type TripPassenger = TripPassengerList["items"][number];
export type BookingStatus = OperatorBooking["status"];
export type TicketStatus = TripPassenger["ticketStatus"];
export type PaymentStatus = NonNullable<OperatorBooking["payment"]>["status"];

/** Số đơn mỗi lần tải (Figma "Tải thêm"). */
export const BOOKING_PAGE_SIZE = 20;

export type BookingListParams = { date: string; tripId?: string; status?: BookingStatus; q?: string; cursor?: string };

/** Một trang đơn của các chuyến khởi hành trong ngày `date` (giờ VN), mới đặt trước. */
export function listBookings(params: BookingListParams): Promise<OperatorBookingPage> {
  const query = new URLSearchParams({ limit: String(BOOKING_PAGE_SIZE) });
  for (const [key, value] of Object.entries(params)) {
    if (value) {
      query.set(key, value);
    }
  }
  return apiRequest<OperatorBookingPage>(`/operator/bookings?${query}`);
}

export function getBooking(bookingId: string): Promise<OperatorBookingDetail> {
  return apiRequest<OperatorBookingDetail>(`/operator/bookings/${bookingId}`);
}

/** Liên hệ đầy đủ — máy chủ ghi nhật ký mỗi lần xem. */
export function revealContact(bookingId: string): Promise<BookingContact> {
  return apiRequest<BookingContact>(`/operator/bookings/${bookingId}/contact-reveal`, { method: "POST" });
}

export type PassengerListParams = { pickupSequence?: number; ticketStatus?: TicketStatus; q?: string };

export function listTripPassengers(tripId: string, params: PassengerListParams): Promise<TripPassengerList> {
  const query = new URLSearchParams();
  for (const [key, value] of Object.entries(params)) {
    if (value !== undefined && value !== "") {
      query.set(key, String(value));
    }
  }
  return apiRequest<TripPassengerList>(`/operator/trips/${tripId}/passengers?${query}`);
}

/**
 * Tải danh sách hành khách dạng CSV (máy chủ ghi nhật ký). Không đi qua `apiRequest` vì body là tệp, không phải JSON:
 * hết phiên thì làm mới một lần rồi thử lại như `apiRequest`.
 */
export async function downloadPassengerCsv(tripId: string): Promise<void> {
  const send = () => fetch(`${API_BASE_URL}/operator/trips/${tripId}/passengers/export`, { credentials: "include", cache: "no-store" });
  let response = await send();
  if (response.status === 401 && (await refreshSession()) === "ok") {
    response = await send();
  }
  if (!response.ok) {
    const body = (await response.json().catch(() => ({}))) as { code?: string; detail?: string };
    throw new ApiError(response.status, body.code ?? "UNKNOWN_ERROR", body.detail ?? "Chưa xuất được danh sách. Vui lòng thử lại.");
  }
  const filename = /filename="([^"]+)"/.exec(response.headers.get("content-disposition") ?? "")?.[1] ?? "hanh-khach.csv";
  const url = URL.createObjectURL(await response.blob());
  const link = document.createElement("a");
  link.href = url;
  link.download = filename;
  link.click();
  URL.revokeObjectURL(url);
}
