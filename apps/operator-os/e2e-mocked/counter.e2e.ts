import { expect, test, type Page } from "@playwright/test";

const OFFICE = "11111111-1111-4111-8111-111111111111";
const TRIP = "22222222-2222-4222-8222-222222222222";
const HOLD = "33333333-3333-4333-8333-333333333333";
const BOOKING = "44444444-4444-4444-8444-444444444444";
const TICKET = "55555555-5555-4555-8555-555555555555";
const RECEIPT = "66666666-6666-4666-8666-666666666666";

async function mockCounter(page: Page, options: { anonymous?: boolean; failFirstReceipt?: boolean; exception?: boolean; additionalReceipt?: boolean } = {}) {
  let authenticated = !options.anonymous;
  const receiptAttempts: Record<string, unknown>[] = [];
  const instant = new Date().toISOString();
  const trip = { tripId: TRIP, routeName: "Sài Gòn – Đà Lạt", departureAt: instant, arrivalAt: instant, status: "BOARDING", vehiclePlateNumber: "51B12345", stops: [{ sequence: 1, name: "Văn phòng Sài Gòn", allowPickup: true, allowDropoff: false, plannedAt: instant }, { sequence: 2, name: "Bến Đà Lạt", allowPickup: false, allowDropoff: true, plannedAt: instant }], seats: [{ code: "A1", type: "BED", status: "AVAILABLE", price: "300000" }, { code: "A2", type: "BED", status: "BOOKED", price: "300000" }] };
  let booking: Record<string, unknown> | null = null;
  const me = { subjectId: "sales-1", scope: "operator", role: "SALES_STAFF", username: "nv.banve", sessionId: "session-1", accessExpiresAt: instant, mfaVerified: false, permissions: ["office:read", "counter:sell", "counter:collect", "counter:read"], operatorId: "operator-1", operatorSlug: "nhaxe" };

  await page.route("**/v1/**", async (route) => {
    const request = route.request();
    const url = new URL(request.url());
    const path = url.pathname.replace(/^\/v1/, "");
    const fulfill = (body: unknown, status = 200) => route.fulfill({ status, contentType: "application/json", body: JSON.stringify(body) });
    if (path === "/auth/csrf") return fulfill({ csrfToken: "counter-test-csrf" });
    if (path === "/auth/me") return authenticated ? fulfill(me) : fulfill({ code: "AUTH_SESSION_EXPIRED", detail: "Session expired" }, 401);
    if (path === "/auth/refresh") return fulfill({ code: "AUTH_SESSION_EXPIRED", detail: "Session expired" }, 401);
    if (path === "/auth/counter/login") { authenticated = true; return fulfill({ authenticated: true }); }
    if (path === "/auth/logout") { authenticated = false; return fulfill({ status: "ok" }); }
    if (path === "/operator/offices") return fulfill({ items: [{ id: OFFICE, code: "VP-SG", name: "Văn phòng Sài Gòn", address: "Quận 1, TP.HCM", active: true, version: 0, createdAt: instant, updatedAt: instant }] });
    if (path === "/operator/counter/trips") return fulfill({ items: [trip] });
    if (path === "/operator/counter/holds" && request.method() === "POST") return fulfill({ holdId: HOLD, officeId: OFFICE, tripId: TRIP, pickup: trip.stops[0], dropoff: trip.stops[1], seats: [{ code: "A1", type: "BED", price: "300000" }], subtotal: "300000", expiresAt: new Date(Date.now() + 600_000).toISOString() });
    if (path === "/operator/counter/bookings" && request.method() === "POST") {
      const input = request.postDataJSON() as { contact: object };
      booking = { bookingId: BOOKING, bookingCode: "VXNABC234", officeId: OFFICE, seller: "nhaxe/nv.banve", status: "PENDING_PAYMENT", tripId: TRIP, trip, contact: input.contact, passengers: [{ seatCode: "A1", fullName: "Nguyễn Văn Khách", price: "300000" }], total: "300000", expiresAt: new Date(Date.now() + 600_000).toISOString(), createdAt: instant, tickets: [], receipts: [] };
      return fulfill(booking, 201);
    }
    if (path === `/operator/counter/bookings/${BOOKING}/receipts`) {
      const input = request.postDataJSON() as Record<string, unknown>;
      receiptAttempts.push(input);
      if (options.failFirstReceipt && receiptAttempts.length === 1) return route.abort("failed");
      const status = options.exception ? "EXCEPTION" : "COMPLETED";
      const receipt = { id: RECEIPT, method: input.method, amount: input.amount, reference: input.reference, status, exceptionReason: options.exception ? "TRIP_CLOSED" : null, createdAt: instant };
      booking = { ...booking, status: options.exception ? "PENDING_PAYMENT" : "CONFIRMED", receipts: [receipt, ...(options.additionalReceipt ? [{ ...receipt, id: "77777777-7777-4777-8777-777777777777", status: "EXCEPTION", exceptionReason: "BOOKING_NOT_PENDING" }] : [])], tickets: options.exception ? [] : [{ ticketId: TICKET, ticketCode: "VXNABC234-01", seatCode: "A1", passengerName: "Nguyễn Văn Khách", status: "VALID", qrToken: "signed-counter-ticket-token" }] };
      return fulfill({ receiptId: RECEIPT, status, exceptionReason: receipt.exceptionReason, booking });
    }
    if (path === `/operator/counter/bookings/${BOOKING}`) return fulfill(booking);
    if (path === "/operator/counter/bookings") return fulfill({ items: booking ? [booking] : [], nextCursor: null });
    if (path === "/operator/counter/report") return fulfill({ cash: "0", bankTransfer: "0", exceptions: "0", commission: "0", receipts: 0, sellers: [] });
    return fulfill({ code: "TEST_UNEXPECTED_ENDPOINT", detail: path }, 404);
  });
  return { receiptAttempts };
}

async function createBooking(page: Page) {
  await page.goto("/counter");
  await page.getByRole("button", { name: /Sài Gòn – Đà Lạt/ }).click();
  await expect(page.getByRole("button", { name: /A2/ })).toBeDisabled();
  await page.getByRole("button", { name: /A1/ }).click();
  await page.getByRole("button", { name: "Giữ ghế và nhập khách" }).click();
  await page.getByLabel("Họ tên liên hệ *").fill("Nguyễn Văn Khách");
  await page.getByLabel("Số điện thoại *").fill("0901234567");
  await page.getByRole("button", { name: "Tạo đơn và thu tiền" }).click();
  await expect(page.getByRole("heading", { name: "Đơn VXNABC234" })).toBeVisible();
}

test("cổng nhân viên đăng nhập bằng endpoint riêng rồi mở bàn bán vé", async ({ page }) => {
  await mockCounter(page, { anonymous: true });
  await page.goto("/auth/counter/login");
  await expect(page.getByRole("heading", { name: "Đăng nhập bán vé tại quầy" })).toBeVisible();
  await page.getByPlaceholder("nhaxe/nv.banve").fill("nhaxe/nv.banve");
  await page.getByPlaceholder("Nhập mật khẩu").fill("counter-test-password");
  await page.getByRole("button", { name: "Đăng nhập", exact: true }).click();
  await expect(page).toHaveURL(/\/counter$/);
  await expect(page.getByRole("heading", { name: "Bán vé tại quầy", exact: true })).toBeVisible();
  await expect(page.getByText("Người bán: nv.banve")).toBeVisible();
});

test("thử lại khi mất kết nối dùng cùng mã khoản thu rồi in lại vé đã có", async ({ page }, testInfo) => {
  const { receiptAttempts } = await mockCounter(page, { failFirstReceipt: true });
  await createBooking(page);
  await page.getByRole("checkbox").check();
  await page.getByRole("button", { name: "Xác nhận tiền đã nhận" }).click();
  await expect(page.getByRole("button", { name: "Thử lại cùng khoản thu" })).toBeEnabled();
  await page.reload();
  await page.getByRole("button", { name: "Mở đơn" }).click();
  await expect(page.getByRole("button", { name: "Thử lại cùng khoản thu" })).toBeEnabled();
  await page.getByRole("button", { name: "Thử lại cùng khoản thu" }).click();
  await expect(page.getByRole("heading", { name: "Vé đã phát", exact: true })).toBeVisible();
  await expect(page.getByRole("img", { name: "Mã QR vé VXNABC234-01" })).toBeVisible();
  expect(receiptAttempts).toHaveLength(2);
  expect(receiptAttempts[0]).toEqual(receiptAttempts[1]);
  await page.reload();
  await page.getByRole("button", { name: "Mở đơn" }).click();
  await expect(page.getByRole("heading", { name: "Vé đã phát", exact: true })).toBeVisible();
  expect(receiptAttempts).toHaveLength(2);
  await page.screenshot({ path: testInfo.outputPath("counter-tickets.png"), fullPage: true });
});

test("chuyển khoản đã nhận nhưng xe khởi hành được giữ ngoại lệ và không có QR", async ({ page }) => {
  await mockCounter(page, { exception: true });
  await createBooking(page);
  await page.getByLabel("Phương thức thu").selectOption("BANK_TRANSFER");
  await page.getByLabel("Mã giao dịch ngân hàng *").fill("BANK-REF-001");
  await page.getByRole("checkbox").check();
  await page.getByRole("button", { name: "Xác nhận tiền đã nhận" }).click();
  await expect(page.getByRole("alert").filter({ hasText: "Tiền đã được ghi nhận" })).toBeVisible();
  await expect(page.getByText("Chuyến đã khởi hành hoặc đã dừng bán. Khoản tiền được giữ để nhà xe xử lý.", { exact: true })).toBeVisible();
  await expect(page.getByRole("heading", { name: "Vé đã phát", exact: true })).toHaveCount(0);
  await expect(page.getByRole("button", { name: "Xác nhận tiền đã nhận" })).toHaveCount(0);
});

test("vé đã phát vẫn giữ nguyên khi đơn có khoản thu bổ sung cần xử lý", async ({ page }) => {
  await mockCounter(page, { additionalReceipt: true });
  await createBooking(page);
  await page.getByRole("checkbox").check();
  await page.getByRole("button", { name: "Xác nhận tiền đã nhận" }).click();
  await expect(page.getByRole("alert").filter({ hasText: "Có khoản thu bổ sung cần xử lý. Vé đã phát vẫn giữ nguyên" })).toBeVisible();
  await expect(page.getByRole("img", { name: "Mã QR vé VXNABC234-01" })).toBeVisible();
  await expect(page.getByRole("button", { name: "Xác nhận tiền đã nhận" })).toHaveCount(0);
});

test("cổng bán vé dùng được trên màn hình hẹp mà không tràn ngang", async ({ page }, testInfo) => {
  await page.setViewportSize({ width: 390, height: 844 });
  await mockCounter(page, { anonymous: true });
  await page.goto("/auth/counter/login");
  await expect(page.getByRole("heading", { name: "Đăng nhập bán vé tại quầy" })).toBeVisible();
  expect(await page.evaluate(() => document.documentElement.scrollWidth <= window.innerWidth)).toBe(true);
  await page.getByPlaceholder("nhaxe/nv.banve").fill("nhaxe/nv.banve");
  await page.getByPlaceholder("Nhập mật khẩu").fill("counter-test-password");
  await page.getByRole("button", { name: "Đăng nhập", exact: true }).click();
  await expect(page.getByRole("heading", { name: "Bán vé tại quầy", exact: true })).toBeVisible();
  expect(await page.evaluate(() => document.documentElement.scrollWidth <= window.innerWidth)).toBe(true);
  await page.screenshot({ path: testInfo.outputPath("counter-mobile.png"), fullPage: true });
});
