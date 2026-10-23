import { randomUUID } from "node:crypto";
import { afterAll, beforeAll, beforeEach, describe, expect, it, vi } from "vitest";
import type { AuditService } from "../audit/audit.service";
import { parseAppConfig } from "../config/env.config";
import { tenantScope } from "../database/db-scope";
import { PrismaService } from "../database/prisma.service";
import type { Coordinates, RouteLeg, RoutingProvider } from "../external/routing/routing-provider";
import type { Authorization } from "../iam/role/authorization";
import { RouteInputSchema } from "../route/dto/route.dto";
import { RouteService } from "../route/route.service";
import { SeatMapInputSchema } from "../vehicle/dto/seat-map.dto";
import { VehicleInputSchema } from "../vehicle/dto/vehicle.dto";
import { SeatMapService } from "../vehicle/seat-map.service";
import { VehicleService } from "../vehicle/vehicle.service";
import { TripScheduleInputSchema } from "./dto/trip-schedule.dto";
import { dateOnly, departureOf, scheduleDates, todayInVietnam } from "./trip-schedule-dates";
import { TripScheduleService } from "./trip-schedule.service";
import { TripService } from "./trip.service";

/**
 * TASK-TRN-007 — lịch chuyến lặp lại trên Postgres THẬT bằng role APP (RLS có hiệu lực). Route tạo qua RouteService với
 * provider giả (không gọi Goong). Audit là mock (ghi sau commit, không chặn).
 */
const url = process.env.DATABASE_URL;
const requireDb = process.env.REQUIRE_DB_TESTS === "1";
const DAY = 24 * 3_600_000;

async function rejectionOf(promise: Promise<unknown>): Promise<{ status?: number; code?: string; text: string }> {
  try {
    await promise;
    return { text: "" };
  } catch (error) {
    const response = (error as { getResponse?: () => { code?: string } }).getResponse?.();
    return {
      status: (error as { getStatus?: () => number }).getStatus?.(),
      code: response?.code,
      text: JSON.stringify(error, Object.getOwnPropertyNames(error)) + String(error),
    };
  }
}

class FakeRouting implements RoutingProvider {
  readonly source = "GOONG" as const;
  async measureLegs(points: Coordinates[]): Promise<RouteLeg[]> {
    return points.slice(1).map((_point, index) => ({ distanceMeters: 1000 * (index + 1), durationSeconds: 3600 * (index + 1) }));
  }
}

/** Ngày giờ VN cách hôm nay `offset` ngày, dạng `YYYY-MM-DD`. */
function dayFromToday(offset: number): string {
  return new Date(dateOnly(todayInVietnam(new Date())).getTime() + offset * DAY).toISOString().slice(0, 10);
}

describe.skipIf(!url && !requireDb)("Lịch chuyến lặp lại — Postgres thật, role app (TRN-007)", () => {
  let prisma: PrismaService;
  let schedules: TripScheduleService;
  let routes: RouteService;
  const recordAuditEvent = vi.fn();
  const tag = randomUUID().slice(0, 8);
  const tenantA = randomUUID();
  const tenantB = randomUUID();
  const province = randomUUID();
  const ward = randomUUID();
  const points = [randomUUID(), randomUUID(), randomUUID()];
  const vehicleType = randomUUID();
  const authzA = authz(tenantA);
  const authzB = authz(tenantB);
  const actor = { sub: `owner-${tag}`, role: "OPERATOR_OWNER" };
  let route: string;
  let routeWithFare: string;
  let routeInactive: string;
  const vehicles: string[] = [];
  let vehicleInactive: string;

  function authz(operatorId: string): Authorization {
    return { permission: "trip:manage", scope: "tenant", db: tenantScope(operatorId) };
  }

  const scheduleInput = (overrides: Record<string, unknown>) =>
    TripScheduleInputSchema.parse({
      routeId: route,
      vehicleId: null,
      departureTime: "06:00",
      durationMinutes: 300,
      daysOfWeek: [1, 2, 3, 4, 5, 6, 7],
      startDate: dayFromToday(3),
      endDate: dayFromToday(5),
      onlineSaleCutoffMinutes: 60,
      note: null,
      ...overrides,
    });

  const tripsOf = (scheduleId: string) =>
    prisma.withTenant(tenantA, (tx) =>
      tx.trip.findMany({
        where: { scheduleId },
        orderBy: { departureAt: "asc" },
        select: {
          id: true,
          serviceDate: true,
          departureAt: true,
          arrivalAt: true,
          status: true,
          vehicleId: true,
          _count: { select: { stops: true, seats: true } },
        },
      }),
    );

  beforeAll(async () => {
    prisma = new PrismaService(parseAppConfig({ DATABASE_URL: url }));
    const audit = { recordAuditEvent } as unknown as AuditService;
    schedules = new TripScheduleService(prisma, new TripService(prisma, audit), audit);
    routes = new RouteService(prisma, new FakeRouting());
    const seatMaps = new SeatMapService(prisma);
    const vehicleService = new VehicleService(prisma, { publicUrl: (key) => `https://cdn.test/${key}` });
    const [role] = await prisma.$queryRaw<{ rolsuper: boolean; rolbypassrls: boolean }[]>`
      SELECT rolsuper, rolbypassrls FROM pg_roles WHERE rolname = current_user`;
    if (!role || role.rolsuper || role.rolbypassrls) {
      throw new Error("DATABASE_URL đang là superuser/BYPASSRLS — dùng role app.");
    }
    await prisma.withSystem(async (tx) => {
      await tx.operatorProfile.createMany({
        data: [
          { id: tenantA, operatorSlug: `sch-a-${tag}`, displayName: "Lịch A" },
          { id: tenantB, operatorSlug: `sch-b-${tag}`, displayName: "Lịch B" },
        ],
      });
      await tx.province.create({ data: { id: province, code: `sp-${tag}`, name: "Tỉnh lịch" } });
      await tx.ward.create({ data: { id: ward, provinceId: province, code: `sw-${tag}`, name: "Phường lịch" } });
      await tx.stopPointCatalog.createMany({
        data: points.map((id, index) => ({
          id,
          name: `Bến lịch ${index + 1} ${tag}`,
          type: "BUS_STATION" as const,
          legalBasis: "QĐ công bố (test)",
          address: `Địa chỉ ${index + 1}`,
          provinceId: province,
          wardId: ward,
          latitude: 10 + index,
          longitude: 106 + index,
        })),
      });
      await tx.vehicleType.create({
        data: { id: vehicleType, code: `SV-${tag}`, name: "Ghế lịch", form: "SEATER", class: "STANDARD" },
      });
    });
    const stops = (ids: string[]) =>
      ids.map((id, index) => ({
        catalogStopPointId: id,
        stopPointId: null,
        note: null,
        allowPickup: index !== ids.length - 1,
        allowDropoff: index !== 0,
      }));
    const routeInput = (name: string, ids: string[], status = "ACTIVE") =>
      RouteInputSchema.parse({ name, status, note: null, stops: stops(ids) });
    route = (await routes.create(authzA, routeInput(`Lịch R3 ${tag}`, points))).id;
    routeWithFare = (await routes.create(authzA, routeInput(`Lịch giá ${tag}`, points.slice(0, 2)))).id;
    routeInactive = (await routes.create(authzA, routeInput(`Lịch ngừng ${tag}`, points.slice(1), "INACTIVE"))).id;
    await prisma.withSystem(async (tx) => {
      const fare = await tx.fare.create({ data: { operatorId: tenantA, routeId: routeWithFare, status: "ACTIVE" } });
      await tx.fareRule.create({ data: { operatorId: tenantA, fareId: fare.id, price: 250_000n } });
    });
    for (let index = 0; index < 4; index++) {
      const map = await seatMaps.create(
        authzA,
        SeatMapInputSchema.parse({
          name: `Sơ đồ lịch ${tag} ${index}`,
          layout: { decks: [{ deck: 1, rows: 2, columns: 2 }] },
          seats: ["A1", "A2", "B1"].map((code, seat) => ({ code, deck: 1, row: Math.floor(seat / 2) + 1, column: (seat % 2) + 1, type: "SEAT" })),
        }),
      );
      const vehicle = await vehicleService.create(
        authzA,
        VehicleInputSchema.parse({
          plateNumber: `51L${String(10000 + Math.floor(Math.random() * 80000) + index)}`,
          vehicleTypeId: vehicleType,
          seatMapId: map.id,
          amenityIds: [],
          status: index === 3 ? "INACTIVE" : "ACTIVE",
          description: null,
        }),
      );
      vehicles.push(vehicle.id);
    }
    vehicleInactive = vehicles.pop()!;
  }, 60_000);

  beforeEach(() => {
    recordAuditEvent.mockReset();
    recordAuditEvent.mockResolvedValue(undefined);
  });

  afterAll(async () => {
    if (!prisma) {
      return;
    }
    await prisma.withSystem(async (tx) => {
      const operatorId = { in: [tenantA, tenantB] };
      await tx.tripSeat.deleteMany({ where: { operatorId } });
      await tx.tripStop.deleteMany({ where: { operatorId } });
      await tx.trip.deleteMany({ where: { operatorId } });
      await tx.tripSchedule.deleteMany({ where: { operatorId } });
      await tx.fareRule.deleteMany({ where: { operatorId } });
      await tx.fare.deleteMany({ where: { operatorId } });
      await tx.routeStop.deleteMany({ where: { operatorId } });
      await tx.route.deleteMany({ where: { operatorId } });
      await tx.vehicle.deleteMany({ where: { operatorId } });
      await tx.seat.deleteMany({ where: { operatorId } });
      await tx.seatMap.deleteMany({ where: { operatorId } });
      await tx.stopPointCatalog.deleteMany({ where: { provinceId: province } });
      await tx.ward.deleteMany({ where: { provinceId: province } });
      await tx.province.deleteMany({ where: { id: province } });
      await tx.vehicleType.deleteMany({ where: { id: vehicleType } });
      await tx.operatorProfile.deleteMany({ where: { id: operatorId } });
    });
    await prisma.$disconnect();
  });

  it("validate: ngày kết thúc trước ngày bắt đầu / quá 93 ngày / đã qua, trùng thứ → 400; tuyến ngừng dùng, xe không hoạt động → 422", async () => {
    for (const overrides of [
      { startDate: dayFromToday(5), endDate: dayFromToday(3) },
      { startDate: dayFromToday(1), endDate: dayFromToday(94) },
      { startDate: dayFromToday(-10), endDate: dayFromToday(-1) },
      { daysOfWeek: [1, 1] },
      { departureTime: "24:00" },
    ]) {
      expect(TripScheduleInputSchema.safeParse({ ...scheduleInput({}), ...overrides }).success, JSON.stringify(overrides)).toBe(false);
    }
    expect(await rejectionOf(schedules.create(actor, authzA, scheduleInput({ routeId: routeInactive })))).toMatchObject({
      status: 422,
      code: "ROUTE_UNAVAILABLE",
    });
    expect(await rejectionOf(schedules.create(actor, authzA, scheduleInput({ vehicleId: vehicleInactive })))).toMatchObject({
      status: 422,
      code: "VEHICLE_UNAVAILABLE",
    });
    // Tuyến của nhà xe A nhìn từ nhà xe B = không tồn tại.
    expect(await rejectionOf(schedules.create(actor, authzB, scheduleInput({})))).toMatchObject({ code: "ROUTE_UNAVAILABLE" });
  });

  it("tạo + sinh chuyến: đúng ngày / giờ VN, chép điểm dừng + ghế; chạy lại không sinh trùng; nhà xe khác không thấy lịch", async () => {
    const created = await schedules.create(
      actor,
      authzA,
      scheduleInput({ vehicleId: vehicles[0], departureTime: "22:30", durationMinutes: 420, daysOfWeek: [1, 3, 5, 7], startDate: dayFromToday(2), endDate: dayFromToday(15) }),
    );
    expect(created).toMatchObject({ departureTime: "22:30", durationMinutes: 420, daysOfWeek: [1, 3, 5, 7], tripCount: 0, lastGeneratedAt: null });
    expect(recordAuditEvent).toHaveBeenCalledWith(expect.objectContaining({ action: "trip_schedule.create", targetId: created.id, operatorId: tenantA }));
    const expected = scheduleDates({ startDate: dateOnly(created.startDate), endDate: dateOnly(created.endDate), daysOfWeek: 0b1010101 });

    const first = await schedules.generate(actor, authzA, created.id, { openForSale: false });
    expect(first.skipped).toEqual([]);
    expect(first.created.map((trip) => trip.serviceDate)).toEqual(expected);
    expect(first.created.every((trip) => trip.status === "DRAFT" && trip.notOpenedReasons.length === 0)).toBe(true);
    const rows = await tripsOf(created.id);
    expect(rows).toHaveLength(expected.length);
    rows.forEach((row, index) => {
      expect(row.serviceDate!.toISOString().slice(0, 10)).toBe(expected[index]);
      expect(row.departureAt.toISOString()).toBe(departureOf(expected[index]!, 22 * 60 + 30).toISOString());
      expect(row.arrivalAt.getTime() - row.departureAt.getTime()).toBe(420 * 60_000);
      expect(row).toMatchObject({ status: "DRAFT", vehicleId: vehicles[0], _count: { stops: 3, seats: 3 } });
    });

    const again = await schedules.generate(actor, authzA, created.id, { openForSale: false });
    expect(again.created).toEqual([]);
    expect(again.skipped).toEqual(expected.map((serviceDate) => ({ serviceDate, reason: "EXISTS" })));
    expect(await tripsOf(created.id)).toHaveLength(expected.length);
    expect((await schedules.get(authzA, created.id)).tripCount).toBe(expected.length);
    expect(recordAuditEvent).toHaveBeenLastCalledWith(
      expect.objectContaining({ action: "trip_schedule.generate", after: expect.objectContaining({ created: 0, skipped: expected.length }) }),
    );

    expect(await rejectionOf(schedules.get(authzB, created.id))).toMatchObject({ status: 404, code: "TRIP_SCHEDULE_NOT_FOUND" });
    expect(await rejectionOf(schedules.generate(actor, authzB, created.id, { openForSale: false }))).toMatchObject({ status: 404 });
    expect((await schedules.list(authzB)).items).toEqual([]);
  });

  it("hai lần sinh đồng thời: mỗi ngày đúng một chuyến", async () => {
    const created = await schedules.create(actor, authzA, scheduleInput({ vehicleId: vehicles[1], startDate: dayFromToday(20), endDate: dayFromToday(26) }));
    const [left, right] = await Promise.all([
      schedules.generate(actor, authzA, created.id, { openForSale: false }),
      schedules.generate(actor, authzA, created.id, { openForSale: false }),
    ]);
    expect(left.created.length + right.created.length).toBe(7);
    expect([...left.skipped, ...right.skipped].every((day) => day.reason === "EXISTS")).toBe(true);
    expect(await tripsOf(created.id)).toHaveLength(7);
  });

  it("xe trùng giờ chuyến khác → bỏ qua đúng ngày đó; ngày đã qua → PAST; sửa lịch chỉ áp cho ngày chưa sinh", async () => {
    const created = await schedules.create(
      actor,
      authzA,
      scheduleInput({ vehicleId: vehicles[2], departureTime: "00:00", durationMinutes: 120, startDate: dayFromToday(0), endDate: dayFromToday(4) }),
    );
    // Chuyến lẻ dùng cùng xe chồng giờ ngày thứ 2.
    const blocker = await schedules.create(
      actor,
      authzA,
      scheduleInput({ vehicleId: vehicles[2], departureTime: "01:00", durationMinutes: 60, startDate: dayFromToday(2), endDate: dayFromToday(2) }),
    );
    expect((await schedules.generate(actor, authzA, blocker.id, { openForSale: false })).created).toHaveLength(1);

    const result = await schedules.generate(actor, authzA, created.id, { openForSale: false });
    expect(result.skipped).toEqual([
      { serviceDate: dayFromToday(0), reason: "PAST" },
      { serviceDate: dayFromToday(2), reason: "VEHICLE_CONFLICT" },
    ]);
    expect(result.created.map((trip) => trip.serviceDate)).toEqual([dayFromToday(1), dayFromToday(3), dayFromToday(4)]);

    // Đổi giờ chạy: chuyến đã sinh giữ giờ cũ; chạy lại chỉ thử lại ngày còn thiếu (vẫn trùng xe nếu giờ còn chồng).
    const updated = await schedules.update(
      actor,
      authzA,
      created.id,
      scheduleInput({ vehicleId: vehicles[2], departureTime: "03:00", durationMinutes: 120, startDate: dayFromToday(0), endDate: dayFromToday(4) }),
    );
    expect(updated.departureTime).toBe("03:00");
    expect(recordAuditEvent).toHaveBeenLastCalledWith(
      expect.objectContaining({ action: "trip_schedule.update", before: expect.objectContaining({ departureTime: "00:00" }) }),
    );
    const rerun = await schedules.generate(actor, authzA, created.id, { openForSale: false });
    // Chạy test trước 03:00 giờ VN thì 03:00 hôm nay chưa qua → ngày hôm nay cũng được sinh.
    const todayStillAhead = departureOf(dayFromToday(0), 3 * 60).getTime() > Date.now();
    expect(rerun.created.map((trip) => trip.serviceDate)).toEqual([...(todayStillAhead ? [dayFromToday(0)] : []), dayFromToday(2)]);
    expect(rerun.created.at(-1)!.departureAt).toBe(departureOf(dayFromToday(2), 3 * 60).toISOString());
    const rows = await tripsOf(created.id);
    expect(rows.find((row) => row.serviceDate!.toISOString().startsWith(dayFromToday(1)))!.departureAt.toISOString()).toBe(
      departureOf(dayFromToday(1), 0).toISOString(),
    );
    expect(await rejectionOf(schedules.update(actor, authzB, created.id, scheduleInput({})))).toMatchObject({ status: 404 });
  });

  it("mở bán ngay: tuyến có giá + xe → Đang mở bán (qua luồng đổi trạng thái, có audit); tuyến chưa có giá / chưa gắn xe → giữ nháp + lý do", async () => {
    const ready = await schedules.create(
      actor,
      authzA,
      scheduleInput({ routeId: routeWithFare, vehicleId: vehicles[0], departureTime: "09:00", durationMinutes: 60, startDate: dayFromToday(30), endDate: dayFromToday(31) }),
    );
    const opened = await schedules.generate(actor, authzA, ready.id, { openForSale: true });
    expect(opened.created.map((trip) => trip.status)).toEqual(["OPEN_FOR_SALE", "OPEN_FOR_SALE"]);
    expect(recordAuditEvent).toHaveBeenCalledWith(
      expect.objectContaining({ action: "trip.status.change", after: { status: "OPEN_FOR_SALE" } }),
      expect.anything(),
    );

    const notReady = await schedules.create(actor, authzA, scheduleInput({ startDate: dayFromToday(40), endDate: dayFromToday(40) }));
    const kept = await schedules.generate(actor, authzA, notReady.id, { openForSale: true });
    expect(kept.created).toHaveLength(1);
    expect(kept.created[0]!.status).toBe("DRAFT");
    expect(kept.created[0]!.notOpenedReasons).toEqual(expect.arrayContaining(["VEHICLE_MISSING", "FARE_MISSING"]));
    expect((await tripsOf(notReady.id))[0]!.status).toBe("DRAFT");
  });

  it("DB: một lịch một chuyến mỗi ngày kể cả ghi thẳng; CHECK khoảng ngày; tenant khác không ghi được lịch", async () => {
    const created = await schedules.create(actor, authzA, scheduleInput({ startDate: dayFromToday(50), endDate: dayFromToday(50) }));
    await schedules.generate(actor, authzA, created.id, { openForSale: false });
    const [trip] = await tripsOf(created.id);
    const duplicate = await rejectionOf(
      prisma.withTenant(tenantA, (tx) =>
        tx.trip.create({
          data: {
            operatorId: tenantA,
            routeId: route,
            departureAt: new Date(trip!.departureAt.getTime() + DAY / 2),
            arrivalAt: new Date(trip!.arrivalAt.getTime() + DAY / 2),
            scheduleId: created.id,
            serviceDate: trip!.serviceDate,
          },
        }),
      ),
    );
    expect(duplicate.text).toMatch(/schedule_id|Unique constraint/i);
    const badRange = await rejectionOf(
      prisma.withTenant(tenantA, (tx) =>
        tx.tripSchedule.update({ where: { id: created.id }, data: { endDate: dateOnly(dayFromToday(200)) } }),
      ),
    );
    expect(badRange.text).toMatch(/trip_schedules_date_range/);
    const foreign = await prisma.withTenant(tenantB, (tx) =>
      tx.tripSchedule.updateMany({ where: { id: created.id }, data: { note: "chiếm" } }),
    );
    expect(foreign.count).toBe(0);
  });
});
