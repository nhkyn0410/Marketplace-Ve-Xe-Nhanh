import { InjectQueue } from "@nestjs/bullmq";
import { Inject, Injectable, Logger } from "@nestjs/common";
import type { Queue } from "bullmq";
import { AuditService, AuditWriteError } from "../audit/audit.service";
import { PrismaService, transactionDeadline, type DbTransaction } from "../database/prisma.service";
import {
  BookingStatus,
  CatalogStatus,
  NotificationKind,
  PaymentStatus,
  RefundStatus,
  StopPointStatus,
  StopPointType,
  TicketStatus,
  TripChangeKind,
  TripSeatStatus,
  TripStatus,
} from "../database/prisma.types";
import { vndToJson } from "../fare/fare-pricing";
import type { Authorization } from "../iam/role/authorization";
import { requireTenant } from "../iam/role/require-tenant";
import { NotificationDispatcher } from "../notification/notification-dispatcher";
import { queueNotification } from "../notification/notification-outbox";
import type { TripScheduleSnapshot } from "../notification/notification-templates";
import { QUEUE_NAMES } from "../queue/queue.constants";
import { settleBookingStatus } from "../refund/booking-settlement";
import { newRefundCode } from "../refund/cancellation.service";
import { REFUND_JOB, REFUND_JOB_OPTIONS } from "../refund/refund-processing";
import type { TripChangeInput, TripSales } from "./dto/trip-change.dto";
import type { TripResponse } from "./dto/trip.dto";
import {
  isDeadlock,
  isTransactionExpired,
  isVehicleOverlapViolation,
  tripBusy,
  tripChangeEmpty,
  tripChangeNotAllowed,
  tripHistoryUnavailable,
  tripNotFound,
  tripSeatsUnmappable,
  tripStatusTransitionInvalid,
  tripStopsInvalid,
  vehicleScheduleConflict,
} from "./trip.errors";
import { findDetail, loadRouteStops, lockVehicleSeats, planStopTimes, routeArrival, toResponse, type TripActor } from "./trip.service";
import { releaseRedemption } from "../promotion/promotion-apply";
import { transitionVoucher } from "../promotion/voucher-apply";
import { tripCancellationRefund } from "./trip-cancellation-amount";

const AUDIT_TIMEOUT_MS = 2_000;
/** Chuyến đang bán / tạm khóa bán / hết chỗ — đổi lịch chạy được (nháp sửa thẳng bằng PUT chuyến). */
const CHANGEABLE: readonly TripStatus[] = [TripStatus.OPEN_FOR_SALE, TripStatus.LOCKED, TripStatus.SOLD_OUT];
/** Hủy được: chưa khởi hành. */
const CANCELLABLE: readonly TripStatus[] = [TripStatus.DRAFT, TripStatus.OPEN_FOR_SALE, TripStatus.LOCKED, TripStatus.SOLD_OUT];
const SOLD: readonly TripSeatStatus[] = [TripSeatStatus.BOOKED, TripSeatStatus.CHECKED_IN];
/** Vé còn hiệu lực đi chuyến — bị ảnh hưởng khi đổi / hủy chuyến. */
const LIVE_TICKETS: TicketStatus[] = [TicketStatus.VALID, TicketStatus.CHECKED_IN];
const ACTIVE_WARD = { status: CatalogStatus.ACTIVE, province: { status: CatalogStatus.ACTIVE } } as const;

type SeatRow = { seatCode: string; status: TripSeatStatus; bookingId: string | null; type: string };

/**
 * Đổi / hủy chuyến ĐÃ BÁN VÉ (TASK-TRN-008, FR-OPS-11..12, BR-10/12/20, BF-06, UC-14 A4). Mọi thay đổi: lý do bắt buộc, lịch
 * sử `trip_changes` (trước / sau), audit (lệnh cuối trong transaction — Mongo lỗi → 503, không đổi gì), thông báo bắt buộc cho
 * từng đơn bị ảnh hưởng (ghi cùng transaction, gửi sau commit). Đổi xe phải giữ được mọi chỗ đã bán / đã khóa (cùng mã, cùng
 * loại). Hủy chuyến: dừng bán, hủy đơn chờ thanh toán (callback đến sau → đối soát), hủy vé + hoàn 100% giá vé còn hiệu lực.
 */
@Injectable()
export class TripChangeService {
  private readonly logger = new Logger(TripChangeService.name);

  constructor(
    @Inject(PrismaService) private readonly prisma: PrismaService,
    @Inject(AuditService) private readonly audit: AuditService,
    @InjectQueue(QUEUE_NAMES.refundProcessing) private readonly refunds: Queue,
    @Inject(NotificationDispatcher) private readonly notifications: NotificationDispatcher,
  ) {}

  /** Tình hình bán + lịch sử đổi / hủy — Operator OS hiện trước khi đổi / hủy chuyến. */
  async sales(authz: Authorization, tripId: string): Promise<TripSales> {
    const { db, operatorId } = requireTenant(authz);
    return this.prisma.withScope(db, async (tx) => {
      const trip = await tx.trip.findFirst({ where: { id: tripId, operatorId }, select: { id: true } });
      if (!trip) {
        throw tripNotFound();
      }
      const seats = await tx.tripSeat.groupBy({ by: ["status"], where: { tripId, operatorId }, _count: { _all: true } });
      const count = (statuses: readonly TripSeatStatus[]) => seats.filter((row) => statuses.includes(row.status)).reduce((sum, row) => sum + row._count._all, 0);
      const bookings = await tx.booking.findMany({
        where: { tripId, operatorId, tickets: { some: { status: { in: LIVE_TICKETS } } } },
        select: {
          subtotal: true, discount: true,
          tickets: { where: { status: { in: LIVE_TICKETS } }, select: { passenger: { select: { price: true } } } },
          payments: { where: { status: PaymentStatus.SUCCESS }, take: 1, select: { amount: true } },
          refunds: { where: { status: { not: RefundStatus.REJECTED }, payment: { status: { not: PaymentStatus.RECONCILING } } }, select: { amount: true } },
        },
      });
      const pendingBookings = await tx.booking.count({ where: { tripId, operatorId, status: BookingStatus.PENDING_PAYMENT } });
      const changes = await tx.tripChange.findMany({
        where: { tripId, operatorId },
        orderBy: { createdAt: "desc" },
        select: { id: true, kinds: true, before: true, after: true, reason: true, affectedBookings: true, actor: true, createdAt: true },
      });
      const accountIds = [...new Set(changes.flatMap((change) => (change.actor.startsWith("operator:") ? [change.actor.slice("operator:".length)] : [])))];
      const accounts = accountIds.length > 0 ? await tx.operatorAccount.findMany({ where: { id: { in: accountIds }, operatorId }, select: { id: true, username: true } }) : [];
      return {
        soldSeats: count(SOLD),
        holdingSeats: count([TripSeatStatus.HOLDING]),
        activeBookings: bookings.length,
        pendingBookings,
        refundOnCancel: vndToJson(bookings.reduce((sum, booking) => sum + tripCancellationRefund(booking.tickets.map((ticket) => ticket.passenger.price), booking.subtotal, booking.discount, booking.payments[0]?.amount ?? 0n, booking.refunds.reduce((total, refund) => total + refund.amount, 0n)), 0n)),
        changes: changes.map((change) => ({
          ...change,
          before: change.before as TripScheduleSnapshot,
          after: change.after as TripScheduleSnapshot,
          actor: accounts.find((account) => `operator:${account.id}` === change.actor)?.username ?? null,
          createdAt: change.createdAt.toISOString(),
        })),
      };
    });
  }

  /** Đổi giờ / xe / điểm đón trả của chuyến đang bán (có hoặc chưa có vé) — BR-10, BR-20. */
  async change(actor: TripActor, authz: Authorization, tripId: string, input: TripChangeInput): Promise<TripResponse> {
    const { db, operatorId } = requireTenant(authz);
    const result = await this.guard(() =>
      this.prisma.withScope(db, async (tx) => {
        const deadline = transactionDeadline(Date.now());
        const [current] = await tx.$queryRaw<{ status: TripStatus; routeId: string; vehicleId: string | null }[]>`
          SELECT status::text AS "status", route_id AS "routeId", vehicle_id AS "vehicleId" FROM trips
          WHERE id = ${tripId} AND operator_id = ${operatorId}
          FOR NO KEY UPDATE`;
        if (!current) {
          throw tripNotFound();
        }
        if (!CHANGEABLE.includes(current.status)) {
          throw tripChangeNotAllowed("Chỉ đổi được chuyến đang bán, tạm khóa bán hoặc hết chỗ. Chuyến nháp sửa trực tiếp.");
        }
        const seats = await lockSeats(tx, operatorId, tripId);
        if (seats.some((seat) => seat.status === TripSeatStatus.HOLDING)) {
          throw tripChangeNotAllowed("Có khách đang thanh toán vé của chuyến — thử lại sau khi hết hạn thanh toán.");
        }
        const detail = (await findDetail(tx, operatorId, tripId))!;
        const before = snapshotOf(detail);

        // Điểm dừng: giữ đủ các thứ tự dừng; điểm mới phải đang hoạt động, trạm dừng nghỉ chỉ ở thứ tự không đón / trả.
        const sequences = detail.stops.map((stop) => stop.sequence).sort((a, b) => a - b);
        const sent = input.stops.map((stop) => stop.sequence).sort((a, b) => a - b);
        if (sequences.length !== sent.length || sequences.some((sequence, index) => sequence !== sent[index])) {
          throw tripStopsInvalid();
        }
        const changedStops = input.stops.filter((stop) => {
          const old = detail.stops.find((item) => item.sequence === stop.sequence)!;
          return old.catalogStopPointId !== stop.catalogStopPointId || old.stopPointId !== stop.stopPointId;
        });
        await assertStopPointsUsable(tx, operatorId, changedStops, detail.stops);

        // Giờ: giờ đến = giờ đi mới + thời gian chạy của tuyến (dời theo giờ đi); giờ từng điểm chia lại theo chặng của
        // tuyến khi không gửi.
        const routeStops = await loadRouteStops(tx, operatorId, current.routeId, true);
        const arrivalAt = routeArrival(input.departureAt, routeStops);
        const stopTimes = planStopTimes(input, routeStops, arrivalAt);
        const scheduleChanged =
          detail.departureAt.getTime() !== input.departureAt.getTime() ||
          detail.arrivalAt.getTime() !== arrivalAt.getTime() ||
          detail.stops.some((stop, index) => stop.plannedAt.getTime() !== stopTimes[index]!.getTime());
        const vehicleChanged = input.vehicleId !== current.vehicleId;
        if (!scheduleChanged && !vehicleChanged && changedStops.length === 0) {
          throw tripChangeEmpty();
        }

        // BR-20: chỗ đã bán / đang khóa phải có trên xe mới, cùng mã + cùng loại.
        let newSeats: Awaited<ReturnType<typeof lockVehicleSeats>> = [];
        if (vehicleChanged) {
          newSeats = await lockVehicleSeats(tx, operatorId, input.vehicleId);
          const kept = seats.filter((seat) => SOLD.includes(seat.status) || seat.status === TripSeatStatus.BLOCKED);
          const missing = kept.filter((seat) => !newSeats.some((next) => next.code === seat.seatCode && next.type === seat.type)).map((seat) => seat.seatCode);
          if (missing.length > 0) {
            throw tripSeatsUnmappable(missing);
          }
        }

        await tx.trip.updateMany({
          where: { id: tripId, operatorId, status: current.status },
          data: { departureAt: input.departureAt, arrivalAt, vehicleId: input.vehicleId },
        });
        for (const [index, stop] of detail.stops.entries()) {
          const replacement = changedStops.find((item) => item.sequence === stop.sequence);
          await tx.tripStop.updateMany({
            where: { tripId, operatorId, sequence: stop.sequence },
            data: {
              plannedAt: stopTimes[index]!,
              ...(replacement ? { catalogStopPointId: replacement.catalogStopPointId, stopPointId: replacement.stopPointId } : {}),
            },
          });
        }
        if (vehicleChanged) {
          // Sinh lại ghế theo sơ đồ xe mới; chỗ đã bán / đang khóa giữ trạng thái + booking theo mã chỗ.
          const byCode = new Map(seats.map((seat) => [seat.seatCode, seat]));
          await tx.tripSeat.deleteMany({ where: { tripId, operatorId } });
          await tx.tripSeat.createMany({
            data: newSeats.map(({ code, deck, row, column, type }) => {
              const old = byCode.get(code);
              const keep = old && (SOLD.includes(old.status) || old.status === TripSeatStatus.BLOCKED);
              return { operatorId, tripId, seatCode: code, deck, row, column, type, status: keep ? old.status : TripSeatStatus.AVAILABLE, bookingId: keep ? old.bookingId : null };
            }),
          });
        }

        const updated = (await findDetail(tx, operatorId, tripId))!;
        const after = snapshotOf(updated);
        const kinds = [
          ...(scheduleChanged ? [TripChangeKind.SCHEDULE] : []),
          ...(vehicleChanged ? [TripChangeKind.VEHICLE] : []),
          ...(changedStops.length > 0 ? [TripChangeKind.STOP] : []),
        ];
        // Đổi chỉ điểm dừng: chỉ báo đơn đón / trả ở các điểm đó; đổi giờ / xe: báo mọi đơn còn vé.
        const changedSequences = changedStops.map((stop) => stop.sequence);
        const bookings = await liveBookings(tx, operatorId, tripId);
        const affected = scheduleChanged || vehicleChanged ? bookings : bookings.filter((booking) => changedSequences.includes(booking.pickupSequence) || changedSequences.includes(booking.dropoffSequence));
        const change = await tx.tripChange.create({
          data: { operatorId, tripId, kinds, before, after, reason: input.reason, affectedBookings: affected.length, actor: `operator:${actor.sub}` },
          select: { id: true },
        });
        const keys: string[] = [];
        for (const booking of affected) {
          const dedupKey = `TRIP_CHANGED:${change.id}:${booking.id}`;
          keys.push(dedupKey);
          await queueNotification(tx, operatorId, { kind: NotificationKind.TRIP_CHANGED, dedupKey, recipientEmail: booking.contactEmail, bookingId: booking.id, tripId, tripChangeId: change.id });
        }
        await this.audit.recordAuditEvent(
          { actorId: actor.sub, actorRole: actor.role, action: "trip.sold_change", targetType: "trip", targetId: tripId, operatorId, before, after: { ...after, kinds, affectedBookings: affected.length }, reason: input.reason },
          { timeoutMs: AUDIT_TIMEOUT_MS, deadline },
        );
        return { row: updated, keys };
      }),
    );
    await this.notifications.dispatch(result.keys);
    return toResponse(result.row);
  }

  /**
   * Hủy chuyến (BR-12, FR-OPS-10): dừng bán ngay. Có đơn → hủy đơn chờ thanh toán (payment đang mở hủy theo), hủy vé còn hiệu
   * lực + hoàn 100% giá vé (refund `APPROVED`, worker hoàn qua cổng), lịch sử + thông báo từng đơn. Chưa có đơn → như đổi trạng
   * thái thường.
   */
  async cancel(actor: TripActor, authz: Authorization, tripId: string, reason: string): Promise<TripResponse> {
    const { db, operatorId } = requireTenant(authz);
    const by = `operator:${actor.sub}`;
    const result = await this.guard(() =>
      this.prisma.withScope(db, async (tx) => {
        const deadline = transactionDeadline(Date.now());
        const now = new Date();
        const [current] = await tx.$queryRaw<{ status: TripStatus }[]>`
          SELECT status::text AS "status" FROM trips WHERE id = ${tripId} AND operator_id = ${operatorId} FOR NO KEY UPDATE`;
        if (!current) {
          throw tripNotFound();
        }
        if (!CANCELLABLE.includes(current.status)) {
          throw tripStatusTransitionInvalid(`Không hủy được chuyến đang ở trạng thái ${current.status}.`);
        }
        if (await tx.booking.findFirst({ where: { operatorId, tripId, channel: "COUNTER", status: { in: [BookingStatus.CONFIRMED, BookingStatus.PAID, BookingStatus.PARTIALLY_CANCELLED] } }, select: { id: true } })) {
          throw tripChangeNotAllowed("Chuyến có vé quầy do nhà xe trực tiếp thu tiền. Cần xử lý hoàn vé quầy trước khi hủy chuyến; chưa tự hoàn qua cổng thanh toán online.");
        }
        const seats = await lockSeats(tx, operatorId, tripId);
        const before = snapshotOf((await findDetail(tx, operatorId, tripId))!);
        await tx.trip.updateMany({ where: { id: tripId, operatorId, status: current.status }, data: { status: TripStatus.CANCELLED, statusReason: reason } });
        const hasSales = seats.some((seat) => SOLD.includes(seat.status) || seat.status === TripSeatStatus.HOLDING);
        const keys: string[] = [];
        const refundIds: string[] = [];
        let affected = 0;
        if (hasSales) {
          const pending = await tx.booking.findMany({ where: { tripId, operatorId, status: BookingStatus.PENDING_PAYMENT }, select: { id: true, contactEmail: true } });
          for (const booking of pending) {
            await cancelPendingBooking(tx, operatorId, booking.id, reason, by, now);
          }
          const live = await liveBookings(tx, operatorId, tripId);
          const refunded = new Map<string, bigint | null>();
          for (const booking of live) {
            await transitionVoucher(tx, operatorId, booking.id, "TRIP_CANCELLED", now);
            const refund = await cancelLiveTickets(tx, operatorId, booking.id, reason, by, now);
            if (refund) {
              refundIds.push(refund.id);
            }
            refunded.set(booking.id, refund?.amount ?? 0n);
          }
          await tx.tripSeat.updateMany({ where: { tripId, operatorId, status: { in: [...SOLD, TripSeatStatus.HOLDING] } }, data: { status: TripSeatStatus.AVAILABLE, bookingId: null } });
          const targets = [...pending.map((booking) => ({ ...booking, refund: null as bigint | null })), ...live.map((booking) => ({ id: booking.id, contactEmail: booking.contactEmail, refund: refunded.get(booking.id) ?? 0n }))];
          affected = targets.length;
          const change = await tx.tripChange.create({
            data: { operatorId, tripId, kinds: [TripChangeKind.CANCEL], before, after: before, reason, affectedBookings: affected, actor: by },
            select: { id: true },
          });
          for (const target of targets) {
            const dedupKey = `TRIP_CANCELLED:${change.id}:${target.id}`;
            keys.push(dedupKey);
            await queueNotification(tx, operatorId, {
              kind: NotificationKind.TRIP_CANCELLED,
              dedupKey,
              recipientEmail: target.contactEmail,
              bookingId: target.id,
              tripId,
              tripChangeId: change.id,
              payload: { refundAmount: target.refund === null ? null : Number(target.refund) },
            });
          }
        }
        const row = (await findDetail(tx, operatorId, tripId))!;
        await this.audit.recordAuditEvent(
          {
            actorId: actor.sub,
            actorRole: actor.role,
            action: "trip.status.change",
            targetType: "trip",
            targetId: tripId,
            operatorId,
            before: { status: current.status },
            after: { status: TripStatus.CANCELLED, affectedBookings: affected, refunds: refundIds.length },
            reason,
          },
          { timeoutMs: AUDIT_TIMEOUT_MS, deadline },
        );
        return { row, keys, refundIds };
      }),
    );
    for (const refundId of result.refundIds) {
      await this.refunds.add(REFUND_JOB, { refundId }, { ...REFUND_JOB_OPTIONS, jobId: refundId }).catch((error: unknown) => {
        // Refund vẫn `APPROVED` trong DB — Admin thấy ở màn Hoàn tiền (ADM-002).
        this.logger.error({ event: "refund.enqueue_failed", refundId, error });
      });
    }
    await this.notifications.dispatch(result.keys);
    return toResponse(result.row);
  }

  // Audit lỗi / transaction hết hạn → 503 (không đổi gì); xe trùng lịch (EXCLUDE) / deadlock → 409.
  private async guard<T>(work: () => Promise<T>): Promise<T> {
    try {
      return await work();
    } catch (error) {
      if (error instanceof AuditWriteError) {
        throw tripHistoryUnavailable();
      }
      if (isTransactionExpired(error)) {
        throw tripBusy();
      }
      if (isVehicleOverlapViolation(error) || isDeadlock(error)) {
        throw vehicleScheduleConflict();
      }
      throw error;
    }
  }
}

/** Khoá MỌI ghế của chuyến: luồng giữ / bán ghế đang chạy phải chờ (hoặc chạy trước) thao tác đổi / hủy. */
async function lockSeats(tx: DbTransaction, operatorId: string, tripId: string): Promise<SeatRow[]> {
  return tx.$queryRaw<SeatRow[]>`
    SELECT seat_code AS "seatCode", status::text AS "status", booking_id AS "bookingId", type::text AS "type"
    FROM trip_seats WHERE trip_id = ${tripId} AND operator_id = ${operatorId}
    FOR UPDATE`;
}

/** Ảnh chụp lịch chạy (giờ, xe, tên điểm theo thứ tự) cho lịch sử + thông báo. */
function snapshotOf(detail: NonNullable<Awaited<ReturnType<typeof findDetail>>>): TripScheduleSnapshot {
  return {
    departureAt: detail.departureAt.toISOString(),
    arrivalAt: detail.arrivalAt.toISOString(),
    vehiclePlateNumber: detail.vehicle?.plateNumber ?? null,
    stops: detail.stops.map((stop) => ({ sequence: stop.sequence, name: (stop.catalogStopPoint ?? stop.stopPoint)!.name })),
  };
}

/** Đơn của chuyến còn ít nhất một vé hiệu lực. */
function liveBookings(tx: DbTransaction, operatorId: string, tripId: string) {
  return tx.booking.findMany({
    where: { tripId, operatorId, tickets: { some: { status: { in: LIVE_TICKETS } } } },
    orderBy: { createdAt: "asc" },
    select: { id: true, contactEmail: true, pickupSequence: true, dropoffSequence: true },
  });
}

/** Điểm thay thế phải đang hoạt động (catalog / điểm riêng của nhà xe, phường + tỉnh hoạt động); trạm dừng nghỉ chỉ ở thứ tự không đón / trả (BR-79). */
async function assertStopPointsUsable(
  tx: DbTransaction,
  operatorId: string,
  changed: TripChangeInput["stops"],
  current: { sequence: number; allowPickup: boolean; allowDropoff: boolean }[],
): Promise<void> {
  for (const stop of changed) {
    const point = stop.catalogStopPointId
      ? await tx.stopPointCatalog.findFirst({ where: { id: stop.catalogStopPointId, status: CatalogStatus.ACTIVE, ward: ACTIVE_WARD }, select: { type: true } })
      : await tx.stopPoint.findFirst({ where: { id: stop.stopPointId!, operatorId, status: StopPointStatus.ACTIVE, ward: ACTIVE_WARD }, select: { type: true } });
    const slot = current.find((item) => item.sequence === stop.sequence)!;
    if (!point || (point.type === StopPointType.REST_STOP && (slot.allowPickup || slot.allowDropoff))) {
      throw tripStopsInvalid(`Điểm thay cho thứ tự dừng ${stop.sequence} không dùng được (ngừng hoạt động, hoặc trạm dừng nghỉ ở điểm có đón / trả).`);
    }
  }
}

/** Hủy đơn chờ thanh toán của chuyến bị hủy: đơn `CANCELLED`, payment đang mở `CANCELLED`, trả ghế đang giữ. */
async function cancelPendingBooking(tx: DbTransaction, operatorId: string, bookingId: string, reason: string, actor: string, now: Date): Promise<void> {
  const updated = await tx.booking.updateMany({ where: { id: bookingId, operatorId, status: BookingStatus.PENDING_PAYMENT }, data: { status: BookingStatus.CANCELLED, cancelledAt: now } });
  if (updated.count === 0) {
    return;
  }
  // Mã khuyến mãi đang giữ cho đơn → trả lượt dùng (BR-72).
  await releaseRedemption(tx, operatorId, bookingId);
  await tx.bookingStatusHistory.create({
    data: { bookingId, operatorId, fromStatus: BookingStatus.PENDING_PAYMENT, toStatus: BookingStatus.CANCELLED, reason: `Nhà xe hủy chuyến: ${reason}`, actor, createdAt: now },
  });
  const open = await tx.payment.findMany({ where: { bookingId, operatorId, status: { in: [PaymentStatus.INITIATED, PaymentStatus.PROCESSING] } }, select: { id: true, status: true } });
  if (open.length > 0) {
    // Khách vẫn trả ở cổng sau thời điểm này → callback vào đối soát (`BOOKING_CANCELLED`), Admin hoàn tiền.
    await tx.payment.updateMany({ where: { id: { in: open.map((payment) => payment.id) } }, data: { status: PaymentStatus.CANCELLED } });
    await tx.paymentStatusHistory.createMany({
      data: open.map((payment) => ({ paymentId: payment.id, operatorId, fromStatus: payment.status, toStatus: PaymentStatus.CANCELLED, reason: "Nhà xe hủy chuyến.", actor, createdAt: now })),
    });
  }
  await tx.tripSeat.updateMany({ where: { bookingId, operatorId, status: TripSeatStatus.HOLDING }, data: { status: TripSeatStatus.AVAILABLE, bookingId: null } });
}

/**
 * Hủy mọi vé còn hiệu lực của đơn + refund `APPROVED` 100% giá các vé đó (không vượt phần đã trả còn lại sau các lần hoàn
 * trước). Trả refund vừa tạo (`null` khi không có gì để hoàn).
 */
async function cancelLiveTickets(
  tx: DbTransaction,
  operatorId: string,
  bookingId: string,
  reason: string,
  actor: string,
  now: Date,
): Promise<{ id: string; amount: bigint } | null> {
  const tickets = await tx.ticket.findMany({
    where: { bookingId, operatorId, status: { in: LIVE_TICKETS } },
    select: { id: true, status: true, passenger: { select: { price: true } } },
  });
  if (tickets.length === 0) {
    return null;
  }
  const payment = await tx.payment.findFirst({ where: { bookingId, operatorId, status: PaymentStatus.SUCCESS }, select: { id: true, amount: true } });
  const priorRefunds = await tx.refund.aggregate({
    where: { bookingId, operatorId, status: { not: RefundStatus.REJECTED }, payment: { status: { not: PaymentStatus.RECONCILING } } },
    _sum: { amount: true },
  });
  const booking = await tx.booking.findFirstOrThrow({ where: { id: bookingId, operatorId }, select: { subtotal: true, discount: true } });
  const amount = tripCancellationRefund(tickets.map((ticket) => ticket.passenger.price), booking.subtotal, booking.discount, payment?.amount ?? 0n, priorRefunds._sum.amount ?? 0n);
  const refund =
    payment && amount > 0n
      ? await tx.refund.create({
          data: {
            refundCode: newRefundCode(),
            operatorId,
            bookingId,
            paymentId: payment.id,
            status: RefundStatus.APPROVED,
            amount,
            refundPercent: 100,
            reason: `Nhà xe hủy chuyến: ${reason}`,
            requestedBy: actor,
            histories: {
              create: [
                { toStatus: RefundStatus.REQUESTED, reason: `Nhà xe hủy chuyến: ${reason}`, actor, createdAt: now },
                { fromStatus: RefundStatus.REQUESTED, toStatus: RefundStatus.APPROVED, reason: "Hoàn toàn bộ giá vé khi nhà xe hủy chuyến.", actor: "system", createdAt: new Date(now.getTime() + 1) },
              ],
            },
          },
          select: { id: true, amount: true },
        })
      : null;
  for (const ticket of tickets) {
    await tx.ticket.update({ where: { id: ticket.id }, data: { status: TicketStatus.CANCELLED, cancelledAt: now, refundId: refund?.id ?? null } });
    await tx.ticketStatusHistory.create({
      data: { ticketId: ticket.id, operatorId, fromStatus: ticket.status, toStatus: TicketStatus.CANCELLED, reason: `Nhà xe hủy chuyến: ${reason}`, actor, createdAt: now },
    });
  }
  await settleBookingStatus(tx, operatorId, bookingId, actor, `Nhà xe hủy chuyến: ${reason}`, new Date(now.getTime() + 2));
  return refund;
}
