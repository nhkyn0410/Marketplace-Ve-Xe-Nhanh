import { createHmac } from "node:crypto";
import { describe, expect, it, vi } from "vitest";
import { PaymentGatewayError } from "../payment-gateway";
import { PayosGateway, signPayosData } from "./payos-gateway";

describe("PayosGateway", () => {
  const config = { clientId: "test-client", apiKey: "test-api-key", checksumKey: "1a54716c8f0efb2744fb28b6e38b25da7f67a925d98bc1c18bd8faaecadd7675", apiUrl: "https://api-merchant.payos.vn" };
  const request = { paymentCode: "PAYABCDEFGH2345", orderCode: 123n, amount: 10_000n, orderInfo: "Thanh toan ve", returnUrl: "https://market.example.com/result", cancelUrl: "https://market.example.com/cancel", clientIp: "127.0.0.1", createdAt: new Date("2026-10-31T00:00:00Z"), expiresAt: new Date("2026-10-31T00:10:00Z") };
  const checkout = { bin: "970422", accountNumber: "12345678", accountName: "NGUYEN VAN A", amount: 10000, description: "PAYOS123", orderCode: 123, currency: "VND", paymentLinkId: "124c33293c43417ab7879e14c8d9eb18", status: "PENDING", checkoutUrl: "https://pay.payos.vn/web/124c33293c43417ab7879e14c8d9eb18", qrCode: "0002010102123857" };
  const webhook = { orderCode: 123, amount: 3000, description: "VQRIO123", accountNumber: "12345678", reference: "TF230204212323", transactionDateTime: "2023-02-04 18:25:00", currency: "VND", paymentLinkId: "124c33293c43417ab7879e14c8d9eb18", code: "00", desc: "Thành công", counterAccountBankId: "", counterAccountBankName: "", counterAccountName: "", counterAccountNumber: "", virtualAccountName: "", virtualAccountNumber: "" };
  const query = { paymentCode: request.paymentCode, orderCode: request.orderCode, requestCode: "RQ123", paymentCreatedAt: request.createdAt, requestedAt: request.createdAt };
  const info = { id: checkout.paymentLinkId, orderCode: 123, amount: 10000, amountPaid: 10000, amountRemaining: 0, status: "PAID", transactions: [{ reference: "TX123", amount: 10000 }] };
  const reply = (data: Record<string, unknown>, overrides: Record<string, unknown> = {}) => new Response(JSON.stringify({ code: "00", data, signature: signPayosData(data, config.checksumKey), ...overrides }));
  const ipn = (data: Record<string, unknown> = webhook) => ({ code: "00", success: true, data, signature: signPayosData(data, config.checksumKey) });

  it("khớp vector chữ ký webhook công khai của payOS", () => {
    const signature = "412e915d2871504ed31be63c8f62a149a4410d34c4c42affc9006ef9917eaa03";
    expect(signPayosData(webhook, config.checksumKey)).toBe(signature);
    expect(new PayosGateway(config).verifyCallback({ ...ipn(), signature })).toMatchObject({ orderCode: 123n, providerTxnId: "TF230204212323", amount: 3000n, success: true });
  });

  it("tạo link ký đúng năm trường và trả thông tin chuyển khoản từ phản hồi có ký", async () => {
    const fetchImpl = vi.fn(async () => reply(checkout));
    const result = await new PayosGateway(config, fetchImpl as typeof fetch).createCheckout(request);
    expect(result).toEqual({ paymentUrl: checkout.checkoutUrl, transfer: { qrCode: checkout.qrCode, bin: checkout.bin, accountNumber: checkout.accountNumber, accountName: checkout.accountName, amount: "10000", description: "PAYOS123", paymentLinkId: checkout.paymentLinkId } });
    const [url, init] = fetchImpl.mock.calls[0] as unknown as [string, RequestInit];
    expect(url).toBe(`${config.apiUrl}/v2/payment-requests`);
    expect(init.headers).toMatchObject({ "x-client-id": config.clientId, "x-api-key": config.apiKey });
    const body = JSON.parse(String(init.body)) as Record<string, unknown>;
    expect(body).toMatchObject({ orderCode: 123, amount: 10000, description: "DEFGH2345", cancelUrl: request.cancelUrl, returnUrl: request.returnUrl, expiredAt: Math.floor(request.expiresAt.getTime() / 1000) });
    expect(body.signature).toBe(createHmac("sha256", config.checksumKey).update("amount=10000&cancelUrl=https://market.example.com/cancel&description=DEFGH2345&orderCode=123&returnUrl=https://market.example.com/result").digest("hex"));
  });

  it("từ chối phản hồi đã ký nhưng sai mã đơn hoặc số tiền và từ chối URL không HTTPS", async () => {
    for (const changed of [{ orderCode: 124 }, { amount: 9999 }, { checkoutUrl: "javascript:alert(1)" }, { currency: "USD" }]) {
      await expect(new PayosGateway(config, (async () => reply({ ...checkout, ...changed })) as typeof fetch).createCheckout(request)).rejects.toBeInstanceOf(PaymentGatewayError);
    }
  });

  it("chặn số tiền/mã đơn ngoài số nguyên an toàn trước khi gọi payOS", async () => {
    const fetchImpl = vi.fn();
    for (const changed of [{ orderCode: undefined }, { orderCode: 0n }, { orderCode: 9_007_199_254_740_992n }, { amount: 9_007_199_254_740_992n }]) {
      await expect(new PayosGateway(config, fetchImpl as typeof fetch).createCheckout({ ...request, ...changed })).rejects.toBeInstanceOf(PaymentGatewayError);
    }
    expect(fetchImpl).not.toHaveBeenCalled();
  });

  it("mất phản hồi tạo link → chỉ lấy lại link cùng orderCode/số tiền qua phản hồi có ký", async () => {
    const fetchImpl = vi.fn().mockRejectedValueOnce(new TypeError("timeout")).mockResolvedValueOnce(reply(info));
    const result = await new PayosGateway(config, fetchImpl as typeof fetch).createCheckout(request);
    expect(result).toEqual({ paymentUrl: checkout.checkoutUrl });
    expect(fetchImpl.mock.calls.map((call) => call[0])).toEqual([`${config.apiUrl}/v2/payment-requests`, `${config.apiUrl}/v2/payment-requests/123`]);
    const mismatch = vi.fn().mockRejectedValueOnce(new TypeError("timeout")).mockResolvedValueOnce(reply({ ...info, amount: 9999 }));
    await expect(new PayosGateway(config, mismatch as typeof fetch).createCheckout(request)).rejects.toBeInstanceOf(PaymentGatewayError);
  });

  it("mã đơn đã tồn tại nhưng chưa khôi phục được → giữ lỗi có thể thử lại", async () => {
    const fetchImpl = vi.fn(async () => new Response(JSON.stringify({ code: "231", desc: "Order exists" })));
    await expect(new PayosGateway(config, fetchImpl as typeof fetch).createCheckout(request)).rejects.toMatchObject({ retryable: true, resultCode: "231" });
  });

  it("chữ ký phản hồi sai, dữ liệu thiếu, lỗi HTTP hoặc timeout → lỗi không lộ khóa", async () => {
    for (const fetchImpl of [async () => reply(checkout, { signature: "0".repeat(64) }), async () => reply({ amount: 10000 }), async () => new Response("no", { status: 503 }), async () => { throw new TypeError(config.apiKey); }]) {
      const caught: unknown = await new PayosGateway(config, fetchImpl as typeof fetch).createCheckout(request).catch((error: unknown) => error);
      expect(caught).toBeInstanceOf(PaymentGatewayError);
      expect(String(caught)).not.toContain(config.apiKey);
      expect(String(caught)).not.toContain(config.checksumKey);
    }
  });

  it("webhook phải có chữ ký, mã đơn, số tiền nguyên dương, reference và currency VND", () => {
    const gateway = new PayosGateway(config);
    for (const invalid of [
      { ...ipn(), signature: "bad" }, { ...ipn(), success: false }, { ...ipn(), code: "01" }, { ...ipn(), data: { ...webhook, amount: 1 } },
      ipn({ ...webhook, reference: "" }), ipn({ ...webhook, orderCode: 0 }), ipn({ ...webhook, amount: 1.5 }), ipn({ ...webhook, amount: Number.MAX_SAFE_INTEGER + 1 }), ipn({ ...webhook, currency: "USD" }), ipn({ ...webhook, code: "01" }), ipn({ ...webhook, paymentLinkId: undefined }),
    ]) expect(gateway.verifyCallback(invalid)).toBeNull();
    expect(gateway.verifyCallback(ipn({ ...webhook, counterAccountBankName: null }))).toMatchObject({ success: true });
  });

  it("tra cứu PAID dùng amountPaid; phần tiền đã nhận của link đóng vẫn đi đối soát", async () => {
    const status = (data: Record<string, unknown>) => new PayosGateway(config, (async () => reply(data)) as typeof fetch).queryTransaction(query);
    expect(await status(info)).toEqual({ status: "SUCCESS", providerTxnId: "TX123", amount: 10000n, resultCode: "PAID" });
    expect(await status({ ...info, status: "CANCELLED", amountPaid: 3000, amountRemaining: 7000 })).toMatchObject({ status: "SUCCESS", amount: 3000n });
    expect(await status({ ...info, status: "PENDING", amountPaid: 3000, amountRemaining: 7000 })).toMatchObject({ status: "PENDING" });
    expect(await status({ ...info, status: "EXPIRED", amountPaid: 0, amountRemaining: 10000, transactions: [] })).toMatchObject({ status: "FAILED", amount: null });
    for (const invalid of [{ ...info, orderCode: 124 }, { ...info, transactions: [] }, { ...info, amountPaid: 0 }, { ...info, status: "UNKNOWN" }]) await expect(status(invalid)).rejects.toBeInstanceOf(PaymentGatewayError);
  });

  it("hủy link kiểm mã đơn/trạng thái và hoàn tiền trả MANUAL_REFUND không thử lại", async () => {
    const fetchImpl = vi.fn(async () => reply({ orderCode: 123, status: "CANCELLED" }));
    const gateway = new PayosGateway(config, fetchImpl as typeof fetch);
    await gateway.cancelCheckout(123n);
    expect((fetchImpl.mock.calls[0] as unknown as [string, RequestInit])[0]).toBe(`${config.apiUrl}/v2/payment-requests/123/cancel`);
    await expect(gateway.refund()).rejects.toMatchObject({ retryable: false, resultCode: "MANUAL_REFUND" });
    await expect(new PayosGateway(config, (async () => reply({ orderCode: 124, status: "CANCELLED" })) as typeof fetch).cancelCheckout(123n)).rejects.toBeInstanceOf(PaymentGatewayError);
  });
});
