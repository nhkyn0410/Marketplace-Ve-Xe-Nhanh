import { z } from "zod";

const code = z.string().trim().toUpperCase().regex(/^[A-Z0-9][A-Z0-9_-]{1,29}$/, "Mã văn phòng gồm 2–30 chữ, số, gạch ngang hoặc gạch dưới.");
const text = (max: number) => z.string().trim().min(1).max(max);

/** Thông tin chủ nhà xe tạo văn phòng bán vé. */
export const SalesOfficeInputSchema = z.object({ code, name: text(100), address: text(255), active: z.boolean().default(true) });
export type SalesOfficeInput = z.infer<typeof SalesOfficeInputSchema>;

/** Thông tin cập nhật văn phòng cùng phiên bản chống ghi đè. */
export const SalesOfficeUpdateSchema = SalesOfficeInputSchema.extend({ active: z.boolean(), version: z.int().nonnegative() });
export type SalesOfficeUpdate = z.infer<typeof SalesOfficeUpdateSchema>;

/** Văn phòng bán vé được phép xem trong nhà xe hiện tại. */
export const SalesOfficeSchema = z.object({
  id: z.uuid(), code: z.string(), name: z.string(), address: z.string(), active: z.boolean(), version: z.int().nonnegative(),
  createdAt: z.iso.datetime(), updatedAt: z.iso.datetime(),
});
export type SalesOffice = z.infer<typeof SalesOfficeSchema>;

/** Danh sách văn phòng theo phạm vi của tài khoản đang đăng nhập. */
export const SalesOfficeListSchema = z.object({ items: z.array(SalesOfficeSchema) });

/** Danh sách nhân viên được phân công, kể cả tài khoản đã ngừng hoạt động. */
export const SalesOfficeAssignmentsSchema = z.object({
  items: z.array(z.object({ employeeId: z.uuid(), username: z.string(), status: z.enum(["ACTIVE", "LOCKED", "DISABLED"]) })),
});

/** Thay danh sách phân công bằng nhân viên bán vé đang hoạt động của nhà xe. */
export const SalesOfficeAssignmentsInputSchema = z.object({
  version: z.int().nonnegative(),
  employeeIds: z.array(z.uuid()).max(200).refine((ids) => new Set(ids).size === ids.length, "Nhân viên phân công không được trùng."),
});
export type SalesOfficeAssignmentsInput = z.infer<typeof SalesOfficeAssignmentsInputSchema>;
