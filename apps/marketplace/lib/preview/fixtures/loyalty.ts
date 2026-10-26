import type {
  LoyaltyHistoryData,
  LoyaltyRedemptionQuote,
  UserVouchersData
} from "../../data/types";
import type { LoyaltyProfileData } from "../../data/loyalty-mappers";

/**
 * Fixture hồ sơ thành viên VXN Plus (SCR-PSG-33 - Figma 1448:19617).
 */
export const loyaltyProfileFixture: LoyaltyProfileData = {
  currentTier: "silver",
  currentTierName: "Hạng Bạc",
  multiplierText: "Hệ số tích điểm ×1,2",
  pointsIn12Months: 2450,
  targetPointsForNextTier: 5000,
  pointsRequiredForNextTier: 2550,
  nextTierName: "Vàng",
  nextTierMultiplierText: "×1,5",
  availablePoints: 1250,
  estimatedVoucherVnd: "1250000",
  // Chính sách mẫu theo LLD-OQ-06 (Khanh chốt 18/10/2026): 1 điểm = 1.000đ, đổi từ 100 điểm, voucher 30 ngày,
  // tích 1 điểm / 10.000đ. Hạn điểm 12 tháng chỉ là số minh hoạ cho preview.
  rules: {
    earnUnit: 10000,
    pointValue: 1000,
    minRedeemPoints: 100,
    pointExpiryMonths: 12,
    voucherValidityDays: 30,
    tiers: [
      { tier: "BRONZE", minPoints: 0, multiplierPercent: 100 },
      { tier: "SILVER", minPoints: 2000, multiplierPercent: 120 },
      { tier: "GOLD", minPoints: 5000, multiplierPercent: 150 },
      { tier: "PLATINUM", minPoints: 10000, multiplierPercent: 200 }
    ]
  },
  tiers: [
    {
      code: "bronze",
      name: "Đồng",
      minPoints12mText: "Từ 0 điểm",
      multiplierText: "×1,0",
      isCurrent: false
    },
    {
      code: "silver",
      name: "Bạc",
      minPoints12mText: "Từ 2.000 điểm",
      multiplierText: "×1,2",
      isCurrent: true
    },
    {
      code: "gold",
      name: "Vàng",
      minPoints12mText: "Từ 5.000 điểm",
      multiplierText: "×1,5",
      isCurrent: false
    },
    {
      code: "platinum",
      name: "Bạch kim",
      minPoints12mText: "Từ 10.000 điểm",
      multiplierText: "×2,0",
      isCurrent: false
    }
  ]
};

/**
 * Fixture báo giá quy đổi điểm thưởng sang voucher (SCR-PSG-35 - Figma 1448:20406).
 */
export const loyaltyRedemptionQuoteFixture: LoyaltyRedemptionQuote = {
  pointsToRedeem: 100,
  voucherValueVnd: "100000",
  remainingPoints: 1150,
  expiryDaysText: "30 ngày",
  expiryDateText: "đến 07/11/2026"
};

/**
 * Fixture lịch sử biến động điểm thưởng (SCR-PSG-34 - Figma 1448:19985).
 */
export const loyaltyHistoryFixture: LoyaltyHistoryData = {
  availablePoints: 1250,
  totalEarnedPoints: 2870,
  totalRedeemedPoints: 1300,
  totalExpiredPoints: 200,
  totalCount: 24,
  pageIndex: 1,
  pageSize: 6,
  transactions: [
    {
      id: "tx-01",
      dateText: "05/10/2026",
      type: "redeem",
      typeLabel: "Đổi điểm",
      sourceText: "Voucher giảm 100.000đ",
      pointsChange: -100
    },
    {
      id: "tx-02",
      dateText: "22/09/2026",
      type: "earn",
      typeLabel: "Tích điểm",
      sourceText: "Đơn VXN-7Q2L5B · hệ số ×1,2",
      pointsChange: 384
    },
    {
      id: "tx-03",
      dateText: "31/08/2026",
      type: "expire",
      typeLabel: "Hết hạn",
      sourceText: "Điểm tích ngày 31/08/2025",
      pointsChange: -200
    },
    {
      id: "tx-04",
      dateText: "14/08/2026",
      type: "revoke",
      typeLabel: "Thu hồi",
      sourceText: "Hoàn tiền vé thuộc đơn VXN-3D5F1G",
      pointsChange: -120
    },
    {
      id: "tx-05",
      dateText: "02/08/2026",
      type: "adjust",
      typeLabel: "Điều chỉnh",
      sourceText: "CSKH cộng bù do sự cố chuyến",
      pointsChange: 50
    },
    {
      id: "tx-06",
      dateText: "18/07/2026",
      type: "earn",
      typeLabel: "Tích điểm",
      sourceText: "Đơn VXN-9A1B7C · hệ số ×1,2",
      pointsChange: 336
    }
  ]
};

/**
 * Fixture ví voucher của người dùng (SCR-PSG-36 - Figma 1448:20565).
 */
export const userVouchersFixture: UserVouchersData = {
  availableCount: 4,
  usedCount: 4,
  expiredCount: 1,
  vouchers: [
    {
      id: "v-01",
      code: "VXN-RED-100K",
      title: "Giảm 100.000đ",
      type: "loyalty_redemption",
      typeLabel: "Đổi điểm",
      status: "available",
      statusLabel: "Khả dụng",
      scopeText: "Áp dụng mọi tuyến, mọi nhà xe.",
      expiryDateText: "05/11/2026",
      discountValueVnd: "100000"
    },
    {
      id: "v-02",
      code: "THU10",
      title: "THU10 · Giảm 10%",
      type: "public_code",
      typeLabel: "Mã đã lưu",
      status: "available",
      statusLabel: "Khả dụng",
      scopeText: "Tối đa 50.000đ · Phương Nam Travel · đơn từ 300.000đ.",
      expiryDateText: "31/10/2026"
    },
    {
      id: "v-03",
      code: "TAYBAC30",
      title: "TAYBAC30 · Giảm 30.000đ",
      type: "public_code",
      typeLabel: "Mã đã lưu",
      status: "available",
      statusLabel: "Sắp hết hạn",
      scopeText: "Chỉ áp dụng tuyến Hà Nội – Sapa.",
      expiryDateText: "15/10/2026",
      discountValueVnd: "30000"
    },
    {
      id: "v-04",
      code: "VXN-RED-200K",
      title: "Giảm 200.000đ",
      type: "loyalty_redemption",
      typeLabel: "Đổi điểm",
      status: "holding",
      statusLabel: "Đang giữ",
      scopeText: "Đang giữ cho đơn VXN-2M7T9A chờ thanh toán.",
      expiryDateText: "20/11/2026",
      discountValueVnd: "200000",
      holdingNote:
        'Voucher đang giữ sẽ chuyển thành "Đã dùng" khi thanh toán thành công, hoặc trở về ví nếu đơn hết hạn hay thanh toán thất bại.'
    }
  ]
};
