import { createZodDto } from "nestjs-zod";
import { z } from "zod";
import { CaseParty, DisputeStatus, PaymentProvider, PaymentStatus, SupportCategory, SupportHandler, SupportPriority, SupportStatus } from "../../database/prisma.types";
import { DOCUMENT_CONTENT_TYPES, MAX_DOCUMENT_BYTES } from "../../operator-kyc/operator-application-format";

// Khiếu nại / hỗ trợ (TASK-TRUST-001, FR-NSR-06..09, BR-49, UC-09; Figma ADM-09a/b, "Nhà xe · Hỗ trợ / Khiếu nại"). Shape AI tự đề
// xuất, chờ Khanh duyệt (`doc/task-propreties/TRUST-001-todo.md`). Tên / liên hệ của khách luôn che.

const text = (max: number) => z.string().trim().min(1).max(max);
const reason = z.string().trim().min(3).max(500);

// ---------- Tệp đính kèm (dùng chung khiếu nại + tranh chấp) ----------

export const AttachmentUploadInputSchema = z.object({ contentType: z.enum(DOCUMENT_CONTENT_TYPES), sizeBytes: z.int().min(1).max(MAX_DOCUMENT_BYTES) });
export type AttachmentUploadInput = z.infer<typeof AttachmentUploadInputSchema>;
/** Xin URL tải một tệp minh chứng (PDF / JPEG / PNG ≤ 10 MB) lên kho riêng tư. */
export class AttachmentUploadInputDto extends createZodDto(AttachmentUploadInputSchema) {}

export const AttachmentUploadResponseSchema = z.object({
  /** URL để trình duyệt `PUT` thẳng tệp lên kho, kèm đúng `Content-Type` đã khai. */
  uploadUrl: z.url(),
  /** Khóa object — gửi lại trong `attachments` của lượt trao đổi. */
  objectKey: z.string(),
  expiresAt: z.iso.datetime(),
});
export type AttachmentUploadResponse = z.infer<typeof AttachmentUploadResponseSchema>;
export class AttachmentUploadResponseDto extends createZodDto(AttachmentUploadResponseSchema) {}

export const AttachmentInputSchema = z.object({ objectKey: z.string().min(1).max(200), fileName: text(200) });
export type AttachmentInput = z.infer<typeof AttachmentInputSchema>;

export const AttachmentSchema = z.object({ attachmentId: z.uuid(), fileName: z.string(), contentType: z.string(), sizeBytes: z.int() });
export type Attachment = z.infer<typeof AttachmentSchema>;

export const DownloadUrlResponseSchema = z.object({ url: z.url(), expiresAt: z.iso.datetime() });
export type DownloadUrlResponse = z.infer<typeof DownloadUrlResponseSchema>;
/** URL xem tệp, hạn 5 phút (mỗi lần cấp ghi audit). */
export class DownloadUrlResponseDto extends createZodDto(DownloadUrlResponseSchema) {}

// ---------- Khiếu nại ----------

export const MessageInputSchema = z.object({ body: text(2000), attachments: z.array(AttachmentInputSchema).max(5).default([]) });
export type MessageInput = z.infer<typeof MessageInputSchema>;
/** Một lượt trao đổi (tối đa 5 tệp). */
export class MessageInputDto extends createZodDto(MessageInputSchema) {}

export const CustomerTicketInputSchema = z.object({
  category: z.enum(SupportCategory),
  priority: z.enum(SupportPriority).default(SupportPriority.MEDIUM),
  subject: z.string().trim().min(3).max(200),
  body: text(2000),
  attachments: z.array(AttachmentInputSchema).max(5).default([]),
});
export type CustomerTicketInput = z.infer<typeof CustomerTicketInputSchema>;
/** Khách gửi khiếu nại cho một đơn của mình. */
export class CustomerTicketInputDto extends createZodDto(CustomerTicketInputSchema) {}

export const AdminMessageInputSchema = MessageInputSchema.extend({
  /** `true` = yêu cầu khách bổ sung thông tin (khiếu nại chờ khách). */
  requestInfo: z.boolean().default(false),
});
export type AdminMessageInput = z.infer<typeof AdminMessageInputSchema>;
export class AdminMessageInputDto extends createZodDto(AdminMessageInputSchema) {}

export const ClassifyInputSchema = z.object({
  category: z.enum(SupportCategory),
  priority: z.enum(SupportPriority),
  handler: z.enum(SupportHandler),
  assigneeId: z.uuid().nullable(),
});
export type ClassifyInput = z.infer<typeof ClassifyInputSchema>;
/** Lưu phân loại (Figma ADM-09b): danh mục, mức ưu tiên, bên xử lý chính, người phụ trách. */
export class ClassifyInputDto extends createZodDto(ClassifyInputSchema) {}

export const TicketStatusInputSchema = z.object({ status: z.enum([SupportStatus.RESOLVED, SupportStatus.CLOSED]), note: reason.nullable().default(null) });
export type TicketStatusInput = z.infer<typeof TicketStatusInputSchema>;
/** Đánh dấu đã giải quyết / đóng khiếu nại. */
export class TicketStatusInputDto extends createZodDto(TicketStatusInputSchema) {}

export const EscalateInputSchema = z.object({
  title: z.string().trim().min(3).max(200).nullable().default(null),
  /** Yêu cầu của khách (vd "Hoàn một phần tiền vé"). */
  customerRequest: z.string().trim().min(1).max(200).nullable().default(null),
  reason,
});
export type EscalateInput = z.infer<typeof EscalateInputSchema>;
/** Chuyển khiếu nại thành tranh chấp (FR-DSP-01). */
export class EscalateInputDto extends createZodDto(EscalateInputSchema) {}

/**
 * Lọc người phụ trách: UUID tài khoản nền tảng hoặc `none` (chưa phân công). Khai chuỗi + pattern thay vì union `uuid | "none"`:
 * union `anyOf` có hằng làm Dart client (dart-dio) sinh lớp không biên dịch được.
 */
export const AssigneeFilterSchema = z.string().regex(/^(none|[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12})$/, "UUID tài khoản nền tảng hoặc `none`.");

export class AdminTicketListQueryDto extends createZodDto(
  z.object({
    status: z.enum(SupportStatus).optional(),
    category: z.enum(SupportCategory).optional(),
    operatorId: z.uuid().optional(),
    /** `none` = chưa phân công. */
    assigneeId: AssigneeFilterSchema.optional(),
    /** Mã khiếu nại hoặc mã đặt vé. */
    q: z.string().trim().min(1).max(50).optional(),
    cursor: z.uuid().optional(),
    limit: z.coerce.number().int().min(1).max(100).default(20),
  }),
) {}

export class OperatorTicketListQueryDto extends createZodDto(
  z.object({ status: z.enum(SupportStatus).optional(), cursor: z.uuid().optional(), limit: z.coerce.number().int().min(1).max(100).default(20) }),
) {}

const UserRefSchema = z.object({ id: z.uuid(), username: z.string() });

export const TicketSummarySchema = z.object({
  ticketId: z.uuid(),
  ticketCode: z.string(),
  subject: z.string(),
  bookingId: z.uuid(),
  bookingCode: z.string(),
  operatorId: z.uuid(),
  operatorName: z.string(),
  reporterParty: z.enum(CaseParty),
  /** Đã che (`Nguyễn Văn K***`). */
  reporterName: z.string(),
  category: z.enum(SupportCategory),
  priority: z.enum(SupportPriority),
  handler: z.enum(SupportHandler),
  status: z.enum(SupportStatus),
  assignee: UserRefSchema.nullable(),
  disputeId: z.uuid().nullable(),
  createdAt: z.iso.datetime(),
  lastMessageAt: z.iso.datetime(),
});
export type TicketSummary = z.infer<typeof TicketSummarySchema>;

export const TicketPageSchema = z.object({
  items: z.array(TicketSummarySchema),
  nextCursor: z.uuid().nullable(),
  total: z.int(),
  /** Khiếu nại chưa phân loại (`NEW`) — nhãn tab Figma ADM-09a. */
  unclassified: z.int(),
});
export type TicketPage = z.infer<typeof TicketPageSchema>;
export class TicketPageDto extends createZodDto(TicketPageSchema) {}

export const CustomerTicketListSchema = z.object({ items: z.array(TicketSummarySchema) });
export type CustomerTicketList = z.infer<typeof CustomerTicketListSchema>;
/** Khiếu nại của một đơn (khách xem). */
export class CustomerTicketListDto extends createZodDto(CustomerTicketListSchema) {}

export const MessageSchema = z.object({
  messageId: z.uuid(),
  party: z.enum(CaseParty),
  /** Khách: tên đã che; Vé Xe Nhanh: `platform/{username}` với Admin, "CSKH Vé Xe Nhanh" với nhà xe / khách. */
  authorName: z.string(),
  body: z.string(),
  createdAt: z.iso.datetime(),
  attachments: z.array(AttachmentSchema),
});
export type Message = z.infer<typeof MessageSchema>;

export const TicketDetailSchema = TicketSummarySchema.extend({
  requestedPriority: z.enum(SupportPriority),
  /** Email liên hệ đã che (chỉ Admin). */
  contactEmailMasked: z.string().nullable(),
  trip: z.object({ tripId: z.uuid(), routeName: z.string(), departureAt: z.iso.datetime(), vehiclePlateNumber: z.string().nullable() }),
  messages: z.array(MessageSchema),
  /** Dữ liệu liên quan tự lấy theo đơn (Figma ADM-09b). */
  payments: z.array(z.object({ paymentId: z.uuid(), paymentCode: z.string(), provider: z.enum(PaymentProvider), status: z.enum(PaymentStatus), amount: z.int() })),
  validTickets: z.int(),
  dispute: z.object({ disputeId: z.uuid(), disputeCode: z.string(), status: z.enum(DisputeStatus) }).nullable(),
});
export type TicketDetail = z.infer<typeof TicketDetailSchema>;
export class TicketDetailDto extends createZodDto(TicketDetailSchema) {}

export const AssigneeListSchema = z.object({ items: z.array(UserRefSchema.extend({ role: z.string() })) });
export type AssigneeList = z.infer<typeof AssigneeListSchema>;
/** Tài khoản nền tảng đang hoạt động có thể phụ trách khiếu nại / tranh chấp. */
export class AssigneeListDto extends createZodDto(AssigneeListSchema) {}
