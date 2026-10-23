import { createZodDto } from "nestjs-zod";
import { z } from "zod";
import { TimeCursorField } from "../../common/time-cursor";

// API §7.5 — Admin rà soát / gỡ ảnh phương tiện (TASK-ADM-003 phần ảnh xe, FR-ADM-20, BR-76, Figma ADM-10b/10c).

export const AdminVehicleImageListQuerySchema = z.object({
  operatorId: z.uuid().optional(),
  /** Chỉ ảnh tải lên từ thời điểm này (Figma "Thời gian tải lên"). */
  uploadedSince: z.iso.datetime().optional(),
  cursor: TimeCursorField,
  limit: z.coerce.number().int().min(1).max(48).default(24),
});
export type AdminVehicleImageListQuery = z.infer<typeof AdminVehicleImageListQuerySchema>;
export class AdminVehicleImageListQueryDto extends createZodDto(AdminVehicleImageListQuerySchema) {}

export const AdminVehicleImageSchema = z.object({
  id: z.uuid(),
  url: z.string(),
  caption: z.string().nullable(),
  /** Thứ tự trong bộ ảnh của xe; ảnh đứng đầu là ảnh đại diện. */
  position: z.int(),
  isCover: z.boolean(),
  vehicleId: z.uuid(),
  plateNumber: z.string(),
  operatorId: z.uuid(),
  operatorName: z.string(),
  createdAt: z.iso.datetime(),
});
export type AdminVehicleImage = z.infer<typeof AdminVehicleImageSchema>;

export const AdminVehicleImageListSchema = z.object({
  items: z.array(AdminVehicleImageSchema),
  nextCursor: z.string().nullable(),
  /** Tổng ảnh khớp bộ lọc ("Đã tải 8 / 146 ảnh"). */
  total: z.int(),
  /** Nhà xe đang có ảnh — lựa chọn của ô lọc "Nhà xe". */
  operators: z.array(z.object({ id: z.uuid(), name: z.string() })),
});
export type AdminVehicleImageList = z.infer<typeof AdminVehicleImageListSchema>;
export class AdminVehicleImageListDto extends createZodDto(AdminVehicleImageListSchema) {}

/** Lý do gỡ: 3–500 ký tự (Figma ADM-10c), lưu vào audit và gửi chủ nhà xe. */
export const RemoveVehicleImageInputSchema = z.object({ reason: z.string().trim().min(3).max(500) });
export type RemoveVehicleImageInput = z.infer<typeof RemoveVehicleImageInputSchema>;
export class AdminRemoveVehicleImageInputDto extends createZodDto(RemoveVehicleImageInputSchema) {}

export class AdminVehicleImageIdParamDto extends createZodDto(z.object({ imageId: z.uuid() })) {}
