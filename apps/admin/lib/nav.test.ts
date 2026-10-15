import { describe, expect, it } from "vitest";

import { NAV_GROUPS, navItemOf } from "./nav";

describe("thanh bên Admin", () => {
  it("đủ 16 mục theo Figma, không trùng đường dẫn", () => {
    const items = NAV_GROUPS.flatMap((group) => group.items);
    expect(items).toHaveLength(16);
    expect(new Set(items.map((item) => item.href)).size).toBe(16);
    expect(NAV_GROUPS.map((group) => group.label)).toEqual([
      undefined,
      "Đối tác & người dùng",
      "Danh mục & chính sách",
      "Tài chính",
      "Hỗ trợ & nội dung",
      "Hệ thống"
    ]);
  });

  it("tìm mục theo đường dẫn, kể cả route con; trang chủ và đường lạ → không có", () => {
    expect(navItemOf("/operators")?.label).toBe("Nhà xe & KYC");
    expect(navItemOf("/operators/applications/abc")?.label).toBe("Nhà xe & KYC");
    expect(navItemOf("/audit-logs")?.label).toBe("Nhật ký audit");
    expect(navItemOf("/")).toBeUndefined();
    expect(navItemOf("/khong-co")).toBeUndefined();
    expect(navItemOf("/operatorsx")).toBeUndefined();
  });
});
