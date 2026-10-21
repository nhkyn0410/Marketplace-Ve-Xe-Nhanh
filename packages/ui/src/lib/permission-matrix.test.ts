import { describe, expect, it } from "vitest";

import { applyTemplate, permissionLabel, samePermissions, togglePermission } from "./permission-matrix";

describe("ma trận tick quyền (TASK-IAM-007)", () => {
  it("áp mẫu: ô được tick lấy theo mẫu, ô không được tick giữ nguyên", () => {
    const grantable = ["a", "b", "c"];
    expect(applyTemplate({ id: "t", label: "T", permissions: ["a"] }, ["b", "x"], grantable)).toEqual(["x", "a"]);
    expect(applyTemplate({ id: "all", label: "Tất cả", permissions: "all" }, [], grantable)).toEqual(["a", "b", "c"]);
    // Mẫu chứa quyền người thao tác không có → không thêm được.
    expect(applyTemplate({ id: "t", label: "T", permissions: ["z"] }, [], grantable)).toEqual([]);
  });

  it("bật / tắt một ô; so sánh không phụ thuộc thứ tự", () => {
    expect(togglePermission(["a"], "b")).toEqual(["a", "b"]);
    expect(togglePermission(["a", "b"], "a")).toEqual(["b"]);
    expect(samePermissions(["a", "b"], ["b", "a"])).toBe(true);
    expect(samePermissions(["a"], ["a", "b"])).toBe(false);
  });

  it("nhãn theo danh mục, mã lạ giữ nguyên", () => {
    const groups = [{ label: "G", items: [{ permission: "a", label: "Quyền A", description: "" }] }];
    expect(permissionLabel(groups, "a")).toBe("Quyền A");
    expect(permissionLabel(groups, "z")).toBe("z");
  });
});
