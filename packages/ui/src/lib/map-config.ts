// Cấu hình bản đồ Goong của Operator OS (ADR-027, TASK-TRN-014).

const rawKey = process.env.NEXT_PUBLIC_GOONG_MAPTILES_KEY;

/**
 * Khóa Goong Maptiles — khóa hiển thị bản đồ, công khai phía trình duyệt (khác `GOONG_API_KEY` của API dùng
 * để tính quãng đường). `null` = môi trường chưa đặt khóa: mọi khối bản đồ ẩn đi và tọa độ nhập bằng tay;
 * không dùng nguồn bản đồ nào khác thay thế.
 */
export const GOONG_MAPTILES_KEY: string | null = rawKey && rawKey.trim() !== "" ? rawKey.trim() : null;
