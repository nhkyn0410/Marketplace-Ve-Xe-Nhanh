// Màn VXN Plus (Figma ADM-12a…12d; TASK-LOY-001): nhãn hạng / loại giao dịch, định dạng điểm, hệ số, quý, kiểm form tham số, CSV.
import type { LoyaltyPointType, LoyaltyReport, LoyaltyTier } from "./loyalty-api";

export const TIERS = ["BRONZE", "SILVER", "GOLD", "PLATINUM"] as const satisfies readonly LoyaltyTier[];

export const TIER_LABEL: Record<LoyaltyTier, string> = { BRONZE: "Đồng", SILVER: "Bạc", GOLD: "Vàng", PLATINUM: "Bạch kim" };

export const TYPE_LABEL: Record<LoyaltyPointType, { label: string; tone: "success" | "warning" | "neutral" | "danger" }> = {
  EARN: { label: "Tích điểm", tone: "success" },
  REDEEM: { label: "Đổi điểm", tone: "neutral" },
  EXPIRE: { label: "Hết hạn", tone: "warning" },
  ADJUST: { label: "Điều chỉnh", tone: "neutral" },
  REVERSAL: { label: "Thu hồi", tone: "danger" }
};

const NUMBER = new Intl.NumberFormat("vi-VN");

/** "1.250"; `signed` → "+384" / "-100" (0 → "0"). */
export function formatPoints(points: number, signed = false): string {
  const text = NUMBER.format(Math.abs(points));
  if (!signed || points === 0) {
    return points < 0 ? `-${text}` : text;
  }
  return points > 0 ? `+${text}` : `-${text}`;
}

/** Hệ số từ phần trăm: 120 → "1,2"; 100 → "1". */
export function multiplierLabel(percent: number): string {
  return (percent / 100).toLocaleString("vi-VN", { maximumFractionDigits: 2 });
}

/** "1,2" / "1.2" / "2" → phần trăm nguyên (120); tối đa 2 chữ số thập phân; sai → `null`. Không qua số thực. */
export function parseMultiplier(value: string): number | null {
  const match = /^(\d)(?:[.,](\d{1,2}))?$/.exec(value.trim());
  return match ? Number(match[1]) * 100 + Number((match[2] ?? "").padEnd(2, "0")) : null;
}

/** Số nguyên dương từ ô nhập (bỏ dấu chấm phân cách nghìn); trống / sai → `null`. */
export function parseCount(value: string): number | null {
  const digits = value.replace(/[.\s]/g, "");
  return /^\d{1,9}$/.test(digits) ? Number(digits) : null;
}

export type LoyaltyRulesForm = {
  earnUnit: string;
  pointValue: string;
  minRedeemPoints: string;
  pointExpiryMonths: string;
  voucherValidityDays: string;
  tiers: { minPoints: string; multiplier: string }[];
};

export type LoyaltyRules = {
  earnUnit: number;
  pointValue: number;
  minRedeemPoints: number;
  pointExpiryMonths: number;
  voucherValidityDays: number;
  tiers: { tier: LoyaltyTier; minPoints: number; multiplierPercent: number }[];
};

export type LoyaltyRulesErrors = Partial<Record<"earnUnit" | "pointValue" | "minRedeemPoints" | "pointExpiryMonths" | "voucherValidityDays", string>> & {
  tiers?: Partial<Record<"minPoints" | "multiplier", string>>[];
};

export function rulesToForm(rules: LoyaltyRules | null): LoyaltyRulesForm {
  return {
    earnUnit: rules ? NUMBER.format(rules.earnUnit) : "",
    pointValue: rules ? NUMBER.format(rules.pointValue) : "",
    minRedeemPoints: rules ? String(rules.minRedeemPoints) : "",
    pointExpiryMonths: rules ? String(rules.pointExpiryMonths) : "",
    voucherValidityDays: rules ? String(rules.voucherValidityDays) : "",
    tiers: TIERS.map((tier, index) => {
      const rule = rules?.tiers.find((item) => item.tier === tier);
      return { minPoints: index === 0 ? "0" : rule ? String(rule.minPoints) : "", multiplier: rule ? multiplierLabel(rule.multiplierPercent) : "" };
    })
  };
}

/** Kiểm form tham số (cùng quy tắc với API — `LoyaltyRulesSchema`); hợp lệ → `rules`. */
export function parseRulesForm(form: LoyaltyRulesForm): { rules: LoyaltyRules | null; errors: LoyaltyRulesErrors } {
  const errors: LoyaltyRulesErrors = {};
  const range = (key: keyof Omit<LoyaltyRulesForm, "tiers">, min: number, max: number, message: string) => {
    const value = parseCount(form[key]);
    if (value === null || value < min || value > max) {
      errors[key] = message;
      return 0;
    }
    return value;
  };
  const earnUnit = range("earnUnit", 1_000, 1_000_000, "Từ 1.000 đến 1.000.000 ₫.");
  const pointValue = range("pointValue", 1, 100_000, "Từ 1 đến 100.000 ₫.");
  const minRedeemPoints = range("minRedeemPoints", 1, 1_000_000, "Số điểm nguyên dương.");
  const pointExpiryMonths = range("pointExpiryMonths", 1, 60, "Từ 1 đến 60 tháng.");
  const voucherValidityDays = range("voucherValidityDays", 1, 365, "Từ 1 đến 365 ngày.");
  const tierErrors: Partial<Record<"minPoints" | "multiplier", string>>[] = [];
  const tiers = TIERS.map((tier, index) => {
    const row = form.tiers[index]!;
    const minPoints = parseCount(row.minPoints);
    const multiplierPercent = parseMultiplier(row.multiplier);
    const lower = index > 0 ? { minPoints: parseCount(form.tiers[index - 1]!.minPoints), multiplier: parseMultiplier(form.tiers[index - 1]!.multiplier) } : null;
    const rowErrors: Partial<Record<"minPoints" | "multiplier", string>> = {};
    if (minPoints === null || minPoints > 10_000_000) {
      rowErrors.minPoints = "Số điểm nguyên không âm.";
    } else if (lower?.minPoints != null && minPoints <= lower.minPoints) {
      rowErrors.minPoints = "Phải lớn hơn mốc của hạng dưới.";
    }
    if (multiplierPercent === null || multiplierPercent < 100 || multiplierPercent > 500) {
      rowErrors.multiplier = "Từ 1 đến 5, tối đa 2 chữ số thập phân.";
    } else if (lower?.multiplier != null && multiplierPercent < lower.multiplier) {
      rowErrors.multiplier = "Không thấp hơn hệ số hạng dưới.";
    }
    tierErrors.push(rowErrors);
    return { tier, minPoints: minPoints ?? 0, multiplierPercent: multiplierPercent ?? 0 };
  });
  if (tierErrors.some((row) => Object.keys(row).length > 0)) {
    errors.tiers = tierErrors;
  }
  const ok = Object.keys(errors).length === 0;
  return { rules: ok ? { earnUnit, pointValue, minRedeemPoints, pointExpiryMonths, voucherValidityDays, tiers } : null, errors };
}

/** Các dòng nội dung một phiên bản VXN Plus (trang xem phiên bản chính sách). */
export function loyaltyRuleRows(rules: LoyaltyRules): [string, string][] {
  return [
    ["Đơn vị tích điểm", `${NUMBER.format(rules.earnUnit)} ₫ cho 1 điểm`],
    ["Giá trị quy đổi", `${NUMBER.format(rules.pointValue)} ₫ mỗi điểm`],
    ["Số điểm đổi tối thiểu", `${NUMBER.format(rules.minRedeemPoints)} điểm`],
    ["Hạn dùng điểm", `${rules.pointExpiryMonths} tháng kể từ ngày tích`],
    ["Hạn dùng voucher", `${rules.voucherValidityDays} ngày`],
    ...rules.tiers.map((tier): [string, string] => [`Hạng ${TIER_LABEL[tier.tier]}`, `Từ ${NUMBER.format(tier.minPoints)} điểm · hệ số ×${multiplierLabel(tier.multiplierPercent)}`])
  ];
}

/** Quý (giờ VN) chứa `at`. */
export function quarterOf(at: Date): { year: number; quarter: number } {
  const local = new Date(at.getTime() + 7 * 3_600_000);
  return { year: local.getUTCFullYear(), quarter: Math.floor(local.getUTCMonth() / 3) + 1 };
}

/** Quý hiện tại và các quý trước (mới trước). */
export function recentQuarters(at: Date, count: number): { year: number; quarter: number }[] {
  const { year, quarter } = quarterOf(at);
  return Array.from({ length: count }, (_, index) => {
    const serial = year * 4 + (quarter - 1) - index;
    return { year: Math.floor(serial / 4), quarter: (serial % 4) + 1 };
  });
}

export function quarterLabel(year: number, quarter: number): string {
  return `Quý ${quarter}/${year}`;
}

/** "2026-09" → "Tháng 9/2026". */
export function monthLabel(month: string): string {
  const [year, value] = month.split("-");
  return `Tháng ${Number(value)}/${year}`;
}

/** CSV báo cáo (số liệu tổng hợp, không có dữ liệu cá nhân) — BOM để Excel đọc đúng tiếng Việt. */
export function reportCsv(report: LoyaltyReport): string {
  const rows = [
    ["Kỳ", "Điểm phát hành", "Điểm đã đổi", "Điểm hết hạn", "Voucher đã dùng", "Giảm do Vé Xe Nhanh chịu (VND)"],
    ...report.months.map((month) => [monthLabel(month.month), month.issued, month.redeemed, month.expired, month.vouchersUsed, month.platformDiscount]),
    [quarterLabel(report.year, report.quarter), report.totals.issued, report.totals.redeemed, report.totals.expired, report.totals.vouchersUsed, report.totals.platformDiscount]
  ];
  return `﻿${rows.map((row) => row.join(",")).join("\r\n")}\r\n`;
}
