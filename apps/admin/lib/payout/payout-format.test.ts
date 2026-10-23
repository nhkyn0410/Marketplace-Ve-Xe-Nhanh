import { ApiError } from "@vexenhanh/ui/lib/auth/api-client";
import { describe, expect, it } from "vitest";

import { bankLabel, checkItems, describePayoutError, periodLabel, rateLabel, rowAction, signedVnd } from "./payout-format";

describe("payout-format (ADM-002)", () => {
  it("thao tác cuối dòng theo trạng thái", () => {
    expect(rowAction("PENDING_REVIEW")).toBe("Rà soát");
    expect(rowAction("READY_TO_TRANSFER")).toBe("Xác nhận");
    expect(rowAction("FAILED")).toBe("Xử lý");
    expect(rowAction("PAID")).toBe("Xem");
  });

  it("kỳ, tài khoản che số, hoa hồng, tiền âm", () => {
    expect(periodLabel("2026-10-13")).toBe("13/10/2026");
    expect(bankLabel({ bankName: "Vietcombank", accountNumberMasked: "•••• 4521", accountHolder: "CTY" })).toBe("Vietcombank •• 4521");
    expect(bankLabel(null)).toBe("Chưa có tài khoản xác minh");
    expect(rateLabel(400)).toBe("4%");
    expect(signedVnd(-5, (value) => `${value} ₫`)).toBe("-5 ₫");
  });

  it("kiểm tra trước khi chi + câu lỗi (lý do kiểm tra, thời điểm chuyển khoản, xác nhận danh tính)", () => {
    expect(checkItems({ ledgerMatches: true, noPendingRefunds: false, bankVerified: true }).map((item) => item.ok)).toEqual([true, false, true]);
    expect(describePayoutError(new ApiError(409, "PAYOUT_CHECKS_FAILED", "x", ["PENDING_REFUNDS", "BANK_NOT_VERIFIED"]))).toEqual({
      message: "Chưa chi được: còn hoàn tiền đang treo, tài khoản nhận tiền chưa xác minh.",
      refresh: true
    });
    expect(describePayoutError(new ApiError(422, "PAYOUT_TRANSFER_TIME_INVALID", "x")).field).toBe("transferredAt");
    expect(describePayoutError(new ApiError(401, "AUTH_INVALID_CREDENTIALS", "x")).field).toBe("identity");
    expect(describePayoutError(new ApiError(503, "SERVICE_UNAVAILABLE", "x")).message).toContain("nhật ký");
  });
});
