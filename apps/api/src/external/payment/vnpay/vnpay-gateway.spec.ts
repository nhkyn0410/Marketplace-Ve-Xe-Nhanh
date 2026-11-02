import { createHmac } from "node:crypto";
import { describe, expect, it, vi } from "vitest";
import { PaymentGatewayError } from "../payment-gateway";
import { queryDrResponseSignData, queryDrSignData, refundResponseSignData, refundSignData, signedQuery, VnpayGateway } from "./vnpay-gateway";

/** Adapter VNPay (ADR-019): ký HMAC-SHA512 đúng cách code mẫu của VNPay; IPN sai chữ ký / sai trường bị từ chối. */
describe("VnpayGateway", () => {
  const config = { tmnCode: "TESTTMN1", hashSecret: "bi-mat-thu-nghiem", paymentUrl: "https://sandbox.vnpayment.vn/paymentv2/vpcpay.html", apiUrl: "https://sandbox.vnpayment.vn/merchant_webapi/api/transaction" };
  const gateway = new VnpayGateway(config);
  const hmac = (data: string) => createHmac("sha512", config.hashSecret).update(data, "utf8").digest("hex");

  it("link thanh toán: tham số sắp theo tên, khoảng trắng thành +, số tiền × 100, giờ GMT+7, chữ ký HMAC-SHA512 trên đúng chuỗi đó", async () => {
    const { paymentUrl } = await gateway.createCheckout({
      paymentCode: "PAYABCDEFGH2345",
      amount: 320_000n,
      orderInfo: "Thanh toan ve VXNAB2CD3",
      returnUrl: "http://localhost:3001/bookings/b1/payment/result",
      clientIp: "10.0.0.1",
      createdAt: new Date("2031-08-01T01:02:03Z"),
      expiresAt: new Date("2031-08-01T01:12:03Z"),
    });
    const [base, query] = paymentUrl.split("?");
    expect(base).toBe(config.paymentUrl);
    const expected =
      "vnp_Amount=32000000&vnp_Command=pay&vnp_CreateDate=20310801080203&vnp_CurrCode=VND&vnp_ExpireDate=20310801081203" +
      "&vnp_IpAddr=10.0.0.1&vnp_Locale=vn&vnp_OrderInfo=Thanh+toan+ve+VXNAB2CD3&vnp_OrderType=other" +
      "&vnp_ReturnUrl=http%3A%2F%2Flocalhost%3A3001%2Fbookings%2Fb1%2Fpayment%2Fresult&vnp_TmnCode=TESTTMN1" +
      "&vnp_TxnRef=PAYABCDEFGH2345&vnp_Version=2.1.0";
    expect(query).toBe(`${expected}&vnp_SecureHash=${hmac(expected)}`);
  });

  function ipn(overrides: Record<string, string> = {}): Record<string, string> {
    const params = {
      vnp_Amount: "32000000",
      vnp_BankCode: "NCB",
      vnp_OrderInfo: "Thanh toan ve VXNAB2CD3",
      vnp_PayDate: "20310801081000",
      vnp_ResponseCode: "00",
      vnp_TmnCode: config.tmnCode,
      vnp_TransactionNo: "14000001",
      vnp_TransactionStatus: "00",
      vnp_TxnRef: "PAYABCDEFGH2345",
      ...overrides,
    };
    return { ...params, vnp_SecureHashType: "HmacSHA512", vnp_SecureHash: hmac(signedQuery(params)).toUpperCase() };
  }

  it("IPN hợp lệ (query đã giải mã, chữ ký in hoa) → mã payment, mã giao dịch, số tiền đồng, thành công", () => {
    expect(gateway.verifyCallback(ipn())).toMatchObject({
      paymentCode: "PAYABCDEFGH2345",
      providerTxnId: "14000001",
      amount: 320_000n,
      success: true,
      resultCode: "00",
    });
    const failed = gateway.verifyCallback(ipn({ vnp_ResponseCode: "24", vnp_TransactionStatus: "02", vnp_TransactionNo: "0" }));
    expect(failed).toMatchObject({ success: false, resultCode: "24", providerTxnId: null });
    // Mã phản hồi 00 nhưng trạng thái giao dịch khác 00 → không coi là thành công.
    expect(gateway.verifyCallback(ipn({ vnp_TransactionStatus: "01" }))?.success).toBe(false);
  });

  it("sửa số tiền / thiếu chữ ký / chữ ký khóa khác / sai mã merchant / số tiền lẻ xu → từ chối", () => {
    expect(gateway.verifyCallback({ ...ipn(), vnp_Amount: "100" })).toBeNull();
    const { vnp_SecureHash: _hash, ...unsigned } = ipn();
    expect(gateway.verifyCallback(unsigned)).toBeNull();
    expect(new VnpayGateway({ ...config, hashSecret: "khoa-khac" }).verifyCallback(ipn())).toBeNull();
    expect(gateway.verifyCallback(ipn({ vnp_TmnCode: "OTHER" }))).toBeNull();
    expect(gateway.verifyCallback(ipn({ vnp_Amount: "32000050" }))).toBeNull();
  });

  describe("hoàn tiền (merchant_webapi)", () => {
    const request = {
      refundCode: "RFDABCDEFGH2345",
      paymentCode: "PAYABCDEFGH2345",
      providerTxnId: "14000001",
      amount: 288_000n,
      paidAmount: 320_000n,
      paymentCreatedAt: new Date("2031-08-01T01:02:03Z"),
      reason: "Hoan tien ve VXNAB2CD3",
      requestedAt: new Date("2031-08-01T02:00:00Z"),
    };
    const reply = (code: string, tamper = false) => {
      const fields: Record<string, string> = {
        vnp_ResponseId: "r1",
        vnp_Command: "refund",
        vnp_ResponseCode: code,
        vnp_Message: "msg",
        vnp_TmnCode: config.tmnCode,
        vnp_TxnRef: request.paymentCode,
        vnp_Amount: "28800000",
        vnp_BankCode: "NCB",
        vnp_PayDate: "20310801090000",
        vnp_TransactionNo: "14000099",
        vnp_TransactionType: "03",
        vnp_TransactionStatus: "05",
        vnp_OrderInfo: request.reason,
      };
      const hash = hmac(refundResponseSignData(fields));
      return vi.fn(async () => new Response(JSON.stringify({ ...fields, vnp_SecureHash: tamper ? hash.replace(/^./, "0") : hash })));
    };

    it("gửi JSON ký HMAC-SHA512 trên chuỗi nối | đúng thứ tự; một phần → loại 03, × 100, giờ GMT+7; trả mã giao dịch hoàn", async () => {
      const fetchImpl = reply("00");
      expect(await new VnpayGateway(config, fetchImpl as unknown as typeof fetch).refund(request)).toEqual({ providerRefundId: "14000099" });
      const [url, init] = fetchImpl.mock.calls[0] as unknown as [string, RequestInit];
      expect(url).toBe(config.apiUrl);
      const body = JSON.parse(String(init.body)) as Record<string, string>;
      expect(body).toMatchObject({
        vnp_Command: "refund",
        vnp_TransactionType: "03",
        vnp_Amount: "28800000",
        vnp_TransactionDate: "20310801080203",
        vnp_CreateDate: "20310801090000",
        vnp_TxnRef: request.paymentCode,
        vnp_TransactionNo: "14000001",
      });
      expect(refundSignData(body)).toBe(
        "RFDABCDEFGH2345|2.1.0|refund|TESTTMN1|03|PAYABCDEFGH2345|28800000|14000001|20310801080203|vexenhanh|20310801090000|127.0.0.1|Hoan tien ve VXNAB2CD3",
      );
      expect(body.vnp_SecureHash).toBe(hmac(refundSignData(body)));
      const full = reply("00");
      await new VnpayGateway(config, full as unknown as typeof fetch).refund({ ...request, amount: 320_000n });
      expect(JSON.parse(String((full.mock.calls[0] as unknown as [string, RequestInit])[1].body)).vnp_TransactionType).toBe("02");
    });

    it("cổng từ chối dứt khoát → lỗi không thử lại; trùng / lỗi chưa rõ → thử lại; chữ ký phản hồi sai / mất mạng → lỗi thử lại", async () => {
      const failure = (fetchImpl: unknown) => new VnpayGateway(config, fetchImpl as typeof fetch).refund(request).catch((error: unknown) => error as PaymentGatewayError);
      expect(await failure(reply("91"))).toMatchObject({ retryable: false, resultCode: "91" });
      expect(await failure(reply("94"))).toMatchObject({ retryable: true, resultCode: "94" });
      expect(await failure(reply("00", true))).toMatchObject({ retryable: true, resultCode: null });
      expect(
        await failure(async () => {
          throw new TypeError("fetch failed");
        }),
      ).toBeInstanceOf(PaymentGatewayError);
    });
  });

  describe("tra cứu giao dịch — querydr (đối soát FR-BTP-17)", () => {
    const query = { paymentCode: "PAYABCDEFGH2345", requestCode: "RQABCDEFGH234567", paymentCreatedAt: new Date("2031-08-01T01:02:03Z"), requestedAt: new Date("2031-08-01T03:00:00Z") };
    const reply = (code: string, status: string, tamper = false) => {
      const fields: Record<string, string> = {
        vnp_ResponseId: "r2",
        vnp_Command: "querydr",
        vnp_ResponseCode: code,
        vnp_Message: "msg",
        vnp_TmnCode: config.tmnCode,
        vnp_TxnRef: query.paymentCode,
        vnp_Amount: "32000000",
        vnp_BankCode: "NCB",
        vnp_PayDate: "20310801081000",
        vnp_TransactionNo: "14000001",
        vnp_TransactionType: "01",
        vnp_TransactionStatus: status,
        vnp_OrderInfo: "Doi soat",
        vnp_PromotionCode: "",
        vnp_PromotionAmount: "",
      };
      const hash = hmac(queryDrResponseSignData(fields));
      return vi.fn(async () => new Response(JSON.stringify({ ...fields, vnp_SecureHash: tamper ? hash.replace(/^./, "0") : hash })));
    };

    it("gửi querydr ký HMAC-SHA512 chuỗi nối | đúng thứ tự (giờ GMT+7); đã trả → SUCCESS kèm mã giao dịch + số tiền đồng", async () => {
      const fetchImpl = reply("00", "00");
      expect(await new VnpayGateway(config, fetchImpl as unknown as typeof fetch).queryTransaction(query)).toEqual({ status: "SUCCESS", providerTxnId: "14000001", amount: 320_000n, resultCode: "00" });
      const body = JSON.parse(String((fetchImpl.mock.calls[0] as unknown as [string, RequestInit])[1].body)) as Record<string, string>;
      expect(queryDrSignData(body)).toBe("RQABCDEFGH234567|2.1.0|querydr|TESTTMN1|PAYABCDEFGH2345|20310801080203|20310801100000|127.0.0.1|Doi soat PAYABCDEFGH2345");
      expect(body.vnp_SecureHash).toBe(hmac(queryDrSignData(body)));
    });

    it("trạng thái: 01 → PENDING, 02 → FAILED, đã hoàn sau đó (06) vẫn là đã trả; mã 91 → NOT_FOUND; 94 → lỗi thử lại; chữ ký phản hồi sai → lỗi", async () => {
      const run = (fetchImpl: unknown) => new VnpayGateway(config, fetchImpl as typeof fetch).queryTransaction(query);
      expect((await run(reply("00", "01"))).status).toBe("PENDING");
      expect((await run(reply("00", "02"))).status).toBe("FAILED");
      expect((await run(reply("00", "06"))).status).toBe("SUCCESS");
      expect((await run(reply("91", ""))).status).toBe("NOT_FOUND");
      expect(await run(reply("94", "")).catch((error: unknown) => error)).toMatchObject({ retryable: true, resultCode: "94" });
      expect(await run(reply("00", "00", true)).catch((error: unknown) => error)).toBeInstanceOf(PaymentGatewayError);
    });
  });
});
