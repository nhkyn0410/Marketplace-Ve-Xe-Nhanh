import type { components } from "@vexenhanh/api-client";
import { formatTripDateVi } from "../format";
import type {
  BookingPaymentData, BookingPaymentResultData, CheckoutPassengerItem,
  CheckoutPriceSummary, MyTicketItem, SeatLocationPoint, SeatSelectionItem, TicketDetailData,
  TicketLookupBookingItem, TicketLookupBookingsData, TicketLookupResultData, TripSeatSelectionData
} from "./types";

/** Kiểu booking theo hợp đồng OpenAPI đã sinh. */
export type ApiBooking = components["schemas"]["BookingResponseDto_Output"];
/** Kiểu chuyến công khai theo hợp đồng OpenAPI đã sinh. */
export type ApiTrip = components["schemas"]["PublicTripDto_Output"];
/** Kiểu giữ chỗ theo hợp đồng OpenAPI đã sinh. */
export type ApiHold = components["schemas"]["SeatHoldResponseDto_Output"];

/** Chuyển tiền số nguyên của API sang chuỗi; từ chối số mất độ chính xác. */
export function moneyString(value: number): string {
  if (!Number.isSafeInteger(value) || value < 0) throw new Error("Số tiền API không hợp lệ.");
  return BigInt(value).toString();
}

/** Chuyển chuỗi VND sang kiểu số nguyên mà hợp đồng API hiện tại yêu cầu. */
export function apiMoney(value: string): number {
  if (!/^\d+$/.test(value) || BigInt(value) > BigInt(Number.MAX_SAFE_INTEGER)) {
    throw new Error("Số tiền vượt giới hạn hợp đồng API.");
  }
  return Number(value);
}

/** Định dạng thời gian theo múi giờ Việt Nam. */
export function dateText(value: string, options: Intl.DateTimeFormatOptions = {}): string {
  return new Intl.DateTimeFormat("vi-VN", { timeZone: "Asia/Ho_Chi_Minh", ...options }).format(new Date(value));
}

/** Lấy số giây còn lại của thời hạn do máy chủ cung cấp. */
export function remainingSeconds(expiresAt: string): number {
  return Math.max(0, Math.floor((Date.parse(expiresAt) - Date.now()) / 1000));
}

/** Hiển thị tên loại chỗ theo mã trong API. */
export function seatTypeLabel(type: string): string {
  return ({ SEAT: "Ghế ngồi", BED: "Giường nằm", BED_DOUBLE: "Giường đôi", CABIN: "Cabin", CABIN_DOUBLE: "Cabin đôi" } as Record<string, string>)[type] ?? type;
}

/** Chỗ đôi (giường đôi / cabin đôi) — được khai người đi cùng (BR-78). */
export function isDoubleSeat(type: string): boolean {
  return type === "BED_DOUBLE" || type === "CABIN_DOUBLE";
}

/** Tên trên vé: người đứng tên, kèm người đi cùng nếu chỗ đôi có khai ("A và B"). */
export function ticketPassengerName(passengerName: string, companionName: string | null | undefined): string {
  return companionName ? `${passengerName} và ${companionName}` : passengerName;
}

/** Chuyển điểm dừng của API sang dữ liệu hiển thị. */
export function mapPoint(point: { sequence: number; name: string; plannedAt: string; address?: string }): SeatLocationPoint {
  return { id: String(point.sequence), name: point.name, address: point.address ?? "", time: dateText(point.plannedAt, { hour: "2-digit", minute: "2-digit" }), hasFreeShuttle: false, plannedAt: point.plannedAt };
}

/** Giữ nguyên bảng tiền đã chốt của booking. */
export function mapBookingPrice(booking: ApiBooking): CheckoutPriceSummary {
  return { ticketPriceTotalVnd: moneyString(booking.subtotal), ticketCount: booking.passengers.length, serviceFeeVnd: moneyString(booking.serviceFee), discountVnd: moneyString(booking.discount), discountLabel: "Ưu đãi", finalTotalVnd: moneyString(booking.total) };
}

/** Chuyển hành khách đã chốt sang dữ liệu giao diện. */
export function mapPassengers(booking: ApiBooking): CheckoutPassengerItem[] {
  return booking.passengers.map((passenger) => ({ seatCode: passenger.seatCode, seatTypeLabel: seatTypeLabel(passenger.seatType), floorLabel: "", priceVnd: moneyString(passenger.price), fullName: passenger.fullName, phoneNumber: passenger.phone ?? "", idNumber: "", shouldSaveForLater: false, isDoubleSeat: isDoubleSeat(passenger.seatType), companionName: passenger.companionName ?? "" }));
}

/** Hiển thị trạng thái booking theo dữ liệu máy chủ, kể cả các bước hoàn tiền. */
export function bookingStatusLabel(status: ApiBooking["status"]): string {
  return ({ PENDING_PAYMENT: "Chờ thanh toán", PENDING_CONFIRMATION: "Chờ xác nhận", PAID: "Đã thanh toán, chờ phát hành vé", CONFIRMED: "Đã xác nhận", PARTIALLY_CANCELLED: "Đã hủy một phần", CANCELLED: "Đã hủy", EXPIRED: "Hết hạn thanh toán", REFUND_PENDING: "Đang hoàn tiền", REFUNDED: "Đã hoàn tiền", REFUND_FAILED: "Hoàn tiền chưa thành công" })[status];
}

/** Hiển thị đúng trạng thái giao dịch, không coi mọi kết quả là đã thanh toán. */
export function paymentStatusLabel(status: NonNullable<ApiBooking["payment"]>["status"] | undefined): string {
  return status ? ({ INITIATED: "Đã khởi tạo", PROCESSING: "Đang xử lý", SUCCESS: "Đã thanh toán", FAILED: "Thanh toán thất bại", EXPIRED: "Giao dịch hết hạn", CANCELLED: "Giao dịch đã hủy", RECONCILING: "Đang đối soát" })[status] : "Chưa thanh toán";
}

/** Giữ riêng vé đã sử dụng, đã lên xe hoặc vắng mặt để tránh thao tác sai. */
export function ticketStatus(status: ApiBooking["tickets"][number]["status"]): TicketDetailData["tickets"][number]["status"] {
  return status === "USED" ? "used" : status === "CHECKED_IN" ? "checked_in" : status === "NO_SHOW" ? "no_show" : ["CANCELLED", "REFUNDED"].includes(status) ? "cancelled" : "valid";
}

/**
 * Trạng thái ghế trên sơ đồ: API gộp đã bán / đang có người giữ / nhà xe khóa thành `UNAVAILABLE` (hiện "Đã đặt");
 * chỗ chưa có giá thì không bán được ("Không bán").
 */
function seatStatus(seat: ApiTrip["seats"][number]): SeatSelectionItem["status"] {
  if (seat.price === null) return "disabled";
  return seat.status === "AVAILABLE" ? "available" : "booked";
}

/** Chuyển chỗ còn bán và điểm dừng thật sang màn chọn chỗ. */
export function mapSeatSelection(trip: ApiTrip): TripSeatSelectionData {
  const pickupPoints = trip.stops.filter((point) => point.allowPickup).map(mapPoint);
  const dropoffPoints = trip.stops.filter((point) => point.allowDropoff).map(mapPoint);
  // "19:24 • T4, 28/10/2026" như Figma; ngày lấy theo giờ VN.
  const departureDay = new Intl.DateTimeFormat("en-CA", { timeZone: "Asia/Ho_Chi_Minh" }).format(new Date(trip.departureAt));
  const departureTimeText = `${dateText(trip.departureAt, { hour: "2-digit", minute: "2-digit" })} • ${formatTripDateVi(departureDay)}`;
  return {
    tripId: trip.tripId, routeName: trip.routeName, departureTimeText, operatorName: trip.operator.name,
    pickupPoints, dropoffPoints, selectedPickupPointId: pickupPoints[0]?.id ?? "", selectedDropoffPointId: dropoffPoints.at(-1)?.id ?? "",
    seats: [...trip.seats].sort((a, b) => a.deck - b.deck || a.row - b.row || a.column - b.column).map((seat) => ({ id: seat.code, code: seat.code, label: seat.code, floor: seat.deck === 2 ? 2 : 1, row: seat.row, column: seat.column, status: seatStatus(seat), type: seat.type.endsWith("DOUBLE") ? "double" : "single", typeLabel: seatTypeLabel(seat.type), priceVnd: seat.price === null ? "0" : moneyString(seat.price) })),
    selectedSeatCodes: [], maxSeats: 10, holdCountdownSeconds: 0, selectedSeatsSummary: [], subtotalVnd: "0"
  };
}

/** Chuyển booking thật sang màn thanh toán. */
export function mapPayment(booking: ApiBooking): BookingPaymentData {
  const seconds = remainingSeconds(booking.expiresAt);
  return { bookingId: booking.bookingId, bookingStatus: booking.status, bookingCode: booking.bookingCode, status: booking.status === "PENDING_PAYMENT" && seconds > 0 ? "pending_payment" : "expired", tripId: booking.tripId, routeName: booking.trip.routeName, departureTimeText: dateText(booking.trip.departureAt, { dateStyle: "short", timeStyle: "short" }), operatorName: booking.trip.operatorName, holdCountdownSeconds: seconds, pickupPoint: mapPoint(booking.pickup), dropoffPoint: mapPoint(booking.dropoff), contactInfo: { fullName: booking.contact.fullName, phoneNumber: booking.contact.phone, email: booking.contact.email }, passengers: mapPassengers(booking), selectedPaymentMethod: booking.payment?.provider === "MOMO" ? "momo" : "vnpay", selectedBankOption: "vnpay_qr", priceSummary: mapBookingPrice(booking), isExpired: booking.status === "EXPIRED" || (booking.status === "PENDING_PAYMENT" && seconds === 0) };
}

/** Chỉ xác nhận thanh toán thành công khi API đã xác nhận và phát hành vé. */
export function mapPaymentResult(booking: ApiBooking): BookingPaymentResultData {
  const success = booking.payment?.status === "SUCCESS" && booking.tickets.length > 0;
  const closed = ["CANCELLED", "EXPIRED", "REFUNDED", "REFUND_PENDING", "REFUND_FAILED"].includes(booking.status);
  const failed = closed || ["FAILED", "EXPIRED", "CANCELLED"].includes(booking.payment?.status ?? "") || (booking.status === "PENDING_PAYMENT" && remainingSeconds(booking.expiresAt) === 0 && booking.payment?.status !== "RECONCILING" && booking.payment?.status !== "SUCCESS");
  return {
    bookingId: booking.bookingId, bookingCode: booking.bookingCode, status: success ? "success" : failed ? "failed" : "processing", canRetryPayment: booking.status === "PENDING_PAYMENT" && remainingSeconds(booking.expiresAt) > 0 && booking.payment?.status !== "RECONCILING" && booking.payment?.status !== "SUCCESS", processingMessage: booking.payment?.status === "SUCCESS" ? "Đã nhận thanh toán. Hệ thống đang phát hành vé." : booking.payment ? "Hệ thống đang kiểm tra kết quả giao dịch. Vui lòng chưa thanh toán thêm cho đơn này." : "Đơn chưa có giao dịch thanh toán. Chọn tiếp tục thanh toán để hoàn tất đặt vé.", paymentMethodLabel: booking.payment?.provider ?? "Chưa thanh toán", amountVnd: moneyString(booking.total), customerEmail: booking.contact.email, holdCountdownSeconds: remainingSeconds(booking.expiresAt),
    ...(failed ? { failureReason: closed ? bookingStatusLabel(booking.status) : "Giao dịch chưa hoàn tất. Vui lòng kiểm tra trạng thái trước khi thanh toán lại." } : {}),
    tickets: booking.tickets.map((ticket) => ({ ticketId: ticket.ticketId, ticketCode: ticket.ticketCode, passengerName: ticketPassengerName(ticket.passengerName, ticket.companionName), seatCode: ticket.seatCode, seatType: seatTypeLabel(booking.passengers.find((p) => p.seatCode === ticket.seatCode)?.seatType ?? ""), status: ticketStatus(ticket.status) })),
    trip: { operatorName: booking.trip.operatorName, operatorCode: "", routeName: booking.trip.routeName, vehicleType: booking.trip.vehicleTypeName, departureTimeText: dateText(booking.pickup.plannedAt, { dateStyle: "short", timeStyle: "short" }), pickupPointName: booking.pickup.name, dropoffPointName: booking.dropoff.name, dropoffTimeText: dateText(booking.dropoff.plannedAt, { hour: "2-digit", minute: "2-digit" }) },
    paymentDetails: { ticketCount: booking.passengers.length, ticketPriceTotalVnd: moneyString(booking.subtotal), serviceFeeVnd: moneyString(booking.serviceFee), discountVnd: moneyString(booking.discount), finalTotalVnd: moneyString(booking.total), gatewayTxnId: booking.payment?.paymentCode ?? "", paidAtText: booking.payment?.paidAt ? dateText(booking.payment.paidAt, { dateStyle: "short", timeStyle: "short" }) : "Chưa thanh toán" }
  };
}

/** Chuyển booking có vé hoặc đang chờ thanh toán sang danh sách hành trình. */
export function mapMyTicket(booking: ApiBooking): MyTicketItem {
  const cancelled = ["CANCELLED", "REFUNDED", "REFUND_PENDING", "REFUND_FAILED", "EXPIRED"].includes(booking.status) || (booking.status === "PENDING_PAYMENT" && remainingSeconds(booking.expiresAt) === 0);
  const completed = booking.tickets.length > 0 && booking.tickets.every((ticket) => ["USED", "NO_SHOW"].includes(ticket.status));
  return { id: booking.tickets[0]?.ticketId ?? booking.bookingId, hasIssuedTickets: booking.tickets.length > 0, bookingCode: booking.bookingCode, routeName: booking.trip.routeName, status: cancelled ? "cancelled" : completed ? "completed" : booking.status === "PENDING_PAYMENT" ? "pending_payment" : "valid", departureDayOfWeek: dateText(booking.trip.departureAt, { weekday: "short" }), departureDay: dateText(booking.trip.departureAt, { day: "2-digit" }), departureMonth: dateText(booking.trip.departureAt, { month: "2-digit", year: "numeric" }), departureTimeText: dateText(booking.pickup.plannedAt, { hour: "2-digit", minute: "2-digit" }), arrivalTimeText: dateText(booking.dropoff.plannedAt, { hour: "2-digit", minute: "2-digit" }), operatorName: booking.trip.operatorName, vehicleType: booking.trip.vehicleTypeName, ticketCount: booking.passengers.length, seatCodesText: booking.passengers.map((p) => p.seatCode).join(", "), pickupPointName: booking.pickup.name, totalAmountVnd: moneyString(booking.total), holdCountdownSeconds: remainingSeconds(booking.expiresAt), paymentUrl: `/bookings/${booking.bookingId}/payment` };
}

/** Chuyển vé và snapshot booking sang chi tiết vé, không tự sinh chính sách. */
export function mapTicketDetail(booking: ApiBooking): TicketDetailData {
  const cancelled = ["CANCELLED", "REFUNDED", "REFUND_PENDING", "REFUND_FAILED"].includes(booking.status);
  const completed = booking.tickets.length > 0 && booking.tickets.every((ticket) => ["USED", "NO_SHOW"].includes(ticket.status));
  return {
    bookingCode: booking.bookingCode, bookingTimeText: dateText(booking.createdAt, { dateStyle: "short", timeStyle: "short" }), status: cancelled ? "cancelled" : completed ? "completed" : "confirmed", statusLabel: bookingStatusLabel(booking.status),
    trip: { operatorName: booking.trip.operatorName, operatorCode: "", operatorHotline: booking.trip.operatorHotline ?? "", routeName: booking.trip.routeName, departureDayOfWeek: dateText(booking.pickup.plannedAt, { weekday: "long" }), departureDateText: dateText(booking.pickup.plannedAt, { dateStyle: "short" }), departureTime: dateText(booking.pickup.plannedAt, { hour: "2-digit", minute: "2-digit" }), departurePointName: booking.pickup.name, departureAddress: booking.pickup.address, arrivalTime: dateText(booking.dropoff.plannedAt, { hour: "2-digit", minute: "2-digit" }), arrivalNoticeText: "Dự kiến", arrivalPointName: booking.dropoff.name, arrivalAddress: booking.dropoff.address, travelDurationText: `${Math.round((Date.parse(booking.dropoff.plannedAt) - Date.parse(booking.pickup.plannedAt)) / 60000)} phút` },
    tickets: booking.tickets.map((ticket) => ({ ticketId: ticket.ticketId, ticketCode: ticket.ticketCode, passengerName: ticketPassengerName(ticket.passengerName, ticket.companionName), seatCode: ticket.seatCode, seatType: seatTypeLabel(booking.passengers.find((p) => p.seatCode === ticket.seatCode)?.seatType ?? ""), pricePaidVnd: moneyString(booking.passengers.find((p) => p.seatCode === ticket.seatCode)?.price ?? 0), status: ticketStatus(ticket.status), statusLabel: ({ VALID: "HỢP LỆ", CHECKED_IN: "ĐÃ LÊN XE", USED: "ĐÃ SỬ DỤNG", NO_SHOW: "VẮNG MẶT", CANCELLED: "ĐÃ HỦY", REFUNDED: "ĐÃ HOÀN TIỀN" })[ticket.status] })),
    payment: { ticketCount: booking.passengers.length, ticketPriceTotalVnd: moneyString(booking.subtotal), serviceFeeVnd: moneyString(booking.serviceFee), discountVnd: moneyString(booking.discount), paidTotalVnd: booking.payment?.status === "SUCCESS" ? moneyString(booking.payment.amount) : "0", methodLabel: booking.payment?.provider ?? "Chưa thanh toán", gatewayTxnId: booking.payment?.paymentCode ?? "", statusLabel: paymentStatusLabel(booking.payment?.status) },
    refundPolicy: { savedAtText: dateText(booking.createdAt, { dateStyle: "short" }), currentRefundNote: "Số tiền hoàn được hệ thống tính lại khi chọn vé hủy.", milestones: booking.cancellationPolicy.tiers.map((tier) => ({ timeframeText: `Trước giờ đi ít nhất ${tier.minHoursBefore} giờ`, refundRateText: `${tier.refundPercent}%`, refundPercent: tier.refundPercent })) }, boardingRules: []
  };
}

/** Danh sách đơn của phiên tra cứu; nhóm tab theo trạng thái và giờ khởi hành (giờ máy chủ). */
export function mapLookupBookings(list: components["schemas"]["TicketLookupBookingListDto_Output"], expiresInSeconds: number, now = new Date()): TicketLookupBookingsData {
  const closed: readonly string[] = ["CANCELLED", "EXPIRED", "REFUND_PENDING", "REFUNDED", "REFUND_FAILED"];
  const items = list.items.map((item): TicketLookupBookingItem => ({
    bookingId: item.bookingId,
    bookingCode: item.bookingCode,
    statusLabel: bookingStatusLabel(item.status),
    group: closed.includes(item.status) ? "cancelled" : new Date(item.departureAt) < now ? "completed" : "upcoming",
    routeName: item.routeName,
    departureTimeText: dateText(item.departureAt, { dateStyle: "short", timeStyle: "short" }),
    operatorName: item.operatorName,
    ticketCountText: `${item.ticketCount} vé`,
    totalVnd: moneyString(item.total),
    bookedWithAccount: item.bookedWithAccount
  }));
  return { maskedEmail: list.maskedEmail, scope: list.scope, hasAccount: list.hasAccount, accountSuggested: list.hasAccount || items.some((item) => item.bookedWithAccount), expiresInSeconds, items };
}

/** Chuyển kết quả tra cứu trực tiếp của API sang giao diện khách vãng lai. */
export function mapLookupResult(booking: ApiBooking, expiresInSeconds: number): TicketLookupResultData {
  const email = booking.contact.email.replace(/^(.).+(@.*)$/, "$1***$2");
  const detail = mapTicketDetail(booking);
  return { bookingCode: booking.bookingCode, routeName: booking.trip.routeName, departureTimeText: dateText(booking.pickup.plannedAt, { dateStyle: "short", timeStyle: "short" }), operatorName: booking.trip.operatorName, statusLabel: bookingStatusLabel(booking.status), session: { maskedEmail: email, expiresInSeconds }, tickets: detail.tickets.map((ticket) => ({ ...ticket, statusLabel: ticket.statusLabel ?? "" })), pickupPoint: { time: detail.trip.departureTime, name: booking.pickup.name, address: booking.pickup.address }, dropoffPoint: { time: detail.trip.arrivalTime, name: booking.dropoff.name, address: booking.dropoff.address, noticeText: "Giờ đến dự kiến" }, payment: { seatCount: booking.passengers.length, ticketPriceTotalVnd: moneyString(booking.subtotal), serviceFeeVnd: moneyString(booking.serviceFee), paidTotalVnd: detail.payment.paidTotalVnd, methodLabel: detail.payment.methodLabel, statusLabel: detail.payment.statusLabel } };
}

/** Điểm trả hợp lệ với điểm đón: đứng sau điểm đón trên hành trình (id điểm = thứ tự `sequence` của API). */
export function isDropoffAfterPickup(pickupId: string, dropoffId: string): boolean {
  return Number(dropoffId) > Number(pickupId);
}

/**
 * Chọn sẵn chặng khách đã tìm (`sequence` điểm đón / trả từ thẻ kết quả). Điểm đón không cho đón thì giữ mặc định của
 * chuyến; điểm trả không hợp lệ (không cho trả / không đứng sau điểm đón) thì lấy điểm trả hợp lệ như khi đổi điểm đón.
 */
export function withSelectedLeg(data: TripSeatSelectionData, leg: { readonly pickup?: number; readonly dropoff?: number }): TripSeatSelectionData {
  const pickup = data.pickupPoints.find((point) => point.id === String(leg.pickup));
  if (!pickup) return data;
  const dropoff = data.dropoffPoints.find((point) => point.id === String(leg.dropoff) && isDropoffAfterPickup(pickup.id, point.id));
  return {
    ...data,
    selectedPickupPointId: pickup.id,
    selectedDropoffPointId: dropoff?.id ?? dropoffForPickup(pickup.id, data.dropoffPoints, data.selectedDropoffPointId)
  };
}

/** Đổi điểm đón: giữ điểm trả đang chọn nếu còn hợp lệ, không thì lấy điểm trả hợp lệ cuối cùng (bến cuối). */
export function dropoffForPickup(pickupId: string, dropoffPoints: readonly SeatLocationPoint[], currentDropoffId: string): string {
  if (isDropoffAfterPickup(pickupId, currentDropoffId)) return currentDropoffId;
  return dropoffPoints.filter((point) => isDropoffAfterPickup(pickupId, point.id)).at(-1)?.id ?? currentDropoffId;
}
