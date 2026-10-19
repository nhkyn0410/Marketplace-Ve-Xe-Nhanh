// Màn Chính sách (TASK-ADM-001 phần chính sách; Figma ADM-06a…06d): nhãn, quy đổi tỷ lệ / ngày giờ Việt Nam, lỗi.
import { ApiError } from "@vexenhanh/ui/lib/auth/api-client";
import { describeReauthError } from "@vexenhanh/ui/lib/auth/reauth";

import type { PolicyState, PolicyType } from "./policy-api";

export const POLICY_TYPE_LABEL: Record<PolicyType, string> = {
  CANCELLATION: "Hủy và hoàn tiền",
  SEAT_HOLD: "Giữ chỗ",
  PAYOUT: "Chi trả",
  LOYALTY: "VXN Plus"
};

export const STATE: Record<PolicyState, { label: string; tone: "success" | "warning" | "neutral" | "danger" }> = {
  DRAFT: { label: "Nháp", tone: "neutral" },
  SCHEDULED: { label: "Đã lên lịch", tone: "warning" },
  ACTIVE: { label: "Đang áp dụng", tone: "success" },
  EXPIRED: { label: "Hết hiệu lực", tone: "neutral" },
  CANCELLED: { label: "Đã hủy", tone: "danger" }
};

/** Mốc giờ chọn được cho một bậc hoàn tiền (Figma 06b: 48 / 24 / 4 / 0 giờ). */
export const TIER_HOURS = [0, 1, 2, 3, 4, 6, 12, 24, 48, 72, 168] as const;

export type Tier = { minHoursBefore: number; refundPercent: number };

/** Nhãn khoảng thời gian của từng bậc khi đã sắp giảm dần: "Từ 48 giờ trở lên", "Từ 4 giờ đến dưới 24 giờ", "Dưới 4 giờ". */
export function tierLabels(tiers: readonly Tier[]): string[] {
  const sorted = [...tiers].sort((a, b) => b.minHoursBefore - a.minHoursBefore);
  return sorted.map((tier, index) => {
    const upper = sorted[index - 1]?.minHoursBefore;
    if (tier.minHoursBefore === 0) {
      return upper === undefined ? "Mọi thời điểm" : `Dưới ${upper} giờ`;
    }
    return upper === undefined ? `Từ ${tier.minHoursBefore} giờ trở lên` : `Từ ${tier.minHoursBefore} giờ đến dưới ${upper} giờ`;
  });
}

/** Lỗi của bộ mốc đang soạn (cùng quy tắc với API); `null` = hợp lệ. */
export function tiersError(tiers: readonly Tier[]): string | null {
  if (tiers.length === 0) {
    return "Thêm ít nhất một mốc.";
  }
  if (tiers.some((tier) => !Number.isInteger(tier.refundPercent) || tier.refundPercent < 0 || tier.refundPercent > 100)) {
    return "Mức hoàn là số nguyên từ 0 đến 100.";
  }
  const hours = tiers.map((tier) => tier.minHoursBefore);
  if (new Set(hours).size !== hours.length) {
    return "Hai mốc trùng số giờ.";
  }
  if (!hours.includes(0)) {
    return "Cần một mốc 0 giờ (hủy sát giờ khởi hành).";
  }
  const sorted = [...tiers].sort((a, b) => b.minHoursBefore - a.minHoursBefore);
  if (sorted.some((tier, index) => index > 0 && tier.refundPercent > sorted[index - 1]!.refundPercent)) {
    return "Hủy càng sát giờ thì mức hoàn không được cao hơn.";
  }
  return null;
}

/** "4,5%" từ phần vạn. */
export function formatRate(bps: number): string {
  return `${(bps / 100).toLocaleString("vi-VN", { maximumFractionDigits: 2 })}%`;
}

/** "4,5" / "4.5" → 450 phần vạn; tối đa 2 chữ số thập phân, 0–100; sai → `null`. Không qua số thực. */
export function percentToBps(value: string): number | null {
  const match = /^(\d{1,3})(?:[.,](\d{1,2}))?$/.exec(value.trim());
  if (!match) {
    return null;
  }
  const bps = Number(match[1]) * 100 + Number((match[2] ?? "").padEnd(2, "0"));
  return bps <= 10_000 ? bps : null;
}

export function bpsToPercentInput(bps: number): string {
  const whole = Math.floor(bps / 100);
  const fraction = bps % 100;
  return fraction === 0 ? String(whole) : `${whole},${String(fraction).padStart(2, "0").replace(/0$/, "")}`;
}

/** "250.000 đ". */
export function formatVnd(value: number): string {
  return `${value.toLocaleString("vi-VN")} đ`;
}

/** "1.200.000" / "1200000" → 1200000; trống → `null`; sai → `NaN`. */
export function parseVnd(value: string): number | null {
  const compact = value.replace(/[.\s,đ]/g, "");
  if (compact === "") {
    return null;
  }
  return /^\d{1,9}$/.test(compact) ? Number(compact) : Number.NaN;
}

const VN_OFFSET_MS = 7 * 3_600_000;
const pad = (value: number) => String(value).padStart(2, "0");

/** ISO → giá trị ô `datetime-local` theo giờ Việt Nam (`2026-11-01T00:00`). */
export function toVnLocalInput(iso: string | null): string {
  if (!iso) {
    return "";
  }
  const shifted = new Date(new Date(iso).getTime() + VN_OFFSET_MS);
  return `${shifted.getUTCFullYear()}-${pad(shifted.getUTCMonth() + 1)}-${pad(shifted.getUTCDate())}T${pad(shifted.getUTCHours())}:${pad(
    shifted.getUTCMinutes()
  )}`;
}

/** Ô `datetime-local` (giờ Việt Nam, bất kể múi giờ máy) → ISO có `+07:00`; trống → `null`. */
export function fromVnLocalInput(value: string): string | null {
  return /^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}$/.test(value) ? `${value}:00+07:00` : null;
}

/** ISO → ô `date` theo giờ Việt Nam. `exclusiveEnd`: mốc kết thúc "không gồm" → hiện ngày cuối cùng còn hiệu lực. */
export function toVnDateInput(iso: string | null, exclusiveEnd = false): string {
  if (!iso) {
    return "";
  }
  const shifted = new Date(new Date(iso).getTime() + VN_OFFSET_MS - (exclusiveEnd ? 1 : 0));
  return `${shifted.getUTCFullYear()}-${pad(shifted.getUTCMonth() + 1)}-${pad(shifted.getUTCDate())}`;
}

/** Ô `date` → 00:00 giờ Việt Nam của ngày đó; `exclusiveEnd`: 00:00 của NGÀY HÔM SAU (ngày đã chọn vẫn tính). */
export function fromVnDateInput(value: string, exclusiveEnd = false): string | null {
  if (!/^\d{4}-\d{2}-\d{2}$/.test(value)) {
    return null;
  }
  const start = new Date(`${value}T00:00:00+07:00`);
  return new Date(start.getTime() + (exclusiveEnd ? 24 * 3_600_000 : 0)).toISOString();
}

/** Lỗi thao tác chính sách / hoa hồng / khung giá; `field: "identity"` = báo tại ô mã xác thực. */
export function describePolicyError(error: unknown): { field: "identity" | "form"; message: string; refresh?: boolean } {
  const identity = describeReauthError(error);
  if (identity) {
    return { field: "identity", message: identity };
  }
  if (!(error instanceof ApiError)) {
    return { field: "form", message: "Không kết nối được máy chủ. Kiểm tra mạng rồi thử lại." };
  }
  switch (error.code) {
    case "POLICY_VERSION_LOCKED":
    case "POLICY_SCHEDULE_CONFLICT":
    case "POLICY_VERSION_CONFLICT":
    case "COMMISSION_RULE_OVERLAP":
    case "FARE_BAND_CLOSED":
      return { field: "form", message: error.message, refresh: true };
    case "POLICY_VERSION_NOT_FOUND":
    case "COMMISSION_RULE_NOT_FOUND":
    case "FARE_BAND_NOT_FOUND":
      return { field: "form", message: "Không còn tìm thấy mục này. Đã tải lại.", refresh: true };
    default:
      return error.status === 503
        ? { field: "form", message: "Hệ thống tạm thời không phản hồi nên chưa đổi gì. Vui lòng thử lại sau." }
        : { field: "form", message: error.message || "Không thực hiện được thao tác. Vui lòng thử lại." };
  }
}
