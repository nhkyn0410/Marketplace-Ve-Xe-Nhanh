import { describe, expect, it } from "vitest";

import { isNavItemActive, isNavPathAllowed, type NavGroup, visibleNavGroups } from "./nav";

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

describe("menu theo quyền (TASK-IAM-007)", () => {
  const icon = () => null;
  const groups: NavGroup[] = [
    { items: [{ href: "/", label: "Tổng quan", icon }] },
    {
      label: "Tài chính",
      items: [
        { href: "/payments", label: "Thanh toán", icon, permissions: ["payment:monitor"] },
        { href: "/payouts", label: "Chi trả", icon, permissions: ["payment:monitor", "payout:manage"] }
      ]
    },
    { label: "Hệ thống", items: [{ href: "/audit-logs", label: "Audit", icon, permissions: ["audit:read"] }] }
  ];

  it("bỏ mục thiếu quyền và nhóm rỗng; mục không khai quyền luôn hiện", () => {
    const visible = visibleNavGroups(groups, ["payout:manage"]);
    expect(visible.map((group) => group.items.map((item) => item.href))).toEqual([["/"], ["/payouts"]]);
  });

  it("vào thẳng URL: trang con theo mục khớp dài nhất; trang ngoài menu được vào", () => {
    expect(isNavPathAllowed(groups, "/audit-logs/abc", ["payment:monitor"])).toBe(false);
    expect(isNavPathAllowed(groups, "/payouts/1", ["payout:manage"])).toBe(true);
    expect(isNavPathAllowed(groups, "/", [])).toBe(true);
    expect(isNavPathAllowed(groups, "/account", [])).toBe(true);
  });
});
