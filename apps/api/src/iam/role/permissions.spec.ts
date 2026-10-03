import { describe, expect, it } from "vitest";
import { EmployeeRole, OperatorRole, PlatformRole } from "../../database/prisma.types";
import { can } from "./access-policy";
import { type GrantScope, PERMISSIONS, ROLE_GRANTS } from "./permissions";
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

  it("role platform chỉ có grant `any`", () => {
    for (const role of PLATFORM_SIDE) {
      for (const [permission, scope] of grantsOf(role as Role)) {
        expect(scope, `${role} → ${permission}`).toBe("any");
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
  it("đúng 3 role bắt buộc TOTP; Employee optional (defer) và Passenger không bị ép", () => {
    const mandatory = Object.values(Role).filter((role) => requiresMfa(role));
    expect(mandatory.sort()).toEqual(
      [Role.OPERATOR_OWNER, Role.PLATFORM_ADMIN, Role.PLATFORM_SUPPORT].sort(),
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
