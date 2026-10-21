import { Inject, Injectable } from "@nestjs/common";
import { AuditService, AuditWriteError } from "../audit/audit.service";
import type { DbScope } from "../database/db-scope";
import { PrismaService, transactionDeadline, type DbTransaction } from "../database/prisma.service";
import { PolicyRuleStatus } from "../database/prisma.types";
import type { VerifiedAccessToken } from "../iam/auth/token.service";
import type { Authorization } from "../iam/role/authorization";
import { ruleState } from "../policy/policy-state";
import {
  commissionPeriodInvalid,
  commissionRuleLocked,
  commissionRuleNotFound,
  commissionRuleOverlap,
  policyServiceUnavailable,
} from "../policy/policy.errors";
import type {
  CommissionOverview,
  CommissionRuleCreateInput,
  CommissionRuleInput,
  CommissionRuleResponse,
} from "./dto/admin-commission.dto";

type Actor = Pick<VerifiedAccessToken, "sub" | "role">;

const AUDIT_TIMEOUT_MS = 2_000;

const RULE_SELECT = {
  id: true,
  operatorId: true,
  rateBps: true,
  effectiveFrom: true,
  effectiveTo: true,
  status: true,
  reason: true,
  cancelReason: true,
  createdBy: true,
  createdAt: true,
  operator: { select: { displayName: true, operatorSlug: true } },
} as const;

type RuleRow = {
  id: string;
  operatorId: string | null;
  rateBps: number;
  effectiveFrom: Date;
  effectiveTo: Date | null;
  status: PolicyRuleStatus;
  reason: string;
  cancelReason: string | null;
  createdBy: string | null;
  createdAt: Date;
  operator: { displayName: string; operatorSlug: string } | null;
};

/**
 * Hoa hồng (TASK-ADM-001 phần chính sách; FR-ADM-07, BR-31, OQ-18, AS-23; Figma ADM-06c): mức mặc định 5% (dữ liệu nền,
 * v1 chưa sửa trên giao diện) + mức riêng theo nhà xe có ngày hiệu lực. Không áp ngược: mức mới bắt đầu ở tương lai;
 * mức đã bắt đầu chỉ được rút ngắn ngày kết thúc. Mức riêng của một nhà xe không chồng thời gian (khóa dòng nhà xe).
 */
@Injectable()
export class AdminCommissionService {
  constructor(
    @Inject(PrismaService) private readonly prisma: PrismaService,
    @Inject(AuditService) private readonly audit: AuditService,
  ) {}

  async overview(authz: Authorization): Promise<CommissionOverview> {
    return this.prisma.withScope(platformDb(authz), async (tx) => {
      const now = new Date();
      const [defaults, overrides] = await Promise.all([
        tx.commissionRule.findMany({
          where: { operatorId: null, status: PolicyRuleStatus.ACTIVE, effectiveFrom: { lte: now } },
          orderBy: { effectiveFrom: "desc" },
          take: 1,
          select: { rateBps: true, effectiveFrom: true, effectiveTo: true },
        }),
        tx.commissionRule.findMany({
          where: { operatorId: { not: null } },
          orderBy: [{ effectiveFrom: "desc" }, { id: "desc" }],
          take: 200,
          select: RULE_SELECT,
        }),
      ]);
      const current = defaults.find((rule) => !rule.effectiveTo || rule.effectiveTo > now);
      const names = await usernames(tx, overrides.map((row) => row.createdBy));
      return {
        default: current ? { rateBps: current.rateBps, effectiveFrom: current.effectiveFrom.toISOString() } : null,
        overrides: overrides.map((row) => toRule(row, now, names)),
      };
    });
  }

  /** Thêm mức riêng cho nhà xe: bắt đầu ở tương lai, không chồng mức riêng khác của nhà xe đó. */
  async create(authz: Authorization, actor: Actor, input: CommissionRuleCreateInput): Promise<CommissionRuleResponse> {
    return this.write(authz, async (tx, deadline) => {
      const now = new Date();
      if (input.effectiveFrom <= now) {
        throw commissionPeriodInvalid();
      }
      await lockOperator(tx, input.operatorId);
      await assertNoOverlap(tx, input.operatorId, input.effectiveFrom, input.effectiveTo, null);
      const row = await tx.commissionRule.create({
        data: {
          operatorId: input.operatorId,
          rateBps: input.rateBps,
          effectiveFrom: input.effectiveFrom,
          effectiveTo: input.effectiveTo,
          reason: input.reason,
          createdBy: actor.sub,
        },
        select: RULE_SELECT,
      });
      await this.record(actor, "commission_rule.create", row, null, snapshot(row), deadline, input.reason);
      return toRule(row, now, await usernames(tx, [row.createdBy]));
    });
  }

  /**
   * Sửa mức riêng. Chưa bắt đầu: sửa tự do (vẫn phải bắt đầu ở tương lai). Đã bắt đầu: chỉ đổi ngày kết thúc (không
   * sớm hơn hiện tại) và lý do — tỷ lệ / ngày bắt đầu giữ nguyên (không áp ngược cho giao dịch đã ghi).
   */
  async update(authz: Authorization, actor: Actor, id: string, input: CommissionRuleInput): Promise<CommissionRuleResponse> {
    return this.write(authz, async (tx, deadline) => {
      const now = new Date();
      const before = await findOverride(tx, id);
      await lockOperator(tx, before.operatorId!);
      if (before.status === PolicyRuleStatus.CANCELLED || (before.effectiveTo && before.effectiveTo <= now)) {
        throw commissionRuleLocked();
      }
      if (before.effectiveFrom <= now) {
        if (input.rateBps !== before.rateBps || input.effectiveFrom.getTime() !== before.effectiveFrom.getTime()) {
          throw commissionRuleLocked();
        }
        if (input.effectiveTo && input.effectiveTo <= now) {
          throw commissionPeriodInvalid();
        }
      } else if (input.effectiveFrom <= now) {
        throw commissionPeriodInvalid();
      }
      await assertNoOverlap(tx, before.operatorId!, input.effectiveFrom, input.effectiveTo, id);
      const row = await tx.commissionRule.update({
        where: { id },
        data: { rateBps: input.rateBps, effectiveFrom: input.effectiveFrom, effectiveTo: input.effectiveTo, reason: input.reason },
        select: RULE_SELECT,
      });
      await this.record(actor, "commission_rule.update", row, snapshot(before), snapshot(row), deadline, input.reason);
      return toRule(row, now, await usernames(tx, [row.createdBy]));
    });
  }

  /** Ngừng mức riêng: chưa bắt đầu → hủy hẳn; đang áp dụng → kết thúc ngay bây giờ (nhà xe về mức mặc định). */
  async cancel(authz: Authorization, actor: Actor, id: string, reason: string): Promise<CommissionRuleResponse> {
    return this.write(authz, async (tx, deadline) => {
      const now = new Date();
      const before = await findOverride(tx, id);
      await lockOperator(tx, before.operatorId!);
      const state = ruleState(before, now);
      if (state === "CANCELLED" || state === "EXPIRED") {
        throw commissionRuleLocked();
      }
      const row = await tx.commissionRule.update({
        where: { id },
        data:
          state === "SCHEDULED"
            ? { status: PolicyRuleStatus.CANCELLED, cancelledBy: actor.sub, cancelledAt: now, cancelReason: reason }
            : // Ngừng sớm: giữ trạng thái ACTIVE (đã áp dụng thật tới bây giờ), lưu người / lý do ngừng.
              { effectiveTo: now, cancelledBy: actor.sub, cancelledAt: now, cancelReason: reason },
        select: RULE_SELECT,
      });
      await this.record(actor, "commission_rule.cancel", row, snapshot(before), snapshot(row), deadline, reason);
      return toRule(row, now, await usernames(tx, [row.createdBy]));
    });
  }

  private record(
    actor: Actor,
    action: string,
    row: RuleRow,
    before: Record<string, unknown> | null,
    after: Record<string, unknown>,
    deadline: number,
    reason: string,
  ): Promise<void> {
    return this.audit.recordAuditEvent(
      {
        actorId: actor.sub,
        actorRole: actor.role,
        action,
        targetType: "commission_rule",
        targetId: row.id,
        ...(row.operatorId ? { operatorId: row.operatorId } : {}),
        before,
        after,
        reason,
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

/** Khóa dòng nhà xe: hai lần thêm / sửa mức riêng của cùng nhà xe xếp hàng, kiểm chồng thời gian không bị lọt. */
async function lockOperator(tx: DbTransaction, operatorId: string): Promise<void> {
  const rows = await tx.$queryRaw<{ id: string }[]>`SELECT id FROM operator_profiles WHERE id = ${operatorId} FOR UPDATE`;
  if (rows.length === 0) {
    throw commissionRuleNotFound();
  }
}

async function findOverride(tx: DbTransaction, id: string): Promise<RuleRow> {
  const row = await tx.commissionRule.findUnique({ where: { id }, select: RULE_SELECT });
  // Mức mặc định (không gắn nhà xe) không sửa ở đây.
  if (!row || row.operatorId === null) {
    throw commissionRuleNotFound();
  }
  return row;
}

async function assertNoOverlap(
  tx: DbTransaction,
  operatorId: string,
  from: Date,
  to: Date | null,
  exceptId: string | null,
): Promise<void> {
  const overlapping = await tx.commissionRule.count({
    where: {
      operatorId,
      status: PolicyRuleStatus.ACTIVE,
      ...(exceptId ? { id: { not: exceptId } } : {}),
      OR: [{ effectiveTo: null }, { effectiveTo: { gt: from } }],
      ...(to ? { effectiveFrom: { lt: to } } : {}),
    },
  });
  if (overlapping > 0) {
    throw commissionRuleOverlap();
  }
}

function snapshot(row: { rateBps: number; effectiveFrom: Date; effectiveTo: Date | null }): Record<string, unknown> {
  return {
    rateBps: row.rateBps,
    effectiveFrom: row.effectiveFrom.toISOString(),
    effectiveTo: row.effectiveTo?.toISOString() ?? null,
  };
}

async function usernames(tx: DbTransaction, ids: readonly (string | null)[]): Promise<Map<string, string>> {
  const wanted = [...new Set(ids.filter((id): id is string => id !== null))];
  if (wanted.length === 0) {
    return new Map();
  }
  const rows = await tx.platformAccount.findMany({ where: { id: { in: wanted } }, select: { id: true, username: true } });
  return new Map(rows.map((row) => [row.id, `platform/${row.username}`]));
}

function toRule(row: RuleRow, now: Date, names: Map<string, string>): CommissionRuleResponse {
  return {
    id: row.id,
    operatorId: row.operatorId!,
    operatorName: row.operator!.displayName,
    operatorSlug: row.operator!.operatorSlug,
    rateBps: row.rateBps,
    effectiveFrom: row.effectiveFrom.toISOString(),
    effectiveTo: row.effectiveTo?.toISOString() ?? null,
    status: row.status,
    state: ruleState(row, now),
    reason: row.reason,
    cancelReason: row.cancelReason,
    createdBy: row.createdBy ? (names.get(row.createdBy) ?? null) : null,
    createdAt: row.createdAt.toISOString(),
  };
}

function platformDb(authz: Authorization): DbScope {
  if (authz.db?.kind !== "platform") {
    // Lỗi lập trình: route Admin thiếu `@Authorize` với quyền phạm vi `any`.
    throw new Error("Route Admin hoa hồng cần ngữ cảnh DB platform.");
  }
  return authz.db;
}
