import { afterEach, describe, expect, it, vi } from "vitest";

import { getPreview } from "./index";

describe("getPreview", () => {
  afterEach(() => {
    vi.unstubAllEnvs();
  });

  it("trả về null khi NODE_ENV là production", () => {
    vi.stubEnv("NODE_ENV", "production");
    expect(getPreview({ preview: "ideal" })).toBeNull();
    expect(getPreview(new URLSearchParams("preview=ideal"))).toBeNull();
  });

  it("trả về tên preview khi ở môi trường ngoài production", () => {
    vi.stubEnv("NODE_ENV", "development");
    expect(getPreview({ preview: "ideal" })).toBe("ideal");
    expect(getPreview({ preview: ["operator-tab"] })).toBe("operator-tab");
    expect(getPreview(new URLSearchParams("preview=empty"))).toBe("empty");
  });

  it("trả về null khi tham số preview trống hoặc không tồn tại", () => {
    vi.stubEnv("NODE_ENV", "development");
    expect(getPreview(undefined)).toBeNull();
    expect(getPreview(null)).toBeNull();
    expect(getPreview({})).toBeNull();
    expect(getPreview({ preview: "" })).toBeNull();
    expect(getPreview({ preview: "   " })).toBeNull();
    expect(getPreview(new URLSearchParams())).toBeNull();
  });
});
