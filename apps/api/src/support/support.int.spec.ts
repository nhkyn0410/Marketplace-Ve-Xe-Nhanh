import { randomUUID } from "node:crypto";
import Redis from "ioredis";
import { afterAll, beforeAll, describe, expect, it, vi } from "vitest";
import { type AuditEventInput, AuditService } from "../audit/audit.service";
import { BookingService } from "../booking/booking.service";
import { BookingInputSchema } from "../booking/dto/booking.dto";
import { parseAppConfig } from "../config/env.config";
import { platformScope, tenantScope } from "../database/db-scope";
import { PrismaService } from "../database/prisma.service";
import { loadPublicOperatorProfile } from "../database/public-operator-profile";
import { PassengerProfileService } from "../iam/user/passenger-profile.service";
import { escalateOverdueDisputes } from "../dispute/dispute-overdue";
import { DisputeService } from "../dispute/dispute.service";
import type { StorageProvider } from "../external/storage/storage-provider";
import type { Coordinates, RouteLeg, RoutingProvider } from "../external/routing/routing-provider";
import type { VerifiedAccessToken } from "../iam/auth/token.service";
import type { Authorization } from "../iam/role/authorization";
import type { NotificationDispatcher } from "../notification/notification-dispatcher";
import { applyPaymentCallback } from "../payment/payment-callback";
import { createRequestRedisClientOptions, getRedisUrl } from "../redis/redis.config";
import { completeRefund } from "../refund/refund-processing";
import { ReviewService } from "../review/review.service";
import { RouteInputSchema } from "../route/dto/route.dto";
import { RouteService } from "../route/route.service";
import { SeatHoldInputSchema } from "../seat-hold/dto/seat-hold.dto";
import { SeatHoldService } from "../seat-hold/seat-hold.service";
import { TicketQrSigner } from "../ticket/ticket-qr";
import { TripInputSchema } from "../trip/dto/trip.dto";
import { TripService } from "../trip/trip.service";
import { SeatMapInputSchema } from "../vehicle/dto/seat-map.dto";
import { VehicleInputSchema } from "../vehicle/dto/vehicle.dto";
import { SeatMapService } from "../vehicle/seat-map.service";
import { VehicleService } from "../vehicle/vehicle.service";
import { SupportAttachmentService } from "./support-attachments";
import { SupportService } from "./support.service";

/**
 * TASK-TRUST-001 trên Postgres + Redis THẬT (role app): khiếu nại của khách vãng lai (mã truy cập) → Admin phân loại chuyển nhà xe
 * → nhà xe phản hồi; cô lập tenant / khiếu nại chưa chuyển; tệp minh chứng (khóa của bên khác bị từ chối); chuyển tranh chấp →
 * yêu cầu minh chứng, mỗi bên chỉ thấy minh chứng của mình, quá hạn → leo thang; quyết định hoàn tiền (giới hạn phần đã trả, refund
 * + sổ giữ hộ khi hoàn xong, không quyết hai lần); đánh giá (BR-18) + kiểm duyệt (BR-55).
 */
const url = process.env.DATABASE_URL;
const ready = Boolean(url && process.env.REDIS_URL);
const requireDb = process.env.REQUIRE_DB_TESTS === "1";
const HOUR = 3_600_000;
const PDF = Uint8Array.from(Buffer.from("%PDF-1.7\n"));

async function rejectionOf(promise: Promise<unknown>): Promise<{ status?: number; code?: string }> {
  try {
    await promise;
    return {};
  } catch (error) {
    const response = (error as { getResponse?: () => { code?: string } }).getResponse?.();
    return { status: (error as { getStatus?: () => number }).getStatus?.(), code: response?.code };
  }
}

class FakeRouting implements RoutingProvider {
  readonly source = "GOONG" as const;
  async measureLegs(points: Coordinates[]): Promise<RouteLeg[]> {
    return points.slice(1).map(() => ({ distanceMeters: 100_000, durationSeconds: 3 * 3600 }));
  }
}

/** Kho riêng tư giả: object "đã tải" là PDF vừa xong. */
function fakeStorage(): StorageProvider {
  return {
    createUploadUrl: async (input) => ({ uploadUrl: `https://upload.test/${input.key}`, expiresAt: new Date(Date.now() + 300_000) }),
    head: async () => ({ sizeBytes: 2048, contentType: "application/pdf", lastModified: new Date() }),
    readStart: async () => PDF,
    delete: async () => undefined,
    list: async function* () {},
    publicUrl: (key) => key,
    createDownloadUrl: async (input) => ({ url: `https://download.test/${input.key}`, expiresAt: new Date(Date.now() + 300_000) }),
  };
}

describe.skipIf(!ready && !requireDb)("Khiếu nại, tranh chấp, đánh giá — Postgres + Redis thật (TRUST-001)", () => {
  let prisma: PrismaService;
  let redis: Redis;
  let holds: SeatHoldService;
  let bookings: BookingService;
  let trips: TripService;
  let support: SupportService;
  let disputes: DisputeService;
  let reviews: ReviewService;
  const events: AuditEventInput[] = [];
  const audit = { recordAuditEvent: vi.fn(async (event: AuditEventInput) => void events.push(event)) } as unknown as AuditService;
  const dispatch = vi.fn(async () => undefined);
  const refundQueue = { add: vi.fn(async () => ({})) };
  const qr = new TicketQrSigner(Buffer.alloc(32, 10));
  const tag = randomUUID().slice(0, 8);
  const operatorId = randomUUID();
  const otherOperatorId = randomUUID();
  const province = randomUUID();
  const ward = randomUUID();
  const points = [randomUUID(), randomUUID(), randomUUID()];
  const vehicleType = randomUUID();
  const adminId = randomUUID();
  const ownerId = randomUUID();
  const userId = `trust${tag}`;
  const admin = { sub: adminId, role: "PLATFORM_ADMIN" } as VerifiedAccessToken;
  const owner = { sub: ownerId, role: "OPERATOR_OWNER" } as VerifiedAccessToken;
  const passenger = { sub: userId, role: "PASSENGER", scope: "passenger", sid: randomUUID() } as VerifiedAccessToken;
  const ownerAuthz: Authorization = { permission: "trip:manage", scope: "tenant", db: tenantScope(operatorId) };
  const operatorAuthz: Authorization = { permission: "support:respond", scope: "tenant", db: tenantScope(operatorId) };
  const strangerAuthz: Authorization = { permission: "support:respond", scope: "tenant", db: tenantScope(otherOperatorId) };
  const platformAuthz: Authorization = { permission: "support:manage", scope: "any", db: platformScope() };
  let routeId: string;
  let seatMapId: string;

  /** Chuyến mở bán sau `hoursAhead` giờ, một đơn đã thanh toán VNPay (300.000 ₫ / chỗ). `user` = hành khách, `null` = khách vãng lai. */
  async function paidBooking(hoursAhead: number, seatCodes: string[], user: VerifiedAccessToken | null) {
    const vehicle = await new VehicleService(prisma, {} as never).create(
      ownerAuthz,
      VehicleInputSchema.parse({ plateNumber: `51F${10000 + Math.floor(Math.random() * 89999)}`, vehicleTypeId: vehicleType, seatMapId, amenityIds: [], status: "ACTIVE", description: null }),
    );
    const departureAt = new Date(Date.now() + hoursAhead * HOUR);
    const trip = await trips.create(
      ownerAuthz,
      TripInputSchema.parse({ routeId, vehicleId: vehicle.id, departureAt: departureAt.toISOString(), stopTimes: null, onlineSaleCutoffMinutes: 60, note: null }),
    );
    await prisma.withSystem((tx) => tx.trip.update({ where: { id: trip.id }, data: { status: "OPEN_FOR_SALE" } }));
    const hold = await holds.create(user, undefined, SeatHoldInputSchema.parse({ tripId: trip.id, seatCodes, pickupSequence: 1, dropoffSequence: 3 }));
    const total = 300_000 * seatCodes.length;
    const created = await bookings.create(
      user,
      BookingInputSchema.parse({
        holdId: hold.holdId,
        contact: { fullName: "Nguyễn Văn Khánh", phone: "0901234567", email: `k-${tag}@example.com` },
        passengers: seatCodes.map((seatCode) => ({ seatCode, fullName: `Khách ${seatCode}`, phone: null })),
        note: null,
        expectedTotal: total,
      }),
    );
    const paymentCode = `PAY${randomUUID().replace(/-/g, "").slice(0, 12).toUpperCase()}`;
    await prisma.withTenant(operatorId, (tx) =>
      tx.payment.create({ data: { paymentCode, operatorId, bookingId: created.bookingId, provider: "VNPAY", status: "PROCESSING", amount: BigInt(total), expiresAt: new Date(Date.now() + 600_000) } }),
    );
    expect(await applyPaymentCallback(prisma, { provider: "VNPAY", paymentCode, providerTxnId: `T${randomUUID().slice(0, 10)}`, amount: String(total), success: true, resultCode: "00", fields: {} }, qr)).toBe("SUCCESS");
    return { tripId: trip.id, bookingId: created.bookingId, token: created.accessToken };
  }

  beforeAll(async () => {
    prisma = new PrismaService(parseAppConfig({ DATABASE_URL: url }));
    redis = new Redis(getRedisUrl(), createRequestRedisClientOptions("trust-test"));
    holds = new SeatHoldService(prisma, redis);
    bookings = new BookingService(prisma, holds, qr);
    trips = new TripService(prisma, {} as AuditService);
    const attachments = new SupportAttachmentService(fakeStorage(), audit);
    const notifier = { dispatch } as unknown as NotificationDispatcher;
    support = new SupportService(prisma, audit, attachments, notifier);
    disputes = new DisputeService(prisma, audit, attachments, notifier, refundQueue as unknown as ConstructorParameters<typeof DisputeService>[4]);
    reviews = new ReviewService(prisma, audit);
    await prisma.withSystem(async (tx) => {
      await tx.operatorProfile.createMany({
        data: [
          { id: operatorId, operatorSlug: `tr-${tag}`, displayName: `Nhà xe hỗ trợ ${tag}` },
          { id: otherOperatorId, operatorSlug: `tr2-${tag}`, displayName: `Nhà xe khác ${tag}` },
        ],
      });
      await tx.operatorAccount.create({ data: { id: ownerId, operatorId, operatorSlug: `tr-${tag}`, username: `owner-${tag}`, passwordHash: "x", role: "OPERATOR_OWNER", contactEmail: `owner-${tag}@example.com` } });
      await tx.platformAccount.create({ data: { id: adminId, username: `trust-${tag}`, passwordHash: "x", role: "PLATFORM_ADMIN" } });
      await tx.user.create({ data: { id: userId, email: `rider-${tag}@example.com`, name: "Rider" } });
      await tx.province.create({ data: { id: province, code: `tp-${tag}`, name: "Tỉnh" } });
      await tx.ward.create({ data: { id: ward, provinceId: province, code: `tw-${tag}`, name: "Phường" } });
      await tx.stopPointCatalog.createMany({
        data: points.map((id, index) => ({
          id,
          name: `Bến ${index} ${tag}`,
          type: index === 1 ? ("REST_STOP" as const) : ("BUS_STATION" as const),
          legalBasis: index === 1 ? null : "QĐ (test)",
          address: "Địa chỉ",
          provinceId: province,
          wardId: ward,
          latitude: 10 + index,
          longitude: 106,
        })),
      });
      await tx.vehicleType.create({ data: { id: vehicleType, code: `TR-${tag}`, name: "Giường", form: "SLEEPER", class: "STANDARD" } });
    });
    routeId = (
      await new RouteService(prisma, new FakeRouting()).create(
        ownerAuthz,
        RouteInputSchema.parse({
          name: `Tuyến hỗ trợ ${tag}`,
          status: "ACTIVE",
          note: null,
          stops: points.map((point, index) => ({ catalogStopPointId: point, stopPointId: null, note: null, allowPickup: index === 0, allowDropoff: index === 2 })),
        }),
      )
    ).id;
    await prisma.withSystem(async (tx) => {
      const fare = await tx.fare.create({ data: { operatorId, routeId, status: "ACTIVE" } });
      await tx.fareRule.create({ data: { operatorId, fareId: fare.id, price: 300_000n } });
    });
    seatMapId = (
      await new SeatMapService(prisma).create(
        ownerAuthz,
        SeatMapInputSchema.parse({
          name: `Sơ đồ ${tag}`,
          layout: { decks: [{ deck: 1, rows: 2, columns: 2 }] },
          seats: ["A1", "A2", "A3", "A4"].map((code, index) => ({ code, deck: 1, row: Math.floor(index / 2) + 1, column: (index % 2) + 1, type: "BED" })),
        }),
      )
    ).id;
  }, 90_000);

  afterAll(async () => {
    if (!prisma) {
      return;
    }
    await prisma.withSystem(async (tx) => {
      await tx.$executeRaw`SELECT set_config('app.allow_ledger_delete', 'on', true)`;
      await tx.review.deleteMany({ where: { operatorId } });
      await tx.supportAttachment.deleteMany({ where: { operatorId } });
      await tx.disputeEvent.deleteMany({ where: { operatorId } });
      await tx.disputeCase.deleteMany({ where: { operatorId } });
      await tx.supportMessage.deleteMany({ where: { operatorId } });
      await tx.supportTicket.deleteMany({ where: { operatorId } });
      await tx.notificationDelivery.deleteMany({ where: { operatorId } });
      await tx.notification.deleteMany({ where: { operatorId } });
      // `generatePayouts` ở payout.int.spec quét mọi nhà xe: chạy song song có thể tạo kỳ chi trả từ bút toán của file này.
      await tx.payoutItem.deleteMany({ where: { operatorId } });
      await tx.escrowLedger.deleteMany({ where: { operatorId } });
      await tx.payoutStatusHistory.deleteMany({ where: { operatorId } });
      await tx.payout.deleteMany({ where: { operatorId } });
      await tx.ticketStatusHistory.deleteMany({ where: { operatorId } });
      await tx.ticket.deleteMany({ where: { operatorId } });
      await tx.refundStatusHistory.deleteMany({ where: { operatorId } });
      await tx.refund.deleteMany({ where: { operatorId } });
      await tx.paymentStatusHistory.deleteMany({ where: { operatorId } });
      await tx.payment.deleteMany({ where: { operatorId } });
      await tx.tripSeat.updateMany({ where: { operatorId }, data: { bookingId: null } });
      await tx.bookingStatusHistory.deleteMany({ where: { operatorId } });
      await tx.passengerInfo.deleteMany({ where: { operatorId } });
      await tx.booking.deleteMany({ where: { operatorId } });
      await tx.tripSeat.deleteMany({ where: { operatorId } });
      await tx.tripStop.deleteMany({ where: { operatorId } });
      await tx.trip.deleteMany({ where: { operatorId } });
      await tx.fareRule.deleteMany({ where: { operatorId } });
      await tx.fare.deleteMany({ where: { operatorId } });
      await tx.routeStop.deleteMany({ where: { operatorId } });
      await tx.route.deleteMany({ where: { operatorId } });
      await tx.vehicle.deleteMany({ where: { operatorId } });
      await tx.seat.deleteMany({ where: { operatorId } });
      await tx.seatMap.deleteMany({ where: { operatorId } });
      await tx.operatorAccount.deleteMany({ where: { operatorId } });
      await tx.operatorLoginName.deleteMany({ where: { operatorId } });
      await tx.user.deleteMany({ where: { id: userId } });
      await tx.platformAccount.deleteMany({ where: { id: adminId } });
      await tx.stopPointCatalog.deleteMany({ where: { provinceId: province } });
      await tx.ward.deleteMany({ where: { provinceId: province } });
      await tx.province.deleteMany({ where: { id: province } });
      await tx.vehicleType.deleteMany({ where: { id: vehicleType } });
      await tx.operatorProfile.deleteMany({ where: { id: { in: [operatorId, otherOperatorId] } } });
    });
    await prisma.$disconnect();
    redis.disconnect();
  });

  it("khiếu nại → phân loại chuyển nhà xe → nhà xe phản hồi → yêu cầu khách bổ sung → khách trả lời; tenant / chưa chuyển → 404; tệp của bên khác bị từ chối", async () => {
    const booking = await paidBooking(30, ["A1", "A2"], null);
    expect(await rejectionOf(support.customerList(null, booking.bookingId, undefined))).toMatchObject({ status: 404 });
    expect(await rejectionOf(support.customerList(null, booking.bookingId, "sai-ma"))).toMatchObject({ status: 404 });

    const upload = await support.customerUpload(null, booking.bookingId, booking.token, { contentType: "application/pdf", sizeBytes: 2048 });
    expect(upload.objectKey).toMatch(new RegExp(`^support/${operatorId}/b-${booking.bookingId}/[0-9a-f-]{36}\\.pdf$`));
    const ticket = await support.customerCreate(null, booking.bookingId, booking.token, {
      category: "PAYMENT_REFUND",
      priority: "MEDIUM",
      subject: "Bị trừ tiền hai lần cho một đơn",
      body: "Tài khoản bị trừ hai lần.",
      attachments: [{ objectKey: upload.objectKey, fileName: "sao-ke.pdf" }],
    });
    expect(ticket).toMatchObject({ status: "NEW", reporterParty: "GUEST", reporterName: "Nguyễn Văn K***", validTickets: 2 });
    expect(ticket.ticketCode).toMatch(/^KN-\d{8}-\d{3,}$/);
    expect(ticket.messages[0]!.attachments).toEqual([expect.objectContaining({ fileName: "sao-ke.pdf", sizeBytes: 2048, contentType: "application/pdf" })]);
    // Khóa của nơi tải khác (nhà xe) không gắn được vào lượt trao đổi của khách.
    const foreign = await support.operatorUpload(operatorAuthz, { contentType: "application/pdf", sizeBytes: 10 });
    expect(await rejectionOf(support.customerReply(null, booking.bookingId, booking.token, ticket.ticketId, { body: "x", attachments: [{ objectKey: foreign.objectKey, fileName: "a.pdf" }] }))).toMatchObject({
      status: 422,
      code: "SUPPORT_ATTACHMENT_INVALID",
    });

    // Chưa chuyển nhà xe → nhà xe không thấy.
    expect((await support.operatorList(operatorAuthz, { limit: 20 })).items).toEqual([]);
    expect(await rejectionOf(support.operatorGet(operatorAuthz, ticket.ticketId))).toMatchObject({ status: 404 });
    const queue = await support.adminList(platformAuthz, { operatorId, status: "NEW", limit: 20 });
    expect(queue.items.map((item) => item.ticketId)).toEqual([ticket.ticketId]);
    expect(queue.unclassified).toBeGreaterThanOrEqual(1);

    const classified = await support.classify(platformAuthz, admin, ticket.ticketId, { category: "SERVICE_QUALITY", priority: "HIGH", handler: "OPERATOR", assigneeId: adminId });
    expect(classified).toMatchObject({ status: "WAITING_OPERATOR", handler: "OPERATOR", priority: "HIGH", assignee: { id: adminId, username: `platform/trust-${tag}` } });
    expect(events.at(-1)).toMatchObject({ action: "support.ticket.classify", targetId: ticket.ticketId, operatorId });
    expect(dispatch).toHaveBeenLastCalledWith([expect.stringMatching(/^CASE_UPDATED:/)]);
    expect(await rejectionOf(support.classify(platformAuthz, admin, ticket.ticketId, { category: "OTHER", priority: "LOW", handler: "PLATFORM", assigneeId: randomUUID() }))).toMatchObject({ status: 422 });

    const seen = await support.operatorGet(operatorAuthz, ticket.ticketId);
    expect([seen.contactEmailMasked, seen.assignee]).toEqual([null, null]);
    expect(await rejectionOf(support.operatorGet(strangerAuthz, ticket.ticketId))).toMatchObject({ status: 404 });
    const replied = await support.operatorReply(operatorAuthz, owner, ticket.ticketId, { body: "Nhà xe đã kiểm tra.", attachments: [] });
    expect(replied.status).toBe("IN_PROGRESS");
    const customerView = await support.customerGet(null, booking.bookingId, booking.token, ticket.ticketId);
    expect(customerView.messages.map((message) => [message.party, message.authorName])).toEqual([
      ["GUEST", "Nguyễn Văn K***"],
      ["OPERATOR", `Nhà xe hỗ trợ ${tag}`],
    ]);

    const asked = await support.adminReply(platformAuthz, admin, ticket.ticketId, { body: "Gửi thêm ảnh sao kê.", attachments: [], requestInfo: true });
    expect(asked.status).toBe("WAITING_CUSTOMER");
    expect(asked.messages.at(-1)).toMatchObject({ party: "PLATFORM", authorName: `platform/trust-${tag}` });
    expect((await support.customerGet(null, booking.bookingId, booking.token, ticket.ticketId)).messages.at(-1)!.authorName).toBe("CSKH Vé Xe Nhanh");
    expect((await support.customerReply(null, booking.bookingId, booking.token, ticket.ticketId, { body: "Đã gửi.", attachments: [] })).status).toBe("IN_PROGRESS");
    expect(await prisma.withSystem((tx) => tx.notification.count({ where: { operatorId, kind: "CASE_UPDATED" } }))).toBeGreaterThanOrEqual(3);

    const download = await support.customerDownload(null, booking.bookingId, booking.token, ticket.messages[0]!.attachments[0]!.attachmentId);
    expect(download.url).toContain("download.test");
    expect(events.at(-1)).toMatchObject({ action: "support.attachment.view", operatorId });
  }, 60_000);

  it("tranh chấp: mở từ khiếu nại (lần hai 409), yêu cầu minh chứng, mỗi bên chỉ thấy minh chứng của mình, quá hạn → leo thang; quyết định hoàn tiền giới hạn phần đã trả, refund + sổ giữ hộ, không quyết hai lần; đóng", async () => {
    const booking = await paidBooking(40, ["A1", "A2"], null);
    const ticket = await support.customerCreate(null, booking.bookingId, booking.token, { category: "SCHEDULE", priority: "MEDIUM", subject: "Xe khởi hành trễ 45 phút", body: "Trễ.", attachments: [] });
    const opened = await disputes.escalate(platformAuthz, admin, ticket.ticketId, { title: null, customerRequest: "Hoàn một phần", reason: "Hai bên không thống nhất" });
    expect(opened).toMatchObject({ status: "OPEN", title: "Xe khởi hành trễ 45 phút", customerRequest: "Hoàn một phần", supportTicketCode: ticket.ticketCode, paidAmount: 600_000, refundableAmount: 600_000 });
    expect(opened.disputeCode).toMatch(/^DC-\d{6,}$/);
    expect((await support.adminGet(platformAuthz, ticket.ticketId)).status).toBe("ESCALATED");
    expect(await rejectionOf(disputes.escalate(platformAuthz, admin, ticket.ticketId, { title: null, customerRequest: null, reason: "Lần nữa" }))).toMatchObject({ status: 409 });

    expect(await rejectionOf(disputes.requestEvidence(platformAuthz, admin, opened.disputeId, { party: "OPERATOR", message: "Gửi nhật trình", dueAt: new Date(Date.now() - HOUR).toISOString() }))).toMatchObject({ status: 409 });
    const waiting = await disputes.requestEvidence(platformAuthz, admin, opened.disputeId, { party: "OPERATOR", message: "Gửi nhật trình chuyến", dueAt: new Date(Date.now() + 24 * HOUR).toISOString() });
    expect(waiting.status).toBe("WAITING_OPERATOR_RESPONSE");
    const file = await support.operatorUpload(operatorAuthz, { contentType: "application/pdf", sizeBytes: 480 });
    const responded = await disputes.operatorRespond(operatorAuthz, owner, opened.disputeId, { body: "Xe gặp kẹt xe.", attachments: [{ objectKey: file.objectKey, fileName: "nhat-trinh.pdf" }] });
    expect(responded.status).toBe("UNDER_REVIEW");
    await disputes.customerRespond(null, booking.bookingId, booking.token, opened.disputeId, { body: "Không có thông báo.", attachments: [] });
    const operatorView = await disputes.operatorGet(operatorAuthz, opened.disputeId);
    const customerView = await disputes.customerGet(null, booking.bookingId, booking.token, opened.disputeId);
    expect(operatorView.events.filter((event) => event.kind === "EVIDENCE").map((event) => event.party)).toEqual(["OPERATOR"]);
    expect(customerView.events.filter((event) => event.kind === "EVIDENCE").map((event) => event.party)).toEqual(["GUEST"]);
    expect(customerView.events.some((event) => event.kind === "REQUEST")).toBe(false);
    expect((await disputes.adminGet(platformAuthz, opened.disputeId)).events.filter((event) => event.kind === "EVIDENCE")).toHaveLength(2);
    expect(await rejectionOf(disputes.operatorGet(strangerAuthz, opened.disputeId))).toMatchObject({ status: 404 });
    // Nhà xe không tải được minh chứng của khách bằng id (kể cả biết id).
    const operatorAttachment = operatorView.events.find((event) => event.kind === "EVIDENCE")!.attachments[0]!;
    expect((await support.operatorDownload(operatorAuthz, owner, operatorAttachment.attachmentId)).url).toContain("download.test");

    // Quá hạn (FR-DSP-05).
    await disputes.requestEvidence(platformAuthz, admin, opened.disputeId, { party: "PASSENGER", message: "Gửi ảnh điểm đón", dueAt: new Date(Date.now() + HOUR).toISOString() });
    await prisma.withSystem((tx) => tx.disputeCase.update({ where: { id: opened.disputeId }, data: { responseDueAt: new Date(Date.now() - 60_000) } }));
    expect((await disputes.adminList(platformAuthz, { due: "overdue", operatorId, limit: 20 })).items.map((item) => [item.disputeId, item.overdue])).toEqual([[opened.disputeId, true]]);
    expect(await escalateOverdueDisputes(prisma, audit)).toBeGreaterThanOrEqual(1);
    const escalated = await disputes.adminGet(platformAuthz, opened.disputeId);
    expect(escalated.status).toBe("ESCALATED");
    expect(escalated.events.at(-1)).toMatchObject({ party: "SYSTEM", fromStatus: "WAITING_USER_EVIDENCE", toStatus: "ESCALATED" });

    // Quyết định hoàn tiền: vượt phần đã trả → 422; hợp lệ → refund APPROVED + hàng đợi; quyết định lần hai → 409.
    expect(await rejectionOf(disputes.decide(platformAuthz, admin, opened.disputeId, { decision: "REFUND", amount: 600_001, reason: "Hoàn theo minh chứng" }))).toMatchObject({ status: 422, code: "DISPUTE_REFUND_INVALID" });
    const decided = await disputes.decide(platformAuthz, admin, opened.disputeId, { decision: "REFUND", amount: 270_000, reason: "Xe trễ không thông báo" });
    expect(decided).toMatchObject({ status: "RESOLVED_REFUND", decision: { decision: "REFUND", amount: 270_000, refund: { status: "APPROVED" } }, refundableAmount: 330_000 });
    const refundId = decided.decision!.refund!.refundId;
    expect(refundQueue.add).toHaveBeenCalledWith("refund", { refundId }, expect.objectContaining({ jobId: refundId }));
    expect((await support.adminGet(platformAuthz, ticket.ticketId)).status).toBe("RESOLVED");
    expect(await rejectionOf(disputes.decide(platformAuthz, admin, opened.disputeId, { decision: "NO_REFUND", amount: null, reason: "Đổi ý" }))).toMatchObject({ status: 409 });
    const state = await prisma.withSystem(async (tx) => ({
      refund: await tx.refund.findUniqueOrThrow({ where: { id: refundId }, select: { amount: true, refundPercent: true, requestedBy: true } }),
      booking: await tx.booking.findUniqueOrThrow({ where: { id: booking.bookingId }, select: { status: true } }),
    }));
    expect(state).toEqual({ refund: { amount: 270_000n, refundPercent: 45, requestedBy: `platform:${adminId}` }, booking: { status: "REFUND_PENDING" } });

    // Cổng xác nhận hoàn → tiền ra khỏi sổ giữ hộ của nhà xe; vé vẫn hiệu lực nên đơn về "đã xác nhận".
    await prisma.withTenant(operatorId, (tx) => completeRefund(tx, operatorId, refundId, { from: "APPROVED", data: { providerRefundId: "RF1" }, reason: "Cổng xác nhận", actor: "system", at: new Date() }));
    const after = await prisma.withSystem(async (tx) => ({
      ledger: await tx.escrowLedger.findMany({ where: { refundId }, orderBy: { amount: "asc" }, select: { entryType: true, amount: true } }),
      booking: await tx.booking.findUniqueOrThrow({ where: { id: booking.bookingId }, select: { status: true } }),
    }));
    expect(after.ledger[0]).toEqual({ entryType: "REFUND", amount: -270_000n });
    expect(after.booking.status).toBe("CONFIRMED");

    const closed = await disputes.setStatus(platformAuthz, admin, opened.disputeId, { status: "CLOSED", reason: "Đã hoàn xong" });
    expect(closed.status).toBe("CLOSED");
    expect((await support.adminGet(platformAuthz, ticket.ticketId)).status).toBe("CLOSED");
    expect(await rejectionOf(disputes.operatorRespond(operatorAuthz, owner, opened.disputeId, { body: "Thêm", attachments: [] }))).toMatchObject({ status: 409 });
  }, 60_000);

  it("mở tranh chấp trực tiếp từ đơn; danh sách /me chỉ có tài nguyên của hành khách, cursor tài khoản khác không dùng được", async () => {
    const mine = await paidBooking(55, ["A1"], passenger);
    const guest = await paidBooking(56, ["A1"], null);
    const ticket = await support.customerCreate(passenger, mine.bookingId, undefined, { category: "SCHEDULE", priority: "MEDIUM", subject: "Xe thay đổi điểm đón", body: "Xin hỗ trợ.", attachments: [] });
    const opened = await disputes.openFromBooking(platformAuthz, admin, { bookingId: mine.bookingId, title: "Mở từ đơn thanh toán", customerRequest: null, reason: "Cần phân xử trực tiếp" });
    expect(opened).toMatchObject({ bookingId: mine.bookingId, status: "OPEN", supportTicketId: null });
    expect(await rejectionOf(disputes.openFromBooking(platformAuthz, admin, { bookingId: mine.bookingId, title: "Gửi lặp lại", customerRequest: null, reason: "Lặp lại yêu cầu" }))).toMatchObject({ status: 409 });
    const profiles = new PassengerProfileService(prisma);
    const bookingsPage = await profiles.bookings(passenger, { limit: 100 });
    expect(bookingsPage.items.some((item) => item.bookingId === mine.bookingId)).toBe(true);
    expect(bookingsPage.items.some((item) => item.bookingId === guest.bookingId)).toBe(false);
    expect(await profiles.bookings(passenger, { limit: 20, cursor: guest.bookingId })).toEqual({ items: [], nextCursor: null });
    expect((await profiles.tickets(passenger, { limit: 100 })).items.filter((item) => item.bookingId === mine.bookingId)).toHaveLength(1);
    expect((await profiles.supportTickets(passenger, { limit: 100 })).items.map((item) => item.ticketId)).toContain(ticket.ticketId);
    expect((await profiles.disputes(passenger, { limit: 100 })).items.map((item) => item.disputeId)).toContain(opened.disputeId);
    const stranger = { ...passenger, sub: "different-account" };
    for (const method of ["bookings", "tickets", "supportTickets", "disputes"] as const) expect((await profiles[method](stranger, { limit: 20 })).items).toEqual([]);
  }, 60_000);

  it("đánh giá: chỉ hành khách, chuyến đã hoàn thành + đã đi, một lần; nhà xe phản hồi / báo cáo → Admin cần xem xét; ẩn → không tính điểm", async () => {
    const guest = await paidBooking(50, ["A1"], null);
    const mine = await paidBooking(60, ["A1"], passenger);
    expect(await rejectionOf(reviews.customerGet(passenger, guest.bookingId))).toMatchObject({ status: 404 });
    expect((await reviews.customerGet(passenger, mine.bookingId)).canReview).toBe(false);
    expect(await rejectionOf(reviews.customerCreate(passenger, mine.bookingId, { rating: 5, comment: null }))).toMatchObject({ status: 409, code: "REVIEW_NOT_ALLOWED" });

    await prisma.withSystem(async (tx) => {
      await tx.trip.update({ where: { id: mine.tripId }, data: { status: "COMPLETED", completedAt: new Date() } });
      await tx.ticket.updateMany({ where: { bookingId: mine.bookingId }, data: { status: "USED" } });
    });
    expect((await reviews.customerGet(passenger, mine.bookingId)).canReview).toBe(true);
    const review = await reviews.customerCreate(passenger, mine.bookingId, { rating: 2, comment: "Liên hệ 0912 345 678 để mua vé rẻ hơn!!!!!" });
    expect(review).toMatchObject({ rating: 2, status: "VISIBLE", authorName: "Nguyễn Văn K***", signals: [] });
    expect(await rejectionOf(reviews.customerCreate(passenger, mine.bookingId, { rating: 4, comment: null }))).toMatchObject({ status: 409 });

    const list = await reviews.operatorList(operatorAuthz, { limit: 20 });
    expect([list.items.map((item) => item.reviewId), list.average, list.validCount]).toEqual([[review.reviewId], 2, 1]);
    const publicProfile = await loadPublicOperatorProfile(prisma, operatorId, { limit: 20 }, new Date(), (key) => key);
    expect(publicProfile?.scorecard).toMatchObject({ averageRating: 2, reviewCount: 1 });
    expect(publicProfile?.reviews.map((item) => item.reviewId)).toEqual([review.reviewId]);
    expect(publicProfile).not.toHaveProperty("taxCode");
    expect(publicProfile).not.toHaveProperty("bankAccounts");
    expect(publicProfile).not.toHaveProperty("kycDocuments");
    expect((await reviews.operatorList(strangerAuthz, { limit: 20 })).items).toEqual([]);
    expect((await reviews.reply(operatorAuthz, owner, review.reviewId, { reply: "Cảm ơn góp ý." })).operatorReply).toBe("Cảm ơn góp ý.");
    expect((await reviews.operatorList(operatorAuthz, { replied: "no", limit: 20 })).items).toEqual([]);
    await reviews.report(operatorAuthz, owner, review.reviewId, { reason: "Quảng cáo số điện thoại" });
    expect(await rejectionOf(reviews.report(operatorAuthz, owner, review.reviewId, { reason: "Lần nữa" }))).toMatchObject({ status: 409 });

    const moderationAuthz: Authorization = { permission: "content:moderate", scope: "any", db: platformScope() };
    const attention = await reviews.adminList(moderationAuthz, { status: "attention", operatorId, limit: 20 });
    expect(attention.items.find((item) => item.reviewId === review.reviewId)?.signals).toEqual(["SPAM", "OPERATOR_REPORTED", "REPEATED"]);
    const hidden = await reviews.moderate(moderationAuthz, admin, review.reviewId, { action: "HIDE", reason: "Quảng cáo, vi phạm chính sách" });
    expect(hidden).toMatchObject({ status: "HIDDEN", moderationReason: "Quảng cáo, vi phạm chính sách" });
    expect(events.at(-1)).toMatchObject({ action: "review.moderate", targetId: review.reviewId, before: { status: "VISIBLE" }, after: { status: "HIDDEN" } });
    const afterHide = await reviews.operatorList(operatorAuthz, { limit: 20 });
    expect([afterHide.items, afterHide.average, afterHide.validCount]).toEqual([[], null, 0]);
    const hiddenPublic = await loadPublicOperatorProfile(prisma, operatorId, { limit: 20 }, new Date(), (key) => key);
    expect(hiddenPublic?.scorecard).toMatchObject({ averageRating: null, reviewCount: 0 });
    expect(hiddenPublic?.reviews).toEqual([]);
    expect((await reviews.adminList(moderationAuthz, { status: "attention", operatorId, limit: 20 })).items).toEqual([]);
    expect(await rejectionOf(reviews.reply(operatorAuthz, owner, review.reviewId, { reply: "Sửa" }))).toMatchObject({ status: 404 });
  }, 60_000);
});
