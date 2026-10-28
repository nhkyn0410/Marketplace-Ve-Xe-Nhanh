import { describe, expect, it } from "vitest";

import type { Employee } from "./employee-api";
import {
  EMPLOYEE_ROLE,
  EMPLOYEE_ROLE_ORDER,
  EMPLOYEE_STATUS,
  EMPLOYEE_STATUS_ORDER,
  filterEmployees,
  loginName,
  passwordState,
  sortEmployees,
  usernameSuffix
} from "./employee-format";

const NOW = new Date("2026-10-14T09:00:00+07:00").getTime();

function employee(overrides: Partial<Employee> = {}): Employee {
  return {
    id: "11111111-1111-4111-8111-111111111111",
    username: "nv.tai.minh",
    contactEmail: "minh.tai@saoviet.vn",
    role: "DRIVER",
    status: "ACTIVE",
    credentialDeliveryPending: false,
    passwordChangeRequired: false,
    temporaryPasswordExpiresAt: null,
    createdAt: "2026-10-01T02:00:00.000Z",
    updatedAt: "2026-10-12T02:00:00.000Z",
    ...overrides
  };
}

describe("nhãn", () => {
  it("đủ nhãn cho mọi vai trò và trạng thái", () => {
    expect(EMPLOYEE_ROLE_ORDER.map((role) => EMPLOYEE_ROLE[role].label)).toEqual([
      "Tài xế",
      "Nhân viên soát vé",
      "Nhân viên bán vé",
      "Nhân viên hỗ trợ"
    ]);
    expect(EMPLOYEE_STATUS_ORDER.map((status) => EMPLOYEE_STATUS[status].label)).toEqual([
      "Hoạt động",
      "Bị khóa",
      "Vô hiệu hóa"
    ]);
  });

  it("tên đăng nhập đầy đủ và phần sau tiền tố nv.", () => {
    expect(loginName("saoviet", "nv.tai.minh")).toBe("saoviet/nv.tai.minh");
    expect(usernameSuffix("nv.tai.minh")).toBe("tai.minh");
    // Phần sau cũng bắt đầu bằng "nv." thì chỉ bỏ đúng một tiền tố.
    expect(usernameSuffix("nv.nv.an")).toBe("nv.an");
    expect(usernameSuffix("legacy")).toBe("legacy");
  });
});

describe("passwordState", () => {
  it("đã đổi mật khẩu", () => {
    expect(passwordState(employee(), NOW)).toEqual({
      tone: "ok",
      label: "Đã đổi mật khẩu",
      detail: "Cập nhật 12/10/2026"
    });
  });

  it("đang chờ đổi mật khẩu tạm: ghi hạn theo giờ Việt Nam", () => {
    const pending = employee({ passwordChangeRequired: true, temporaryPasswordExpiresAt: "2026-10-14T02:30:00.000Z" });
    expect(passwordState(pending, NOW)).toEqual({
      tone: "warning",
      label: "Chờ đổi mật khẩu tạm",
      detail: "Mật khẩu tạm hết hạn 14/10/2026 · 09:30"
    });
  });

  it("mật khẩu tạm hết hạn đúng mốc hoặc thiếu hạn: phải cấp lại", () => {
    const atLimit = employee({ passwordChangeRequired: true, temporaryPasswordExpiresAt: "2026-10-14T02:00:00.000Z" });
    expect(passwordState(atLimit, NOW).label).toBe("Mật khẩu tạm đã hết hạn");
    expect(passwordState(employee({ passwordChangeRequired: true }), NOW).tone).toBe("danger");
  });

  it("chưa gửi được mật khẩu tạm đứng trước mọi trạng thái mật khẩu khác", () => {
    const failed = employee({
      credentialDeliveryPending: true,
      passwordChangeRequired: true,
      temporaryPasswordExpiresAt: "2026-10-15T02:00:00.000Z"
    });
    expect(passwordState(failed, NOW)).toEqual({
      tone: "danger",
      label: "Chưa gửi được mật khẩu tạm",
      detail: "Bấm cấp lại mật khẩu để gửi lại"
    });
  });

  it("tài khoản bị khóa / vô hiệu hóa không nói về mật khẩu", () => {
    expect(passwordState(employee({ status: "LOCKED", credentialDeliveryPending: true }), NOW)).toEqual({
      tone: "muted",
      label: "—",
      detail: "Tài khoản đang bị khóa"
    });
    expect(passwordState(employee({ status: "DISABLED" }), NOW).detail).toBe("Tài khoản đã vô hiệu hóa");
  });
});

describe("lọc và sắp xếp", () => {
  const list = [
    employee({ id: "a", username: "nv.ve.lan", contactEmail: "lan.ve@saoviet.vn", role: "TICKET_STAFF" }),
    employee({ id: "b", username: "nv.tai.minh", contactEmail: "Minh.Tai@saoviet.vn" }),
    employee({ id: "c", username: "nv.hotro.nam", contactEmail: null, role: "SUPPORT_STAFF", status: "LOCKED" })
  ];
  const ids = (rows: Employee[]) => rows.map((row) => row.id);
  const all = { search: "", role: null, status: null };

  it("tìm theo tên đăng nhập hoặc email, không phân biệt hoa thường", () => {
    expect(ids(filterEmployees(list, { ...all, search: "  TAI " }))).toEqual(["b"]);
    expect(ids(filterEmployees(list, { ...all, search: "lan.ve@" }))).toEqual(["a"]);
    expect(ids(filterEmployees(list, { ...all, search: "khong-co" }))).toEqual([]);
  });

  it("lọc theo vai trò và trạng thái cùng lúc; nhân viên chưa có email vẫn lọc được", () => {
    expect(ids(filterEmployees(list, { ...all, status: "LOCKED" }))).toEqual(["c"]);
    expect(ids(filterEmployees(list, { ...all, role: "DRIVER", status: "ACTIVE" }))).toEqual(["b"]);
    expect(ids(filterEmployees(list, { search: "nam", role: "DRIVER", status: null }))).toEqual([]);
    expect(ids(filterEmployees(list, all))).toEqual(["a", "b", "c"]);
  });

  it("sắp theo tên đăng nhập, không đổi mảng gốc", () => {
    expect(ids(sortEmployees(list))).toEqual(["c", "b", "a"]);
    expect(ids(list)).toEqual(["a", "b", "c"]);
  });
});
