import { describe, expect, it } from "vitest";

import { NAV_GROUPS } from "./nav";

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

});
