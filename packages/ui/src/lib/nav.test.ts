import { describe, expect, it } from "vitest";

import { isNavItemActive } from "./nav";

describe("isNavItemActive", () => {
  it("trang chủ chỉ active khi đúng `/`", () => {
    expect(isNavItemActive("/", "/")).toBe(true);
    expect(isNavItemActive("/trips", "/")).toBe(false);
  });

  it("mục thường active cho chính nó và route con", () => {
    expect(isNavItemActive("/trips", "/trips")).toBe(true);
    expect(isNavItemActive("/trips/123/edit", "/trips")).toBe(true);
  });

  it("không active nhầm với route chỉ trùng tiền tố chuỗi", () => {
    expect(isNavItemActive("/trips-archive", "/trips")).toBe(false);
    expect(isNavItemActive("/payouts", "/payments")).toBe(false);
  });
});
