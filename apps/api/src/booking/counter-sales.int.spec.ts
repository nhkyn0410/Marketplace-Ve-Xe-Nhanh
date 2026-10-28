import { randomUUID } from "node:crypto";
import Redis from "ioredis";
import { afterAll, beforeAll, describe, expect, it, vi } from "vitest";
import { CounterBookingInputSchema, CounterHoldInputSchema, CounterReceiptInputSchema } from "@vexenhanh/types";
import { parseAppConfig } from "../config/env.config";
import { platformScope, tenantScope } from "../database/db-scope";
import { PrismaService } from "../database/prisma.service";
import type { Authorization } from "../iam/role/authorization";
import { CounterCommissionService } from "../commission/counter-commission.service";
import { SalesOfficeService } from "../operator/sales-office.service";
import { SeatHoldService } from "../seat-hold/seat-hold.service";
import { TicketQrSigner } from "../ticket/ticket-qr";
import { OperatorDepartureService } from "../trip/operator-departure.service";
import { BookingService } from "./booking.service";
import { hashBookingToken } from "./booking-access";
import { PaymentService } from "../payment/payment.service";
import { CounterSalesService } from "./counter-sales.service";

const ready = Boolean(process.env.DATABASE_URL && process.env.REDIS_URL);
const required = process.env.REQUIRE_DB_TESTS === "1";
const authz = (operatorId: string, permission: Authorization["permission"]): Authorization => ({ permission, scope: "tenant", db: tenantScope(operatorId) });
async function codeOf(promise: Promise<unknown>) { try { await promise; return null; } catch (error) { return (error as { getResponse?: () => { code?: string } }).getResponse?.().code; } }

describe.skipIf(!ready && !required)("Bán vé quầy — Postgres APP + Redis thật", () => {
  let prisma: PrismaService; let redis: Redis; let publicHolds: SeatHoldService; let sales: CounterSalesService; let offices: SalesOfficeService; let departures: OperatorDepartureService; let qr: TicketQrSigner;
  const a = randomUUID(); const b = randomUUID(); const employee = randomUUID(); const another = randomUUID(); const driver = randomUUID();
  const tag = randomUUID().slice(0, 8); const routeId = randomUUID(); const typeId = randomUUID(); const mapId = randomUUID();
  const owner = { sub: randomUUID(), role: "OPERATOR_OWNER" }; const staff = { sub: employee, role: "SALES_STAFF" }; const coworker = { sub: another, role: "SALES_STAFF" };
  const audit = { recordAuditEvent: vi.fn(async () => undefined) };
  const pointIds = [randomUUID(), randomUUID()]; let firstOffice: string; let secondOffice: string; let seq = 10000;
  const read = authz(a, "counter:read"); const sell = authz(a, "counter:sell"); const collect = authz(a, "counter:collect");

  beforeAll(async () => {
    prisma = new PrismaService(parseAppConfig({ DATABASE_URL: process.env.DATABASE_URL }));
    const [role] = await prisma.$queryRaw<{ rolsuper: boolean; rolbypassrls: boolean }[]>`SELECT rolsuper, rolbypassrls FROM pg_roles WHERE rolname=current_user`;
    if (!role || role.rolsuper || role.rolbypassrls) throw new Error("Counter test phải chạy APP role để kiểm RLS.");
    redis = new Redis(process.env.REDIS_URL!, { maxRetriesPerRequest: 1 });
    qr = new TicketQrSigner(Buffer.alloc(32, 9));
    publicHolds = new SeatHoldService(prisma, redis);
    sales = new CounterSalesService(prisma, redis, new BookingService(prisma, publicHolds, qr), qr, audit as never);
    offices = new SalesOfficeService(prisma, audit as never); departures = new OperatorDepartureService(prisma, audit as never);
    const province = randomUUID(); const ward = randomUUID();
    await prisma.withSystem(async (tx) => {
      await tx.operatorProfile.createMany({ data: [{ id: a, operatorSlug: `counter-a-${tag}`, displayName: "Nhà xe A" }, { id: b, operatorSlug: `counter-b-${tag}`, displayName: "Nhà xe B" }] });
      await tx.employeeAccount.createMany({ data: [{ id: employee, operatorId: a, username: "nv.sales01", passwordHash: "x", role: "SALES_STAFF" }, { id: another, operatorId: a, username: "nv.sales02", passwordHash: "x", role: "SALES_STAFF" }, { id: driver, operatorId: a, username: "nv.driver", passwordHash: "x", role: "DRIVER" }] });
      await tx.province.create({ data: { id: province, code: `cp-${tag}`, name: "Tỉnh quầy" } });
      await tx.ward.create({ data: { id: ward, provinceId: province, code: `cw-${tag}`, name: "Phường quầy" } });
      await tx.stopPointCatalog.createMany({ data: pointIds.map((id, index) => ({ id, name: `Bến quầy ${index}`, type: "BUS_STATION", address: "Test", provinceId: province, wardId: ward, latitude: 10 + index, longitude: 106 + index, legalBasis: "QĐ test" })) });
      await tx.vehicleType.create({ data: { id: typeId, code: `CT-${tag}`, name: "Xe quầy", form: "SEATER", class: "STANDARD" } });
      await tx.seatMap.create({ data: { id: mapId, operatorId: a, name: "Sơ đồ quầy", layout: { decks: [{ deck: 1, rows: 1, columns: 3 }] }, seatCount: 3 } });
      await tx.route.create({ data: { id: routeId, operatorId: a, name: "Tuyến quầy", totalDistanceMeters: 10000, totalDurationSeconds: 3600, metricsSource: "ESTIMATE" } });
      const fare = await tx.fare.create({ data: { operatorId: a, routeId } });
      await tx.fareRule.create({ data: { operatorId: a, fareId: fare.id, vehicleTypeId: typeId, seatType: "SEAT", price: 300_001n } });
    });
    const office = await offices.create(owner, authz(a, "office:manage"), { code: "VP1", name: "Văn phòng 1", address: "A", active: true }); firstOffice = office.id;
    const second = await offices.create(owner, authz(a, "office:manage"), { code: "VP2", name: "Văn phòng 2", address: "B", active: true }); secondOffice = second.id;
    await offices.replaceAssignments(owner, authz(a, "office:manage"), firstOffice, { version: 0, employeeIds: [employee, another] });
  }, 30_000);
  afterAll(async () => { await redis?.quit(); await prisma?.$disconnect(); });

  async function trip(delayed = false) {
    return prisma.withSystem(async (tx) => {
      const vehicle = await tx.vehicle.create({ data: { operatorId: a, plateNumber: `51C${seq++}`, vehicleTypeId: typeId, seatMapId: mapId } });
      const departureAt = new Date(Date.now() + (delayed ? -1 : 3) * 3_600_000);
      const result = await tx.trip.create({ data: { operatorId: a, routeId, vehicleId: vehicle.id, departureAt, arrivalAt: new Date(departureAt.getTime() + 6 * 3_600_000), status: "OPEN_FOR_SALE" } });
      await tx.tripStop.createMany({ data: pointIds.map((catalogStopPointId, index) => ({ operatorId: a, tripId: result.id, sequence: index + 1, catalogStopPointId, role: index === 0 ? "ORIGIN" : "DESTINATION", allowPickup: index === 0, allowDropoff: index === 1, plannedAt: new Date(departureAt.getTime() + index * 6 * 3_600_000) })) });
      await tx.tripSeat.createMany({ data: ["A1", "A2", "A3"].map((seatCode, index) => ({ operatorId: a, tripId: result.id, seatCode, deck: 1, row: 1, column: index + 1, type: "SEAT" })) });
      return result.id;
    });
  }
  const inputHold = (tripId: string, seatCode = "A1", officeId = firstOffice) => CounterHoldInputSchema.parse({ officeId, tripId, seatCodes: [seatCode], pickupSequence: 1, dropoffSequence: 2 });
  async function booking(tripId: string, seatCode = "A1") {
    const hold = await sales.hold(staff, sell, inputHold(tripId, seatCode));
    const input = CounterBookingInputSchema.parse({ holdId: hold.holdId, contact: { fullName: "Khách tại quầy", phone: "0901234567", email: null }, passengers: [{ seatCode, fullName: "Hành khách", phone: null }], note: null, expectedTotal: hold.subtotal });
    return { input, hold, booking: await sales.create(staff, sell, input) };
  }
  const receipt = (amount = "300001", method: "CASH" | "BANK_TRANSFER" = "CASH", reference: string | null = null) => CounterReceiptInputSchema.parse({ idempotencyKey: randomUUID(), method, amount, reference });

  it("quá giờ lịch vẫn bán khi chưa khởi hành; giữ quầy không thể dùng qua guest/nhân viên khác/văn phòng khác", async () => {
    const id = await trip(true);
    const hold = await sales.hold(staff, sell, inputHold(id));
    expect(hold.subtotal).toBe("300001");
    expect(await codeOf(publicHolds.get(null, hold.holdId))).toBe("SEAT_HOLD_EXPIRED");
    expect(await codeOf(sales.getHold(coworker, sell, hold.holdId))).toBe("SEAT_HOLD_EXPIRED");
    expect(await codeOf(sales.hold(staff, sell, inputHold(id, "A2", secondOffice)))).toBe("OFFICE_NOT_FOUND");
    expect(await codeOf(publicHolds.create(null, undefined, { tripId: id, seatCodes: ["A2"], pickupSequence: 1, dropoffSequence: 2 }))).toBe("TRIP_NOT_FOUND");
    await sales.release(staff, sell, hold.holdId);
    const created = await booking(id);
    expect(created.booking.contact.email).toBeNull();
    expect((await sales.create(staff, sell, created.input)).bookingId).toBe(created.booking.bookingId);
    expect(await codeOf(sales.create(staff, sell, { ...created.input, note: "Dữ liệu gửi khác" }))).toBe("COUNTER_BOOKING_KEY_REUSED");
    expect(created.booking.seller).toContain("sales01");
    expect(await prisma.withTenant(b, (tx) => tx.booking.findUnique({ where: { id: created.booking.bookingId } }))).toBeNull();
  });

  it("hai văn phòng và online tranh cùng ghế chỉ một phiên giữ thành công", async () => {
    const id = await trip();
    const result = await Promise.allSettled([
      sales.hold(owner, sell, inputHold(id, "A1", firstOffice)),
      sales.hold(owner, sell, inputHold(id, "A1", secondOffice)),
      publicHolds.create(null, undefined, { tripId: id, seatCodes: ["A1"], pickupSequence: 1, dropoffSequence: 2 }),
    ]);
    expect(result.filter((value) => value.status === "fulfilled")).toHaveLength(1);
    expect(result.filter((value) => value.status === "rejected")).toHaveLength(2);
  });

  it("thu đủ phát vé một lần, mặc định phí0%, không tăng escrow/payout; in lại giữ nguyên QR", async () => {
    const { booking: created } = await booking(await trip());
    const input = receipt();
    const [first, repeat] = await Promise.all([sales.collect(staff, collect, created.bookingId, input), sales.collect(staff, collect, created.bookingId, input)]);
    expect(first.receiptId).toBe(repeat.receiptId); expect(first.status).toBe("COMPLETED");
    expect(first.booking.status).toBe("CONFIRMED"); expect(first.booking.tickets).toHaveLength(1);
    expect((await sales.get(staff, read, created.bookingId)).tickets[0]?.qrToken).toBe(first.booking.tickets[0]?.qrToken);
    const state = await prisma.withTenant(a, async (tx) => ({ fees: await tx.counterCommissionReceivable.findMany({ where: { bookingId: created.bookingId } }), escrow: await tx.escrowLedger.count({ where: { bookingId: created.bookingId } }), payments: await tx.payment.count({ where: { bookingId: created.bookingId } }), receipts: await tx.counterReceipt.count({ where: { bookingId: created.bookingId } }) }));
    expect(state.fees).toHaveLength(1); expect(state.fees[0]).toMatchObject({ rateBps: 0, basis: 300_001n, amount: 0n }); expect(state.escrow).toBe(0); expect(state.payments).toBe(0); expect(state.receipts).toBe(1);
    expect(await codeOf(sales.collect(staff, collect, created.bookingId, { ...input, amount: "1" }))).toBe("COUNTER_IDEMPOTENCY_CONFLICT");
    await expect(prisma.withTenant(a, (tx) => tx.counterReceipt.update({ where: { id: first.receiptId }, data: { amount: 1n } }))).rejects.toBeDefined();
    expect(await prisma.withTenant(b, (tx) => tx.counterReceipt.findUnique({ where: { id: first.receiptId } }))).toBeNull();
  });

  it("khóa mới ghi khoản tiền mặt thực nhận mới dù cùng số tiền, không phát thêm vé hoặc phí", async () => {
    const { booking: created } = await booking(await trip());
    const input = receipt();
    const first = await sales.collect(staff, collect, created.bookingId, input);
    expect(first.status).toBe("COMPLETED");
    const nextInput = { ...input, idempotencyKey: randomUUID() };
    const extra = await sales.collect(staff, collect, created.bookingId, nextInput);
    expect(extra).toMatchObject({ status: "EXCEPTION", exceptionReason: "BOOKING_NOT_PENDING" });
    expect(extra.receiptId).not.toBe(first.receiptId);
    expect((await sales.collect(staff, collect, created.bookingId, nextInput)).receiptId).toBe(extra.receiptId);
    const state = await prisma.withTenant(a, async (tx) => ({
      receipts: await tx.counterReceipt.findMany({ where: { bookingId: created.bookingId }, orderBy: { createdAt: "asc" } }),
      tickets: await tx.ticket.count({ where: { bookingId: created.bookingId } }),
      fees: await tx.counterCommissionReceivable.count({ where: { bookingId: created.bookingId } }),
    }));
    expect(state.receipts).toHaveLength(2);
    expect(state.receipts.reduce((total, row) => total + row.amount, 0n)).toBe(600_002n);
    expect(state.tickets).toBe(1);
    expect(state.fees).toBe(1);
  });

  it("owner bán và thu chuyển khoản ở văn phòng bất kỳ; ngừng office vẫn xem lịch sử được", async () => {
    const id = await trip(true);
    await prisma.withTenant(a, (tx) => tx.trip.update({ where: { id }, data: { status: "BOARDING" } }));
    const hold = await sales.hold(owner, sell, inputHold(id, "A1", secondOffice));
    const created = await sales.create(owner, sell, CounterBookingInputSchema.parse({ holdId: hold.holdId, contact: { fullName: "Khách chuyển khoản", phone: "0901234567", email: "test@example.com" }, passengers: [{ seatCode: "A1", fullName: "Khách", phone: null }], note: null, expectedTotal: hold.subtotal }));
    const input = receipt("300001", "BANK_TRANSFER", `BANK-OK-${randomUUID()}`);
    expect(await sales.collect(owner, collect, created.bookingId, input)).toMatchObject({ status: "COMPLETED", booking: { status: "CONFIRMED" } });
    await prisma.withTenant(a, (tx) => tx.salesOffice.update({ where: { id: secondOffice }, data: { active: false } }));
    expect((await sales.get(owner, read, created.bookingId)).tickets).toHaveLength(1);
    expect((await sales.list(owner, read, { officeId: secondOffice, limit: 50 })).items).toHaveLength(1);
    expect(await codeOf(sales.hold(owner, sell, inputHold(id, "A2", secondOffice)))).toBe("OFFICE_NOT_FOUND");
    await prisma.withTenant(a, (tx) => tx.salesOffice.update({ where: { id: secondOffice }, data: { active: true } }));
  });

  it("đã nhận tiền nhưng lỗi phát vé vẫn lưu ngoại lệ, không để sót hoa hồng hoặc vé một phần", async () => {
    const { booking: created } = await booking(await trip());
    const sign = vi.spyOn(qr, "token").mockImplementationOnce(() => { throw new Error("QR signer offline (test)"); });
    const input = receipt();
    const result = await sales.collect(staff, collect, created.bookingId, input);
    sign.mockRestore();
    expect(result).toMatchObject({ status: "EXCEPTION", exceptionReason: "ISSUANCE_FAILED" });
    expect(result.booking.tickets).toEqual([]); expect(result.booking.status).toBe("PENDING_PAYMENT");
    expect((await sales.collect(staff, collect, created.bookingId, input)).receiptId).toBe(result.receiptId);
    const state = await prisma.withTenant(a, async (tx) => ({ fees: await tx.counterCommissionReceivable.count({ where: { bookingId: created.bookingId } }), seats: await tx.tripSeat.findMany({ where: { bookingId: created.bookingId }, select: { status: true } }) }));
    expect(state.fees).toBe(0); expect(state.seats).toEqual([{ status: "HOLDING" }]);
  });

  it("lỗi dựng QR trả về sau khi phát vé không rollback khoản thu; retry cùng khóa khôi phục kết quả", async () => {
    const { booking: created } = await booking(await trip());
    const input = receipt();
    const original = qr.token.bind(qr);
    const signer = vi.spyOn(qr, "token").mockImplementationOnce(original).mockImplementationOnce(() => { throw new Error("QR response unavailable (test)"); });
    try {
      expect(await codeOf(sales.collect(staff, collect, created.bookingId, input))).toBe("COUNTER_RECEIPT_UNAVAILABLE");
    } finally {
      signer.mockRestore();
    }
    const saved = await prisma.withTenant(a, (tx) => tx.counterReceipt.findUniqueOrThrow({ where: { operatorId_idempotencyKey: { operatorId: a, idempotencyKey: input.idempotencyKey } } }));
    expect(saved.status).toBe("COMPLETED");
    const retried = await sales.collect(staff, collect, created.bookingId, input);
    expect(retried.receiptId).toBe(saved.id);
    expect(retried.booking.tickets).toHaveLength(1);
    expect(await prisma.withTenant(a, (tx) => tx.counterCommissionReceivable.count({ where: { bookingId: created.bookingId } }))).toBe(1);
  });

  it("đơn quầy không đi qua payment online kể cả người gọi biết mã truy cập", async () => {
    const { booking: created } = await booking(await trip());
    const token = "counter-private-guest-token-test";
    await prisma.withTenant(a, (tx) => tx.booking.update({ where: { id: created.bookingId }, data: { accessTokenHash: hashBookingToken(token) } }));
    const gateway = { provider: "VNPAY", createCheckout: vi.fn() };
    const service = new PaymentService(prisma, new Map([["VNPAY", gateway]]) as never, {} as never);
    expect(await codeOf(service.create(null, created.bookingId, token, { provider: "VNPAY" }, undefined))).toBe("COUNTER_PAYMENT_MANUAL_REQUIRED");
    expect(gateway.createCheckout).not.toHaveBeenCalled();
  });

  it("tiền thiếu/thừa và tiền đến sau khởi hành vẫn lưu ngoại lệ, không xuất vé; bank ref không dùng lại", async () => {
    const { booking: shortage } = await booking(await trip());
    const reference = `BANK-${randomUUID()}`;
    const shortInput = receipt("1", "BANK_TRANSFER", reference);
    const short = await sales.collect(staff, collect, shortage.bookingId, shortInput);
    expect(short).toMatchObject({ status: "EXCEPTION", exceptionReason: "AMOUNT_MISMATCH" }); expect(short.booking.tickets).toEqual([]);
    expect((await sales.collect(staff, collect, shortage.bookingId, shortInput)).receiptId).toBe(short.receiptId);
    expect(await codeOf(sales.collect(staff, collect, shortage.bookingId, { ...shortInput, idempotencyKey: randomUUID() }))).toBe("COUNTER_TRANSFER_DUPLICATE");
    const additional = await sales.collect(staff, collect, shortage.bookingId, receipt("300001", "BANK_TRANSFER", `TOPUP-${randomUUID()}`));
    expect(additional).toMatchObject({ status: "EXCEPTION", exceptionReason: "UNRESOLVED_RECEIPT" });
    expect(additional.booking.tickets).toEqual([]);
    const shortageState = await prisma.withTenant(a, async (tx) => ({
      receipts: await tx.counterReceipt.findMany({ where: { bookingId: shortage.bookingId } }),
      tickets: await tx.ticket.count({ where: { bookingId: shortage.bookingId } }),
      fees: await tx.counterCommissionReceivable.count({ where: { bookingId: shortage.bookingId } }),
      seats: await tx.tripSeat.findMany({ where: { bookingId: shortage.bookingId }, select: { status: true } }),
    }));
    expect(shortageState.receipts).toHaveLength(2);
    expect(shortageState.receipts.reduce((total, row) => total + row.amount, 0n)).toBe(300_002n);
    expect(shortageState.tickets).toBe(0);
    expect(shortageState.fees).toBe(0);
    expect(shortageState.seats).toEqual([{ status: "HOLDING" }]);
    const { booking: surplus } = await booking(await trip());
    expect(await codeOf(sales.collect(staff, collect, surplus.bookingId, receipt("400000", "BANK_TRANSFER", reference)))).toBe("COUNTER_TRANSFER_DUPLICATE");
    expect(await sales.collect(staff, collect, surplus.bookingId, receipt("400000"))).toMatchObject({ status: "EXCEPTION", exceptionReason: "AMOUNT_MISMATCH" });
    const id = await trip(true); const { booking: late } = await booking(id);
    await departures.depart(owner, authz(a, "trip:dispatch"), id, {});
    expect(await codeOf(sales.hold(staff, sell, inputHold(id, "A2")))).toBe("COUNTER_TRIP_CLOSED");
    const result = await sales.collect(staff, collect, late.bookingId, receipt());
    expect(result).toMatchObject({ status: "EXCEPTION", exceptionReason: "TRIP_CLOSED" }); expect(result.booking.tickets).toEqual([]);
  });

  it("thu và khởi hành đồng thời: vé thành công luôn có mốc thu trước hoặc bằng mốc khởi hành", async () => {
    const id = await trip(true); const { booking: created } = await booking(id);
    const [paid, departed] = await Promise.all([sales.collect(staff, collect, created.bookingId, receipt()), departures.depart(owner, authz(a, "trip:dispatch"), id, {})]);
    if (paid.status === "COMPLETED") {
      const row = await prisma.withTenant(a, (tx) => tx.booking.findUniqueOrThrow({ where: { id: created.bookingId }, select: { paidAt: true } }));
      expect(row.paidAt!.getTime()).toBeLessThanOrEqual(Date.parse(departed.departedAt));
    } else { expect(paid.exceptionReason).toBe("TRIP_CLOSED"); expect(paid.booking.tickets).toEqual([]); }
  });

  it("snapshot phí cấu hình chính xác, thu theo kỳ chống lặp và tenant không tự xác nhận trả phí", async () => {
    await prisma.withSystem((tx) => tx.commissionRule.create({ data: { operatorId: a, channel: "COUNTER", rateBps: 100, effectiveFrom: new Date(0), reason: "Phí quầy test" } }));
    const { booking: created } = await booking(await trip());
    const result = await sales.collect(owner, collect, created.bookingId, receipt());
    const fee = await prisma.withTenant(a, (tx) => tx.counterCommissionReceivable.findUniqueOrThrow({ where: { receiptId: result.receiptId } }));
    expect(fee).toMatchObject({ rateBps: 100, basis: 300_001n, amount: 3_000n });
    const service = new CounterCommissionService(prisma, audit as never);
    const platform: Authorization = { permission: "finance:configure", scope: "any", db: platformScope() };
    const totals = await service.overview(platform, { operatorId: a });
    const input = { operatorId: a, idempotencyKey: randomUUID(), amount: totals.outstanding, reference: `COLLECT-${randomUUID()}`, reason: "Thu phí kỳ test" };
    const [one, two] = await Promise.all([service.settle(platform, { sub: "admin", role: "PLATFORM_ADMIN" }, input), service.settle(platform, { sub: "admin", role: "PLATFORM_ADMIN" }, input)]);
    expect(one.id).toBe(two.id); expect((await service.overview(platform, { operatorId: a })).outstanding).toBe("0");
    await expect(prisma.withTenant(a, (tx) => tx.counterCommissionSettlement.create({ data: { operatorId: a, idempotencyKey: randomUUID(), amount: 1n, reference: "FAKE", reason: "Forged", createdBy: "owner" } }))).rejects.toBeDefined();
    const date = new Intl.DateTimeFormat("en-CA", { timeZone: "Asia/Ho_Chi_Minh", year: "numeric", month: "2-digit", day: "2-digit" }).format(new Date());
    const report = await sales.report(owner, read, { officeId: firstOffice, date });
    expect(BigInt(report.cash)).toBeGreaterThan(0n); expect(BigInt(report.exceptions)).toBeGreaterThan(0n); expect(BigInt(report.commission)).toBe(3000n);
  });
});
