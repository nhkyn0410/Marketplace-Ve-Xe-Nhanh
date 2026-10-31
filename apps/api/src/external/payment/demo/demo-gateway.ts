import { createHmac, timingSafeEqual } from "node:crypto";
import { z } from "zod";
import { type CheckoutRequest, type PaymentGateway, PaymentGatewayError, type TransactionQuery, type TransactionStatus, type VerifiedCallback } from "../payment-gateway";

/** Cấu hình cổng thử nội bộ, không xử lý tiền thật. */
export type DemoConfig = { secret: string; baseUrl: string; callbackUrl: string };
const OrderSchema = z.object({ paymentCode: z.string().regex(/^PAY[A-Z2-9]{12}$/), amount: z.string().regex(/^[1-9]\d*$/), expiresAt: z.iso.datetime(), returnUrl: z.url(), orderInfo: z.string() });
type DemoOrder = z.infer<typeof OrderSchema>;
const CallbackSchema = z.object({ paymentCode: OrderSchema.shape.paymentCode, amount: OrderSchema.shape.amount, success: z.boolean(), reference: z.string().min(1), signature: z.string() });
type DemoCallback = z.infer<typeof CallbackSchema>;

/** Cổng thanh toán thử cho phép diễn tập callback có ký mà không chuyển tiền. */
export class DemoGateway implements PaymentGateway {
  readonly provider = "DEMO" as const;
  readonly minAmount = 1n;
  readonly maxAmount = BigInt(Number.MAX_SAFE_INTEGER);
  private readonly outcomes = new Map<string, DemoCallback>();

  constructor(readonly config: DemoConfig, private readonly fetchImpl: typeof fetch = fetch) {}

  /** Tạo link cổng thử với mã đơn và số tiền được ký để chống sửa trên trình duyệt. */
  async createCheckout(request: CheckoutRequest): Promise<{ paymentUrl: string }> {
    const order: DemoOrder = { paymentCode: request.paymentCode, amount: request.amount.toString(), expiresAt: request.expiresAt.toISOString(), returnUrl: request.returnUrl, orderInfo: request.orderInfo };
    const payload = Buffer.from(JSON.stringify(order)).toString("base64url");
    return { paymentUrl: `${this.config.baseUrl}?token=${payload}.${mac(payload, this.config.secret)}` };
  }

  /** Kiểm tính toàn vẹn và hạn thanh toán của link cổng thử. */
  checkoutOrder(token: string | undefined): DemoOrder | null {
    const [payload, signature, extra] = (token ?? "").split(".");
    if (!payload || !signature || extra !== undefined || !equal(mac(payload, this.config.secret), signature)) return null;
    try {
      const parsed = OrderSchema.safeParse(JSON.parse(Buffer.from(payload, "base64url").toString("utf8")));
      return parsed.success && new Date(parsed.data.expiresAt).getTime() > Date.now() ? parsed.data : null;
    } catch {
      return null;
    }
  }

  /** Sinh một kết quả duy nhất cho mỗi đơn thử; bấm lại không sinh mã giao dịch mới. */
  complete(order: DemoOrder, success: boolean): DemoCallback {
    const previous = this.outcomes.get(order.paymentCode);
    if (previous) return previous;
    const data = { paymentCode: order.paymentCode, amount: order.amount, success, reference: `DEMO-${order.paymentCode}` };
    const result = { ...data, signature: signDemoCallback(data, this.config.secret) };
    this.outcomes.set(order.paymentCode, result);
    return result;
  }

  /** Xác thực kết quả cổng thử trước khi đưa vào quy trình payment chung. */
  verifyCallback(input: Record<string, unknown>): VerifiedCallback | null {
    const parsed = CallbackSchema.safeParse(input);
    if (!parsed.success) return null;
    const { signature, ...data } = parsed.data;
    if (!equal(signDemoCallback(data, this.config.secret), signature)) return null;
    return { paymentCode: data.paymentCode, providerTxnId: data.reference, amount: BigInt(data.amount), success: data.success, resultCode: data.success ? "00" : "DEMO_FAILED", fields: { source: "demo", reference: data.reference } };
  }

  /** Trả kết quả thử cho worker sau khi kiểm chữ ký yêu cầu tra cứu. */
  queryOutcome(input: Record<string, unknown>): DemoCallback | null | undefined {
    const code = input.paymentCode;
    if (typeof code !== "string" || typeof input.signature !== "string" || !equal(mac(`query:${code}`, this.config.secret), input.signature)) return undefined;
    return this.outcomes.get(code) ?? null;
  }

  /** Tra cứu cổng thử qua HTTP để worker và API có thể chạy ở hai tiến trình. */
  async queryTransaction(request: TransactionQuery): Promise<TransactionStatus> {
    try {
      const response = await this.fetchImpl(`${this.config.baseUrl}/query`, {
        method: "POST", headers: { "content-type": "application/json" },
        body: JSON.stringify({ paymentCode: request.paymentCode, signature: mac(`query:${request.paymentCode}`, this.config.secret) }),
        signal: AbortSignal.timeout(10_000),
      });
      if (!response.ok) throw new PaymentGatewayError("Cổng thử không trả được kết quả tra cứu.");
      const body: unknown = await response.json();
      if (body === null) return { status: "NOT_FOUND", providerTxnId: null, amount: null, resultCode: "NOT_FOUND" };
      const callback = typeof body === "object" && !Array.isArray(body) ? this.verifyCallback(body as Record<string, unknown>) : null;
      if (!callback || callback.paymentCode !== request.paymentCode) throw new PaymentGatewayError("Kết quả tra cứu cổng thử không hợp lệ.");
      return { status: callback.success ? "SUCCESS" : "FAILED", providerTxnId: callback.providerTxnId, amount: callback.amount, resultCode: callback.resultCode };
    } catch (error) {
      if (error instanceof PaymentGatewayError) throw error;
      throw new PaymentGatewayError("Không kết nối được cổng thanh toán thử.");
    }
  }

  /** Mô phỏng hoàn tiền thành công, không thực hiện chuyển khoản. */
  async refund(): Promise<{ providerRefundId: string | null }> {
    return { providerRefundId: null };
  }
}

/** Ký các trường kết quả của cổng thử cho webhook nội bộ. */
export function signDemoCallback(data: Omit<DemoCallback, "signature">, secret: string): string {
  return mac(JSON.stringify([data.paymentCode, data.amount, data.success, data.reference]), secret);
}

function mac(value: string, secret: string): string {
  return createHmac("sha256", secret).update(value, "utf8").digest("hex");
}

function equal(expected: string, signature: string): boolean {
  if (!/^[a-f\d]{64}$/i.test(signature)) return false;
  return timingSafeEqual(Buffer.from(expected, "hex"), Buffer.from(signature, "hex"));
}
