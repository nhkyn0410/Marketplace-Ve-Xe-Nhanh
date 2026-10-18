import { createHash } from "node:crypto";
import { Logger, Module } from "@nestjs/common";
import { APP_CONFIG, type AppConfig } from "../../config/env.config";
import { MomoGateway } from "./momo/momo-gateway";
import { PAYMENT_GATEWAYS, type PaymentGateway, type PaymentGateways } from "./payment-gateway";
import {
  PAYMENT_SIMULATOR,
  PAYMENT_SIMULATOR_PATH,
  type PaymentSimulator,
  PaymentSimulatorController,
} from "./simulator/payment-simulator.controller";
import { VnpayGateway } from "./vnpay/vnpay-gateway";

/**
 * Khóa của cổng giả lập: CỐ ĐỊNH theo tên (không phải bí mật — chỉ dev / test, không có tiền thật) để API và worker (hai
 * tiến trình) ký / kiểm cùng một khóa, vd worker gọi API hoàn tiền của cổng giả lập trong API.
 */
function devKey(name: string, bytes: number): string {
  return createHash("sha256").update(`vexenhanh-dev-payment-simulator:${name}`).digest("hex").slice(0, bytes * 2);
}

/** Dựng các cổng theo config — tách ra để worker / test dựng cùng một cách. */
export function createPaymentGateways(config: AppConfig): { gateways: PaymentGateways; simulator: PaymentSimulator } {
  const logger = new Logger("PaymentModule");
  const apiBase = config.BETTER_AUTH_URL.replace(/\/+$/, "");
  const simulatorBase = `${apiBase}/v1/${PAYMENT_SIMULATOR_PATH}`;
  const dev = config.NODE_ENV !== "production";
  const simulator: PaymentSimulator = { vnpay: null, momo: null };
  const gateways = new Map<PaymentGateway["provider"], PaymentGateway>();

  if (config.VNPAY_TMN_CODE && config.VNPAY_HASH_SECRET) {
    gateways.set(
      "VNPAY",
      new VnpayGateway({ tmnCode: config.VNPAY_TMN_CODE, hashSecret: config.VNPAY_HASH_SECRET, paymentUrl: config.VNPAY_PAYMENT_URL, apiUrl: config.VNPAY_API_URL }),
    );
  } else if (dev) {
    simulator.vnpay = {
      tmnCode: "DEVSIM01",
      hashSecret: devKey("vnpay", 32),
      paymentUrl: `${simulatorBase}/vnpay`,
      apiUrl: `${simulatorBase}/vnpay/merchant_webapi/api/transaction`,
    };
    gateways.set("VNPAY", new VnpayGateway(simulator.vnpay));
  }
  const momoIpnUrl = `${apiBase}/v1/webhooks/payment/momo`;
  if (config.MOMO_PARTNER_CODE && config.MOMO_ACCESS_KEY && config.MOMO_SECRET_KEY) {
    gateways.set(
      "MOMO",
      new MomoGateway({
        partnerCode: config.MOMO_PARTNER_CODE,
        accessKey: config.MOMO_ACCESS_KEY,
        secretKey: config.MOMO_SECRET_KEY,
        endpoint: config.MOMO_ENDPOINT.replace(/\/+$/, ""),
        ipnUrl: momoIpnUrl,
      }),
    );
  } else if (dev) {
    simulator.momo = {
      partnerCode: "DEVSIM01",
      accessKey: devKey("momo-access", 12),
      secretKey: devKey("momo-secret", 32),
      endpoint: `${simulatorBase}/momo`,
      ipnUrl: momoIpnUrl,
    };
    gateways.set("MOMO", new MomoGateway(simulator.momo));
  }
  if (simulator.vnpay || simulator.momo) {
    logger.warn("Chưa khai khóa cổng thanh toán — dùng cổng GIẢ LẬP trong API (chỉ dev / test, không có tiền thật).");
  } else if (gateways.size < 2) {
    logger.warn("Có cổng thanh toán chưa khai khóa — tạo payment qua cổng đó trả 503 (OQ-22).");
  }
  return { gateways, simulator };
}

/**
 * Cổng thanh toán (ADR-019, mẫu RoutingModule / StorageModule): có khóa → adapter VNPay / MoMo thật (URL mặc định là
 * sandbox); dev / test thiếu khóa → cùng adapter thật nhưng trỏ về cổng giả lập trong API, ký bằng khóa cố định chỉ cho dev.
 * Controller giả lập trả 404 khi cổng tương ứng không phải giả lập.
 */
@Module({
  controllers: [PaymentSimulatorController],
  providers: [
    { provide: "PAYMENT_SETUP", inject: [APP_CONFIG], useFactory: createPaymentGateways },
    { provide: PAYMENT_GATEWAYS, inject: ["PAYMENT_SETUP"], useFactory: (setup: ReturnType<typeof createPaymentGateways>) => setup.gateways },
    { provide: PAYMENT_SIMULATOR, inject: ["PAYMENT_SETUP"], useFactory: (setup: ReturnType<typeof createPaymentGateways>) => setup.simulator },
  ],
  exports: [PAYMENT_GATEWAYS],
})
export class PaymentGatewayModule {}
