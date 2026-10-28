import { randomUUID } from "node:crypto";
import { afterAll, beforeAll, describe, expect, it, vi } from "vitest";
import { parseAppConfig } from "../config/env.config";
import { tenantScope } from "../database/db-scope";
import { PrismaService } from "../database/prisma.service";
import type { Authorization } from "../iam/role/authorization";
import { SalesOfficeService } from "./sales-office.service";

const url = process.env.DATABASE_URL;
const required = process.env.REQUIRE_DB_TESTS === "1";
const authz = (operatorId: string): Authorization => ({ permission: "office:manage", scope: "tenant", db: tenantScope(operatorId) });
async function codeOf(promise: Promise<unknown>) { try { await promise; return null; } catch (error) { return (error as { getResponse?: () => { code?: string } }).getResponse?.().code; } }

describe.skipIf(!url && !required)("Văn phòng bán vé — Postgres thật và RLS", () => {
  let prisma: PrismaService;
  let offices: SalesOfficeService;
  const a = randomUUID(); const b = randomUUID(); const employee = randomUUID(); const driver = randomUUID(); const other = randomUUID();
  const owner = { sub: randomUUID(), role: "OPERATOR_OWNER" };
  const staff = { sub: employee, role: "SALES_STAFF" };
  const tag = randomUUID().slice(0, 8);
  const audit = { recordAuditEvent: vi.fn(async () => undefined) };

  beforeAll(async () => {
    prisma = new PrismaService(parseAppConfig({ DATABASE_URL: url }));
    const [role] = await prisma.$queryRaw<{ rolsuper: boolean; rolbypassrls: boolean }[]>`SELECT rolsuper, rolbypassrls FROM pg_roles WHERE rolname=current_user`;
    if (!role || role.rolsuper || role.rolbypassrls) throw new Error("Office test phải chạy bằng role APP để kiểm RLS.");
    offices = new SalesOfficeService(prisma, audit as never);
    await prisma.withSystem(async (tx) => {
      await tx.operatorProfile.createMany({ data: [{ id: a, operatorSlug: `off-a-${tag}`, displayName: "A" }, { id: b, operatorSlug: `off-b-${tag}`, displayName: "B" }] });
      await tx.employeeAccount.createMany({ data: [{ id: employee, operatorId: a, username: "nv.sale", passwordHash: "x", role: "SALES_STAFF" }, { id: driver, operatorId: a, username: "nv.driver", passwordHash: "x", role: "DRIVER" }, { id: other, operatorId: b, username: "nv.sale", passwordHash: "x", role: "SALES_STAFF" }] });
    });
  });
  afterAll(async () => { await prisma?.$disconnect(); });

  it("mã duy nhất trong tenant, staff chỉ thấy văn phòng được cấp; chủ thấy cả văn phòng ngừng hoạt động", async () => {
    const first = await offices.create(owner, authz(a), { code: "FIRST", name: "Quầy một", address: "A", active: true });
    const second = await offices.create(owner, authz(a), { code: "SECOND", name: "Quầy hai", address: "B", active: true });
    expect((await offices.list(staff, { ...authz(a), permission: "office:read" })).items).toEqual([]);
    const assigned = await offices.replaceAssignments(owner, authz(a), first.id, { version: first.version, employeeIds: [employee] });
    expect((await offices.list(staff, { ...authz(a), permission: "office:read" })).items.map((office) => office.id)).toEqual([first.id]);
    expect(await codeOf(offices.get(staff, authz(a), second.id))).toBe("OFFICE_NOT_FOUND");
    expect(await codeOf(offices.create(owner, authz(a), { code: "FIRST", name: "Trùng", address: "A", active: true }))).toBe("OFFICE_CODE_CONFLICT");
    await offices.create(owner, authz(b), { code: "FIRST", name: "Khác tenant", address: "B", active: true });
    await offices.update(owner, authz(a), first.id, { code: first.code, name: first.name, address: first.address, active: false, version: assigned.version });
    expect((await offices.list(staff, authz(a))).items).toEqual([]);
    expect((await offices.list(owner, authz(a))).items).toHaveLength(2);
  });

  it("phân công chặn tài xế, nhân viên khác tenant và tài khoản đã khóa; FK ghép tự chặn lách service", async () => {
    const office = await offices.create(owner, authz(a), { code: "ASSIGN", name: "Phân công", address: "A", active: true });
    for (const employeeId of [driver, other]) expect(await codeOf(offices.replaceAssignments(owner, authz(a), office.id, { version: 0, employeeIds: [employeeId] }))).toBe("OFFICE_ASSIGNMENT_INVALID");
    await prisma.withTenant(a, (tx) => tx.employeeAccount.update({ where: { id: employee }, data: { status: "LOCKED" } }));
    expect(await codeOf(offices.replaceAssignments(owner, authz(a), office.id, { version: 0, employeeIds: [employee] }))).toBe("OFFICE_ASSIGNMENT_INVALID");
    await prisma.withTenant(a, (tx) => tx.employeeAccount.update({ where: { id: employee }, data: { status: "ACTIVE" } }));
    await expect(prisma.withSystem((tx) => tx.salesOfficeAssignment.create({ data: { operatorId: a, officeId: office.id, employeeId: other } }))).rejects.toBeDefined();
    await expect(prisma.withTenant(b, (tx) => tx.salesOffice.create({ data: { operatorId: a, code: "RLS", name: "X", address: "X" } }))).rejects.toBeDefined();
  });

  it("RLS ẩn văn phòng tenant khác cả khi truy vấn không filter; version chống ghi đè đồng thời", async () => {
    const office = await offices.create(owner, authz(a), { code: "VERSION", name: "Ban đầu", address: "A", active: true });
    expect(await prisma.withTenant(b, (tx) => tx.salesOffice.findUnique({ where: { id: office.id } }))).toBeNull();
    expect(await codeOf(offices.get(owner, authz(b), office.id))).toBe("OFFICE_NOT_FOUND");
    const updates = await Promise.allSettled(["Một", "Hai"].map((name) => offices.update(owner, authz(a), office.id, { code: office.code, name, address: "A", active: true, version: 0 })));
    expect(updates.filter((result) => result.status === "fulfilled")).toHaveLength(1);
    expect(updates.filter((result) => result.status === "rejected")).toHaveLength(1);
    expect((await offices.get(owner, authz(a), office.id)).version).toBe(1);
    expect(await codeOf(offices.create(staff, authz(a), { code: "DENY", name: "X", address: "X", active: true }))).toBe("PERMISSION_DENIED");
  });

  it("audit lỗi rollback thay đổi văn phòng", async () => {
    audit.recordAuditEvent.mockRejectedValueOnce(new Error("Audit offline"));
    expect(await codeOf(offices.create(owner, authz(a), { code: "AUDIT", name: "X", address: "X", active: true }))).toBe("SERVICE_UNAVAILABLE");
    expect(await prisma.withTenant(a, (tx) => tx.salesOffice.findFirst({ where: { code: "AUDIT" } }))).toBeNull();
  });
});
