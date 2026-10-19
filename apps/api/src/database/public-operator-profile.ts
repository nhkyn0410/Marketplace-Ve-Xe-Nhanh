import type { PublicOperatorProfile } from "@vexenhanh/types";
import type { PrismaService } from "./prisma.service";

/** Hồ sơ công khai chỉ chọn trường công khai, review đang hiển thị và tuyến đang mở bán. */
export async function loadPublicOperatorProfile(prisma: Pick<PrismaService, "withSystem">, operatorId: string, query: { cursor?: string; limit: number }, now: Date): Promise<PublicOperatorProfile | null> {
  return prisma.withSystem(async (tx) => {
    const profile = await tx.operatorProfile.findFirst({ where: { id: operatorId, status: "ACTIVE" }, select: { id: true, operatorSlug: true, displayName: true, description: true, hotline: true, publicEmail: true, address: true } });
    if (!profile) return null;
    const cursor = query.cursor ? await tx.review.findFirst({ where: { id: query.cursor, operatorId, status: "VISIBLE" }, select: { id: true, createdAt: true } }) : null;
    const rating = await tx.review.aggregate({ where: { operatorId, status: "VISIBLE" }, _avg: { rating: true }, _count: { id: true } });
    const reviews = query.cursor && !cursor ? [] : await tx.review.findMany({ where: { operatorId, status: "VISIBLE", ...(cursor ? { OR: [{ createdAt: { lt: cursor.createdAt } }, { createdAt: cursor.createdAt, id: { lt: cursor.id } }] } : {}) }, orderBy: [{ createdAt: "desc" }, { id: "desc" }], take: query.limit + 1, select: { id: true, authorName: true, rating: true, comment: true, operatorReply: true, operatorRepliedAt: true, createdAt: true } });
    const routes = await tx.route.findMany({ where: { operatorId, trips: { some: { status: "OPEN_FOR_SALE", departureAt: { gt: now } } } }, orderBy: { name: "asc" }, take: 6, select: { id: true, name: true } });
    const trips = await tx.trip.findMany({ where: { operatorId, departureAt: { lt: now }, status: { in: ["COMPLETED", "CANCELLED"] } }, select: { status: true, changes: { where: { kinds: { has: "CANCEL" } }, select: { actor: true } } } });
    const bookings = await tx.booking.count({ where: { operatorId, paidAt: { not: null } } });
    const refunded = await tx.booking.count({ where: { operatorId, paidAt: { not: null }, refunds: { some: { status: "SUCCESS" } } } });
    const disputed = await tx.booking.count({ where: { operatorId, paidAt: { not: null }, disputeCases: { some: {} } } });
    const attendance = await tx.ticket.groupBy({ by: ["status"], where: { operatorId, status: { in: ["USED", "CHECKED_IN", "NO_SHOW"] }, booking: { trip: { status: "COMPLETED" } } }, _count: { _all: true } });
    const attendanceCount = attendance.reduce((total, row) => total + row._count._all, 0);
    const checkedIn = attendance.filter((row) => row.status === "USED" || row.status === "CHECKED_IN").reduce((total, row) => total + row._count._all, 0);
    const noShow = attendance.find((row) => row.status === "NO_SHOW")?._count._all ?? 0;
    const cancelled = trips.filter((trip) => trip.status === "CANCELLED");
    const knownCancellations = cancelled.every((trip) => trip.changes.length > 0);
    const operatorCancelled = cancelled.filter((trip) => trip.changes.some((change) => change.actor.startsWith("operator:"))).length;
    const page = reviews.slice(0, query.limit);
    return {
      operatorId: profile.id, operatorSlug: profile.operatorSlug, displayName: profile.displayName,
      description: profile.description, hotline: profile.hotline, publicEmail: profile.publicEmail, address: profile.address,
      scorecard: { averageRating: rating._avg.rating, reviewCount: rating._count.id,
        operatorCancellationRate: knownCancellations ? ratio(operatorCancelled, trips.length) : null,
        refundBookingRate: ratio(refunded, bookings), disputeBookingRate: ratio(disputed, bookings),
        checkInRate: ratio(checkedIn, attendanceCount), noShowRate: ratio(noShow, attendanceCount),
      },
      routes: routes.map((route) => ({ routeId: route.id, name: route.name })),
      // Nhà xe chưa có điều khoản dịch vụ riêng trong schema; thiếu dữ liệu được trả null.
      serviceTerms: null,
      reviews: page.map((review) => ({ reviewId: review.id, authorName: review.authorName, rating: review.rating, comment: review.comment, operatorReply: review.operatorReply, operatorRepliedAt: review.operatorRepliedAt?.toISOString() ?? null, createdAt: review.createdAt.toISOString() })),
      nextReviewCursor: reviews.length > query.limit ? page.at(-1)!.id : null,
    };
  });
}

function ratio(numerator: number, denominator: number): number | null { return denominator ? numerator / denominator : null; }
