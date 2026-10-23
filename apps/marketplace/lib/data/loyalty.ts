"use server";

import type { components } from "@vexenhanh/api-client";
import { apiRequest } from "./api";
import { failed, ok, type DataResult } from "./result";
import { refreshSessionIfNeeded } from "./session";
import { mapLoyaltyProfile, mapVoucher, type LoyaltyProfileData } from "./loyalty-mappers";
import { formatDateVi } from "../format";
import type { LoyaltyHistoryData, LoyaltyRedemptionQuote, LoyaltyTransactionType, UserVouchersData } from "./types";

type Schemas = components["schemas"];
const transactionTypes: Record<string, string> = { earn: "EARN", redeem: "REDEEM", expire: "EXPIRE", adjust: "ADJUST", revoke: "REVERSAL" };
const transactionLabels: Record<LoyaltyTransactionType, string> = { earn: "Tích điểm", redeem: "Đổi điểm", expire: "Hết hạn", adjust: "Điều chỉnh", revoke: "Thu hồi / hoàn điểm" };

/** Lấy số dư, hạng và chính sách thành viên hiện hành từ API. */
export async function getLoyaltyProfile(): Promise<DataResult<LoyaltyProfileData>> {
  const result = await apiRequest<Schemas["PassengerLoyaltyDto_Output"]>("/me/loyalty");
  if (result.status !== "ok") return result;
  try { return ok(mapLoyaltyProfile(result.data)); }
  catch { return failed("GET /me/loyalty", "Chính sách quy đổi điểm trả về giá trị không hợp lệ."); }
}

/** Đổi điểm bằng khóa của một lần xác nhận, sau đó đọc lại số dư thực tế. */
export async function redeemLoyaltyPoints(points: number, idempotencyKey: string): Promise<DataResult<LoyaltyRedemptionQuote>> {
  if (!Number.isSafeInteger(points) || points < 1 || points > 1_000_000 || !/^[\da-f-]{36}$/i.test(idempotencyKey)) {
    return failed("POST /me/loyalty/redemptions", "Số điểm hoặc mã yêu cầu đổi điểm không hợp lệ.");
  }
  const session = await refreshSessionIfNeeded();
  if (session.status !== "ok") return session;
  const result = await apiRequest<Schemas["UserVoucherDto_Output"]>("/me/loyalty/redemptions", {
    method: "POST", headers: { "Idempotency-Key": idempotencyKey }, body: JSON.stringify({ points })
  });
  if (result.status !== "ok") return result;
  const profile = await getLoyaltyProfile();
  return ok({ pointsToRedeem: points, voucherValueVnd: result.data.discountAmount ?? result.data.discountValue,
    remainingPoints: profile.status === "ok" ? profile.data.availablePoints : -1,
    expiryDaysText: "", expiryDateText: formatDateVi(result.data.expiresAt) });
}

/** Lấy một trang sổ điểm, lọc trên máy chủ theo loại và khoảng thời gian. */
export async function getLoyaltyHistory(page = 1, type?: string, period = "all"): Promise<DataResult<LoyaltyHistoryData>> {
  const pageIndex = Number.isSafeInteger(page) && page > 0 ? page : 1;
  const params = new URLSearchParams({ offset: String((pageIndex - 1) * 20), limit: "20" });
  if (type && transactionTypes[type]) params.set("type", transactionTypes[type]);
  if (["3m", "6m", "12m"].includes(period)) {
    const from = new Date();
    from.setUTCMonth(from.getUTCMonth() - Number.parseInt(period, 10));
    params.set("from", from.toISOString());
  }
  const [result, profile] = await Promise.all([
    apiRequest<Schemas["PassengerLoyaltyTransactionsDto_Output"]>(`/me/loyalty/transactions?${params}`), getLoyaltyProfile()
  ]);
  if (result.status !== "ok") return result;
  if (profile.status !== "ok") return profile;
  const types: Record<string, LoyaltyTransactionType> = { EARN: "earn", REDEEM: "redeem", EXPIRE: "expire", ADJUST: "adjust", REVERSAL: "revoke" };
  return ok({ availablePoints: profile.data.availablePoints, totalEarnedPoints: result.data.totals.earned,
    totalRedeemedPoints: result.data.totals.redeemed, totalExpiredPoints: result.data.totals.expired,
    transactions: result.data.items.map((item) => ({ id: item.id, dateText: formatDateVi(item.createdAt),
      type: types[item.type]!, typeLabel: transactionLabels[types[item.type]!], sourceText: item.sourceLabel,
      pointsChange: item.points })), totalCount: result.data.total, pageIndex, pageSize: 20 });
}

/** Lấy toàn bộ ví theo từng trang API để số đếm và bộ lọc không bỏ sót voucher. */
export async function getUserVouchers(status?: string): Promise<DataResult<UserVouchersData>> {
  const statuses: Record<string, string> = { available: "AVAILABLE", holding: "RESERVED", used: "USED", expired: "EXPIRED" };
  const vouchers: Schemas["UserVoucherDto_Output"][] = [];
  let total = 0;
  do {
    const params = new URLSearchParams({ offset: String(vouchers.length), limit: "50" });
    if (status && statuses[status]) params.set("status", statuses[status]);
    const result = await apiRequest<Schemas["UserVoucherPageDto_Output"]>(`/me/vouchers?${params}`);
    if (result.status !== "ok") return result;
    total = result.data.total;
    vouchers.push(...result.data.items);
    if (result.data.items.length === 0) break;
  } while (vouchers.length < total);
  const items = vouchers.map(mapVoucher);
  return ok({ vouchers: items, availableCount: items.filter((v) => v.status === "available").length,
    holdingCount: items.filter((v) => v.status === "holding").length,
    usedCount: items.filter((v) => v.status === "used").length, expiredCount: items.filter((v) => v.status === "expired").length });
}

/** Lưu mã công khai bằng trường promotionCode theo hợp đồng API. */
export async function saveVoucherCode(code: string): Promise<DataResult<{ readonly saved: boolean; readonly message: string }>> {
  const promotionCode = code.trim().toUpperCase();
  if (!/^[A-Z0-9]{3,20}$/.test(promotionCode)) return failed("POST /me/vouchers", "Mã khuyến mãi phải gồm 3–20 chữ cái hoặc chữ số.");
  const session = await refreshSessionIfNeeded();
  if (session.status !== "ok") return session;
  const result = await apiRequest<Schemas["UserVoucherDto_Output"]>("/me/vouchers", { method: "POST", body: JSON.stringify({ promotionCode }) });
  return result.status === "ok" ? ok({ saved: true, message: "Đã lưu mã vào ví voucher." }) : result;
}
