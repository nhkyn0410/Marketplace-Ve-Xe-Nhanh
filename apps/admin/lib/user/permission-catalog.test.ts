import { describe, expect, it } from "vitest";

import { PERMISSION_GROUPS, PERMISSION_TEMPLATES, permissionSummary } from "./permission-catalog";

describe("danh mục quyền tài khoản quản trị (TASK-IAM-007)", () => {
  const catalog = PERMISSION_GROUPS.flatMap((group) => group.items.map((item) => item.permission));

  it("17 quyền tick được, không trùng; mẫu chỉ dùng quyền trong danh mục", () => {
    expect(catalog).toHaveLength(17);
    expect(new Set(catalog).size).toBe(17);
    for (const templates of Object.values(PERMISSION_TEMPLATES)) {
      for (const template of templates) {
        if (template.permissions !== "all") {
          for (const permission of template.permissions) {
            expect(catalog, `${template.id} → ${permission}`).toContain(permission);
          }
        }
      }
    }
  });

  it("tóm tắt cột Quyền", () => {
    expect(permissionSummary({ role: "PLATFORM_ADMIN", permissions: catalog })).toBe("Toàn quyền");
    expect(permissionSummary({ role: "PLATFORM_ADMIN", permissions: ["audit:read"] })).toBe("1 quyền");
    expect(permissionSummary({ role: "PLATFORM_SUPPORT", permissions: ["payment:monitor", "support:manage"] })).toBe("2 quyền");
    expect(permissionSummary({ role: "PLATFORM_SUPPORT", permissions: [] })).toBe("Chưa có quyền");
  });
});
