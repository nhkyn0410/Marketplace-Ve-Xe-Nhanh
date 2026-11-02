import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";
import { apiRequest, ACCESS_COOKIE } from "./api";

const mocks = vi.hoisted(() => ({ get: vi.fn(), headers: vi.fn() }));
vi.mock("next/headers", () => ({ cookies: async () => ({ get: mocks.get }), headers: async () => new Headers({ "user-agent": "Test browser" }) }));

describe("marketplace API transport", () => {
  beforeEach(() => { vi.stubGlobal("fetch", vi.fn()); vi.spyOn(console, "error").mockImplementation(() => {}); mocks.get.mockReturnValue(undefined); });
  afterEach(() => { vi.unstubAllGlobals(); vi.restoreAllMocks(); });

  it("gửi Bearer ở máy chủ và luôn tắt cache, không chuyển cookie tới API", async () => {
    mocks.get.mockImplementation((name: string) => name === ACCESS_COOKIE ? { value: "private-access" } : undefined);
    vi.mocked(fetch).mockResolvedValue(Response.json({ userId: "p1" }));
    expect(await apiRequest("/me/profile")).toEqual({ status: "ok", data: { userId: "p1" } });
    const [url, options] = vi.mocked(fetch).mock.calls[0]!;
    expect(url).toBe("http://localhost:3000/v1/me/profile");
    expect(options?.cache).toBe("no-store");
    expect(options?.redirect).toBe("error");
    expect(new Headers(options?.headers).get("Authorization")).toBe("Bearer private-access");
    expect(new Headers(options?.headers).has("Cookie")).toBe(false);
  });

  it("coi 204 thu hồi phiên là thành công và không đọc JSON rỗng", async () => {
    vi.mocked(fetch).mockResolvedValue(new Response(null, { status: 204 }));
    expect(await apiRequest("/auth/sessions/id", { method: "DELETE" })).toEqual({ status: "ok", data: undefined });
  });

  it("đưa chi tiết RFC7807 tới giao diện và không thử lại mutation", async () => {
    vi.mocked(fetch).mockResolvedValue(Response.json({ detail: "Phiên đã hết hạn." }, { status: 401 }));
    expect(await apiRequest("/me/profile", { method: "PUT", body: "{}" })).toEqual({ status: "error", endpoint: "PUT /me/profile", message: "Phiên đã hết hạn.", httpStatus: 401 });
    expect(fetch).toHaveBeenCalledTimes(1);
  });

  it("chặn URL bên ngoài trước khi gửi Bearer", async () => {
    expect((await apiRequest("//example.com/steal")).status).toBe("error");
    expect(fetch).not.toHaveBeenCalled();
  });

  it("không nuốt tín hiệu dynamic rendering của Next để prerender thành trang lỗi cố định", async () => {
    const dynamicError = Object.assign(new Error("Dynamic server usage"), { digest: "DYNAMIC_SERVER_USAGE" });
    mocks.get.mockImplementation(() => { throw dynamicError; });
    await expect(apiRequest("/me/profile")).rejects.toBe(dynamicError);
    expect(fetch).not.toHaveBeenCalled();
  });
});
