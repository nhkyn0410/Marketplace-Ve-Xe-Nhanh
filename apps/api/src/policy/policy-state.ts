import type { DbTransaction } from "../database/prisma.service";
import { PolicyRuleStatus, PolicyVersionStatus } from "../database/prisma.types";

type VersionLike = { id: string; status: PolicyVersionStatus; effectiveFrom: Date | null };

/**
 * Trạng thái hiển thị của từng phiên bản trong MỘT phạm vi (loại + nhà xe): bản đã kích hoạt có hiệu lực muộn nhất mà
 * không sau `now` là "Đang áp dụng", bản kích hoạt trước nó "Hết hiệu lực", bản hiệu lực ở tương lai "Đã lên lịch".
 */
export function policyStates(versions: readonly VersionLike[], now: Date): Map<string, "DRAFT" | "SCHEDULED" | "ACTIVE" | "EXPIRED" | "CANCELLED"> {
  const states = new Map<string, "DRAFT" | "SCHEDULED" | "ACTIVE" | "EXPIRED" | "CANCELLED">();
  let current: VersionLike | undefined;
  for (const version of versions) {
    if (version.status === PolicyVersionStatus.PUBLISHED && version.effectiveFrom && version.effectiveFrom <= now) {
      if (!current || version.effectiveFrom > current.effectiveFrom!) {
        current = version;
      }
    }
  }
  for (const version of versions) {
    if (version.status === PolicyVersionStatus.DRAFT) {
      states.set(version.id, "DRAFT");
    } else if (version.status === PolicyVersionStatus.CANCELLED) {
      states.set(version.id, "CANCELLED");
    } else if (version.effectiveFrom! > now) {
      states.set(version.id, "SCHEDULED");
    } else {
      states.set(version.id, version.id === current?.id ? "ACTIVE" : "EXPIRED");
    }
  }
  return states;
}

/** Trạng thái hiển thị của một mức hoa hồng / khung giá có khoảng hiệu lực `[from, to)`. */
export function ruleState(
  rule: { status: PolicyRuleStatus; effectiveFrom: Date; effectiveTo: Date | null },
  now: Date,
): "SCHEDULED" | "ACTIVE" | "EXPIRED" | "CANCELLED" {
  if (rule.status === PolicyRuleStatus.CANCELLED) {
    return "CANCELLED";
  }
  if (rule.effectiveFrom > now) {
    return "SCHEDULED";
  }
  return rule.effectiveTo && rule.effectiveTo <= now ? "EXPIRED" : "ACTIVE";
}

export type FareBandRow = {
  id: string;
  name: string;
  minPrice: bigint | null;
  maxPrice: bigint | null;
  effectiveFrom: Date;
  effectiveTo: Date;
  message: string;
};

export type FareBandWarning = {
  /** Vị trí quy tắc trong `rules` của bảng giá. */
  ruleIndex: number;
  price: number;
  bandId: string;
  bandName: string;
  minPrice: number | null;
  maxPrice: number | null;
  effectiveFrom: string;
  effectiveTo: string;
  message: string;
};

/** Khung giá còn hiệu lực hoặc sắp tới (chưa kết thúc, chưa hủy) — đọc được ở mọi scope (RLS `public_read`). */
export function loadOpenFareBands(tx: DbTransaction, now: Date): Promise<FareBandRow[]> {
  return tx.fareBand.findMany({
    where: { status: PolicyRuleStatus.ACTIVE, effectiveTo: { gt: now } },
    orderBy: [{ effectiveFrom: "asc" }, { id: "asc" }],
    select: { id: true, name: true, minPrice: true, maxPrice: true, effectiveFrom: true, effectiveTo: true, message: true },
  });
}

/**
 * Quy tắc giá nằm ngoài khung giá (FR-OPS-09, OQ-17 — chỉ cảnh báo). Quy tắc không có khung giờ áp dụng mọi chuyến nên
 * chịu mọi khung giá; quy tắc có khung giờ `[validFrom, validTo)` chỉ chịu khung giá có thời gian giao nhau.
 */
export function fareBandWarnings(
  rules: readonly { price: number; validFrom: string | null; validTo: string | null }[],
  bands: readonly FareBandRow[],
): FareBandWarning[] {
  const warnings: FareBandWarning[] = [];
  rules.forEach((rule, ruleIndex) => {
    for (const band of bands) {
      const overlaps =
        rule.validFrom === null ||
        rule.validTo === null ||
        (new Date(rule.validFrom) < band.effectiveTo && new Date(rule.validTo) > band.effectiveFrom);
      const price = BigInt(rule.price);
      const outside = (band.minPrice !== null && price < band.minPrice) || (band.maxPrice !== null && price > band.maxPrice);
      if (overlaps && outside) {
        warnings.push({
          ruleIndex,
          price: rule.price,
          bandId: band.id,
          bandName: band.name,
          minPrice: band.minPrice === null ? null : Number(band.minPrice),
          maxPrice: band.maxPrice === null ? null : Number(band.maxPrice),
          effectiveFrom: band.effectiveFrom.toISOString(),
          effectiveTo: band.effectiveTo.toISOString(),
          message: band.message,
        });
      }
    }
  });
  return warnings;
}
