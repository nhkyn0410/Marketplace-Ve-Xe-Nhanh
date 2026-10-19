import { unavailable, type DataResult } from "./result";
import type {
  LoyaltyHistoryData,
  LoyaltyProfile,
  LoyaltyRedemptionQuote,
  UserVouchersData
} from "./types";

/**
 * Lấy thông tin hồ sơ thành viên VXN Plus (SCR-PSG-33).
 * Endpoint: GET /me/loyalty
 */
export async function getLoyaltyProfile(): Promise<DataResult<LoyaltyProfile>> {
  return unavailable("GET /me/loyalty");
}

/**
 * Yêu cầu đổi điểm thưởng lấy voucher giảm giá (SCR-PSG-35).
 * Endpoint: POST /me/loyalty/redemptions
 */
export async function redeemLoyaltyPoints(
  _points: number
): Promise<DataResult<LoyaltyRedemptionQuote>> {
  return unavailable("POST /me/loyalty/redemptions");
}

/**
 * Lấy danh sách lịch sử biến động điểm thưởng (SCR-PSG-34).
 * Endpoint: GET /me/loyalty/transactions
 */
export async function getLoyaltyHistory(
  _page: number = 1,
  _type?: string
): Promise<DataResult<LoyaltyHistoryData>> {
  return unavailable("GET /me/loyalty/transactions");
}

/**
 * Lấy danh sách voucher trong ví của người dùng (SCR-PSG-36).
 * Endpoint: GET /me/vouchers
 */
export async function getUserVouchers(
  _status?: string
): Promise<DataResult<UserVouchersData>> {
  return unavailable("GET /me/vouchers");
}

/**
 * Lưu mã khuyến mãi công khai vào ví voucher (SCR-PSG-36).
 * Endpoint: POST /me/vouchers
 */
export async function saveVoucherCode(
  _code: string
): Promise<DataResult<{ readonly saved: boolean; readonly message: string }>> {
  return unavailable("POST /me/vouchers");
}
