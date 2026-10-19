import { Body, Controller, Get, HttpCode, Inject, Post, Query, Res } from "@nestjs/common";
import { ApiExcludeController } from "@nestjs/swagger";
import type { Response } from "express";
import { type CallbackAck, PaymentWebhookService } from "./payment-webhook.service";

/** Mã phản hồi IPN theo tài liệu VNPay (VNPay chấm kịch bản IPN theo đúng các mã này). */
const VNPAY_ACK: Record<CallbackAck, { RspCode: string; Message: string }> = {
  ACCEPTED: { RspCode: "00", Message: "Confirm Success" },
  ALREADY_CONFIRMED: { RspCode: "02", Message: "Order already confirmed" },
  NOT_FOUND: { RspCode: "01", Message: "Order not found" },
  AMOUNT_MISMATCH: { RspCode: "04", Message: "Invalid amount" },
  INVALID_SIGNATURE: { RspCode: "97", Message: "Invalid signature" },
};

/**
 * Webhook IPN của cổng thanh toán (API §10.1, ADR-019) — public, không token: tin cậy CHỈ dựa trên chữ ký HMAC của cổng.
 * VNPay gọi GET (query) và đọc `RspCode`; MoMo POST JSON và chờ 204. Không vào OpenAPI (client không gọi).
 */
@ApiExcludeController()
@Controller("webhooks/payment")
export class PaymentWebhookController {
  constructor(@Inject(PaymentWebhookService) private readonly webhooks: PaymentWebhookService) {}

  @Get("vnpay")
  @HttpCode(200)
  async vnpay(@Query() query: Record<string, unknown>): Promise<{ RspCode: string; Message: string }> {
    try {
      return VNPAY_ACK[await this.webhooks.receive("VNPAY", query)];
    } catch {
      // Chưa nhận được (Redis / DB lỗi) → VNPay gửi lại IPN.
      return { RspCode: "99", Message: "Unknown error" };
    }
  }

  @Post("momo")
  async momo(@Body() body: Record<string, unknown> | undefined, @Res() res: Response): Promise<void> {
    const ack = await this.webhooks.receive("MOMO", body ?? {});
    res.status(ack === "INVALID_SIGNATURE" ? 400 : 204).end();
  }
}
