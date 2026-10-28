import type { CounterBooking, CounterBookingInput, CounterHold, CounterHoldInput, CounterReceiptInput, CounterReceiptResult, CounterReport, CounterTrip } from "@vexenhanh/types";

import { apiRequest } from "../auth/api-client";

export type { CounterBooking, CounterHold, CounterTrip } from "@vexenhanh/types";

/** Tải chuyến còn bán quầy theo văn phòng và ngày chạy tại Việt Nam. */
export async function listCounterTrips(officeId: string, date: string): Promise<CounterTrip[]> {
  return (await apiRequest<{ items: CounterTrip[] }>(`/operator/counter/trips?${new URLSearchParams({ officeId, date })}`)).items;
}

/** Giữ một lô ghế bằng danh tính người bán và văn phòng đang làm việc. */
export function createCounterHold(input: CounterHoldInput): Promise<CounterHold> {
  return apiRequest<CounterHold>("/operator/counter/holds", { method: "POST", body: input });
}

/** Bỏ phiên giữ ghế khi quay lại chọn chuyến hoặc chỗ khác. */
export function releaseCounterHold(holdId: string): Promise<void> {
  return apiRequest<void>(`/operator/counter/holds/${holdId}`, { method: "DELETE" });
}

/** Tạo đơn quầy từ phiên giữ ghế còn hạn của người bán. */
export function createCounterBooking(input: CounterBookingInput): Promise<CounterBooking> {
  return apiRequest<CounterBooking>("/operator/counter/bookings", { method: "POST", body: input });
}

/** Tải đơn quầy cùng khoản thu và vé để kiểm tra hoặc in lại. */
export function getCounterBooking(bookingId: string): Promise<CounterBooking> {
  return apiRequest<CounterBooking>(`/operator/counter/bookings/${bookingId}`);
}

/** Tải các đơn quầy trong văn phòng đang chọn. */
export async function listCounterBookings(officeId: string): Promise<CounterBooking[]> {
  return (await apiRequest<{ items: CounterBooking[] }>(`/operator/counter/bookings?${new URLSearchParams({ officeId })}`)).items;
}

/** Xác nhận tiền thực nhận với mã thao tác cố định để thử lại an toàn. */
export function confirmCounterReceipt(bookingId: string, input: CounterReceiptInput): Promise<CounterReceiptResult> {
  return apiRequest<CounterReceiptResult>(`/operator/counter/bookings/${bookingId}/receipts`, { method: "POST", body: input });
}

/** Đối soát khoản thu và hoa hồng theo ngày Việt Nam của văn phòng đang chọn. */
export function getCounterReport(officeId: string, date: string): Promise<CounterReport> {
  return apiRequest<CounterReport>(`/operator/counter/report?${new URLSearchParams({ officeId, date })}`);
}
