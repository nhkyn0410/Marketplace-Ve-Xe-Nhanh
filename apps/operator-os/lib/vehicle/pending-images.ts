// Ảnh chưa lưu được lúc "Thêm phương tiện": tạo xe xong thì trang chuyển sang màn sửa (component dựng lại), nên
// giữ tạm các ô ảnh ở đây để màn sửa hiện lại ảnh lỗi kèm nút "Thử lại" (Figma 08) thay vì làm mất ảnh. Chỉ
// sống trong bộ nhớ của tab; tải lại trang thì mất — ảnh đã lưu vẫn còn trên xe.
import type { ImageItem } from "./vehicle-images";

export type PendingImages = { items: ImageItem[]; notice: string };

const pending = new Map<string, PendingImages>();

export function stashPendingImages(vehicleId: string, value: PendingImages): void {
  pending.set(vehicleId, value);
}

/** Đọc mà không xóa: React có thể gọi hàm khởi tạo state hai lần ở chế độ strict. */
export function peekPendingImages(vehicleId: string): PendingImages | null {
  return pending.get(vehicleId) ?? null;
}

export function clearPendingImages(vehicleId: string): void {
  pending.delete(vehicleId);
}
