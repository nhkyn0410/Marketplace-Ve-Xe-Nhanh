import { randomUUID } from "node:crypto";
import { HttpException, HttpStatus, Inject, Injectable, Logger } from "@nestjs/common";
import type { CounterBooking, CounterBookingInput, CounterHold, CounterHoldInput, CounterReceiptInput, CounterReceiptResult, CounterReport, CounterTrip, CounterTripsQuery } from "@vexenhanh/types";
import type Redis from "ioredis";
import { AuditService } from "../audit/audit.service";
import { recordCounterCommission, resolveCounterCommission, type CounterCommissionSnapshot } from "../commission/counter-commission";
import { PrismaService, type DbTransaction } from "../database/prisma.service";
import { loadSegmentOffers } from "../database/segment-offers";
import { resolveSeatPrice } from "../fare/fare-pricing";
import { coveringOffer, segmentSeatPrice } from "../fare/segment-pricing";
import type { VerifiedAccessToken } from "../iam/auth/token.service";
import { can } from "../iam/role/access-policy";
import type { Authorization } from "../iam/role/authorization";
import { permissionDenied } from "../iam/role/authorization.errors";
import type { Permission } from "../iam/role/permissions";
import { requireTenant } from "../iam/role/require-tenant";
import { requireCounterOffice } from "../operator/sales-office-access";
import { REDIS_CLIENT } from "../redis/redis.config";
import { acquireHold, heldSeatCodes, readHold, releaseHold, stillHeld, type HoldRecord } from "../seat-hold/seat-hold-store";
import { holdUnavailable, seatHoldConflict, seatHoldExpired, seatNotAvailable, stopsInvalid } from "../seat-hold/seat-hold.errors";
import { issueTickets } from "../ticket/ticket-issuer";
import { TICKET_QR, type TicketQrSigner } from "../ticket/ticket-qr";
import { BookingService } from "./booking.service";
import { expireBooking } from "./booking-expiry";
import { counterError } from "./counter-sales.errors";

type Actor = Pick<VerifiedAccessToken, "sub" | "role" | "perms">;
const HOLD_MS = 10 * 60_000;
const OPEN = ["OPEN_FOR_SALE", "BOARDING"] as const;
const TRIP_SELECT = {
  id: true, status: true, departedAt: true, departureAt: true, arrivalAt: true, routeId: true,
  operator: { select: { status: true } }, route: { select: { name: true } },
  vehicle: { select: { plateNumber: true, vehicleTypeId: true } },
  stops: { orderBy: { sequence: "asc" }, select: { sequence: true, plannedAt: true, allowPickup: true, allowDropoff: true, catalogStopPoint: { select: { name: true } }, stopPoint: { select: { name: true } } } },
  seats: { orderBy: { seatCode: "asc" }, select: { seatCode: true, type: true, status: true } },
} as const;

/** Bán vé tại văn phòng, dùng chung khóa ghế và lõi vé với online nhưng nhà xe trực tiếp thu tiền. */
@Injectable()
export class CounterSalesService {
  private readonly logger = new Logger(CounterSalesService.name);

  constructor(
    @Inject(PrismaService) private readonly prisma: PrismaService,
    @Inject(REDIS_CLIENT) private readonly redis: Redis,
    @Inject(BookingService) private readonly bookings: BookingService,
    @Inject(TICKET_QR) private readonly qr: TicketQrSigner,
    @Inject(AuditService) private readonly audit: AuditService,
  ) {}

  /** Tìm chuyến còn bán quầy trong ngày đã chọn, kể cả quá giờ khởi hành dự kiến. */
  async trips(actor: Actor, authz: Authorization, query: CounterTripsQuery): Promise<{ items: CounterTrip[] }> {
    const { db, operatorId } = access(actor, authz, "counter:sell");
    return this.prisma.withScope(db, async (tx) => {
      await requireCounterOffice(tx, operatorId, actor, query.officeId);
      const from = new Date(`${query.date}T00:00:00+07:00`);
      const to = new Date(from.getTime() + 86_400_000);
      const rows = await tx.trip.findMany({ where: { operatorId, status: { in: [...OPEN] }, departedAt: null, departureAt: { gte: from, lt: to }, operator: { status: "ACTIVE" }, vehicleId: { not: null } }, orderBy: [{ departureAt: "asc" }, { id: "asc" }], take: 100, select: TRIP_SELECT });
      const items: CounterTrip[] = [];
      for (const trip of rows) {
        const rules = await fareRules(tx, operatorId, trip.routeId);
        const held = await this.redisCall(() => heldSeatCodes(this.redis, trip.id, trip.seats.map((seat) => seat.seatCode)));
        items.push({
          tripId: trip.id, routeName: trip.route.name, departureAt: trip.departureAt.toISOString(), arrivalAt: trip.arrivalAt.toISOString(), status: trip.status as CounterTrip["status"], vehiclePlateNumber: trip.vehicle?.plateNumber ?? null,
          stops: trip.stops.map((stop) => ({ sequence: stop.sequence, name: (stop.catalogStopPoint ?? stop.stopPoint)?.name ?? "", plannedAt: stop.plannedAt.toISOString(), allowPickup: stop.allowPickup, allowDropoff: stop.allowDropoff })),
          seats: trip.seats.map((seat) => ({ code: seat.seatCode, type: seat.type, status: seat.status === "AVAILABLE" && held.has(seat.seatCode) ? "HOLDING" : seat.status, price: trip.vehicle ? resolveSeatPrice(rules, trip.vehicle.vehicleTypeId, seat.type, trip.departureAt)?.toString() ?? null : null })),
        });
      }
      return { items };
    });
  }

  /** Giữ chung kho ghế trong mười phút, gắn người bán và văn phòng từ phiên được xác thực. */
  async hold(actor: Actor, authz: Authorization, input: CounterHoldInput): Promise<CounterHold> {
    const { db, operatorId } = access(actor, authz, "counter:sell");
    let acquired: HoldRecord | null = null;
    try {
      return await this.prisma.withScope(db, async (tx) => {
        await lockTrip(tx, operatorId, input.tripId);
        await requireCounterOffice(tx, operatorId, actor, input.officeId);
        const trip = await tx.trip.findFirst({ where: { id: input.tripId, operatorId }, select: TRIP_SELECT });
        if (!trip?.vehicle || trip.departedAt || !OPEN.includes(trip.status as typeof OPEN[number]) || trip.operator.status !== "ACTIVE") throw counterError("COUNTER_TRIP_CLOSED", "Chuyến không còn bán vé tại quầy.");
        const pickup = trip.stops.find((stop) => stop.sequence === input.pickupSequence);
        const dropoff = trip.stops.find((stop) => stop.sequence === input.dropoffSequence);
        if (!pickup?.allowPickup || !dropoff?.allowDropoff || pickup.sequence >= dropoff.sequence) throw stopsInvalid();
        const rules = await fareRules(tx, operatorId, trip.routeId);
        // Giá theo chặng (3.3): tuyến con ngắn nhất bao trọn chặng, không có thì giá tuyến chính.
        const offer = coveringOffer((await loadSegmentOffers(tx, [trip.id])).get(trip.id) ?? [], pickup.sequence, dropoff.sequence);
        const seats = input.seatCodes.map((code) => {
          const seat = trip.seats.find((item) => item.seatCode === code);
          return { code, type: seat?.type, status: seat?.status, price: seat ? segmentSeatPrice(offer, rules, trip.vehicle!.vehicleTypeId, seat.type, trip.departureAt) : null };
        });
        const bad = seats.filter((seat) => seat.status !== "AVAILABLE" || seat.price === null || seat.price <= 0n);
        if (bad.length) throw seatNotAvailable(bad.map((seat) => seat.code));
        const now = new Date();
        const point = (stop: NonNullable<typeof pickup>) => ({ sequence: stop.sequence, name: (stop.catalogStopPoint ?? stop.stopPoint)?.name ?? "", plannedAt: stop.plannedAt.toISOString() });
        const record: HoldRecord = { holdId: randomUUID(), tripId: trip.id, seatCodes: input.seatCodes, userId: null, counter: { operatorId, officeId: input.officeId, actor: actorKey(actor) }, pickup: point(pickup), dropoff: point(dropoff), seats: seats.map((seat) => ({ code: seat.code, type: seat.type!, price: seat.price!.toString() })), subtotal: seats.reduce((sum, seat) => sum + seat.price!, 0n).toString(), createdAt: now.toISOString(), expiresAt: new Date(now.getTime() + HOLD_MS).toISOString() };
        const conflict = await this.redisCall(() => acquireHold(this.redis, record, HOLD_MS));
        if (conflict) throw seatHoldConflict(conflict);
        acquired = record;
        return presentHold(record);
      });
    } catch (error) {
      if (acquired) await releaseHold(this.redis, acquired).catch(() => undefined);
      throw error;
    }
  }

  /** Đọc phiên giữ ghế của chính người bán, không dùng holdId để truy cập phiên của nhân viên khác. */
  async getHold(actor: Actor, authz: Authorization, holdId: string): Promise<CounterHold> {
    const { db, operatorId } = access(actor, authz, "counter:sell");
    const record = await this.ownedHold(actor, operatorId, holdId);
    await this.prisma.withScope(db, async (tx) => {
      await lockTrip(tx, operatorId, record.tripId);
      await requireCounterOffice(tx, operatorId, actor, record.counter!.officeId);
      const trip = await tx.trip.findFirst({ where: { id: record.tripId, operatorId }, select: { status: true, departedAt: true } });
      if (!trip || trip.departedAt || !OPEN.includes(trip.status as typeof OPEN[number])) throw counterError("COUNTER_TRIP_CLOSED", "Xe đã ngừng bán vé tại quầy.");
    });
    return presentHold(record);
  }

  /** Hủy phiên giữ chỗ của chính người bán; không phát sinh khoản thu. */
  async release(actor: Actor, authz: Authorization, holdId: string): Promise<void> {
    const { db, operatorId } = access(actor, authz, "counter:sell");
    const record = await this.ownedHold(actor, operatorId, holdId);
    await this.prisma.withScope(db, (tx) => requireCounterOffice(tx, operatorId, actor, record.counter!.officeId));
    await this.redisCall(() => releaseHold(this.redis, record));
  }

  /** Tạo đơn quầy từ phiên giữ còn hạn, tính lại giá trong cùng giao dịch khóa chuyến và ghế. */
  async create(actor: Actor, authz: Authorization, input: CounterBookingInput): Promise<CounterBooking> {
    const { db, operatorId } = access(actor, authz, "counter:sell");
    // Trả lại chính đơn đã tạo khi trình duyệt gửi lại sau timeout, dù khóa Redis đã được chuyển vào Postgres.
    const existing = await this.prisma.withScope(db, (tx) => tx.booking.findFirst({ where: { operatorId, holdId: input.holdId, channel: "COUNTER", soldBy: actorKey(actor) }, include: { passengers: true } }));
    if (existing) {
      if (!sameBookingInput(existing, input)) throw counterError("COUNTER_BOOKING_KEY_REUSED", "Phiên giữ chỗ đã tạo đơn với dữ liệu khác. Hãy mở lại đơn đã tạo.");
      return this.get(actor, { ...authz, permission: "counter:read" }, existing.id);
    }
    const hold = await this.ownedHold(actor, operatorId, input.holdId);
    const bookingId = await this.prisma.withScope(db, async (tx) => {
      await lockTrip(tx, operatorId, hold.tripId);
      await requireCounterOffice(tx, operatorId, actor, hold.counter!.officeId);
      const duplicate = await tx.booking.findFirst({ where: { operatorId, holdId: hold.holdId }, include: { passengers: true } });
      if (duplicate) {
        if (duplicate.soldBy !== actorKey(actor)) throw seatHoldExpired();
        if (!sameBookingInput(duplicate, input)) throw counterError("COUNTER_BOOKING_KEY_REUSED", "Phiên giữ chỗ đã tạo đơn với dữ liệu khác.");
        return duplicate.id;
      }
      if (new Date(hold.expiresAt) <= new Date() || !(await this.redisCall(() => stillHeld(this.redis, hold)))) throw seatHoldExpired();
      return this.bookings.createAtCounter(tx, operatorId, hold, input, { officeId: hold.counter!.officeId, soldBy: actorKey(actor), sellerLabel: await displayActor(tx, operatorId, actorKey(actor)) });
    });
    await releaseHold(this.redis, hold).catch((error: unknown) => this.logger.warn({ event: "counter.hold_release_failed", holdId: hold.holdId, error }));
    return this.get(actor, { ...authz, permission: "counter:read" }, bookingId);
  }

  /** Danh sách đơn của văn phòng được cấp, bao gồm khoản thu cần xử lý và vé để in lại. */
  async list(actor: Actor, authz: Authorization, query: { officeId: string; cursor?: string; limit: number }) {
    const { db, operatorId } = access(actor, authz, "counter:read");
    return this.prisma.withScope(db, async (tx) => {
      await requireCounterOffice(tx, operatorId, actor, query.officeId, true);
      const rows = await tx.booking.findMany({ where: { operatorId, officeId: query.officeId, channel: "COUNTER" }, orderBy: { id: "desc" }, take: query.limit + 1, ...(query.cursor ? { cursor: { id: query.cursor }, skip: 1 } : {}), select: { id: true } });
      const items: CounterBooking[] = [];
      for (const row of rows.slice(0, query.limit)) items.push(await this.present(tx, operatorId, row.id));
      return { items, nextCursor: rows.length > query.limit ? items.at(-1)!.bookingId : null };
    });
  }

  /** Đọc đơn và QR đã phát trong phạm vi văn phòng; in lại không tạo vé mới. */
  async get(actor: Actor, authz: Authorization, bookingId: string): Promise<CounterBooking> {
    const { db, operatorId } = access(actor, authz, "counter:read");
    return this.prisma.withScope(db, async (tx) => {
      const booking = await this.find(tx, operatorId, bookingId);
      await requireCounterOffice(tx, operatorId, actor, booking.officeId!, true);
      return this.present(tx, operatorId, bookingId);
    });
  }

  /** Đối soát trong ngày theo phương thức và người xác nhận thu, tách riêng ngoại lệ và hoa hồng. */
  async report(actor: Actor, authz: Authorization, query: CounterTripsQuery): Promise<CounterReport> {
    const { db, operatorId } = access(actor, authz, "counter:read");
    return this.prisma.withScope(db, async (tx) => {
      await requireCounterOffice(tx, operatorId, actor, query.officeId, true);
      const from = new Date(`${query.date}T00:00:00+07:00`);
      const to = new Date(from.getTime() + 86_400_000);
      const receipts = await tx.counterReceipt.findMany({ where: { operatorId, officeId: query.officeId, createdAt: { gte: from, lt: to } }, select: { method: true, amount: true, status: true, recordedBy: true, receivable: { select: { amount: true } } } });
      const sums = { cash: 0n, bankTransfer: 0n, exceptions: 0n, commission: 0n };
      const sellers = new Map<string, typeof sums>();
      for (const receipt of receipts) {
        const seller = sellers.get(receipt.recordedBy) ?? { cash: 0n, bankTransfer: 0n, exceptions: 0n, commission: 0n };
        const field = receipt.status === "EXCEPTION" ? "exceptions" : receipt.method === "CASH" ? "cash" : "bankTransfer";
        sums[field] += receipt.amount; seller[field] += receipt.amount;
        sums.commission += receipt.receivable?.amount ?? 0n; seller.commission += receipt.receivable?.amount ?? 0n;
        sellers.set(receipt.recordedBy, seller);
      }
      const amounts = (value: typeof sums) => ({ cash: value.cash.toString(), bankTransfer: value.bankTransfer.toString(), exceptions: value.exceptions.toString(), commission: value.commission.toString() });
      const people = [];
      for (const [seller, value] of sellers) people.push({ seller: await displayActor(tx, operatorId, seller), ...amounts(value) });
      return { ...amounts(sums), receipts: receipts.length, sellers: people };
    });
  }

  /** Ghi tiền đã thực nhận, phát vé chỉ khi đúng số tiền và chuyến chưa khởi hành thực tế. */
  async collect(actor: Actor, authz: Authorization, bookingId: string, input: CounterReceiptInput): Promise<CounterReceiptResult> {
    const { db, operatorId } = access(actor, authz, "counter:collect");
    try {
      const result = await this.prisma.withScope(db, async (tx) => {
        const initial = await this.find(tx, operatorId, bookingId);
        // Khóa chuyến trước đơn/ghế: xếp hàng với driver/dispatch khởi hành và tránh deadlock đổi chuyến.
        await lockTrip(tx, operatorId, initial.tripId);
        await tx.$queryRaw`SELECT id FROM bookings WHERE id = ${bookingId} AND operator_id = ${operatorId} FOR UPDATE`;
        const booking = await this.find(tx, operatorId, bookingId);
        const duplicate = await tx.counterReceipt.findFirst({ where: { operatorId, idempotencyKey: input.idempotencyKey } });
        if (duplicate) {
          await requireCounterOffice(tx, operatorId, actor, booking.officeId!, true);
          if (duplicate.bookingId !== bookingId || duplicate.amount !== BigInt(input.amount) || duplicate.method !== input.method || duplicate.reference !== input.reference) throw counterError("COUNTER_IDEMPOTENCY_CONFLICT", "Mã thao tác đã dùng cho dữ liệu thu tiền khác.");
          return { receiptId: duplicate.id, status: duplicate.status, exceptionReason: duplicate.exceptionReason, created: false };
        }
        await requireCounterOffice(tx, operatorId, actor, booking.officeId!);
        if (input.reference && await tx.counterReceipt.findFirst({ where: { operatorId, reference: input.reference }, select: { id: true } })) throw counterError("COUNTER_TRANSFER_DUPLICATE", "Mã chuyển khoản đã được ghi nhận, hãy kiểm tra giao dịch gốc.");
        const trip = await tx.trip.findFirstOrThrow({ where: { id: booking.tripId, operatorId }, select: { status: true, departedAt: true, operator: { select: { status: true } } } });
        const seats = await tx.$queryRaw<{ status: string }[]>`SELECT status::text AS status FROM trip_seats WHERE booking_id = ${bookingId} AND operator_id = ${operatorId} ORDER BY seat_code FOR UPDATE`;
        const now = new Date();
        let reason = booking.status !== "PENDING_PAYMENT" ? "BOOKING_NOT_PENDING" : booking.counterReceipts.some((receipt) => receipt.status === "EXCEPTION") ? "UNRESOLVED_RECEIPT" : trip.departedAt || !OPEN.includes(trip.status as typeof OPEN[number]) || trip.operator.status !== "ACTIVE" ? "TRIP_CLOSED" : booking.expiresAt <= now ? "BOOKING_EXPIRED" : booking.total !== BigInt(input.amount) ? "AMOUNT_MISMATCH" : seats.length !== booking.passengers.length || seats.some((seat) => seat.status !== "HOLDING") ? "SEATS_UNAVAILABLE" : null;
        let commission: CounterCommissionSnapshot | undefined;
        if (!reason) {
          try { commission = await resolveCounterCommission(tx, operatorId, booking.subtotal, now); }
          catch (error) {
            if (error instanceof HttpException && (error.getResponse() as { code?: string }).code === "COUNTER_COMMISSION_NOT_LOWER") reason = "COMMISSION_CONFIG_INVALID";
            else throw error;
          }
        }
        // Việc đã nhận tiền phải được lưu kể cả không đủ điều kiện phát hành vé.
        const receiptId = randomUUID();
        const recordReceipt = (status: "COMPLETED" | "EXCEPTION", exceptionReason: string | null) => tx.counterReceipt.create({ data: { id: receiptId, operatorId, bookingId, officeId: booking.officeId!, idempotencyKey: input.idempotencyKey, method: input.method, amount: BigInt(input.amount), reference: input.reference, status, exceptionReason, recordedBy: actorKey(actor), receivedAt: now, createdAt: now } });
        let receipt;
        if (!reason) {
          // Tiền đã nhận không mất dấu khi lỗi phát vé: chỉ rollback phần chốt bán rồi lưu khoản thu ngoại lệ.
          await tx.$executeRaw`SAVEPOINT counter_issue`;
          try {
            receipt = await recordReceipt("COMPLETED", null);
            await recordCounterCommission(tx, { operatorId, receiptId, bookingId, basis: booking.subtotal, at: now, snapshot: commission });
            await tx.tripSeat.updateMany({ where: { operatorId, bookingId, status: "HOLDING" }, data: { status: "BOOKED" } });
            await tx.booking.updateMany({ where: { id: bookingId, operatorId, status: "PENDING_PAYMENT" }, data: { status: "CONFIRMED", paidAt: now, confirmedAt: now } });
            await tx.bookingStatusHistory.create({ data: { operatorId, bookingId, fromStatus: "PENDING_PAYMENT", toStatus: "CONFIRMED", reason: "Nhà xe xác nhận thu đủ tiền tại quầy.", actor: actorKey(actor), createdAt: now } });
            await issueTickets(tx, operatorId, bookingId, this.qr, now, actorKey(actor));
            await tx.$executeRaw`RELEASE SAVEPOINT counter_issue`;
          } catch (error) {
            await tx.$executeRaw`ROLLBACK TO SAVEPOINT counter_issue`;
            await tx.$executeRaw`RELEASE SAVEPOINT counter_issue`;
            reason = "ISSUANCE_FAILED";
            receipt = await recordReceipt("EXCEPTION", reason);
            this.logger.error({ event: "counter.issuance_failed", bookingId, receiptId, error });
          }
        } else {
          receipt = await recordReceipt("EXCEPTION", reason);
        }
        if (reason && booking.status === "PENDING_PAYMENT" && booking.expiresAt <= now) {
          await expireBooking(tx, operatorId, bookingId, now);
        }
        return { receiptId: receipt.id, status: receipt.status, exceptionReason: receipt.exceptionReason, created: true };
      });
      if (result.created) this.audit.recordAuditEvent({ actorId: actor.sub, actorRole: actor.role, action: "counter.receipt.recorded", targetType: "counter_receipt", targetId: result.receiptId, operatorId, after: { bookingId, status: result.status, amount: input.amount, method: input.method, exceptionReason: result.exceptionReason } }).catch((error: unknown) => this.logger.error({ event: "audit.write_failed", action: "counter.receipt.recorded", error }));
      const { created: _created, ...response } = result;
      // Khoản thu đã commit trước khi dựng QR/response; lỗi hiển thị không được rollback tiền đã nhận.
      try {
        const booking = await this.get(actor, { ...authz, permission: "counter:read" }, bookingId);
        return { ...response, booking };
      } catch (error) {
        this.logger.error({ event: "counter.receipt_response_failed", bookingId, receiptId: result.receiptId, error });
        throw counterError("COUNTER_RECEIPT_UNAVAILABLE", "Khoản thu đã được lưu nhưng chưa tải được kết quả. Giữ nguyên mã thao tác và tải lại đơn trước khi thử lại.", HttpStatus.SERVICE_UNAVAILABLE);
      }
    } catch (error) {
      if ((error as { code?: string })?.code === "P2002") throw counterError("COUNTER_RECEIPT_CONFLICT", "Khoản thu hoặc mã chuyển khoản vừa được ghi nhận. Tải lại đơn để đối chiếu.");
      if (["P2028", "P1001", "P1002", "P1008", "P1017"].includes((error as { code?: string })?.code ?? "")) throw counterError("COUNTER_RECEIPT_UNAVAILABLE", "Chưa xác minh được trạng thái khoản thu. Giữ nguyên mã thao tác và tải lại đơn trước khi thử lại.", HttpStatus.SERVICE_UNAVAILABLE);
      throw error;
    }
  }

  private async ownedHold(actor: Actor, operatorId: string, holdId: string): Promise<HoldRecord> {
    const record = await this.redisCall(() => readHold(this.redis, holdId));
    if (!record?.counter || record.counter.operatorId !== operatorId || record.counter.actor !== actorKey(actor) || new Date(record.expiresAt) <= new Date()) throw seatHoldExpired();
    return record;
  }

  private async find(tx: DbTransaction, operatorId: string, bookingId: string) {
    const row = await tx.booking.findFirst({ where: { id: bookingId, operatorId, channel: "COUNTER" }, include: { passengers: { orderBy: { seatCode: "asc" } }, tickets: { orderBy: { ticketCode: "asc" }, include: { passenger: { select: { fullName: true, companionName: true } } } }, counterReceipts: { orderBy: { createdAt: "asc" } } } });
    if (!row?.officeId) throw counterError("COUNTER_BOOKING_NOT_FOUND", "Không tìm thấy đơn bán quầy.", HttpStatus.NOT_FOUND);
    return row;
  }

  private async present(tx: DbTransaction, operatorId: string, bookingId: string): Promise<CounterBooking> {
    const row = await this.find(tx, operatorId, bookingId);
    const snapshot = row.snapshot as { trip: { routeName: string; departureAt: string; arrivalAt: string }; counterSale?: { sellerLabel: string } };
    return {
      bookingId: row.id, bookingCode: row.bookingCode, officeId: row.officeId!, seller: snapshot.counterSale?.sellerLabel ?? await displayActor(tx, operatorId, row.soldBy!),
      status: row.status, tripId: row.tripId,
      trip: { routeName: snapshot.trip.routeName, departureAt: snapshot.trip.departureAt, arrivalAt: snapshot.trip.arrivalAt },
      contact: { fullName: row.contactName, phone: row.contactPhone, email: row.contactEmail },
      passengers: row.passengers.map((passenger) => ({ seatCode: passenger.seatCode, fullName: passenger.fullName, companionName: passenger.companionName, price: passenger.price.toString() })),
      total: row.total.toString(), expiresAt: row.expiresAt.toISOString(), createdAt: row.createdAt.toISOString(),
      tickets: row.tickets.map((ticket) => ({ ticketId: ticket.id, ticketCode: ticket.ticketCode, seatCode: ticket.seatCode, passengerName: ticket.passenger.fullName, companionName: ticket.passenger.companionName, status: ticket.status, qrToken: this.qr.token(ticket.id) })),
      receipts: row.counterReceipts.map((receipt) => ({ id: receipt.id, method: receipt.method, amount: receipt.amount.toString(), reference: receipt.reference, status: receipt.status, exceptionReason: receipt.exceptionReason, createdAt: receipt.createdAt.toISOString() })),
    };
  }

  private async redisCall<T>(work: () => Promise<T>): Promise<T> {
    try { return await work(); } catch (error) {
      if (error instanceof HttpException) throw error;
      this.logger.error({ event: "counter.redis_failed", error });
      throw holdUnavailable();
    }
  }
}

function access(actor: Actor, authz: Authorization, permission: Permission) {
  if (authz.permission !== permission || !can(actor, permission).allowed) throw permissionDenied();
  return requireTenant(authz);
}

function actorKey(actor: Actor): string { return `${actor.role === "OPERATOR_OWNER" ? "operator" : "employee"}:${actor.sub}`; }

function sameBookingInput(row: { contactName: string; contactPhone: string; contactEmail: string | null; note: string | null; total: bigint; passengers: { seatCode: string; fullName: string; phone: string | null; companionName: string | null }[] }, input: CounterBookingInput): boolean {
  if (row.contactName !== input.contact.fullName || row.contactPhone !== input.contact.phone || row.contactEmail !== (input.contact.email?.toLowerCase() ?? null) || row.note !== input.note || row.total !== BigInt(input.expectedTotal) || row.passengers.length !== input.passengers.length) return false;
  return input.passengers.every((passenger) => row.passengers.some((saved) => saved.seatCode === passenger.seatCode && saved.fullName === passenger.fullName && saved.phone === passenger.phone && saved.companionName === (passenger.companionName ?? null)));
}

async function displayActor(tx: DbTransaction, operatorId: string, key: string): Promise<string> {
  const separator = key.indexOf(":");
  const id = key.slice(separator + 1);
  const row = key.startsWith("employee:")
    ? await tx.employeeAccount.findFirst({ where: { id, operatorId }, select: { username: true } })
    : await tx.operatorAccount.findFirst({ where: { id, operatorId }, select: { username: true } });
  return row?.username ?? key;
}

async function lockTrip(tx: DbTransaction, operatorId: string, tripId: string) {
  const [row] = await tx.$queryRaw<{ id: string }[]>`SELECT id FROM trips WHERE id = ${tripId} AND operator_id = ${operatorId} FOR SHARE`;
  if (!row) throw counterError("COUNTER_TRIP_NOT_FOUND", "Không tìm thấy chuyến.", HttpStatus.NOT_FOUND);
}

async function fareRules(tx: DbTransaction, operatorId: string, routeId: string) {
  return tx.fareRule.findMany({ where: { operatorId, fare: { routeId, status: "ACTIVE" } }, select: { vehicleTypeId: true, seatType: true, validFrom: true, validTo: true, price: true } });
}

function presentHold(record: HoldRecord): CounterHold {
  return { holdId: record.holdId, officeId: record.counter!.officeId, tripId: record.tripId, pickup: record.pickup, dropoff: record.dropoff, seats: record.seats.map((seat) => ({ code: seat.code, type: seat.type as CounterHold["seats"][number]["type"], price: String(seat.price) })), subtotal: String(record.subtotal), expiresAt: record.expiresAt };
}
