import { describe, expect, it } from "vitest";

import { visibleNavGroups } from "@vexenhanh/ui/lib/nav";

import { NAV_GROUPS } from "./nav";

describe("thanh bên Admin", () => {
  it("16 mục theo Figma + Tuyến & chuyến (chờ duyệt 28/10/2026), không trùng đường dẫn", () => {
    const items = NAV_GROUPS.flatMap((group) => group.items);
    expect(items).toHaveLength(17);
    expect(new Set(items.map((item) => item.href)).size).toBe(17);
    expect(items.find((item) => item.href === "/routes")).toMatchObject({ label: "Tuyến & chuyến", permissions: ["user:manage"] });
    expect(items.find((item) => item.href === "/payments")?.label).toBe("Giao dịch");
    expect(NAV_GROUPS.map((group) => group.label)).toEqual([
      undefined,
      "Đối tác & người dùng",
      "Danh mục & chính sách",
      "Tài chính",
      "Hỗ trợ & nội dung",
      "Hệ thống"
    ]);
  });

  it("TASK-IAM-007: mọi mục trừ Tổng quan khai quyền; tài khoản kế toán chỉ thấy mục tài chính", () => {
    const items = NAV_GROUPS.flatMap((group) => group.items);
    expect(items.filter((item) => !item.permissions).map((item) => item.href)).toEqual(["/"]);
    const accountant = visibleNavGroups(NAV_GROUPS, ["payment:monitor", "payout:manage", "refund:manage"]);
    expect(accountant.flatMap((group) => group.items.map((item) => item.href))).toEqual(["/", "/payments", "/payouts", "/reports"]);
  });
});
