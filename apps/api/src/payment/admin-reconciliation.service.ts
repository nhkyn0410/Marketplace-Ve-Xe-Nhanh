import { InjectQueue } from "@nestjs/bullmq";
import { Inject, Injectable } from "@nestjs/common";
import type { Queue } from "bullmq";
import { ReconciliationIssueSchema, type ReconciliationRecord, type ReconciliationRequest } from "@vexenhanh/types";
import { z } from "zod";
import { AuditService, AuditWriteError } from "../audit/audit.service";
import { PrismaService, transactionDeadline } from "../database/prisma.service";
import { AuthException } from "../iam/auth/auth.errors";
import type { VerifiedAccessToken } from "../iam/auth/token.service";
import type { Authorization } from "../iam/role/authorization";
import { platformDb } from "../support/support.service";
import { QUEUE_NAMES } from "../queue/queue.constants";
import { RECONCILE_JOB } from "./payment-reconciliation";

const SELECT = { id: true, source: true, status: true, checkpoint: true, paymentResult: true, ledgerEntriesChecked: true, payoutsChecked: true, issueCount: true, issues: true, error: true, startedAt: true, finishedAt: true, createdAt: true } as const;

/** Chạy lại đối soát có audit và xem kết quả bền vững trên trang Tích hợp & hệ thống. */
@Injectable()
export class AdminReconciliationService {
  constructor(@Inject(PrismaService) private readonly prisma: PrismaService, @Inject(AuditService) private readonly audit: AuditService, @InjectQueue(QUEUE_NAMES.paymentReconciliation) private readonly queue: Pick<Queue, "add">) {}

  /** Liệt kê 20 lần đối soát gần nhất, gồm các mốc và sai lệch sổ giữ hộ. */
  async list(authz: Authorization): Promise<{ items: ReconciliationRecord[] }> {
    const rows = await this.prisma.withScope(platformDb(authz), (tx) => tx.reconciliationRecord.findMany({ orderBy: { createdAt: "desc" }, take: 20, select: SELECT }));
    return { items: rows.map(recordView) };
  }

  /** Xếp hàng đối soát theo requestId chống gửi lặp; chỉ chạy sau khi đã ghi audit. */
  async run(authz: Authorization, actor: VerifiedAccessToken, input: ReconciliationRequest): Promise<ReconciliationRecord> {
    const deadline = transactionDeadline(Date.now());
    const record = await this.prisma.withScope(platformDb(authz), async (tx) => {
      await tx.$executeRaw`SELECT pg_advisory_xact_lock(hashtext(${`reconciliation:${input.requestId}`}))`;
      const previous = await tx.reconciliationRecord.findUnique({ where: { id: input.requestId } });
      if (previous) {
        if (previous.requestedBy !== actor.sub || previous.reason !== input.reason) throw new AuthException(409, "IDEMPOTENCY_CONFLICT", "Mã yêu cầu đã dùng cho lần đối soát khác.");
        return previous;
      }
      await this.audit.recordAuditEvent({ actorId: actor.sub, actorRole: actor.role, action: "system.reconciliation.run", targetType: "reconciliation", targetId: input.requestId, before: null, after: { source: "MANUAL" }, reason: input.reason }, { timeoutMs: 2000, deadline });
      return tx.reconciliationRecord.create({ data: { id: input.requestId, source: "MANUAL", status: "QUEUED", requestedBy: actor.sub, reason: input.reason } });
    }).catch((error: unknown) => {
      if (error instanceof AuditWriteError) throw new AuthException(503, "SERVICE_UNAVAILABLE", "Chưa ghi được nhật ký nên chưa chạy đối soát.");
      throw error;
    });
    if (record.status === "QUEUED") {
      try {
        await this.queue.add(RECONCILE_JOB, { runId: record.id }, { jobId: `reconcile-${record.id}`, attempts: 3, backoff: { type: "exponential", delay: 30000 }, removeOnComplete: { age: 86400 }, removeOnFail: { age: 7 * 86400 } });
      } catch {
        // Giữ QUEUED để cùng requestId có thể thử xếp hàng lại khi Redis hoạt động trở lại.
        throw new AuthException(503, "SERVICE_UNAVAILABLE", "Chưa kết nối được hàng đợi; thử gửi lại yêu cầu đối soát.");
      }
    }
    return recordView(record);
  }
}

function recordView(row: { id: string; source: string; status: string; checkpoint: string; paymentResult: unknown; ledgerEntriesChecked: number; payoutsChecked: number; issueCount: number; issues: unknown; error: string | null; startedAt: Date | null; finishedAt: Date | null; createdAt: Date }): ReconciliationRecord {
  const payment = z.object({ checked: z.int(), errors: z.int() }).safeParse(row.paymentResult);
  return { runId: row.id, source: z.enum(["MANUAL", "SCHEDULED"]).parse(row.source), status: z.enum(["QUEUED", "RUNNING", "COMPLETED", "FAILED"]).parse(row.status), checkpoint: row.checkpoint, paymentsChecked: payment.success ? payment.data.checked : 0, paymentErrors: payment.success ? payment.data.errors : 0, ledgerEntriesChecked: row.ledgerEntriesChecked, payoutsChecked: row.payoutsChecked, issueCount: row.issueCount, issues: z.array(ReconciliationIssueSchema).parse(row.issues), error: row.error, startedAt: row.startedAt?.toISOString() ?? null, finishedAt: row.finishedAt?.toISOString() ?? null, createdAt: row.createdAt.toISOString() };
}
