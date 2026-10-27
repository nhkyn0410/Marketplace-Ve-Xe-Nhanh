// Trang công khai của nhà xe (TASK-MKT-001, SCR-PSG-17): đường dẫn tới trang `/operators/{id}` của web khách hàng và
// cách hiện các chỉ số trong khung "Xem trước trên ứng dụng" — cùng cách web khách hàng hiện.
import type { PublicOperatorProfile } from "./profile-api";

/** Máy dev chạy web khách hàng ở cổng 3001 (`apps/marketplace`). */
const DEV_MARKETPLACE_URL = "http://localhost:3001";

/**
 * Link trang nhà xe trên web khách hàng. Gốc lấy từ `NEXT_PUBLIC_MARKETPLACE_URL` (Next thay giá trị khi build); bản
 * build production thiếu biến → `null` để nút tắt thay vì trỏ nhầm về `localhost`.
 */
export function operatorPageUrl(operatorId: string): string | null {
  const base =
    process.env.NEXT_PUBLIC_MARKETPLACE_URL?.trim() || (process.env.NODE_ENV === "production" ? "" : DEV_MARKETPLACE_URL);
  return base ? `${base.replace(/\/+$/, "")}/operators/${encodeURIComponent(operatorId)}` : null;
}

/** Tỉ lệ 0–1 → `1.2%`; chưa đủ dữ liệu → "Chưa có dữ liệu". */
export function rateText(value: number | null): string {
  return value === null ? "Chưa có dữ liệu" : `${(value * 100).toFixed(1)}%`;
}

export type PreviewMetric = { label: string; value: string; note?: string };

/** Bốn chỉ số chất lượng như khối "Chỉ số chất lượng" của trang nhà xe. */
export function previewMetrics(scorecard: PublicOperatorProfile["scorecard"]): PreviewMetric[] {
  return [
    {
      label: "Đánh giá trung bình",
      value: scorecard.averageRating === null ? "—" : scorecard.averageRating.toFixed(1),
      note: `${scorecard.reviewCount} đánh giá`
    },
    { label: "Hủy chuyến do nhà xe", value: rateText(scorecard.operatorCancellationRate) },
    {
      label: "Đơn có hoàn tiền / tranh chấp",
      value: `${rateText(scorecard.refundBookingRate)} / ${rateText(scorecard.disputeBookingRate)}`
    },
    { label: "Tỷ lệ check-in", value: rateText(scorecard.checkInRate) }
  ];
}
