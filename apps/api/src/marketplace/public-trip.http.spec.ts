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
    search: vi.fn(async () => ({ items: [], total: 0, page: 1, limit: 20, facets: { operators: [], priceMin: null, priceMax: null } })),
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

  it.each([
    [`date=2031-05-10&toProvinceId=${province}`],
    [`fromProvinceId=${province}&fromStopPointId=${randomUUID()}&toProvinceId=${province}&date=2031-05-10`],
    [`fromProvinceId=${province}&toProvinceId=${province}`],
    [`fromProvinceId=${province}&toProvinceId=${province}&date=10/05/2031`],
    [`fromProvinceId=${province}&toProvinceId=${province}&date=2031-05-10&passengers=11`],
    [`fromProvinceId=${province}&toProvinceId=${province}&date=2031-05-10&priceMin=500&priceMax=100`],
    [`fromProvinceId=${province}&toProvinceId=${province}&date=2031-05-10&sort=rating`],
  ])("query sai → 400, service không bị gọi: %s", async (query) => {
    expect((await fetch(`${base}/search?${query}`)).status).toBe(400);
    expect(service.search).not.toHaveBeenCalled();
  });

  it("chi tiết: id không phải uuid → 400 trước khi vào service", async () => {
    expect((await fetch(`${base}/khong-phai-uuid`)).status).toBe(400);
    expect(service.getTrip).not.toHaveBeenCalled();
  });
});
