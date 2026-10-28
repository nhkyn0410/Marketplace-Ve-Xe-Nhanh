import { randomUUID } from "node:crypto";
import type Redis from "ioredis";
import { afterAll, beforeAll, describe, expect, it } from "vitest";
import type { AuditService } from "../audit/audit.service";
import { parseAppConfig } from "../config/env.config";
import { tenantScope } from "../database/db-scope";
import { PrismaService } from "../database/prisma.service";
import { loadFeaturedOperators, loadPopularRoutes } from "../database/public-highlights";
import type { Coordinates, RouteLeg, RoutingProvider } from "../external/routing/routing-provider";
import type { StorageProvider } from "../external/storage/storage-provider";
import type { Authorization } from "../iam/role/authorization";
import { RouteInputSchema } from "../route/dto/route.dto";
import { RouteService } from "../route/route.service";
import { TripInputSchema } from "../trip/dto/trip.dto";
import { TripService } from "../trip/trip.service";
import { SeatMapInputSchema } from "../vehicle/dto/seat-map.dto";
import { VehicleInputSchema } from "../vehicle/dto/vehicle.dto";
import { SeatMapService } from "../vehicle/seat-map.service";
import { VehicleService } from "../vehicle/vehicle.service";
import { CatalogService } from "../catalog/catalog.service";
import { PlaceSuggestionQuerySchema } from "../catalog/dto/catalog.dto";
import { TripSearchQuerySchema } from "./dto/public-trip.dto";
import { TripSearchService } from "./trip-search.service";

/**
 * TASK-TRN-004 — tìm chuyến + chi tiết chuyến công khai trên Postgres THẬT bằng role APP (truy vấn công khai chạy ở ngữ cảnh
 * `system` trong `database/public-trips.ts`). Ngày 10/05/2031 (giờ VN); Redis là bản giả trong bộ nhớ.
 */
const url = process.env.DATABASE_URL;
const requireDb = process.env.REQUIRE_DB_TESTS === "1";
const HOUR = 3_600_000;
const DATE = "2031-05-10";
/** 00:00 ngày `DATE` giờ VN. */
const DAY0 = Date.UTC(2031, 4, 10) - 7 * HOUR;

class FakeRouting implements RoutingProvider {
  readonly source = "GOONG" as const;
  async measureLegs(points: Coordinates[]): Promise<RouteLeg[]> {
    return points.slice(1).map(() => ({ distanceMeters: 100_000, durationSeconds: 3 * 3600 }));
  }
}

class MemoryRedis {
  readonly store = new Map<string, string>();
  async get(key: string) {
    return this.store.get(key) ?? null;
  }
  async set(key: string, value: string) {
    this.store.set(key, value);
    return "OK";
  }
}

describe.skipIf(!url && !requireDb)("Tìm chuyến công khai — Postgres thật, role app (TRN-004)", () => {
  let prisma: PrismaService;
  let search: TripSearchService;
  let trips: TripService;
  const redis = new MemoryRedis();
  const tag = randomUUID().slice(0, 8);
  const [opA, opB] = [randomUUID(), randomUUID()];
  const [provinceA, provinceB] = [randomUUID(), randomUUID()];
  const [wardA, wardB, wardEmpty] = [randomUUID(), randomUUID(), randomUUID()];
  const [stationA, restStop, stationB, farA] = [randomUUID(), randomUUID(), randomUUID(), randomUUID()];
  const officeNearA = randomUUID();
  const [sleeperLimo, seater] = [randomUUID(), randomUUID()];
  const amenity = randomUUID();
  const ids: Record<string, string> = {};

  const storage = { publicUrl: (key: string) => `https://cdn.test/${key}` } as unknown as StorageProvider;
  const authz = (operatorId: string): Authorization => ({ permission: "trip:manage", scope: "tenant", db: tenantScope(operatorId) });
  const query = (overrides: Record<string, unknown> = {}) =>
    TripSearchQuerySchema.parse({ fromProvinceId: provinceA, toProvinceId: provinceB, date: DATE, ...overrides });

  async function vehicle(operatorId: string, typeId: string, seats: { code: string; type: string }[]) {
    const map = await new SeatMapService(prisma).create(
      authz(operatorId),
      SeatMapInputSchema.parse({
        name: `Sơ đồ ${randomUUID().slice(0, 6)}`,
        layout: { decks: [{ deck: 1, rows: 4, columns: 2 }] },
        seats: seats.map((seat, index) => ({ ...seat, deck: 1, row: Math.floor(index / 2) + 1, column: (index % 2) + 1 })),
      }),
    );
    const created = await new VehicleService(prisma, storage as never).create(
      authz(operatorId),
      VehicleInputSchema.parse({
        plateNumber: `51S${String(10000 + Math.floor(Math.random() * 89999))}`,
        vehicleTypeId: typeId,
        seatMapId: map.id,
        amenityIds: [amenity],
        status: "ACTIVE",
        description: null,
      }),
    );
    return created.id;
  }

  /** Chuyến của tuyến, khởi hành `start` giờ (giờ VN, ngày `DATE` + `day`), chạy 6 giờ; mặc định mở bán luôn. */
  async function trip(operatorId: string, routeId: string, vehicleId: string, start: number, options: { day?: number; status?: string; cutoff?: number; at?: Date } = {}) {
    const departureAt = options.at ?? new Date(DAY0 + (options.day ?? 0) * 24 * HOUR + start * HOUR);
    const created = await trips.create(
      authz(operatorId),
      TripInputSchema.parse({
        routeId,
        vehicleId,
        departureAt: departureAt.toISOString(),
        stopTimes: null,
        onlineSaleCutoffMinutes: options.cutoff ?? 60,
        note: null,
      }),
    );
    await prisma.withSystem((tx) =>
      tx.trip.update({ where: { id: created.id }, data: { status: (options.status ?? "OPEN_FOR_SALE") as "OPEN_FOR_SALE" } }),
    );
    return created.id;
  }

  async function fare(operatorId: string, routeId: string, rules: { seatType: "BED" | "SEAT" | null; price: bigint }[]) {
    await prisma.withSystem(async (tx) => {
      const created = await tx.fare.create({ data: { operatorId, routeId, status: "ACTIVE" } });
      await tx.fareRule.createMany({ data: rules.map((rule) => ({ operatorId, fareId: created.id, ...rule })) });
    });
  }

  beforeAll(async () => {
    prisma = new PrismaService(parseAppConfig({ DATABASE_URL: url }));
    search = new TripSearchService(prisma, storage, redis as unknown as Redis);
    trips = new TripService(prisma, {} as AuditService);
    const routes = new RouteService(prisma, new FakeRouting());
    await prisma.withSystem(async (tx) => {
      await tx.operatorProfile.createMany({
        data: [
          { id: opA, operatorSlug: `srch-a-${tag}`, displayName: `Nhà xe A ${tag}`, hotline: "19001001" },
          { id: opB, operatorSlug: `srch-b-${tag}`, displayName: `Nhà xe B ${tag}` },
        ],
      });
      await tx.province.createMany({
        data: [
          { id: provinceA, code: `sa-${tag}`, name: "Tỉnh đi" },
          { id: provinceB, code: `sb-${tag}`, name: "Tỉnh đến" },
        ],
      });
      await tx.ward.createMany({
        data: [
          { id: wardA, provinceId: provinceA, code: `wa-${tag}`, name: "Phường đi" },
          { id: wardB, provinceId: provinceB, code: `wb-${tag}`, name: "Phường đến" },
          // Cùng tỉnh đi nhưng không có điểm dừng nào: tìm theo phường này phải nới ra cả tỉnh.
          { id: wardEmpty, provinceId: provinceA, code: `we-${tag}`, name: `Phường trống ${tag}` },
          // Bỏ dấu thì trùng nhau: gõ có dấu phải ra đúng tên trước.
          { provinceId: provinceA, code: `wc1-${tag}`, name: `Xã Cổ Đô ${tag}` },
          { provinceId: provinceA, code: `wc2-${tag}`, name: `Xã Cờ Đỏ ${tag}` },
        ],
      });
      await tx.legacyAdministrativeMapping.createMany({
        data: [
          { legacyProvinceCode: "99", legacyProvinceName: `Tỉnh cũ ${tag}`, legacyDistrictName: `Huyện cũ ${tag}`, legacyWardName: `Xã Cũ Đông ${tag}`, provinceId: provinceA, wardId: wardEmpty },
          { legacyProvinceCode: "99", legacyProvinceName: `Tỉnh cũ ${tag}`, legacyDistrictName: `Huyện cũ ${tag}`, legacyWardName: "", provinceId: provinceA, wardId: wardEmpty },
          // Tên cũ trùng hệt tên mới: chỉ hiện gợi ý phường mới.
          { legacyProvinceCode: "99", legacyProvinceName: `Tỉnh cũ ${tag}`, legacyDistrictName: `Huyện cũ ${tag}`, legacyWardName: `Phường trống ${tag}`, provinceId: provinceA, wardId: wardEmpty },
        ],
      });
      const point = (id: string, name: string, type: "BUS_STATION" | "REST_STOP", provinceId: string, wardId: string, latitude: number, longitude: number) => ({
        id, name: `${name} ${tag}`, type, address: `Địa chỉ ${name}`, provinceId, wardId, latitude, longitude,
        legalBasis: type === "BUS_STATION" ? "QĐ công bố (test)" : null,
      });
      await tx.stopPointCatalog.createMany({
        data: [
          point(stationA, "Bến đi", "BUS_STATION", provinceA, wardA, 10.8, 106.7),
          point(restStop, "Trạm nghỉ", "REST_STOP", provinceA, wardA, 11.3, 107.5),
          point(stationB, "Bến đến", "BUS_STATION", provinceB, wardB, 11.94, 108.45),
          // Cách bến đi ~20 km: ngoài bán kính 5 km.
          point(farA, "Bến xa", "BUS_STATION", provinceA, wardA, 10.98, 106.7),
        ],
      });
      // Văn phòng riêng của nhà xe A cách bến đi ~1,1 km: trong bán kính.
      await tx.stopPoint.create({
        data: { id: officeNearA, operatorId: opA, name: `Văn phòng gần ${tag}`, type: "OFFICE", address: "Gần bến", provinceId: provinceA, wardId: wardA, latitude: 10.81, longitude: 106.7 },
      });
      await tx.vehicleType.createMany({
        data: [
          { id: sleeperLimo, code: `SL-${tag}`, name: "Limousine giường", form: "SLEEPER", class: "LIMOUSINE" },
          { id: seater, code: `ST-${tag}`, name: "Ghế ngồi", form: "SEATER", class: "STANDARD" },
        ],
      });
      await tx.amenity.create({ data: { id: amenity, code: `wifi-${tag}`, name: `Wifi ${tag}` } });
    });
    const stop = (catalogStopPointId: string | null, stopPointId: string | null, pickup: boolean, dropoff: boolean) =>
      ({ catalogStopPointId, stopPointId, note: null, allowPickup: pickup, allowDropoff: dropoff });
    const route = (operatorId: string, name: string, stops: ReturnType<typeof stop>[]) =>
      routes.create(authz(operatorId), RouteInputSchema.parse({ name: `${name} ${tag}`, status: "ACTIVE", note: null, stops }));
    ids.routeA = (await route(opA, "Đi – Đến", [stop(stationA, null, true, false), stop(restStop, null, false, false), stop(stationB, null, false, true)])).id;
    ids.routeOffice = (await route(opA, "Văn phòng – Đến", [stop(null, officeNearA, true, false), stop(stationB, null, false, true)])).id;
    ids.routeFar = (await route(opA, "Bến xa – Đến", [stop(farA, null, true, false), stop(stationB, null, false, true)])).id;
    ids.routeB = (await route(opB, "B Đi – Đến", [stop(stationA, null, true, false), stop(stationB, null, false, true)])).id;
    await fare(opA, ids.routeA, [{ seatType: "BED", price: 350_000n }, { seatType: "SEAT", price: 250_000n }]);
    await fare(opA, ids.routeOffice, [{ seatType: null, price: 300_000n }]);
    await fare(opA, ids.routeFar, [{ seatType: null, price: 280_000n }]);
    await fare(opB, ids.routeB, [{ seatType: null, price: 200_000n }]);
    const busA = await vehicle(opA, sleeperLimo, [{ code: "A1", type: "BED" }, { code: "A2", type: "BED" }]);
    const busA2 = await vehicle(opA, seater, [{ code: "B1", type: "SEAT" }, { code: "B2", type: "SEAT" }, { code: "B3", type: "SEAT" }]);
    const busB = await vehicle(opB, seater, [{ code: "C1", type: "SEAT" }]);
    ids.main = await trip(opA, ids.routeA, busA, 8);
    ids.cheap = await trip(opA, ids.routeA, busA2, 15);
    ids.office = await trip(opA, ids.routeOffice, busA2, 22);
    ids.far = await trip(opA, ids.routeFar, busA, 16);
    ids.draft = await trip(opA, ids.routeA, busA, 2, { day: 1, status: "DRAFT" });
    ids.otherDay = await trip(opA, ids.routeA, busA, 8, { day: 2 });
    ids.suspended = await trip(opB, ids.routeB, busB, 9);
    await prisma.withSystem((tx) => tx.operatorProfile.update({ where: { id: opB }, data: { status: "SUSPENDED", suspendedReason: "Kiểm thử", suspendedAt: new Date() } }));
    // Một chỗ của chuyến rẻ đã khóa (bán ngoài nền tảng): còn 2 chỗ.
    await prisma.withSystem((tx) => tx.tripSeat.updateMany({ where: { tripId: ids.cheap, seatCode: "B1" }, data: { status: "BLOCKED" } }));
  }, 90_000);

  afterAll(async () => {
    if (!prisma) {
      return;
    }
    await prisma.withSystem(async (tx) => {
      const operatorId = { in: [opA, opB] };
      await tx.tripSeat.deleteMany({ where: { operatorId } });
      await tx.tripStop.deleteMany({ where: { operatorId } });
      await tx.trip.deleteMany({ where: { operatorId } });
      await tx.fareRule.deleteMany({ where: { operatorId } });
      await tx.fare.deleteMany({ where: { operatorId } });
      await tx.routeStop.deleteMany({ where: { operatorId } });
      await tx.route.deleteMany({ where: { operatorId } });
      await tx.vehicleAmenity.deleteMany({ where: { operatorId } });
      await tx.vehicle.deleteMany({ where: { operatorId } });
      await tx.seat.deleteMany({ where: { operatorId } });
      await tx.seatMap.deleteMany({ where: { operatorId } });
      await tx.stopPoint.deleteMany({ where: { operatorId } });
      await tx.stopPointCatalog.deleteMany({ where: { provinceId: { in: [provinceA, provinceB] } } });
      await tx.legacyAdministrativeMapping.deleteMany({ where: { provinceId: { in: [provinceA, provinceB] } } });
      await tx.ward.deleteMany({ where: { provinceId: { in: [provinceA, provinceB] } } });
      await tx.province.deleteMany({ where: { id: { in: [provinceA, provinceB] } } });
      await tx.vehicleType.deleteMany({ where: { id: { in: [sleeperLimo, seater] } } });
      await tx.amenity.deleteMany({ where: { id: amenity } });
      await tx.operatorProfile.deleteMany({ where: { id: operatorId } });
    });
    await prisma.$disconnect();
  });

  it("theo tỉnh: đúng chuyến đang mở bán trong ngày; bỏ nháp / ngày khác / nhà xe tạm khóa / chiều ngược; điểm đón trả + giá thấp nhất + chỗ trống", async () => {
    const result = await search.search(query());
    expect(result.items.map((item) => item.tripId)).toEqual([ids.main, ids.cheap, ids.far, ids.office]);
    const main = result.items[0]!;
    expect(main).toMatchObject({
      operator: { id: opA, name: `Nhà xe A ${tag}`, averageRating: null, reviewCount: 0 },
      vehicleType: { form: "SLEEPER", class: "LIMOUSINE" },
      pickup: { sequence: 1, name: `Bến đi ${tag}` },
      dropoff: { sequence: 3, name: `Bến đến ${tag}` },
      durationMinutes: 360,
      availableSeats: 2,
      minPrice: 350_000,
      vehicleCoverImageUrl: null,
      amenities: [{ id: amenity, name: `Wifi ${tag}` }],
    });
    expect(main.onlineSaleClosesAt).toBe(new Date(DAY0 + 7 * HOUR).toISOString());
    expect(result.items.find((item) => item.tripId === ids.cheap)).toMatchObject({ availableSeats: 2, minPrice: 250_000 });
    expect(result.facets).toEqual({ operators: [{ id: opA, name: `Nhà xe A ${tag}`, count: 4 }], priceMin: 250_000, priceMax: 350_000 });
    expect((await search.search(query({ fromProvinceId: provinceB, toProvinceId: provinceA }))).items).toEqual([]);
    expect((await search.search(query({ date: "2031-05-11" }))).items).toEqual([]);
  });

  it("tuyến phổ biến + nhà xe tiêu biểu: gộp 3 tuyến cùng cặp tỉnh, bỏ nháp và nhà xe tạm khóa", async () => {
    const now = new Date(DAY0 - HOUR);
    const pair = { originProvinceId: provinceA, originName: "đi", destinationProvinceId: provinceB, destinationName: "đến" };
    const popular = (await loadPopularRoutes(prisma, 1000, now)).filter((route) => route.originProvinceId === provinceA || route.destinationProvinceId === provinceA);
    expect(popular).toEqual([
      {
        ...pair,
        distanceMeters: 100_000,
        durationSeconds: 3 * 3600,
        minPrice: 250_000n,
        vehicleTypeNames: ["Ghế ngồi", "Limousine giường"],
        nextDepartureAt: new Date(DAY0 + 8 * HOUR),
        operatorCount: 1,
        averageRating: null,
        reviewCount: 0,
      },
    ]);
    const featured = (await loadFeaturedOperators(prisma, 1000, now)).filter((operator) => operator.operatorId === opA || operator.operatorId === opB);
    expect(featured).toEqual([{ operatorId: opA, displayName: `Nhà xe A ${tag}`, logoObjectKey: null, averageRating: null, reviewCount: 0, routes: [pair] }]);
    // Ngoài cửa sổ 30 ngày tới thì không còn là tuyến đang bán.
    expect((await loadPopularRoutes(prisma, 1000, new Date(DAY0 - 40 * 24 * HOUR))).some((route) => route.originProvinceId === provinceA)).toBe(false);
  });

  it("theo phường / xã: khớp điểm đón / trả nằm trong phường; phường không có chuyến → nới ra cả tỉnh (widenedToProvince); phường không có → rỗng", async () => {
    const byWard = await search.search(query({ fromProvinceId: undefined, fromWardId: wardA, toProvinceId: undefined, toWardId: wardB }));
    expect(byWard.items.map((item) => item.tripId)).toEqual([ids.main, ids.cheap, ids.far, ids.office]);
    expect(byWard.widenedToProvince).toEqual({ from: false, to: false });

    const widened = await search.search(query({ fromProvinceId: undefined, fromWardId: wardEmpty }));
    expect(widened.items.map((item) => item.tripId)).toEqual([ids.main, ids.cheap, ids.far, ids.office]);
    expect(widened.widenedToProvince).toEqual({ from: true, to: false });

    const unknown = await search.search(query({ fromProvinceId: undefined, fromWardId: randomUUID() }));
    expect(unknown).toMatchObject({ items: [], total: 0, widenedToProvince: { from: false, to: false } });
    // Nới ra cả tỉnh vẫn không có chuyến (ngày không có chuyến) → rỗng, không bật cờ nới.
    expect(await search.search(query({ fromProvinceId: undefined, fromWardId: wardEmpty, date: "2031-05-11" }))).toMatchObject({
      items: [],
      widenedToProvince: { from: false, to: false },
    });
    expect(() => query({ fromWardId: wardA })).toThrow();
    expect((await search.search(query())).widenedToProvince).toEqual({ from: false, to: false });
  });

  it("gợi ý địa điểm: phường mới, địa danh, tên cũ cấp xã → phường mới, cấp huyện → tỉnh; tên cũ trùng tên mới bị bỏ; gõ không dấu", async () => {
    const catalog = new CatalogService(prisma, { publicUrl: (key) => key });
    const { items } = await catalog.listPlaces(PlaceSuggestionQuerySchema.parse({ q: tag, limit: 20 }));
    expect(items.filter((item) => item.kind === "WARD").map((item) => item.label)).toEqual(
      expect.arrayContaining([`Phường trống ${tag}`, `Xã Cổ Đô ${tag}`, `Xã Cờ Đỏ ${tag}`]),
    );
    expect(items.find((item) => item.label === `Phường trống ${tag}`)).toEqual({
      kind: "WARD",
      label: `Phường trống ${tag}`,
      detail: "Tỉnh đi",
      target: { type: "ward", id: wardEmpty },
    });
    const accented = await catalog.listPlaces(PlaceSuggestionQuerySchema.parse({ q: `cờ đỏ ${tag}` }));
    expect(accented.items.map((item) => item.label)).toEqual([`Xã Cờ Đỏ ${tag}`, `Xã Cổ Đô ${tag}`]);
    expect(items.filter((item) => item.kind === "STOP_POINT").map((item) => item.target.id).sort()).toEqual(
      [stationA, stationB, farA].sort(),
    );
    expect(items.filter((item) => item.kind === "LEGACY")).toEqual([
      { kind: "LEGACY", label: `Huyện cũ ${tag}`, detail: `Cũ: Tỉnh cũ ${tag} · Nay thuộc Tỉnh đi`, target: { type: "province", id: provinceA } },
      {
        kind: "LEGACY",
        label: `Xã Cũ Đông ${tag}`,
        detail: `Cũ: Huyện cũ ${tag}, Tỉnh cũ ${tag} · Nay: Phường trống ${tag}, Tỉnh đi`,
        target: { type: "ward", id: wardEmpty },
      },
    ]);
    const accentless = await catalog.listPlaces(PlaceSuggestionQuerySchema.parse({ q: `xa cu dong ${tag}` }));
    expect(accentless.items).toEqual([expect.objectContaining({ kind: "LEGACY", target: { type: "ward", id: wardEmpty } })]);
    expect(() => PlaceSuggestionQuerySchema.parse({ q: "a" })).toThrow();
  });

  it("theo địa danh: điểm trong bán kính 5 km (cả văn phòng riêng) khớp, điểm cách ~20 km không khớp", async () => {
    const result = await search.search(query({ fromProvinceId: undefined, fromStopPointId: stationA, toProvinceId: undefined, toStopPointId: stationB }));
    expect(result.items.map((item) => item.tripId)).toEqual([ids.main, ids.cheap, ids.office]);
    expect(result.items.find((item) => item.tripId === ids.office)!.pickup.name).toBe(`Văn phòng gần ${tag}`);
  });

  it("số khách vượt chỗ trống bị loại; lọc dạng chỗ / hạng / giờ / giá / tiện ích; sắp theo giá / thời gian; phân trang", async () => {
    expect((await search.search(query({ passengers: 3 }))).items.map((item) => item.tripId)).toEqual([ids.office]);
    expect((await search.search(query({ vehicleForm: "SEATER" }))).items.map((item) => item.tripId)).toEqual([ids.cheap, ids.office]);
    expect((await search.search(query({ vehicleClass: "LIMOUSINE" }))).items.map((item) => item.tripId)).toEqual([ids.main, ids.far]);
    expect((await search.search(query({ departureFrom: "12:00", departureTo: "20:00" }))).items.map((item) => item.tripId)).toEqual([ids.cheap, ids.far]);
    expect((await search.search(query({ priceMin: 260_000, priceMax: 320_000 }))).items.map((item) => item.tripId)).toEqual([ids.far, ids.office]);
    expect((await search.search(query({ amenityIds: `${amenity},${randomUUID()}` }))).items).toEqual([]);
    expect((await search.search(query({ sort: "price" }))).items.map((item) => item.minPrice)).toEqual([250_000, 280_000, 300_000, 350_000]);
    const page2 = await search.search(query({ limit: 3, page: 2 }));
    expect(page2).toMatchObject({ total: 4, page: 2 });
    expect(page2.items.map((item) => item.tripId)).toEqual([ids.office]);
  });

  it("quá giờ ngừng bán online không hiện; bảng giá bị ngừng thì chuyến không hiện; kết quả được cache 60 giây", async () => {
    const soon = new Date(Date.now() + 30 * 60_000);
    const vnDate = new Date(soon.getTime() + 7 * HOUR).toISOString().slice(0, 10);
    const closed = await trip(opA, ids.routeA, (await prisma.withSystem((tx) => tx.trip.findUniqueOrThrow({ where: { id: ids.main } }))).vehicleId!, 0, { at: soon, cutoff: 60 });
    expect((await search.search(query({ date: vnDate }))).items.some((item) => item.tripId === closed)).toBe(false);

    redis.store.clear();
    await search.search(query());
    expect(redis.store.size).toBe(1);
    await prisma.withSystem((tx) => tx.fare.updateMany({ where: { routeId: ids.routeFar }, data: { status: "INACTIVE" } }));
    // Còn trong cache → vẫn thấy; xóa cache → chuyến không còn giá bị bỏ.
    expect((await search.search(query())).items.some((item) => item.tripId === ids.far)).toBe(true);
    redis.store.clear();
    expect((await search.search(query())).items.some((item) => item.tripId === ids.far)).toBe(false);
    await prisma.withSystem((tx) => tx.fare.updateMany({ where: { routeId: ids.routeFar }, data: { status: "ACTIVE" } }));
  });

  it("chi tiết: lịch trình đủ điểm, sơ đồ chỗ có giá + còn / không (chỗ khóa), chính sách hủy; nháp / nhà xe tạm khóa → 404", async () => {
    const detail = await search.getTrip(ids.cheap);
    expect(detail).toMatchObject({ routeName: `Đi – Đến ${tag}`, operator: { hotline: "19001001", averageRating: null, reviewCount: 0 }, vehicleImages: [] });
    expect(detail.stops.map((stop) => [stop.sequence, stop.type, stop.allowPickup, stop.allowDropoff])).toEqual([
      [1, "BUS_STATION", true, false],
      [2, "REST_STOP", false, false],
      [3, "BUS_STATION", false, true],
    ]);
    expect(detail.seats).toEqual([
      expect.objectContaining({ code: "B1", status: "UNAVAILABLE", price: 250_000 }),
      expect.objectContaining({ code: "B2", status: "AVAILABLE", price: 250_000 }),
      expect.objectContaining({ code: "B3", status: "AVAILABLE", price: 250_000 }),
    ]);
    expect(Array.isArray(detail.cancellationPolicy.tiers)).toBe(true);
    for (const tripId of [ids.draft, ids.suspended, randomUUID()]) {
      await expect(search.getTrip(tripId)).rejects.toMatchObject({ status: 404 });
    }
  });
});
