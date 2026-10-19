import { createHmac } from "node:crypto";
import { describe, expect, it, vi } from "vitest";
import { PaymentGatewayError } from "../payment-gateway";
import { MomoGateway } from "./momo-gateway";

/** Adapter MoMo AIO v2 (ADR-019): ký HMAC-SHA256 chuỗi cố định theo tài liệu; IPN sai chữ ký / sai đối tác bị từ chối. */
describe("MomoGateway", () => {
  const config = {
    partnerCode: "MOMOTEST01",
    accessKey: "khoa-truy-cap",
    secretKey: "bi-mat-thu-nghiem",
    endpoint: "https://test-payment.momo.vn",
    ipnUrl: "https://api.example.com/v1/webhooks/payment/momo",
  };
  const hmac = (data: string) => createHmac("sha256", config.secretKey).update(data, "utf8").digest("hex");
  const request = {
    paymentCode: "PAYABCDEFGH2345",
    amount: 320_000n,
    orderInfo: "Thanh toan ve VXNAB2CD3",
    returnUrl: "http://localhost:3001/bookings/b1/payment/result",
    clientIp: "10.0.0.1",
    createdAt: new Date(),
    expiresAt: new Date(),
  };

  it("tạo giao dịch: POST /v2/gateway/api/create, chữ ký đúng chuỗi tài liệu, trả payUrl", async () => {
    const fetchImpl = vi.fn(async () => new Response(JSON.stringify({ resultCode: 0, payUrl: "https://test-payment.momo.vn/pay/xyz" })));
    const result = await new MomoGateway(config, fetchImpl as unknown as typeof fetch).createCheckout(request);
    expect(result.paymentUrl).toBe("https://test-payment.momo.vn/pay/xyz");
    const [url, init] = fetchImpl.mock.calls[0] as unknown as [string, RequestInit];
    expect(url).toBe("https://test-payment.momo.vn/v2/gateway/api/create");
    const body = JSON.parse(String(init.body)) as Record<string, string | number>;
    expect(body).toMatchObject({ partnerCode: "MOMOTEST01", amount: 320000, orderId: "PAYABCDEFGH2345", requestType: "captureWallet", ipnUrl: config.ipnUrl });
    const raw =
      `accessKey=khoa-truy-cap&amount=320000&extraData=&ipnUrl=${config.ipnUrl}&orderId=PAYABCDEFGH2345` +
      `&orderInfo=Thanh toan ve VXNAB2CD3&partnerCode=MOMOTEST01&redirectUrl=${request.returnUrl}&requestId=${body.requestId}&requestType=captureWallet`;
    expect(body.signature).toBe(hmac(raw));
  });

  it("MoMo từ chối / HTTP lỗi / mất kết nối → PaymentGatewayError không lộ khóa", async () => {
    for (const fetchImpl of [
      async () => new Response(JSON.stringify({ resultCode: 41, message: "Trùng orderId" })),
      async () => new Response("lỗi", { status: 500 }),
      async () => {
        throw new TypeError("fetch failed");
      },
    ]) {
      const error = await new MomoGateway(config, fetchImpl as unknown as typeof fetch).createCheckout(request).catch((caught: unknown) => caught);
      expect(error).toBeInstanceOf(PaymentGatewayError);
      expect(String((error as Error).message)).not.toContain(config.secretKey);
    }
  });

  function ipn(overrides: Record<string, string | number> = {}): Record<string, string | number> {
    const fields: Record<string, string | number> = {
      partnerCode: config.partnerCode,
      orderId: "PAYABCDEFGH2345",
      requestId: "req-1",
      amount: 320000,
      orderInfo: "Thanh toan ve VXNAB2CD3",
      orderType: "momo_wallet",
      transId: 4100000001,
      resultCode: 0,
      message: "Thành công.",
      payType: "qr",
      responseTime: 1_790_000_000_000,
      extraData: "",
      ...overrides,
    };
    const raw = ["amount", "extraData", "message", "orderId", "orderInfo", "orderType", "partnerCode", "payType", "requestId", "responseTime", "resultCode", "transId"]
      .map((key) => `${key}=${fields[key]}`)
      .join("&");
    return { ...fields, signature: hmac(`accessKey=${config.accessKey}&${raw}`) };
  }

  it("IPN hợp lệ → thành công kèm transId; resultCode khác 0 → thất bại", () => {
    const gateway = new MomoGateway(config);
    expect(gateway.verifyCallback(ipn())).toMatchObject({ paymentCode: "PAYABCDEFGH2345", providerTxnId: "4100000001", amount: 320_000n, success: true, resultCode: "0" });
    expect(gateway.verifyCallback(ipn({ resultCode: 1006, transId: 0 }))).toMatchObject({ success: false, providerTxnId: null, resultCode: "1006" });
  });

  it("sửa số tiền / thiếu trường / sai đối tác / chữ ký khóa khác → từ chối", () => {
    const gateway = new MomoGateway(config);
    expect(gateway.verifyCallback({ ...ipn(), amount: 1000 })).toBeNull();
    const { payType: _payType, ...missing } = ipn();
    expect(gateway.verifyCallback(missing)).toBeNull();
    expect(gateway.verifyCallback(ipn({ partnerCode: "OTHER" }))).toBeNull();
    expect(new MomoGateway({ ...config, secretKey: "khac" }).verifyCallback(ipn())).toBeNull();
  });

  it("hoàn tiền: POST /v2/gateway/api/refund ký chuỗi tài liệu (orderId = mã refund, transId gốc); từ chối / đang xử lý phân loại thử lại", async () => {
    const request = {
      refundCode: "RFDABCDEFGH2345",
      paymentCode: "PAYABCDEFGH2345",
      providerTxnId: "4100000001",
      amount: 288_000n,
      paidAmount: 320_000n,
      paymentCreatedAt: new Date(),
      reason: "Hoan tien ve VXNAB2CD3",
      requestedAt: new Date(),
    };
    const fetchImpl = vi.fn(async () => new Response(JSON.stringify({ resultCode: 0, transId: 4200000001 })));
    expect(await new MomoGateway(config, fetchImpl as unknown as typeof fetch).refund(request)).toEqual({ providerRefundId: "4200000001" });
    const [url, init] = fetchImpl.mock.calls[0] as unknown as [string, RequestInit];
    expect(url).toBe("https://test-payment.momo.vn/v2/gateway/api/refund");
    const body = JSON.parse(String(init.body)) as Record<string, string | number>;
    expect(body).toMatchObject({ orderId: "RFDABCDEFGH2345", amount: 288000, transId: 4100000001 });
    expect(body.signature).toBe(
      hmac("accessKey=khoa-truy-cap&amount=288000&description=Hoan tien ve VXNAB2CD3&orderId=RFDABCDEFGH2345&partnerCode=MOMOTEST01&requestId=RFDABCDEFGH2345&transId=4100000001"),
    );
    const outcome = async (resultCode: number) =>
      new MomoGateway(config, (async () => new Response(JSON.stringify({ resultCode }))) as unknown as typeof fetch).refund(request).catch((error: unknown) => error as PaymentGatewayError);
    expect(await outcome(1080)).toMatchObject({ retryable: false, resultCode: "1080" });
    expect(await outcome(7000)).toMatchObject({ retryable: true, resultCode: "7000" });
  });
});
