import { HttpException, HttpStatus, Inject, Injectable } from "@nestjs/common";
import type { CounterCommissionOverview, CounterCommissionQuery, CounterCommissionSettlement, CounterCommissionSettlementInput } from "@vexenhanh/types";
import { AuditService, AuditWriteError } from "../audit/audit.service";
import { PrismaService, transactionDeadline, type DbTransaction } from "../database/prisma.service";
import type { VerifiedAccessToken } from "../iam/auth/token.service";
import type { Authorization } from "../iam/role/authorization";
import { permissionDenied } from "../iam/role/authorization.errors";
import { policyServiceUnavailable } from "../policy/policy.errors";

type SettlementRow = Omit<CounterCommissionSettlement, "amount" | "createdAt"> & { amount: bigint; createdAt: Date };

/** Theo dõi phí quầy nhà xe còn phải trả và các khoản Platform đã thu thủ công. */
@Injectable()
export class CounterCommissionService {
  constructor(@Inject(PrismaService) private readonly prisma: PrismaService, @Inject(AuditService) private readonly audit: AuditService) {}

  /** Báo cáo tổng phí toàn lịch sử cùng danh sách chi tiết trong khoảng ngày đã chọn. */
  async overview(authz: Authorization, query: CounterCommissionQuery): Promise<CounterCommissionOverview> {
    const db = platform(authz, "finance:read", "finance:configure");
    return this.prisma.withScope(db, async (tx) => {
      const totals = await balances(tx, query.operatorId);
      const createdAt = { ...(query.from ? { gte: new Date(query.from) } : {}), ...(query.to ? { lt: new Date(query.to) } : {}) };
      const items = await tx.counterCommissionReceivable.findMany({ where: { operatorId: query.operatorId, createdAt }, orderBy: [{ createdAt: "desc" }, { id: "desc" }], take: 200 });
      const settlements = await tx.counterCommissionSettlement.findMany({ where: { operatorId: query.operatorId, createdAt }, orderBy: [{ createdAt: "desc" }, { id: "desc" }], take: 200 });
      return {
        operatorId: query.operatorId, accrued: totals.accrued.toString(), settled: totals.settled.toString(), outstanding: totals.outstanding.toString(),
        items: items.map((row) => ({ id: row.id, bookingId: row.bookingId, receiptId: row.receiptId, commissionRuleId: row.commissionRuleId, rateBps: row.rateBps, basis: row.basis.toString(), amount: row.amount.toString(), createdAt: row.createdAt.toISOString() })),
        settlements: settlements.map(present),
      };
    });
  }

  /** Ghi khoản Platform đã thu, không vượt phí còn phải thu; khóa chống lặp giữ nguyên kết quả sau timeout. */
  async settle(authz: Authorization, actor: Pick<VerifiedAccessToken, "sub" | "role">, input: CounterCommissionSettlementInput): Promise<CounterCommissionSettlement> {
    const db = platform(authz, "finance:configure");
    try {
      return await this.prisma.withScope(db, async (tx) => {
        const deadline = transactionDeadline(Date.now());
        const rows = await tx.$queryRaw<{ id: string }[]>`SELECT id FROM operator_profiles WHERE id = ${input.operatorId} FOR UPDATE`;
        if (!rows.length) throw failure(HttpStatus.NOT_FOUND, "OPERATOR_NOT_FOUND", "Không tìm thấy nhà xe.");
        const previous = await tx.counterCommissionSettlement.findUnique({ where: { operatorId_idempotencyKey: { operatorId: input.operatorId, idempotencyKey: input.idempotencyKey } } });
        if (previous) {
          if (previous.amount !== BigInt(input.amount) || previous.reference !== input.reference || previous.reason !== input.reason) throw failure(HttpStatus.CONFLICT, "COUNTER_SETTLEMENT_KEY_REUSED", "Khóa chống lặp đã dùng cho dữ liệu khác.");
          return present(previous);
        }
        const { outstanding } = await balances(tx, input.operatorId);
        if (BigInt(input.amount) > outstanding) throw failure(HttpStatus.CONFLICT, "COUNTER_SETTLEMENT_EXCEEDS_BALANCE", "Số tiền vượt phí quầy còn phải thu.");
        const row = await tx.counterCommissionSettlement.create({ data: { operatorId: input.operatorId, idempotencyKey: input.idempotencyKey, amount: BigInt(input.amount), reference: input.reference, reason: input.reason, createdBy: `platform:${actor.sub}` } });
        await this.audit.recordAuditEvent({ actorId: actor.sub, actorRole: actor.role, action: "counter.commission.settled", targetType: "counter_commission_settlement", targetId: row.id, operatorId: input.operatorId, reason: input.reason, after: { amount: input.amount, reference: input.reference } }, { timeoutMs: 2000, deadline });
        return present(row);
      });
    } catch (error) {
      if ((error as { code?: string })?.code === "P2002") throw failure(HttpStatus.CONFLICT, "COUNTER_SETTLEMENT_REFERENCE_USED", "Tham chiếu này đã được ghi nhận cho nhà xe.");
      if (error instanceof AuditWriteError || (error as { code?: string })?.code === "P2028") throw policyServiceUnavailable();
      throw error;
    }
  }
}

function platform(authz: Authorization, ...permissions: string[]) {
  if (authz.scope !== "any" || authz.db?.kind !== "platform" || !permissions.includes(authz.permission)) throw permissionDenied();
  return authz.db;
}

async function balances(tx: DbTransaction, operatorId: string) {
  const accrued = (await tx.counterCommissionReceivable.aggregate({ where: { operatorId }, _sum: { amount: true } }))._sum.amount ?? 0n;
  const settled = (await tx.counterCommissionSettlement.aggregate({ where: { operatorId }, _sum: { amount: true } }))._sum.amount ?? 0n;
  return { accrued, settled, outstanding: accrued - settled };
}

function present(row: SettlementRow): CounterCommissionSettlement {
  return { id: row.id, operatorId: row.operatorId, amount: row.amount.toString(), reference: row.reference, reason: row.reason, createdBy: row.createdBy, createdAt: row.createdAt.toISOString() };
}

function failure(status: HttpStatus, code: string, detail: string): HttpException {
  return new HttpException({ code, detail, title: "Counter commission error" }, status);
}
