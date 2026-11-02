import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";
import { ACCESS_COOKIE, REFRESH_COOKIE } from "./api";
import { refreshSessionIfNeeded } from "./session";

const mocks = vi.hoisted(() => ({ values: new Map<string, string>(), set: vi.fn(), remove: vi.fn() }));
vi.mock("next/headers", () => ({
  cookies: async () => ({ get: (name: string) => mocks.values.has(name) ? { value: mocks.values.get(name) } : undefined, set: mocks.set, delete: mocks.remove }),
  headers: async () => new Headers({ "user-agent": "Test browser" })
}));
const pair = { accessToken: "new-access", refreshToken: "new-refresh", tokenType: "Bearer", scope: "passenger", role: "PASSENGER", expiresIn: 900, refreshExpiresIn: 2592000 };

describe("marketplace refresh rotation", () => {
  beforeEach(() => {
    mocks.values.clear(); mocks.set.mockReset(); mocks.remove.mockReset();
    mocks.set.mockImplementation((name: string, value: string) => { mocks.values.set(name, value); });
    mocks.remove.mockImplementation((name: string) => { mocks.values.delete(name); });
    vi.stubGlobal("fetch", vi.fn()); vi.spyOn(console, "error").mockImplementation(() => {});
  });
  afterEach(() => { vi.unstubAllGlobals(); vi.restoreAllMocks(); });

  it("hai action đồng thời chỉ xoay một lần và cùng ghi cookie httpOnly mới", async () => {
    mocks.values.set(REFRESH_COOKIE, "rotation-concurrent");
    vi.mocked(fetch).mockResolvedValue(Response.json(pair));
    const results = await Promise.all([refreshSessionIfNeeded(), refreshSessionIfNeeded()]);
    expect(fetch).toHaveBeenCalledTimes(1);
    expect(results).toEqual([{ status: "ok", data: { rotated: true } }, { status: "ok", data: { rotated: true } }]);
    expect(mocks.set).toHaveBeenCalledWith(ACCESS_COOKIE, pair.accessToken, expect.objectContaining({ httpOnly: true, sameSite: "lax", path: "/", maxAge: 900 }));
    expect(mocks.set).toHaveBeenCalledWith(REFRESH_COOKIE, pair.refreshToken, expect.objectContaining({ httpOnly: true, maxAge: pair.refreshExpiresIn }));
    expect(JSON.stringify(results)).not.toContain(pair.accessToken);
    expect(JSON.stringify(results)).not.toContain(pair.refreshToken);
  });

  it("giữ cookie khi API báo lỗi tạm 503 và không gửi lại refresh cũ ngay", async () => {
    mocks.values.set(REFRESH_COOKIE, "rotation-temporary");
    vi.mocked(fetch).mockResolvedValue(new Response(null, { status: 503 }));
    expect((await refreshSessionIfNeeded()).status).toBe("error");
    expect(mocks.remove).not.toHaveBeenCalled();
    expect(fetch).toHaveBeenCalledTimes(1);
  });

  it("xóa cookie khi refresh bị từ chối, không tái sử dụng token", async () => {
    mocks.values.set(REFRESH_COOKIE, "rotation-expired");
    vi.mocked(fetch).mockResolvedValue(new Response(null, { status: 401 }));
    expect((await refreshSessionIfNeeded()).status).toBe("error");
    expect(mocks.remove).toHaveBeenCalledWith(REFRESH_COOKIE);
    expect(mocks.remove).toHaveBeenCalledWith(ACCESS_COOKIE);
    expect(fetch).toHaveBeenCalledTimes(1);
  });

  it("không dùng lại token sau lỗi mạng có kết quả xoay không xác định", async () => {
    mocks.values.set(REFRESH_COOKIE, "rotation-unknown");
    vi.mocked(fetch).mockRejectedValue(new Error("connection lost"));
    expect((await refreshSessionIfNeeded()).status).toBe("error");
    expect(mocks.remove).toHaveBeenCalledWith(REFRESH_COOKIE);
    expect(fetch).toHaveBeenCalledTimes(1);
  });

  it("không refresh khi access cookie còn hiệu lực", async () => {
    mocks.values.set(ACCESS_COOKIE, "existing-access");
    mocks.values.set(REFRESH_COOKIE, "existing-refresh");
    expect(await refreshSessionIfNeeded()).toEqual({ status: "ok", data: { rotated: false } });
    expect(fetch).not.toHaveBeenCalled();
  });
});
