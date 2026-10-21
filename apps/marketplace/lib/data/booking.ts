"use server";

import type { components } from "@vexenhanh/api-client";
import QRCode from "qrcode";
import { cookies } from "next/headers";
import { apiRequest, ACCESS_COOKIE } from "./api";
import { getAccountProfile } from "./auth";
import { refreshSessionIfNeeded } from "./session";
import { bookingHeaders, rememberBooking, rememberedBooking } from "./booking-access";
import { apiMoney, mapPayment, mapPaymentResult, mapPoint, mapSeatSelection, moneyString, remainingSeconds, seatTypeLabel, type ApiBooking, type ApiHold, type ApiTrip } from "./booking-mappers";
import { type DataResult, failed, ok } from "./result";
import type { BookingPaymentData, BookingPaymentResultData, CheckoutContactInfo, CheckoutHoldData, CheckoutPassengerItem, TripSeatSelectionData } from "./types";

/** Lấy điểm dừng và trạng thái chỗ từ chi tiết chuyến công khai. */
export async function getTripSeatSelection(tripId: string): Promise<DataResult<TripSeatSelectionData>> {
  const result = await apiRequest<ApiTrip>(`/trips/${encodeURIComponent(tripId)}`);
  if (result.status !== "ok") return result;
  try { return ok(mapSeatSelection(result.data)); }
  catch { return failed("GET /trips/{tripId}", "Dữ liệu giá vé không hợp lệ."); }
}

/** Giữ chỗ với đúng điểm đón và trả đã chọn, để máy chủ xác nhận giá và ghế. */
export async function holdSeats(tripId: string, seatCodes: readonly string[], pickupSequence: number, dropoffSequence: number): Promise<DataResult<{ readonly holdId: string }>> {
  const session = await refreshSessionIfNeeded();
  if (session.status !== "ok") return session;
  if (seatCodes.length === 0 || seatCodes.length > 10 || new Set(seatCodes).size !== seatCodes.length || !Number.isSafeInteger(pickupSequence) || !Number.isSafeInteger(dropoffSequence) || pickupSequence < 1 || pickupSequence >= dropoffSequence) {
    return failed("POST /seat-holds", "Vui lòng chọn 1–10 chỗ và điểm trả sau điểm đón.");
  }
  const input: components["schemas"]["SeatHoldInputDto"] = { tripId, seatCodes: [...seatCodes], pickupSequence, dropoffSequence };
  const result = await apiRequest<ApiHold>("/seat-holds", { method: "POST", body: JSON.stringify(input) });
  return result.status === "ok" ? ok({ holdId: result.data.holdId }) : result;
}

/** Lấy giá giữ chỗ từ máy chủ và bổ sung tên chuyến, địa chỉ từ API công khai. */
export async function getCheckoutHoldData(holdId: string): Promise<DataResult<CheckoutHoldData>> {
  const hold = await apiRequest<ApiHold>(`/seat-holds/${encodeURIComponent(holdId)}`);
  if (hold.status !== "ok") return hold;
  const [trip, profile] = await Promise.all([
    apiRequest<ApiTrip>(`/trips/${hold.data.tripId}`),
    (await cookies()).get(ACCESS_COOKIE)?.value ? getAccountProfile() : Promise.resolve(null)
  ]);
  if (trip.status !== "ok") return trip;
  try {
    const subtotal = moneyString(hold.data.subtotal);
    const account = profile?.status === "ok" ? profile.data : null;
    const savedPassengers = account?.savedPassengers?.map((passenger) => ({ id: passenger.id, fullName: passenger.name, phoneNumber: passenger.phone, idNumber: "" })) ?? [];
    return ok({ holdId: hold.data.holdId, tripId: hold.data.tripId, routeName: trip.data.routeName, departureTimeText: mapSeatSelection(trip.data).departureTimeText, operatorName: trip.data.operator.name, holdCountdownSeconds: remainingSeconds(hold.data.expiresAt), pickupPoint: mapPoint({ ...hold.data.pickup, address: trip.data.stops.find((s) => s.sequence === hold.data.pickup.sequence)?.address ?? "" }), dropoffPoint: mapPoint({ ...hold.data.dropoff, address: trip.data.stops.find((s) => s.sequence === hold.data.dropoff.sequence)?.address ?? "" }), contactInfo: { fullName: account?.fullName ?? "", phoneNumber: account?.phone ?? "", email: account?.email ?? "" }, savedPassengers, maxSavedPassengers: 0, currentSavedPassengersCount: savedPassengers.length, passengers: hold.data.seats.map((seat) => ({ seatCode: seat.code, seatTypeLabel: seatTypeLabel(seat.type), floorLabel: "", priceVnd: moneyString(seat.price), fullName: "", phoneNumber: "", idNumber: "", shouldSaveForLater: false })), vouchers: [], priceSummary: { isEstimate: true, ticketPriceTotalVnd: subtotal, ticketCount: hold.data.seats.length, serviceFeeVnd: "0", discountVnd: "0", discountLabel: "Ưu đãi", finalTotalVnd: subtotal } });
  } catch { return failed("GET /seat-holds/{holdId}", "Dữ liệu giá giữ chỗ không hợp lệ."); }
}

/** Tạo booking bằng giá giữ chỗ đọc lại ở máy chủ; lưu token khách trong cookie httpOnly. */
export async function createBooking(holdId: string, payload: { readonly contactInfo: CheckoutContactInfo; readonly passengers: readonly CheckoutPassengerItem[]; readonly note: string }): Promise<DataResult<{ readonly bookingId: string }>> {
  const session = await refreshSessionIfNeeded();
  if (session.status !== "ok") return session;
  const existingId = await rememberedBooking(holdId);
  if (existingId) return ok({ bookingId: existingId });
  if (!payload.contactInfo.fullName.trim() || !payload.contactInfo.email.trim() || !payload.contactInfo.phoneNumber.trim() || payload.passengers.some((passenger) => !passenger.fullName.trim())) {
    return failed("POST /bookings", "Vui lòng nhập thông tin liên hệ và tên từng hành khách.");
  }
  const hold = await apiRequest<ApiHold>(`/seat-holds/${encodeURIComponent(holdId)}`);
  if (hold.status !== "ok") return hold;
  try {
    const input: components["schemas"]["BookingInputDto"] = { holdId, contact: { fullName: payload.contactInfo.fullName.trim(), phone: payload.contactInfo.phoneNumber.trim(), email: payload.contactInfo.email.trim() }, passengers: payload.passengers.map((passenger) => ({ seatCode: passenger.seatCode, fullName: passenger.fullName.trim(), phone: passenger.phoneNumber.trim() || null })), note: payload.note.trim() || null, expectedTotal: apiMoney(moneyString(hold.data.subtotal)) };
    const result = await apiRequest<components["schemas"]["CreatedBookingDto_Output"]>("/bookings", { method: "POST", body: JSON.stringify(input) });
    if (result.status !== "ok") return result;
    await rememberBooking(holdId, result.data.bookingId, result.data.accessToken);
    return ok({ bookingId: result.data.bookingId });
  } catch { return failed("POST /bookings", "Không thể tạo đơn. Vui lòng kiểm tra phiên giữ chỗ và thử lại."); }
}

/** Đọc booking với quyền truy cập của tài khoản hoặc cookie khách vãng lai. */
export async function getBookingPaymentData(bookingId: string): Promise<DataResult<BookingPaymentData>> {
  const result = await apiRequest<ApiBooking>(`/bookings/${encodeURIComponent(bookingId)}`, { headers: await bookingHeaders(bookingId) });
  if (result.status !== "ok") return result;
  try { return ok(mapPayment(result.data)); }
  catch { return failed("GET /bookings/{bookingId}", "Dữ liệu thanh toán không hợp lệ."); }
}

/** Tạo giao dịch bằng nhà cung cấp được API hỗ trợ và trả liên kết cổng thanh toán. */
export async function createPayment(bookingId: string, paymentMethod: string): Promise<DataResult<{ readonly paymentUrl: string }>> {
  const session = await refreshSessionIfNeeded();
  if (session.status !== "ok") return session;
  if (paymentMethod !== "vnpay" && paymentMethod !== "momo") return failed("POST /bookings/{bookingId}/payments", "Phương thức thanh toán không hợp lệ.");
  const result = await apiRequest<components["schemas"]["PaymentResponseDto_Output"]>(`/bookings/${encodeURIComponent(bookingId)}/payments`, { method: "POST", headers: await bookingHeaders(bookingId), body: JSON.stringify({ provider: paymentMethod === "momo" ? "MOMO" : "VNPAY" } satisfies components["schemas"]["PaymentInputDto"]) });
  if (result.status !== "ok") return result;
  try {
    const url = new URL(result.data.paymentUrl);
    if (url.protocol !== "https:" && !(process.env.NODE_ENV !== "production" && url.protocol === "http:" && ["localhost", "127.0.0.1"].includes(url.hostname))) throw new Error();
    return ok({ paymentUrl: url.toString() });
  } catch { return failed("POST /bookings/{bookingId}/payments", "Cổng thanh toán trả về liên kết không hợp lệ."); }
}

/** Lấy kết quả từ booking; tham số trên URL cổng thanh toán không được dùng xác nhận thành công. */
export async function getBookingPaymentResult(bookingId: string): Promise<DataResult<BookingPaymentResultData>> {
  const result = await apiRequest<ApiBooking>(`/bookings/${encodeURIComponent(bookingId)}`, { headers: await bookingHeaders(bookingId) });
  if (result.status !== "ok") return result;
  try {
    const mapped = mapPaymentResult(result.data);
    const tickets = await Promise.all((mapped.tickets ?? []).map(async (ticket) => ({ ...ticket, qrCodeDataUrl: await QRCode.toDataURL(result.data.tickets.find((t) => t.ticketId === ticket.ticketId)!.qrToken) })));
    return ok({ ...mapped, tickets });
  } catch { return failed("GET /bookings/{bookingId}", "Không thể đọc kết quả thanh toán."); }
}
