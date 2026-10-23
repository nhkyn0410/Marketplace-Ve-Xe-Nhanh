import { z } from "zod";

export const ReconciliationRequestSchema = z.object({ requestId: z.uuid(), reason: z.string().trim().min(3).max(500) }).strict();
export const ReconciliationIssueSchema = z.object({
  checkpoint: z.string(), entityId: z.string(), operatorId: z.uuid(), expected: z.string(), actual: z.string(),
});
export const ReconciliationRecordSchema = z.object({
  runId: z.uuid(), source: z.enum(["MANUAL", "SCHEDULED"]), status: z.enum(["QUEUED", "RUNNING", "COMPLETED", "FAILED"]),
  checkpoint: z.string(), paymentsChecked: z.int(), paymentErrors: z.int(), ledgerEntriesChecked: z.int(), payoutsChecked: z.int(), issueCount: z.int(),
  issues: z.array(ReconciliationIssueSchema), error: z.string().nullable(),
  startedAt: z.iso.datetime().nullable(), finishedAt: z.iso.datetime().nullable(), createdAt: z.iso.datetime(),
});
export const ReconciliationPageSchema = z.object({ items: z.array(ReconciliationRecordSchema) });
export type ReconciliationIssue = z.infer<typeof ReconciliationIssueSchema>;
export type ReconciliationRequest = z.infer<typeof ReconciliationRequestSchema>;
export type ReconciliationRecord = z.infer<typeof ReconciliationRecordSchema>;
