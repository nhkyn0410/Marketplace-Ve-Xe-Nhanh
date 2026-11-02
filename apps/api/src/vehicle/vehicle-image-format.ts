/** Loại file ảnh xe được nhận (BR-76) — không có SVG: SVG chứa được script. */
export const VEHICLE_IMAGE_CONTENT_TYPES = ["image/jpeg", "image/png", "image/webp"] as const;
export type VehicleImageContentType = (typeof VEHICLE_IMAGE_CONTENT_TYPES)[number];

export const MAX_VEHICLE_IMAGES = 8;
export const MAX_VEHICLE_IMAGE_BYTES = 5 * 1024 * 1024;
export const MAX_VEHICLE_IMAGE_CAPTION = 60;

/** Số byte đầu cần đọc để nhận ra cả ba định dạng (WebP cần tới byte thứ 12). */
export const IMAGE_SIGNATURE_BYTES = 12;

const EXTENSIONS: Record<VehicleImageContentType, string> = {
  "image/jpeg": "jpg",
  "image/png": "png",
  "image/webp": "webp",
};
const UUID = "[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}";

const startsWith = (bytes: Uint8Array, signature: number[], offset = 0) =>
  signature.every((value, index) => bytes[offset + index] === value);

/**
 * Định dạng thật của file theo chữ ký ở các byte đầu, không tin `Content-Type` hay đuôi file: một file HTML đổi
 * đuôi `.jpg` phải bị từ chối (Security §9). `null` = không phải JPEG / PNG / WebP.
 */
export function detectImageType(bytes: Uint8Array): VehicleImageContentType | null {
  if (startsWith(bytes, [0xff, 0xd8, 0xff])) {
    return "image/jpeg";
  }
  if (startsWith(bytes, [0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a])) {
    return "image/png";
  }
  // RIFF....WEBP
  if (startsWith(bytes, [0x52, 0x49, 0x46, 0x46]) && startsWith(bytes, [0x57, 0x45, 0x42, 0x50], 8)) {
    return "image/webp";
  }
  return null;
}

/** Khóa object của một ảnh mới: `vehicles/{operatorId}/{vehicleId}/{uuid}.{ext}` — không dùng tên file gốc. */
export function vehicleImageKey(
  operatorId: string,
  vehicleId: string,
  imageId: string,
  contentType: VehicleImageContentType,
): string {
  return `${vehicleImagePrefix(operatorId, vehicleId)}${imageId}.${EXTENSIONS[contentType]}`;
}

/** Tiền tố khóa của mọi ảnh thuộc một xe. Gắn ảnh vào xe chỉ nhận khóa nằm dưới tiền tố của chính xe đó. */
export function vehicleImagePrefix(operatorId: string, vehicleId: string): string {
  return `vehicles/${operatorId}/${vehicleId}/`;
}

/**
 * Loại file suy ra từ khóa nếu khóa đúng dạng do server sinh cho đúng xe này; `null` nếu khóa lạ, thuộc xe /
 * nhà xe khác hoặc có đoạn đi ngược thư mục.
 */
export function contentTypeOfKey(
  operatorId: string,
  vehicleId: string,
  objectKey: string,
): VehicleImageContentType | null {
  const prefix = vehicleImagePrefix(operatorId, vehicleId);
  if (!objectKey.startsWith(prefix)) {
    return null;
  }
  const match = new RegExp(`^(${UUID})\\.(jpg|png|webp)$`).exec(objectKey.slice(prefix.length));
  if (!match) {
    return null;
  }
  const entry = Object.entries(EXTENSIONS).find(([, extension]) => extension === match[2]);
  return (entry?.[0] as VehicleImageContentType | undefined) ?? null;
}
