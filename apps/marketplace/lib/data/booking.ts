// Tạm — chưa có hợp đồng API (05 API §7.2)
import { DataResult, unavailable } from "./result";
import {
  BookingPaymentData,
  BookingPaymentResultData,
  CheckoutHoldData,
  TripSeatSelectionData
} from "./types";

/**
 * Lấy dữ liệu điểm đón/trả và sơ đồ ghế cho một chuyến xe (SCR-PSG-18).
 * Do backend chưa cung cấp API endpoint lấy sơ đồ ghế và điểm dừng, hàm này trả về unavailable.
 */
export async function getTripSeatSelection(
  tripId: string
): Promise<DataResult<TripSeatSelectionData>> {
  return unavailable(`GET /trips/${tripId}/seats`);
}

/**
 * Giữ chỗ ghế cho khách (Endpoint POST /seat-holds theo Bảng A2 - ❌ chưa code).
 */
export async function holdSeats(
  tripId: string,
  seatCodes: readonly string[]
): Promise<DataResult<{ readonly holdId: string }>> {
  void tripId;
  void seatCodes;
  return unavailable("POST /seat-holds");
}

/**
 * Lấy thông tin lượt giữ chỗ và danh sách hành khách cần nhập (SCR-PSG-19).
 */
export async function getCheckoutHoldData(
  holdId: string
): Promise<DataResult<CheckoutHoldData>> {
  return unavailable(`GET /seat-holds/${holdId}`);
}

/**
 * Tạo đơn đặt vé mới (Endpoint POST /bookings theo Bảng A2 - ❌ chưa code).
 */
export async function createBooking(
  holdId: string,
  payload?: unknown
): Promise<DataResult<{ readonly bookingId: string }>> {
  void holdId;
  void payload;
  return unavailable("POST /bookings");
}

/**
 * Lấy thông tin đơn hàng chờ thanh toán B3 (SCR-PSG-20 - GET /bookings/{bookingId}).
 */
export async function getBookingPaymentData(
  bookingId: string
): Promise<DataResult<BookingPaymentData>> {
  return unavailable(`GET /bookings/${bookingId}`);
}

/**
 * Khởi tạo giao dịch thanh toán vé (Endpoint POST /bookings/{bookingId}/payments theo Bảng A2 - ❌ chưa code).
 */
export async function createPayment(
  bookingId: string,
  paymentMethod: string
): Promise<DataResult<{ readonly paymentUrl: string }>> {
  void bookingId;
  void paymentMethod;
  return unavailable(`POST /bookings/${bookingId}/payments`);
}

/**
 * Lấy kết quả thanh toán vé (SCR-PSG-21, 22, 23 - GET /bookings/{bookingId}/payment-result).
 */
export async function getBookingPaymentResult(
  bookingId: string
): Promise<DataResult<BookingPaymentResultData>> {
  return unavailable(`GET /bookings/${bookingId}/payment-result`);
}
