import { randomUUID } from "node:crypto";
import { Inject, Injectable } from "@nestjs/common";
import type { SalesOffice, SalesOfficeAssignmentsInput, SalesOfficeInput, SalesOfficeUpdate } from "@vexenhanh/types";
import { AuditService } from "../audit/audit.service";
import { PrismaService, type DbTransaction } from "../database/prisma.service";
import type { VerifiedAccessToken } from "../iam/auth/token.service";
import type { Authorization } from "../iam/role/authorization";
import { permissionDenied } from "../iam/role/authorization.errors";
import { requireTenant } from "../iam/role/require-tenant";
import { officeAssignmentInvalid, officeAuditUnavailable, officeCodeConflict, officeNotFound, officeVersionConflict } from "./sales-office.errors";

type Actor = Pick<VerifiedAccessToken, "sub" | "role">;
type OfficeRow = Omit<SalesOffice, "createdAt" | "updatedAt"> & { createdAt: Date; updatedAt: Date };
const SELECT = { id: true, code: true, name: true, address: true, active: true, version: true, createdAt: true, updatedAt: true } as const;

/** Quản lý nhiều văn phòng và phân công tài khoản trong phạm vi nhà xe, bảo vệ bằng bộ lọc và RLS. */
@Injectable()
export class SalesOfficeService {
  constructor(
    @Inject(PrismaService) private readonly prisma: PrismaService,
    @Inject(AuditService) private readonly audit: AuditService,
  ) {}

  /** Chủ nhà xe xem tất cả; nhân viên bán vé chỉ xem văn phòng hoạt động được phân công. */
  async list(actor: Actor, authz: Authorization): Promise<{ items: SalesOffice[] }> {
    const { db, operatorId } = requireTenant(authz);
    const visible = visibleTo(actor, operatorId);
    const rows = await this.prisma.withScope(db, (tx) => tx.salesOffice.findMany({
      where: { operatorId, ...visible }, orderBy: [{ code: "asc" }, { id: "asc" }], select: SELECT,
    }));
    return { items: rows.map(toOffice) };
  }

  /** Đọc một văn phòng trong phạm vi được phép của tài khoản. */
  async get(actor: Actor, authz: Authorization, officeId: string): Promise<SalesOffice> {
    const { db, operatorId } = requireTenant(authz);
    const visible = visibleTo(actor, operatorId);
    const row = await this.prisma.withScope(db, (tx) => tx.salesOffice.findFirst({ where: { id: officeId, operatorId, ...visible }, select: SELECT }));
    if (!row) throw officeNotFound();
    return toOffice(row);
  }

  /** Chủ nhà xe tạo văn phòng mới; mã văn phòng duy nhất trong nhà xe. */
  async create(actor: Actor, authz: Authorization, input: SalesOfficeInput): Promise<SalesOffice> {
    ownerOnly(actor);
    const { db, operatorId } = requireTenant(authz);
    try {
      return await this.prisma.withScope(db, async (tx) => {
        const row = await tx.salesOffice.create({ data: { id: randomUUID(), operatorId, ...input }, select: SELECT });
        await this.record(actor, operatorId, row.id, "operator.office.create", null, toOffice(row));
        return toOffice(row);
      });
    } catch (error) {
      if (uniqueConflict(error)) throw officeCodeConflict();
      throw error;
    }
  }

  /** Chủ nhà xe sửa hoặc ngừng hoạt động văn phòng, không xóa dữ liệu lịch sử. */
  async update(actor: Actor, authz: Authorization, officeId: string, input: SalesOfficeUpdate): Promise<SalesOffice> {
    ownerOnly(actor);
    const { db, operatorId } = requireTenant(authz);
    try {
      return await this.prisma.withScope(db, async (tx) => {
        const before = await lockOffice(tx, operatorId, officeId, input.version);
        const { version: _version, ...data } = input;
        const row = await tx.salesOffice.update({ where: { id: officeId, operatorId }, data: { ...data, version: { increment: 1 } }, select: SELECT });
        await this.record(actor, operatorId, officeId, "operator.office.update", toOffice(before), toOffice(row));
        return toOffice(row);
      });
    } catch (error) {
      if (uniqueConflict(error)) throw officeCodeConflict();
      throw error;
    }
  }

  /** Chủ nhà xe xem tài khoản đã được phân công, kể cả tài khoản bị khóa. */
  async assignments(actor: Actor, authz: Authorization, officeId: string) {
    ownerOnly(actor);
    const { db, operatorId } = requireTenant(authz);
    return this.prisma.withScope(db, async (tx) => {
      if (!(await tx.salesOffice.findFirst({ where: { id: officeId, operatorId }, select: { id: true } }))) throw officeNotFound();
      const rows = await tx.salesOfficeAssignment.findMany({ where: { officeId, operatorId }, orderBy: { employee: { username: "asc" } }, select: { employeeId: true, employee: { select: { username: true, status: true } } } });
      return { items: rows.map((row) => ({ employeeId: row.employeeId, username: row.employee.username, status: row.employee.status })) };
    });
  }

  /** Chủ nhà xe thay phân công bằng nhân viên bán vé đang hoạt động, kiểm phiên bản cùng giao dịch. */
  async replaceAssignments(actor: Actor, authz: Authorization, officeId: string, input: SalesOfficeAssignmentsInput): Promise<SalesOffice> {
    ownerOnly(actor);
    const { db, operatorId } = requireTenant(authz);
    return this.prisma.withScope(db, async (tx) => {
      await lockOffice(tx, operatorId, officeId, input.version);
      const employees = input.employeeIds.length ? await tx.$queryRaw<{ id: string; role: string; status: string }[]>`
        SELECT id, role::text AS role, status::text AS status FROM employee_accounts
        WHERE operator_id = ${operatorId} AND id = ANY(${input.employeeIds}::text[]) ORDER BY id FOR SHARE` : [];
      if (employees.length !== input.employeeIds.length || employees.some((employee) => employee.role !== "SALES_STAFF" || employee.status !== "ACTIVE")) throw officeAssignmentInvalid();
      const before = await tx.salesOfficeAssignment.findMany({ where: { officeId, operatorId }, select: { employeeId: true } });
      await tx.salesOfficeAssignment.deleteMany({ where: { officeId, operatorId } });
      if (input.employeeIds.length) await tx.salesOfficeAssignment.createMany({ data: input.employeeIds.map((employeeId) => ({ officeId, operatorId, employeeId })) });
      const row = await tx.salesOffice.update({ where: { id: officeId, operatorId }, data: { version: { increment: 1 } }, select: SELECT });
      await this.record(actor, operatorId, officeId, "operator.office.assignments", { employeeIds: before.map((item) => item.employeeId).sort() }, { employeeIds: [...input.employeeIds].sort() });
      return toOffice(row);
    });
  }

  private async record(actor: Actor, operatorId: string, targetId: string, action: string, before: Record<string, unknown> | null, after: Record<string, unknown>): Promise<void> {
    try {
      await this.audit.recordAuditEvent({ actorId: actor.sub, actorRole: actor.role, action, targetType: "sales_office", targetId, operatorId, before, after }, { timeoutMs: 2000 });
    } catch {
      throw officeAuditUnavailable();
    }
  }
}

function ownerOnly(actor: Actor): void {
  if (actor.role !== "OPERATOR_OWNER") throw permissionDenied();
}

function visibleTo(actor: Actor, operatorId: string) {
  if (actor.role === "OPERATOR_OWNER") return {};
  if (actor.role !== "SALES_STAFF") throw permissionDenied();
  return { active: true, assignments: { some: { operatorId, employeeId: actor.sub, employee: { status: "ACTIVE" as const, role: "SALES_STAFF" as const } } } };
}

async function lockOffice(tx: DbTransaction, operatorId: string, officeId: string, version: number): Promise<OfficeRow> {
  const [locked] = await tx.$queryRaw<{ id: string }[]>`SELECT id FROM sales_offices WHERE id = ${officeId} AND operator_id = ${operatorId} FOR NO KEY UPDATE`;
  if (!locked) throw officeNotFound();
  const row = await tx.salesOffice.findFirstOrThrow({ where: { id: officeId, operatorId }, select: SELECT });
  if (row.version !== version) throw officeVersionConflict();
  return row;
}

function toOffice(row: OfficeRow): SalesOffice {
  return { ...row, createdAt: row.createdAt.toISOString(), updatedAt: row.updatedAt.toISOString() };
}

function uniqueConflict(error: unknown): boolean {
  return (error as { code?: unknown } | null)?.code === "P2002";
}
