import { findReferencedApplicationDocumentKeys } from "../database/operator-application-document-keys";
import type { PrismaService } from "../database/prisma.service";
import { deleteOrphanObjects } from "../external/storage/orphan-objects";
import type { StorageProvider } from "../external/storage/storage-provider";

export const APPLICATION_DOCUMENT_CLEANUP_JOB = "application-document-cleanup";

/** 03:45 giờ VN mỗi ngày — sau job dọn ảnh xe (ADR-016). */
export const APPLICATION_DOCUMENT_CLEANUP_SCHEDULE = { pattern: "45 3 * * *", tz: "Asia/Ho_Chi_Minh" } as const;

/** Lớn hơn `ATTACHABLE_MAX_AGE_MS` của service: giấy tờ còn gắn được thì job chưa đụng tới. */
export const DOCUMENT_ORPHAN_MIN_AGE_MS = 24 * 3_600_000;

/** Tiền tố của mọi giấy tờ hồ sơ đăng ký trong kho riêng tư. */
export const APPLICATION_DOCUMENT_ROOT = "operator-applications/";

/**
 * Xóa giấy tờ dưới `operator-applications/` không còn hồ sơ nào tham chiếu và đã cũ hơn 24 giờ: tải lên rồi bỏ dở,
 * hoặc bị thay mà lần xóa sau commit thất bại. Giấy tờ là dữ liệu cá nhân — không để tồn trong kho vô thời hạn.
 */
export function deleteOrphanApplicationDocuments(
  storage: Pick<StorageProvider, "list" | "delete">,
  prisma: Pick<PrismaService, "withSystem">,
  now: Date = new Date(),
): Promise<number> {
  return deleteOrphanObjects({
    storage,
    prefix: APPLICATION_DOCUMENT_ROOT,
    minAgeMs: DOCUMENT_ORPHAN_MIN_AGE_MS,
    findReferenced: (keys) => findReferencedApplicationDocumentKeys(prisma, keys),
    now,
  });
}
