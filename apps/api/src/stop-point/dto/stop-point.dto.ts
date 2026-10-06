import { createZodDto } from "nestjs-zod";
import { z } from "zod";
import { SearchQueryField } from "../../common/search-text";
import { StopPointProposalStatus, StopPointStatus, StopPointType } from "../../database/prisma.types";

const optionalText = (max: number) =>
  z
    .string()
    .trim()
    .max(max)
    .nullable()
    .transform((value) => value || null);

// Không `.default()`: cùng schema cho POST và PUT (thay toàn bộ) — thiếu trường là 400 (bài học TRN-001).
const LocationFields = {
  name: z.string().trim().min(1).max(150),
  address: z.string().trim().min(1).max(300),
  provinceId: z.uuid(),
  wardId: z.uuid(),
  latitude: z.number().min(-90).max(90),
  longitude: z.number().min(-180).max(180),
  description: optionalText(500),
};

/** Loại điểm nhà xe được tự tạo (BR-38): văn phòng / điểm trung chuyển và trạm dừng nghỉ. */
export const PRIVATE_STOP_POINT_TYPES: StopPointType[] = [StopPointType.OFFICE, StopPointType.REST_STOP];

export const StopPointInputSchema = z.object({
  ...LocationFields,
  // Nhận đủ các loại ở biên để service trả 422 `STOP_POINT_TYPE_NOT_ALLOWED` có mã riêng (API §7.3) —
  // giao diện báo được "loại này phải đề xuất vào danh mục dùng chung" thay vì lỗi 400 chung.
  type: z.enum(StopPointType),
  // Nhà xe chỉ đặt `ACTIVE` / `INACTIVE`; `SUSPENDED` chỉ Admin đặt (BR-81).
  status: z.enum([StopPointStatus.ACTIVE, StopPointStatus.INACTIVE]),
});
export type StopPointInput = z.infer<typeof StopPointInputSchema>;
// Tên class có tiền tố `Operator`: OpenAPI đặt tên schema theo tên class, trùng với DTO catalog công khai
// (`StopPointListResponseDto`) sẽ ghi đè schema của `/catalog/stop-points` (openapi.spec.ts chặn trùng).
/** Body tạo/thay toàn bộ điểm dừng riêng của nhà xe. */
export class OperatorStopPointInputDto extends createZodDto(StopPointInputSchema) {}

export const StopPointProposalInputSchema = z.object({
  ...LocationFields,
  // Chỉ bến xe và điểm dừng đón trả khách mới đề xuất vào danh mục dùng chung (BR-38); loại khác → 400.
  type: z.enum([StopPointType.BUS_STATION, StopPointType.PICKUP_POINT]),
  // Căn cứ công bố của cơ quan quản lý — Admin đối chiếu khi duyệt.
  legalBasis: z.string().trim().min(1).max(300),
});
export type StopPointProposalInput = z.infer<typeof StopPointProposalInputSchema>;
/** Body gửi / sửa-gửi-lại đề xuất đưa điểm vào danh mục dùng chung. */
export class StopPointProposalInputDto extends createZodDto(StopPointProposalInputSchema) {}

const pageFields = {
  cursor: z.uuid().optional(),
  limit: z.coerce.number().int().min(1).max(100).default(20),
};

export const StopPointListQuerySchema = z.object({
  status: z.enum(StopPointStatus).optional(),
  type: z.enum(StopPointType).optional(),
  provinceId: z.uuid().optional(),
  q: SearchQueryField,
  ...pageFields,
});
export type OperatorStopPointListQuery = z.infer<typeof StopPointListQuerySchema>;
/** Query list điểm riêng: lọc trạng thái / loại / tỉnh, tìm theo tên hoặc địa chỉ, phân trang cursor theo `id`. */
export class OperatorStopPointListQueryDto extends createZodDto(StopPointListQuerySchema) {}
/** Query list đề xuất: lọc trạng thái, phân trang cursor theo `id`. */
export class StopPointProposalListQueryDto extends createZodDto(
  z.object({ status: z.enum(StopPointProposalStatus).optional(), ...pageFields }),
) {}

const LocationResponseFields = {
  id: z.uuid(),
  name: z.string(),
  type: z.enum(StopPointType),
  address: z.string(),
  provinceId: z.uuid(),
  wardId: z.uuid(),
  latitude: z.number(),
  longitude: z.number(),
  description: z.string().nullable(),
  createdAt: z.iso.datetime(),
  updatedAt: z.iso.datetime(),
};

export const StopPointResponseSchema = z.object({
  ...LocationResponseFields,
  status: z.enum(StopPointStatus),
  // Lý do Admin khóa điểm; chỉ có khi `status = SUSPENDED` (BR-81).
  suspensionReason: z.string().nullable(),
  // Số route của nhà xe đang dùng điểm này.
  routeCount: z.int(),
});
export type StopPointResponse = z.infer<typeof StopPointResponseSchema>;
/** Một điểm dừng riêng của nhà xe. */
export class OperatorStopPointResponseDto extends createZodDto(StopPointResponseSchema) {}

export const StopPointListResponseSchema = z.object({
  items: z.array(StopPointResponseSchema),
  nextCursor: z.uuid().nullable(),
});
export type StopPointListResponse = z.infer<typeof StopPointListResponseSchema>;
/** Một trang điểm riêng của nhà xe. */
export class OperatorStopPointListResponseDto extends createZodDto(StopPointListResponseSchema) {}

export const StopPointProposalResponseSchema = z.object({
  ...LocationResponseFields,
  legalBasis: z.string(),
  status: z.enum(StopPointProposalStatus),
  rejectionReason: z.string().nullable(),
  catalogStopPointId: z.uuid().nullable(),
});
export type StopPointProposalResponse = z.infer<typeof StopPointProposalResponseSchema>;
/** Một đề xuất điểm dừng của nhà xe. */
export class StopPointProposalResponseDto extends createZodDto(StopPointProposalResponseSchema) {}

export const StopPointProposalListResponseSchema = z.object({
  items: z.array(StopPointProposalResponseSchema),
  nextCursor: z.uuid().nullable(),
});
export type StopPointProposalListResponse = z.infer<typeof StopPointProposalListResponseSchema>;
/** Một trang đề xuất của nhà xe. */
export class StopPointProposalListResponseDto extends createZodDto(StopPointProposalListResponseSchema) {}
