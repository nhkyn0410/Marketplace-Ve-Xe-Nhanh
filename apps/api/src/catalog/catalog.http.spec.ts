import { randomUUID } from "node:crypto";
import type { AddressInfo } from "node:net";
import { type INestApplication, Module } from "@nestjs/common";
import { APP_INTERCEPTOR, NestFactory } from "@nestjs/core";
import { ZodSerializerInterceptor, ZodValidationPipe } from "nestjs-zod";
import {
  afterAll,
  beforeAll,
  beforeEach,
  describe,
  expect,
  it,
  vi,
} from "vitest";
import { ProblemDetailsExceptionFilter } from "../common/errors/problem-details.filter";
import { configureApiRoutes } from "../openapi/openapi";
import { CatalogController } from "./catalog.controller";
import { CatalogService } from "./catalog.service";

/** Route thật (decorator, ZodValidationPipe, serializer, filter RFC 7807); dữ liệu do test DB lo. */
describe("Catalog routes — HTTP công khai", () => {
  const provinceId = randomUUID();
  const timestamps = {
    status: "ACTIVE",
    createdAt: new Date(),
    updatedAt: new Date(),
  };
  const listProvinces = vi.fn(async () => ({
    // Field thừa (status/timestamp) mô phỏng service lỡ trả thêm: serializer phải cắt.
    items: [
      {
        id: provinceId,
        code: "79",
        name: "Thành phố Hồ Chí Minh",
        ...timestamps,
      },
    ],
  }));
  const listWards = vi.fn(async () => ({ items: [] }));
  const listStopPoints = vi.fn(async () => ({ items: [], nextCursor: null }));
  const vehicleTypeId = randomUUID();
  const listVehicleTypes = vi.fn(async () => ({
    items: [
      {
        id: vehicleTypeId,
        code: "SLEEPER_LIMOUSINE",
        name: "Giường nằm Limousine",
        description: null,
        form: "SLEEPER",
        class: "LIMOUSINE",
        ...timestamps,
      },
    ],
  }));
  const listAmenities = vi.fn(async () => ({ items: [] }));
  const originProvinceId = randomUUID();
  const destinationProvinceId = randomUUID();
  const pair = {
    originProvinceId,
    originName: "TP. Hồ Chí Minh",
    destinationProvinceId,
    destinationName: "Lâm Đồng",
  };
  const listPopularRoutes = vi.fn(async () => ({
    items: [
      {
        ...pair,
        distanceMeters: 308_000,
        durationSeconds: 25_200,
        minPrice: 280_000,
        vehicleTypeNames: ["Giường nằm"],
        nextDepartureAt: "2026-10-27T15:00:00.000Z",
        operatorCount: 2,
        averageRating: 4.8,
        reviewCount: 12,
        // Field nội bộ mô phỏng service lỡ trả thêm: serializer phải cắt.
        routeId: randomUUID(),
      },
    ],
  }));
  const operatorId = randomUUID();
  const listFeaturedOperators = vi.fn(async () => ({
    items: [
      {
        operatorId,
        displayName: "Phương Trang",
        averageRating: null,
        reviewCount: 0,
        routes: [pair],
      },
    ],
  }));
  let app: INestApplication;
  let base: string;

  @Module({
    controllers: [CatalogController],
    providers: [
      { provide: APP_INTERCEPTOR, useClass: ZodSerializerInterceptor },
      {
        provide: CatalogService,
        useValue: {
          listProvinces,
          listWards,
          listStopPoints,
          listVehicleTypes,
          listAmenities,
          listPopularRoutes,
          listFeaturedOperators,
        },
      },
    ],
  })
  class HttpTestModule {}

  beforeAll(async () => {
    app = await NestFactory.create(HttpTestModule, {
      logger: false,
      abortOnError: false,
    });
    app.useGlobalPipes(new ZodValidationPipe());
    app.useGlobalFilters(new ProblemDetailsExceptionFilter());
    configureApiRoutes(app);
    await app.listen(0, "127.0.0.1");
    base = `http://127.0.0.1:${(app.getHttpServer().address() as AddressInfo).port}/v1/catalog`;
  }, 15_000);

  afterAll(async () => {
    await app?.close();
  });

  beforeEach(() => {
    vi.clearAllMocks();
  });

  it.each([
    "provinces",
    `wards?provinceId=${provinceId}`,
    "stop-points",
    "vehicle-types",
    "amenities",
    "popular-routes",
    "featured-operators",
  ])("GET /catalog/%s trả 200 khi KHÔNG có token", async (path) => {
    const response = await fetch(`${base}/${path}`);
    expect(response.status).toBe(200);
  });

  it("response chỉ giữ field công khai (không status/timestamp)", async () => {
    const body = await (await fetch(`${base}/provinces`)).json();
    expect(body).toEqual({
      items: [{ id: provinceId, code: "79", name: "Thành phố Hồ Chí Minh" }],
    });
  });

  it("vehicle-types trả dạng chỗ + hạng xe (BR-77), không status/timestamp", async () => {
    const body = await (await fetch(`${base}/vehicle-types`)).json();
    expect(body).toEqual({
      items: [
        {
          id: vehicleTypeId,
          code: "SLEEPER_LIMOUSINE",
          name: "Giường nằm Limousine",
          description: null,
          form: "SLEEPER",
          class: "LIMOUSINE",
        },
      ],
    });
  });

  it("popular-routes áp mặc định limit=7 và chỉ trả field công khai", async () => {
    const body = await (await fetch(`${base}/popular-routes`)).json();
    expect(listPopularRoutes).toHaveBeenLastCalledWith(7);
    expect(body.items[0]).not.toHaveProperty("routeId");
    expect(body.items[0]).toMatchObject({ ...pair, minPrice: 280_000 });
    await fetch(`${base}/popular-routes?limit=3`);
    expect(listPopularRoutes).toHaveBeenLastCalledWith(3);
  });

  it("featured-operators áp mặc định limit=5, nhà xe chưa có đánh giá trả averageRating null", async () => {
    const body = await (await fetch(`${base}/featured-operators`)).json();
    expect(listFeaturedOperators).toHaveBeenLastCalledWith(5);
    expect(body).toEqual({
      items: [
        {
          operatorId,
          displayName: "Phương Trang",
          averageRating: null,
          reviewCount: 0,
          routes: [pair],
        },
      ],
    });
  });

  it("wards chuyển đúng provinceId xuống service", async () => {
    await fetch(`${base}/wards?provinceId=${provinceId}`);
    expect(listWards).toHaveBeenCalledWith(provinceId);
  });

  it("stop-points áp mặc định limit=20 và ép kiểu query", async () => {
    await fetch(`${base}/stop-points?type=BUS_STATION&limit=5`);
    expect(listStopPoints).toHaveBeenLastCalledWith({
      type: "BUS_STATION",
      limit: 5,
    });
    await fetch(`${base}/stop-points`);
    expect(listStopPoints).toHaveBeenLastCalledWith({ limit: 20 });
  });

  it("stop-points nhận từ khoá `q` (cắt khoảng trắng); `q` trống coi như không tìm", async () => {
    await fetch(
      `${base}/stop-points?q=${encodeURIComponent("  bến xe miền đông ")}`,
    );
    expect(listStopPoints).toHaveBeenLastCalledWith({
      q: "bến xe miền đông",
      limit: 20,
    });
    await fetch(`${base}/stop-points?q=${encodeURIComponent("   ")}`);
    expect(listStopPoints).toHaveBeenLastCalledWith({
      q: undefined,
      limit: 20,
    });
  });

  it.each([
    "wards",
    "wards?provinceId=khong-phai-uuid",
    "stop-points?limit=0",
    "stop-points?limit=101",
    "stop-points?type=AIRPORT",
    "stop-points?cursor=abc",
    "stop-points?wardId=abc",
    `stop-points?q=${"x".repeat(101)}`,
    "popular-routes?limit=0",
    "popular-routes?limit=21",
    "featured-operators?limit=abc",
  ])(
    "GET /catalog/%s → 400 problem+json, service không bị gọi",
    async (path) => {
      const response = await fetch(`${base}/${path}`);
      expect(response.status).toBe(400);
      expect(response.headers.get("content-type")).toContain(
        "application/problem+json",
      );
      expect(listWards).not.toHaveBeenCalled();
      expect(listStopPoints).not.toHaveBeenCalled();
      expect(listPopularRoutes).not.toHaveBeenCalled();
      expect(listFeaturedOperators).not.toHaveBeenCalled();
    },
  );
});
