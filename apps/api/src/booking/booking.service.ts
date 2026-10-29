import { randomBytes, randomInt } from "node:crypto";
import { HttpException, HttpStatus, Inject, Injectable } from "@nestjs/common";
import { bookingIdOfCode, bookingIdOfHold, guestLookupBookingRows, withBookingOperator, withTripOperator } from "../database/marketplace-scope";
import { PrismaService, type DbTransaction } from "../database/prisma.service";
import { BookingStatus, type PaymentProvider, type PaymentStatus, type RefundStatus, type SeatType, type TicketStatus, type TripChangeKind } from "../database/prisma.types";
import { resolveSeatPrice, vndToJson } from "../fare/fare-pricing";
import type { VerifiedAccessToken } from "../iam/auth/token.service";
import { seatNotAvailable, stopsInvalid } from "../seat-hold/seat-hold.errors";
import type { HoldRecord } from "../seat-hold/seat-hold-store";
import { TICKET_QR, type TicketQrSigner } from "../ticket/ticket-qr";
import { SeatHoldService } from "../seat-hold/seat-hold.service";
import {
  companionNotAllowed,
  bookingNotFound,
  holdAlreadyUsed,
  passengersMismatch,
  snapshotChanged,
  tripNotOnSale,
} from "./booking.errors";
import { ACCESS_GRANT_SELECT, canAccessBooking, hashBookingToken } from "./booking-access";
import { expireBooking } from "./booking-expiry";
import type { BookingInput, BookingResponse, CreatedBooking } from "./dto/booking.dto";
import { claimPromotion } from "../promotion/promotion-apply";
import { evaluateVoucher, reserveVoucher } from "../promotion/voucher-apply";
import { voucherProblem } from "../loyalty/passenger-loyalty.service";
import type { CounterBookingInput } from "@vexenhanh/types";

/** Chỗ đôi được khai người đi cùng (BR-78). */
const DOUBLE_SEATS = new Set<string>(["BED_DOUBLE", "CABIN_DOUBLE"]);
const MINUTE = 60_000;
/** Mã booking `VXN` + 6 ký tự, bỏ 0/O/1/I cho dễ đọc qua điện thoại (32^6 ≈ 1 tỷ mã). */
const CODE_ALPHABET = "23456789ABCDEFGHJKLMNPQRSTUVWXYZ";
const CODE_ATTEMPTS = 3;

type Tier = { minHoursBefore: number; refundPercent: number };
type SnapshotStop = { sequence: number; name: string; address: string; plannedAt: string };

/** Một dòng trong danh sách tra cứu vé theo email (API §7.2 `POST /guest/ticket-lookup/bookings`). */
export type GuestLookupBooking = {
  bookingId: string;
  bookingCode: string;
  status: BookingStatus;
  routeName: string;
  operatorName: string;
  departureAt: string;
  ticketCount: number;
  total: bigint;
  bookedWithAccount: boolean;
  createdAt: Date;
};

/** Dữ liệu bắt buộc chụp lúc đặt (SRS §9.4, LLD §6.2 bước 3) — booking hiển thị / hủy theo bản chụp này. */
type BookingSnapshot = {
  trip: BookingResponse["trip"];
  pickup: SnapshotStop;
  dropoff: SnapshotStop;
  cancellationPolicy: { tiers: Tier[] };
  counterSale?: { soldBy: string; sellerLabel: string; officeId: string };
  /** Mã khuyến mãi đã áp (BR-47) — phần giảm do nhà xe chịu (Khanh 18/10/2026, LLD-OQ-07). */
  promotion?: { code: string; name: string; discount: number; fundedBy: "OPERATOR" | "PLATFORM" };
};

type BookingRow = {
  id: string;
  bookingCode: string;
  status: BookingStatus;
  tripId: string;
  contactName: string;
  contactPhone: string;
  contactEmail: string | null;
  note: string | null;
  subtotal: bigint;
  serviceFee: bigint;
  discount: bigint;
  total: bigint;
  snapshot: unknown;
  expiresAt: Date;
  createdAt: Date;
  passengers: { seatCode: string; seatType: SeatType; fullName: string; phone: string | null; companionName: string | null; price: bigint }[];
  payments: { paymentCode: string; provider: PaymentProvider; status: PaymentStatus; amount: bigint; paidAt: Date | null }[];
  tickets: { id: string; ticketCode: string; seatCode: string; status: TicketStatus; passenger: { fullName: string; companionName: string | null } }[];
  refunds: { refundCode: string; amount: bigint; status: RefundStatus; createdAt: Date }[];
  trip: { changes: { kinds: TripChangeKind[]; before: unknown; after: unknown; reason: string; createdAt: Date }[] };
};

type CoreBookingInput = Omit<BookingInput, "contact" | "expectedTotal"> & {
  contact: { fullName: string; phone: string; email: string | null };
  expectedTotal: number | string;
};
type CounterAttribution = { officeId: string; soldBy: string; sellerLabel: string };

const BOOKING_SELECT = {
  id: true,
  bookingCode: true,
  status: true,
  tripId: true,
  contactName: true,
  contactPhone: true,
  contactEmail: true,
  note: true,
  subtotal: true,
  serviceFee: true,
  discount: true,
  total: true,
  snapshot: true,
  expiresAt: true,
  createdAt: true,
  userId: true,
  accessTokenHash: true,
  accessGrants: ACCESS_GRANT_SELECT,
  passengers: {
    orderBy: { seatCode: "asc" },
    select: { seatCode: true, seatType: true, fullName: true, phone: true, companionName: true, price: true },
  },
  payments: {
    orderBy: { createdAt: "desc" },
    select: { paymentCode: true, provider: true, status: true, amount: true, paidAt: true },
  },
  tickets: {
    orderBy: { ticketCode: "asc" },
    select: { id: true, ticketCode: true, seatCode: true, status: true, passenger: { select: { fullName: true, companionName: true } } },
  },
  refunds: { orderBy: { createdAt: "asc" }, select: { refundCode: true, amount: true, status: true, createdAt: true } },
  trip: { select: { changes: { orderBy: { createdAt: "asc" }, select: { kinds: true, before: true, after: true, reason: true, createdAt: true } } } },
} as const;

/**
 * Tạo + xem booking (TASK-BTP-002, LLD §6.2, FR-BTP-05/06). Booking tạo TỪ phiên giữ chỗ còn hiệu lực của chính người
 * gọi; trong MỘT transaction ở tenant của nhà xe sở hữu chuyến: khoá chuyến `FOR SHARE` (xếp hàng với nhà xe đổi trạng
 * thái chuyến — bàn giao TRN-006) + kiểm lại còn mở bán, khoá các ghế `FOR UPDATE` + kiểm còn `AVAILABLE`, tính lại giá
 * từ bảng giá đang áp dụng (khác số khách đã thấy → 409), rồi ghi booking `PENDING_PAYMENT` + hành khách + lịch sử và
 * chuyển ghế sang `HOLDING`. Xong mới trả khóa Redis — chỗ từ đây do Postgres giữ tới hạn thanh toán (= hạn giữ chỗ).
 * v1: chỉ trả trước (OQ-07), phí dịch vụ 0 nhưng vẫn tách dòng (CO-12); tối đa một mã khuyến mãi hoặc voucher của chính hành khách.
 */
@Injectable()
export class BookingService {
  constructor(
    @Inject(PrismaService) private readonly prisma: PrismaService,
    @Inject(SeatHoldService) private readonly holds: SeatHoldService,
    @Inject(TICKET_QR) private readonly qr: TicketQrSigner,
  ) {}

  async create(user: VerifiedAccessToken | null, input: BookingInput): Promise<CreatedBooking> {
    if (input.userVoucherId && input.promotionCode) throw voucherProblem("VOUCHER_ONE_PER_BOOKING", "Mỗi đơn chỉ áp dụng một voucher hoặc một mã khuyến mãi.", HttpStatus.UNPROCESSABLE_ENTITY);
    const hold = await this.holds.takeForBooking(user, input.holdId);
    const held = new Set(hold.seatCodes);
    if (input.passengers.length !== held.size || input.passengers.some((passenger) => !held.has(passenger.seatCode))) {
      throw passengersMismatch();
    }
    const now = new Date();
    const accessToken = randomBytes(32).toString("base64url");
    let created: BookingResponse | null = null;
    for (let attempt = 1; !created; attempt++) {
      try {
        const row = await this.transaction(() =>
          withTripOperator(this.prisma, hold.tripId, (tx, operatorId) => this.insert(tx, operatorId, user, hold, input, accessToken, now)),
        );
        if (!row) {
          throw tripNotOnSale();
        }
        created = toResponse(row, this.qr);
      } catch (error) {
        if (!isUniqueConflict(error)) {
          throw error;
        }
        // Phiên giữ chỗ đã thành booking (gửi lặp / đồng thời) → 409; còn lại là trùng mã booking ngẫu nhiên → thử mã khác.
        if ((await bookingIdOfHold(this.prisma, hold.holdId)) || attempt >= CODE_ATTEMPTS) {
          throw holdAlreadyUsed();
        }
      }
    }
    await this.holds.releaseConsumed(hold);
    return { ...created, accessToken };
  }

  /** Tạo đơn quầy trong giao dịch tenant đã kiểm văn phòng, tái sử dụng lõi giá và khóa ghế. */
  async createAtCounter(tx: DbTransaction, operatorId: string, hold: HoldRecord, input: CounterBookingInput, attribution: CounterAttribution): Promise<string> {
    const held = new Set(hold.seatCodes);
    if (input.passengers.length !== held.size || input.passengers.some((passenger) => !held.has(passenger.seatCode))) throw passengersMismatch();
    const booking = await this.insert(tx, operatorId, null, hold, { ...input, promotionCode: null, userVoucherId: null }, randomBytes(32).toString("base64url"), new Date(), attribution);
    return booking.id;
  }

  /**
   * Booking của chính hành khách (đăng nhập) hoặc của khách vãng lai có đúng mã truy cập. Không có quyền = không tồn tại.
   * Quá hạn thanh toán mà job nền chưa kịp quét thì chuyển `EXPIRED` ngay (cùng logic job) trước khi trả.
   */
  async get(user: VerifiedAccessToken | null, bookingId: string, accessToken: string | undefined): Promise<BookingResponse> {
    const now = new Date();
    const booking = await this.transaction(() =>
      withBookingOperator(this.prisma, bookingId, async (tx, operatorId) => {
        const row = await tx.booking.findFirst({ where: { id: bookingId, operatorId }, select: BOOKING_SELECT });
        if (!row || !canAccessBooking(row, user, accessToken)) {
          return null;
        }
        if (row.status === BookingStatus.PENDING_PAYMENT && row.expiresAt <= now && (await expireBooking(tx, operatorId, row.id, now))) {
          return { ...row, status: BookingStatus.EXPIRED };
        }
        return row;
      }),
    );
    if (!booking) {
      throw bookingNotFound();
    }
    return toResponse(booking, this.qr);
  }

  /**
   * Tra cứu vé của khách vãng lai, bước gửi mã (API §7.2 `POST /guest/ticket-lookup/otp`, Security §8): id booking khi đúng
   * mã booking VÀ đúng email liên hệ lúc đặt; sai bất kỳ → `null` (nơi gọi vẫn trả phản hồi trung tính).
   */
  async matchGuestContact(bookingCode: string, email: string): Promise<string | null> {
    const bookingId = await bookingIdOfCode(this.prisma, bookingCode);
    if (!bookingId) {
      return null;
    }
    const row = await withBookingOperator(this.prisma, bookingId, (tx, operatorId) =>
      tx.booking.findFirst({ where: { id: bookingId, operatorId }, select: { contactEmail: true } }),
    );
    return row?.contactEmail === email.toLowerCase() ? bookingId : null;
  }

  /**
   * Đơn tra cứu được bằng email liên hệ đã xác minh OTP (mọi nhà xe, gồm cả đơn đặt khi đã đăng nhập — Khanh 27/10/2026):
   * đúng một đơn khi phiên mở bằng mã đặt vé, ngược lại các đơn tạo từ `since`, mới nhất trước.
   */
  async listForGuestLookup(scope: { email: string; bookingId: string | null }, since: Date, limit: number, now = new Date()): Promise<GuestLookupBooking[]> {
    const rows = await guestLookupBookingRows(this.prisma, scope, since, limit);
    return rows.map((row) => {
      const trip = (row.snapshot as BookingSnapshot).trip;
      return {
        bookingId: row.id,
        bookingCode: row.bookingCode,
        // Quá hạn thanh toán mà job nền chưa quét: hiện như đã hết hạn (cùng quy tắc `get`), không ghi ở đường đọc này.
        status: row.status === BookingStatus.PENDING_PAYMENT && row.expiresAt <= now ? BookingStatus.EXPIRED : row.status,
        routeName: trip.routeName,
        operatorName: trip.operatorName,
        departureAt: trip.departureAt,
        ticketCount: row._count.tickets,
        total: row.total,
        bookedWithAccount: row.userId !== null,
        createdAt: row.createdAt,
      };
    });
  }

  /**
   * Mã truy cập phụ cho booking khách vãng lai trong phạm vi phiên tra cứu đã xác minh OTP (hủy vé / khiếu nại — Khanh
   * 27/10/2026). Đơn đặt bằng tài khoản không cấp (`ACCOUNT` — phải đăng nhập); ngoài phạm vi → `NOT_FOUND`. Mã chỉ trả một
   * lần, DB giữ băm; dọn mã đã hết hạn của đơn khi cấp mới.
   */
  async grantLookupAccess(
    bookingId: string,
    match: { email: string; since: Date } | undefined,
    expiresAt: Date,
    now = new Date(),
  ): Promise<{ accessToken: string } | "NOT_FOUND" | "ACCOUNT"> {
    const accessToken = randomBytes(32).toString("base64url");
    const outcome = await withBookingOperator(this.prisma, bookingId, async (tx, operatorId) => {
      const row = await tx.booking.findFirst({
        where: { id: bookingId, operatorId, ...(match ? { contactEmail: match.email.toLowerCase(), createdAt: { gte: match.since } } : {}) },
        select: { userId: true },
      });
      if (!row) {
        return "NOT_FOUND" as const;
      }
      if (row.userId !== null) {
        return "ACCOUNT" as const;
      }
      await tx.bookingAccessGrant.deleteMany({ where: { bookingId, operatorId, expiresAt: { lte: now } } });
      await tx.bookingAccessGrant.create({ data: { bookingId, operatorId, tokenHash: hashBookingToken(accessToken), expiresAt } });
      return { accessToken };
    });
    return outcome ?? "NOT_FOUND";
  }

  /** Booking cho phiên tra cứu đã xác minh OTP (chỉ xem — không cấp mã truy cập booking); `match` giới hạn theo email. */
  async getForLookup(bookingId: string, match?: { email: string; since: Date }): Promise<BookingResponse | null> {
    const row = await withBookingOperator(this.prisma, bookingId, (tx, operatorId) =>
      tx.booking.findFirst({
        where: { id: bookingId, operatorId, ...(match ? { contactEmail: match.email.toLowerCase(), createdAt: { gte: match.since } } : {}) },
        select: BOOKING_SELECT,
      }),
    );
    return row ? toResponse(row, this.qr) : null;
  }

  private async insert(
    tx: DbTransaction,
    operatorId: string,
    user: VerifiedAccessToken | null,
    hold: HoldRecord,
    input: CoreBookingInput,
    accessToken: string,
    now: Date,
    counter?: CounterAttribution,
  ): Promise<BookingRow> {
    const [locked] = await tx.$queryRaw<{ id: string }[]>`
      SELECT id FROM trips WHERE id = ${hold.tripId} AND operator_id = ${operatorId} FOR SHARE`;
    const trip = locked
      ? await tx.trip.findFirst({
          where: { id: hold.tripId, operatorId },
          select: {
            status: true,
            departedAt: true,
            routeId: true,
            departureAt: true,
            arrivalAt: true,
            onlineSaleCutoffMinutes: true,
            operator: { select: { status: true, displayName: true, hotline: true } },
            route: { select: { name: true } },
            vehicle: { select: { vehicleType: { select: { id: true, name: true } } } },
            stops: {
              where: { sequence: { in: [hold.pickup.sequence, hold.dropoff.sequence] } },
              select: {
                sequence: true,
                plannedAt: true,
                allowPickup: true,
                allowDropoff: true,
                catalogStopPoint: { select: { name: true, address: true } },
                stopPoint: { select: { name: true, address: true } },
              },
            },
          },
        })
      : null;
    const saleClosesAt = trip ? trip.departureAt.getTime() - trip.onlineSaleCutoffMinutes * MINUTE : 0;
    const open = counter ? trip && ["OPEN_FOR_SALE", "BOARDING"].includes(trip.status) && trip.departedAt === null : trip?.status === "OPEN_FOR_SALE" && saleClosesAt > now.getTime();
    if (!trip?.vehicle || !open || trip.operator.status !== "ACTIVE") {
      throw tripNotOnSale();
    }
    const pickup = trip.stops.find((stop) => stop.sequence === hold.pickup.sequence);
    const dropoff = trip.stops.find((stop) => stop.sequence === hold.dropoff.sequence);
    if (!pickup?.allowPickup || !dropoff?.allowDropoff) {
      throw stopsInvalid();
    }

    // Khoá ghế theo thứ tự mã (tránh deadlock giữa hai booking chồng chỗ) rồi kiểm còn trống — Redis đã chặn trùng, đây
    // là chốt cuối với thao tác của nhà xe (khoá ghế) hay ghế lệch trạng thái.
    const seats = await tx.$queryRaw<{ seatCode: string; type: SeatType; status: string }[]>`
      SELECT seat_code AS "seatCode", type::text AS "type", status::text AS "status" FROM trip_seats
      WHERE trip_id = ${hold.tripId} AND operator_id = ${operatorId} AND seat_code = ANY(${hold.seatCodes})
      ORDER BY seat_code
      FOR UPDATE`;
    const rules = await tx.fareRule.findMany({
      where: { operatorId, fare: { routeId: trip.routeId, status: "ACTIVE" } },
      select: { vehicleTypeId: true, seatType: true, validFrom: true, validTo: true, price: true },
    });
    const priced = hold.seatCodes.map((code) => {
      const seat = seats.find((row) => row.seatCode === code);
      const price = seat ? resolveSeatPrice(rules, trip.vehicle!.vehicleType.id, seat.type, trip.departureAt) : null;
      return { code, type: seat?.type, status: seat?.status, price };
    });
    const unavailable = priced.filter((seat) => seat.status !== "AVAILABLE" || seat.price === null || seat.price <= 0n);
    if (unavailable.length > 0) {
      // Gửi lặp đồng thời: bên sau chờ khoá ghế tới khi bên trước commit, lúc đó ghế đã thuộc booking của chính phiên này.
      if (await tx.booking.findFirst({ where: { holdId: hold.holdId, operatorId }, select: { id: true } })) {
        throw holdAlreadyUsed();
      }
      throw seatNotAvailable(unavailable.map((seat) => seat.code));
    }
    const notDouble = input.passengers
      .filter((passenger) => passenger.companionName && !DOUBLE_SEATS.has(priced.find((seat) => seat.code === passenger.seatCode)?.type ?? ""))
      .map((passenger) => passenger.seatCode);
    if (notDouble.length > 0) {
      throw companionNotAllowed(notDouble);
    }
    const subtotal = priced.reduce((sum, seat) => sum + seat.price!, 0n);
    const serviceFee = 0n;
    // Giữ một lượt dùng của mã ngay trong transaction này: đơn không tạo được thì rollback trả luôn lượt (TASK-PROM-001).
    const promotion = input.userVoucherId
      ? await evaluateVoucher(tx, user?.sub ?? null, input.userVoucherId, { operatorId, routeId: trip.routeId, tripId: hold.tripId, subtotal, now })
      : input.promotionCode
      ? await claimPromotion(tx, { operatorId, routeId: trip.routeId, tripId: hold.tripId, subtotal, code: input.promotionCode, now })
      : null;
    const discount = promotion?.discount ?? 0n;
    const total = subtotal + serviceFee - discount;
    if (total !== BigInt(input.expectedTotal)) {
      throw snapshotChanged(vndToJson(total));
    }

    const point = (stop: NonNullable<typeof pickup>): SnapshotStop => {
      const place = (stop.catalogStopPoint ?? stop.stopPoint)!;
      return { sequence: stop.sequence, name: place.name, address: place.address, plannedAt: stop.plannedAt.toISOString() };
    };
    // Mốc hủy đang áp dụng: phiên bản riêng của nhà xe, không có thì mặc định nền tảng (như trang chi tiết chuyến). Đọc
    // trong cùng transaction — không mở kết nối thứ hai khi đang giữ khoá.
    const policies = await tx.policyVersion.findMany({
      where: { type: "CANCELLATION", status: "PUBLISHED", effectiveFrom: { lte: now }, OR: [{ operatorId: null }, { operatorId }] },
      orderBy: { effectiveFrom: "desc" },
      select: { operatorId: true, rules: true },
    });
    const policy = policies.find((version) => version.operatorId === operatorId) ?? policies.find((version) => version.operatorId === null);
    const tiers = (policy?.rules as { tiers?: Tier[] } | undefined)?.tiers ?? [];
    const snapshot: BookingSnapshot = {
      trip: {
        routeName: trip.route.name,
        operatorName: trip.operator.displayName,
        operatorHotline: trip.operator.hotline,
        vehicleTypeName: trip.vehicle.vehicleType.name,
        departureAt: trip.departureAt.toISOString(),
        arrivalAt: trip.arrivalAt.toISOString(),
      },
      pickup: point(pickup),
      dropoff: point(dropoff),
      cancellationPolicy: { tiers },
      ...(counter ? { counterSale: { soldBy: counter.soldBy, sellerLabel: counter.sellerLabel, officeId: counter.officeId } } : {}),
      ...(promotion ? { promotion: { code: promotion.code, name: promotion.name, discount: vndToJson(promotion.discount), fundedBy: promotion.fundedBy } } : {}),
    };
    const booking = await tx.booking.create({
      data: {
        bookingCode: newBookingCode(),
        operatorId,
        tripId: hold.tripId,
        ...(counter ? { channel: "COUNTER", officeId: counter.officeId, soldBy: counter.soldBy } : {}),
        userId: user?.sub ?? null,
        holdId: hold.holdId,
        status: BookingStatus.PENDING_PAYMENT,
        contactName: input.contact.fullName,
        contactPhone: input.contact.phone,
        contactEmail: input.contact.email?.toLowerCase() ?? null,
        pickupSequence: pickup.sequence,
        dropoffSequence: dropoff.sequence,
        subtotal,
        serviceFee,
        discount,
        total,
        snapshot,
        note: input.note,
        accessTokenHash: hashBookingToken(accessToken),
        expiresAt: new Date(hold.expiresAt),
        passengers: {
          create: input.passengers.map((passenger) => {
            const seat = priced.find((row) => row.code === passenger.seatCode)!;
            // `operator_id` của dòng con lấy theo booking (FK ghép `booking_id, operator_id`).
            return {
              tripId: hold.tripId,
              seatCode: seat.code,
              seatType: seat.type!,
              price: seat.price!,
              fullName: passenger.fullName,
              phone: passenger.phone,
              companionName: passenger.companionName ?? null,
            };
          }),
        },
        histories: {
          create: { fromStatus: null, toStatus: BookingStatus.PENDING_PAYMENT, actor: counter?.soldBy ?? (user ? `user:${user.sub}` : "guest") },
        },
      },
      select: BOOKING_SELECT,
    });
    await tx.tripSeat.updateMany({
      where: { tripId: hold.tripId, operatorId, seatCode: { in: hold.seatCodes }, status: "AVAILABLE" },
      data: { status: "HOLDING", bookingId: booking.id },
    });
    if (promotion) {
      if (promotion.userVoucherId) await reserveVoucher(tx, promotion.userVoucherId, user!.sub, booking.id, operatorId, now);
      await tx.promotionRedemption.create({
        data: { promotionId: promotion.promotionId, userVoucherId: promotion.userVoucherId ?? null, operatorId, bookingId: booking.id, code: promotion.code, discount: promotion.discount, fundedBy: promotion.fundedBy },
      });
    }
    return booking;
  }

  /** Transaction hết hạn / deadlock khi tranh khoá với thao tác khác → 503, không có gì được ghi; client thử lại. */
  private async transaction<T>(work: () => Promise<T>): Promise<T> {
    try {
      return await work();
    } catch (error) {
      const code = (error as { code?: unknown } | null)?.code;
      const dbCode = (error as { cause?: { originalCode?: unknown } } | null)?.cause?.originalCode;
      if (code === "P2028" || dbCode === "40P01") {
        throw new HttpException(
          { code: "SERVICE_UNAVAILABLE", title: "Booking error", detail: "Hệ thống đang bận. Vui lòng thử lại." },
          HttpStatus.SERVICE_UNAVAILABLE,
        );
      }
      throw error;
    }
  }
}

function newBookingCode(): string {
  let code = "VXN";
  for (let i = 0; i < 6; i++) {
    code += CODE_ALPHABET[randomInt(CODE_ALPHABET.length)];
  }
  return code;
}

function isUniqueConflict(error: unknown): boolean {
  return (error as { code?: unknown } | null)?.code === "P2002";
}

function toResponse(row: BookingRow, qr: TicketQrSigner): BookingResponse {
  const snapshot = row.snapshot as BookingSnapshot;
  // Payment đã thành công nếu có (payment khác của booking bị hủy theo), không thì lần gần nhất.
  const payment = row.payments.find((item) => item.status === "SUCCESS") ?? row.payments[0];
  return {
    bookingId: row.id,
    bookingCode: row.bookingCode,
    status: row.status,
    tripId: row.tripId,
    trip: snapshot.trip,
    pickup: snapshot.pickup,
    dropoff: snapshot.dropoff,
    contact: { fullName: row.contactName, phone: row.contactPhone, email: row.contactEmail ?? "" },
    passengers: row.passengers.map((passenger) => ({ ...passenger, price: vndToJson(passenger.price) })),
    note: row.note,
    subtotal: vndToJson(row.subtotal),
    serviceFee: vndToJson(row.serviceFee),
    discount: vndToJson(row.discount),
    discountFunding: snapshot.promotion?.fundedBy ?? null,
    total: vndToJson(row.total),
    cancellationPolicy: snapshot.cancellationPolicy,
    expiresAt: row.expiresAt.toISOString(),
    payment: payment ? { ...payment, amount: vndToJson(payment.amount), paidAt: payment.paidAt?.toISOString() ?? null } : null,
    tickets: row.tickets.map((ticket) => ({
      ticketId: ticket.id,
      ticketCode: ticket.ticketCode,
      seatCode: ticket.seatCode,
      passengerName: ticket.passenger.fullName,
      companionName: ticket.passenger.companionName,
      status: ticket.status,
      qrToken: qr.token(ticket.id),
    })),
    refunds: row.refunds.map((refund) => ({ ...refund, amount: vndToJson(refund.amount), createdAt: refund.createdAt.toISOString() })),
    tripChanges: row.trip.changes
      .filter((change) => change.createdAt >= row.createdAt)
      .map((change) => ({
        kinds: change.kinds,
        before: change.before as BookingResponse["tripChanges"][number]["before"],
        after: change.after as BookingResponse["tripChanges"][number]["after"],
        reason: change.reason,
        createdAt: change.createdAt.toISOString(),
      })),
    createdAt: row.createdAt.toISOString(),
  };
}
