import { describe, expect, it, vi } from "vitest";
import { NotFoundException } from "@nestjs/common";
import { parseAppConfig } from "../../../config/env.config";
import { createPaymentGateways } from "../payment.module";
import { DemoGateway, signDemoCallback } from "./demo-gateway";
import { DemoPaymentController } from "./demo-payment.controller";

describe("DemoGateway", () => {
  const config = { secret: "demo-test-secret", baseUrl: "https://api.example.com/v1/dev/payment-gateway/demo", callbackUrl: "https://api.example.com/v1/webhooks/payment/demo" };
  const request = { paymentCode: "PAYABCDEFGH2345", amount: 10000n, orderInfo: "Thu thanh toan", returnUrl: "https://market.example.com/result", clientIp: "127.0.0.1", createdAt: new Date(), expiresAt: new Date(Date.now() + 600000) };
  const tokenFrom = (url: string) => new URL(url).searchParams.get("token")!;

  it("link có ký giữ nguyên số tiền, không cho sửa payload hoặc dùng sau hạn", async () => {
    const gateway = new DemoGateway(config);
    const token = tokenFrom((await gateway.createCheckout(request)).paymentUrl);
    expect(gateway.checkoutOrder(token)).toMatchObject({ paymentCode: request.paymentCode, amount: "10000" });
    expect(gateway.checkoutOrder(`${token}0`)).toBeNull();
    const expired = await gateway.createCheckout({ ...request, expiresAt: new Date(Date.now() - 1000) });
    expect(gateway.checkoutOrder(tokenFrom(expired.paymentUrl))).toBeNull();
  });

  it("bấm lặp trả cùng callback/reference và webhook sai chữ ký bị từ chối", async () => {
    const gateway = new DemoGateway(config);
    const order = gateway.checkoutOrder(tokenFrom((await gateway.createCheckout(request)).paymentUrl))!;
    const callback = gateway.complete(order, true);
    expect(gateway.complete(order, false)).toEqual(callback);
    expect(gateway.verifyCallback(callback)).toMatchObject({ paymentCode: request.paymentCode, amount: 10000n, success: true, providerTxnId: `DEMO-${request.paymentCode}` });
    expect(gateway.verifyCallback({ ...callback, success: false })).toBeNull();
    expect(gateway.verifyCallback({ ...callback, amount: "1" })).toBeNull();
    const failed = { paymentCode: request.paymentCode, amount: "10000", success: false, reference: "DEMO-FAILED" };
    expect(gateway.verifyCallback({ ...failed, signature: signDemoCallback(failed, config.secret) })).toMatchObject({ success: false });
  });

  it("worker tra cứu kết quả qua HTTP có ký và chặn kết quả của mã đơn khác", async () => {
    const apiGateway = new DemoGateway(config);
    const order = apiGateway.checkoutOrder(tokenFrom((await apiGateway.createCheckout(request)).paymentUrl))!;
    apiGateway.complete(order, true);
    const fetchImpl = vi.fn(async (_url: string | URL | Request, init?: RequestInit) => new Response(JSON.stringify(apiGateway.queryOutcome(JSON.parse(String(init?.body)) as Record<string, unknown>))));
    const workerGateway = new DemoGateway(config, fetchImpl as typeof fetch);
    const query = { paymentCode: request.paymentCode, requestCode: "RQ123", paymentCreatedAt: request.createdAt, requestedAt: request.createdAt };
    expect(await workerGateway.queryTransaction(query)).toMatchObject({ status: "SUCCESS", amount: 10000n });
    expect(await workerGateway.queryTransaction({ ...query, paymentCode: "PAY2345ABCDEFGH" })).toMatchObject({ status: "NOT_FOUND" });
    expect(apiGateway.queryOutcome({ paymentCode: request.paymentCode, signature: "bad" })).toBeUndefined();
  });

  it("controller không có gateway DEMO → 404, không hiển thị cổng thử", () => {
    const controller = new DemoPaymentController(new Map());
    expect(() => controller.page("any")).toThrow(NotFoundException);
    expect(() => controller.query({})).toThrow(NotFoundException);
  });

  it("dev thiếu khóa payOS bật DEMO; dev có payOS không bật DEMO; production mặc định không bật", () => {
    const dev = parseAppConfig({});
    expect(createPaymentGateways(dev).gateways.has("DEMO")).toBe(true);
    const live = createPaymentGateways({ ...dev, PAYOS_CLIENT_ID: "id", PAYOS_API_KEY: "key", PAYOS_CHECKSUM_KEY: "checksum" });
    expect([...live.gateways.keys()]).toEqual(["PAYOS"]);
    expect(live.simulator).toEqual({ vnpay: null, momo: null });
    expect(createPaymentGateways({ ...dev, NODE_ENV: "production", PAYMENT_DEMO_ENABLED: false }).gateways.has("DEMO")).toBe(false);
    expect(createPaymentGateways({ ...dev, NODE_ENV: "production", PAYMENT_DEMO_ENABLED: true }).gateways.has("DEMO")).toBe(true);
    expect(createPaymentGateways(dev).gateways.has("PAYOS")).toBe(false);
  });

  it("đủ khóa từng cổng → payOS, MoMo và VNPay cùng dùng adapter đã cấu hình", () => {
    const config = parseAppConfig({
      PAYOS_CLIENT_ID: "payos-client", PAYOS_API_KEY: "payos-api", PAYOS_CHECKSUM_KEY: "payos-checksum",
      MOMO_PARTNER_CODE: "momo-partner", MOMO_ACCESS_KEY: "momo-access", MOMO_SECRET_KEY: "momo-secret",
      VNPAY_TMN_CODE: "vnpay-terminal", VNPAY_HASH_SECRET: "vnpay-secret",
    });
    const setup = createPaymentGateways(config);
    expect([...setup.gateways.keys()]).toEqual(["PAYOS", "VNPAY", "MOMO"]);
    expect(setup.simulator).toEqual({ vnpay: null, momo: null });
    expect(setup.gateways.get("VNPAY")?.provider).toBe("VNPAY");
    expect(setup.gateways.get("MOMO")?.provider).toBe("MOMO");
  });
});
