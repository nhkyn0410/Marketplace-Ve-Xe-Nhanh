import { Inject, Injectable } from "@nestjs/common";
import { AuditService, AuditWriteError } from "../audit/audit.service";
import type { DbScope } from "../database/db-scope";
import { PrismaService, transactionDeadline, type DbTransaction } from "../database/prisma.service";
import { BankAccountStatus, EscrowEntryType, PayoutStatus } from "../database/prisma.types";
import type { VerifiedAccessToken } from "../iam/auth/token.service";
import { vndToJson } from "../fare/fare-pricing";
import type { Authorization } from "../iam/role/authorization";
import type { AdminPayoutStats, PayoutBankAccount, PayoutConfirmInput, PayoutDetail, PayoutPage } from "./dto/payout.dto";
import { payoutChecksFailed, payoutNotFound, payoutServiceUnavailable, payoutStatusInvalid, transferTimeInvalid } from "./payout.errors";
import { loadPayoutDetail, PAYOUT_SELECT, payoutChecks, toPayoutSummary } from "./payout-view";
import { vnDate } from "./payout-generation";

const AUDIT_TIMEOUT_MS = 2_000;
const VN_OFFSET_MS = 7 * 3_600_000;

type ListQuery = { period?: string; operatorId?: string; status?: PayoutStatus; q?: string; cursor?: string; limit: number };
type Actor = Pick<VerifiedAccessToken, "sub" | "role">;

/**
 * Chi trả nhà xe phía Admin (TASK-BTP-006 / ADM-002, ADR-022, LLD §6.6 bước 4–5, SRS §17.10; Figma ADM-08a–c): rà soát →
 * sẵn sàng chuyển khoản → Admin TỰ chuyển khoản → nhập mã giao dịch ngân hàng → đã chi (ghi bút toán `PAYOUT` vào sổ
 * escrow). Giữ lại / mở lại / hủy kỳ (hủy thì bút toán quay về kỳ sau). Mọi thao tác: khoá dòng kỳ chi trả, ghi lịch sử +
 * audit (lệnh cuối trong transaction — Mongo lỗi → 503, không đổi gì). Xác nhận đã chi + xem đầy đủ số tài khoản cần xác
 * nhận lại danh tính (route).
 */
@Injectable()
export class AdminPayoutService {
  constructor(
    @Inject(PrismaService) private readonly prisma: PrismaService,
    @Inject(AuditService) private readonly audit: AuditService,
  ) {}

  async list(authz: Authorization, query: ListQuery): Promise<PayoutPage> {
    const rows = await this.prisma.withScope(platformDb(authz), async (tx) => {
      let after = {};
      if (query.cursor) {
        const cursor = await tx.payout.findUnique({ where: { id: query.cursor }, select: { id: true, createdAt: true } });
        if (!cursor) {
          return [];
        }
        after = { OR: [{ createdAt: { lt: cursor.createdAt } }, { createdAt: cursor.createdAt, id: { lt: cursor.id } }] };
      }
      return tx.payout.findMany({
        where: {
          period: query.period ? new Date(query.period) : undefined,
          operatorId: query.operatorId,
          status: query.status,
          ...(query.q
            ? { OR: [{ payoutCode: { contains: query.q.toUpperCase() } }, { operator: { displayName: { contains: query.q, mode: "insensitive" as const } } }] }
            : {}),
          ...after,
        },
        orderBy: [{ createdAt: "desc" }, { id: "desc" }],
        take: query.limit + 1,
        select: PAYOUT_SELECT,
      });
    });
    const page = rows.slice(0, query.limit);
    return { items: page.map(toPayoutSummary), nextCursor: rows.length > query.limit ? page[page.length - 1]!.id : null };
  }

  async stats(authz: Authorization, now: Date = new Date()): Promise<AdminPayoutStats> {
    const monthStart = new Date(Date.parse(`${vnDate(now).slice(0, 7)}-01T00:00:00Z`) - VN_OFFSET_MS);
    return this.prisma.withScope(platformDb(authz), async (tx) => {
      const group = async (where: object) => {
        const result = await tx.payout.aggregate({ where, _count: { _all: true }, _sum: { amount: true } });
        return { count: result._count._all, amount: vndToJson(result._sum.amount ?? 0n) };
      };
      return {
        pendingReview: await group({ status: PayoutStatus.PENDING_REVIEW }),
        readyToTransfer: await group({ status: { in: [PayoutStatus.READY_TO_TRANSFER, PayoutStatus.TRANSFERRING] } }),
        onHold: await group({ status: PayoutStatus.ON_HOLD }),
        paidThisMonth: await group({ status: PayoutStatus.PAID, paidAt: { gte: monthStart } }),
      };
    });
  }

  async get(authz: Authorization, payoutId: string): Promise<PayoutDetail> {
    const detail = await this.prisma.withScope(platformDb(authz), (tx) => loadPayoutDetail(tx, payoutId, (actor) => adminActorName(tx, actor)));
    if (!detail) {
      throw payoutNotFound();
    }
    return detail;
  }

  /** Rà soát xong: `PENDING_REVIEW → READY_TO_TRANSFER` — phải qua đủ kiểm tra trước khi chi. */
  async review(authz: Authorization, actor: Actor, payoutId: string): Promise<PayoutDetail> {
    return this.transition(authz, actor, payoutId, "payout.review", [PayoutStatus.PENDING_REVIEW], PayoutStatus.READY_TO_TRANSFER, null, async (tx, now) => {
      await requireChecks(tx, payoutId);
      return { reviewedBy: actor.sub, reviewedAt: now };
    });
  }

  /** Giữ lại (SRS §17.10 ON_HOLD) kèm lý do. */
  async hold(authz: Authorization, actor: Actor, payoutId: string, reason: string): Promise<PayoutDetail> {
    return this.transition(
      authz,
      actor,
      payoutId,
      "payout.hold",
      [PayoutStatus.PENDING_REVIEW, PayoutStatus.READY_TO_TRANSFER],
      PayoutStatus.ON_HOLD,
      reason,
      async () => ({ holdReason: reason }),
    );
  }

  /** Mở lại kỳ đang giữ → chờ rà soát; chụp lại tài khoản nhận tiền đã xác minh mới nhất. */
  async release(authz: Authorization, actor: Actor, payoutId: string): Promise<PayoutDetail> {
    return this.transition(authz, actor, payoutId, "payout.release", [PayoutStatus.ON_HOLD], PayoutStatus.PENDING_REVIEW, null, async (tx, _now, operatorId) => {
      const bank = await tx.bankAccount.findFirst({
        where: { operatorId, status: BankAccountStatus.VERIFIED },
        orderBy: [{ reviewedAt: "desc" }, { createdAt: "desc" }],
        select: { bankName: true, accountNumber: true, accountHolder: true },
      });
      return { holdReason: null, bankName: bank?.bankName ?? null, bankAccountNumber: bank?.accountNumber ?? null, bankAccountHolder: bank?.accountHolder ?? null };
    });
  }

  /**
   * Đã chuyển khoản (Figma ADM-08c): mã giao dịch ngân hàng + thời điểm theo sao kê + ghi chú → `PAID`, ghi bút toán `PAYOUT`
   * (− thực chi) vào sổ escrow. Kiểm tra trước khi chi chạy lại lần nữa (hoàn tiền có thể vừa phát sinh).
   */
  async confirm(authz: Authorization, actor: Actor, payoutId: string, input: PayoutConfirmInput): Promise<PayoutDetail> {
    return this.transition(
      authz,
      actor,
      payoutId,
      "payout.confirm",
      [PayoutStatus.READY_TO_TRANSFER, PayoutStatus.TRANSFERRING],
      PayoutStatus.PAID,
      input.note,
      async (tx, now, operatorId, payout) => {
        if (input.transferredAt > now) {
          throw transferTimeInvalid();
        }
        await requireChecks(tx, payoutId);
        await tx.escrowLedger.create({
          data: { operatorId, entryType: EscrowEntryType.PAYOUT, amount: -payout.amount, payoutId, eligibleAt: now, note: input.bankReference, createdBy: `platform:${actor.sub}`, createdAt: now },
        });
        return { bankReference: input.bankReference, transferredAt: input.transferredAt, confirmationNote: input.note, paidBy: actor.sub, paidAt: now };
      },
    );
  }

  /** Hủy kỳ chưa chi (sai dữ liệu / trùng): bút toán được trả về để vào kỳ sau. */
  async cancel(authz: Authorization, actor: Actor, payoutId: string, reason: string): Promise<PayoutDetail> {
    return this.transition(
      authz,
      actor,
      payoutId,
      "payout.cancel",
      [PayoutStatus.PENDING_REVIEW, PayoutStatus.ON_HOLD, PayoutStatus.READY_TO_TRANSFER, PayoutStatus.TRANSFERRING],
      PayoutStatus.CANCELLED,
      reason,
      async (tx) => {
        await tx.payoutItem.deleteMany({ where: { payoutId } });
        return { cancelReason: reason };
      },
    );
  }

  /** Số tài khoản đầy đủ — ghi audit TRƯỚC khi trả (Figma ADM-08b "Hiện đầy đủ số tài khoản"). */
  async revealBank(authz: Authorization, actor: Actor, payoutId: string): Promise<PayoutBankAccount> {
    return this.write(authz, async (tx, deadline) => {
      const payout = await tx.payout.findUnique({ where: { id: payoutId }, select: { operatorId: true, bankName: true, bankAccountNumber: true, bankAccountHolder: true } });
      if (!payout) {
        throw payoutNotFound();
      }
      if (!payout.bankName || !payout.bankAccountNumber || !payout.bankAccountHolder) {
        throw payoutStatusInvalid("Kỳ chi trả chưa có tài khoản nhận tiền.");
      }
      await this.record(actor, "payout.bank_reveal", payoutId, payout.operatorId, null, {}, deadline, null);
      return { bankName: payout.bankName, accountNumber: payout.bankAccountNumber, accountHolder: payout.bankAccountHolder };
    });
  }

  private async transition(
    authz: Authorization,
    actor: Actor,
    payoutId: string,
    action: string,
    from: readonly PayoutStatus[],
    to: PayoutStatus,
    reason: string | null,
    apply: (tx: DbTransaction, now: Date, operatorId: string, payout: { amount: bigint; createdAt: Date }) => Promise<Record<string, unknown>>,
  ): Promise<PayoutDetail> {
    return this.write(authz, async (tx, deadline) => {
      const now = new Date();
      const [locked] = await tx.$queryRaw<{ status: PayoutStatus; operatorId: string; amount: bigint; createdAt: Date }[]>`
        SELECT status::text AS "status", operator_id AS "operatorId", amount, created_at AS "createdAt" FROM payouts WHERE id = ${payoutId} FOR UPDATE`;
      if (!locked) {
        throw payoutNotFound();
      }
      if (!from.includes(locked.status)) {
        throw payoutStatusInvalid(`Kỳ chi trả đang ở trạng thái ${locked.status}, không thực hiện được thao tác này.`);
      }
      const data = await apply(tx, now, locked.operatorId, locked);
      await tx.payout.update({ where: { id: payoutId }, data: { ...data, status: to } });
      await tx.payoutStatusHistory.create({ data: { payoutId, operatorId: locked.operatorId, fromStatus: locked.status, toStatus: to, reason, actor: `platform:${actor.sub}`, createdAt: now } });
      const detail = (await loadPayoutDetail(tx, payoutId, (name) => adminActorName(tx, name)))!;
      // Lệnh cuối trước COMMIT, giới hạn theo hạn còn lại của transaction.
      await this.record(actor, action, payoutId, locked.operatorId, { status: locked.status }, { status: to, ...auditable(data) }, deadline, reason);
      return detail;
    });
  }

  private record(
    actor: Actor,
    action: string,
    payoutId: string,
    operatorId: string,
    before: Record<string, unknown> | null,
    after: Record<string, unknown>,
    deadline: number,
    reason: string | null,
  ): Promise<void> {
    return this.audit.recordAuditEvent(
      { actorId: actor.sub, actorRole: actor.role, action, targetType: "payout", targetId: payoutId, operatorId, before, after, ...(reason ? { reason } : {}) },
      { timeoutMs: AUDIT_TIMEOUT_MS, deadline },
    );
  }

  private async write<T>(authz: Authorization, work: (tx: DbTransaction, deadline: number) => Promise<T>): Promise<T> {
    try {
      return await this.prisma.withScope(platformDb(authz), (tx) => work(tx, transactionDeadline(Date.now())));
    } catch (error) {
      if (error instanceof AuditWriteError || (error as { code?: unknown } | null)?.code === "P2028") {
        throw payoutServiceUnavailable();
      }
      throw error;
    }
  }
}

async function requireChecks(tx: DbTransaction, payoutId: string): Promise<void> {
  const checks = await payoutChecks(tx, payoutId);
  const failed = [
    ...(checks.ledgerMatches ? [] : ["LEDGER_MISMATCH"]),
    ...(checks.noPendingRefunds ? [] : ["PENDING_REFUNDS"]),
    ...(checks.bankVerified ? [] : ["BANK_NOT_VERIFIED"]),
  ];
  if (failed.length > 0) {
    throw payoutChecksFailed(failed);
  }
}

/** Trường đưa vào audit: không ghi số tài khoản đầy đủ. */
function auditable(data: Record<string, unknown>): Record<string, unknown> {
  const { bankAccountNumber: _account, ...rest } = data;
  return Object.fromEntries(Object.entries(rest).map(([key, value]) => [key, value instanceof Date ? value.toISOString() : value]));
}

async function adminActorName(tx: DbTransaction, actor: string | null): Promise<string | null> {
  if (!actor || !actor.startsWith("platform:")) {
    return null;
  }
  const account = await tx.platformAccount.findUnique({ where: { id: actor.slice("platform:".length) }, select: { username: true } });
  return account ? `platform/${account.username}` : "Vé Xe Nhanh";
}

function platformDb(authz: Authorization): DbScope {
  if (authz.db?.kind !== "platform") {
    // Lỗi lập trình: route Admin thiếu `@Authorize` với quyền phạm vi `any`.
    throw new Error("Route Admin chi trả cần ngữ cảnh DB platform.");
  }
  return authz.db;
}
