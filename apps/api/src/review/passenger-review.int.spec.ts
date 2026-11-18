import { randomUUID } from "node:crypto";
import { Client } from "pg";
import { afterAll, beforeAll, describe, expect, it, vi } from "vitest";
import type { AuditService } from "../audit/audit.service";
import { parseAppConfig } from "../config/env.config";
import { tenantScope } from "../database/db-scope";
import { PrismaService } from "../database/prisma.service";
import type { TicketStatus, TripStatus } from "../database/prisma.types";
import type { VerifiedAccessToken } from "../iam/auth/token.service";
import type { Authorization } from "../iam/role/authorization";
import { ReviewService } from "./review.service";

/**
 * SCR-PSG-14 trên Postgres THẬT, role app (ADR-025): danh sách "Chờ đánh giá" đúng điều kiện của `canReview` (BR-18), đọc qua nhiều
 * nhà xe của chính hành khách mà không lộ đơn của tài khoản khác / khách vãng lai, RLS tenant vẫn chặn các chỗ còn lại.
 */
const url = process.env.DATABASE_URL;
const requireDb = process.env.REQUIRE_DB_TESTS === "1";
const HOUR = 3_600_000;

describe.skipIf(!url && !requireDb)("Đánh giá của tôi — Postgres thật, role app", () => {
  let prisma: PrismaService;
  let reviews: ReviewService;
  const tag = randomUUID().slice(0, 8);
  const operatorA = randomUUID();
  const operatorB = randomUUID();
  const routes = { [operatorA]: randomUUID(), [operatorB]: randomUUID() };
  const vehicleType = randomUUID();
  const vehicle = randomUUID();
  const riderId = `rider${tag}`;
  const strangerId = `stranger${tag}`;
  const rider = { sub: riderId, role: "PASSENGER", scope: "passenger", sid: randomUUID() } as VerifiedAccessToken;
  const stranger = { sub: strangerId, role: "PASSENGER", scope: "passenger", sid: randomUUID() } as VerifiedAccessToken;
  let sequence = 0;

  /** Đơn trên chuyến riêng (khởi hành `hoursAgo` giờ trước), mỗi vé một trạng thái. `userId` = `null` là khách vãng lai. */
  async function booking(input: { operatorId: string; userId: string | null; hoursAgo: number; tripStatus: TripStatus; tickets: TicketStatus[]; withVehicle?: boolean }) {
    const { operatorId } = input;
    sequence += 1;
    const code = `VXN${tag.slice(0, 3).toUpperCase()}${String(sequence).padStart(3, "0")}`;
    const bookingId = randomUUID();
    const tripId = randomUUID();
    const departureAt = new Date(Date.now() - input.hoursAgo * HOUR);
    await prisma.withTenant(operatorId, async (tx) => {
      await tx.trip.create({ data: { id: tripId, operatorId, routeId: routes[operatorId]!, vehicleId: input.withVehicle ? vehicle : null, departureAt, arrivalAt: new Date(departureAt.getTime() + HOUR), status: input.tripStatus, statusReason: input.tripStatus === "CANCELLED" ? "Hủy để test" : null } });
      await tx.booking.create({
        data: { id: bookingId, bookingCode: code, operatorId, tripId, userId: input.userId, holdId: randomUUID(), status: "CONFIRMED", contactName: "Nguyễn Văn Khánh", contactPhone: "0901234567", contactEmail: `rider-${tag}@example.com`, pickupSequence: 1, dropoffSequence: 2, subtotal: 300_000n, total: 300_000n, snapshot: {}, accessTokenHash: randomUUID(), expiresAt: new Date(departureAt.getTime() - HOUR) },
      });
      for (const [index, status] of input.tickets.entries()) {
        const seatCode = `A${index + 1}`;
        const passenger = await tx.passengerInfo.create({ data: { bookingId, operatorId, tripId, seatCode, seatType: "BED", price: 300_000n, fullName: "Khách" } });
        await tx.ticket.create({ data: { ticketCode: `${code}-${String(index + 1).padStart(2, "0")}`, operatorId, bookingId, tripId, passengerInfoId: passenger.id, seatCode, status, qrTokenHash: randomUUID(), issuedAt: departureAt } });
      }
    });
    return bookingId;
  }

  beforeAll(async () => {
    prisma = new PrismaService(parseAppConfig({ DATABASE_URL: url }));
    reviews = new ReviewService(prisma, {} as AuditService);
    await prisma.withSystem(async (tx) => {
      await tx.operatorProfile.createMany({
        data: [
          { id: operatorA, operatorSlug: `pra-${tag}`, displayName: `Nhà xe A ${tag}` },
          { id: operatorB, operatorSlug: `prb-${tag}`, displayName: `Nhà xe B ${tag}` },
        ],
      });
      await tx.user.createMany({
        data: [
          { id: riderId, email: `rider-${tag}@example.com`, name: "Rider" },
          { id: strangerId, email: `stranger-${tag}@example.com`, name: "Stranger" },
        ],
      });
      await tx.vehicleType.create({ data: { id: vehicleType, code: `PR-${tag}`, name: "Limousine 34 giường", form: "SLEEPER", class: "STANDARD" } });
      for (const operatorId of [operatorA, operatorB]) {
        await tx.route.create({ data: { id: routes[operatorId]!, operatorId, name: `Tuyến ${operatorId === operatorA ? "A" : "B"} ${tag}`, totalDistanceMeters: 100_000, totalDurationSeconds: 3_600, metricsSource: "GOONG" } });
      }
      await tx.vehicle.create({ data: { id: vehicle, operatorId: operatorA, plateNumber: `51F${10000 + Math.floor(Math.random() * 89999)}`, vehicleTypeId: vehicleType } });
    });
  }, 60_000);

  afterAll(async () => {
    if (!prisma) {
      return;
    }
    await prisma.withSystem(async (tx) => {
      const operators = { operatorId: { in: [operatorA, operatorB] } };
      await tx.review.deleteMany({ where: operators });
      await tx.ticket.deleteMany({ where: operators });
      await tx.passengerInfo.deleteMany({ where: operators });
      await tx.booking.deleteMany({ where: operators });
      await tx.trip.deleteMany({ where: operators });
      await tx.vehicle.deleteMany({ where: operators });
      await tx.route.deleteMany({ where: operators });
      await tx.vehicleType.deleteMany({ where: { id: vehicleType } });
      await tx.user.deleteMany({ where: { id: { in: [riderId, strangerId] } } });
      await tx.operatorProfile.deleteMany({ where: { id: { in: [operatorA, operatorB] } } });
    });
    await prisma.$disconnect();
  });

  it("chờ đánh giá = đúng điều kiện canReview: chuyến COMPLETED, có vé USED / CHECKED_IN, chưa có đánh giá; gửi xong chuyển sang đã đánh giá", async () => {
    const operatorId = operatorA;
    const used = await booking({ operatorId, userId: riderId, hoursAgo: 10, tripStatus: "COMPLETED", tickets: ["USED"], withVehicle: true });
    const checkedIn = await booking({ operatorId, userId: riderId, hoursAgo: 20, tripStatus: "COMPLETED", tickets: ["CHECKED_IN"] });
    const oneRidden = await booking({ operatorId, userId: riderId, hoursAgo: 30, tripStatus: "COMPLETED", tickets: ["CANCELLED", "USED"] });
    const notRidden = [
      await booking({ operatorId, userId: riderId, hoursAgo: 40, tripStatus: "COMPLETED", tickets: ["VALID"] }),
      await booking({ operatorId, userId: riderId, hoursAgo: 41, tripStatus: "COMPLETED", tickets: ["NO_SHOW"] }),
      await booking({ operatorId, userId: riderId, hoursAgo: 42, tripStatus: "COMPLETED", tickets: ["CANCELLED"] }),
      await booking({ operatorId, userId: riderId, hoursAgo: 43, tripStatus: "COMPLETED", tickets: [] }),
    ];
    const notCompleted = [
      await booking({ operatorId, userId: riderId, hoursAgo: 50, tripStatus: "DEPARTED", tickets: ["USED"] }),
      await booking({ operatorId, userId: riderId, hoursAgo: 51, tripStatus: "OPEN_FOR_SALE", tickets: ["CHECKED_IN"] }),
      await booking({ operatorId, userId: riderId, hoursAgo: 52, tripStatus: "CANCELLED", tickets: ["USED"] }),
    ];

    const list = await reviews.customerList(rider, { limit: 100 });
    // Mới đi trước, không phải mới đặt trước.
    expect(list.pending.items.map((item) => item.bookingId)).toEqual([used, checkedIn, oneRidden]);
    expect(list.pending.total).toBe(3);
    expect(list.pending.items[0]).toMatchObject({ operatorId, operatorName: `Nhà xe A ${tag}`, routeName: `Tuyến A ${tag}`, vehicleTypeName: "Limousine 34 giường" });
    expect(list.pending.items[1]!.vehicleTypeName).toBeNull();

    // Hai đường (danh sách + kiểm tra theo đơn) phải luôn cho cùng một câu trả lời.
    for (const bookingId of [used, checkedIn, oneRidden]) {
      expect((await reviews.customerGet(rider, bookingId)).canReview).toBe(true);
    }
    for (const bookingId of [...notRidden, ...notCompleted]) {
      expect((await reviews.customerGet(rider, bookingId)).canReview).toBe(false);
    }

    const review = await reviews.customerCreate(rider, used, { rating: 4, comment: "Xe đúng giờ." });
    const after = await reviews.customerList(rider, { limit: 100 });
    expect(after.pending.items.map((item) => item.bookingId)).toEqual([checkedIn, oneRidden]);
    expect(after.pending.total).toBe(2);
    expect(after.reviewed.total).toBe(1);
    expect(after.reviewed.items[0]).toMatchObject({ reviewId: review.reviewId, bookingId: used, rating: 4, comment: "Xe đúng giờ.", status: "VISIBLE", operatorName: `Nhà xe A ${tag}` });
    expect((await reviews.customerGet(rider, used)).canReview).toBe(false);

    // Đã ẩn / giữ chờ: tác giả vẫn thấy trạng thái, không quay lại danh sách chờ để gửi lần hai.
    await prisma.withSystem((tx) => tx.review.update({ where: { id: review.reviewId }, data: { status: "HIDDEN", moderationReason: "Lý do nội bộ", operatorReportReason: "Nhà xe báo", operatorReportedAt: new Date() } }));
    const hidden = await reviews.customerList(rider, { limit: 100 });
    expect(hidden.reviewed.items[0]).toMatchObject({ reviewId: review.reviewId, status: "HIDDEN", moderationReason: null, operatorReportReason: null, operatorReportedAt: null, signals: [] });
    expect(hidden.pending.items.map((item) => item.bookingId)).not.toContain(used);
  }, 60_000);

  it("qua nhiều nhà xe: hành khách thấy đơn của mình ở cả hai; tài khoản khác, khách vãng lai, cursor của người khác đều không lọt; RLS tenant vẫn chặn", async () => {
    const atB = await booking({ operatorId: operatorB, userId: riderId, hoursAgo: 5, tripStatus: "COMPLETED", tickets: ["USED"] });
    const reviewedAtB = await booking({ operatorId: operatorB, userId: riderId, hoursAgo: 6, tripStatus: "COMPLETED", tickets: ["USED"] });
    const reviewB = await reviews.customerCreate(rider, reviewedAtB, { rating: 5, comment: null });
    const atA = await booking({ operatorId: operatorA, userId: riderId, hoursAgo: 7, tripStatus: "COMPLETED", tickets: ["USED"] });
    const guestAtB = await booking({ operatorId: operatorB, userId: null, hoursAgo: 8, tripStatus: "COMPLETED", tickets: ["USED"] });
    const theirs = await booking({ operatorId: operatorB, userId: strangerId, hoursAgo: 9, tripStatus: "COMPLETED", tickets: ["USED"] });
    const theirReview = await reviews.customerCreate(stranger, theirs, { rating: 1, comment: "Của người khác" });
    const theirPending = await booking({ operatorId: operatorA, userId: strangerId, hoursAgo: 3, tripStatus: "COMPLETED", tickets: ["USED"] });

    const mine = await reviews.customerList(rider, { limit: 100 });
    const mineIds = mine.pending.items.map((item) => item.bookingId);
    expect(mineIds).toEqual(expect.arrayContaining([atA, atB]));
    expect(mine.pending.items.find((item) => item.bookingId === atB)!.operatorId).toBe(operatorB);
    expect(mine.reviewed.items.map((item) => item.reviewId)).toContain(reviewB.reviewId);
    for (const foreign of [guestAtB, theirs, theirPending]) {
      expect(mineIds).not.toContain(foreign);
    }
    expect(mine.reviewed.items.map((item) => item.reviewId)).not.toContain(theirReview.reviewId);

    const theirList = await reviews.customerList(stranger, { limit: 100 });
    expect(theirList.pending.items.map((item) => item.bookingId)).toEqual([theirPending]);
    expect(theirList.reviewed.items.map((item) => item.reviewId)).toEqual([theirReview.reviewId]);

    // Cursor của tài khoản khác không mở được danh sách, nhưng tổng vẫn là của chính người gọi.
    const withForeignCursor = await reviews.customerList(rider, { limit: 100, pendingCursor: theirPending, reviewedCursor: theirReview.reviewId });
    expect(withForeignCursor.pending).toEqual({ items: [], nextCursor: null, total: mine.pending.total });
    expect(withForeignCursor.reviewed).toEqual({ items: [], nextCursor: null, total: mine.reviewed.total });

    // Đi vòng qua ngữ cảnh tenant: nhà xe A không đọc được đánh giá / đơn của nhà xe B, kể cả khi quên lọc `operator_id`.
    const leaked = await prisma.withTenant(operatorA, async (tx) => ({
      reviews: await tx.review.findMany({ where: { id: reviewB.reviewId } }),
      bookings: await tx.booking.findMany({ where: { id: atB } }),
    }));
    expect(leaked).toEqual({ reviews: [], bookings: [] });
    const operatorAuthz: Authorization = { permission: "support:respond", scope: "tenant", db: tenantScope(operatorA) };
    expect((await reviews.operatorList(operatorAuthz, { limit: 100 })).items.map((item) => item.reviewId)).not.toContain(reviewB.reviewId);
  }, 60_000);

  it("phân trang: mỗi danh sách có cursor riêng, đi hết không trùng / không sót; đơn vừa được đánh giá vẫn dùng làm cursor được", async () => {
    const paged = { sub: `paged${tag}`, role: "PASSENGER", scope: "passenger", sid: randomUUID() } as VerifiedAccessToken;
    await prisma.withSystem((tx) => tx.user.create({ data: { id: paged.sub, email: `paged-${tag}@example.com`, name: "Paged" } }));
    try {
      const ids: string[] = [];
      for (const hoursAgo of [100, 101, 102, 103, 104]) {
        ids.push(await booking({ operatorId: hoursAgo % 2 ? operatorA : operatorB, userId: paged.sub, hoursAgo, tripStatus: "COMPLETED", tickets: ["USED"] }));
      }

      const first = await reviews.customerList(paged, { limit: 2 });
      expect(first.pending.items.map((item) => item.bookingId)).toEqual(ids.slice(0, 2));
      expect(first.pending.total).toBe(5);
      expect(first.pending.nextCursor).toBe(ids[1]);
      expect(first.reviewed).toEqual({ items: [], nextCursor: null, total: 0 });

      // Đơn làm cursor vừa được đánh giá: rời danh sách chờ nhưng trang sau vẫn tiếp đúng chỗ.
      const reviewOne = await reviews.customerCreate(paged, ids[1]!, { rating: 3, comment: null });
      const second = await reviews.customerList(paged, { limit: 2, pendingCursor: first.pending.nextCursor! });
      expect(second.pending.items.map((item) => item.bookingId)).toEqual(ids.slice(2, 4));
      expect(second.pending.total).toBe(4);
      const last = await reviews.customerList(paged, { limit: 2, pendingCursor: second.pending.nextCursor! });
      expect(last.pending.items.map((item) => item.bookingId)).toEqual([ids[4]]);
      expect(last.pending.nextCursor).toBeNull();

      const reviewIds = [reviewOne.reviewId];
      for (const bookingId of [ids[0]!, ids[2]!]) {
        reviewIds.unshift((await reviews.customerCreate(paged, bookingId, { rating: 5, comment: null })).reviewId);
      }
      // Trùng `created_at` thì thứ tự theo `id`: bộ `reviews` đủ ba dòng, không phụ thuộc đồng hồ.
      const page1 = await reviews.customerList(paged, { limit: 2 });
      expect(page1.reviewed.total).toBe(3);
      expect(page1.reviewed.items).toHaveLength(2);
      const page2 = await reviews.customerList(paged, { limit: 2, reviewedCursor: page1.reviewed.nextCursor! });
      expect(page2.reviewed.nextCursor).toBeNull();
      expect([...page1.reviewed.items, ...page2.reviewed.items].map((item) => item.reviewId).sort()).toEqual([...reviewIds].sort());
      // Danh sách không có cursor vẫn trả trang đầu của nó.
      expect(page2.pending.items.map((item) => item.bookingId)).toEqual(ids.filter((id) => ![ids[0], ids[1], ids[2]].includes(id)));
    } finally {
      await prisma.withSystem(async (tx) => {
        const owned = await tx.booking.findMany({ where: { userId: paged.sub }, select: { id: true } });
        const bookingId = { in: owned.map((row) => row.id) };
        await tx.review.deleteMany({ where: { bookingId } });
        await tx.ticket.deleteMany({ where: { bookingId } });
        await tx.passengerInfo.deleteMany({ where: { bookingId } });
        await tx.booking.deleteMany({ where: { id: bookingId } });
        await tx.user.deleteMany({ where: { id: paged.sub } });
      });
    }
  }, 60_000);

  it("không N+1: số câu lệnh gửi Postgres không tăng theo số dòng trả về", async () => {
    const heavy = { sub: `heavy${tag}`, role: "PASSENGER", scope: "passenger", sid: randomUUID() } as VerifiedAccessToken;
    await prisma.withSystem((tx) => tx.user.create({ data: { id: heavy.sub, email: `heavy-${tag}@example.com`, name: "Heavy" } }));
    try {
      for (const hoursAgo of [200, 201, 202, 203, 204, 205]) {
        const bookingId = await booking({ operatorId: hoursAgo % 2 ? operatorA : operatorB, userId: heavy.sub, hoursAgo, tripStatus: "COMPLETED", tickets: ["USED"], withVehicle: hoursAgo % 2 === 1 });
        if (hoursAgo >= 203) {
          await reviews.customerCreate(heavy, bookingId, { rating: 4, comment: null });
        }
      }
      const statements = vi.spyOn(Client.prototype, "query");
      const countFor = async (limit: number) => {
        statements.mockClear();
        const list = await reviews.customerList(heavy, { limit });
        return { statements: statements.mock.calls.length, rows: list.pending.items.length + list.reviewed.items.length };
      };
      const small = await countFor(1);
      const large = await countFor(50);
      statements.mockRestore();
      expect(small.rows).toBe(2);
      expect(large.rows).toBe(6);
      expect(small.statements).toBeGreaterThan(0);
      expect(large.statements).toBeLessThanOrEqual(small.statements);
    } finally {
      await prisma.withSystem(async (tx) => {
        const owned = await tx.booking.findMany({ where: { userId: heavy.sub }, select: { id: true } });
        const bookingId = { in: owned.map((row) => row.id) };
        await tx.review.deleteMany({ where: { bookingId } });
        await tx.ticket.deleteMany({ where: { bookingId } });
        await tx.passengerInfo.deleteMany({ where: { bookingId } });
        await tx.booking.deleteMany({ where: { id: bookingId } });
        await tx.user.deleteMany({ where: { id: heavy.sub } });
      });
    }
  }, 60_000);
});
