import { createZodDto } from "nestjs-zod";
import { z } from "zod";
import { DirectDisputeInputSchema } from "@vexenhanh/types";
import { CaseParty, DisputeDecision, DisputeEventKind, DisputeStatus, RefundStatus } from "../../database/prisma.types";
import { AssigneeFilterSchema, AttachmentInputSchema, AttachmentSchema } from "../../support/dto/support.dto";

// Tranh chấp (TASK-TRUST-001, FR-DSP-01..08, BR-50/51, UC-27; Figma ADM-09c/d/e, "Nhà xe · Hỗ trợ / Tranh chấp"). Shape AI tự đề
// xuất, chờ Khanh duyệt (`doc/task-propreties/TRUST-001-todo.md`).

const reason = z.string().trim().min(3).max(500);
/** Mở tranh chấp trực tiếp từ một đơn, không cần khiếu nại trung gian (FR-DSP-01). */
export class DirectDisputeInputDto extends createZodDto(DirectDisputeInputSchema) {}
/** Trạng thái còn mở (chưa có quyết định). */
export const OPEN_DISPUTE_STATUSES = [
  DisputeStatus.OPEN,
  DisputeStatus.WAITING_USER_EVIDENCE,
  DisputeStatus.WAITING_OPERATOR_RESPONSE,
  DisputeStatus.UNDER_REVIEW,
  DisputeStatus.ESCALATED,
] as const;

export const RequestEvidenceInputSchema = z.object({
  /** `PASSENGER` = khách của đơn (hành khách hoặc khách vãng lai), `OPERATOR` = nhà xe. */
  party: z.enum([CaseParty.PASSENGER, CaseParty.OPERATOR]),
  message: reason,
  /** Hạn phản hồi (sau hiện tại, tối đa 30 ngày). */
  dueAt: z.iso.datetime({ offset: true }),
});
export type RequestEvidenceInput = z.infer<typeof RequestEvidenceInputSchema>;
/** Yêu cầu một bên cung cấp minh chứng + hạn phản hồi (FR-DSP-03). */
export class RequestEvidenceInputDto extends createZodDto(RequestEvidenceInputSchema) {}

export const DisputeStatusInputSchema = z.object({
  status: z.enum([DisputeStatus.UNDER_REVIEW, DisputeStatus.ESCALATED, DisputeStatus.CLOSED]),
  reason,
});
export type DisputeStatusInput = z.infer<typeof DisputeStatusInputSchema>;
/** Đang xem xét / leo thang / đóng (sau quyết định). */
export class DisputeStatusInputDto extends createZodDto(DisputeStatusInputSchema) {}

export const DecisionInputSchema = z
  .object({
    decision: z.enum(DisputeDecision),
    /** VND, bắt buộc khi hoàn tiền; tối đa phần khách đã trả còn lại. */
    amount: z.int().min(1).max(100_000_000).nullable().default(null),
    reason,
  })
  .refine((input) => (input.decision === DisputeDecision.REFUND) === (input.amount !== null), {
    message: "Hoàn tiền cần số tiền; không hoàn / phương án khác thì bỏ trống.",
    path: ["amount"],
  });
export type DecisionInput = z.infer<typeof DecisionInputSchema>;
/** Ra quyết định (FR-DSP-06): hoàn tiền / không hoàn / phương án khác, kèm lý do; cần xác nhận lại danh tính. */
export class DisputeDecisionInputDto extends createZodDto(DecisionInputSchema) {}

export const EvidenceInputSchema = z.object({ body: z.string().trim().min(1).max(2000), attachments: z.array(AttachmentInputSchema).max(5).default([]) });
export type EvidenceInput = z.infer<typeof EvidenceInputSchema>;
/** Một bên gửi phản hồi / minh chứng (FR-DSP-04). */
export class EvidenceInputDto extends createZodDto(EvidenceInputSchema) {}

export class AdminDisputeListQueryDto extends createZodDto(
  z.object({
    /** `open` = mọi trạng thái chưa có quyết định. */
    status: z.union([z.enum(DisputeStatus), z.literal("open")]).optional(),
    operatorId: z.uuid().optional(),
    /** `overdue` = đang chờ một bên và đã quá hạn. */
    due: z.enum(["overdue", "upcoming"]).optional(),
    assigneeId: AssigneeFilterSchema.optional(),
    q: z.string().trim().min(1).max(50).optional(),
    cursor: z.uuid().optional(),
    limit: z.coerce.number().int().min(1).max(100).default(20),
  }),
) {}

export class OperatorDisputeListQueryDto extends createZodDto(
  z.object({ cursor: z.uuid().optional(), limit: z.coerce.number().int().min(1).max(100).default(20) }),
) {}

export const DisputeSummarySchema = z.object({
  disputeId: z.uuid(),
  disputeCode: z.string(),
  title: z.string(),
  bookingId: z.uuid(),
  bookingCode: z.string(),
  operatorId: z.uuid(),
  operatorName: z.string(),
  /** VND khách đã trả cho đơn (thanh toán thành công). */
  paidAmount: z.int(),
  status: z.enum(DisputeStatus),
  responseDueAt: z.iso.datetime().nullable(),
  overdue: z.boolean(),
  assignee: z.object({ id: z.uuid(), username: z.string() }).nullable(),
  supportTicketId: z.uuid().nullable(),
  createdAt: z.iso.datetime(),
  updatedAt: z.iso.datetime(),
});
export type DisputeSummary = z.infer<typeof DisputeSummarySchema>;

export const CustomerDisputeListSchema = z.object({ items: z.array(DisputeSummarySchema) });
/** Tranh chấp của một đơn (khách xem). */
export class CustomerDisputeListDto extends createZodDto(CustomerDisputeListSchema) {}

export const DisputePageSchema = z.object({ items: z.array(DisputeSummarySchema), nextCursor: z.uuid().nullable(), total: z.int(), open: z.int() });
export type DisputePage = z.infer<typeof DisputePageSchema>;
export class DisputePageDto extends createZodDto(DisputePageSchema) {}

export const DisputeEventSchema = z.object({
  eventId: z.uuid(),
  kind: z.enum(DisputeEventKind),
  party: z.enum(CaseParty),
  actorName: z.string(),
  fromStatus: z.enum(DisputeStatus).nullable(),
  toStatus: z.enum(DisputeStatus).nullable(),
  body: z.string().nullable(),
  target: z.enum(CaseParty).nullable(),
  dueAt: z.iso.datetime().nullable(),
  createdAt: z.iso.datetime(),
  attachments: z.array(AttachmentSchema),
});
export type DisputeEvent = z.infer<typeof DisputeEventSchema>;

export const DisputeDetailSchema = DisputeSummarySchema.extend({
  customerRequest: z.string().nullable(),
  supportTicketCode: z.string().nullable(),
  bookingTotal: z.int(),
  /** Phần khách đã trả còn hoàn được (trừ các lần hoàn đang / đã xử lý). */
  refundableAmount: z.int(),
  customerName: z.string(),
  trip: z.object({
    tripId: z.uuid(),
    routeName: z.string(),
    departureAt: z.iso.datetime(),
    departedAt: z.iso.datetime().nullable(),
    vehiclePlateNumber: z.string().nullable(),
  }),
  /** Lần check-in đầu của vé thuộc đơn (dữ liệu hệ thống, Figma ADM-09d). */
  firstCheckInAt: z.iso.datetime().nullable(),
  tripChangeNotified: z.boolean(),
  cancellationTiers: z.array(z.object({ minHoursBefore: z.number(), refundPercent: z.number() })),
  /** Sự kiện bên gọi được xem (nhà xe / khách không thấy minh chứng của bên kia). */
  events: z.array(DisputeEventSchema),
  decision: z
    .object({
      decision: z.enum(DisputeDecision),
      amount: z.int().nullable(),
      reason: z.string(),
      decidedAt: z.iso.datetime(),
      refund: z.object({ refundId: z.uuid(), refundCode: z.string(), status: z.enum(RefundStatus) }).nullable(),
    })
    .nullable(),
});
export type DisputeDetail = z.infer<typeof DisputeDetailSchema>;
export class DisputeDetailDto extends createZodDto(DisputeDetailSchema) {}
