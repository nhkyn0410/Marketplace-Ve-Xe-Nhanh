import { VEHICLE_IMAGE_CONTENT_TYPES, type VehicleImageContentType } from "../vehicle/vehicle-image-format";

/** Ảnh banner dùng chung loại / dung lượng với ảnh xe, ảnh bài viết (JPEG / PNG / WebP, ≤ 5 MB; không SVG). */
export const CONTENT_IMAGE_CONTENT_TYPES = VEHICLE_IMAGE_CONTENT_TYPES;

const EXTENSIONS: Record<VehicleImageContentType, string> = {
  "image/jpeg": "jpg",
  "image/png": "png",
  "image/webp": "webp",
};
const KEY = /^content-pages\/[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\.(jpg|png|webp)$/;

/** Khóa object của một ảnh banner mới: `content-pages/{uuid}.{ext}` — không dùng tên file gốc. */
export function contentImageKey(imageId: string, contentType: VehicleImageContentType): string {
  return `content-pages/${imageId}.${EXTENSIONS[contentType]}`;
}

/** Loại file suy từ khóa nếu khóa đúng dạng server sinh; `null` = khóa lạ / đi ngược thư mục. */
export function contentTypeOfContentKey(objectKey: string): VehicleImageContentType | null {
  const match = KEY.exec(objectKey);
  if (!match) {
    return null;
  }
  const entry = Object.entries(EXTENSIONS).find(([, extension]) => extension === match[1]);
  return (entry?.[0] as VehicleImageContentType | undefined) ?? null;
}
