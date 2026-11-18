import { Controller, Get, Inject } from "@nestjs/common";
import { ApiTags } from "@nestjs/swagger";
import { ZodResponse } from "nestjs-zod";
import { type GatewayProvider, PAYMENT_GATEWAYS, type PaymentGateways } from "../external/payment/payment-gateway";
import { PaymentProviderListDto, type PaymentProviderList } from "./dto/payment.dto";

/** Thứ tự hiển thị của SCR-PSG-20 (06 UI): payOS, MoMo, VNPay, cổng thử. */
export const PAYMENT_PROVIDER_ORDER: readonly GatewayProvider[] = ["PAYOS", "MOMO", "VNPAY", "DEMO"];

/** Cổng nào đang bật = cổng đã có khóa / được bật trong cấu hình máy chủ (`createPaymentGateways`). */
export function listPaymentProviders(gateways: PaymentGateways): PaymentProviderList {
  return { items: PAYMENT_PROVIDER_ORDER.map((provider) => ({ provider, enabled: gateways.has(provider) })) };
}

// CÔNG KHAI (PASSENGER-PARITY Q5, chờ duyệt): web và ứng dụng hành khách dựng danh sách phương thức thanh toán từ đây
// thay vì ghi cứng. Không `@Authorize` vì khách vãng lai cũng thanh toán. Chỉ nêu tên cổng và cờ bật — không lộ khóa.
@ApiTags("payments")
@Controller("payment-providers")
/** Danh sách cổng thanh toán đang bật. */
export class PaymentProviderController {
  constructor(@Inject(PAYMENT_GATEWAYS) private readonly gateways: PaymentGateways) {}

  @Get()
  @ZodResponse({ status: 200, description: "Các cổng theo thứ tự hiển thị, kèm cờ đang bật.", type: PaymentProviderListDto })
  list(): PaymentProviderList {
    return listPaymentProviders(this.gateways);
  }
}
