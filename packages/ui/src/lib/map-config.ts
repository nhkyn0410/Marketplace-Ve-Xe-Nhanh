// Cấu hình bản đồ Goong của các app web (ADR-027, TASK-TRN-014). Mỗi app tự khai biến môi trường.

const rawKey = process.env.NEXT_PUBLIC_GOONG_MAPTILES_KEY;

/**
 * Khóa Goong Maptiles — khóa hiển thị bản đồ, công khai phía trình duyệt (khác `GOONG_API_KEY` của API dùng
 * để tính quãng đường). `null` = môi trường chưa đặt khóa: các khối bản đồ ẩn đi;
 * không dùng nguồn bản đồ nào khác thay thế.
 */
export const GOONG_MAPTILES_KEY: string | null = rawKey && rawKey.trim() !== "" ? rawKey.trim() : null;
