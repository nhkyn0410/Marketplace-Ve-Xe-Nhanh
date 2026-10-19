/**
 * Port cổng thanh toán (ADR-019, ADR-006/AS-08): domain chỉ phụ thuộc interface này, không gọi VNPay / MoMo trực tiếp.
 * Cổng là trang thanh toán được host (redirect) — hệ thống không chạm dữ liệu thẻ. Callback server-to-server (IPN) là
 * nguồn chân lý; trang quay về (return URL) chỉ để hiển thị.
 */
export const PAYMENT_GATEWAYS = Symbol("PAYMENT_GATEWAYS");

export type GatewayProvider = "VNPAY" | "MOMO";

export type CheckoutRequest = {
  /** Mã payment nội bộ gửi cổng (`vnp_TxnRef` / `orderId`). */
  paymentCode: string;
  /** VND, số nguyên đồng. */
  amount: bigint;
  /** Mô tả ngắn hiển thị ở cổng (không dấu, không ký tự đặc biệt). */
  orderInfo: string;
  /** Trang quay về sau khi khách thanh toán (chỉ hiển thị kết quả). */
  returnUrl: string;
  /** IP khách (VNPay bắt buộc `vnp_IpAddr`). */
  clientIp: string;
  createdAt: Date;
  /** Hạn thanh toán ở cổng (= hạn booking). */
  expiresAt: Date;
};

/** Kết quả callback ĐÃ xác thực chữ ký. */
export type VerifiedCallback = {
  paymentCode: string;
  /** Mã giao dịch của cổng; `null` khi cổng không cấp (giao dịch lỗi trước khi tạo). */
  providerTxnId: string | null;
  amount: bigint;
  success: boolean;
  /** Mã kết quả nguyên gốc của cổng (`vnp_ResponseCode` / `resultCode`). */
  resultCode: string;
  /** Trường đã xác thực (không gồm chữ ký) — lưu phục vụ đối soát. */
  fields: Record<string, string>;
};

export type RefundRequest = {
  /** Mã refund nội bộ gửi cổng (`vnp_RequestId` / `orderId` của lệnh hoàn MoMo). */
  refundCode: string;
  /** Mã payment đã gửi cổng lúc thanh toán (`vnp_TxnRef` / `orderId`). */
  paymentCode: string;
  /** Mã giao dịch thanh toán của cổng (`vnp_TransactionNo` / `transId`). */
  providerTxnId: string;
  /** VND cần hoàn. */
  amount: bigint;
  /** VND khách đã trả ở payment — VNPay phân biệt hoàn toàn phần / một phần. */
  paidAmount: bigint;
  /** Lúc tạo yêu cầu thanh toán (VNPay `vnp_TransactionDate` = `vnp_CreateDate` lúc thanh toán). */
  paymentCreatedAt: Date;
  /** Mô tả ngắn (không dấu). */
  reason: string;
  requestedAt: Date;
};

/** Tra cứu một giao dịch thanh toán ở cổng (đối soát — FR-BTP-17, UC-32, LLD §6.3 bước 4). */
export type TransactionQuery = {
  /** Mã payment đã gửi cổng lúc thanh toán (`vnp_TxnRef` / `orderId`). */
  paymentCode: string;
  /** Mã yêu cầu tra cứu, mỗi lần một khác (`vnp_RequestId` / `requestId`). */
  requestCode: string;
  /** Lúc tạo yêu cầu thanh toán (VNPay `vnp_TransactionDate`). */
  paymentCreatedAt: Date;
  requestedAt: Date;
};

/** Trạng thái giao dịch theo cổng: đã trả / thất bại / còn chờ / cổng không có giao dịch này. */
export type TransactionStatus = {
  status: "SUCCESS" | "FAILED" | "PENDING" | "NOT_FOUND";
  providerTxnId: string | null;
  /** VND cổng ghi nhận (thành công). */
  amount: bigint | null;
  resultCode: string;
};

export interface PaymentGateway {
  readonly provider: GatewayProvider;
  /** Giới hạn số tiền một giao dịch của cổng (VND). */
  readonly minAmount: bigint;
  readonly maxAmount: bigint;
  /** Tạo link trang thanh toán. Lỗi phía cổng → `PaymentGatewayError`. */
  createCheckout(request: CheckoutRequest): Promise<{ paymentUrl: string }>;
  /** Xác thực chữ ký callback (query VNPay / body MoMo); sai chữ ký / thiếu trường → `null`. */
  verifyCallback(input: Record<string, unknown>): VerifiedCallback | null;
  /**
   * Hoàn tiền về phương thức khách đã trả (API hoàn của cổng — OQ-13). Thành công → mã giao dịch hoàn của cổng; cổng từ
   * chối / lỗi → `PaymentGatewayError` (`retryable` = nên thử lại sau).
   */
  refund(request: RefundRequest): Promise<{ providerRefundId: string | null }>;
  /** Tra cứu trạng thái giao dịch thanh toán (querydr / query). Lỗi kết nối / phản hồi sai → `PaymentGatewayError`. */
  queryTransaction(request: TransactionQuery): Promise<TransactionStatus>;
}

/** Cổng không trả được kết quả hợp lệ (timeout, HTTP lỗi, từ chối). Message không chứa khóa / chữ ký. */
export class PaymentGatewayError extends Error {
  override readonly name = "PaymentGatewayError";

  constructor(
    message: string,
    /** `false` = cổng từ chối dứt khoát (không thử lại, chuyển xử lý thủ công). */
    readonly retryable = true,
    /** Mã kết quả của cổng nếu có. */
    readonly resultCode: string | null = null,
  ) {
    super(message);
  }
}

/** Cổng đã cấu hình, theo mã. Cổng không có trong map = chưa cấu hình (production chưa có khóa — OQ-22). */
export type PaymentGateways = ReadonlyMap<GatewayProvider, PaymentGateway>;
