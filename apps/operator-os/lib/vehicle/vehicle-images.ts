// Bộ ảnh của xe ở form Thêm / Sửa phương tiện (TASK-TRN-009, BR-76, Figma 02 / 04 / 08). Ảnh chọn ở form chỉ
// nằm trong trình duyệt; bấm "Lưu phương tiện" mới tải lên kho và thay bộ ảnh của xe (`syncVehicleImages`).
import { ApiError } from "../auth/api-client";
import type { Vehicle } from "./vehicle-api";

export const MAX_VEHICLE_IMAGES = 8;
export const MAX_IMAGE_BYTES = 5 * 1024 * 1024;
export const CAPTION_MAX_LENGTH = 60;
export const ACCEPTED_IMAGE_TYPES = ["image/jpeg", "image/png", "image/webp"] as const;
/** Cạnh dài tối đa sau khi nén ở trình duyệt (LLD §6.12 bước 1, `LLD-OQ-08` mặc định v1). */
export const MAX_IMAGE_EDGE = 1600;

export type SavedImage = Vehicle["images"][number];

/**
 * Một ô ảnh ở form. `saved` = ảnh đang có trên xe. `new` = ảnh vừa chọn, chưa gắn vào xe: `objectKey` có khi đã
 * tải lên kho xong (lần lưu trước lỗi ở bước gắn thì không phải tải lại), `failed` = lần lưu gần nhất chưa tải được.
 */
export type ImageItem =
  | { kind: "saved"; id: string; objectKey: string; url: string; caption: string }
  | {
      kind: "new";
      id: string;
      file: Blob;
      previewUrl: string;
      caption: string;
      objectKey: string | null;
      failed: boolean;
    };

export type NewImageItem = Extract<ImageItem, { kind: "new" }>;

/** Ảnh đã lưu của xe → ô ảnh của form, đúng thứ tự (ảnh đầu là ảnh đại diện). */
export function toImageItems(images: readonly SavedImage[]): ImageItem[] {
  return [...images]
    .sort((a, b) => a.position - b.position)
    .map((image): ImageItem => ({
      kind: "saved",
      id: image.id,
      objectKey: image.objectKey,
      url: image.url,
      caption: image.caption ?? ""
    }));
}

/** Lỗi tại tệp khi chọn ảnh (Figma "Ảnh · Lỗi tại tệp"); `null` = nhận được. */
export function fileProblem(file: { type: string }): string | null {
  return (ACCEPTED_IMAGE_TYPES as readonly string[]).includes(file.type)
    ? null
    : "Định dạng không được hỗ trợ. Chọn JPEG, PNG hoặc WebP.";
}

export const OVERSIZE_MESSAGE = "Ảnh vượt quá 5 MB. Hãy chọn tệp nhỏ hơn.";
export const FULL_MESSAGE = "Đã đủ 8 ảnh. Xóa một ảnh trước khi thêm ảnh mới.";

/** Chọn nhiều tệp một lúc: nhận tệp hợp lệ tới khi đủ 8 ảnh; mỗi loại lỗi chỉ báo một lần. */
export function pickFiles<T extends { type: string }>(
  files: readonly T[],
  currentCount: number
): { accepted: T[]; problems: string[] } {
  const accepted: T[] = [];
  const problems = new Set<string>();
  for (const file of files) {
    const problem = fileProblem(file);
    if (problem) {
      problems.add(problem);
    } else if (currentCount + accepted.length >= MAX_VEHICLE_IMAGES) {
      problems.add(FULL_MESSAGE);
    } else {
      accepted.push(file);
    }
  }
  return { accepted, problems: [...problems] };
}

/** Kích thước sau khi thu nhỏ để cạnh dài không quá `maxEdge`; ảnh đã nhỏ hơn giữ nguyên. */
export function fitWithin(width: number, height: number, maxEdge = MAX_IMAGE_EDGE): { width: number; height: number } {
  const scale = Math.min(1, maxEdge / Math.max(width, height));
  return { width: Math.max(1, Math.round(width * scale)), height: Math.max(1, Math.round(height * scale)) };
}

/** Đưa ô ở `from` tới `to`, các ô khác giữ thứ tự. */
export function moveItem<T>(items: readonly T[], from: number, to: number): T[] {
  if (from === to || from < 0 || to < 0 || from >= items.length || to >= items.length) {
    return [...items];
  }
  const next = [...items];
  const [moved] = next.splice(from, 1);
  next.splice(to, 0, moved!);
  return next;
}

/** Body `PUT …/images`: ô đã có khóa object, theo thứ tự; chú thích trống gửi `null`. */
export function toImagesInput(items: readonly ImageItem[]): { images: { objectKey: string; caption: string | null }[] } {
  return {
    images: items.flatMap((item) =>
      item.objectKey ? [{ objectKey: item.objectKey, caption: item.caption.trim() || null }] : []
    )
  };
}

/** Bộ ảnh ở form khác bộ ảnh đã lưu (thêm / xóa / đổi thứ tự / sửa chú thích). */
export function imagesChanged(saved: readonly SavedImage[], items: readonly ImageItem[]): boolean {
  const before = toImageItems(saved);
  if (before.length !== items.length) {
    return true;
  }
  return items.some((item, index) => {
    const old = before[index]!;
    return item.kind !== "saved" || item.id !== old.id || item.caption.trim() !== old.caption.trim();
  });
}

/** Nhãn đếm ảnh ở góc khối: có ảnh chưa lưu được thì chỉ đếm ảnh đã lưu (Figma 08). */
export function countLabel(items: readonly ImageItem[]): string {
  const failed = items.some((item) => item.kind === "new" && item.failed);
  if (failed) {
    const saved = items.filter((item) => item.kind === "saved").length;
    return `${saved} / ${MAX_VEHICLE_IMAGES} ảnh đã lưu`;
  }
  return `${items.length} / ${MAX_VEHICLE_IMAGES} ảnh`;
}

/** Dòng phụ dưới biển số ở danh sách xe (Figma 01). */
export function imageCountLine(count: number): string {
  return count > 0 ? `${count} ảnh` : "Chưa có ảnh";
}

/** Lỗi khi gắn bộ ảnh vào xe → thông báo cho người dùng (mã lỗi API §7.3). */
export function describeImageSaveError(error: unknown): string {
  if (error instanceof ApiError) {
    switch (error.code) {
      case "VEHICLE_IMAGE_INVALID":
        return `Chưa lưu được ảnh: ${error.message}`;
      case "VEHICLE_IMAGE_LIMIT_EXCEEDED":
        return FULL_MESSAGE;
      case "VEHICLE_IMAGE_UPLOAD_RATE_LIMITED":
        return "Bạn tải ảnh quá nhanh. Vui lòng thử lại sau ít phút.";
      case "VEHICLE_NOT_FOUND":
        return "Phương tiện không còn tồn tại. Vui lòng quay lại danh sách.";
    }
    if (error.status === 503) {
      return "Kho lưu ảnh tạm thời không phản hồi. Vui lòng thử lại sau.";
    }
    if (error.status === 400) {
      return "Ảnh chưa hợp lệ. Vui lòng kiểm tra chú thích và thử lại.";
    }
  }
  return "Chưa lưu được ảnh. Vui lòng kiểm tra kết nối và thử lại.";
}

export type ImageSyncDeps = {
  requestUpload: (input: { contentType: string; sizeBytes: number }) => Promise<{ uploadUrl: string; objectKey: string }>;
  uploadFile: (uploadUrl: string, file: Blob) => Promise<void>;
  replaceImages: (input: ReturnType<typeof toImagesInput>) => Promise<{ images: SavedImage[] }>;
};

export type ImageSyncResult = {
  items: ImageItem[];
  /** Số ảnh chưa tải lên được — còn trong form với nút "Thử lại". */
  failed: number;
  /** Lỗi khi gắn bộ ảnh vào xe; có lỗi thì bộ ảnh của xe giữ nguyên như trước lần lưu. */
  error: unknown;
  /** Bộ ảnh của xe sau khi gắn; `null` khi gắn lỗi. */
  saved: SavedImage[] | null;
};

/**
 * Lưu bộ ảnh của form vào xe: tải lần lượt từng ảnh mới chưa có trên kho, rồi thay bộ ảnh của xe bằng mọi ảnh
 * đã có khóa object. Ảnh tải lỗi không chặn ảnh khác ("giữ ảnh hợp lệ khi một ảnh lỗi" — Figma, bàn giao).
 */
export async function syncVehicleImages(items: readonly ImageItem[], deps: ImageSyncDeps): Promise<ImageSyncResult> {
  const staged: ImageItem[] = [];
  for (const item of items) {
    if (item.kind === "saved" || item.objectKey) {
      staged.push(item);
      continue;
    }
    try {
      const grant = await deps.requestUpload({ contentType: item.file.type, sizeBytes: item.file.size });
      await deps.uploadFile(grant.uploadUrl, item.file);
      staged.push({ ...item, objectKey: grant.objectKey, failed: false });
    } catch {
      staged.push({ ...item, failed: true });
    }
  }
  const failed = staged.filter((item) => item.kind === "new" && item.failed).length;
  let saved: SavedImage[];
  try {
    saved = (await deps.replaceImages(toImagesInput(staged))).images;
  } catch (error) {
    return { items: staged, failed, error, saved: null };
  }
  // Ghép lại theo thứ tự ở form: ô đã gắn thay bằng ảnh của server, ô lỗi giữ nguyên chỗ để thử lại.
  const byKey = new Map(toImageItems(saved).map((item) => [item.objectKey!, item]));
  const next = staged.flatMap((item) => {
    if (!item.objectKey) {
      return [item];
    }
    const fresh = byKey.get(item.objectKey);
    return fresh ? [fresh] : [];
  });
  return { items: next, failed, error: null, saved };
}
