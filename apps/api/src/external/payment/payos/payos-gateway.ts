import { createHmac, timingSafeEqual } from "node:crypto";
import { z } from "zod";
import { type CheckoutRequest, type CheckoutTransfer, type PaymentGateway, PaymentGatewayError, type TransactionQuery, type TransactionStatus, type VerifiedCallback } from "../payment-gateway";

/** Cấu hình kết nối kênh thu payOS, chỉ được giữ ở backend. */
export type PayosConfig = { clientId: string; apiKey: string; checksumKey: string; apiUrl: string };

const REQUEST_TIMEOUT_MS = 10_000;
const MAX_INTEGER = BigInt(Number.MAX_SAFE_INTEGER);
const IntegerSchema = z.number().int().nonnegative().max(Number.MAX_SAFE_INTEGER);
const OrderCodeSchema = IntegerSchema.positive();
const EnvelopeSchema = z.object({ code: z.string(), data: z.unknown().optional(), signature: z.string().optional() });
const CheckoutSchema = z.object({
  orderCode: OrderCodeSchema,
  amount: IntegerSchema.positive(),
  currency: z.literal("VND"),
  checkoutUrl: z.url().refine((url) => new URL(url).protocol === "https:"),
  qrCode: z.string().min(1),
  bin: z.string().regex(/^\d{6}$/),
  accountNumber: z.string().min(1),
  accountName: z.string().min(1),
  description: z.string().min(1),
  paymentLinkId: z.string().min(1),
  status: z.enum(["PENDING", "PROCESSING", "PAID"]),
});
const QuerySchema = z.object({
  orderCode: OrderCodeSchema,
  amount: IntegerSchema.positive(),
  amountPaid: IntegerSchema,
  amountRemaining: IntegerSchema,
  status: z.enum(["PENDING", "PROCESSING", "PAID", "CANCELLED", "EXPIRED"]),
  transactions: z.array(z.object({ reference: z.string().min(1), amount: IntegerSchema.positive() })),
});
const RecoverSchema = z.object({ id: z.string().regex(/^[a-f\d]{32}$/i), orderCode: OrderCodeSchema, amount: IntegerSchema.positive(), status: z.enum(["PENDING", "PROCESSING", "PAID"]) });
const WebhookSchema = z.object({
  code: z.literal("00"),
  success: z.literal(true),
  signature: z.string(),
  data: z.object({
    orderCode: OrderCodeSchema,
    amount: IntegerSchema.positive(),
    code: z.literal("00"),
    currency: z.literal("VND"),
    reference: z.string().min(1),
    paymentLinkId: z.string().min(1),
    description: z.string(),
  }),
});

/** Adapter payOS VietQR: tạo link, xác thực webhook, tra cứu và hủy link thanh toán. */
export class PayosGateway implements PaymentGateway {
  readonly provider = "PAYOS" as const;
  readonly minAmount = 1n;
  readonly maxAmount = MAX_INTEGER;

  constructor(private readonly config: PayosConfig, private readonly fetchImpl: typeof fetch = fetch) {}

  /** Tạo link có hạn bằng mã số payOS và kiểm chữ ký cùng số tiền của phản hồi. */
  async createCheckout(request: CheckoutRequest): Promise<{ paymentUrl: string; transfer?: CheckoutTransfer }> {
    const orderCode = safeInteger(request.orderCode);
    const amount = safeInteger(request.amount);
    const description = request.paymentCode.slice(-9);
    const cancelUrl = request.cancelUrl ?? request.returnUrl;
    const signed = { amount, cancelUrl, description, orderCode, returnUrl: request.returnUrl };
    const expiredAt = Math.floor(request.expiresAt.getTime() / 1000);
    if (!Number.isSafeInteger(expiredAt) || expiredAt <= 0 || expiredAt > 2_147_483_647) {
      throw new PaymentGatewayError("Hạn thanh toán payOS không hợp lệ.", false);
    }
    let data: unknown;
    try {
      data = await this.call("/v2/payment-requests", { method: "POST", body: JSON.stringify({ ...signed, expiredAt, signature: signPayosData(signed, this.config.checksumKey) }) });
    } catch (error) {
      // Request trước có thể đã tạo link nhưng phản hồi bị mất. Chỉ lấy lại đúng mã + tiền đã ký, không tạo đơn mới.
      const existing = RecoverSchema.safeParse(await this.call(`/v2/payment-requests/${orderCode}`, { method: "GET" }).catch(() => null));
      if (existing.success && existing.data.orderCode === orderCode && BigInt(existing.data.amount) === request.amount) {
        return { paymentUrl: `https://pay.payos.vn/web/${existing.data.id}` };
      }
      if (error instanceof PaymentGatewayError && error.resultCode !== null) {
        throw new PaymentGatewayError("Chưa tạo hoặc lấy lại được link payOS cho mã đơn này.", true, error.resultCode);
      }
      throw error;
    }
    const parsed = CheckoutSchema.safeParse(data);
    if (!parsed.success || parsed.data.orderCode !== orderCode || BigInt(parsed.data.amount) !== request.amount) {
      throw new PaymentGatewayError("payOS trả thông tin link thanh toán không khớp.");
    }
    const checkout = parsed.data;
    return {
      paymentUrl: checkout.checkoutUrl,
      transfer: {
        qrCode: checkout.qrCode,
        bin: checkout.bin,
        accountNumber: checkout.accountNumber,
        accountName: checkout.accountName,
        amount: String(checkout.amount),
        description: checkout.description,
        paymentLinkId: checkout.paymentLinkId,
      },
    };
  }

  /** Kiểm chữ ký trên nguyên bản data của webhook trước khi dùng các trường giao dịch. */
  verifyCallback(input: Record<string, unknown>): VerifiedCallback | null {
    const parsed = WebhookSchema.safeParse(input);
    if (!parsed.success || !isRecord(input.data) || !verifyPayosData(input.data, parsed.data.signature, this.config.checksumKey)) return null;
    const { data } = parsed.data;
    return {
      paymentCode: String(data.orderCode),
      orderCode: BigInt(data.orderCode),
      providerTxnId: data.reference,
      amount: BigInt(data.amount),
      success: true,
      resultCode: data.code,
      fields: { orderCode: String(data.orderCode), paymentLinkId: data.paymentLinkId, reference: data.reference, amount: String(data.amount), currency: data.currency, description: data.description, code: data.code },
    };
  }

  /** Tra cứu số tiền thực nhận để callback bị mất vẫn được đối soát theo booking. */
  async queryTransaction(request: TransactionQuery): Promise<TransactionStatus> {
    const orderCode = safeInteger(request.orderCode);
    const parsed = QuerySchema.safeParse(await this.call(`/v2/payment-requests/${orderCode}`, { method: "GET" }));
    if (!parsed.success || parsed.data.orderCode !== orderCode) throw new PaymentGatewayError("payOS trả thông tin tra cứu không hợp lệ.");
    const data = parsed.data;
    const closed = data.status === "CANCELLED" || data.status === "EXPIRED";
    if (data.status === "PAID" || (closed && data.amountPaid > 0)) {
      // Nhiều lần chuyển / trả thừa hoặc thiếu đều đi qua kiểm tổng số tiền của domain.
      const reference = data.transactions.at(-1)?.reference;
      if (!reference || data.amountPaid <= 0) throw new PaymentGatewayError("payOS thiếu chứng từ thanh toán khi tra cứu.");
      return { status: "SUCCESS", providerTxnId: reference, amount: BigInt(data.amountPaid), resultCode: data.status };
    }
    return { status: closed ? "FAILED" : "PENDING", providerTxnId: null, amount: null, resultCode: data.status };
  }

  /** Hủy link chờ thanh toán khi booking hết hạn. */
  async cancelCheckout(orderCode: bigint): Promise<void> {
    const code = safeInteger(orderCode);
    const data = await this.call(`/v2/payment-requests/${code}/cancel`, { method: "POST", body: JSON.stringify({ cancellationReason: "Booking het han thanh toan" }) });
    if (!isRecord(data) || data.orderCode !== code || !["CANCELLED", "EXPIRED"].includes(String(data.status))) {
      throw new PaymentGatewayError("payOS chưa xác nhận hủy link thanh toán.");
    }
  }

  /** Chuyển hoàn tiền payOS sang quy trình hoàn thủ công đã có. */
  async refund(): Promise<{ providerRefundId: string | null }> {
    throw new PaymentGatewayError("payOS cần hoàn tiền thủ công.", false, "MANUAL_REFUND");
  }

  private async call(path: string, init: RequestInit): Promise<unknown> {
    let response: Response;
    let body: unknown;
    try {
      response = await this.fetchImpl(`${this.config.apiUrl.replace(/\/+$/, "")}${path}`, {
        ...init,
        headers: { "content-type": "application/json", "x-client-id": this.config.clientId, "x-api-key": this.config.apiKey },
        signal: AbortSignal.timeout(REQUEST_TIMEOUT_MS),
      });
      body = await response.json();
    } catch {
      throw new PaymentGatewayError("Không nhận được phản hồi hợp lệ từ payOS.");
    }
    const parsed = EnvelopeSchema.safeParse(body);
    if (!response.ok || !parsed.success || parsed.data.code !== "00") {
      throw new PaymentGatewayError(`payOS từ chối yêu cầu (HTTP ${response.status}).`, response.status === 429 || response.status >= 500 || (response.ok && parsed.success && parsed.data.code === "01"), parsed.success ? parsed.data.code : null);
    }
    const { data, signature } = parsed.data;
    if (!isRecord(data) || !signature || !verifyPayosData(data, signature, this.config.checksumKey)) throw new PaymentGatewayError("Chữ ký phản hồi payOS không hợp lệ.");
    return data;
  }
}

/** Ký dữ liệu payOS theo khóa alphabet và quy tắc giá trị null của nhà cung cấp. */
export function signPayosData(data: Record<string, unknown>, checksumKey: string): string {
  const raw = Object.keys(data).filter((key) => data[key] !== undefined).sort().map((key) => `${key}=${canonicalValue(data[key])}`).join("&");
  return createHmac("sha256", checksumKey).update(raw, "utf8").digest("hex");
}

function verifyPayosData(data: Record<string, unknown>, signature: string, checksumKey: string): boolean {
  if (!/^[a-f\d]{64}$/i.test(signature)) return false;
  try {
    return timingSafeEqual(Buffer.from(signPayosData(data, checksumKey), "hex"), Buffer.from(signature, "hex"));
  } catch {
    return false;
  }
}

function canonicalValue(value: unknown): string {
  if (value === null || value === undefined || value === "null" || value === "undefined") return "";
  if (Array.isArray(value)) return JSON.stringify(value.map((entry) => isRecord(entry) ? Object.fromEntries(Object.keys(entry).sort().map((key) => [key, entry[key]])) : entry));
  if (typeof value === "object") throw new TypeError("Kiểu dữ liệu ký payOS không hợp lệ.");
  return String(value);
}

function isRecord(value: unknown): value is Record<string, unknown> {
  return typeof value === "object" && value !== null && !Array.isArray(value);
}

function safeInteger(value: bigint | undefined): number {
  if (value === undefined || value <= 0n || value > MAX_INTEGER) throw new PaymentGatewayError("Số tiền hoặc mã đơn payOS ngoài giới hạn số nguyên an toàn.", false);
  return Number(value);
}
