import { Inject, Injectable } from "@nestjs/common";
import { AuditService, AuditWriteError } from "../audit/audit.service";
import type { DbScope } from "../database/db-scope";
import { withBookingOperator } from "../database/marketplace-scope";
import { withPassengerData } from "../database/passenger-scope";
import { PrismaService, transactionDeadline, type DbTransaction } from "../database/prisma.service";
import { DisputeStatus, ReviewStatus, TicketStatus, TripStatus } from "../database/prisma.types";
import type { VerifiedAccessToken } from "../iam/auth/token.service";
import type { Authorization } from "../iam/role/authorization";
import { requireTenant } from "../iam/role/require-tenant";
import { maskName } from "../payment/admin-payment.service";
import { OPEN_DISPUTE_STATUSES } from "../dispute/dto/dispute.dto";
import { platformDb } from "../support/support.service";
import { reviewNotAllowed, reviewNotFound, trustAuditUnavailable } from "../support/support.errors";
import { REVIEW_SIGNALS, type CustomerReview, type ModerationInput, type PassengerReviews, type ReplyInput, type ReportInput, type Review, type ReviewInput, type ReviewPage } from "./dto/review.dto";

const AUDIT_TIMEOUT_MS = 2_000;
const OPEN_DISPUTES: DisputeStatus[] = [...OPEN_DISPUTE_STATUSES];
/** Vé chứng tỏ khách đã đi chuyến (BR-18 "ticket hợp lệ trên chuyến đã hoàn thành"). */
const RIDDEN: TicketStatus[] = [TicketStatus.USED, TicketStatus.CHECKED_IN];
/** BR-18: chuyến đã hoàn thành và đơn có vé đã đi. */
const REVIEWABLE = { trip: { status: TripStatus.COMPLETED }, tickets: { some: { status: { in: RIDDEN } } } };
/** Số điện thoại / đường dẫn trong nhận xét — dấu hiệu quảng cáo (Figma ADM-10a "Nghi quảng cáo / spam"). */
const SPAM_PATTERN = /(https?:\/\/|www\.|\b0\d(?:[ .-]?\d){7,}\b|\d{2}x{2,})/i;
const SPAM_SQL = "(https?://|www\\.|0[0-9]([ .-]?[0-9]){7,}|[0-9]{2}x{2,})";
/** Ký tự lặp từ 5 lần (`!!!!!`, `aaaaa`) — "Nội dung lặp". */
const REPEATED_PATTERN = /(.)\1{4,}/u;

type Signal = (typeof REVIEW_SIGNALS)[number];
type Actor = Pick<VerifiedAccessToken, "sub" | "role">;
type View = "ADMIN" | "OPERATOR" | "CUSTOMER";
type ReviewWhere = NonNullable<NonNullable<Parameters<DbTransaction["review"]["findMany"]>[0]>["where"]>;

const SELECT = {
  id: true,
  bookingId: true,
  operatorId: true,
  authorName: true,
  rating: true,
  comment: true,
  status: true,
  operatorReply: true,
  operatorRepliedAt: true,
  operatorReportedAt: true,
  operatorReportReason: true,
  moderationReason: true,
  moderatedAt: true,
  createdAt: true,
  booking: { select: { bookingCode: true, disputeCases: { where: { status: { in: OPEN_DISPUTES } }, select: { id: true } } } },
  operator: { select: { displayName: true } },
  trip: { select: { departureAt: true, route: { select: { name: true } } } },
} as const;
type Row = Awaited<ReturnType<typeof findRows>>[number];

function findRows(tx: DbTransaction, where: ReviewWhere) {
  return tx.review.findMany({ where, select: SELECT });
}

/**
 * Đánh giá chuyến đi (TASK-TRUST-001, FR-NSR-10/11, BR-18/55): hành khách (không phải khách vãng lai) đánh giá một lần mỗi đơn sau
 * khi chuyến hoàn thành và đã đi; nhà xe phản hồi hoặc báo vi phạm (không sửa / xóa được); Admin giữ chờ / ẩn (lý do) / hiển thị
 * lại — chỉ đánh giá đang hiển thị được tính điểm. Thao tác của nhà xe / Admin ghi audit trong transaction.
 */
@Injectable()
export class ReviewService {
  constructor(
    @Inject(PrismaService) private readonly prisma: PrismaService,
    @Inject(AuditService) private readonly audit: AuditService,
  ) {}

  // ------------------------------------------------------------------ Hành khách

  /** Chuyến chờ đánh giá + đánh giá đã gửi trên mọi nhà xe (SCR-PSG-14); đơn của tài khoản khác và khách vãng lai không có ở đây. */
  async customerList(user: VerifiedAccessToken, query: { pendingCursor?: string; reviewedCursor?: string; limit: number }): Promise<PassengerReviews> {
    return withPassengerData(this.prisma, user.sub, async (tx, userId) => ({
      pending: await pendingPage(tx, userId, query.pendingCursor, query.limit),
      reviewed: await reviewedPage(tx, userId, query.reviewedCursor, query.limit),
    }));
  }

  async customerGet(user: VerifiedAccessToken, bookingId: string): Promise<CustomerReview> {
    return this.asOwner(user, bookingId, async (tx, operatorId) => {
      const row = (await findRows(tx, { bookingId, operatorId }))[0];
      return { review: row ? toReview(row, "CUSTOMER") : null, canReview: !row && (await eligible(tx, operatorId, bookingId)) };
    });
  }

  async customerCreate(user: VerifiedAccessToken, bookingId: string, input: ReviewInput): Promise<Review> {
    return this.asOwner(user, bookingId, async (tx, operatorId) => {
      await tx.$queryRaw`SELECT id FROM bookings WHERE id = ${bookingId} FOR UPDATE`;
      if (await tx.review.findFirst({ where: { bookingId, operatorId }, select: { id: true } })) {
        throw reviewNotAllowed("Đơn này đã được đánh giá.");
      }
      if (!(await eligible(tx, operatorId, bookingId))) {
        throw reviewNotAllowed("Chỉ đánh giá được sau khi chuyến hoàn thành và bạn đã đi chuyến này.");
      }
      const booking = await tx.booking.findFirstOrThrow({ where: { id: bookingId, operatorId }, select: { tripId: true, contactName: true } });
      const created = await tx.review.create({
        data: { operatorId, bookingId, tripId: booking.tripId, userId: user.sub, authorName: maskName(booking.contactName), rating: input.rating, comment: input.comment || null },
        select: { id: true },
      });
      return toReview((await findRows(tx, { id: created.id, operatorId }))[0]!, "CUSTOMER");
    });
  }

  // ------------------------------------------------------------------ Nhà xe

  async operatorList(authz: Authorization, query: { routeId?: string; rating?: number; replied?: "yes" | "no"; cursor?: string; limit: number }): Promise<ReviewPage> {
    const { db, operatorId } = requireTenant(authz);
    return this.prisma.withScope(db, (tx) =>
      page(
        tx,
        {
          operatorId,
          status: { not: ReviewStatus.HIDDEN },
          ...(query.routeId ? { trip: { routeId: query.routeId } } : {}),
          ...(query.rating ? { rating: query.rating } : {}),
          ...(query.replied ? { operatorReply: query.replied === "yes" ? { not: null } : null } : {}),
        },
        query,
        "OPERATOR",
        { operatorId },
      ),
    );
  }

  async reply(authz: Authorization, actor: Actor, reviewId: string, input: ReplyInput): Promise<Review> {
    const { db, operatorId } = requireTenant(authz);
    return this.write(db, async (tx, deadline) => {
      const review = await lockReview(tx, reviewId, operatorId);
      if (review.status === ReviewStatus.HIDDEN) {
        throw reviewNotFound();
      }
      await tx.review.update({ where: { id: reviewId }, data: { operatorReply: input.reply, operatorRepliedAt: new Date() } });
      await this.record(actor, "review.reply", reviewId, operatorId, { reply: review.operatorReply }, { reply: input.reply }, deadline);
      return toReview((await findRows(tx, { id: reviewId, operatorId }))[0]!, "OPERATOR");
    });
  }

  async report(authz: Authorization, actor: Actor, reviewId: string, input: ReportInput): Promise<Review> {
    const { db, operatorId } = requireTenant(authz);
    return this.write(db, async (tx, deadline) => {
      const review = await lockReview(tx, reviewId, operatorId);
      if (review.status === ReviewStatus.HIDDEN) {
        throw reviewNotFound();
      }
      if (review.operatorReportedAt) {
        throw reviewNotAllowed("Nhà xe đã báo cáo đánh giá này.");
      }
      // Báo cáo mới → Admin xem lại (bỏ dấu đã xử lý trước đó).
      await tx.review.update({ where: { id: reviewId }, data: { operatorReportedAt: new Date(), operatorReportReason: input.reason, moderatedAt: null, moderatedBy: null } });
      await this.record(actor, "review.report", reviewId, operatorId, {}, {}, deadline, input.reason);
      return toReview((await findRows(tx, { id: reviewId, operatorId }))[0]!, "OPERATOR");
    });
  }

  // ------------------------------------------------------------------ Admin

  async adminList(authz: Authorization, query: { status?: ReviewStatus | "attention"; operatorId?: string; rating?: number; q?: string; cursor?: string; limit: number }): Promise<ReviewPage> {
    return this.prisma.withScope(platformDb(authz), async (tx) => {
      const attention = query.status === "attention" ? await attentionIds(tx) : null;
      const q = query.q;
      const where: ReviewWhere = {
        ...(attention ? { id: { in: attention } } : query.status && query.status !== "attention" ? { status: query.status } : {}),
        ...(query.operatorId ? { operatorId: query.operatorId } : {}),
        ...(query.rating ? { rating: query.rating } : {}),
        ...(q ? { OR: [{ comment: { contains: q, mode: "insensitive" } }, { booking: { bookingCode: { contains: q.toUpperCase().replace(/-/g, "") } } }] } : {}),
      };
      return page(tx, where, query, "ADMIN", query.operatorId ? { operatorId: query.operatorId } : {});
    });
  }

  /** Giữ chờ / ẩn / hiển thị lại (BR-55, UC-28). Ẩn bắt buộc lý do; mọi lần ghi audit. */
  async moderate(authz: Authorization, actor: Actor, reviewId: string, input: ModerationInput): Promise<Review> {
    return this.write(platformDb(authz), async (tx, deadline) => {
      const review = await lockReview(tx, reviewId);
      const status = input.action === "HOLD" ? ReviewStatus.HELD : input.action === "HIDE" ? ReviewStatus.HIDDEN : ReviewStatus.VISIBLE;
      await tx.review.update({ where: { id: reviewId }, data: { status, moderationReason: input.reason ?? (status === ReviewStatus.HIDDEN ? review.moderationReason : null), moderatedBy: `platform:${actor.sub}`, moderatedAt: new Date() } });
      await this.record(actor, "review.moderate", reviewId, review.operatorId, { status: review.status }, { status }, deadline, input.reason ?? undefined);
      return toReview((await findRows(tx, { id: reviewId }))[0]!, "ADMIN");
    });
  }

  // ------------------------------------------------------------------ Nội bộ

  /** Chạy ở tenant của đơn khi đơn là của chính hành khách (khách vãng lai không đánh giá — BR-18); không → 404. */
  private async asOwner<T>(user: VerifiedAccessToken, bookingId: string, work: (tx: DbTransaction, operatorId: string) => Promise<T>): Promise<T> {
    const result = await withBookingOperator(this.prisma, bookingId, async (tx, operatorId) => {
      const booking = await tx.booking.findFirst({ where: { id: bookingId, operatorId }, select: { userId: true } });
      if (!booking || booking.userId === null || booking.userId !== user.sub) {
        return { found: false as const };
      }
      return { found: true as const, value: await work(tx, operatorId) };
    });
    if (!result?.found) {
      throw reviewNotFound();
    }
    return result.value;
  }

  private async write<T>(db: DbScope, work: (tx: DbTransaction, deadline: number) => Promise<T>): Promise<T> {
    try {
      return await this.prisma.withScope(db, (tx) => work(tx, transactionDeadline(Date.now())));
    } catch (error) {
      if (error instanceof AuditWriteError || (error as { code?: unknown } | null)?.code === "P2028") {
        throw trustAuditUnavailable();
      }
      throw error;
    }
  }

  private record(actor: Actor, action: string, reviewId: string, operatorId: string, before: Record<string, unknown>, after: Record<string, unknown>, deadline: number, reason?: string): Promise<void> {
    return this.audit.recordAuditEvent(
      { actorId: actor.sub, actorRole: actor.role, action, targetType: "review", targetId: reviewId, operatorId, before, after, ...(reason ? { reason } : {}) },
      { timeoutMs: AUDIT_TIMEOUT_MS, deadline },
    );
  }
}

async function eligible(tx: DbTransaction, operatorId: string, bookingId: string): Promise<boolean> {
  return (await tx.booking.findFirst({ where: { id: bookingId, operatorId, ...REVIEWABLE }, select: { id: true } })) !== null;
}

/** Đơn đủ điều kiện `eligible` chưa có đánh giá, chuyến gần nhất trước. Cursor của tài khoản khác không dùng được. */
async function pendingPage(tx: DbTransaction, userId: string, cursorId: string | undefined, limit: number): Promise<PassengerReviews["pending"]> {
  const where = { userId, ...REVIEWABLE, reviews: { none: {} } };
  const total = await tx.booking.count({ where });
  const cursor = cursorId ? await tx.booking.findFirst({ where: { id: cursorId, userId }, select: { id: true, trip: { select: { departureAt: true } } } }) : null;
  if (cursorId && !cursor) {
    return { items: [], nextCursor: null, total };
  }
  const rows = await tx.booking.findMany({
    where: { ...where, ...(cursor ? { OR: [{ trip: { departureAt: { lt: cursor.trip.departureAt } } }, { trip: { departureAt: cursor.trip.departureAt }, id: { lt: cursor.id } }] } : {}) },
    orderBy: [{ trip: { departureAt: "desc" } }, { id: "desc" }],
    take: limit + 1,
    select: {
      id: true,
      bookingCode: true,
      operatorId: true,
      operator: { select: { displayName: true } },
      trip: { select: { departureAt: true, route: { select: { name: true } }, vehicle: { select: { vehicleType: { select: { name: true } } } } } },
    },
  });
  return {
    items: rows.slice(0, limit).map((row) => ({
      bookingId: row.id,
      bookingCode: row.bookingCode,
      operatorId: row.operatorId,
      operatorName: row.operator.displayName,
      routeName: row.trip.route.name,
      vehicleTypeName: row.trip.vehicle?.vehicleType.name ?? null,
      departureAt: row.trip.departureAt.toISOString(),
    })),
    nextCursor: rows.length > limit ? rows[limit - 1]!.id : null,
    total,
  };
}

/** Đánh giá đã gửi, mới trước, gồm cả đang giữ chờ / đã ẩn để khách biết trạng thái. Cursor của tài khoản khác không dùng được. */
async function reviewedPage(tx: DbTransaction, userId: string, cursorId: string | undefined, limit: number): Promise<PassengerReviews["reviewed"]> {
  const where = { booking: { userId } };
  const total = await tx.review.count({ where });
  const cursor = cursorId ? await tx.review.findFirst({ where: { id: cursorId, ...where }, select: { id: true, createdAt: true } }) : null;
  if (cursorId && !cursor) {
    return { items: [], nextCursor: null, total };
  }
  const rows = await tx.review.findMany({
    where: { ...where, ...(cursor ? { OR: [{ createdAt: { lt: cursor.createdAt } }, { createdAt: cursor.createdAt, id: { lt: cursor.id } }] } : {}) },
    orderBy: [{ createdAt: "desc" }, { id: "desc" }],
    take: limit + 1,
    select: SELECT,
  });
  return {
    items: rows.slice(0, limit).map((row) => toReview(row, "CUSTOMER")),
    nextCursor: rows.length > limit ? rows[limit - 1]!.id : null,
    total,
  };
}

async function lockReview(tx: DbTransaction, reviewId: string, operatorId?: string) {
  const [row] = await tx.$queryRaw<{ id: string }[]>`SELECT id FROM reviews WHERE id = ${reviewId} FOR UPDATE`;
  const review = row
    ? await tx.review.findFirst({
        where: { id: reviewId, ...(operatorId ? { operatorId } : {}) },
        select: { operatorId: true, status: true, operatorReply: true, operatorReportedAt: true, moderationReason: true },
      })
    : null;
  if (!review) {
    throw reviewNotFound();
  }
  return review;
}

/** Đánh giá cần xem xét: đang giữ chờ; hoặc chưa xử lý mà nhà xe báo cáo / nghi spam / nội dung lặp / đơn đang tranh chấp. */
async function attentionIds(tx: DbTransaction): Promise<string[]> {
  const rows = await tx.$queryRaw<{ id: string }[]>`
    SELECT r.id FROM reviews r
    WHERE r.status = 'HELD'
      OR (r.status = 'VISIBLE' AND r.moderated_at IS NULL AND (
        r.operator_reported_at IS NOT NULL
        OR r.comment ~* ${SPAM_SQL}
        OR r.comment ~ '(.)\\1{4,}'
        OR EXISTS (SELECT 1 FROM dispute_cases d WHERE d.booking_id = r.booking_id AND d.operator_id = r.operator_id AND d.status::text = ANY(${OPEN_DISPUTES}))
      ))
    LIMIT 1000`;
  return rows.map((row) => row.id);
}

async function page(tx: DbTransaction, where: ReviewWhere, query: { cursor?: string; limit: number }, view: View, scoreScope: ReviewWhere): Promise<ReviewPage> {
  const rows = await tx.review.findMany({
    where,
    orderBy: [{ createdAt: "desc" }, { id: "desc" }],
    take: query.limit + 1,
    ...(query.cursor ? { cursor: { id: query.cursor }, skip: 1 } : {}),
    select: SELECT,
  });
  const more = rows.length > query.limit;
  const items = rows.slice(0, query.limit);
  const score = await tx.review.aggregate({ where: { ...scoreScope, status: ReviewStatus.VISIBLE }, _avg: { rating: true }, _count: { _all: true } });
  return {
    items: items.map((row) => toReview(row, view)),
    nextCursor: more ? items.at(-1)!.id : null,
    total: await tx.review.count({ where }),
    average: score._avg.rating === null ? null : Math.round(score._avg.rating * 10) / 10,
    validCount: score._count._all,
  };
}

/** Tín hiệu hiển thị cho Admin (Figma ADM-10a). */
export function reviewSignals(row: { comment: string | null; operatorReportedAt: Date | null; disputed: boolean }): Signal[] {
  const signals: Signal[] = [];
  if (row.comment && SPAM_PATTERN.test(row.comment)) {
    signals.push("SPAM");
  }
  if (row.operatorReportedAt) {
    signals.push("OPERATOR_REPORTED");
  }
  if (row.disputed) {
    signals.push("DISPUTED");
  }
  if (row.comment && REPEATED_PATTERN.test(row.comment)) {
    signals.push("REPEATED");
  }
  return signals;
}

function toReview(row: Row, view: View): Review {
  const admin = view === "ADMIN";
  return {
    reviewId: row.id,
    bookingId: row.bookingId,
    bookingCode: row.booking.bookingCode,
    operatorId: row.operatorId,
    operatorName: row.operator.displayName,
    authorName: row.authorName,
    rating: row.rating,
    comment: row.comment,
    routeName: row.trip.route.name,
    departureAt: row.trip.departureAt.toISOString(),
    status: row.status,
    operatorReply: row.operatorReply,
    operatorRepliedAt: row.operatorRepliedAt?.toISOString() ?? null,
    operatorReportedAt: view === "CUSTOMER" ? null : (row.operatorReportedAt?.toISOString() ?? null),
    operatorReportReason: admin ? row.operatorReportReason : null,
    moderationReason: admin ? row.moderationReason : null,
    signals: admin ? reviewSignals({ comment: row.comment, operatorReportedAt: row.operatorReportedAt, disputed: row.booking.disputeCases.length > 0 }) : [],
    createdAt: row.createdAt.toISOString(),
  };
}
