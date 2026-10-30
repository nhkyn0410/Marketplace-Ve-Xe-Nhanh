import { randomUUID } from "node:crypto";
import type { AddressInfo } from "node:net";
import { type INestApplication, Module } from "@nestjs/common";
import { APP_INTERCEPTOR, NestFactory } from "@nestjs/core";
import { ZodSerializerInterceptor, ZodValidationPipe } from "nestjs-zod";
import { afterAll, beforeAll, beforeEach, describe, expect, it, vi } from "vitest";
import { ProblemDetailsExceptionFilter } from "../common/errors/problem-details.filter";
import { configureApiRoutes } from "../openapi/openapi";
import { PublicTripController } from "./public-trip.controller";
import { TripSearchService } from "./trip-search.service";

/** Route công khai `/trips/search`, `/trips/{tripId}` (TASK-TRN-004): không cần đăng nhập; nghiệp vụ ở `.int.spec.ts`. */
describe("Tìm chuyến công khai — HTTP", () => {
  const service = {
    search: vi.fn<TripSearchService["search"]>(async () => ({ items: [], total: 0, page: 1, limit: 20, facets: { operators: [], priceMin: null, priceMax: null }, widenedToProvince: { from: false, to: false } })),
    getTrip: vi.fn(async () => {
      throw new Error("không gọi");
    }),
  };
  let app: INestApplication;
  let base: string;

  @Module({
    controllers: [PublicTripController],
    providers: [{ provide: APP_INTERCEPTOR, useClass: ZodSerializerInterceptor }, { provide: TripSearchService, useValue: service }],
  })
  class HttpTestModule {}

  beforeAll(async () => {
    app = await NestFactory.create(HttpTestModule, { logger: false, abortOnError: false });
    app.useGlobalPipes(new ZodValidationPipe());
    app.useGlobalFilters(new ProblemDetailsExceptionFilter());
    configureApiRoutes(app);
    await app.listen(0, "127.0.0.1");
    base = `http://127.0.0.1:${(app.getHttpServer().address() as AddressInfo).port}/v1/trips`;
  }, 15_000);

  afterAll(async () => {
    await app?.close();
  });

  beforeEach(() => {
    vi.clearAllMocks();
  });

  const province = randomUUID();

  it("tìm không cần đăng nhập; mặc định 1 khách, sắp theo giờ đi, trang 1 / 20; tiện ích tách theo dấu phẩy", async () => {
    const response = await fetch(`${base}/search?fromProvinceId=${province}&toProvinceId=${province}&date=2031-05-10&amenityIds=a,b`);
    expect(response.status).toBe(200);
    expect(service.search).toHaveBeenCalledWith(
      expect.objectContaining({ passengers: 1, sort: "departure", page: 1, limit: 20, amenityIds: ["a", "b"] }),
    );
  });

  it.each(["", "date=2031-05-10&passengers=2"])("không nhập điểm đi / đến vẫn tìm được: %s", async (query) => {
    expect((await fetch(`${base}/search?${query}`)).status).toBe(200);
    const input = service.search.mock.calls[0]![0];
    expect(input).not.toHaveProperty("fromProvinceId");
    expect(input).not.toHaveProperty("toProvinceId");
    expect(input).toMatchObject(query ? { date: "2031-05-10", passengers: 2 } : { passengers: 1 });
  });

  it.each(["https://cdn.test/operator-logo.png", null])("serializer giữ logo nhà xe công khai trong thẻ chuyến: %s", async (logoUrl) => {
    service.search.mockResolvedValueOnce({
      items: [{
        tripId: randomUUID(), operator: { id: randomUUID(), name: "Nhà xe", slug: "nha-xe", logoUrl, averageRating: null, reviewCount: 0 },
        routeName: "A → B", segmentTitle: "A → B", vehicleType: { name: "Giường nằm", form: "SLEEPER", class: "STANDARD" },
        departureAt: "2031-05-10T01:00:00Z", arrivalAt: "2031-05-10T07:00:00Z",
        pickup: { sequence: 1, name: "A", address: "A", plannedAt: "2031-05-10T01:00:00Z" },
        dropoff: { sequence: 2, name: "B", address: "B", plannedAt: "2031-05-10T07:00:00Z" },
        durationMinutes: 360, availableSeats: 10, minPrice: 300000, vehicleCoverImageUrl: null, amenities: [], onlineSaleClosesAt: "2031-05-10T00:00:00Z",
      }],
      total: 1, page: 1, limit: 20, facets: { operators: [], priceMin: null, priceMax: null }, widenedToProvince: { from: false, to: false },
    });
    const response = await fetch(`${base}/search?date=2031-05-10`);
    expect(response.status).toBe(200);
    const body = await response.json() as { items: { operator: { logoUrl: string | null } }[] };
    expect(body.items[0]!.operator.logoUrl).toBe(logoUrl);
  });

  it.each([
    [`toProvinceId=${province}&toAreaId=79&date=2031-05-10`],
    [`fromProvinceId=${province}&fromStopPointId=${randomUUID()}&toProvinceId=${province}&date=2031-05-10`],
    [`fromAreaId=79&fromWardId=${randomUUID()}`],
    [`fromProvinceId=${province}&fromWardId=${randomUUID()}&toProvinceId=${province}&date=2031-05-10`],
    [`fromProvinceId=${province}&toProvinceId=${province}&toWardId=${randomUUID()}&date=2031-05-10`],
    [`fromProvinceId=${province}&toProvinceId=${province}&date=10/05/2031`],
    [`fromProvinceId=${province}&toProvinceId=${province}&date=2031-05-10&passengers=11`],
    [`fromProvinceId=${province}&toProvinceId=${province}&date=2031-05-10&priceMin=500&priceMax=100`],
    [`fromProvinceId=${province}&toProvinceId=${province}&date=2031-05-10&sort=cheapest`],
  ])("query sai → 400, service không bị gọi: %s", async (query) => {
    expect((await fetch(`${base}/search?${query}`)).status).toBe(400);
    expect(service.search).not.toHaveBeenCalled();
  });

  it("chi tiết: id không phải uuid → 400 trước khi vào service", async () => {
    expect((await fetch(`${base}/khong-phai-uuid`)).status).toBe(400);
    expect(service.getTrip).not.toHaveBeenCalled();
  });
});
