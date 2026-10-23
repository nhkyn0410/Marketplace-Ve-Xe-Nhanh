import { describe, expect, it } from "vitest";

import { ApiError } from "../auth/api-client";
import {
  ALL_MANAGER_PERMISSIONS,
  describeManagerError,
  MANAGER_TEMPLATES,
  managerPermissionSummary,
  managerReasonError,
  managerUsernameError
} from "./manager-format";

describe("tài khoản quản lý nhà xe (TASK-IAM-007)", () => {
  it("danh mục đủ 8 quyền tick được, không trùng; mẫu chỉ dùng quyền trong danh mục", () => {
    expect(new Set(ALL_MANAGER_PERMISSIONS).size).toBe(8);
    expect(ALL_MANAGER_PERMISSIONS).not.toContain("kyc:submit");
    expect(ALL_MANAGER_PERMISSIONS).not.toContain("manager:manage");
    for (const template of MANAGER_TEMPLATES) {
      if (template.permissions !== "all") {
        for (const permission of template.permissions) {
          expect(ALL_MANAGER_PERMISSIONS, `${template.id} → ${permission}`).toContain(permission);
        }
      }
    }
  });

  it("tên đăng nhập: chữ thường 3–40 ký tự, cấm tiền tố nhân viên `nv.`", () => {
    expect(managerUsernameError("ke-toan")).toBeNull();
    expect(managerUsernameError(" Ke.Toan ")).toBeNull();
    expect(managerUsernameError("nv.ketoan")).toContain("nv.");
    expect(managerUsernameError("ab")).not.toBeNull();
  });

  it("lý do 3–500 ký tự; tóm tắt cột Quyền", () => {
    expect(managerReasonError("ab")).not.toBeNull();
    expect(managerReasonError("Kế toán mới")).toBeNull();
    expect(managerPermissionSummary([])).toBe("Chưa có quyền");
    expect(managerPermissionSummary(["finance:read"])).toBe("1 quyền");
    expect(managerPermissionSummary(ALL_MANAGER_PERMISSIONS)).toBe("Đủ quyền quản lý");
  });

  it("lỗi: trùng tên → ô tên đăng nhập; tài khoản đổi ở nơi khác → tải lại danh sách", () => {
    expect(describeManagerError(new ApiError(409, "ACCOUNT_USERNAME_CONFLICT", "x"))).toMatchObject({ field: "username" });
    expect(describeManagerError(new ApiError(409, "ACCOUNT_STATE_CONFLICT", "x"))).toMatchObject({ refresh: true });
    expect(describeManagerError(new Error("mạng")).message).toContain("kết nối");
  });
});
