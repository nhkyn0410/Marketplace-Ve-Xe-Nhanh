import { describe, expect, it } from "vitest";
import { EmployeeRole, OperatorRole, PlatformRole } from "../../database/prisma.types";
import { can, grantedPermissions } from "./access-policy";
import { ACCOUNT_PERMISSIONS, type GrantScope, PERMISSIONS, ROLE_GRANTS, storedPermissions } from "./permissions";
import { isRole, requiresMfa, Role } from "./role";

/**
 * Bất biến của bảng quyền (TASK-IAM-003). Đây là "lưới an toàn" cho việc mở rộng role: thêm role
 * hay quyền sai kiểu là đỏ ở đây, không phải lộ ra lúc có người truy cập được dữ liệu tenant khác.
 */
const OPERATOR_SIDE: string[] = [...Object.values(OperatorRole), ...Object.values(EmployeeRole)];
const PLATFORM_SIDE: string[] = Object.values(PlatformRole);

function grantsOf(role: Role): [string, GrantScope][] {
  return Object.entries(ROLE_GRANTS[role]) as [string, GrantScope][];
}

describe("ROLE_GRANTS — bất biến", () => {
  it("mọi role trong enum Postgres đều là Role hợp lệ và có dòng trong bảng", () => {
    // Thêm giá trị vào enum Prisma (vd EmployeeRole.DISPATCHER) mà quên `Role` + `ROLE_GRANTS` → đỏ.
    for (const role of [...OPERATOR_SIDE, ...PLATFORM_SIDE, Role.PASSENGER]) {
      expect(isRole(role), `${role} chưa có trong Role`).toBe(true);
      expect(ROLE_GRANTS, `${role} chưa có dòng trong ROLE_GRANTS`).toHaveProperty(role);
    }
    expect(Object.keys(ROLE_GRANTS).sort()).toEqual(Object.values(Role).sort());
  });

  it("role phía Operator KHÔNG bao giờ có grant `any` — chỉ tenant/assigned/own", () => {
    for (const role of OPERATOR_SIDE) {
      for (const [permission, scope] of grantsOf(role as Role)) {
        expect(scope, `${role} → ${permission}`).not.toBe("any");
      }
    }
  });

  it("Passenger/Anonymous không có grant tenant/assigned (họ không có operatorId)", () => {
    for (const role of [Role.PASSENGER, Role.ANONYMOUS]) {
      for (const [permission, scope] of grantsOf(role)) {
        expect(["any", "own"], `${role} → ${permission}`).toContain(scope);
      }
    }
  });

  it("role platform chỉ có grant any, trừ tùy chọn thông báo của chính mình", () => {
    for (const role of PLATFORM_SIDE) {
      for (const [permission, scope] of grantsOf(role as Role)) {
        expect(scope, `${role} → ${permission}`).toBe(permission === "notification:manage" ? "own" : "any");
      }
    }
  });

  it("không có quyền 'chết' — quyền nào trong danh mục cũng có ít nhất một role được cấp", () => {
    for (const permission of PERMISSIONS) {
      const holders = Object.values(Role).filter((role) => ROLE_GRANTS[role][permission]);
      expect(holders.length, `${permission} không ai được cấp`).toBeGreaterThan(0);
    }
  });
});

describe("ROLE_REQUIRES_MFA — Security §5.2 (TASK-IAM-004)", () => {
  it("role dùng Operator OS / Admin bắt buộc TOTP; Employee optional (defer) và Passenger không bị ép", () => {
    const mandatory = Object.values(Role).filter((role) => requiresMfa(role));
    // OPERATOR_MANAGER (TASK-IAM-007) dùng Operator OS như Owner.
    expect(mandatory.sort()).toEqual(
      [Role.OPERATOR_OWNER, Role.OPERATOR_MANAGER, Role.PLATFORM_ADMIN, Role.PLATFORM_SUPPORT].sort(),
    );
  });

  it("mọi role platform đều bắt buộc MFA (quyền `any` toàn hệ thống)", () => {
    for (const role of PLATFORM_SIDE) {
      expect(requiresMfa(role), role).toBe(true);
    }
  });

  it("role lạ → false (TokenService đã chặn role lạ trước đó)", () => {
    expect(requiresMfa("SUPERUSER")).toBe(false);
  });
});

describe("can() — các ô quan trọng của Security §7", () => {
  const as = (role: string) => ({ role });

  it("Operator quản lý xe trong tenant; Employee chỉ xem theo phân công, không quản lý", () => {
    expect(can(as(Role.OPERATOR_OWNER), "vehicle:manage")).toEqual({ allowed: true, scope: "tenant" });
    expect(can(as(Role.DRIVER), "vehicle:read")).toEqual({ allowed: true, scope: "assigned" });
    expect(can(as(Role.DRIVER), "vehicle:manage")).toEqual({ allowed: false, reason: "not_granted" });
  });

  it("Employee check-in theo phân công; Operator chỉ xem kết quả", () => {
    expect(can(as(Role.TICKET_STAFF), "checkin:perform")).toEqual({ allowed: true, scope: "assigned" });
    expect(can(as(Role.OPERATOR_OWNER), "checkin:perform").allowed).toBe(false);
    expect(can(as(Role.OPERATOR_OWNER), "checkin:read")).toEqual({ allowed: true, scope: "tenant" });
  });

  it("KYC: Operator nộp hồ sơ mình, chỉ PLATFORM_ADMIN duyệt", () => {
    expect(can(as(Role.OPERATOR_OWNER), "kyc:submit")).toEqual({ allowed: true, scope: "tenant" });
    expect(can(as(Role.PLATFORM_ADMIN), "kyc:review")).toEqual({ allowed: true, scope: "any" });
    expect(can(as(Role.OPERATOR_OWNER), "kyc:review").allowed).toBe(false);
  });

  it("PLATFORM_SUPPORT (giả định tối thiểu quyền): không duyệt, không cấu hình, không hoàn tiền, không đọc audit", () => {
    for (const permission of ["kyc:review", "finance:configure", "refund:request", "audit:read", "account:lock"] as const) {
      expect(can(as(Role.PLATFORM_SUPPORT), permission).allowed, permission).toBe(false);
    }
  });

  it("ô 'có điều kiện' của §7 KHÔNG được cấp mặc định", () => {
    expect(can(as(Role.OPERATOR_OWNER), "booking:create").allowed).toBe(false); // "hỗ trợ nếu được phép"
    expect(can(as(Role.PLATFORM_ADMIN), "booking:create").allowed).toBe(false);
    expect(can(as(Role.OPERATOR_OWNER), "audit:read").allowed).toBe(false); // "nếu được cấp"
  });

  it("Guest (không token) tìm chuyến + đặt/thanh toán trong guest session", () => {
    expect(can(null, "trip:search")).toEqual({ allowed: true, scope: "any" });
    expect(can(null, "booking:create")).toEqual({ allowed: true, scope: "own" });
    expect(can(null, "vehicle:read").allowed).toBe(false);
  });

  it("role lạ trong JWT → không có quyền nào (fail-closed)", () => {
    for (const permission of PERMISSIONS) {
      expect(can(as("SUPER_HACKER"), permission)).toEqual({ allowed: false, reason: "unknown_role" });
    }
  });
});

describe("phân quyền theo từng tài khoản — TASK-IAM-007", () => {
  const OWNER_ONLY = ["kyc:submit", "manager:manage"] as const;

  it("quyền tick được ⊆ grant của role, không gồm tùy chọn thông báo của chính mình", () => {
    for (const [role, account] of Object.entries(ACCOUNT_PERMISSIONS)) {
      for (const permission of account.assignable) {
        expect(ROLE_GRANTS[role as Role][permission], `${role} → ${permission}`).toBeDefined();
      }
      expect(account.assignable, role).not.toContain("notification:manage");
    }
  });

  it("tài khoản quản lý: trần ⊆ quyền Owner (cùng phạm vi), không bao giờ có hồ sơ / tài khoản nhận tiền / tài khoản quản lý", () => {
    for (const [permission, scope] of grantsOf(Role.OPERATOR_MANAGER)) {
      expect(ROLE_GRANTS[Role.OPERATOR_OWNER][permission as keyof (typeof ROLE_GRANTS)[Role]], permission).toBe(scope);
    }
    for (const permission of OWNER_ONLY) {
      expect(can({ role: Role.OPERATOR_MANAGER, perms: [...PERMISSIONS] }, permission).allowed, permission).toBe(false);
    }
    expect(ACCOUNT_PERMISSIONS[Role.OPERATOR_MANAGER]?.required).toBe(true);
  });

  it("quyền quản trị tài khoản / phân quyền: `access:manage` chỉ phía Platform, `manager:manage` chỉ Owner", () => {
    const holders = (permission: (typeof PERMISSIONS)[number]) =>
      Object.values(Role).filter((role) => ROLE_GRANTS[role][permission]).sort();
    expect(holders("access:manage")).toEqual([Role.PLATFORM_ADMIN]);
    expect(holders("manager:manage")).toEqual([Role.OPERATOR_OWNER]);
  });

  it("tài khoản mang danh sách: chỉ có quyền tick được trong danh sách; quyền không tick được vẫn theo role", () => {
    const accountant = { role: Role.PLATFORM_ADMIN, perms: ["payout:manage", "payment:monitor"] };
    expect(can(accountant, "payout:manage")).toEqual({ allowed: true, scope: "any" });
    expect(can(accountant, "finance:configure")).toEqual({ allowed: false, reason: "not_granted" });
    expect(can(accountant, "access:manage").allowed).toBe(false);
    expect(can(accountant, "notification:manage")).toEqual({ allowed: true, scope: "own" });
    // Danh sách không thêm được quyền ngoài trần của role.
    expect(can({ role: Role.PLATFORM_SUPPORT, perms: ["audit:read"] }, "audit:read").allowed).toBe(false);
  });

  it("tài khoản chưa có danh sách (seed) → đủ quyền tick được; tài khoản quản lý thiếu danh sách → không có quyền tick được nào", () => {
    expect(can({ role: Role.PLATFORM_ADMIN }, "access:manage").allowed).toBe(true);
    expect(can({ role: Role.OPERATOR_MANAGER }, "trip:manage").allowed).toBe(false);
    expect(can({ role: Role.OPERATOR_MANAGER }, "notification:manage").allowed).toBe(true);
    expect(can({ role: Role.OPERATOR_MANAGER, perms: ["trip:manage"] }, "trip:manage")).toEqual({ allowed: true, scope: "tenant" });
  });

  it("danh sách rỗng ≠ không có danh sách; Owner bỏ qua danh sách (luôn đủ quyền)", () => {
    expect(can({ role: Role.PLATFORM_ADMIN, perms: [] }, "audit:read").allowed).toBe(false);
    expect(can({ role: Role.OPERATOR_OWNER, perms: [] }, "trip:manage").allowed).toBe(true);
  });

  it("grantedPermissions trả đúng quyền hiệu lực", () => {
    expect(grantedPermissions({ role: Role.OPERATOR_MANAGER, perms: ["booking:read"] })).toEqual(
      expect.arrayContaining(["booking:read", "notification:manage", "trip:search", "vehicle:read", "checkin:read"]),
    );
    expect(grantedPermissions({ role: Role.OPERATOR_MANAGER, perms: ["booking:read"] })).not.toContain("trip:manage");
    expect(grantedPermissions(null)).toEqual(expect.arrayContaining(["trip:search", "booking:create"]));
  });

  it("storedPermissions: NULL → theo role; mã lạ / sai kiểu bị bỏ (chỉ làm mất quyền, không thêm)", () => {
    expect(storedPermissions(null)).toBeNull();
    expect(storedPermissions(["trip:manage", "trip:manage", "god:mode", 1, "booking:read"])).toEqual(["booking:read", "trip:manage"]);
    expect(storedPermissions({ "trip:manage": true })).toEqual([]);
  });
});
