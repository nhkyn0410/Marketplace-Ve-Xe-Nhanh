import type { ApiBooking, ApiHold, ApiTrip } from "./booking-mappers";

/** Tạo snapshot booking dùng riêng trong kiểm thử bộ chuyển đổi API. */
export function bookingFixture(overrides: Partial<ApiBooking> = {}): ApiBooking {
  return {
    bookingId: "11111111-1111-4111-8111-111111111111", bookingCode: "VXN-TEST", status: "CONFIRMED", tripId: "22222222-2222-4222-8222-222222222222",
    trip: { routeName: "Hà Nội → Hải Phòng", operatorName: "Nhà xe kiểm thử", operatorHotline: null, vehicleTypeName: "Ghế ngồi", departureAt: "2030-01-01T01:00:00Z", arrivalAt: "2030-01-01T03:00:00Z" },
    pickup: { sequence: 1, name: "Điểm đón", address: "Địa chỉ đón", plannedAt: "2030-01-01T01:00:00Z" }, dropoff: { sequence: 2, name: "Điểm trả", address: "Địa chỉ trả", plannedAt: "2030-01-01T03:00:00Z" },
    contact: { fullName: "Khách kiểm thử", phone: "0900000000", email: "guest@example.test" }, passengers: [{ seatCode: "A1", seatType: "SEAT", fullName: "Khách kiểm thử", phone: null, companionName: null, price: 100001 }], note: null, subtotal: 100001, serviceFee: 0, discount: 1, discountFunding: "PLATFORM", total: 100000,
    cancellationPolicy: { tiers: [{ minHoursBefore: 24, refundPercent: 80 }] }, expiresAt: "2030-01-01T00:00:00Z", payment: { paymentCode: "PAY-TEST", provider: "VNPAY", status: "SUCCESS", amount: 100000, paidAt: "2029-12-01T01:00:00Z" },
    tickets: [{ ticketId: "33333333-3333-4333-8333-333333333333", ticketCode: "VXN-T1", seatCode: "A1", passengerName: "Khách kiểm thử", companionName: null, status: "VALID", qrToken: "signed-qr-content" }], refunds: [], tripChanges: [], createdAt: "2029-12-01T00:00:00Z", ...overrides
  };
}

/** Tạo giữ chỗ với giá do máy chủ trả trong kiểm thử. */
export function holdFixture(): ApiHold {
  const booking = bookingFixture();
  return { holdId: "44444444-4444-4444-8444-444444444444", tripId: booking.tripId, pickup: booking.pickup, dropoff: booking.dropoff, seats: [{ code: "A1", type: "SEAT", price: 100001 }], subtotal: 100001, expiresAt: "2030-01-01T00:00:00Z" };
}

/** Tạo chi tiết chuyến công khai cho kiểm thử trang giữ chỗ. */
export function publicTripFixture(): ApiTrip {
  const booking = bookingFixture();
  return {
    tripId: booking.tripId, operator: { id: "55555555-5555-4555-8555-555555555555", name: booking.trip.operatorName, slug: "test", hotline: null, averageRating: null, reviewCount: 0 }, routeName: booking.trip.routeName, segment: null, departureAt: booking.trip.departureAt, arrivalAt: booking.trip.arrivalAt, onlineSaleClosesAt: "2029-12-31T23:00:00Z", note: null,
    vehicleType: { name: "Ghế ngồi", form: "SEATER", class: "STANDARD" }, amenities: [], vehicleImages: [],
    stops: [booking.pickup, booking.dropoff].map((stop, index) => ({ ...stop, role: index === 0 ? "ORIGIN" : "DESTINATION", type: "BUS_STATION", latitude: 0, longitude: 0, pickupWindowStart: null, pickupWindowEnd: null, allowPickup: index === 0, allowDropoff: index === 1, pickupOpen: index === 0, note: null })),
    seats: [{ code: "A1", deck: 1, row: 2, column: 4, type: "SEAT", status: "AVAILABLE", price: 100001 }], cancellationPolicy: booking.cancellationPolicy
  };
}
