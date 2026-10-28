import { VEHICLE_IMAGE_CONTENT_TYPES, type VehicleImageContentType } from "../vehicle/vehicle-image-format";

/** Logo nhà xe dùng chung loại file với ảnh xe (JPEG / PNG / WebP; không SVG — SVG chứa được script). */
export const OPERATOR_LOGO_CONTENT_TYPES = VEHICLE_IMAGE_CONTENT_TYPES;
export type OperatorLogoContentType = VehicleImageContentType;

/** Logo chỉ hiện nhỏ (đầu trang nhà xe, thẻ nhà xe) nên 2 MB là dư; Operator OS thu nhỏ ảnh trước khi tải lên. */
export const MAX_OPERATOR_LOGO_BYTES = 2 * 1024 * 1024;

/** Tiền tố của mọi logo nhà xe trong kho công khai (ADR-018). */
export const OPERATOR_LOGO_ROOT = "operator-logos/";

const EXTENSIONS: Record<OperatorLogoContentType, string> = {
  "image/jpeg": "jpg",
  "image/png": "png",
  "image/webp": "webp",
};
const UUID = "[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}";

/** Khóa object của một logo mới: `operator-logos/{operatorId}/{uuid}.{ext}` — không dùng tên file gốc. */
export function operatorLogoKey(operatorId: string, logoId: string, contentType: OperatorLogoContentType): string {
  return `${OPERATOR_LOGO_ROOT}${operatorId}/${logoId}.${EXTENSIONS[contentType]}`;
}

/** Loại file suy ra từ khóa nếu khóa đúng dạng server sinh cho đúng nhà xe này; khóa lạ / nhà xe khác → `null`. */
export function contentTypeOfLogoKey(operatorId: string, objectKey: string): OperatorLogoContentType | null {
  const prefix = `${OPERATOR_LOGO_ROOT}${operatorId}/`;
  if (!objectKey.startsWith(prefix)) {
    return null;
  }
  const match = new RegExp(`^${UUID}\\.(jpg|png|webp)$`).exec(objectKey.slice(prefix.length));
  const entry = match && Object.entries(EXTENSIONS).find(([, extension]) => extension === match[1]);
  return (entry?.[0] as OperatorLogoContentType | undefined) ?? null;
}
