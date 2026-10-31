import { Body, Controller, Get, Header, HttpCode, Inject, NotFoundException, Post, Query, Res, ServiceUnavailableException } from "@nestjs/common";
import { ApiExcludeController } from "@nestjs/swagger";
import type { Response } from "express";
import { PAYMENT_GATEWAYS, type PaymentGateways } from "../payment-gateway";
import { PAYMENT_SIMULATOR_PATH } from "../simulator/payment-simulator.controller";
import { DemoGateway } from "./demo-gateway";

/** Trang thanh toán thử nội bộ; mọi route trả 404 khi DEMO không được bật. */
@ApiExcludeController()
@Controller(`${PAYMENT_SIMULATOR_PATH}/demo`)
export class DemoPaymentController {
  constructor(@Inject(PAYMENT_GATEWAYS) private readonly gateways: PaymentGateways) {}

  /** Hiển thị hai lựa chọn thành công hoặc thất bại cho đơn thử còn hạn. */
  @Get()
  @Header("content-type", "text/html; charset=utf-8")
  page(@Query("token") token: string): string {
    const order = this.gateway().checkoutOrder(token);
    if (!order) throw new NotFoundException();
    const amount = new Intl.NumberFormat("vi-VN").format(BigInt(order.amount));
    return `<!doctype html><html lang="vi"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>Thanh toán thử</title>
<style>body{font-family:system-ui,sans-serif;max-width:420px;margin:48px auto;padding:0 16px;color:#111}.box{border:1px solid #ddd;border-radius:12px;padding:20px}button{display:block;width:100%;padding:12px;border:0;border-radius:8px;margin-top:12px}.ok{background:#087c32;color:white}small{color:#666}</style></head><body><div class="box"><small>CỔNG THỬ — không có tiền thật</small><h1>Thanh toán thử</h1><p>${escapeHtml(order.orderInfo)}</p><p><strong>${escapeHtml(amount)} đ</strong></p><form method="post" action="${escapeHtml(this.gateway().config.baseUrl)}/complete"><input type="hidden" name="token" value="${escapeHtml(token)}"><button class="ok" name="outcome" value="success">Thanh toán thành công</button><button name="outcome" value="fail">Thanh toán thất bại</button></form></div></body></html>`;
  }

  /** Gửi webhook có ký rồi đưa trình duyệt về trang kết quả đã khai trong đơn thử. */
  @Post("complete")
  async complete(@Body() body: Record<string, unknown>, @Res() response: Response): Promise<void> {
    const gateway = this.gateway();
    const order = gateway.checkoutOrder(typeof body.token === "string" ? body.token : undefined);
    if (!order || (body.outcome !== "success" && body.outcome !== "fail")) throw new NotFoundException();
    const callback = gateway.complete(order, body.outcome === "success");
    try {
      const reply = await fetch(gateway.config.callbackUrl, { method: "POST", headers: { "content-type": "application/json" }, body: JSON.stringify(callback), signal: AbortSignal.timeout(10_000) });
      if (!reply.ok) throw new Error("callback unavailable");
    } catch {
      throw new ServiceUnavailableException("Chưa gửi được kết quả thử. Vui lòng thử lại.");
    }
    response.redirect(302, order.returnUrl);
  }

  /** Cho worker tra cứu lại kết quả thử bằng yêu cầu đã ký. */
  @Post("query")
  @HttpCode(200)
  query(@Body() body: Record<string, unknown>): object | null {
    const outcome = this.gateway().queryOutcome(body);
    if (outcome === undefined) throw new NotFoundException();
    return outcome;
  }

  private gateway(): DemoGateway {
    const gateway = this.gateways.get("DEMO");
    if (!(gateway instanceof DemoGateway)) throw new NotFoundException();
    return gateway;
  }
}

function escapeHtml(value: string): string {
  return value.replace(/[&<>"']/g, (char) => `&#${char.charCodeAt(0)};`);
}
