import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";
import { registerAccount, requestLoginOtp, revokeAllOtherSessions, updateNotificationSettings, verifyOtp, submitTripReview } from "./auth";
import { ACCESS_COOKIE, REFRESH_COOKIE } from "./api";

const mocks = vi.hoisted(() => ({ values: new Map<string, string>(), set: vi.fn(), remove: vi.fn() }));
vi.mock("next/headers", () => ({
  cookies: async () => ({ get: (name: string) => mocks.values.has(name) ? { value: mocks.values.get(name) } : undefined, set: mocks.set, delete: mocks.remove }),
  headers: async () => new Headers({ "user-agent": "Test browser" })
}));
const pair = { accessToken: "secret-access", refreshToken: "secret-refresh", tokenType: "Bearer", scope: "passenger", role: "PASSENGER", expiresIn: 900, refreshExpiresIn: 2592000 };

describe("marketplace auth server actions", () => {
  beforeEach(() => {
    mocks.values.clear(); mocks.set.mockReset(); mocks.remove.mockReset();
    mocks.set.mockImplementation((name: string, value: string) => { mocks.values.set(name, value); });
    mocks.remove.mockImplementation((name: string) => { mocks.values.delete(name); });
    vi.stubGlobal("fetch", vi.fn()); vi.spyOn(console, "error").mockImplementation(() => {});
  });
  afterEach(() => { vi.unstubAllGlobals(); vi.restoreAllMocks(); });

  it("gửi OTP bằng /otp/request, không bịa expiresIn mà backend không trả", async () => {
    vi.mocked(fetch).mockResolvedValue(Response.json({ status: "ok" }));
    expect(await requestLoginOtp({ email: "customer@example.com" })).toEqual({ status: "ok", data: { sent: true } });
    expect(fetch).toHaveBeenCalledWith("http://localhost:3000/v1/auth/otp/request", expect.objectContaining({ method: "POST", body: JSON.stringify({ email: "customer@example.com" }) }));
  });

  it("đăng ký email rồi xác minh riêng; không lưu ngầm hồ sơ hoặc trả token cho trình duyệt", async () => {
    vi.mocked(fetch).mockResolvedValueOnce(Response.json({ status: "ok" })).mockResolvedValueOnce(Response.json(pair));
    expect((await registerAccount({ email: "customer@example.com" })).status).toBe("ok");
    expect(JSON.parse(String(vi.mocked(fetch).mock.calls[0]?.[1]?.body))).toEqual({ email: "customer@example.com" });
    expect(mocks.set).not.toHaveBeenCalled();
    const result = await verifyOtp({ email: "customer@example.com", otp: "123456" });
    expect(result).toEqual({ status: "ok", data: { authenticated: true } });
    expect(fetch).toHaveBeenCalledTimes(2);
    expect(mocks.values.get(ACCESS_COOKIE)).toBe(pair.accessToken);
    expect(mocks.values.get(REFRESH_COOKIE)).toBe(pair.refreshToken);
    expect(JSON.stringify(result)).not.toContain("secret-");
  });

  it("chặn email đăng ký không hợp lệ trước khi gọi API", async () => {
    expect((await registerAccount({ email: "invalid" })).status).toBe("error");
    expect(fetch).not.toHaveBeenCalled();
  });

  it("cho phép đánh giá chỉ có sao theo booking, gửi comment null", async () => {
    mocks.values.set(ACCESS_COOKIE, "active");
    vi.mocked(fetch).mockResolvedValueOnce(Response.json({ reviewId: "review", status: "VISIBLE" }));
    expect(await submitTripReview({ bookingId: "11111111-1111-4111-8111-111111111111", tripId: "trip", rating: 5, content: "  " })).toEqual({ status: "ok", data: { reviewId: "review", status: "VISIBLE" } });
    expect(vi.mocked(fetch).mock.calls[0]?.[0]).toContain("/bookings/11111111-1111-4111-8111-111111111111/review");
    expect(JSON.parse(String(vi.mocked(fetch).mock.calls[0]?.[1]?.body))).toEqual({ rating: 5, comment: null });
  });

  it("chặn đánh giá sai số sao hoặc vượt giới hạn nhận xét của API", async () => {
    const input = { bookingId: "11111111-1111-4111-8111-111111111111", tripId: "trip", rating: 6, content: "" };
    expect((await submitTripReview(input)).status).toBe("error");
    expect((await submitTripReview({ ...input, rating: 5, content: "x".repeat(1001) })).status).toBe("error");
    expect(fetch).not.toHaveBeenCalled();
  });

  it("đăng xuất phiên khác qua DELETE từng family, không thu hồi phiên hiện tại", async () => {
    const item = { sessionId: "11111111-1111-4111-8111-111111111111", current: true, deviceLabel: "Browser", ipAddress: null, createdAt: "2026-10-21T00:00:00Z", lastUsedAt: "2026-10-21T00:00:00Z", expiresAt: "2026-11-21T00:00:00Z" };
    mocks.values.set(ACCESS_COOKIE, "active");
    vi.mocked(fetch).mockResolvedValueOnce(Response.json({ items: [item, { ...item, sessionId: "22222222-2222-4222-8222-222222222222", current: false }], nextCursor: null })).mockResolvedValueOnce(new Response(null, { status: 204 }));
    expect(await revokeAllOtherSessions()).toEqual({ status: "ok", data: { revokedCount: 1 } });
    expect(fetch).toHaveBeenCalledTimes(2);
    expect(vi.mocked(fetch).mock.calls[1]?.[0]).toContain("/auth/sessions/22222222-2222-4222-8222-222222222222");
  });

  it("lưu preferences từng kind đã đổi thay vì gửi shape giao diện vào API", async () => {
    mocks.values.set(ACCESS_COOKIE, "active");
    vi.mocked(fetch).mockResolvedValueOnce(Response.json({ items: [{ kind: "PROMOTION", mandatory: false, email: false, push: false }] })).mockResolvedValueOnce(Response.json({ items: [] }));
    expect(await updateNotificationSettings({ mandatoryItems: [], optionalItems: [{ id: "PROMOTION", title: "Khuyến mãi", description: "", isMandatory: false, emailEnabled: true, pushEnabled: false }] })).toEqual({ status: "ok", data: { updated: true } });
    expect(JSON.parse(String(vi.mocked(fetch).mock.calls[1]?.[1]?.body))).toEqual({ kind: "PROMOTION", email: true, push: false });
  });
});
