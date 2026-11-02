import type { PrismaService } from "../database/prisma.service";
import { findReferencedVehicleImageKeys } from "../database/vehicle-image-keys";
import { deleteOrphanObjects } from "../external/storage/orphan-objects";
import type { StorageProvider } from "../external/storage/storage-provider";

export const VEHICLE_IMAGE_CLEANUP_JOB = "vehicle-image-cleanup";

/** 03:30 giờ VN mỗi ngày — sau job dọn phiên, khung ít người dùng nhất (ADR-016). */
export const VEHICLE_IMAGE_CLEANUP_SCHEDULE = { pattern: "30 3 * * *", tz: "Asia/Ho_Chi_Minh" } as const;

/**
 * Object chưa đủ 24 giờ không bị xóa (LLD §6.12 bước 5): người dùng có thể đã tải lên nhưng chưa bấm lưu. Gắn ảnh
 * chỉ nhận object trẻ hơn mốc này (`ATTACHABLE_MAX_AGE_MS`), nên object job thấy "mồ côi" không thể được gắn nữa.
 */
export const ORPHAN_MIN_AGE_MS = 24 * 3_600_000;

/** Tiền tố của mọi ảnh xe trong kho công khai. */
export const VEHICLE_IMAGE_ROOT = "vehicles/";

/**
 * Xóa object dưới `vehicles/` không còn dòng `vehicle_images` nào tham chiếu và đã cũ hơn 24 giờ: ảnh tải lên rồi
 * bỏ dở, hoặc ảnh bị gỡ mà lần xóa sau commit thất bại. Trả về số object đã xóa.
 */
export function deleteOrphanVehicleImages(
  storage: Pick<StorageProvider, "list" | "delete">,
  prisma: Pick<PrismaService, "withSystem">,
  now: Date = new Date(),
): Promise<number> {
  return deleteOrphanObjects({
    storage,
    prefix: VEHICLE_IMAGE_ROOT,
    minAgeMs: ORPHAN_MIN_AGE_MS,
    findReferenced: (keys) => findReferencedVehicleImageKeys(prisma, keys),
    now,
  });
}
