import { describe, expect, it, vi } from "vitest";

import { failed, ok, unavailable } from "./result";

describe("lib/data/result", () => {
  it("ok() trả về đúng status ok và data", () => {
    const res = ok({ items: [1, 2, 3] });
    expect(res).toEqual({
      status: "ok",
      data: { items: [1, 2, 3] }
    });
  });

  it("unavailable() gọi console.warn đúng một lần với tên endpoint", () => {
    const spy = vi.spyOn(console, "warn").mockImplementation(() => {});

    const res = unavailable("GET /trips/search");

    expect(spy).toHaveBeenCalledTimes(1);
    expect(spy).toHaveBeenCalledWith("[marketplace] chưa có API: GET /trips/search");
    expect(res).toEqual({
      status: "unavailable",
      endpoint: "GET /trips/search"
    });

    spy.mockRestore();
  });

  it("failed() gọi console.error với tên endpoint và message", () => {
    const spy = vi.spyOn(console, "error").mockImplementation(() => {});

    const res = failed("GET /catalog/provinces", "Lỗi kết nối");

    expect(spy).toHaveBeenCalledTimes(1);
    expect(spy).toHaveBeenCalledWith("[marketplace] lỗi gọi API: GET /catalog/provinces", "Lỗi kết nối");
    expect(res).toEqual({
      status: "error",
      endpoint: "GET /catalog/provinces",
      message: "Lỗi kết nối"
    });

    spy.mockRestore();
  });
});
