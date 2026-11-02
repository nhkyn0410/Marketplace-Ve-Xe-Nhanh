import { ApiError } from "@vexenhanh/ui/lib/auth/api-client";
import { describe, expect, it } from "vitest";

import type { PaymentDetail } from "./payment-api";
import { allocationRows, describeRefundError, moment, paymentNote, paymentTimeline, reconcileReasonLabel, refundAction, refundNote, tripMoment } from "./payment-format";

const DETAIL: PaymentDetail = {
  paymentId: "p1",
  paymentCode: "PAY123",
  bookingId: "b1",
  bookingCode: "VXN8F3K2Q",
  operatorId: "o1",
  operatorName: "Sao Việt Express",
  provider: "VNPAY",
  amount: 560_000,
  status: "SUCCESS",
  reconcileReason: null,
  failureCode: null,
  reconcileResolved: false,
  createdAt: "2026-10-08T07:10:42.000Z",
  paidAt: "2026-10-08T07:12:08.000Z",
  providerTxnId: "VNP14982231",
  expiresAt: "2026-10-08T07:20:42.000Z",
  lastCallbackAt: "2026-10-08T07:12:08.000Z",
  amountMatches: true,
  booking: {
    status: "CONFIRMED",
    routeName: "Sài Gòn – Đà Lạt",
    departureAt: "2026-10-16T15:30:00.000Z",
    contactName: "Nguyễn Văn K***",
    seatCodes: ["A03", "A04"],
    subtotal: 560_000,
    serviceFee: 0,
    discount: 0,
    total: 560_000,
    createdAt: "2026-10-08T07:10:05.000Z"
  },
  allocation: { commissionAmount: 28_000, commissionRateBps: 500, operatorNet: 532_000 },
  histories: [
    { fromStatus: null, toStatus: "INITIATED", reason: null, actor: "Khách hàng", createdAt: "2026-10-08T07:10:42.000Z" },
    { fromStatus: "INITIATED", toStatus: "SUCCESS", reason: "Cổng xác nhận.", actor: "Cổng VNPay", createdAt: "2026-10-08T07:12:08.000Z" }
  ],
  tickets: [
    { ticketCode: "VXN8F3K2Q-01", seatCode: "A03", status: "VALID", issuedAt: "2026-10-08T07:12:10.000Z" },
    { ticketCode: "VXN8F3K2Q-02", seatCode: "A04", status: "VALID", issuedAt: "2026-10-08T07:12:10.000Z" }
  ],
  ledger: [
    { entryType: "PAYMENT_CAPTURED", amount: 560_000, eligibleAt: "2026-10-19T22:30:00.000Z", createdAt: "2026-10-08T07:12:09.000Z" },
    { entryType: "COMMISSION", amount: -28_000, eligibleAt: "2026-10-19T22:30:00.000Z", createdAt: "2026-10-08T07:12:09.000Z" }
  ],
  refunds: [],
  canRefund: false
};

describe("payment-format (ADM-002 Giao dịch)", () => {
  it("giờ VN, ghi chú dòng, thao tác cuối dòng", () => {
    expect(moment("2026-10-08T07:12:00.000Z")).toBe("08/10 · 14:12");
    expect(tripMoment("2026-10-16T15:30:00.000Z")).toBe("22:30 ngày 16/10/2026");
    expect(paymentNote({ status: "RECONCILING", reconcileReason: "DUPLICATE_PAYMENT", reconcileResolved: false, failureCode: null })).toBe("Trả trùng cho cùng đơn");
    expect(paymentNote({ status: "RECONCILING", reconcileReason: "BOOKING_EXPIRED", reconcileResolved: true, failureCode: null })).toBe("Đã tạo hoàn tiền");
    expect(paymentNote({ status: "FAILED", reconcileReason: null, reconcileResolved: false, failureCode: "24" })).toBe("Mã lỗi cổng 24");
    expect(paymentNote({ status: "SUCCESS", reconcileReason: null, reconcileResolved: false, failureCode: null })).toBeNull();
    expect(reconcileReasonLabel("XYZ")).toBe("XYZ");
    expect(refundNote({ status: "FAILED", provider: "MOMO", failureCode: "1001" })).toBe("Cổng MoMo trả lỗi 1001");
    expect(refundNote({ status: "PROCESSING", provider: "VNPAY", failureCode: null })).toBe("Đã gửi cổng VNPay");
    expect(refundAction("FAILED")).toBe("Xử lý");
    expect(refundAction("SUCCESS")).toBe("Xem");
  });

  it("dòng thời gian mới trước (cùng thời điểm: bước sau đứng trước); mốc chi trả tương lai đánh dấu dự kiến; phân bổ theo sổ", () => {
    const sameTime = paymentTimeline({ ...DETAIL, histories: [], booking: { ...DETAIL.booking, createdAt: "2026-10-08T07:12:09.000Z" }, tickets: DETAIL.tickets.map((ticket) => ({ ...ticket, issuedAt: "2026-10-08T07:12:09.000Z" })) }, new Date("2026-10-10T00:00:00.000Z"));
    expect(sameTime.map((event) => event.title)).toEqual(["Đủ điều kiện chi trả cho nhà xe", "Phát hành 2 vé", "Ghi sổ giữ hộ", "Tạo đơn đặt vé"]);
    const events = paymentTimeline(DETAIL, new Date("2026-10-10T00:00:00.000Z"));
    expect(events.map((event) => event.title)).toEqual([
      "Đủ điều kiện chi trả cho nhà xe",
      "Phát hành 2 vé",
      "Ghi sổ giữ hộ",
      "Cổng VNPay xác nhận thành công",
      "Tạo thanh toán",
      "Tạo đơn đặt vé"
    ]);
    expect(events[0]!.future).toBe(true);
    expect(events[1]!.detail).toBe("VXN8F3K2Q-01, VXN8F3K2Q-02");
    expect(allocationRows(DETAIL).map((row) => [row.label, row.amount])).toEqual([
      ["Giá vé (2 chỗ)", 560_000],
      ["Khách thanh toán qua cổng", 560_000],
      ["Hoa hồng 5% trên giá vé", 28_000],
      ["Nhà xe nhận khi chi trả", 532_000]
    ]);
    expect(allocationRows({ ...DETAIL, allocation: null })).toHaveLength(2);
    const reconciling = paymentTimeline({
      ...DETAIL,
      status: "RECONCILING",
      reconcileReason: "DUPLICATE_PAYMENT",
      histories: [{ fromStatus: "PROCESSING", toStatus: "RECONCILING", reason: "Cần đối soát: DUPLICATE_PAYMENT.", actor: "Cổng VNPay", createdAt: "2026-10-08T07:13:00.000Z" }]
    });
    expect(reconciling.find((event) => event.title === "Chuyển cần đối soát")?.detail).toBe("Trả trùng cho cùng đơn");
  });

  it("câu lỗi: xác nhận danh tính, trạng thái đổi (tải lại), dữ liệu sai, audit lỗi", () => {
    expect(describeRefundError(new ApiError(401, "AUTH_INVALID_CREDENTIALS", "x")).field).toBe("identity");
    expect(describeRefundError(new ApiError(409, "REFUND_STATUS_INVALID", "Đang APPROVED."))).toEqual({ message: "Đang APPROVED. Tải lại để xem trạng thái mới.", refresh: true });
    expect(describeRefundError(new ApiError(400, "BAD_REQUEST", "x")).message).toContain("3–500");
    expect(describeRefundError(new ApiError(503, "SERVICE_UNAVAILABLE", "x")).message).toContain("nhật ký");
    expect(describeRefundError(new Error("network")).message).toContain("kết nối");
  });
});
