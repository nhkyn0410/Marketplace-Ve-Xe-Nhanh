import { randomUUID } from "node:crypto";
import type { AddressInfo } from "node:net";
import { type INestApplication, Module } from "@nestjs/common";
import { APP_INTERCEPTOR, NestFactory } from "@nestjs/core";
import { ZodSerializerInterceptor, ZodValidationPipe } from "nestjs-zod";
import { afterAll, beforeAll, beforeEach, describe, expect, it, vi } from "vitest";
import { ProblemDetailsExceptionFilter } from "../common/errors/problem-details.filter";
import { APP_CONFIG, type AppConfig } from "../config/env.config";
import { type AccessTokenClaims, TokenService } from "../iam/auth/token.service";
import { SessionService } from "../iam/session/session.service";
import { configureApiRoutes } from "../openapi/openapi";
import { SeatMapController } from "./seat-map.controller";
import { SeatMapService } from "./seat-map.service";
import { VehicleImageController } from "./vehicle-image.controller";
import { VehicleImageService } from "./vehicle-image.service";
import { VehicleController } from "./vehicle.controller";
import { VehicleService } from "./vehicle.service";

/** Route thật + chuỗi guard `@Authorize` thật; nghiệp vụ service kiểm ở test DB. */
describe("Vehicle / SeatMap routes — HTTP", () => {
  const operatorId = randomUUID();
  const vehicleId = randomUUID();
  const seatMapId = randomUUID();
  const now = new Date().toISOString();
  const vehicle = {
    id: vehicleId,
    plateNumber: "51B12345",
    vehicleTypeId: randomUUID(),
    seatMapId: null,
    seatMap: null,
    seatMapLocked: false,
    amenityIds: [],
    images: [],
    status: "ACTIVE",
    description: null,
    createdAt: now,
    updatedAt: now,
  };
  const imageKey = `vehicles/${operatorId}/${vehicleId}/${randomUUID()}.jpg`;
  const image = {
    id: randomUUID(),
    objectKey: imageKey,
    url: `https://cdn.test/${imageKey}`,
    position: 0,
    caption: "Ngoại thất",
  };
  const uploadGrant = {
    uploadUrl: "https://upload.test/put?signature=abc",
    objectKey: imageKey,
    expiresAt: now,
  };
  const seatMap = {
    id: seatMapId,
    name: "Ghế 2",
    seatCount: 1,
    passengerCapacity: 2,
    deckCount: 1,
    inUse: false,
    layout: { decks: [{ deck: 1, rows: 1, columns: 1 }] },
    seats: [{ code: "A1", deck: 1, row: 1, column: 1, type: "CABIN_DOUBLE" }],
    createdAt: now,
    updatedAt: now,
  };
  const vehicles = {
    list: vi.fn(async () => ({ items: [vehicle], nextCursor: null })),
    get: vi.fn(async () => vehicle),
    create: vi.fn(async () => vehicle),
    update: vi.fn(async () => vehicle),
  };
  const images = {
    createUploadUrl: vi.fn(async () => uploadGrant),
    replace: vi.fn(async () => ({ images: [image] })),
  };
  const seatMaps = {
    list: vi.fn(async () => ({ items: [], nextCursor: null })),
    get: vi.fn(async () => seatMap),
    create: vi.fn(async () => seatMap),
    update: vi.fn(async () => seatMap),
  };
  let app: INestApplication;
  let base: string;
  let tokens: TokenService;

  const config = { NODE_ENV: "test", JWT_ACCESS_TTL_SECONDS: 900, JWT_ISSUER: "vexenhanh-test" } as AppConfig;

  @Module({
    controllers: [VehicleController, VehicleImageController, SeatMapController],
    providers: [
      { provide: APP_INTERCEPTOR, useClass: ZodSerializerInterceptor },
      { provide: APP_CONFIG, useValue: config },
      TokenService,
      { provide: VehicleService, useValue: vehicles },
      { provide: VehicleImageService, useValue: images },
      { provide: SeatMapService, useValue: seatMaps },
      {
        provide: SessionService,
        useValue: { assertActive: async () => undefined, assertOperatorAccountCurrent: async () => undefined },
      },
    ],
  })
  class HttpTestModule {}

  beforeAll(async () => {
    app = await NestFactory.create(HttpTestModule, { logger: false, abortOnError: false });
    app.useGlobalPipes(new ZodValidationPipe());
    app.useGlobalFilters(new ProblemDetailsExceptionFilter());
    configureApiRoutes(app);
    await app.listen(0, "127.0.0.1");
    base = `http://127.0.0.1:${(app.getHttpServer().address() as AddressInfo).port}/v1/operator`;
    tokens = app.get(TokenService);
  }, 15_000);

  afterAll(async () => {
    await app?.close();
  });

  beforeEach(() => {
    vi.clearAllMocks();
  });

  async function token(role: AccessTokenClaims["role"]): Promise<string> {
    const platform = role === "PLATFORM_ADMIN" || role === "PLATFORM_SUPPORT";
    return (
      await tokens.mintAccessToken({
        sub: randomUUID(),
        sid: randomUUID(),
        scope: platform ? "platform" : "operator",
        role,
        ...(platform ? {} : { operatorId, operatorSlug: "test-operator" }),
        ...(role === "OPERATOR_OWNER" || platform ? { mfa: true } : {}),
      })
    ).accessToken;
  }

  async function call(method: string, path: string, accessToken?: string, body?: object) {
    const response = await fetch(`${base}${path}`, {
      method,
      headers: {
        ...(accessToken ? { authorization: `Bearer ${accessToken}` } : {}),
        "content-type": "application/json",
      },
      ...(body ? { body: JSON.stringify(body) } : {}),
    });
    return { status: response.status, body: (await response.json()) as Record<string, unknown> };
  }

  const vehicleBody = {
    plateNumber: "51b-123.45",
    vehicleTypeId: randomUUID(),
    seatMapId: null,
    amenityIds: [],
    status: "ACTIVE",
    description: null,
  };
  const seatMapBody = {
    name: "Ghế 2",
    layout: { decks: [{ deck: 1, rows: 1, columns: 1 }] },
    seats: [{ code: "a1", deck: 1, row: 1, column: 1, type: "SEAT" }],
  };
  const uploadBody = { contentType: "image/jpeg", sizeBytes: 1024 };
  const imagesBody = { images: [{ objectKey: imageKey, caption: "Ngoại thất" }] };
  const routes: [string, string, object | undefined, number][] = [
    ["POST", `/vehicles/${vehicleId}/images/upload-url`, uploadBody, 200],
    ["PUT", `/vehicles/${vehicleId}/images`, imagesBody, 200],
    ["GET", "/vehicles", undefined, 200],
    ["GET", `/vehicles/${vehicleId}`, undefined, 200],
    ["POST", "/vehicles", vehicleBody, 201],
    ["PUT", `/vehicles/${vehicleId}`, vehicleBody, 200],
    ["GET", "/seat-maps", undefined, 200],
    ["GET", `/seat-maps/${seatMapId}`, undefined, 200],
    ["POST", "/seat-maps", seatMapBody, 201],
    ["PUT", `/seat-maps/${seatMapId}`, seatMapBody, 200],
  ];

  it.each(routes)("%s %s: Owner được, không token 401, Employee/Platform 403", async (method, path, body, ok) => {
    expect((await call(method, path, await token("OPERATOR_OWNER"), body)).status).toBe(ok);
    expect((await call(method, path, undefined, body)).status).toBe(401);
    for (const role of ["DRIVER", "TICKET_STAFF", "SUPPORT_STAFF", "PLATFORM_ADMIN"] as const) {
      const denied = await call(method, path, await token(role), body);
      expect(denied.status, role).toBe(403);
      expect(denied.body.code, role).toBe("PERMISSION_DENIED");
    }
  });

  it("service nhận scope tenant lấy từ JWT + dữ liệu đã chuẩn hoá", async () => {
    await call("POST", "/vehicles", await token("OPERATOR_OWNER"), vehicleBody);
    expect(vehicles.create).toHaveBeenCalledWith(
      expect.objectContaining({ db: expect.objectContaining({ kind: "tenant", operatorId }) }),
      expect.objectContaining({ plateNumber: "51B12345", amenityIds: [], status: "ACTIVE" }),
    );
    await call("POST", "/seat-maps", await token("OPERATOR_OWNER"), seatMapBody);
    expect(seatMaps.create).toHaveBeenCalledWith(
      expect.anything(),
      expect.objectContaining({ seats: [expect.objectContaining({ code: "A1" })] }),
    );
  });

  it("ảnh xe: service nhận tài khoản + scope tenant từ JWT; chú thích được cắt khoảng trắng, rỗng thành null (TRN-009)", async () => {
    const owner = await token("OPERATOR_OWNER");
    const granted = await call("POST", `/vehicles/${vehicleId}/images/upload-url`, owner, uploadBody);
    expect(granted.body).toEqual(uploadGrant);
    expect(images.createUploadUrl).toHaveBeenCalledWith(
      expect.objectContaining({ sub: expect.any(String) }),
      expect.objectContaining({ db: expect.objectContaining({ kind: "tenant", operatorId }) }),
      vehicleId,
      uploadBody,
    );

    const other = `vehicles/${operatorId}/${vehicleId}/${randomUUID()}.png`;
    const saved = await call("PUT", `/vehicles/${vehicleId}/images`, owner, {
      images: [
        { objectKey: imageKey, caption: "  Ngoại thất  " },
        { objectKey: other, caption: "   " },
      ],
      operatorId: randomUUID(),
    });
    expect(saved.body).toEqual({ images: [image] });
    expect(images.replace).toHaveBeenCalledWith(
      expect.objectContaining({ db: expect.objectContaining({ kind: "tenant", operatorId }) }),
      vehicleId,
      {
        images: [
          { objectKey: imageKey, caption: "Ngoại thất" },
          { objectKey: other, caption: null },
        ],
      },
    );
    // Mảng rỗng là yêu cầu hợp lệ: xóa hết ảnh.
    expect((await call("PUT", `/vehicles/${vehicleId}/images`, owner, { images: [] })).status).toBe(200);
  });

  it("ảnh xe: 9 phần tử vẫn tới service (service trả 422 nghiệp vụ), không bị chặn thành 400 ở tầng dữ liệu", async () => {
    const nine = Array.from({ length: 9 }, () => ({
      objectKey: `vehicles/${operatorId}/${vehicleId}/${randomUUID()}.jpg`,
      caption: null,
    }));
    expect((await call("PUT", `/vehicles/${vehicleId}/images`, await token("OPERATOR_OWNER"), { images: nine })).status).toBe(200);
    expect(images.replace).toHaveBeenCalledOnce();
  });

  it.each([
    ["POST", "/images/upload-url", { contentType: "image/gif", sizeBytes: 10 }],
    ["POST", "/images/upload-url", { contentType: "image/svg+xml", sizeBytes: 10 }],
    ["POST", "/images/upload-url", { contentType: "image/jpeg", sizeBytes: 0 }],
    ["POST", "/images/upload-url", { contentType: "image/jpeg", sizeBytes: 5 * 1024 * 1024 + 1 }],
    ["POST", "/images/upload-url", { contentType: "image/jpeg", sizeBytes: 10.5 }],
    ["POST", "/images/upload-url", { sizeBytes: 10 }],
    ["PUT", "/images", {}],
    ["PUT", "/images", { images: [{ objectKey: imageKey }] }],
    ["PUT", "/images", { images: [{ objectKey: imageKey, caption: "x".repeat(61) }] }],
    ["PUT", "/images", { images: [{ objectKey: "", caption: null }] }],
    [
      "PUT",
      "/images",
      {
        images: [
          { objectKey: imageKey, caption: null },
          { objectKey: imageKey, caption: "lặp" },
        ],
      },
    ],
    ["PUT", "/images", { images: Array.from({ length: 51 }, (_, index) => ({ objectKey: `k${index}`, caption: null })) }],
  ])("ảnh xe: %s …%s dữ liệu sai → 400 problem+json, service không bị gọi", async (method, path, body) => {
    const response = await call(method, `/vehicles/${vehicleId}${path}`, await token("OPERATOR_OWNER"), body);
    expect(response.status).toBe(400);
    expect(images.createUploadUrl).not.toHaveBeenCalled();
    expect(images.replace).not.toHaveBeenCalled();
  });

  it("Vehicle trả kèm bộ ảnh; trường lạ service lỡ trả bị serializer cắt (TRN-009)", async () => {
    vehicles.get.mockResolvedValueOnce({
      ...vehicle,
      images: [{ ...image, sizeBytes: 1024, contentType: "image/jpeg", operatorId }],
    } as never);
    const detail = await call("GET", `/vehicles/${vehicleId}`, await token("OPERATOR_OWNER"));
    expect(detail.body.images).toEqual([image]);
  });

  it("Vehicle trả kèm tóm tắt sơ đồ đang gắn, không kèm bố cục / ghế (TRN-011)", async () => {
    const { layout: _layout, seats: _seats, ...summary } = seatMap;
    // Service lỡ trả cả bố cục + ghế thì serializer cắt: danh sách xe chỉ mang phần tóm tắt.
    vehicles.list.mockResolvedValueOnce({
      items: [{ ...vehicle, seatMapId, seatMap }],
      nextCursor: null,
    } as never);
    const listed = await call("GET", "/vehicles", await token("OPERATOR_OWNER"));
    expect(listed.body).toEqual({ items: [{ ...vehicle, seatMapId, seatMap: summary }], nextCursor: null });
  });

  it("SeatMap trả sức chứa + số tầng ở cả chi tiết và danh sách (BR-78, TRN-011)", async () => {
    const owner = await token("OPERATOR_OWNER");
    const detail = await call("GET", `/seat-maps/${seatMapId}`, owner);
    expect(detail.body).toMatchObject({ seatCount: 1, passengerCapacity: 2, deckCount: 1 });
    expect(detail.body.seats).toEqual([{ code: "A1", deck: 1, row: 1, column: 1, type: "CABIN_DOUBLE" }]);

    const { layout: _layout, seats: _seats, ...summary } = seatMap;
    // Service lỡ trả kèm ghế ở danh sách thì serializer cắt: danh sách chỉ có phần tóm tắt.
    seatMaps.list.mockResolvedValueOnce({ items: [seatMap], nextCursor: null } as never);
    expect((await call("GET", "/seat-maps", owner)).body).toEqual({ items: [summary], nextCursor: null });
  });

  it.each(["BED_DOUBLE", "CABIN", "CABIN_DOUBLE"])("POST /seat-maps nhận loại chỗ %s", async (type) => {
    const body = { ...seatMapBody, seats: [{ ...seatMapBody.seats[0], type }] };
    expect((await call("POST", "/seat-maps", await token("OPERATOR_OWNER"), body)).status).toBe(201);
    expect(seatMaps.create).toHaveBeenCalledWith(
      expect.anything(),
      expect.objectContaining({ seats: [expect.objectContaining({ type })] }),
    );
  });

  it("mass assignment: operatorId/id trong body bị bỏ, tenant chỉ lấy từ JWT", async () => {
    const otherTenant = randomUUID();
    await call("POST", "/vehicles", await token("OPERATOR_OWNER"), { ...vehicleBody, operatorId: otherTenant, id: randomUUID() });
    await call("POST", "/seat-maps", await token("OPERATOR_OWNER"), {
      ...seatMapBody,
      operatorId: otherTenant,
      seats: [{ ...seatMapBody.seats[0], id: randomUUID(), operatorId: otherTenant }],
    });
    const [vehicleAuthz, vehicleInput] = vehicles.create.mock.calls[0] as unknown as [
      { db: { operatorId: string } },
      Record<string, unknown>,
    ];
    expect(vehicleAuthz.db.operatorId).toBe(operatorId);
    expect(vehicleInput).not.toHaveProperty("operatorId");
    expect(vehicleInput).not.toHaveProperty("id");
    const [, seatMapInput] = seatMaps.create.mock.calls[0] as unknown as [unknown, { seats: object[] }];
    expect(seatMapInput).not.toHaveProperty("operatorId");
    expect(seatMapInput.seats[0]).not.toHaveProperty("id");
    expect(seatMapInput.seats[0]).not.toHaveProperty("operatorId");
  });

  it.each([
    ["POST", "/vehicles", { ...vehicleBody, plateNumber: "ABC" }],
    ["POST", "/vehicles", { ...vehicleBody, vehicleTypeId: "x" }],
    ["PUT", `/vehicles/${vehicleId}`, { plateNumber: "51B12345" }],
    ["POST", "/seat-maps", { ...seatMapBody, seats: [{ ...seatMapBody.seats[0], row: 2 }] }],
    ["POST", "/seat-maps", { ...seatMapBody, seats: [{ ...seatMapBody.seats[0], type: "SOFA" }] }],
    ["PUT", `/seat-maps/${seatMapId}`, { ...seatMapBody, seats: [{ ...seatMapBody.seats[0], type: "LIMOUSINE" }] }],
    ["GET", "/vehicles?status=BROKEN", undefined],
    ["GET", "/seat-maps?limit=101", undefined],
  ])("%s %s dữ liệu sai → 400 problem+json, service không bị gọi", async (method, path, body) => {
    const response = await call(method, path, await token("OPERATOR_OWNER"), body);
    expect(response.status).toBe(400);
    expect(vehicles.create).not.toHaveBeenCalled();
    expect(vehicles.update).not.toHaveBeenCalled();
    expect(vehicles.list).not.toHaveBeenCalled();
    expect(seatMaps.create).not.toHaveBeenCalled();
    expect(seatMaps.update).not.toHaveBeenCalled();
    expect(seatMaps.list).not.toHaveBeenCalled();
  });
});
