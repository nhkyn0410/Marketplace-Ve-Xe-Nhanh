import { randomInt } from "node:crypto";
import { Inject, Injectable, Logger } from "@nestjs/common";
import { bookingNotFound } from "../booking/booking.errors";
import { canAccessBooking } from "../booking/booking-access";
import { counterError } from "../booking/counter-sales.errors";
import { APP_CONFIG, type AppConfig } from "../config/env.config";
import { withBookingOperator } from "../database/marketplace-scope";
import { PrismaService, type DbTransaction } from "../database/prisma.service";
import { PaymentStatus } from "../database/prisma.types";
import { PAYMENT_GATEWAYS, PaymentGatewayError, type PaymentGateway, type PaymentGateways } from "../external/payment/payment-gateway";
import { vndToJson } from "../fare/fare-pricing";
import type { VerifiedAccessToken } from "../iam/auth/token.service";
import type { PaymentInput, PaymentResponse } from "./dto/payment.dto";
import {
  amountOutOfRange,
  bookingExpired,
  bookingInvalidState,
  paymentInProgress,
  providerError,
  providerUnavailable,
} from "./payment.errors";

/** Mã gửi cổng `PAY` + 12 ký tự (CHECK `payments_code_format`). */
const CODE_ALPHABET = "23456789ABCDEFGHJKLMNPQRSTUVWXYZ";
/** Payment `INITIATED` trẻ hơn mức này = request khác đang gọi cổng → 409; già hơn = lần trước lỗi giữa chừng → hủy, tạo lại. */
const IN_FLIGHT_MS = 30_000;
const OPEN = [PaymentStatus.INITIATED, PaymentStatus.PROCESSING];

type PaymentRow = {
  id: string;
  paymentCode: string;
  provider: PaymentInput["provider"];
  status: PaymentStatus;
  amount: bigint;
  paymentUrl: string | null;
  expiresAt: Date;
  createdAt: Date;
};

const PAYMENT_SELECT = { id: true, paymentCode: true, provider: true, status: true, amount: true, paymentUrl: true, expiresAt: true, createdAt: true } as const;

/**
 * Tạo payment cho booking (TASK-BTP-003, FR-BTP-07, BR-27, ADR-019). Chỉ booking `PENDING_PAYMENT` còn hạn, của chính
 * người gọi (hành khách / mã truy cập của khách vãng lai). Ba bước để KHÔNG gọi cổng khi đang giữ transaction:
 * (1) khoá booking, kiểm, ghi payment `INITIATED` (hoặc trả lại payment đang mở cùng cổng — idempotent theo booking + cổng);
 * (2) gọi cổng lấy link; (3) `INITIATED → PROCESSING` kèm link. Số tiền = tổng booking; hạn = hạn booking.
 */
@Injectable()
export class PaymentService {
  private readonly logger = new Logger(PaymentService.name);

  constructor(
    @Inject(PrismaService) private readonly prisma: PrismaService,
    @Inject(PAYMENT_GATEWAYS) private readonly gateways: PaymentGateways,
    @Inject(APP_CONFIG) private readonly config: AppConfig,
  ) {}

  async create(
    user: VerifiedAccessToken | null,
    bookingId: string,
    accessToken: string | undefined,
    input: PaymentInput,
    clientIp: string | undefined,
  ): Promise<PaymentResponse> {
    const gateway = this.gateways.get(input.provider);
    if (!gateway) {
      throw providerUnavailable();
    }
    const now = new Date();
    const prepared = await withBookingOperator(this.prisma, bookingId, (tx, operatorId) =>
      this.prepare(tx, operatorId, bookingId, user, accessToken, gateway, now),
    );
    if (!prepared) {
      throw bookingNotFound();
    }
    const { payment, bookingCode } = prepared;
    if (payment.status === PaymentStatus.PROCESSING && payment.paymentUrl) {
      return toResponse(payment);
    }

    let paymentUrl: string;
    try {
      ({ paymentUrl } = await gateway.createCheckout({
        paymentCode: payment.paymentCode,
        amount: payment.amount,
        orderInfo: `Thanh toan ve ${bookingCode}`,
        returnUrl: `${this.config.PAYMENT_RETURN_BASE_URL.replace(/\/+$/, "")}/bookings/${bookingId}/payment/result`,
        clientIp: clientIp ?? "127.0.0.1",
        // Giờ tạo giao dịch = giờ tạo payment: hoàn tiền VNPay gửi lại đúng mốc này (`vnp_TransactionDate`).
        createdAt: payment.createdAt,
        expiresAt: payment.expiresAt,
      }));
    } catch (error) {
      if (!(error instanceof PaymentGatewayError)) {
        throw error;
      }
      this.logger.warn({ event: "payment.gateway_failed", provider: gateway.provider, paymentCode: payment.paymentCode, error: error.message });
      await withBookingOperator(this.prisma, bookingId, (tx, operatorId) =>
        transition(tx, operatorId, payment, PaymentStatus.FAILED, { failureCode: "GATEWAY_ERROR" }, error.message),
      );
      throw providerError();
    }
    const updated = await withBookingOperator(this.prisma, bookingId, (tx, operatorId) =>
      transition(tx, operatorId, payment, PaymentStatus.PROCESSING, { paymentUrl }, "Đã tạo link thanh toán ở cổng."),
    );
    if (!updated) {
      // Booking vừa hết hạn / được thanh toán qua cổng khác giữa chừng → payment đã bị đóng.
      throw bookingInvalidState("đã thay đổi");
    }
    return toResponse({ ...payment, status: PaymentStatus.PROCESSING, paymentUrl });
  }

  private async prepare(
    tx: DbTransaction,
    operatorId: string,
    bookingId: string,
    user: VerifiedAccessToken | null,
    accessToken: string | undefined,
    gateway: PaymentGateway,
    now: Date,
  ): Promise<{ payment: PaymentRow; bookingCode: string } | null> {
    // Khoá booking: tạo payment xếp hàng với nhau + với job hết hạn / callback thành công.
    await tx.$queryRaw`SELECT id FROM bookings WHERE id = ${bookingId} AND operator_id = ${operatorId} FOR UPDATE`;
    const booking = await tx.booking.findFirst({
      where: { id: bookingId, operatorId },
      select: { bookingCode: true, channel: true, status: true, total: true, expiresAt: true, userId: true, accessTokenHash: true },
    });
    if (!booking || !canAccessBooking(booking, user, accessToken)) {
      return null;
    }
    if (booking.channel === "COUNTER") throw counterError("COUNTER_PAYMENT_MANUAL_REQUIRED", "Đơn tại quầy do nhà xe xác nhận thu tiền trực tiếp, không tạo thanh toán qua cổng online.");
    if (booking.status === "PENDING_PAYMENT" && booking.expiresAt <= now) {
      throw bookingExpired();
    }
    if (booking.status !== "PENDING_PAYMENT") {
      throw booking.status === "EXPIRED" ? bookingExpired() : bookingInvalidState(booking.status);
    }
    if (booking.total < gateway.minAmount || booking.total > gateway.maxAmount) {
      throw amountOutOfRange();
    }
    const open = await tx.payment.findFirst({
      where: { bookingId, operatorId, provider: gateway.provider, status: { in: OPEN } },
      select: PAYMENT_SELECT,
    });
    if (open?.status === PaymentStatus.PROCESSING) {
      return { payment: open, bookingCode: booking.bookingCode };
    }
    if (open) {
      if (now.getTime() - open.createdAt.getTime() < IN_FLIGHT_MS) {
        throw paymentInProgress();
      }
      await transition(tx, operatorId, open, PaymentStatus.CANCELLED, {}, "Tạo link thanh toán lỗi giữa chừng.");
    }
    const payment = await tx.payment.create({
      data: {
        paymentCode: newPaymentCode(),
        operatorId,
        bookingId,
        provider: gateway.provider,
        status: PaymentStatus.INITIATED,
        amount: booking.total,
        expiresAt: booking.expiresAt,
        histories: { create: { toStatus: PaymentStatus.INITIATED, actor: user ? `user:${user.sub}` : "guest" } },
      },
      select: PAYMENT_SELECT,
    });
    return { payment, bookingCode: booking.bookingCode };
  }
}

/**
 * Đổi trạng thái payment có điều kiện (chỉ từ trạng thái đang mở) + ghi lịch sử. Trả `false` khi payment đã bị đóng bởi
 * thao tác khác (callback, job hết hạn) — không ghi đè.
 */
async function transition(
  tx: DbTransaction,
  operatorId: string,
  payment: { id: string; status: PaymentStatus },
  to: PaymentStatus,
  data: { paymentUrl?: string; failureCode?: string },
  reason: string,
): Promise<boolean> {
  const updated = await tx.payment.updateMany({ where: { id: payment.id, operatorId, status: payment.status }, data: { status: to, ...data } });
  if (updated.count === 0) {
    return false;
  }
  await tx.paymentStatusHistory.create({ data: { paymentId: payment.id, operatorId, fromStatus: payment.status, toStatus: to, reason, actor: "system" } });
  return true;
}

function newPaymentCode(): string {
  let code = "PAY";
  for (let i = 0; i < 12; i++) {
    code += CODE_ALPHABET[randomInt(CODE_ALPHABET.length)];
  }
  return code;
}

function toResponse(payment: PaymentRow): PaymentResponse {
  return {
    paymentId: payment.id,
    paymentCode: payment.paymentCode,
    provider: payment.provider,
    status: payment.status,
    amount: vndToJson(payment.amount),
    paymentUrl: payment.paymentUrl!,
    expiresAt: payment.expiresAt.toISOString(),
  };
}
