import { createHmac, timingSafeEqual } from "node:crypto";
import { z } from "zod";
import { type CheckoutRequest, type PaymentGateway, PaymentGatewayError, type RefundRequest, type TransactionQuery, type TransactionStatus, type VerifiedCallback } from "../payment-gateway";

export type VnpayConfig = {
  tmnCode: string;
  hashSecret: string;
  /** Trang thanh toán (`…/paymentv2/vpcpay.html`): sandbox, production, hoặc cổng giả lập dev. */
  paymentUrl: string;
  /** API truy vấn / hoàn tiền (`…/merchant_webapi/api/transaction`). */
  apiUrl: string;
};

const VN_OFFSET_MS = 7 * 3_600_000;
const REQUEST_TIMEOUT_MS = 15_000;
/** Mã phản hồi hoàn tiền nên thử lại: trùng yêu cầu trong thời gian giới hạn (94), lỗi chưa xác định (99). */
const RETRYABLE_REFUND_CODES = new Set(["94", "99"]);

/** `vnp_TransactionStatus` của querydr: giao dịch đã trả (kể cả đã / đang hoàn sau đó) / còn chờ; còn lại = không thành công. */
const PAID_STATUSES = new Set(["00", "04", "05", "06", "09"]);
const PENDING_STATUSES = new Set(["01", "07"]);

const RefundResponseSchema = z.object({
  vnp_ResponseId: z.string(),
  vnp_Command: z.string(),
  vnp_ResponseCode: z.string(),
  vnp_Message: z.string().optional(),
  vnp_TmnCode: z.string().optional(),
  vnp_TxnRef: z.string().optional(),
  vnp_Amount: z.string().optional(),
  vnp_BankCode: z.string().optional(),
  vnp_PayDate: z.string().optional(),
  vnp_TransactionNo: z.string().optional(),
  vnp_TransactionType: z.string().optional(),
  vnp_TransactionStatus: z.string().optional(),
  vnp_OrderInfo: z.string().optional(),
  vnp_PromotionCode: z.string().optional(),
  vnp_PromotionAmount: z.string().optional(),
  vnp_SecureHash: z.string(),
});

/**
 * Adapter VNPay PAY v2.1.0 (ADR-019): link thanh toán ký HMAC-SHA512 trên chuỗi tham số `vnp_*` sắp theo tên, giá trị
 * mã hoá URL (khoảng trắng = `+`) — đúng cách code mẫu Node của VNPay. IPN gửi lại các tham số `vnp_*` + `vnp_SecureHash`
 * ký cùng cách. `vnp_Amount` = số tiền × 100. Giờ tạo / hết hạn theo GMT+7 `yyyyMMddHHmmss`.
 */
export class VnpayGateway implements PaymentGateway {
  readonly provider = "VNPAY" as const;
  // Giới hạn giao dịch của VNPay: từ 5.000đ tới dưới 1 tỷ đồng.
  readonly minAmount = 5_000n;
  readonly maxAmount = 999_999_999n;

  constructor(
    private readonly config: VnpayConfig,
    private readonly fetchImpl: typeof fetch = fetch,
  ) {}

  async createCheckout(request: CheckoutRequest): Promise<{ paymentUrl: string }> {
    const params: Record<string, string> = {
      vnp_Version: "2.1.0",
      vnp_Command: "pay",
      vnp_TmnCode: this.config.tmnCode,
      vnp_Amount: (request.amount * 100n).toString(),
      vnp_CurrCode: "VND",
      vnp_TxnRef: request.paymentCode,
      vnp_OrderInfo: request.orderInfo,
      vnp_OrderType: "other",
      vnp_Locale: "vn",
      vnp_ReturnUrl: request.returnUrl,
      vnp_IpAddr: request.clientIp,
      vnp_CreateDate: vnTimestamp(request.createdAt),
      vnp_ExpireDate: vnTimestamp(request.expiresAt),
    };
    const query = signedQuery(params);
    return { paymentUrl: `${this.config.paymentUrl}?${query}&vnp_SecureHash=${sign(query, this.config.hashSecret)}` };
  }

  verifyCallback(input: Record<string, unknown>): VerifiedCallback | null {
    const fields: Record<string, string> = {};
    for (const [key, value] of Object.entries(input)) {
      if (key.startsWith("vnp_") && key !== "vnp_SecureHash" && key !== "vnp_SecureHashType" && typeof value === "string") {
        fields[key] = value;
      }
    }
    const given = input.vnp_SecureHash;
    if (typeof given !== "string" || !safeEqualHex(sign(signedQuery(fields), this.config.hashSecret), given)) {
      return null;
    }
    const { vnp_TxnRef: paymentCode, vnp_Amount: amount, vnp_ResponseCode: responseCode, vnp_TmnCode: tmnCode } = fields;
    if (!paymentCode || !amount || !/^\d+$/.test(amount) || !responseCode || tmnCode !== this.config.tmnCode) {
      return null;
    }
    const minor = BigInt(amount);
    if (minor % 100n !== 0n) {
      return null;
    }
    const transactionNo = fields.vnp_TransactionNo;
    return {
      paymentCode,
      // VNPay trả `vnp_TransactionNo = 0` khi giao dịch chưa được tạo phía ngân hàng.
      providerTxnId: transactionNo && transactionNo !== "0" ? transactionNo : null,
      amount: minor / 100n,
      success: responseCode === "00" && fields.vnp_TransactionStatus === "00",
      resultCode: responseCode,
      fields,
    };
  }

  /**
   * Hoàn tiền qua `merchant_webapi` (JSON, `vnp_Command = refund`): `vnp_TransactionType` 02 = hoàn toàn phần, 03 = một
   * phần; chữ ký HMAC-SHA512 trên các trường nối bằng `|` theo thứ tự tài liệu; phản hồi cũng được kiểm chữ ký.
   */
  async refund(request: RefundRequest): Promise<{ providerRefundId: string | null }> {
    const fields: Record<string, string> = {
      vnp_RequestId: request.refundCode,
      vnp_Version: "2.1.0",
      vnp_Command: "refund",
      vnp_TmnCode: this.config.tmnCode,
      vnp_TransactionType: request.amount === request.paidAmount ? "02" : "03",
      vnp_TxnRef: request.paymentCode,
      vnp_Amount: (request.amount * 100n).toString(),
      vnp_TransactionNo: request.providerTxnId,
      vnp_TransactionDate: vnTimestamp(request.paymentCreatedAt),
      vnp_CreateBy: "vexenhanh",
      vnp_CreateDate: vnTimestamp(request.requestedAt),
      vnp_IpAddr: "127.0.0.1",
      vnp_OrderInfo: request.reason,
    };
    let response: Response;
    try {
      response = await this.fetchImpl(this.config.apiUrl, {
        method: "POST",
        headers: { "content-type": "application/json" },
        body: JSON.stringify({ ...fields, vnp_SecureHash: sign(refundSignData(fields), this.config.hashSecret) }),
        signal: AbortSignal.timeout(REQUEST_TIMEOUT_MS),
      });
    } catch {
      throw new PaymentGatewayError("Không kết nối được VNPay.");
    }
    const parsed = RefundResponseSchema.safeParse(await response.json().catch(() => null));
    if (!response.ok || !parsed.success) {
      throw new PaymentGatewayError(`VNPay trả phản hồi hoàn tiền không hợp lệ (HTTP ${response.status}).`);
    }
    const body = parsed.data;
    if (!safeEqualHex(sign(refundResponseSignData(body), this.config.hashSecret), body.vnp_SecureHash)) {
      throw new PaymentGatewayError("Chữ ký phản hồi hoàn tiền của VNPay không khớp.");
    }
    if (body.vnp_ResponseCode !== "00") {
      throw new PaymentGatewayError(
        `VNPay từ chối hoàn tiền (mã ${body.vnp_ResponseCode}).`,
        RETRYABLE_REFUND_CODES.has(body.vnp_ResponseCode),
        body.vnp_ResponseCode,
      );
    }
    return { providerRefundId: body.vnp_TransactionNo && body.vnp_TransactionNo !== "0" ? body.vnp_TransactionNo : null };
  }

  /** querydr (merchant_webapi): ký chuỗi nối `|`, kiểm chữ ký phản hồi. Mã 91 = không có giao dịch; 94 / 99 = thử lại sau. */
  async queryTransaction(request: TransactionQuery): Promise<TransactionStatus> {
    const fields: Record<string, string> = {
      vnp_RequestId: request.requestCode,
      vnp_Version: "2.1.0",
      vnp_Command: "querydr",
      vnp_TmnCode: this.config.tmnCode,
      vnp_TxnRef: request.paymentCode,
      vnp_TransactionDate: vnTimestamp(request.paymentCreatedAt),
      vnp_CreateDate: vnTimestamp(request.requestedAt),
      vnp_IpAddr: "127.0.0.1",
      vnp_OrderInfo: `Doi soat ${request.paymentCode}`,
    };
    let response: Response;
    try {
      response = await this.fetchImpl(this.config.apiUrl, {
        method: "POST",
        headers: { "content-type": "application/json" },
        body: JSON.stringify({ ...fields, vnp_SecureHash: sign(queryDrSignData(fields), this.config.hashSecret) }),
        signal: AbortSignal.timeout(REQUEST_TIMEOUT_MS),
      });
    } catch {
      throw new PaymentGatewayError("Không kết nối được VNPay.");
    }
    const parsed = RefundResponseSchema.safeParse(await response.json().catch(() => null));
    if (!response.ok || !parsed.success) {
      throw new PaymentGatewayError(`VNPay trả phản hồi tra cứu không hợp lệ (HTTP ${response.status}).`);
    }
    const body = parsed.data;
    if (!safeEqualHex(sign(queryDrResponseSignData(body), this.config.hashSecret), body.vnp_SecureHash)) {
      throw new PaymentGatewayError("Chữ ký phản hồi tra cứu của VNPay không khớp.");
    }
    if (body.vnp_ResponseCode === "91") {
      return { status: "NOT_FOUND", providerTxnId: null, amount: null, resultCode: "91" };
    }
    if (body.vnp_ResponseCode !== "00") {
      throw new PaymentGatewayError(`VNPay từ chối tra cứu (mã ${body.vnp_ResponseCode}).`, RETRYABLE_REFUND_CODES.has(body.vnp_ResponseCode), body.vnp_ResponseCode);
    }
    const state = body.vnp_TransactionStatus ?? "";
    const status = PAID_STATUSES.has(state) ? "SUCCESS" : PENDING_STATUSES.has(state) ? "PENDING" : "FAILED";
    return {
      status,
      providerTxnId: body.vnp_TransactionNo && body.vnp_TransactionNo !== "0" ? body.vnp_TransactionNo : null,
      amount: body.vnp_Amount ? BigInt(body.vnp_Amount) / 100n : null,
      resultCode: state,
    };
  }
}

export function queryDrSignData(fields: Record<string, string>): string {
  return ["vnp_RequestId", "vnp_Version", "vnp_Command", "vnp_TmnCode", "vnp_TxnRef", "vnp_TransactionDate", "vnp_CreateDate", "vnp_IpAddr", "vnp_OrderInfo"]
    .map((key) => fields[key] ?? "")
    .join("|");
}

export function queryDrResponseSignData(fields: Record<string, string | undefined>): string {
  return [
    "vnp_ResponseId",
    "vnp_Command",
    "vnp_ResponseCode",
    "vnp_Message",
    "vnp_TmnCode",
    "vnp_TxnRef",
    "vnp_Amount",
    "vnp_BankCode",
    "vnp_PayDate",
    "vnp_TransactionNo",
    "vnp_TransactionType",
    "vnp_TransactionStatus",
    "vnp_OrderInfo",
    "vnp_PromotionCode",
    "vnp_PromotionAmount",
  ]
    .map((key) => fields[key] ?? "")
    .join("|");
}

export function refundSignData(fields: Record<string, string>): string {
  return [
    "vnp_RequestId",
    "vnp_Version",
    "vnp_Command",
    "vnp_TmnCode",
    "vnp_TransactionType",
    "vnp_TxnRef",
    "vnp_Amount",
    "vnp_TransactionNo",
    "vnp_TransactionDate",
    "vnp_CreateBy",
    "vnp_CreateDate",
    "vnp_IpAddr",
    "vnp_OrderInfo",
  ]
    .map((key) => fields[key] ?? "")
    .join("|");
}

export function refundResponseSignData(fields: Record<string, string | undefined>): string {
  return [
    "vnp_ResponseId",
    "vnp_Command",
    "vnp_ResponseCode",
    "vnp_Message",
    "vnp_TmnCode",
    "vnp_TxnRef",
    "vnp_Amount",
    "vnp_BankCode",
    "vnp_PayDate",
    "vnp_TransactionNo",
    "vnp_TransactionType",
    "vnp_TransactionStatus",
    "vnp_OrderInfo",
  ]
    .map((key) => fields[key] ?? "")
    .join("|");
}

/** Chuỗi ký = query `key=value` sắp theo tên, giá trị `encodeURIComponent` với khoảng trắng thành `+` (mẫu VNPay). */
export function signedQuery(params: Record<string, string>): string {
  return Object.keys(params)
    .sort()
    .map((key) => `${encodeURIComponent(key)}=${encodeURIComponent(params[key]!).replace(/%20/g, "+")}`)
    .join("&");
}

export function sign(data: string, secret: string): string {
  return createHmac("sha512", secret).update(Buffer.from(data, "utf-8")).digest("hex");
}

function safeEqualHex(expected: string, given: string): boolean {
  const a = Buffer.from(expected.toLowerCase());
  const b = Buffer.from(given.toLowerCase());
  return a.length === b.length && timingSafeEqual(a, b);
}

export function vnTimestamp(date: Date): string {
  return new Date(date.getTime() + VN_OFFSET_MS).toISOString().replace(/[-:T]/g, "").slice(0, 14);
}
