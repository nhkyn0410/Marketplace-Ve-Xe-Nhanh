import { HttpException, Inject, Injectable, Logger } from "@nestjs/common";
import type { DbScope } from "../database/db-scope";
import { PrismaService, type DbTransaction } from "../database/prisma.service";
import { maskEmail } from "../external/notification/email-notifier";
import type { VerifiedAccessToken } from "../iam/auth/token.service";
import type { Authorization } from "../iam/role/authorization";
import { deviceLabel, maskIpAddress } from "../iam/session/session.service";
import { auditLogNotFound, auditLogUnavailable } from "./audit-log.errors";
import { AuditService, isFailureAction, type AuditRecord, type AuditSearchFilter } from "./audit.service";
import {
  AUDIT_ACTOR_ROLES,
  AUDIT_MODULES,
  type AuditActorType,
  type AuditLogDetail,
  type AuditLogItem,
  type AuditLogList,
  type AuditLogListQuery,
  type AuditModule,
} from "./dto/admin-audit-log.dto";

type Actor = Pick<VerifiedAccessToken, "sub" | "role">;

const RELATED_LIMIT = 20;
const MATCH_LIMIT = 50;
const VIEW_AUDIT_TIMEOUT_MS = 2_000;
const HIDDEN = "[đã ẩn]";

/**
 * Admin tra cứu audit toàn hệ thống (UC-30, FR-ADM-16, BR-58; Figma ADM-15a/15b). Đọc Mongo `audit_event` qua
 * `AuditService`, gắn tên người thực hiện / nhà xe từ Postgres (scope `platform`), che dữ liệu nhạy cảm ở SERVER
 * trước khi trả, và ghi lại mỗi lượt xem chi tiết (UC-30 bước 8).
 */
@Injectable()
export class AdminAuditLogService {
  private readonly logger = new Logger(AdminAuditLogService.name);

  constructor(
    @Inject(PrismaService) private readonly prisma: PrismaService,
    @Inject(AuditService) private readonly audit: AuditService,
  ) {}

  async list(authz: Authorization, query: AuditLogListQuery): Promise<AuditLogList> {
    const filter = await this.toFilter(authz, query);
    const after = query.cursor ? decodeCursor(query.cursor) : undefined;
    const [rows, total] = await read(() =>
      Promise.all([this.audit.searchAuditEvents(filter, { after, limit: query.limit + 1 }), this.audit.countAuditEvents(filter)]),
    );
    const kept = rows.slice(0, query.limit);
    const last = kept.at(-1);
    return {
      items: await this.describe(authz, kept),
      nextCursor: rows.length > query.limit && last ? `${last.createdAt.toISOString()}_${last.id}` : null,
      total,
    };
  }

  async get(authz: Authorization, actor: Actor, id: string): Promise<AuditLogDetail> {
    const record = await read(() => this.audit.findAuditEvent(id));
    if (!record) {
      throw auditLogNotFound();
    }
    const related = await read(() => this.audit.listTargetAuditEvents(record.targetType, record.targetId, RELATED_LIMIT));
    const [item, ...chain] = await this.describe(authz, [record, ...related]);
    await this.audit
      .recordAuditEvent(
        { actorId: actor.sub, actorRole: actor.role, action: "audit.event.view", targetType: "audit_event", targetId: id },
        { timeoutMs: VIEW_AUDIT_TIMEOUT_MS },
      )
      .catch((error: unknown) => this.logger.warn({ event: "audit.view.record_failed", id, error }));
    const after = record.after ?? null;
    return {
      ...item!,
      before: maskSnapshot(record.before ?? null),
      after: maskSnapshot(after),
      ip: typeof after?.ip === "string" ? maskIpAddress(after.ip) : null,
      device: typeof after?.userAgent === "string" ? deviceLabel(after.userAgent) : null,
      requestId: record.requestId ?? null,
      related: chain,
    };
  }

  private async toFilter(authz: Authorization, query: AuditLogListQuery): Promise<AuditSearchFilter> {
    const filter: AuditSearchFilter = {
      from: query.from ? new Date(query.from) : undefined,
      to: query.to ? new Date(query.to) : undefined,
      result: query.result,
    };
    if (query.actorType === "SYSTEM") {
      filter.systemOnly = true;
    } else if (query.actorType) {
      filter.actorRoles = AUDIT_ACTOR_ROLES[query.actorType];
    }
    if (query.module && query.module !== "OTHER") {
      filter.actionPrefixes = AUDIT_MODULES[query.module];
    }
    if (query.q) {
      const q = query.q;
      filter.match = {
        targetId: q,
        actorIds: await this.prisma.withScope(platformDb(authz), (tx) => matchingActorIds(tx, q)),
      };
    }
    return filter;
  }

  /** Gắn tên đăng nhập người thực hiện + tên nhà xe cho một loạt bản ghi (mỗi bảng một truy vấn). */
  private async describe(authz: Authorization, records: AuditRecord[]): Promise<AuditLogItem[]> {
    const actorIds = [...new Set(records.flatMap((record) => (record.actorId ? [record.actorId] : [])))];
    const operatorIds = [...new Set(records.flatMap((record) => (record.operatorId ? [record.operatorId] : [])))];
    const { names, operators } = await this.prisma.withScope(platformDb(authz), async (tx) => ({
      names: await actorNames(tx, actorIds),
      operators: new Map(
        (
          await tx.operatorProfile.findMany({ where: { id: { in: operatorIds } }, select: { id: true, displayName: true } })
        ).map((operator) => [operator.id, operator.displayName]),
      ),
    }));
    return records.map((record) => ({
      id: record.id,
      createdAt: record.createdAt.toISOString(),
      actorId: record.actorId ?? null,
      actorName: record.actorId ? (names.get(record.actorId) ?? null) : null,
      actorRole: record.actorRole ?? null,
      actorType: actorTypeOf(record),
      action: record.action,
      module: moduleOf(record.action),
      result: isFailureAction(record.action) ? "FAILURE" : "SUCCESS",
      targetType: record.targetType,
      targetId: record.targetId,
      operator: record.operatorId
        ? { id: record.operatorId, name: operators.get(record.operatorId) ?? record.operatorId }
        : null,
      reason: record.reason ?? null,
    }));
  }
}

/** Lỗi đọc Mongo (chưa kết nối, hết giờ) → 503 thử lại được, thay cho 500. */
async function read<T>(work: () => Promise<T>): Promise<T> {
  try {
    return await work();
  } catch (error) {
    if (error instanceof HttpException) {
      throw error;
    }
    throw auditLogUnavailable();
  }
}

function decodeCursor(cursor: string): { at: Date; id: string } {
  const separator = cursor.lastIndexOf("_");
  return { at: new Date(cursor.slice(0, separator)), id: cursor.slice(separator + 1) };
}

function actorTypeOf(record: AuditRecord): AuditActorType {
  if (!record.actorId && !record.actorRole) {
    return "SYSTEM";
  }
  const role = record.actorRole ?? "";
  const type = (Object.keys(AUDIT_ACTOR_ROLES) as (keyof typeof AUDIT_ACTOR_ROLES)[]).find((key) =>
    (AUDIT_ACTOR_ROLES[key] as readonly string[]).includes(role),
  );
  return type ?? "UNKNOWN";
}

function moduleOf(action: string): AuditModule {
  const found = (Object.keys(AUDIT_MODULES) as (keyof typeof AUDIT_MODULES)[]).find((key) =>
    AUDIT_MODULES[key].some((prefix) => action.startsWith(prefix)),
  );
  return found ?? "OTHER";
}

/** Tên hiển thị của người thực hiện theo namespace đăng nhập (ADR-017); hành khách hiện email đã che. */
async function actorNames(tx: DbTransaction, ids: string[]): Promise<Map<string, string>> {
  const names = new Map<string, string>();
  if (ids.length === 0) {
    return names;
  }
  const where = { id: { in: ids } };
  for (const row of await tx.platformAccount.findMany({ where, select: { id: true, username: true } })) {
    names.set(row.id, `platform/${row.username}`);
  }
  for (const row of await tx.operatorAccount.findMany({ where, select: { id: true, operatorSlug: true, username: true } })) {
    names.set(row.id, `${row.operatorSlug}/${row.username}`);
  }
  for (const row of await tx.employeeAccount.findMany({
    where,
    select: { id: true, username: true, operator: { select: { operatorSlug: true } } },
  })) {
    names.set(row.id, `${row.operator.operatorSlug}/${row.username}`);
  }
  for (const row of await tx.user.findMany({ where, select: { id: true, email: true } })) {
    names.set(row.id, maskEmail(row.email));
  }
  return names;
}

/**
 * Ô tìm theo tài khoản: `platform/khanh`, `saoviet/owner01`, `saoviet/` hoặc một phần tên đăng nhập / email hành
 * khách. Mỗi bảng tối đa 50 tài khoản; `%`, `_` là ký tự thường.
 */
async function matchingActorIds(tx: DbTransaction, q: string): Promise<string[]> {
  const slash = q.indexOf("/");
  const scope = slash >= 0 ? q.slice(0, slash).toLowerCase() : null;
  const name = (slash >= 0 ? q.slice(slash + 1) : q).replace(/[\\%_]/g, "\\$&");
  const username = { contains: name, mode: "insensitive" as const };
  const ids: string[] = [];
  if (scope === null || scope === "platform") {
    ids.push(...(await tx.platformAccount.findMany({ where: { username }, select: { id: true }, take: MATCH_LIMIT })).map((row) => row.id));
  }
  if (scope !== "platform") {
    const operatorAccounts = await tx.operatorAccount.findMany({
      where: { username, ...(scope ? { operatorSlug: scope } : {}) },
      select: { id: true },
      take: MATCH_LIMIT,
    });
    const employees = await tx.employeeAccount.findMany({
      where: { username, ...(scope ? { operator: { operatorSlug: scope } } : {}) },
      select: { id: true },
      take: MATCH_LIMIT,
    });
    ids.push(...operatorAccounts.map((row) => row.id), ...employees.map((row) => row.id));
  }
  if (scope === null) {
    ids.push(
      ...(await tx.user.findMany({ where: { email: { contains: name, mode: "insensitive" } }, select: { id: true }, take: MATCH_LIMIT })).map(
        (row) => row.id,
      ),
    );
  }
  return ids;
}

/** Che trường nhạy cảm trong ảnh chụp trước / sau theo tên trường, đệ quy (Security §10, UC-30 bước 5). */
export function maskSnapshot(snapshot: Record<string, unknown> | null): Record<string, unknown> | null {
  if (!snapshot) {
    return null;
  }
  return Object.fromEntries(Object.entries(snapshot).map(([key, value]) => [key, maskValue(key, value)]));
}

function maskValue(key: string, value: unknown): unknown {
  if (value === null || value === undefined) {
    return value ?? null;
  }
  if (/(password|secret|token|otp|hash)/i.test(key)) {
    return HIDDEN;
  }
  if (Array.isArray(value)) {
    return value.map((item) => maskValue(key, item));
  }
  if (value instanceof Date) {
    return value.toISOString();
  }
  if (typeof value === "object") {
    return maskSnapshot(value as Record<string, unknown>);
  }
  if (typeof value !== "string") {
    return value;
  }
  if (/email/i.test(key)) {
    return maskEmail(value);
  }
  if (/phone/i.test(key)) {
    return value.length > 3 ? `${"•".repeat(value.length - 3)}${value.slice(-3)}` : "•••";
  }
  if (/(bankAccount|accountNumber)/i.test(key)) {
    return `••••${value.slice(-4)}`;
  }
  if (key === "ip") {
    return maskIpAddress(value) ?? HIDDEN;
  }
  if (key === "userAgent") {
    return deviceLabel(value);
  }
  return value;
}

function platformDb(authz: Authorization): DbScope {
  if (authz.db?.kind !== "platform") {
    // Lỗi lập trình: route Admin thiếu `@Authorize` với quyền phạm vi `any`.
    throw new Error("Route Admin nhật ký audit cần ngữ cảnh DB platform.");
  }
  return authz.db;
}
