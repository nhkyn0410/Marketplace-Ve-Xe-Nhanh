import { Logger } from "@nestjs/common";
import type { AuditService } from "../audit/audit.service";
import { withDeliveryOperator } from "../database/notification-scope";
import type { DbTransaction, PrismaService } from "../database/prisma.service";
import { NotificationDeliveryStatus, NotificationKind, OperatorRole, AccountStatus, TicketStatus } from "../database/prisma.types";
import { EmailUnavailableError, type EmailNotifier } from "../external/notification/email-notifier";
import { vndToJson } from "../fare/fare-pricing";
import { renderNotification, type NotificationContent, type TripScheduleSnapshot } from "./notification-templates";
import { withNotificationSubject } from "../database/preference-scope";

// Gửi một bản thông báo (TASK-NSR-001, ADR-020, RSK-14): job BullMQ ở worker. Ba bước như hoàn tiền: (1) đọc bản gửi còn
// `PENDING` + dữ liệu MỚI NHẤT để dựng nội dung; (2) gửi email NGOÀI transaction; (3) ghi `SENT` / `FAILED` / `SKIPPED` có điều
// kiện. Lỗi tạm thời → BullMQ thử lại theo backoff, lần cuối ghi `FAILED`. Chưa cấu hình kênh (dev) → `SKIPPED`, không thử lại.

export const NOTIFICATION_JOB = "deliver";
export const NOTIFICATION_SWEEP_JOB = "sweep";
/** Quét bản gửi `PENDING` bị kẹt (xếp hàng lỗi) mỗi 5 phút. */
export const NOTIFICATION_SWEEP_SCHEDULE = { pattern: "*/5 * * * *" } as const;
export const NOTIFICATION_JOB_OPTIONS = {
  attempts: 5,
  backoff: { type: "exponential", delay: 60_000 },
  removeOnComplete: { age: 7 * 24 * 3600 },
  removeOnFail: false,
} as const;

export type DeliveryOutcome = "NOT_FOUND" | "ALREADY_DONE" | "SENT" | "SKIPPED" | "FAILED";

type Loaded = { done: true } | { done: false; kind: NotificationKind; email: string | null; content: NotificationContent | null; recipientType?: string | null; recipientId?: string | null };

const logger = new Logger("NotificationDelivery");

export async function deliverNotification(
  prisma: Pick<PrismaService, "withSystem" | "withTenant">,
  notifier: EmailNotifier,
  audit: Pick<AuditService, "recordSystemLog"> | null,
  deliveryId: string,
  options: { finalAttempt: boolean; now?: () => Date },
): Promise<DeliveryOutcome> {
  const now = options.now ?? (() => new Date());
  const loaded = await withDeliveryOperator(prisma, deliveryId, async (tx, operatorId): Promise<Loaded | null> => {
    const delivery = await tx.notificationDelivery.findFirst({
      where: { id: deliveryId, operatorId },
      select: { status: true, recipientType: true, recipientId: true, notification: { select: { kind: true, bookingId: true, refundId: true, tripChangeId: true, payload: true } } },
    });
    if (!delivery) {
      return null;
    }
    if (delivery.status !== NotificationDeliveryStatus.PENDING) {
      return { done: true };
    }
    const target = await loadTarget(tx, operatorId, delivery.notification);
    return { done: false, kind: delivery.notification.kind, recipientType: delivery.recipientType, recipientId: delivery.recipientId, ...target };
  });
  if (!loaded) {
    return "NOT_FOUND";
  }
  if (loaded.done) {
    return "ALREADY_DONE";
  }
  if ((loaded.kind === NotificationKind.OPERATIONS_ALERT || loaded.kind === NotificationKind.LOYALTY_UPDATED || loaded.kind === NotificationKind.PROMOTION) && loaded.recipientId) {
    loaded.email = await withNotificationSubject(prisma, async (tx) => {
      if (loaded.recipientType === "PASSENGER") return (await tx.user.findUnique({ where: { id: loaded.recipientId! }, select: { email: true } }))?.email ?? null;
      if (loaded.recipientType === "PLATFORM") return (await tx.platformAccount.findUnique({ where: { id: loaded.recipientId! }, select: { contactEmail: true } }))?.contactEmail ?? null;
      if (loaded.recipientType === "EMPLOYEE") return (await tx.employeeAccount.findFirst({ where: { id: loaded.recipientId! }, select: { contactEmail: true } }))?.contactEmail ?? null;
      return loaded.email;
    });
  }
  const finish = async (status: NotificationDeliveryStatus, lastError: string | null, outcome: DeliveryOutcome): Promise<DeliveryOutcome> => {
    await withDeliveryOperator(prisma, deliveryId, (tx, operatorId) =>
      tx.notificationDelivery.updateMany({
        where: { id: deliveryId, operatorId, status: NotificationDeliveryStatus.PENDING },
        data: { status, lastError, attempts: { increment: 1 }, ...(status === NotificationDeliveryStatus.SENT ? { sentAt: now() } : {}) },
      }),
    );
    await systemLog(audit, outcome, loaded.kind, deliveryId, lastError);
    return outcome;
  };
  if (!loaded.email || !loaded.content) {
    return finish(NotificationDeliveryStatus.SKIPPED, loaded.email ? "Không còn dữ liệu để dựng nội dung." : "Không có email người nhận.", "SKIPPED");
  }
  if (!notifier.sendTransactional) {
    return finish(NotificationDeliveryStatus.SKIPPED, "Kênh email không hỗ trợ thông báo giao dịch.", "SKIPPED");
  }
  try {
    await notifier.sendTransactional({ email: loaded.email, ...renderNotification(loaded.content), logLabel: loaded.kind });
  } catch (error) {
    if (error instanceof EmailUnavailableError) {
      return finish(NotificationDeliveryStatus.SKIPPED, error.message, "SKIPPED");
    }
    const message = error instanceof Error ? error.message : String(error);
    if (!options.finalAttempt) {
      await withDeliveryOperator(prisma, deliveryId, (tx, operatorId) =>
        tx.notificationDelivery.updateMany({
          where: { id: deliveryId, operatorId, status: NotificationDeliveryStatus.PENDING },
          data: { lastError: message.slice(0, 500), attempts: { increment: 1 } },
        }),
      );
      throw error;
    }
    return finish(NotificationDeliveryStatus.FAILED, message.slice(0, 500), "FAILED");
  }
  return finish(NotificationDeliveryStatus.SENT, null, "SENT");
}

/** Người nhận + nội dung theo loại thông báo, đọc dữ liệu mới nhất ở tenant của nhà xe. */
export async function loadTarget(
  tx: DbTransaction,
  operatorId: string | null,
  notification: { kind: NotificationKind; bookingId: string | null; refundId: string | null; tripChangeId: string | null; payload: unknown },
): Promise<{ email: string | null; content: NotificationContent | null }> {
  const payload = (notification.payload ?? {}) as Record<string, unknown>;
  const booking = notification.bookingId && operatorId
    ? await tx.booking.findFirst({
        where: { id: notification.bookingId, operatorId },
        select: {
          bookingCode: true,
          contactEmail: true,
          total: true,
          snapshot: true,
          tickets: { orderBy: { ticketCode: "asc" }, select: { ticketCode: true, seatCode: true, status: true } },
        },
      })
    : null;
  const snapshot = booking?.snapshot as { trip: { routeName: string; departureAt: string }; pickup: { name: string }; dropoff: { name: string } } | undefined;
  const change = notification.tripChangeId && operatorId
    ? await tx.tripChange.findFirst({ where: { id: notification.tripChangeId, operatorId }, select: { before: true, after: true, reason: true } })
    : null;
  const refund = notification.refundId && operatorId
    ? await tx.refund.findFirst({ where: { id: notification.refundId, operatorId }, select: { refundCode: true, amount: true, payment: { select: { provider: true } } } })
    : null;
  const provider = refund ? (refund.payment.provider === "VNPAY" ? "VNPay" : "MoMo") : "";

  switch (notification.kind) {
    case NotificationKind.OPERATIONS_ALERT:
    case NotificationKind.LOYALTY_UPDATED:
    case NotificationKind.PROMOTION:
      return { email: operatorId ? (await tx.operatorAccount.findFirst({ where: { operatorId, role: OperatorRole.OPERATOR_OWNER, status: AccountStatus.ACTIVE }, orderBy: { createdAt: "asc" }, select: { contactEmail: true } }))?.contactEmail ?? null : null, content: { kind: notification.kind, title: String(payload.title ?? "Vé Xe Nhanh"), message: String(payload.message ?? "Có cập nhật mới.") } };
    case NotificationKind.BOOKING_CONFIRMED:
      return booking && snapshot
        ? {
            email: booking.contactEmail,
            content: {
              kind: "BOOKING_CONFIRMED",
              bookingCode: booking.bookingCode,
              routeName: snapshot.trip.routeName,
              departureAt: snapshot.trip.departureAt,
              pickupName: snapshot.pickup.name,
              dropoffName: snapshot.dropoff.name,
              tickets: booking.tickets.filter((ticket) => ticket.status === TicketStatus.VALID).map(({ ticketCode, seatCode }) => ({ ticketCode, seatCode })),
              total: vndToJson(booking.total),
            },
          }
        : { email: booking?.contactEmail ?? null, content: null };
    case NotificationKind.TICKETS_CANCELLED:
      return {
        email: booking?.contactEmail ?? null,
        content: booking
          ? { kind: "TICKETS_CANCELLED", bookingCode: booking.bookingCode, ticketCodes: (payload.ticketCodes as string[]) ?? [], refundAmount: Number(payload.refundAmount ?? 0) }
          : null,
      };
    case NotificationKind.REFUND_SUCCEEDED:
      return {
        email: booking?.contactEmail ?? null,
        content: booking && refund ? { kind: "REFUND_SUCCEEDED", bookingCode: booking.bookingCode, refundCode: refund.refundCode, amount: vndToJson(refund.amount), provider } : null,
      };
    case NotificationKind.TRIP_CHANGED:
      return {
        email: booking?.contactEmail ?? null,
        content:
          booking && snapshot && change
            ? {
                kind: "TRIP_CHANGED",
                bookingCode: booking.bookingCode,
                routeName: snapshot.trip.routeName,
                before: change.before as TripScheduleSnapshot,
                after: change.after as TripScheduleSnapshot,
                reason: change.reason,
              }
            : null,
      };
    case NotificationKind.TRIP_CANCELLED:
      return {
        email: booking?.contactEmail ?? null,
        content:
          booking && snapshot && change
            ? {
                kind: "TRIP_CANCELLED",
                bookingCode: booking.bookingCode,
                routeName: snapshot.trip.routeName,
                departureAt: (change.before as TripScheduleSnapshot).departureAt,
                reason: change.reason,
                refundAmount: payload.refundAmount === null || payload.refundAmount === undefined ? null : Number(payload.refundAmount),
              }
            : null,
      };
    case NotificationKind.CASE_UPDATED: {
      // Khiếu nại / tranh chấp (TASK-TRUST-001): báo khách theo email liên hệ của đơn, hoặc chủ nhà xe.
      const operatorAudience = payload.audience === "OPERATOR";
      const owner = operatorAudience && operatorId
        ? await tx.operatorAccount.findFirst({
            where: { operatorId, role: OperatorRole.OPERATOR_OWNER, status: AccountStatus.ACTIVE, contactEmail: { not: null } },
            orderBy: { createdAt: "asc" },
            select: { contactEmail: true },
          })
        : null;
      return {
        email: operatorAudience ? (owner?.contactEmail ?? null) : (booking?.contactEmail ?? null),
        content: booking
          ? {
              kind: "CASE_UPDATED",
              audience: operatorAudience ? "OPERATOR" : "CUSTOMER",
              bookingCode: booking.bookingCode,
              caseCode: String(payload.caseCode ?? ""),
              title: String(payload.title ?? ""),
              message: String(payload.message ?? ""),
            }
          : null,
      };
    }
    case NotificationKind.MANUAL_REFUND: {
      if (!operatorId) return { email: null, content: null };
      const owner = await tx.operatorAccount.findFirst({
        where: { operatorId, role: OperatorRole.OPERATOR_OWNER, status: AccountStatus.ACTIVE, contactEmail: { not: null } },
        orderBy: { createdAt: "asc" },
        select: { contactEmail: true, operator: { select: { displayName: true } } },
      });
      return {
        email: owner?.contactEmail ?? null,
        content:
          owner && booking && refund
            ? {
                kind: "MANUAL_REFUND",
                operatorName: owner.operator.displayName,
                bookingCode: booking.bookingCode,
                refundCode: refund.refundCode,
                amount: vndToJson(refund.amount),
                reference: String(payload.reference ?? ""),
                reason: String(payload.reason ?? ""),
              }
            : null,
      };
    }
  }
}

/** Nhật ký gửi vào Mongo `system_log` (DB §4) — không chứa địa chỉ email. Mongo lỗi không làm hỏng việc gửi. */
async function systemLog(audit: Pick<AuditService, "recordSystemLog"> | null, outcome: DeliveryOutcome, kind: NotificationKind, deliveryId: string, error: string | null) {
  if (!audit) {
    return;
  }
  try {
    await audit.recordSystemLog({
      level: outcome === "FAILED" ? "error" : outcome === "SKIPPED" ? "warn" : "info",
      source: "notification",
      event: `notification.${outcome.toLowerCase()}`,
      message: `Thông báo ${kind} qua email: ${outcome}.`,
      context: { deliveryId, kind, channel: "EMAIL", ...(error ? { error } : {}) },
    });
  } catch (failure) {
    logger.warn({ event: "notification.system_log_failed", deliveryId, error: failure instanceof Error ? failure.message : String(failure) });
  }
}
