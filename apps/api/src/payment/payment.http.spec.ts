import { randomUUID } from "node:crypto";
import type { AddressInfo } from "node:net";
import { type INestApplication, Module } from "@nestjs/common";
import { APP_INTERCEPTOR, NestFactory } from "@nestjs/core";
import { ZodSerializerInterceptor, ZodValidationPipe } from "nestjs-zod";
import { afterAll, beforeAll, beforeEach, describe, expect, it, vi } from "vitest";
import { ProblemDetailsExceptionFilter } from "../common/errors/problem-details.filter";
import { APP_CONFIG, type AppConfig } from "../config/env.config";
import { MomoGateway } from "../external/payment/momo/momo-gateway";
import { PAYMENT_SIMULATOR, type PaymentSimulator, PaymentSimulatorController } from "../external/payment/simulator/payment-simulator.controller";
import { VnpayGateway } from "../external/payment/vnpay/vnpay-gateway";
import { type AccessTokenClaims, TokenService } from "../iam/auth/token.service";
import { GuestOrPassengerGuard } from "../iam/role/guest-or-passenger";
import { SessionService } from "../iam/session/session.service";
import { configureApiRoutes } from "../openapi/openapi";
import { PaymentController } from "./payment.controller";
import { callbackUnavailable } from "./payment.errors";
import { PaymentService } from "./payment.service";
import { PaymentWebhookController } from "./payment-webhook.controller";
import { type CallbackAck, PaymentWebhookService } from "./payment-webhook.service";

/**
 * Guard thật trên `POST /bookings/{id}/payments`, mã phản hồi IPN của từng cổng, và cổng giả lập dev chạy trọn vòng
 * (link ký → trang → IPN ký về webhook của chính API → đưa trình duyệt về trang kết quả). Nghiệp vụ ở `.int.spec.ts`.
 */
describe("Thanh toán — HTTP", () => {
  const bookingId = randomUUID();
  const payment = {
    paymentId: randomUUID(),
    paymentCode: "PAYABCDEFGH2345",
    provider: "VNPAY",
    status: "PROCESSING",
    amount: 320000,
    paymentUrl: "https://sandbox.vnpayment.vn/x",
    expiresAt: new Date().toISOString(),
  };
  const service = { create: vi.fn(async () => payment) };
  const receive = vi.fn<(provider: string, input: Record<string, unknown>) => Promise<CallbackAck>>(async () => "ACCEPTED");
  const simulator: PaymentSimulator = {
    vnpay: { tmnCode: "DEVSIM01", hashSecret: "bi-mat-gia-lap", paymentUrl: "", apiUrl: "" },
    momo: { partnerCode: "DEVSIM01", accessKey: "truy-cap", secretKey: "bi-mat-momo", endpoint: "", ipnUrl: "" },
  };
  let app: INestApplication;
  let origin: string;
  let tokens: TokenService;

  @Module({
    controllers: [PaymentController, PaymentWebhookController, PaymentSimulatorController],
    providers: [
      { provide: APP_INTERCEPTOR, useClass: ZodSerializerInterceptor },
      { provide: APP_CONFIG, useValue: { NODE_ENV: "test", JWT_ACCESS_TTL_SECONDS: 900, JWT_ISSUER: "vexenhanh-test" } as AppConfig },
      TokenService,
      GuestOrPassengerGuard,
      { provide: PaymentService, useValue: service },
      { provide: PaymentWebhookService, useValue: { receive } },
      { provide: PAYMENT_SIMULATOR, useValue: simulator },
      { provide: SessionService, useValue: { assertActive: async () => undefined, assertOperatorAccountCurrent: async () => undefined } },
    ],
  })
  class HttpTestModule {}

  beforeAll(async () => {
    app = await NestFactory.create(HttpTestModule, { logger: false, abortOnError: false });
    app.useGlobalPipes(new ZodValidationPipe());
    app.useGlobalFilters(new ProblemDetailsExceptionFilter());
    configureApiRoutes(app);
    await app.listen(0, "127.0.0.1");
    origin = `http://127.0.0.1:${(app.getHttpServer().address() as AddressInfo).port}`;
    simulator.vnpay!.paymentUrl = `${origin}/v1/dev/payment-gateway/vnpay`;
    simulator.momo!.endpoint = `${origin}/v1/dev/payment-gateway/momo`;
    simulator.momo!.ipnUrl = `${origin}/v1/webhooks/payment/momo`;
    tokens = app.get(TokenService);
  }, 15_000);

  afterAll(async () => {
    await app?.close();
  });

  beforeEach(() => {
    vi.clearAllMocks();
  });

  async function token(role: AccessTokenClaims["role"]): Promise<string> {
    const scope = role === "PASSENGER" ? "passenger" : role.startsWith("PLATFORM") ? "platform" : "operator";
    return (
      await tokens.mintAccessToken({
        sub: `user-${role}`,
        sid: randomUUID(),
        scope,
        role,
        ...(scope === "operator" ? { operatorId: randomUUID(), operatorSlug: "nhaxe" } : {}),
        ...(scope === "passenger" ? {} : { mfa: true }),
      })
    ).accessToken;
  }

  async function pay(accessToken: string | null, body: object, headers: Record<string, string> = {}) {
    const response = await fetch(`${origin}/v1/bookings/${bookingId}/payments`, {
      method: "POST",
      headers: { ...(accessToken ? { authorization: `Bearer ${accessToken}` } : {}), "content-type": "application/json", ...headers },
      body: JSON.stringify(body),
    });
    return { status: response.status, body: (await response.json()) as Record<string, unknown> };
  }

  it("khách vãng lai tạo payment: 201, mã truy cập + cổng + IP tới service; hành khách được; chủ nhà xe / Admin 403; cổng lạ 400", async () => {
    expect(await pay(null, { provider: "VNPAY" }, { "X-Booking-Token": "ma" })).toMatchObject({ status: 201, body: { paymentCode: "PAYABCDEFGH2345" } });
    const [user, id, accessToken, input] = service.create.mock.calls[0] as unknown as [unknown, string, string, { provider: string }];
    expect([user, id, accessToken, input]).toEqual([null, bookingId, "ma", { provider: "VNPAY" }]);
    expect((await pay(await token("PASSENGER"), { provider: "MOMO" })).status).toBe(201);
    for (const role of ["OPERATOR_OWNER", "PLATFORM_ADMIN"] as const) {
      expect(await pay(await token(role), { provider: "VNPAY" }), role).toMatchObject({ status: 403 });
    }
    expect((await pay(null, { provider: "STRIPE" })).status).toBe(400);
    expect(service.create).toHaveBeenCalledTimes(2);
  });

  it.each([
    ["ACCEPTED", "00"],
    ["ALREADY_CONFIRMED", "02"],
    ["NOT_FOUND", "01"],
    ["AMOUNT_MISMATCH", "04"],
    ["INVALID_SIGNATURE", "97"],
  ] as const)("IPN VNPay (GET, không token): %s → RspCode %s", async (ack, code) => {
    receive.mockResolvedValueOnce(ack);
    const response = await fetch(`${origin}/v1/webhooks/payment/vnpay?vnp_TxnRef=PAY1&vnp_SecureHash=abc`);
    expect(response.status).toBe(200);
    expect(await response.json()).toMatchObject({ RspCode: code });
    expect(receive).toHaveBeenCalledWith("VNPAY", { vnp_TxnRef: "PAY1", vnp_SecureHash: "abc" });
  });

  it("IPN VNPay lỗi hệ thống → 99 (VNPay gửi lại); IPN MoMo: nhận → 204, sai chữ ký → 400, hàng đợi lỗi → 503", async () => {
    receive.mockRejectedValueOnce(new Error("redis down"));
    expect(await (await fetch(`${origin}/v1/webhooks/payment/vnpay?x=1`)).json()).toMatchObject({ RspCode: "99" });
    const momo = (body: object) => fetch(`${origin}/v1/webhooks/payment/momo`, { method: "POST", headers: { "content-type": "application/json" }, body: JSON.stringify(body) });
    expect((await momo({ orderId: "PAY1" })).status).toBe(204);
    receive.mockResolvedValueOnce("INVALID_SIGNATURE");
    expect((await momo({ orderId: "PAY1" })).status).toBe(400);
    receive.mockRejectedValueOnce(callbackUnavailable());
    expect((await momo({ orderId: "PAY1" })).status).toBe(503);
  });

  it("cổng VNPay giả lập: link ký → trang; bấm thành công → IPN ký đúng tới webhook + về trang kết quả kèm tham số ký; link bị sửa → 404", async () => {
    const gateway = new VnpayGateway(simulator.vnpay!);
    const { paymentUrl } = await gateway.createCheckout({
      paymentCode: "PAYABCDEFGH2345",
      amount: 320_000n,
      orderInfo: "Thanh toan ve VXNAB2CD3",
      returnUrl: "http://localhost:3001/bookings/b1/payment/result",
      clientIp: "127.0.0.1",
      createdAt: new Date(),
      expiresAt: new Date(Date.now() + 600_000),
    });
    const page = await fetch(paymentUrl);
    expect(page.status).toBe(200);
    const html = await page.text();
    expect(html).toContain("320.000");
    expect((await fetch(paymentUrl.replace("vnp_Amount=32000000", "vnp_Amount=100"))).status).toBe(404);

    const success = html.match(/href="(vnpay\/complete\?outcome=success[^"]+)"/)![1]!.replace(/&#38;/g, "&");
    const done = await fetch(`${origin}/v1/dev/payment-gateway/${success}`, { redirect: "manual" });
    expect(done.status).toBe(302);
    const back = new URL(done.headers.get("location")!);
    expect(back.origin + back.pathname).toBe("http://localhost:3001/bookings/b1/payment/result");
    expect(gateway.verifyCallback(Object.fromEntries(back.searchParams))).toMatchObject({ paymentCode: "PAYABCDEFGH2345", amount: 320_000n, success: true });
    const [provider, ipn] = receive.mock.calls[0]!;
    expect(provider).toBe("VNPAY");
    expect(gateway.verifyCallback(ipn)).toMatchObject({ success: true, paymentCode: "PAYABCDEFGH2345" });
  });

  it("cổng MoMo giả lập: tạo giao dịch bằng adapter thật → trang → bấm thất bại → IPN ký đúng (resultCode ≠ 0); cổng tắt → 404", async () => {
    const gateway = new MomoGateway(simulator.momo!);
    const { paymentUrl } = await gateway.createCheckout({
      paymentCode: "PAYMOMO2345678A",
      amount: 150_000n,
      orderInfo: "Thanh toan ve VXNAB2CD3",
      returnUrl: "http://localhost:3001/bookings/b2/payment/result",
      clientIp: "127.0.0.1",
      createdAt: new Date(),
      expiresAt: new Date(),
    });
    const html = await (await fetch(paymentUrl)).text();
    expect(html).toContain("150.000");
    const fail = html.match(/href="(complete\?outcome=fail[^"]+)"/)![1]!.replace(/&#38;/g, "&");
    const done = await fetch(`${origin}/v1/dev/payment-gateway/momo/${fail}`, { redirect: "manual" });
    expect(done.status).toBe(302);
    const [provider, ipn] = receive.mock.calls[0]!;
    expect(provider).toBe("MOMO");
    expect(gateway.verifyCallback(ipn)).toMatchObject({ paymentCode: "PAYMOMO2345678A", success: false, amount: 150_000n });

    const saved = simulator.vnpay;
    simulator.vnpay = null;
    expect((await fetch(`${origin}/v1/dev/payment-gateway/vnpay?vnp_Amount=1`)).status).toBe(404);
    simulator.vnpay = saved;
  });
});
