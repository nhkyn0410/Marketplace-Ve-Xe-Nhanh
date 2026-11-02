import { VEHICLE_IMAGE_CONTENT_TYPES, type VehicleImageContentType } from "../vehicle/vehicle-image-format";

/** Ảnh bài viết dùng chung loại / dung lượng với ảnh xe (JPEG / PNG / WebP, ≤ 5 MB; không SVG). */
export const ARTICLE_IMAGE_CONTENT_TYPES = VEHICLE_IMAGE_CONTENT_TYPES;
export type ArticleImageContentType = VehicleImageContentType;

const EXTENSIONS: Record<ArticleImageContentType, string> = {
  "image/jpeg": "jpg",
  "image/png": "png",
  "image/webp": "webp",
};
const KEY = /^articles\/[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\.(jpg|png|webp)$/;

/** Khóa object của một ảnh bài viết mới: `articles/{uuid}.{ext}` — không dùng tên file gốc. */
export function articleImageKey(imageId: string, contentType: ArticleImageContentType): string {
  return `articles/${imageId}.${EXTENSIONS[contentType]}`;
}

/** Loại file suy từ khóa nếu khóa đúng dạng server sinh; `null` = khóa lạ / đi ngược thư mục. */
export function contentTypeOfArticleKey(objectKey: string): ArticleImageContentType | null {
  const match = KEY.exec(objectKey);
  if (!match) {
    return null;
  }
  const entry = Object.entries(EXTENSIONS).find(([, extension]) => extension === match[1]);
  return (entry?.[0] as ArticleImageContentType | undefined) ?? null;
}
