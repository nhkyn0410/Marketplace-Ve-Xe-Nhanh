import { beforeEach, describe, expect, it, vi } from "vitest";
import { apiMoney, mapBookingPrice, mapLookupResult, mapPaymentResult, mapSeatSelection, mapTicketDetail, moneyString } from "./booking-mappers";
import { bookingFixture, holdFixture, publicTripFixture } from "./booking-test-fixture";

const { request, profile, wallet, jar, values } = vi.hoisted(() => {
  const values = new Map<string, string>();
  return { request: vi.fn(), profile: vi.fn(), wallet: vi.fn(), values, jar: { get: vi.fn((name: string) => values.has(name) ? { value: values.get(name) } : undefined), set: vi.fn((name: string, value: string) => { values.set(name, value); }) } };
});
vi.mock("./api", () => ({ apiRequest: request, ACCESS_COOKIE: "vxn_marketplace_access" }));
vi.mock("./auth", () => ({ getAccountProfile: profile }));
vi.mock("./loyalty", () => ({ getUserVouchers: wallet }));
vi.mock("./session", () => ({ refreshSessionIfNeeded: vi.fn(async () => ({ status: "ok", data: { rotated: false } })) }));
vi.mock("next/headers", () => ({ cookies: vi.fn(async () => jar) }));
import { checkCheckoutPromotion, createBooking, createPayment, getCheckoutHoldData, holdSeats } from "./booking";

describe("booking API integration", () => {
  beforeEach(() => { vi.clearAllMocks(); values.clear(); request.mockReset(); wallet.mockResolvedValue({ status: "ok", data: { vouchers: [], availableCount: 0, usedCount: 0, expiredCount: 0 } }); });

  it("dùng BigInt/chuỗi cho tiền và từ chối số không an toàn từ API", () => {
    expect(moneyString(Number.MAX_SAFE_INTEGER)).toBe("9007199254740991");
    expect(apiMoney("9007199254740991")).toBe(Number.MAX_SAFE_INTEGER);
    expect(() => moneyString(Number.MAX_SAFE_INTEGER + 1)).toThrow();
    expect(() => apiMoney("9007199254740992")).toThrow();
    expect(() => moneyString(100.5)).toThrow();
    expect(mapBookingPrice(bookingFixture())).toMatchObject({ ticketPriceTotalVnd: "100001", discountVnd: "1", finalTotalVnd: "100000" });
  });

  it("không xác nhận thành công từ trạng thái chưa phát hành vé hoặc đang đối soát", () => {
    expect(mapPaymentResult(bookingFixture({ tickets: [] })).status).toBe("processing");
    const payment = bookingFixture().payment!;
    expect(mapPaymentResult(bookingFixture({ payment: { ...payment, status: "RECONCILING" } })).status).toBe("processing");
    expect(mapPaymentResult(bookingFixture()).status).toBe("success");
  });

  it("giữ trạng thái đã sử dụng/vắng mặt và nhãn thanh toán chưa thành công", () => {
    const booking = bookingFixture();
    booking.tickets[0]!.status = "NO_SHOW";
    const payment = booking.payment!;
    const detail = mapTicketDetail({ ...booking, status: "REFUND_PENDING", payment: { ...payment, status: "RECONCILING" } });
    expect(detail.statusLabel).toBe("Đang hoàn tiền");
    expect(detail.tickets[0]).toMatchObject({ status: "no_show", statusLabel: "VẮNG MẶT" });
    expect(detail.payment).toMatchObject({ statusLabel: "Đang đối soát", paidTotalVnd: "0" });
    expect(mapLookupResult({ ...booking, status: "CANCELLED" }, 30).statusLabel).toBe("Đã hủy");
    expect(mapPaymentResult({ ...booking, status: "CANCELLED", payment: null, tickets: [] })).toMatchObject({ status: "failed", canRetryPayment: false });
  });

  it("giữ tọa độ ghế thật và không cho chọn ghế chưa có giá hoặc không còn bán", () => {
    const trip = publicTripFixture();
    trip.seats.push({ ...trip.seats[0]!, code: "A2", column: 5, price: null }, { ...trip.seats[0]!, code: "A3", column: 6, status: "UNAVAILABLE" });
    expect(mapSeatSelection(trip).seats).toMatchObject([
      { code: "A1", row: 2, column: 4, status: "available", priceVnd: "100001" },
      { code: "A2", status: "disabled" },
      { code: "A3", status: "disabled" }
    ]);
  });

  it("không gửi giữ chỗ trùng hoặc điểm trả trước điểm đón", async () => {
    expect((await holdSeats("trip", ["A1", "A1"], 1, 2)).status).toBe("error");
    expect((await holdSeats("trip", ["A1"], 2, 1)).status).toBe("error");
    expect(request).not.toHaveBeenCalled();
    request.mockResolvedValue({ status: "ok", data: holdFixture() });
    await holdSeats("trip", ["A1"], 1, 2);
    expect(JSON.parse(request.mock.calls[0]![1].body)).toEqual({ tripId: "trip", seatCodes: ["A1"], pickupSequence: 1, dropoffSequence: 2 });
  });

  it("đọc lại giá giữ chỗ phía máy chủ, giữ token httpOnly và dùng lại kết quả gửi lặp", async () => {
    const booking = bookingFixture();
    const hold = holdFixture();
    request.mockResolvedValueOnce({ status: "ok", data: hold }).mockResolvedValueOnce({ status: "ok", data: { ...booking, accessToken: "private-guest-token" } });
    const payload = { contactInfo: { fullName: "Khách", phoneNumber: "0900000000", email: "guest@example.test" }, passengers: [{ seatCode: "A1", seatTypeLabel: "", floorLabel: "", priceVnd: "1", fullName: "Khách", phoneNumber: "", idNumber: "", shouldSaveForLater: false }], note: "" };
    const result = await createBooking(hold.holdId, payload);
    const sent = JSON.parse(request.mock.calls[1]![1].body);
    expect(sent.expectedTotal).toBe(100001);
    expect(sent).not.toHaveProperty("promotionCode");
    expect(sent.passengers[0]).not.toHaveProperty("priceVnd");
    expect(result).toEqual({ status: "ok", data: { bookingId: booking.bookingId } });
    expect(jar.set).toHaveBeenCalledWith(`vxn_booking_${booking.bookingId}`, "private-guest-token", expect.objectContaining({ httpOnly: true, sameSite: "lax" }));
    expect(await createBooking(hold.holdId, payload)).toEqual(result);
    expect(request).toHaveBeenCalledTimes(2);
  });

  it("kiểm mã đã chuẩn hóa bằng trip và subtotal giữ chỗ, giữ nguyên báo giá API", async () => {
    const hold = holdFixture();
    request.mockResolvedValueOnce({ status: "ok", data: hold }).mockResolvedValueOnce({ status: "ok", data: { code: "THU10", name: "Ưu đãi mùa thu", discount: 10000, total: 90001 } });
    expect(await checkCheckoutPromotion(hold.holdId, "  thu10  ")).toEqual({ status: "ok", data: { code: "THU10", name: "Ưu đãi mùa thu", discountVnd: "10000", totalVnd: "90001" } });
    expect(request.mock.calls[0]![0]).toBe(`/seat-holds/${hold.holdId}`);
    expect(request.mock.calls[1]![0]).toBe("/promotions/check");
    expect(JSON.parse(request.mock.calls[1]![1].body)).toEqual({ tripId: hold.tripId, code: "THU10", subtotal: 100001 });
  });

  it("không kiểm mã sai định dạng hoặc giữ chỗ đã hết hạn", async () => {
    expect((await checkCheckoutPromotion(holdFixture().holdId, "a!")).status).toBe("error");
    expect(request).not.toHaveBeenCalled();
    request.mockResolvedValueOnce({ status: "ok", data: { ...holdFixture(), expiresAt: "2000-01-01T00:00:00Z" } });
    expect((await checkCheckoutPromotion(holdFixture().holdId, "THU10")).status).toBe("error");
    expect(request).toHaveBeenCalledTimes(1);
  });

  it.each([
    { code: "THU10", discount: -1, total: 100002 },
    { code: "THU10", discount: 0.5, total: 100000.5 },
    { code: "THU10", discount: 1, total: Number.MAX_SAFE_INTEGER + 1 },
    { code: "THU10", discount: 10000, total: 100001 },
    { code: "KHAC10", discount: 10000, total: 90001 }
  ])("từ chối báo giá mã không khớp hoặc tiền không hợp lệ: %j", async (quote) => {
    request.mockResolvedValueOnce({ status: "ok", data: holdFixture() }).mockResolvedValueOnce({ status: "ok", data: { name: "Ưu đãi", ...quote } });
    expect((await checkCheckoutPromotion(holdFixture().holdId, "THU10")).status).toBe("error");
  });

  it("trả lỗi mã không hợp lệ/hết lượt cho giao diện thay vì dựng mức giảm", async () => {
    const exhausted = { status: "error", endpoint: "POST /promotions/check", message: "Mã khuyến mãi đã hết lượt.", httpStatus: 409 };
    request.mockResolvedValueOnce({ status: "ok", data: holdFixture() }).mockResolvedValueOnce(exhausted);
    expect(await checkCheckoutPromotion(holdFixture().holdId, "THU10")).toEqual(exhausted);
    expect(request).toHaveBeenCalledTimes(2);
  });

  it("gửi mã và tổng sau giảm khách đã thấy, không âm thầm kiểm lại rồi thay tổng", async () => {
    const hold = holdFixture();
    const booking = bookingFixture();
    request.mockResolvedValueOnce({ status: "ok", data: hold }).mockResolvedValueOnce({ status: "ok", data: { ...booking, accessToken: "private-guest-token" } });
    const payload = { contactInfo: { fullName: "Khách", phoneNumber: "0900000000", email: "guest@example.test" }, passengers: [{ ...bookingFixture().passengers[0]!, seatTypeLabel: "", floorLabel: "", priceVnd: "1", phoneNumber: "", idNumber: "", shouldSaveForLater: false }], note: "", promotion: { code: "  thu10  ", expectedTotalVnd: "90001" } };
    expect((await createBooking(hold.holdId, payload)).status).toBe("ok");
    expect(JSON.parse(request.mock.calls[1]![1].body)).toMatchObject({ promotionCode: "THU10", expectedTotal: 90001 });
    expect(request.mock.calls.map((call) => call[0])).toEqual([`/seat-holds/${hold.holdId}`, "/bookings"]);
    expect(JSON.parse(request.mock.calls[1]![1].body)).not.toHaveProperty("userVoucherId");
  });

  it("giữ lỗi tạo đơn khi mã hết lượt hoặc tổng thay đổi, không tự tạo lại đơn bỏ mã", async () => {
    const hold = holdFixture();
    const changed = { status: "error", endpoint: "POST /bookings", message: "Giá vé đã thay đổi. Vui lòng chọn chỗ lại.", httpStatus: 409 };
    request.mockResolvedValueOnce({ status: "ok", data: hold }).mockResolvedValueOnce(changed);
    const payload = { contactInfo: { fullName: "Khách", phoneNumber: "0900000000", email: "guest@example.test" }, passengers: [{ ...bookingFixture().passengers[0]!, seatTypeLabel: "", floorLabel: "", priceVnd: "1", phoneNumber: "", idNumber: "", shouldSaveForLater: false }], note: "", promotion: { code: "THU10", expectedTotalVnd: "90001" } };
    expect(await createBooking(hold.holdId, payload)).toEqual(changed);
    expect(JSON.parse(request.mock.calls[1]![1].body)).toMatchObject({ promotionCode: "THU10", expectedTotal: 90001 });
    expect(request).toHaveBeenCalledTimes(2);
    expect(jar.set).not.toHaveBeenCalled();
  });

  it("không gửi booking khi tổng giảm mất độ chính xác hoặc mã không hợp lệ", async () => {
    const hold = holdFixture();
    const payload = { contactInfo: { fullName: "Khách", phoneNumber: "0900000000", email: "guest@example.test" }, passengers: [{ ...bookingFixture().passengers[0]!, seatTypeLabel: "", floorLabel: "", priceVnd: "1", phoneNumber: "", idNumber: "", shouldSaveForLater: false }], note: "", promotion: { code: "THU10", expectedTotalVnd: "9007199254740992" } };
    request.mockResolvedValueOnce({ status: "ok", data: hold });
    expect((await createBooking(hold.holdId, payload)).status).toBe("error");
    expect(request).toHaveBeenCalledTimes(1);
    request.mockClear();
    expect((await createBooking(hold.holdId, { ...payload, promotion: { code: "a!", expectedTotalVnd: "90001" } })).status).toBe("error");
    expect(request).not.toHaveBeenCalled();
  });

  it("điền thông tin liên hệ, cho chọn hành khách đã lưu và vẫn cho khách vãng lai đặt vé", async () => {
    values.set("vxn_marketplace_access", "account-token");
    profile.mockResolvedValue({ status: "ok", data: { fullName: "Tên tài khoản", email: "account@example.test", phone: "0900000000", savedPassengers: [{ id: "passenger-1", name: "Người đi cùng", phone: "0911111111" }] } });
    request.mockResolvedValueOnce({ status: "ok", data: holdFixture() }).mockResolvedValueOnce({ status: "ok", data: publicTripFixture() });
    const result = await getCheckoutHoldData(holdFixture().holdId);
    expect(result.status === "ok" && result.data.contactInfo).toEqual({ fullName: "Tên tài khoản", email: "account@example.test", phoneNumber: "0900000000" });
    expect(result.status === "ok" && result.data.savedPassengers[0]).toMatchObject({ id: "passenger-1", fullName: "Người đi cùng", phoneNumber: "0911111111" });
    expect(result.status === "ok" && result.data.priceSummary).toMatchObject({ isEstimate: true, ticketPriceTotalVnd: "100001" });
    values.clear();
    profile.mockClear();
    request.mockResolvedValueOnce({ status: "ok", data: holdFixture() }).mockResolvedValueOnce({ status: "ok", data: publicTripFixture() });
    const guest = await getCheckoutHoldData(holdFixture().holdId);
    expect(guest.status === "ok" && guest.data.contactInfo).toEqual({ fullName: "", email: "", phoneNumber: "" });
    expect(profile).not.toHaveBeenCalled();
  });

  it("voucher trong ví: báo giá từng voucher cho chuyến, không áp được thì 'Không phù hợp', lỗi ví không làm hỏng checkout", async () => {
    values.set("vxn_marketplace_access", "account-token");
    profile.mockResolvedValue({ status: "ok", data: { fullName: "Khách", email: "k@example.test", phone: "0900000000", savedPassengers: [] } });
    const base = { status: "available", statusLabel: "Khả dụng", scopeText: "Đơn tối thiểu 0đ", expiryDateText: "05/11/2026" };
    wallet.mockResolvedValue({ status: "ok", data: { vouchers: [
      { ...base, id: "v-redeem", code: "", title: "Voucher VXN Plus", type: "loyalty_redemption", typeLabel: "Đổi điểm", discountLabel: "Giảm 50.000đ" },
      { ...base, id: "v-saved", code: "TAYBAC30", title: "Tây Bắc", type: "public_code", typeLabel: "Mã đã lưu", discountLabel: "Giảm 30.000đ" }
    ], availableCount: 2, usedCount: 0, expiredCount: 0 } });
    request.mockResolvedValueOnce({ status: "ok", data: holdFixture() }).mockResolvedValueOnce({ status: "ok", data: publicTripFixture() })
      .mockResolvedValueOnce({ status: "ok", data: { code: "VXNPLUS", name: "Voucher VXN Plus", discount: 50_000, total: 50_001 } })
      .mockResolvedValueOnce({ status: "error", endpoint: "POST /promotions/check", message: "Mã khuyến mãi không áp dụng cho tuyến này." });
    const result = await getCheckoutHoldData(holdFixture().holdId);
    expect(result.status === "ok" && result.data.vouchers).toMatchObject([
      { id: "v-redeem", isApplicable: true, discountVnd: "50000", tagText: "Đổi từ điểm", discountLabel: "Voucher đổi điểm" },
      { id: "v-saved", isApplicable: false, discountVnd: "0", tagText: "Không phù hợp", description: "Mã khuyến mãi không áp dụng cho tuyến này." }
    ]);
    expect(JSON.parse(request.mock.calls[2]![1].body)).toMatchObject({ userVoucherId: "v-redeem", subtotal: 100_001 });
    wallet.mockRejectedValueOnce(new Error("network"));
    request.mockResolvedValueOnce({ status: "ok", data: holdFixture() }).mockResolvedValueOnce({ status: "ok", data: publicTripFixture() });
    const fallback = await getCheckoutHoldData(holdFixture().holdId);
    expect(fallback.status === "ok" && fallback.data.vouchers).toEqual([]);
  });

  it("tạo đơn với voucher trong ví gửi userVoucherId; gửi cả mã lẫn voucher bị chặn trước khi gọi API", async () => {
    const hold = holdFixture();
    const payload = { contactInfo: { fullName: "Khách", phoneNumber: "0900000000", email: "k@example.test" }, passengers: [{ ...bookingFixture().passengers[0]!, seatTypeLabel: "", floorLabel: "", priceVnd: "1", phoneNumber: "", idNumber: "", shouldSaveForLater: false }], note: "" };
    expect((await createBooking(hold.holdId, { ...payload, promotion: { code: "THU10", userVoucherId: "v-redeem", expectedTotalVnd: "50001" } })).status).toBe("error");
    expect(request).not.toHaveBeenCalled();
    request.mockResolvedValueOnce({ status: "ok", data: hold }).mockResolvedValueOnce({ status: "ok", data: { bookingId: "b-1", accessToken: "t" } });
    expect((await createBooking(hold.holdId, { ...payload, promotion: { userVoucherId: "v-redeem", expectedTotalVnd: "50001" } })).status).toBe("ok");
    const body = JSON.parse(request.mock.calls[1]![1].body);
    expect(body).toMatchObject({ userVoucherId: "v-redeem", expectedTotal: 50_001 });
    expect(body.promotionCode).toBeUndefined();
  });

  it("gửi đúng provider và token qua header, từ chối liên kết thanh toán thực thi mã", async () => {
    const booking = bookingFixture();
    values.set(`vxn_booking_${booking.bookingId}`, "private-guest-token");
    request.mockResolvedValue({ status: "ok", data: { paymentUrl: "javascript:alert(1)" } });
    expect((await createPayment(booking.bookingId, "vnpay")).status).toBe("error");
    expect(request.mock.calls[0]![1]).toMatchObject({ headers: { "X-Booking-Token": "private-guest-token" }, body: '{"provider":"VNPAY"}' });
    request.mockResolvedValue({ status: "ok", data: { paymentUrl: "https://sandbox.vnpayment.vn/payment" } });
    expect(await createPayment(booking.bookingId, "vnpay")).toEqual({ status: "ok", data: { paymentUrl: "https://sandbox.vnpayment.vn/payment" } });
  });
});
