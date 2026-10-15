import { createZodDto } from "nestjs-zod";
import { z } from "zod";
import { SearchQueryField } from "../../common/search-text";
import { TimeCursorField } from "../../common/time-cursor";
import {
  CatalogStatus,
  StopPointProposalStatus,
  StopPointStatus,
  StopPointType,
} from "../../database/prisma.types";
import { LocationFields, LocationResponseFields } from "./stop-point.dto";

/** Loại điểm của danh mục dùng chung (BR-38): không có văn phòng trung chuyển. */
export const SHARED_STOP_POINT_TYPES = [
  StopPointType.BUS_STATION,
  StopPointType.PICKUP_POINT,
  StopPointType.REST_STOP,
] as const;
/** Loại cần căn cứ công bố của cơ quan quản lý. */
const NEEDS_LEGAL_BASIS: readonly StopPointType[] = [StopPointType.BUS_STATION, StopPointType.PICKUP_POINT];

const pageFields = {
  cursor: TimeCursorField,
  limit: z.coerce.number().int().min(1).max(100).default(20),
};

/** Lý do khóa / từ chối: bắt buộc, 1–500 ký tự (Figma ADM-05e), lưu vào audit và hiện cho nhà xe. */
export const ReasonInputSchema = z.object({ reason: z.string().trim().min(1).max(500) });
export type ReasonInput = z.infer<typeof ReasonInputSchema>;
export class StopPointReasonInputDto extends createZodDto(ReasonInputSchema) {}

const legalBasis = z
  .string()
  .trim()
  .max(300)
  .nullable()
  .transform((value) => value || null);

// ── Điểm dùng chung ─────────────────────────────────────────────────────────────────────────────────────

export const SharedStopPointInputSchema = z
  .object({
    ...LocationFields,
    type: z.enum(SHARED_STOP_POINT_TYPES),
    legalBasis,
    status: z.enum(CatalogStatus),
  })
  .refine((input) => !NEEDS_LEGAL_BASIS.includes(input.type) || input.legalBasis !== null, {
    path: ["legalBasis"],
    message: "Bến xe và điểm dừng đón trả bắt buộc căn cứ công bố.",
  });
export type SharedStopPointInput = z.infer<typeof SharedStopPointInputSchema>;
/** Body tạo / thay toàn bộ một điểm dừng dùng chung. */
export class AdminSharedStopPointInputDto extends createZodDto(SharedStopPointInputSchema) {}

export const SharedStopPointListQuerySchema = z.object({
  type: z.enum(SHARED_STOP_POINT_TYPES).optional(),
  provinceId: z.uuid().optional(),
  status: z.enum(CatalogStatus).optional(),
  q: SearchQueryField,
  ...pageFields,
});
export type SharedStopPointListQuery = z.infer<typeof SharedStopPointListQuerySchema>;
/** Query danh sách điểm dùng chung: lọc loại / tỉnh / trạng thái, tìm không dấu, mới tạo trước. */
export class AdminSharedStopPointListQueryDto extends createZodDto(SharedStopPointListQuerySchema) {}

export const SharedStopPointSchema = z.object({
  ...LocationResponseFields,
  provinceName: z.string(),
  legalBasis: z.string().nullable(),
  status: z.enum(CatalogStatus),
  /** Số tuyến (mọi nhà xe) đang dùng điểm này. */
  routeCount: z.int(),
});
export type SharedStopPoint = z.infer<typeof SharedStopPointSchema>;
export class AdminSharedStopPointDto extends createZodDto(SharedStopPointSchema) {}

export const SharedStopPointListSchema = z.object({
  items: z.array(SharedStopPointSchema),
  nextCursor: z.string().nullable(),
  /** Số điểm khớp bộ lọc. */
  total: z.int(),
});
export type SharedStopPointList = z.infer<typeof SharedStopPointListSchema>;
export class AdminSharedStopPointListDto extends createZodDto(SharedStopPointListSchema) {}

// ── Đề xuất của nhà xe ──────────────────────────────────────────────────────────────────────────────────

export const ProposalListQuerySchema = z.object({
  status: z.enum(StopPointProposalStatus).optional(),
  type: z.enum([StopPointType.BUS_STATION, StopPointType.PICKUP_POINT]).optional(),
  operatorId: z.uuid().optional(),
  ...pageFields,
});
export type ProposalListQuery = z.infer<typeof ProposalListQuerySchema>;
/** Query danh sách đề xuất: lọc trạng thái / loại / nhà xe, mới gửi trước. */
export class AdminStopPointProposalListQueryDto extends createZodDto(ProposalListQuerySchema) {}

/** Điểm dùng chung cùng loại, đang hoạt động, ở gần đề xuất (cảnh báo tạo trùng — LLD §6.13 bước 3). */
const NearbySchema = z.object({
  id: z.uuid(),
  name: z.string(),
  latitude: z.number(),
  longitude: z.number(),
  distanceMeters: z.int(),
  routeCount: z.int(),
});

export const AdminProposalSchema = z.object({
  ...LocationResponseFields,
  provinceName: z.string(),
  legalBasis: z.string(),
  status: z.enum(StopPointProposalStatus),
  rejectionReason: z.string().nullable(),
  catalogStopPointId: z.uuid().nullable(),
  operatorId: z.uuid(),
  operatorName: z.string(),
  /** Gần nhất trước; rỗng = không có điểm cùng loại trong bán kính cảnh báo. */
  nearby: z.array(NearbySchema),
});
export type AdminProposal = z.infer<typeof AdminProposalSchema>;
export class AdminStopPointProposalDto extends createZodDto(AdminProposalSchema) {}

export const AdminProposalListSchema = z.object({
  items: z.array(AdminProposalSchema),
  nextCursor: z.string().nullable(),
  total: z.int(),
});
export type AdminProposalList = z.infer<typeof AdminProposalListSchema>;
export class AdminStopPointProposalListDto extends createZodDto(AdminProposalListSchema) {}

/** Body duyệt: thông tin điểm sau khi Admin chỉnh (giao diện điền sẵn từ đề xuất). */
export const ProposalApprovalInputSchema = z.object({
  ...LocationFields,
  type: z.enum([StopPointType.BUS_STATION, StopPointType.PICKUP_POINT]),
  legalBasis: z.string().trim().min(1).max(300),
});
export type ProposalApprovalInput = z.infer<typeof ProposalApprovalInputSchema>;
export class AdminStopPointProposalApprovalDto extends createZodDto(ProposalApprovalInputSchema) {}

// ── Điểm riêng của nhà xe ───────────────────────────────────────────────────────────────────────────────

export const OperatorPointListQuerySchema = z.object({
  operatorId: z.uuid().optional(),
  type: z.enum([StopPointType.OFFICE, StopPointType.REST_STOP]).optional(),
  provinceId: z.uuid().optional(),
  status: z.enum(StopPointStatus).optional(),
  q: SearchQueryField,
  ...pageFields,
});
export type OperatorPointListQuery = z.infer<typeof OperatorPointListQuerySchema>;
/** Query điểm riêng của mọi nhà xe: lọc nhà xe / loại / tỉnh / trạng thái, tìm không dấu, mới tạo trước. */
export class AdminOperatorStopPointListQueryDto extends createZodDto(OperatorPointListQuerySchema) {}

export const AdminOperatorPointSchema = z.object({
  ...LocationResponseFields,
  provinceName: z.string(),
  status: z.enum(StopPointStatus),
  suspensionReason: z.string().nullable(),
  operatorId: z.uuid(),
  operatorName: z.string(),
  /** Số tuyến của nhà xe đang dùng điểm này. */
  routeCount: z.int(),
});
export type AdminOperatorPoint = z.infer<typeof AdminOperatorPointSchema>;
export class AdminOperatorStopPointDto extends createZodDto(AdminOperatorPointSchema) {}

export const AdminOperatorPointListSchema = z.object({
  items: z.array(AdminOperatorPointSchema),
  nextCursor: z.string().nullable(),
  total: z.int(),
});
export type AdminOperatorPointList = z.infer<typeof AdminOperatorPointListSchema>;
export class AdminOperatorStopPointListDto extends createZodDto(AdminOperatorPointListSchema) {}

export const IdParamSchema = z.object({ id: z.uuid() });
export class AdminStopPointIdParamDto extends createZodDto(IdParamSchema) {}
