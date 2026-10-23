import { createHmac, randomUUID, timingSafeEqual } from "node:crypto";
import { z } from "zod";
import { type CheckoutRequest, type PaymentGateway, PaymentGatewayError, type RefundRequest, type TransactionQuery, type TransactionStatus, type VerifiedCallback } from "../payment-gateway";

export type MomoConfig = {
  partnerCode: string;
  accessKey: string;
  secretKey: string;
  /** Gốc API MoMo (`https://test-payment.momo.vn` sandbox / production, hoặc cổng giả lập dev). */
  endpoint: string;
  /** URL IPN công khai của API (`…/v1/webhooks/payment/momo`). */
  ipnUrl: string;
};

const REQUEST_TIMEOUT_MS = 10_000;

/** Mã kết quả hoàn tiền nên thử lại: đang xử lý (7000, 7002), lỗi hệ thống (99). */
const RETRYABLE_REFUND_CODES = new Set([7000, 7002, 99]);

const RefundResponseSchema = z.object({ resultCode: z.number(), message: z.string().optional(), transId: z.union([z.number(), z.string()]).optional() });

const QueryResponseSchema = z.object({
  resultCode: z.number(),
  message: z.string().optional(),
  transId: z.union([z.number(), z.string()]).optional(),
  amount: z.union([z.number(), z.string()]).optional(),
});
/** `resultCode` của query: đang chờ khách / đang xử lý; 42 = không có đơn. */
const PENDING_QUERY_CODES = new Set([1000, 7000, 7002, 9000]);
const NOT_FOUND_QUERY_CODES = new Set([42]);

const CreateResponseSchema = z.object({
  resultCode: z.number(),
  message: z.string().optional(),
  payUrl: z.string().optional(),
});

// Thứ tự trường trong chuỗi ký IPN theo tài liệu MoMo AIO v2 (sắp theo tên).
const IPN_SIGNED_FIELDS = [
  "accessKey",
  "amount",
  "extraData",
  "message",
  "orderId",
  "orderInfo",
  "orderType",
  "partnerCode",
  "payType",
  "requestId",
  "responseTime",
  "resultCode",
  "transId",
] as const;

/**
 * Adapter MoMo AIO v2 (ADR-019): tạo giao dịch `POST /v2/gateway/api/create` (`captureWallet`) ký HMAC-SHA256 trên chuỗi
 * `key=value` cố định theo tài liệu (giá trị thô, không mã hoá) → `payUrl`. IPN POST JSON ký cùng cách; `resultCode = 0`
 * là thành công. Mọi lỗi gọi cổng → `PaymentGatewayError` không chứa khóa.
 */
export class MomoGateway implements PaymentGateway {
  readonly provider = "MOMO" as const;
  // Giới hạn giao dịch ví MoMo: 1.000đ – 50.000.000đ.
  readonly minAmount = 1_000n;
  readonly maxAmount = 50_000_000n;

  constructor(
    private readonly config: MomoConfig,
    private readonly fetchImpl: typeof fetch = fetch,
  ) {}

  async createCheckout(request: CheckoutRequest): Promise<{ paymentUrl: string }> {
    const body = {
      partnerCode: this.config.partnerCode,
      requestId: randomUUID(),
      amount: request.amount.toString(),
      orderId: request.paymentCode,
      orderInfo: request.orderInfo,
      redirectUrl: request.returnUrl,
      ipnUrl: this.config.ipnUrl,
      requestType: "captureWallet",
      extraData: "",
    };
    const raw = [
      `accessKey=${this.config.accessKey}`,
      `amount=${body.amount}`,
      `extraData=${body.extraData}`,
      `ipnUrl=${body.ipnUrl}`,
      `orderId=${body.orderId}`,
      `orderInfo=${body.orderInfo}`,
      `partnerCode=${body.partnerCode}`,
      `redirectUrl=${body.redirectUrl}`,
      `requestId=${body.requestId}`,
      `requestType=${body.requestType}`,
    ].join("&");
    let response: Response;
    try {
      response = await this.fetchImpl(`${this.config.endpoint}/v2/gateway/api/create`, {
        method: "POST",
        headers: { "content-type": "application/json" },
        body: JSON.stringify({ ...body, amount: Number(request.amount), lang: "vi", signature: sign(raw, this.config.secretKey) }),
        signal: AbortSignal.timeout(REQUEST_TIMEOUT_MS),
      });
    } catch {
      throw new PaymentGatewayError("Không kết nối được MoMo.");
    }
    const parsed = CreateResponseSchema.safeParse(await response.json().catch(() => null));
    if (!response.ok || !parsed.success || parsed.data.resultCode !== 0 || !parsed.data.payUrl) {
      throw new PaymentGatewayError(`MoMo từ chối tạo giao dịch (resultCode ${parsed.success ? parsed.data.resultCode : "?"}).`);
    }
    return { paymentUrl: parsed.data.payUrl };
  }

  /** Hoàn tiền `POST /v2/gateway/api/refund`: `orderId` = mã refund (duy nhất), `transId` = giao dịch thanh toán gốc. */
  async refund(request: RefundRequest): Promise<{ providerRefundId: string | null }> {
    const body = {
      partnerCode: this.config.partnerCode,
      orderId: request.refundCode,
      requestId: request.refundCode,
      amount: request.amount.toString(),
      transId: request.providerTxnId,
      description: request.reason,
    };
    const raw = [
      `accessKey=${this.config.accessKey}`,
      `amount=${body.amount}`,
      `description=${body.description}`,
      `orderId=${body.orderId}`,
      `partnerCode=${body.partnerCode}`,
      `requestId=${body.requestId}`,
      `transId=${body.transId}`,
    ].join("&");
    let response: Response;
    try {
      response = await this.fetchImpl(`${this.config.endpoint}/v2/gateway/api/refund`, {
        method: "POST",
        headers: { "content-type": "application/json" },
        body: JSON.stringify({ ...body, amount: Number(request.amount), transId: Number(request.providerTxnId), lang: "vi", signature: sign(raw, this.config.secretKey) }),
        signal: AbortSignal.timeout(REQUEST_TIMEOUT_MS),
      });
    } catch {
      throw new PaymentGatewayError("Không kết nối được MoMo.");
    }
    const parsed = RefundResponseSchema.safeParse(await response.json().catch(() => null));
    if (!response.ok || !parsed.success) {
      throw new PaymentGatewayError(`MoMo trả phản hồi hoàn tiền không hợp lệ (HTTP ${response.status}).`);
    }
    if (parsed.data.resultCode !== 0) {
      throw new PaymentGatewayError(
        `MoMo từ chối hoàn tiền (resultCode ${parsed.data.resultCode}).`,
        RETRYABLE_REFUND_CODES.has(parsed.data.resultCode),
        String(parsed.data.resultCode),
      );
    }
    return { providerRefundId: parsed.data.transId === undefined ? null : String(parsed.data.transId) };
  }

  /** `POST /v2/gateway/api/query` (ký HMAC-SHA256 accessKey, orderId, partnerCode, requestId). */
  async queryTransaction(request: TransactionQuery): Promise<TransactionStatus> {
    const raw = [`accessKey=${this.config.accessKey}`, `orderId=${request.paymentCode}`, `partnerCode=${this.config.partnerCode}`, `requestId=${request.requestCode}`].join("&");
    let response: Response;
    try {
      response = await this.fetchImpl(`${this.config.endpoint}/v2/gateway/api/query`, {
        method: "POST",
        headers: { "content-type": "application/json" },
        body: JSON.stringify({ partnerCode: this.config.partnerCode, requestId: request.requestCode, orderId: request.paymentCode, lang: "vi", signature: sign(raw, this.config.secretKey) }),
        signal: AbortSignal.timeout(REQUEST_TIMEOUT_MS),
      });
    } catch {
      throw new PaymentGatewayError("Không kết nối được MoMo.");
    }
    const parsed = QueryResponseSchema.safeParse(await response.json().catch(() => null));
    if (!response.ok || !parsed.success) {
      throw new PaymentGatewayError(`MoMo trả phản hồi tra cứu không hợp lệ (HTTP ${response.status}).`);
    }
    const { resultCode, transId, amount } = parsed.data;
    const status = resultCode === 0 ? "SUCCESS" : PENDING_QUERY_CODES.has(resultCode) ? "PENDING" : NOT_FOUND_QUERY_CODES.has(resultCode) ? "NOT_FOUND" : "FAILED";
    return {
      status,
      providerTxnId: status === "SUCCESS" && transId !== undefined ? String(transId) : null,
      amount: status === "SUCCESS" && amount !== undefined ? BigInt(amount) : null,
      resultCode: String(resultCode),
    };
  }

  verifyCallback(input: Record<string, unknown>): VerifiedCallback | null {
    const fields: Record<string, string> = {};
    for (const key of IPN_SIGNED_FIELDS) {
      if (key === "accessKey") continue;
      const value = input[key];
      if (typeof value !== "string" && typeof value !== "number") {
        return null;
      }
      fields[key] = String(value);
    }
    const raw = IPN_SIGNED_FIELDS.map((key) => `${key}=${key === "accessKey" ? this.config.accessKey : fields[key]}`).join("&");
    const given = input.signature;
    if (typeof given !== "string" || !safeEqualHex(sign(raw, this.config.secretKey), given)) {
      return null;
    }
    if (fields.partnerCode !== this.config.partnerCode || !/^\d+$/.test(fields.amount!)) {
      return null;
    }
    const success = fields.resultCode === "0";
    return {
      paymentCode: fields.orderId!,
      providerTxnId: fields.transId && fields.transId !== "0" ? fields.transId : null,
      amount: BigInt(fields.amount!),
      success,
      resultCode: fields.resultCode!,
      fields,
    };
  }
}

export function sign(data: string, secret: string): string {
  return createHmac("sha256", secret).update(Buffer.from(data, "utf-8")).digest("hex");
}

function safeEqualHex(expected: string, given: string): boolean {
  const a = Buffer.from(expected.toLowerCase());
  const b = Buffer.from(given.toLowerCase());
  return a.length === b.length && timingSafeEqual(a, b);
}
