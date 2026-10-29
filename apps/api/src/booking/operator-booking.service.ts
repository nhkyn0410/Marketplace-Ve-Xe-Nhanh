import { Inject, Injectable } from "@nestjs/common";
import { AuditService, AuditWriteError } from "../audit/audit.service";
import { PrismaService } from "../database/prisma.service";
import { type PaymentProvider, type PaymentStatus, TicketStatus } from "../database/prisma.types";
import { vndToJson } from "../fare/fare-pricing";
import type { VerifiedAccessToken } from "../iam/auth/token.service";
import type { Authorization } from "../iam/role/authorization";
import { requireTenant } from "../iam/role/require-tenant";
import { bookingNotFound } from "./booking.errors";
import type {
  BookingContact,
  OperatorBookingDetail,
  OperatorBookingPage,
  OperatorBookingSummary,
  TripPassengerList,
} from "./dto/operator-booking.dto";
import { auditUnavailable, tripNotFound } from "./operator-booking.errors";

const VN_OFFSET_MS = 7 * 3_600_000;
const DAY_MS = 86_400_000;
const AUDIT_TIMEOUT_MS = 2_000;
const AUDIT_TARGET = "booking";
/** Vé còn hiệu lực / đã dùng = chỗ đã bán (vé hủy / hoàn không tính). */
const SOLD: readonly TicketStatus[] = [TicketStatus.VALID, TicketStatus.CHECKED_IN, TicketStatus.NO_SHOW, TicketStatus.USED];

type Snapshot = {
  pickup: OperatorBookingDetail["pickup"];
  dropoff: OperatorBookingDetail["dropoff"];
  cancellationPolicy: OperatorBookingDetail["cancellationPolicy"];
  promotion?: { fundedBy: "OPERATOR" | "PLATFORM" };
};

type ListQuery = { date: string; tripId?: string; status?: OperatorBookingSummary["status"]; q?: string; cursor?: string; limit: number };
type PassengerQuery = { pickupSequence?: number; ticketStatus?: TicketStatus; q?: string };

const SUMMARY_SELECT = {
  id: true,
  bookingCode: true,
  status: true,
  createdAt: true,
  contactName: true,
  contactPhone: true,
  userId: true,
  total: true,
  trip: { select: { id: true, departureAt: true, route: { select: { name: true } }, vehicle: { select: { plateNumber: true } } } },
  passengers: { orderBy: { seatCode: "asc" }, select: { seatCode: true } },
  tickets: { select: { status: true } },
  payments: { orderBy: { createdAt: "desc" }, select: { provider: true, status: true, paidAt: true } },
} as const;

/**
 * Màn Đặt vé của nhà xe (TASK-OPR-003, FR-OPS-14/15, UC-15, AC-20; Figma "Nhà xe · Đặt vé" 01–03 — thiết kế chờ Khanh
 * duyệt): đơn / vé / hành khách thuộc chuyến của chính nhà xe (scope tenant + RLS). Liên hệ che mặc định; xem đầy đủ hoặc
 * xuất danh sách hành khách phải ghi audit được trước (Mongo lỗi → 503, không trả dữ liệu).
 */
@Injectable()
export class OperatorBookingService {
  constructor(
    @Inject(PrismaService) private readonly prisma: PrismaService,
    @Inject(AuditService) private readonly audit: AuditService,
  ) {}

  /** Đơn của các chuyến khởi hành trong ngày (giờ VN), mới đặt trước. */
  async list(authz: Authorization, query: ListQuery): Promise<OperatorBookingPage> {
    const { db, operatorId } = requireTenant(authz);
    const from = new Date(Date.parse(`${query.date}T00:00:00Z`) - VN_OFFSET_MS);
    const to = new Date(from.getTime() + DAY_MS);
    const rows = await this.prisma.withScope(db, async (tx) => {
      let after = {};
      if (query.cursor) {
        const cursor = await tx.booking.findFirst({ where: { id: query.cursor, operatorId }, select: { id: true, createdAt: true } });
        if (!cursor) {
          return [];
        }
        after = { OR: [{ createdAt: { lt: cursor.createdAt } }, { createdAt: cursor.createdAt, id: { lt: cursor.id } }] };
      }
      return tx.booking.findMany({
        where: {
          operatorId,
          tripId: query.tripId,
          status: query.status,
          trip: { departureAt: { gte: from, lt: to } },
          ...searchFilter(query.q),
          ...after,
        },
        orderBy: [{ createdAt: "desc" }, { id: "desc" }],
        take: query.limit + 1,
        select: SUMMARY_SELECT,
      });
    });
    const page = rows.slice(0, query.limit);
    return { items: page.map(toSummary), nextCursor: rows.length > query.limit ? page[page.length - 1]!.id : null };
  }

  async get(authz: Authorization, bookingId: string): Promise<OperatorBookingDetail> {
    const { db, operatorId } = requireTenant(authz);
    const row = await this.prisma.withScope(db, (tx) =>
      tx.booking.findFirst({
        where: { id: bookingId, operatorId },
        select: {
          ...SUMMARY_SELECT,
          contactEmail: true,
          note: true,
          snapshot: true,
          subtotal: true,
          serviceFee: true,
          discount: true,
          passengers: {
            orderBy: { seatCode: "asc" },
            select: { seatCode: true, seatType: true, fullName: true, phone: true, companionName: true, tickets: { select: { ticketCode: true, status: true } } },
          },
          histories: { orderBy: { createdAt: "asc" }, select: { fromStatus: true, toStatus: true, reason: true, actor: true, createdAt: true } },
        },
      }),
    );
    if (!row) {
      throw bookingNotFound();
    }
    const snapshot = row.snapshot as Snapshot;
    return {
      ...toSummary(row),
      contactEmailMasked: row.contactEmail ? maskEmail(row.contactEmail) : null,
      note: row.note,
      pickup: snapshot.pickup,
      dropoff: snapshot.dropoff,
      seats: row.passengers.map((passenger) => ({
        seatCode: passenger.seatCode,
        seatType: passenger.seatType,
        passengerName: passenger.fullName,
        companionName: passenger.companionName,
        phoneMasked: passenger.phone ? maskPhone(passenger.phone) : null,
        ticketCode: passenger.tickets[0]?.ticketCode ?? null,
        ticketStatus: passenger.tickets[0]?.status ?? null,
      })),
      subtotal: vndToJson(row.subtotal),
      serviceFee: vndToJson(row.serviceFee),
      discount: vndToJson(row.discount),
      discountFunding: snapshot.promotion?.fundedBy ?? null,
      cancellationPolicy: snapshot.cancellationPolicy,
      histories: row.histories.map((history) => ({ ...history, actor: actorKind(history.actor), createdAt: history.createdAt.toISOString() })),
    };
  }

  /** Liên hệ đầy đủ của một đơn — ghi audit `booking.contact.reveal` TRƯỚC khi trả (Figma "Hiện đầy đủ"). */
  async revealContact(actor: VerifiedAccessToken, authz: Authorization, bookingId: string): Promise<BookingContact> {
    const { db, operatorId } = requireTenant(authz);
    const row = await this.prisma.withScope(db, (tx) =>
      tx.booking.findFirst({
        where: { id: bookingId, operatorId },
        select: { contactName: true, contactPhone: true, contactEmail: true, passengers: { orderBy: { seatCode: "asc" }, select: { seatCode: true, phone: true } } },
      }),
    );
    if (!row) {
      throw bookingNotFound();
    }
    await this.record(actor, operatorId, "booking.contact.reveal", bookingId, {});
    return { fullName: row.contactName, phone: row.contactPhone, email: row.contactEmail, passengers: row.passengers };
  }

  /** Hành khách đã có vé của một chuyến (theo mã chỗ) + số liệu cả chuyến. */
  async passengers(authz: Authorization, tripId: string, query: PassengerQuery): Promise<TripPassengerList> {
    const { trip, tickets } = await this.loadManifest(authz, tripId);
    const stopName = (sequence: number) => trip.stops.find((stop) => stop.sequence === sequence)?.name ?? `Điểm ${sequence}`;
    const items = tickets
      .map((ticket) => ({
        seatCode: ticket.seatCode,
        passengerName: ticket.passenger.fullName,
        companionName: ticket.passenger.companionName,
        phoneMasked: maskPhone(ticket.passenger.phone ?? ticket.booking.contactPhone),
        phone: ticket.passenger.phone ?? ticket.booking.contactPhone,
        bookingId: ticket.booking.id,
        bookingCode: ticket.booking.bookingCode,
        guest: ticket.booking.userId === null,
        pickup: { sequence: ticket.booking.pickupSequence, name: stopName(ticket.booking.pickupSequence) },
        dropoff: { sequence: ticket.booking.dropoffSequence, name: stopName(ticket.booking.dropoffSequence) },
        ticketCode: ticket.ticketCode,
        ticketStatus: ticket.status,
      }))
      .filter((item) => (query.pickupSequence === undefined || item.pickup.sequence === query.pickupSequence) && (!query.ticketStatus || item.ticketStatus === query.ticketStatus) && matches(item, query.q))
      .map(({ phone: _phone, ...item }) => item);
    const count = (statuses: readonly TicketStatus[]) => tickets.filter((ticket) => statuses.includes(ticket.status)).length;
    return {
      trip: { tripId: trip.id, departureAt: trip.departureAt.toISOString(), routeName: trip.route.name, vehiclePlateNumber: trip.vehicle?.plateNumber ?? null, seatCount: trip._count.seats },
      summary: {
        sold: count(SOLD),
        checkedIn: count([TicketStatus.CHECKED_IN, TicketStatus.USED]),
        notBoarded: count([TicketStatus.VALID]),
        noShow: count([TicketStatus.NO_SHOW]),
      },
      pickups: trip.stops.filter((stop) => stop.allowPickup).map((stop) => ({ sequence: stop.sequence, name: stop.name })),
      items,
    };
  }

  /**
   * Danh sách hành khách của chuyến dạng CSV (UTF-8 có BOM để Excel đọc đúng tiếng Việt) với số điện thoại ĐẦY ĐỦ — cho tài
   * xế / nhân viên liên hệ đón khách (FR-OPS-15). Ghi audit `trip.passengers.export` trước khi trả.
   */
  async exportPassengers(actor: VerifiedAccessToken, authz: Authorization, tripId: string): Promise<{ filename: string; csv: string }> {
    const { operatorId } = requireTenant(authz);
    const { trip, tickets } = await this.loadManifest(authz, tripId);
    const stopName = (sequence: number) => trip.stops.find((stop) => stop.sequence === sequence)?.name ?? `Điểm ${sequence}`;
    const rows = tickets
      .filter((ticket) => SOLD.includes(ticket.status))
      .map((ticket) => [
        ticket.seatCode,
        ticket.passenger.fullName,
        ticket.passenger.phone ?? ticket.booking.contactPhone,
        stopName(ticket.booking.pickupSequence),
        stopName(ticket.booking.dropoffSequence),
        ticket.ticketCode,
        TICKET_LABEL[ticket.status],
      ]);
    await this.record(actor, operatorId, "trip.passengers.export", tripId, { passengers: rows.length });
    const header = ["Chỗ", "Hành khách", "Số điện thoại", "Điểm đón", "Điểm trả", "Mã vé", "Trạng thái vé"];
    const csv = `﻿${[header, ...rows].map((row) => row.map(csvCell).join(",")).join("\r\n")}\r\n`;
    const local = new Date(trip.departureAt.getTime() + VN_OFFSET_MS).toISOString();
    return { filename: `hanh-khach-${local.slice(0, 10)}-${local.slice(11, 16).replace(":", "h")}.csv`, csv };
  }

  private async loadManifest(authz: Authorization, tripId: string) {
    const { db, operatorId } = requireTenant(authz);
    const result = await this.prisma.withScope(db, async (tx) => {
      const trip = await tx.trip.findFirst({
        where: { id: tripId, operatorId },
        select: {
          id: true,
          departureAt: true,
          route: { select: { name: true } },
          vehicle: { select: { plateNumber: true } },
          _count: { select: { seats: true } },
          stops: {
            orderBy: { sequence: "asc" },
            select: { sequence: true, allowPickup: true, catalogStopPoint: { select: { name: true } }, stopPoint: { select: { name: true } } },
          },
        },
      });
      if (!trip) {
        return null;
      }
      const tickets = await tx.ticket.findMany({
        where: { tripId, operatorId },
        orderBy: { seatCode: "asc" },
        select: {
          seatCode: true,
          ticketCode: true,
          status: true,
          passenger: { select: { fullName: true, phone: true, companionName: true } },
          booking: { select: { id: true, bookingCode: true, userId: true, contactPhone: true, pickupSequence: true, dropoffSequence: true } },
        },
      });
      return { trip, tickets };
    });
    if (!result) {
      throw tripNotFound();
    }
    const stops = result.trip.stops.map((stop) => ({
      sequence: stop.sequence,
      allowPickup: stop.allowPickup,
      name: (stop.catalogStopPoint ?? stop.stopPoint)?.name ?? `Điểm ${stop.sequence}`,
    }));
    return { trip: { ...result.trip, stops }, tickets: result.tickets };
  }

  private async record(actor: VerifiedAccessToken, operatorId: string, action: string, targetId: string, after: Record<string, unknown>): Promise<void> {
    try {
      await this.audit.recordAuditEvent(
        { actorId: actor.sub, actorRole: actor.role, action, targetType: action.startsWith("trip.") ? "trip" : AUDIT_TARGET, targetId, operatorId, after },
        { timeoutMs: AUDIT_TIMEOUT_MS },
      );
    } catch (error) {
      if (error instanceof AuditWriteError) {
        throw auditUnavailable();
      }
      throw error;
    }
  }
}

const TICKET_LABEL: Record<TicketStatus, string> = {
  VALID: "Hợp lệ",
  CANCELLED: "Đã hủy",
  CHECKED_IN: "Đã lên xe",
  NO_SHOW: "Vắng mặt",
  USED: "Đã đi",
  REFUNDED: "Đã hoàn",
};

/** `0901234567` → `0*** *** 567` (giữ ký tự đầu + 3 số cuối để đối chiếu qua điện thoại). */
export function maskPhone(phone: string): string {
  return phone.length <= 4 ? "***" : `${phone[0]}*** *** ${phone.slice(-3)}`;
}

/** `khach@gmail.com` → `k***@gmail.com`. */
export function maskEmail(email: string): string {
  const at = email.indexOf("@");
  return at <= 0 ? "***" : `${email[0]}***${email.slice(at)}`;
}

function actorKind(actor: string | null): string {
  if (!actor || actor === "system") return "SYSTEM";
  if (actor === "guest") return "GUEST";
  if (actor.startsWith("user:")) return "PASSENGER";
  if (actor.startsWith("provider:")) return "PROVIDER";
  return "PLATFORM";
}

/** Tìm theo mã đặt vé / mã vé (`VXN…`), số điện thoại (chữ số) hoặc tên người liên hệ. */
function searchFilter(q: string | undefined) {
  if (!q) {
    return {};
  }
  const code = q.toUpperCase().replace(/[\s-]/g, "");
  if (/^VXN[A-Z0-9]*$/.test(code)) {
    const bookingCode = code.slice(0, 9);
    return code.length > 9
      ? { tickets: { some: { ticketCode: { startsWith: `${bookingCode}-${code.slice(9)}` } } } }
      : { bookingCode: { startsWith: bookingCode } };
  }
  const digits = q.replace(/[\s.+-]/g, "");
  if (/^\d{3,}$/.test(digits)) {
    return { contactPhone: { contains: digits.replace(/^84/, "") } };
  }
  return { contactName: { contains: q, mode: "insensitive" as const } };
}

function matches(item: { passengerName: string; ticketCode: string; phone: string }, q: string | undefined): boolean {
  if (!q) {
    return true;
  }
  const digits = q.replace(/[\s.+-]/g, "");
  return (
    item.passengerName.toLowerCase().includes(q.toLowerCase()) ||
    item.ticketCode.replace("-", "").includes(q.toUpperCase().replace(/[\s-]/g, "")) ||
    (/^\d{3,}$/.test(digits) && item.phone.includes(digits))
  );
}

function csvCell(value: string): string {
  // Chặn công thức khi mở bằng Excel (CSV injection) + bọc ngoặc kép.
  const safe = /^[=+\-@\t\r]/.test(value) ? `'${value}` : value;
  return `"${safe.replace(/"/g, '""')}"`;
}

function toSummary(row: {
  id: string;
  bookingCode: string;
  status: OperatorBookingSummary["status"];
  createdAt: Date;
  contactName: string;
  contactPhone: string;
  userId: string | null;
  total: bigint;
  trip: { id: string; departureAt: Date; route: { name: string }; vehicle: { plateNumber: string } | null };
  passengers: { seatCode: string }[];
  tickets: { status: TicketStatus }[];
  payments: { provider: PaymentProvider; status: PaymentStatus; paidAt: Date | null }[];
}): OperatorBookingSummary {
  const payment = row.payments.find((item) => item.status === "SUCCESS") ?? row.payments[0];
  return {
    bookingId: row.id,
    bookingCode: row.bookingCode,
    status: row.status,
    createdAt: row.createdAt.toISOString(),
    contactName: row.contactName,
    contactPhoneMasked: maskPhone(row.contactPhone),
    guest: row.userId === null,
    trip: { tripId: row.trip.id, departureAt: row.trip.departureAt.toISOString(), routeName: row.trip.route.name, vehiclePlateNumber: row.trip.vehicle?.plateNumber ?? null },
    seatCodes: row.passengers.map((passenger) => passenger.seatCode),
    cancelledTicketCount: row.tickets.filter((ticket) => ticket.status === TicketStatus.CANCELLED || ticket.status === TicketStatus.REFUNDED).length,
    total: vndToJson(row.total),
    payment: payment ? { provider: payment.provider, status: payment.status, paidAt: payment.paidAt?.toISOString() ?? null } : null,
  };
}
