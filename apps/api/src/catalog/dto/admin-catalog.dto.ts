import { createZodDto } from "nestjs-zod";
import { z } from "zod";
import { CatalogStatus, VehicleClass, VehicleForm } from "../../database/prisma.types";

// ── Đầu vào ─────────────────────────────────────────────────────────────────────────────────────────────

const name = z.string().trim().min(1).max(100);
/** Mã của loại xe / tiện ích: chữ hoa không dấu, số, gạch dưới (như dữ liệu seed: `SLEEPER_LIMOUSINE`). */
const itemCode = z
  .string()
  .trim()
  .toUpperCase()
  .regex(/^[A-Z0-9_]{2,40}$/, "Mã gồm 2–40 ký tự chữ hoa không dấu, số, gạch dưới.");

export const ProvinceInputSchema = z.object({
  /** Mã tỉnh / thành theo danh mục hành chính chính thức: 2 chữ số. Không đổi được sau khi tạo. */
  code: z.string().trim().regex(/^\d{2}$/, "Mã tỉnh / thành gồm 2 chữ số."),
  name,
});
export type ProvinceInput = z.infer<typeof ProvinceInputSchema>;
export class AdminProvinceInputDto extends createZodDto(ProvinceInputSchema) {}

export const WardInputSchema = z.object({
  /** Tỉnh / thành chứa phường — không đổi được sau khi tạo (điểm dừng tham chiếu cặp phường–tỉnh). */
  provinceId: z.uuid(),
  /** Mã phường / xã chính thức: 5 chữ số. */
  code: z.string().trim().regex(/^\d{5}$/, "Mã phường / xã gồm 5 chữ số."),
  name,
});
export type WardInput = z.infer<typeof WardInputSchema>;
export class AdminWardInputDto extends createZodDto(WardInputSchema) {}

export const VehicleTypeInputSchema = z.object({
  code: itemCode,
  name,
  description: z
    .string()
    .trim()
    .max(300)
    .nullable()
    .transform((value) => value || null),
  /** Dạng chỗ + hạng xe (BR-77) — không đổi được sau khi tạo: xe và bảng giá đang dựa vào hai thuộc tính này. */
  form: z.enum(VehicleForm),
  class: z.enum(VehicleClass),
});
export type VehicleTypeInput = z.infer<typeof VehicleTypeInputSchema>;
export class AdminVehicleTypeInputDto extends createZodDto(VehicleTypeInputSchema) {}

export const AmenityInputSchema = z.object({ code: itemCode, name });
export type AmenityInput = z.infer<typeof AmenityInputSchema>;
export class AdminAmenityInputDto extends createZodDto(AmenityInputSchema) {}

/** Sửa: chỉ đổi được tên (+ mô tả với loại xe); mã, tỉnh của phường, dạng chỗ / hạng xe giữ nguyên. */
export const RenameInputSchema = z.object({ name });
export type RenameInput = z.infer<typeof RenameInputSchema>;
export class AdminCatalogRenameDto extends createZodDto(RenameInputSchema) {}

export const VehicleTypeUpdateSchema = VehicleTypeInputSchema.pick({ name: true, description: true });
export type VehicleTypeUpdate = z.infer<typeof VehicleTypeUpdateSchema>;
export class AdminVehicleTypeUpdateDto extends createZodDto(VehicleTypeUpdateSchema) {}

/** Ngừng dùng: lý do 3–500 ký tự (Figma ADM-04c), lưu vào audit. */
export const DeactivateInputSchema = z.object({ reason: z.string().trim().min(3).max(500) });
export class AdminCatalogDeactivateDto extends createZodDto(DeactivateInputSchema) {}

export const CATALOG_KINDS = ["provinces", "wards", "vehicle-types", "amenities"] as const;
export type CatalogKind = (typeof CATALOG_KINDS)[number];
export const CatalogItemParamSchema = z.object({ kind: z.enum(CATALOG_KINDS), id: z.uuid() });
export class AdminCatalogItemParamDto extends createZodDto(CatalogItemParamSchema) {}
export const IdParamSchema = z.object({ id: z.uuid() });
export class AdminCatalogIdParamDto extends createZodDto(IdParamSchema) {}

const search = z
  .string()
  .trim()
  .max(100)
  .transform((value) => value || undefined)
  .optional();
const page = {
  /** Mã của dòng cuối trang trước (danh sách xếp theo mã). */
  cursor: z.string().trim().max(20).optional(),
  limit: z.coerce.number().int().min(1).max(100).default(20),
};

export const ProvinceListQuerySchema = z.object({ q: search, status: z.enum(CatalogStatus).optional(), ...page });
export type ProvinceListQuery = z.infer<typeof ProvinceListQuerySchema>;
export class AdminProvinceListQueryDto extends createZodDto(ProvinceListQuerySchema) {}

export const WardListQuerySchema = z.object({
  provinceId: z.uuid().optional(),
  q: search,
  status: z.enum(CatalogStatus).optional(),
  ...page,
});
export type WardListQuery = z.infer<typeof WardListQuerySchema>;
export class AdminWardListQueryDto extends createZodDto(WardListQuerySchema) {}

export const StatusQuerySchema = z.object({ status: z.enum(CatalogStatus).optional() });
export type StatusQuery = z.infer<typeof StatusQuerySchema>;
export class AdminCatalogStatusQueryDto extends createZodDto(StatusQuerySchema) {}

// ── Đầu ra ──────────────────────────────────────────────────────────────────────────────────────────────

const itemFields = {
  id: z.uuid(),
  code: z.string(),
  name: z.string(),
  status: z.enum(CatalogStatus),
  createdAt: z.iso.datetime(),
  updatedAt: z.iso.datetime(),
};

export const ProvinceItemSchema = z.object({
  ...itemFields,
  wardCount: z.int(),
  /** Điểm dừng dùng chung trong tỉnh. */
  stopPointCount: z.int(),
});
export type ProvinceItem = z.infer<typeof ProvinceItemSchema>;
export class AdminProvinceDto extends createZodDto(ProvinceItemSchema) {}

export const WardItemSchema = z.object({
  ...itemFields,
  provinceId: z.uuid(),
  provinceName: z.string(),
  stopPointCount: z.int(),
});
export type WardItem = z.infer<typeof WardItemSchema>;
export class AdminWardDto extends createZodDto(WardItemSchema) {}

export const VehicleTypeItemSchema = z.object({
  ...itemFields,
  description: z.string().nullable(),
  form: z.enum(VehicleForm),
  class: z.enum(VehicleClass),
  /** Xe (mọi nhà xe) đang khai loại này. */
  vehicleCount: z.int(),
  operatorCount: z.int(),
  /** Quy tắc giá tham chiếu loại xe này. */
  fareRuleCount: z.int(),
});
export type VehicleTypeItem = z.infer<typeof VehicleTypeItemSchema>;
export class AdminVehicleTypeDto extends createZodDto(VehicleTypeItemSchema) {}

export const AmenityItemSchema = z.object({ ...itemFields, vehicleCount: z.int() });
export type AmenityItem = z.infer<typeof AmenityItemSchema>;
export class AdminAmenityDto extends createZodDto(AmenityItemSchema) {}

const pageOf = <T extends z.ZodType>(item: T) =>
  z.object({ items: z.array(item), nextCursor: z.string().nullable(), total: z.int() });

export const ProvincePageSchema = pageOf(ProvinceItemSchema);
export type ProvincePage = z.infer<typeof ProvincePageSchema>;
export class AdminProvincePageDto extends createZodDto(ProvincePageSchema) {}

export const WardPageSchema = pageOf(WardItemSchema);
export type WardPage = z.infer<typeof WardPageSchema>;
export class AdminWardPageDto extends createZodDto(WardPageSchema) {}

// Loại xe / tiện ích chỉ vài chục dòng: trả cả danh sách, không phân trang.
export const VehicleTypeListSchema = z.object({ items: z.array(VehicleTypeItemSchema) });
export type VehicleTypeList = z.infer<typeof VehicleTypeListSchema>;
export class AdminVehicleTypeListDto extends createZodDto(VehicleTypeListSchema) {}

export const AmenityListSchema = z.object({ items: z.array(AmenityItemSchema) });
export type AmenityList = z.infer<typeof AmenityListSchema>;
export class AdminAmenityListDto extends createZodDto(AmenityListSchema) {}
