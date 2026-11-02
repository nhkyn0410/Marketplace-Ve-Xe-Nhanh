// Chữ hiển thị của khuyến mãi (TASK-PROM-001) — dùng chung Admin + Operator OS. Hàm thuần.

type Tone = "success" | "warning" | "neutral" | "danger";
export type PromotionDisplay = "DRAFT" | "SCHEDULED" | "RUNNING" | "PAUSED" | "ENDED";

export const PROMOTION_DISPLAY: Record<PromotionDisplay, { label: string; tone: Tone }> = {
  DRAFT: { label: "Nháp", tone: "neutral" },
  SCHEDULED: { label: "Đã lên lịch", tone: "neutral" },
  RUNNING: { label: "Đang chạy", tone: "success" },
  PAUSED: { label: "Tạm dừng", tone: "warning" },
  ENDED: { label: "Đã kết thúc", tone: "neutral" }
};
export const PROMOTION_DISPLAY_ORDER: PromotionDisplay[] = ["RUNNING", "SCHEDULED", "DRAFT", "PAUSED", "ENDED"];

const VND = new Intl.NumberFormat("vi-VN");
const money = (amount: number) => `${VND.format(amount)} ₫`;
const VN_OFFSET_MS = 7 * 3_600_000;
const pad = (value: number) => String(value).padStart(2, "0");

/** Mức giảm: `10%, tối đa 50.000 ₫` / `30.000 ₫`. */
export function discountLabel(promotion: { discountType: "PERCENT" | "AMOUNT"; discountValue: number; maxDiscount: number | null }): string {
  if (promotion.discountType === "AMOUNT") {
    return money(promotion.discountValue);
  }
  return promotion.maxDiscount === null ? `${promotion.discountValue}%` : `${promotion.discountValue}%, tối đa ${money(promotion.maxDiscount)}`;
}

/** Điều kiện đơn: `Đơn từ 300.000 ₫` / `Không yêu cầu`. */
export function minOrderLabel(minOrder: number): string {
  return minOrder > 0 ? `Đơn từ ${money(minOrder)}` : "Không yêu cầu";
}

function vnParts(iso: string) {
  const at = new Date(Date.parse(iso) + VN_OFFSET_MS);
  return { day: `${pad(at.getUTCDate())}/${pad(at.getUTCMonth() + 1)}`, year: at.getUTCFullYear(), time: `${pad(at.getUTCHours())}:${pad(at.getUTCMinutes())}` };
}

/** Hiệu lực `01/10 – 31/12/2026` (giờ VN). */
export function windowLabel(startsAt: string, endsAt: string): string {
  const start = vnParts(startsAt);
  const end = vnParts(endsAt);
  return `${start.day}${start.year === end.year ? "" : `/${start.year}`} – ${end.day}/${end.year}`;
}

/** Lượt dùng `2.840 / 10.000`. */
export function usageLabel(used: number, limit: number): string {
  return `${VND.format(used)} / ${VND.format(limit)}`;
}

/** Giới hạn mức giảm Vé Xe Nhanh cấp: `20% hoặc 100.000 ₫`. */
export function capLabel(maxPercent: number | null, maxAmount: number | null): string {
  if (maxPercent !== null && maxAmount !== null) {
    return `${maxPercent}% hoặc ${money(maxAmount)}`;
  }
  return maxPercent !== null ? `${maxPercent}%` : maxAmount !== null ? money(maxAmount) : "—";
}

/** Ô `datetime-local` (giờ VN) ↔ ISO có múi giờ. */
export function toLocalInput(iso: string): string {
  return new Date(Date.parse(iso) + VN_OFFSET_MS).toISOString().slice(0, 16);
}

export function fromLocalInput(local: string): string {
  return `${local}:00+07:00`;
}
