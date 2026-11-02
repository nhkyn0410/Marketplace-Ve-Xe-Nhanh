import { Inject, Injectable } from "@nestjs/common";
import { AuditService, AuditWriteError } from "../audit/audit.service";
import type { DbScope } from "../database/db-scope";
import { PrismaService, transactionDeadline, type DbTransaction } from "../database/prisma.service";
import { OperatorStatus, PolicyRuleStatus, PolicyType, PolicyVersionStatus } from "../database/prisma.types";
import type { VerifiedAccessToken } from "../iam/auth/token.service";
import type { Authorization } from "../iam/role/authorization";
import { isPrismaUniqueConflict } from "../iam/user/account.errors";
import {
  type FareBandInput,
  type FareBandList,
  type FareBandResponse,
  type PolicyDraftCreateInput,
  type PolicyDraftInput,
  type PolicyOverview,
  type PolicyVersionResponse,
  RULE_SCHEMAS,
} from "./dto/policy.dto";
import {
  fareBandClosed,
  fareBandNotFound,
  policyEffectiveInvalid,
  policyRulesInvalid,
  policyScheduleConflict,
  policyServiceUnavailable,
  policyVersionConflict,
  policyVersionLocked,
  policyVersionNotFound,
} from "./policy.errors";
import { policyStates, ruleState } from "./policy-state";

type Actor = Pick<VerifiedAccessToken, "sub" | "role">;

const AUDIT_TIMEOUT_MS = 2_000;

const VERSION_SELECT = {
  id: true,
  type: true,
  operatorId: true,
  version: true,
  status: true,
  rules: true,
  description: true,
  changeReason: true,
  effectiveFrom: true,
  createdBy: true,
  publishedAt: true,
  createdAt: true,
  updatedAt: true,
  operator: { select: { displayName: true } },
} as const;

type VersionRow = {
  id: string;
  type: PolicyType;
  operatorId: string | null;
  version: number;
  status: PolicyVersionStatus;
  rules: unknown;
  description: string | null;
  changeReason: string | null;
  effectiveFrom: Date | null;
  createdBy: string | null;
  publishedAt: Date | null;
  createdAt: Date;
  updatedAt: Date;
  operator: { displayName: string } | null;
};

/**
 * Chính sách nền tảng có phiên bản (TASK-ADM-001 phần chính sách; FR-ADM-06/08, UC-25, AS-23; Figma ADM-06a/06b/06d):
 * hủy / hoàn tiền (mặc định + riêng nhà xe — OQ-13), giữ chỗ, chi trả. Nháp sửa tự do; kích hoạt = khóa nội dung, có
 * hiệu lực từ một thời điểm ở tương lai, cần lý do + xác nhận lại danh tính (guard); mỗi phạm vi tối đa một bản đang chờ
 * hiệu lực. Kèm khung giá trần / sàn theo dịp (FR-ADM-09, OQ-17 — chỉ cảnh báo nhà xe). Ghi + audit trong một transaction.
 */
@Injectable()
export class AdminPolicyService {
  constructor(
    @Inject(PrismaService) private readonly prisma: PrismaService,
    @Inject(AuditService) private readonly audit: AuditService,
  ) {}

  async overview(authz: Authorization, type: PolicyType, operatorId: string | undefined): Promise<PolicyOverview> {
    const scope = operatorId ?? null;
    if (scope && type !== PolicyType.CANCELLATION) {
      throw policyRulesInvalid("Chỉ chính sách hủy / hoàn tiền có phạm vi riêng theo nhà xe.");
    }
    return this.prisma.withScope(platformDb(authz), async (tx) => {
      const now = new Date();
      const [rows, operator, activeOperatorCount] = await Promise.all([
        tx.policyVersion.findMany({
          where: { type, operatorId: scope },
          orderBy: [{ version: "desc" }],
          select: VERSION_SELECT,
        }),
        scope ? tx.operatorProfile.findUnique({ where: { id: scope }, select: { displayName: true } }) : null,
        tx.operatorProfile.count({ where: { status: OperatorStatus.ACTIVE } }),
      ]);
      if (scope && !operator) {
        throw policyRulesInvalid("Nhà xe không tồn tại.");
      }
      const names = await usernames(tx, rows.map((row) => row.createdBy));
      const states = policyStates(rows, now);
      let overrides: PolicyOverview["overrides"] = [];
      if (type === PolicyType.CANCELLATION && !scope) {
        const published = await tx.policyVersion.findMany({
          where: { type, operatorId: { not: null }, status: PolicyVersionStatus.PUBLISHED },
          select: { id: true, status: true, effectiveFrom: true, operatorId: true, operator: { select: { displayName: true, operatorSlug: true } } },
        });
        const byOperator = new Map<string, typeof published>();
        for (const row of published) {
          byOperator.set(row.operatorId!, [...(byOperator.get(row.operatorId!) ?? []), row]);
        }
        overrides = [...byOperator.values()].flatMap((list) => {
          const listStates = policyStates(list, now);
          const best = list.find((row) => listStates.get(row.id) === "ACTIVE") ?? list.find((row) => listStates.get(row.id) === "SCHEDULED");
          return best
            ? [{ operatorId: best.operatorId!, operatorName: best.operator!.displayName, operatorSlug: best.operator!.operatorSlug, state: listStates.get(best.id)! }]
            : [];
        });
      }
      return {
        type,
        operatorId: scope,
        operatorName: operator?.displayName ?? null,
        versions: rows.map((row) => toVersion(row, states.get(row.id)!, names)),
        activeOperatorCount,
        overrides,
      };
    });
  }

  async get(authz: Authorization, id: string): Promise<PolicyVersionResponse> {
    return this.prisma.withScope(platformDb(authz), async (tx) => {
      const row = await tx.policyVersion.findUnique({ where: { id }, select: VERSION_SELECT });
      if (!row) {
        throw policyVersionNotFound();
      }
      return this.present(tx, row, new Date());
    });
  }

  /** Tạo nháp (số phiên bản = lớn nhất của phạm vi + 1). */
  async createDraft(authz: Authorization, actor: Actor, type: PolicyType, input: PolicyDraftCreateInput): Promise<PolicyVersionResponse> {
    if (input.operatorId && type !== PolicyType.CANCELLATION) {
      throw policyRulesInvalid("Chỉ chính sách hủy / hoàn tiền có phạm vi riêng theo nhà xe.");
    }
    const rules = parseRules(type, input.rules);
    return this.write(authz, async (tx, deadline) => {
      if (input.operatorId && !(await tx.operatorProfile.count({ where: { id: input.operatorId } }))) {
        throw policyRulesInvalid("Nhà xe không tồn tại.");
      }
      const last = await tx.policyVersion.aggregate({ where: { type, operatorId: input.operatorId }, _max: { version: true } });
      const row = await tx.policyVersion.create({
        data: {
          type,
          operatorId: input.operatorId,
          version: (last._max.version ?? 0) + 1,
          rules,
          description: input.description,
          effectiveFrom: input.effectiveFrom,
          createdBy: actor.sub,
        },
        select: VERSION_SELECT,
      });
      await this.record(actor, "policy.create", row, null, { version: row.version, rules, effectiveFrom: iso(row.effectiveFrom) }, deadline);
      return this.present(tx, row, new Date());
    }).catch((error: unknown) => {
      // Hai Admin tạo nháp cùng lúc cho một phạm vi → trùng số phiên bản.
      throw isPrismaUniqueConflict(error) ? policyVersionConflict() : error;
    });
  }

  async updateDraft(authz: Authorization, actor: Actor, id: string, input: PolicyDraftInput): Promise<PolicyVersionResponse> {
    return this.write(authz, async (tx, deadline) => {
      const before = await lockVersion(tx, id);
      if (before.status !== PolicyVersionStatus.DRAFT) {
        throw policyVersionLocked();
      }
      const rules = parseRules(before.type, input.rules);
      const row = await tx.policyVersion.update({
        where: { id },
        data: { rules, description: input.description, effectiveFrom: input.effectiveFrom },
        select: VERSION_SELECT,
      });
      await this.record(
        actor,
        "policy.update",
        row,
        { rules: before.rules, effectiveFrom: iso(before.effectiveFrom) },
        { rules, effectiveFrom: iso(row.effectiveFrom) },
        deadline,
      );
      return this.present(tx, row, new Date());
    });
  }

  /**
   * Kích hoạt nháp: thời điểm hiệu lực phải ở tương lai (không áp ngược — UC-25 A5) và phạm vi chưa có bản nào đang chờ
   * hiệu lực (A2). Nội dung khóa từ đây; booking tạo sau thời điểm hiệu lực mới chụp bản này (BR-07).
   */
  async publish(authz: Authorization, actor: Actor, id: string, changeReason: string): Promise<PolicyVersionResponse> {
    return this.write(authz, async (tx, deadline) => {
      const now = new Date();
      const draft = await lockVersion(tx, id);
      if (draft.status !== PolicyVersionStatus.DRAFT) {
        throw policyVersionLocked();
      }
      if (!draft.effectiveFrom || draft.effectiveFrom <= now) {
        throw policyEffectiveInvalid();
      }
      parseRules(draft.type, draft.rules);
      const scheduled = await tx.policyVersion.count({
        where: { type: draft.type, operatorId: draft.operatorId, status: PolicyVersionStatus.PUBLISHED, effectiveFrom: { gt: now } },
      });
      if (scheduled > 0) {
        throw policyScheduleConflict();
      }
      const row = await tx.policyVersion.update({
        where: { id },
        data: { status: PolicyVersionStatus.PUBLISHED, changeReason, publishedBy: actor.sub, publishedAt: now },
        select: VERSION_SELECT,
      });
      await this.record(
        actor,
        "policy.publish",
        row,
        { status: PolicyVersionStatus.DRAFT },
        { status: PolicyVersionStatus.PUBLISHED, version: row.version, rules: row.rules, effectiveFrom: iso(row.effectiveFrom) },
        deadline,
        changeReason,
      );
      return this.present(tx, row, now);
    }).catch((error: unknown) => {
      // Unique "một thời điểm hiệu lực mỗi phạm vi" — hai lần kích hoạt đồng thời.
      throw isPrismaUniqueConflict(error) ? policyScheduleConflict() : error;
    });
  }

  /** Hủy nháp, hoặc hủy bản đã lên lịch nhưng chưa tới hiệu lực. Bản đã có hiệu lực không hủy được. */
  async cancel(authz: Authorization, actor: Actor, id: string, reason: string): Promise<PolicyVersionResponse> {
    return this.write(authz, async (tx, deadline) => {
      const now = new Date();
      const before = await lockVersion(tx, id);
      const scheduled = before.status === PolicyVersionStatus.PUBLISHED && before.effectiveFrom! > now;
      if (before.status !== PolicyVersionStatus.DRAFT && !scheduled) {
        throw policyVersionLocked();
      }
      const row = await tx.policyVersion.update({
        where: { id },
        data: { status: PolicyVersionStatus.CANCELLED, cancelledBy: actor.sub, cancelledAt: now },
        select: VERSION_SELECT,
      });
      await this.record(actor, "policy.cancel", row, { status: before.status }, { status: PolicyVersionStatus.CANCELLED }, deadline, reason);
      return this.present(tx, row, now);
    });
  }

  // ── Khung giá trần / sàn (FR-ADM-09, OQ-17) ──

  async listFareBands(authz: Authorization): Promise<FareBandList> {
    return this.prisma.withScope(platformDb(authz), async (tx) => {
      const rows = await tx.fareBand.findMany({ orderBy: [{ effectiveFrom: "desc" }, { id: "desc" }], take: 200 });
      const names = await usernames(tx, rows.map((row) => row.createdBy));
      const now = new Date();
      return { items: rows.map((row) => toFareBand(row, now, names)) };
    });
  }

  async createFareBand(authz: Authorization, actor: Actor, input: FareBandInput): Promise<FareBandResponse> {
    const now = new Date();
    if (input.effectiveTo <= now) {
      throw policyEffectiveInvalid();
    }
    return this.write(authz, async (tx, deadline) => {
      const row = await tx.fareBand.create({
        data: {
          name: input.name,
          minPrice: input.minPrice === null ? null : BigInt(input.minPrice),
          maxPrice: input.maxPrice === null ? null : BigInt(input.maxPrice),
          effectiveFrom: input.effectiveFrom,
          effectiveTo: input.effectiveTo,
          message: input.message,
          reason: input.reason,
          createdBy: actor.sub,
        },
      });
      await this.audit.recordAuditEvent(
        {
          actorId: actor.sub,
          actorRole: actor.role,
          action: "fare_band.create",
          targetType: "fare_band",
          targetId: row.id,
          before: null,
          after: {
            name: row.name,
            minPrice: input.minPrice,
            maxPrice: input.maxPrice,
            effectiveFrom: row.effectiveFrom.toISOString(),
            effectiveTo: row.effectiveTo.toISOString(),
          },
          reason: input.reason,
        },
        { timeoutMs: AUDIT_TIMEOUT_MS, deadline },
      );
      return toFareBand(row, now, await usernames(tx, [row.createdBy]));
    });
  }

  /** Hủy khung giá chưa kết thúc: nhà xe thôi nhận cảnh báo. */
  async cancelFareBand(authz: Authorization, actor: Actor, id: string, reason: string): Promise<FareBandResponse> {
    return this.write(authz, async (tx, deadline) => {
      const now = new Date();
      const changed = await tx.fareBand.updateMany({
        where: { id, status: PolicyRuleStatus.ACTIVE, effectiveTo: { gt: now } },
        data: { status: PolicyRuleStatus.CANCELLED, cancelledBy: actor.sub, cancelledAt: now, cancelReason: reason },
      });
      if (changed.count === 0) {
        throw (await tx.fareBand.count({ where: { id } })) ? fareBandClosed() : fareBandNotFound();
      }
      const row = await tx.fareBand.findUniqueOrThrow({ where: { id } });
      await this.audit.recordAuditEvent(
        {
          actorId: actor.sub,
          actorRole: actor.role,
          action: "fare_band.cancel",
          targetType: "fare_band",
          targetId: id,
          before: { status: PolicyRuleStatus.ACTIVE },
          after: { status: PolicyRuleStatus.CANCELLED },
          reason,
        },
        { timeoutMs: AUDIT_TIMEOUT_MS, deadline },
      );
      return toFareBand(row, now, await usernames(tx, [row.createdBy]));
    });
  }

  private async present(tx: DbTransaction, row: VersionRow, now: Date): Promise<PolicyVersionResponse> {
    // Trạng thái hiển thị phụ thuộc các bản đã kích hoạt khác cùng phạm vi.
    const siblings = await tx.policyVersion.findMany({
      where: { type: row.type, operatorId: row.operatorId, status: PolicyVersionStatus.PUBLISHED },
      select: { id: true, status: true, effectiveFrom: true },
    });
    const states = policyStates([...siblings.filter((sibling) => sibling.id !== row.id), row], now);
    return toVersion(row, states.get(row.id)!, await usernames(tx, [row.createdBy]));
  }

  private record(
    actor: Actor,
    action: string,
    row: VersionRow,
    before: Record<string, unknown> | null,
    after: Record<string, unknown>,
    deadline: number,
    reason?: string,
  ): Promise<void> {
    return this.audit.recordAuditEvent(
      {
        actorId: actor.sub,
        actorRole: actor.role,
        action,
        targetType: "policy_version",
        targetId: row.id,
        ...(row.operatorId ? { operatorId: row.operatorId } : {}),
        before: before ? { type: row.type, ...before } : null,
        after: { type: row.type, ...after },
        ...(reason ? { reason } : {}),
      },
      { timeoutMs: AUDIT_TIMEOUT_MS, deadline },
    );
  }

  private async write<T>(authz: Authorization, work: (tx: DbTransaction, deadline: number) => Promise<T>): Promise<T> {
    try {
      return await this.prisma.withScope(platformDb(authz), (tx) => work(tx, transactionDeadline(Date.now())));
    } catch (error) {
      if (error instanceof AuditWriteError || (error as { code?: unknown } | null)?.code === "P2028") {
        throw policyServiceUnavailable();
      }
      throw error;
    }
  }
}

/** Kiểm nội dung theo đúng loại chính sách; trả bản đã chuẩn hoá (mốc hoàn tiền sắp giảm dần). */
function parseRules(type: PolicyType, rules: unknown): object {
  const parsed = RULE_SCHEMAS[type].safeParse(rules);
  if (!parsed.success) {
    throw policyRulesInvalid(parsed.error.issues[0]?.message ?? "Nội dung chính sách không hợp lệ.");
  }
  return parsed.data;
}

async function lockVersion(tx: DbTransaction, id: string): Promise<{
  type: PolicyType;
  operatorId: string | null;
  status: PolicyVersionStatus;
  rules: unknown;
  effectiveFrom: Date | null;
}> {
  // Khóa dòng: hai Admin thao tác cùng một phiên bản xếp hàng, người sau thấy trạng thái mới.
  const locked = await tx.$queryRaw<{ id: string }[]>`SELECT id FROM policy_versions WHERE id = ${id} FOR UPDATE`;
  if (locked.length === 0) {
    throw policyVersionNotFound();
  }
  return tx.policyVersion.findUniqueOrThrow({
    where: { id },
    select: { type: true, operatorId: true, status: true, rules: true, effectiveFrom: true },
  });
}

/** Tên đăng nhập `platform/{username}` của người tạo. */
async function usernames(tx: DbTransaction, ids: readonly (string | null)[]): Promise<Map<string, string>> {
  const wanted = [...new Set(ids.filter((id): id is string => id !== null))];
  if (wanted.length === 0) {
    return new Map();
  }
  const rows = await tx.platformAccount.findMany({ where: { id: { in: wanted } }, select: { id: true, username: true } });
  return new Map(rows.map((row) => [row.id, `platform/${row.username}`]));
}

function toVersion(row: VersionRow, state: PolicyVersionResponse["state"], names: Map<string, string>): PolicyVersionResponse {
  return {
    id: row.id,
    type: row.type,
    operatorId: row.operatorId,
    operatorName: row.operator?.displayName ?? null,
    version: row.version,
    status: row.status,
    state,
    rules: row.rules as PolicyVersionResponse["rules"],
    description: row.description,
    changeReason: row.changeReason,
    effectiveFrom: iso(row.effectiveFrom),
    createdBy: row.createdBy ? (names.get(row.createdBy) ?? null) : null,
    publishedAt: iso(row.publishedAt),
    createdAt: row.createdAt.toISOString(),
    updatedAt: row.updatedAt.toISOString(),
  };
}

function toFareBand(
  row: {
    id: string;
    name: string;
    minPrice: bigint | null;
    maxPrice: bigint | null;
    effectiveFrom: Date;
    effectiveTo: Date;
    message: string;
    reason: string;
    status: PolicyRuleStatus;
    cancelReason: string | null;
    createdBy: string | null;
    createdAt: Date;
  },
  now: Date,
  names: Map<string, string>,
): FareBandResponse {
  return {
    id: row.id,
    name: row.name,
    minPrice: row.minPrice === null ? null : Number(row.minPrice),
    maxPrice: row.maxPrice === null ? null : Number(row.maxPrice),
    effectiveFrom: row.effectiveFrom.toISOString(),
    effectiveTo: row.effectiveTo.toISOString(),
    message: row.message,
    reason: row.reason,
    status: row.status,
    state: ruleState(row, now),
    cancelReason: row.cancelReason,
    createdBy: row.createdBy ? (names.get(row.createdBy) ?? null) : null,
    createdAt: row.createdAt.toISOString(),
  };
}

const iso = (date: Date | null) => date?.toISOString() ?? null;

function platformDb(authz: Authorization): DbScope {
  if (authz.db?.kind !== "platform") {
    // Lỗi lập trình: route Admin thiếu `@Authorize` với quyền phạm vi `any`.
    throw new Error("Route Admin chính sách cần ngữ cảnh DB platform.");
  }
  return authz.db;
}
