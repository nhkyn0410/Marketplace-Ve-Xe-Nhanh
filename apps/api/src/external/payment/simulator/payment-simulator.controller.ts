import { createHmac, randomInt, timingSafeEqual } from "node:crypto";
import { Body, Controller, Get, Header, HttpCode, Inject, Logger, NotFoundException, Post, Query, Res } from "@nestjs/common";
import { ApiExcludeController } from "@nestjs/swagger";
import type { Response } from "express";
import { type MomoConfig, sign as momoSign } from "../momo/momo-gateway";
import { refundResponseSignData, refundSignData, type VnpayConfig, sign as vnpaySign, signedQuery, vnTimestamp } from "../vnpay/vnpay-gateway";

export const PAYMENT_SIMULATOR_PATH = "dev/payment-gateway";
export const PAYMENT_SIMULATOR = Symbol("PAYMENT_SIMULATOR");

/** Khóa của cổng giả lập (sinh mỗi lần chạy) — chỉ có ở dev / test khi cổng thật chưa khai khóa. */
export type PaymentSimulator = { vnpay: VnpayConfig | null; momo: MomoConfig | null };

const VN_OFFSET_MS = 7 * 3_600_000;
const CALLBACK_TIMEOUT_MS = 10_000;

/**
 * Cổng thanh toán GIẢ LẬP cho dev / test (Khanh 17/10/2026: "Adapter thật + cổng giả lập dev"): đóng vai VNPay / MoMo
 * sandbox để chạy trọn luồng thanh toán mà không cần khóa — nhận link thanh toán đã ký, cho chọn "thành công" / "thất
 * bại", rồi gửi IPN đã ký về webhook của chính API (server-to-server như cổng thật) và đưa trình duyệt về trang kết quả.
 * Cổng tương ứng không phải giả lập (đã khai khóa / production) → mọi route 404. Không vào OpenAPI.
 */
@ApiExcludeController()
@Controller(PAYMENT_SIMULATOR_PATH)
export class PaymentSimulatorController {
  private readonly logger = new Logger(PaymentSimulatorController.name);

  constructor(@Inject(PAYMENT_SIMULATOR) private readonly simulator: PaymentSimulator) {}

  /** Trang thanh toán VNPay giả lập — query y như link VNPay thật (`vnp_*` + `vnp_SecureHash`). */
  @Get("vnpay")
  @Header("content-type", "text/html; charset=utf-8")
  vnpayPage(@Query() query: Record<string, string>): string {
    const params = this.verifiedVnpayRequest(query);
    const signed = new URLSearchParams(query).toString();
    return page(
      "VNPay (giả lập)",
      Number(BigInt(params.vnp_Amount!) / 100n),
      params.vnp_OrderInfo ?? "",
      `vnpay/complete?${new URLSearchParams({ outcome: "success", request: signed })}`,
      `vnpay/complete?${new URLSearchParams({ outcome: "fail", request: signed })}`,
    );
  }

  @Get("vnpay/complete")
  async vnpayComplete(@Query("outcome") outcome: string, @Query("request") request: string, @Res() res: Response): Promise<void> {
    const config = this.simulator.vnpay!;
    const params = this.verifiedVnpayRequest(Object.fromEntries(new URLSearchParams(request ?? "")));
    const success = outcome === "success";
    const callback: Record<string, string> = {
      vnp_Amount: params.vnp_Amount!,
      vnp_BankCode: "NCB",
      vnp_CardType: "ATM",
      vnp_OrderInfo: params.vnp_OrderInfo ?? "",
      vnp_PayDate: new Date(Date.now() + VN_OFFSET_MS).toISOString().replace(/[-:T]/g, "").slice(0, 14),
      vnp_ResponseCode: success ? "00" : "24",
      vnp_TmnCode: config.tmnCode,
      vnp_TransactionNo: success ? String(randomInt(10_000_000, 99_999_999)) : "0",
      vnp_TransactionStatus: success ? "00" : "02",
      vnp_TxnRef: params.vnp_TxnRef!,
    };
    const query = `${signedQuery(callback)}&vnp_SecureHash=${vnpaySign(signedQuery(callback), config.hashSecret)}`;
    // IPN VNPay là GET tới URL khai ở cổng quản trị — ở bản giả lập là webhook của chính API.
    await this.deliver(`${config.paymentUrl.replace(/\/v1\/.*$/, "")}/v1/webhooks/payment/vnpay?${query}`, { method: "GET" });
    res.redirect(302, `${params.vnp_ReturnUrl}${params.vnp_ReturnUrl!.includes("?") ? "&" : "?"}${query}`);
  }

  /** Thay cho API hoàn tiền `merchant_webapi` của VNPay: kiểm chữ ký, hoàn thành công ngay, phản hồi có ký. */
  @Post("vnpay/merchant_webapi/api/transaction")
  @HttpCode(200)
  vnpayRefund(@Body() body: Record<string, string>): Record<string, string> {
    const config = this.simulator.vnpay;
    if (!config) {
      throw new NotFoundException();
    }
    const valid = safeEqual(vnpaySign(refundSignData(body), config.hashSecret), String(body.vnp_SecureHash ?? "")) && body.vnp_Command === "refund";
    const response: Record<string, string> = {
      vnp_ResponseId: randomInt(100_000_000, 999_999_999).toString(),
      vnp_Command: "refund",
      vnp_ResponseCode: valid ? "00" : "97",
      vnp_Message: valid ? "Refund success" : "Invalid checksum",
      vnp_TmnCode: config.tmnCode,
      vnp_TxnRef: body.vnp_TxnRef ?? "",
      vnp_Amount: body.vnp_Amount ?? "",
      vnp_BankCode: "NCB",
      vnp_PayDate: vnTimestamp(new Date()),
      vnp_TransactionNo: valid ? String(randomInt(10_000_000, 99_999_999)) : "0",
      vnp_TransactionType: body.vnp_TransactionType ?? "",
      vnp_TransactionStatus: valid ? "05" : "",
      vnp_OrderInfo: body.vnp_OrderInfo ?? "",
    };
    return { ...response, vnp_SecureHash: vnpaySign(refundResponseSignData(response), config.hashSecret) };
  }

  /** Thay cho `POST /v2/gateway/api/refund` của MoMo: kiểm chữ ký, hoàn thành công ngay. */
  @Post("momo/v2/gateway/api/refund")
  @HttpCode(200)
  momoRefund(@Body() body: Record<string, unknown>): { resultCode: number; message: string; transId?: number } {
    const config = this.momo();
    const raw = ["accessKey", "amount", "description", "orderId", "partnerCode", "requestId", "transId"]
      .map((key) => `${key}=${key === "accessKey" ? config.accessKey : String(body[key] ?? "")}`)
      .join("&");
    if (!safeEqual(momoSign(raw, config.secretKey), String(body.signature ?? ""))) {
      return { resultCode: 11007, message: "Sai chữ ký." };
    }
    return { resultCode: 0, message: "Thành công.", transId: randomInt(1_000_000_000, 9_999_999_999) };
  }

  /** Thay cho `POST /v2/gateway/api/create` của MoMo: kiểm chữ ký rồi trả `payUrl` tới trang giả lập. */
  @Post("momo/v2/gateway/api/create")
  @HttpCode(200)
  momoCreate(@Body() body: Record<string, unknown>): { resultCode: number; message: string; payUrl?: string } {
    const config = this.momo();
    const raw = ["accessKey", "amount", "extraData", "ipnUrl", "orderId", "orderInfo", "partnerCode", "redirectUrl", "requestId", "requestType"]
      .map((key) => `${key}=${key === "accessKey" ? config.accessKey : String(body[key] ?? "")}`)
      .join("&");
    if (!safeEqual(momoSign(raw, config.secretKey), String(body.signature ?? ""))) {
      return { resultCode: 11007, message: "Sai chữ ký." };
    }
    const order = {
      orderId: String(body.orderId),
      requestId: String(body.requestId),
      amount: String(body.amount),
      orderInfo: String(body.orderInfo),
      redirectUrl: String(body.redirectUrl),
      ipnUrl: String(body.ipnUrl),
    };
    const token = Buffer.from(JSON.stringify(order)).toString("base64url");
    return { resultCode: 0, message: "Thành công.", payUrl: `${config.endpoint}/pay?token=${token}.${tokenMac(token, config.secretKey)}` };
  }

  @Get("momo/pay")
  @Header("content-type", "text/html; charset=utf-8")
  momoPage(@Query("token") token: string): string {
    const order = this.momoOrder(token);
    return page(
      "MoMo (giả lập)",
      Number(order.amount),
      order.orderInfo,
      `complete?${new URLSearchParams({ outcome: "success", token })}`,
      `complete?${new URLSearchParams({ outcome: "fail", token })}`,
    );
  }

  @Get("momo/complete")
  async momoComplete(@Query("outcome") outcome: string, @Query("token") token: string, @Res() res: Response): Promise<void> {
    const config = this.momo();
    const order = this.momoOrder(token);
    const success = outcome === "success";
    const callback: Record<string, string | number> = {
      partnerCode: config.partnerCode,
      orderId: order.orderId,
      requestId: order.requestId,
      amount: Number(order.amount),
      orderInfo: order.orderInfo,
      orderType: "momo_wallet",
      transId: success ? randomInt(1_000_000_000, 9_999_999_999) : 0,
      resultCode: success ? 0 : 1006,
      message: success ? "Thành công." : "Người dùng từ chối giao dịch.",
      payType: "qr",
      responseTime: Date.now(),
      extraData: "",
    };
    const raw = ["accessKey", "amount", "extraData", "message", "orderId", "orderInfo", "orderType", "partnerCode", "payType", "requestId", "responseTime", "resultCode", "transId"]
      .map((key) => `${key}=${key === "accessKey" ? config.accessKey : String(callback[key])}`)
      .join("&");
    const signed = { ...callback, signature: momoSign(raw, config.secretKey) };
    await this.deliver(order.ipnUrl, { method: "POST", headers: { "content-type": "application/json" }, body: JSON.stringify(signed) });
    const query = new URLSearchParams(Object.entries(signed).map(([key, value]) => [key, String(value)]));
    res.redirect(302, `${order.redirectUrl}${order.redirectUrl.includes("?") ? "&" : "?"}${query}`);
  }

  private verifiedVnpayRequest(query: Record<string, string>): Record<string, string> {
    const config = this.simulator.vnpay;
    if (!config) {
      throw new NotFoundException();
    }
    const { vnp_SecureHash: given, ...params } = query;
    if (!given || !safeEqual(vnpaySign(signedQuery(params), config.hashSecret), given) || !/^\d+$/.test(params.vnp_Amount ?? "")) {
      throw new NotFoundException();
    }
    return params;
  }

  private momo(): MomoConfig {
    if (!this.simulator.momo) {
      throw new NotFoundException();
    }
    return this.simulator.momo;
  }

  private momoOrder(token: string | undefined) {
    const config = this.momo();
    const [payload, mac] = (token ?? "").split(".");
    if (!payload || !mac || !safeEqual(tokenMac(payload, config.secretKey), mac)) {
      throw new NotFoundException();
    }
    return JSON.parse(Buffer.from(payload, "base64url").toString()) as {
      orderId: string;
      requestId: string;
      amount: string;
      orderInfo: string;
      redirectUrl: string;
      ipnUrl: string;
    };
  }

  /** Gửi IPN như cổng thật; lỗi chỉ ghi log (cổng thật cũng chỉ thử lại về sau). */
  private async deliver(url: string, init: RequestInit): Promise<void> {
    try {
      const response = await fetch(url, { ...init, signal: AbortSignal.timeout(CALLBACK_TIMEOUT_MS) });
      this.logger.log({ event: "payment.simulator.ipn", status: response.status });
    } catch (error) {
      this.logger.warn({ event: "payment.simulator.ipn_failed", error });
    }
  }
}

function tokenMac(payload: string, secret: string): string {
  return createHmac("sha256", secret).update(`sim:${payload}`).digest("base64url");
}

function safeEqual(expected: string, given: string): boolean {
  const a = Buffer.from(expected.toLowerCase());
  const b = Buffer.from(given.toLowerCase());
  return a.length === b.length && timingSafeEqual(a, b);
}

function escapeHtml(value: string): string {
  return value.replace(/[&<>"']/g, (char) => `&#${char.charCodeAt(0)};`);
}

function page(title: string, amount: number, orderInfo: string, successHref: string, failHref: string): string {
  const vnd = new Intl.NumberFormat("vi-VN").format(amount);
  return `<!doctype html><html lang="vi"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>${escapeHtml(title)}</title><style>body{font-family:system-ui,sans-serif;max-width:420px;margin:48px auto;padding:0 16px;color:#111}
.box{border:1px solid #ddd;border-radius:12px;padding:20px}a{display:block;text-align:center;padding:12px;border-radius:8px;margin-top:12px;text-decoration:none}
.ok{background:#0a7d32;color:#fff}.fail{background:#eee;color:#111}small{color:#666}</style></head><body>
<div class="box"><small>CỔNG GIẢ LẬP — không có tiền thật (chỉ dev / test)</small><h1>${escapeHtml(title)}</h1>
<p>${escapeHtml(orderInfo)}</p><p><strong>${escapeHtml(vnd)} đ</strong></p>
<a class="ok" href="${escapeHtml(successHref)}">Thanh toán thành công</a><a class="fail" href="${escapeHtml(failHref)}">Thanh toán thất bại</a></div></body></html>`;
}
