import { Inject, Injectable } from "@nestjs/common";
import type { PassengerProfile, PassengerProfileUpdate, SavedPassengerInput, SavedPassenger, PassengerPageQuery, PassengerBookingPage, PassengerTicketPage, PassengerSupportPage, PassengerDisputePage } from "@vexenhanh/types";
import { withPassengerData } from "../../database/passenger-scope";
import { PrismaService } from "../../database/prisma.service";
import type { VerifiedAccessToken } from "../auth/token.service";
import { permissionDenied } from "../role/authorization.errors";
import { accountNotFound } from "./account.errors";

const PROFILE_SELECT = { id: true, name: true, email: true, emailVerified: true, phone: true, dateOfBirth: true, image: true } as const;

/** Hồ sơ và các tài nguyên của hành khách; chủ sở hữu luôn lấy từ access token. */
@Injectable()
export class PassengerProfileService {
  constructor(@Inject(PrismaService) private readonly prisma: PrismaService) {}

  /** Đọc hồ sơ tài khoản của người gọi. */
  async get(actor: VerifiedAccessToken): Promise<PassengerProfile> {
    return withPassengerData(this.prisma, passengerId(actor), async (tx, userId) => {
      const row = await tx.user.findUnique({ where: { id: userId }, select: PROFILE_SELECT });
      if (!row) throw accountNotFound();
      return { ...row, userId: row.id, dateOfBirth: row.dateOfBirth?.toISOString().slice(0, 10) ?? null };
    });
  }

  /** Cập nhật tên, điện thoại và ngày sinh của chính hành khách. */
  async update(actor: VerifiedAccessToken, input: PassengerProfileUpdate): Promise<PassengerProfile> {
    await withPassengerData(this.prisma, passengerId(actor), async (tx, userId) => {
      const changed = await tx.user.updateMany({ where: { id: userId }, data: {
        ...(input.name !== undefined ? { name: input.name } : {}),
        ...(input.phone !== undefined ? { phone: input.phone } : {}),
        ...(input.dateOfBirth !== undefined ? { dateOfBirth: input.dateOfBirth ? new Date(`${input.dateOfBirth}T00:00:00.000Z`) : null } : {}),
      } });
      if (!changed.count) throw accountNotFound();
    });
    return this.get(actor);
  }

  /** Liệt kê hành khách thường dùng của tài khoản. */
  async saved(actor: VerifiedAccessToken): Promise<{ items: SavedPassenger[] }> {
    return withPassengerData(this.prisma, passengerId(actor), async (tx, userId) => ({ items: (await tx.savedPassenger.findMany({ where: { userId }, orderBy: [{ createdAt: "asc" }, { id: "asc" }], select: { id: true, fullName: true, phone: true } })).map(savedView) }));
  }

  /** Lưu một hành khách thường dùng vào tài khoản người gọi. */
  async createSaved(actor: VerifiedAccessToken, input: SavedPassengerInput): Promise<SavedPassenger> {
    return withPassengerData(this.prisma, passengerId(actor), async (tx, userId) => savedView(await tx.savedPassenger.create({ data: { ...input, userId }, select: { id: true, fullName: true, phone: true } })));
  }

  /** Sửa một hành khách đã lưu sau khi xác minh chủ sở hữu. */
  async updateSaved(actor: VerifiedAccessToken, id: string, input: SavedPassengerInput): Promise<SavedPassenger> {
    return withPassengerData(this.prisma, passengerId(actor), async (tx, userId) => {
      const result = await tx.savedPassenger.updateMany({ where: { id, userId }, data: input });
      if (!result.count) throw accountNotFound();
      return savedView(await tx.savedPassenger.findFirstOrThrow({ where: { id, userId }, select: { id: true, fullName: true, phone: true } }));
    });
  }

  /** Xóa một hành khách đã lưu của đúng tài khoản. */
  async deleteSaved(actor: VerifiedAccessToken, id: string): Promise<void> {
    return withPassengerData(this.prisma, passengerId(actor), async (tx, userId) => {
      if (!(await tx.savedPassenger.deleteMany({ where: { id, userId } })).count) throw accountNotFound();
    });
  }

  /** Liệt kê đơn của hành khách trên mọi nhà xe. */
  async bookings(actor: VerifiedAccessToken, query: PassengerPageQuery): Promise<PassengerBookingPage> {
    return withPassengerData(this.prisma, passengerId(actor), async (tx, userId) => {
      const cursor = query.cursor ? await tx.booking.findFirst({ where: { id: query.cursor, userId }, select: { createdAt: true, id: true } }) : null;
      if (query.cursor && !cursor) return { items: [], nextCursor: null };
      const rows = await tx.booking.findMany({ where: { userId, ...after(cursor) }, orderBy: [{ createdAt: "desc" }, { id: "desc" }], take: query.limit + 1, select: {
        id: true, bookingCode: true, operatorId: true, tripId: true, status: true, total: true, createdAt: true,
        operator: { select: { displayName: true } }, trip: { select: { departureAt: true, route: { select: { name: true } } } },
      } });
      return paginate(rows, query.limit, (row) => ({ bookingId: row.id, bookingCode: row.bookingCode, operatorId: row.operatorId, operatorName: row.operator.displayName, tripId: row.tripId, routeName: row.trip.route.name, departureAt: row.trip.departureAt.toISOString(), status: row.status, total: row.total.toString(), createdAt: row.createdAt.toISOString() }));
    });
  }

  /** Liệt kê vé thuộc các đơn của tài khoản, không trả QR trong danh sách. */
  async tickets(actor: VerifiedAccessToken, query: PassengerPageQuery): Promise<PassengerTicketPage> {
    return withPassengerData(this.prisma, passengerId(actor), async (tx, userId) => {
      const cursor = query.cursor ? await tx.ticket.findFirst({ where: { id: query.cursor, booking: { userId } }, select: { createdAt: true, id: true } }) : null;
      if (query.cursor && !cursor) return { items: [], nextCursor: null };
      const rows = await tx.ticket.findMany({ where: { booking: { userId }, ...after(cursor) }, orderBy: [{ createdAt: "desc" }, { id: "desc" }], take: query.limit + 1, select: {
        id: true, ticketCode: true, bookingId: true, seatCode: true, status: true, issuedAt: true,
        passenger: { select: { fullName: true } }, booking: { select: { bookingCode: true, operator: { select: { displayName: true } }, trip: { select: { departureAt: true, route: { select: { name: true } } } } } },
      } });
      return paginate(rows, query.limit, (row) => ({ ticketId: row.id, ticketCode: row.ticketCode, bookingId: row.bookingId, bookingCode: row.booking.bookingCode, operatorName: row.booking.operator.displayName, routeName: row.booking.trip.route.name, departureAt: row.booking.trip.departureAt.toISOString(), seatCode: row.seatCode, passengerName: row.passenger.fullName, status: row.status, issuedAt: row.issuedAt.toISOString() }));
    });
  }

  /** Liệt kê khiếu nại gắn với các đơn của tài khoản. */
  async supportTickets(actor: VerifiedAccessToken, query: PassengerPageQuery): Promise<PassengerSupportPage> {
    return withPassengerData(this.prisma, passengerId(actor), async (tx, userId) => {
      const cursor = query.cursor ? await tx.supportTicket.findFirst({ where: { id: query.cursor, booking: { userId } }, select: { createdAt: true, id: true } }) : null;
      if (query.cursor && !cursor) return { items: [], nextCursor: null };
      const rows = await tx.supportTicket.findMany({ where: { booking: { userId }, ...after(cursor) }, orderBy: [{ createdAt: "desc" }, { id: "desc" }], take: query.limit + 1, select: { id: true, ticketCode: true, bookingId: true, subject: true, status: true, updatedAt: true, booking: { select: { bookingCode: true } } } });
      return paginate(rows, query.limit, (row) => ({ ticketId: row.id, ticketCode: row.ticketCode, bookingId: row.bookingId, bookingCode: row.booking.bookingCode, subject: row.subject, status: row.status, updatedAt: row.updatedAt.toISOString() }));
    });
  }

  /** Liệt kê tranh chấp gắn với các đơn của tài khoản. */
  async disputes(actor: VerifiedAccessToken, query: PassengerPageQuery): Promise<PassengerDisputePage> {
    return withPassengerData(this.prisma, passengerId(actor), async (tx, userId) => {
      const cursor = query.cursor ? await tx.disputeCase.findFirst({ where: { id: query.cursor, booking: { userId } }, select: { createdAt: true, id: true } }) : null;
      if (query.cursor && !cursor) return { items: [], nextCursor: null };
      const rows = await tx.disputeCase.findMany({ where: { booking: { userId }, ...after(cursor) }, orderBy: [{ createdAt: "desc" }, { id: "desc" }], take: query.limit + 1, select: { id: true, disputeCode: true, bookingId: true, title: true, status: true, responseDueAt: true, updatedAt: true, booking: { select: { bookingCode: true } } } });
      return paginate(rows, query.limit, (row) => ({ disputeId: row.id, disputeCode: row.disputeCode, bookingId: row.bookingId, bookingCode: row.booking.bookingCode, title: row.title, status: row.status, responseDueAt: row.responseDueAt?.toISOString() ?? null, updatedAt: row.updatedAt.toISOString() }));
    });
  }
}

function passengerId(actor: VerifiedAccessToken): string {
  if (actor.scope !== "passenger" || actor.role !== "PASSENGER") throw permissionDenied();
  return actor.sub;
}
function savedView(row: { id: string; fullName: string; phone: string | null }): SavedPassenger {
  return { passengerId: row.id, fullName: row.fullName, phone: row.phone };
}
function after(cursor: { createdAt: Date; id: string } | null) {
  return cursor ? { OR: [{ createdAt: { lt: cursor.createdAt } }, { createdAt: cursor.createdAt, id: { lt: cursor.id } }] } : {};
}
function paginate<T extends { id: string }, R>(rows: T[], limit: number, view: (row: T) => R): { items: R[]; nextCursor: string | null } {
  const page = rows.slice(0, limit);
  return { items: page.map(view), nextCursor: rows.length > limit ? page.at(-1)!.id : null };
}
