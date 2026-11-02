import { randomUUID } from "node:crypto";
import { describe, expect, it, vi } from "vitest";
import type { PrismaService } from "../database/prisma.service";
import { loadFeaturedOperators } from "../database/public-highlights";
import { CatalogService } from "./catalog.service";

vi.mock("../database/public-highlights", () => ({ loadFeaturedOperators: vi.fn(), loadPopularRoutes: vi.fn() }));

function stopPoint(id: string) {
  return {
    id,
    name: `Bến ${id}`,
    type: "BUS_STATION",
    address: "x",
    provinceId: randomUUID(),
    wardId: randomUUID(),
    latitude: 10,
    longitude: 106,
    description: null,
  };
}

function serviceWith(rows: unknown[]) {
  const findMany = vi.fn(async () => rows);
  const queryRaw = vi.fn(async (): Promise<unknown[]> => []);
  const prisma = {
    province: { findMany },
    ward: { findMany },
    stopPointCatalog: { findMany },
    vehicleType: { findMany },
    amenity: { findMany },
    $queryRaw: queryRaw,
  } as unknown as PrismaService;
  return { service: new CatalogService(prisma, { publicUrl: (key) => `https://cdn.test/${key}` }), findMany, queryRaw };
}

describe("CatalogService — chỉ ACTIVE + cursor", () => {
  it.each([
    ["listProvinces", (s: CatalogService) => s.listProvinces()],
    ["listVehicleTypes", (s: CatalogService) => s.listVehicleTypes()],
    ["listAmenities", (s: CatalogService) => s.listAmenities()],
  ])("%s chỉ đọc item ACTIVE, sắp theo mã", async (_name, call) => {
    const { service, findMany } = serviceWith([]);
    await call(service);
    expect(findMany).toHaveBeenCalledWith(
      expect.objectContaining({
        where: { status: "ACTIVE" },
        orderBy: { code: "asc" },
      }),
    );
  });

  it("listWards lọc đúng tỉnh + ACTIVE, ẩn phường của tỉnh đã vô hiệu hoá", async () => {
    const { service, findMany } = serviceWith([]);
    const provinceId = randomUUID();
    await service.listWards(provinceId);
    expect(findMany).toHaveBeenCalledWith(
      expect.objectContaining({
        where: { provinceId, status: "ACTIVE", province: { status: "ACTIVE" } },
      }),
    );
  });

  it("listStopPoints: lọc ACTIVE + filter, cursor là `id > cursor` (không dùng skip), lấy dư 1 để biết còn trang", async () => {
    const { service, findMany } = serviceWith([]);
    const cursor = randomUUID();
    const provinceId = randomUUID();
    await service.listStopPoints({
      provinceId,
      type: "OFFICE",
      cursor,
      limit: 5,
    });
    expect(findMany).toHaveBeenCalledWith(
      expect.objectContaining({
        where: {
          status: "ACTIVE",
          ward: { status: "ACTIVE", province: { status: "ACTIVE" } },
          provinceId,
          wardId: undefined,
          type: "OFFICE",
          id: { gt: cursor },
        },
        orderBy: { id: "asc" },
        take: 6,
      }),
    );
    const call = findMany.mock.calls[0] as unknown as [Record<string, unknown>];
    expect(call[0]).not.toHaveProperty("skip");
    expect(call[0]).not.toHaveProperty("cursor");
  });

  it("listStopPoints: `q` so với cột `search_text` bằng từ khoá database đã chuẩn hoá; không có `q` thì không thêm điều kiện, không hỏi database", async () => {
    const { service, findMany, queryRaw } = serviceWith([]);
    queryRaw.mockResolvedValueOnce([{ value: "ben xe 50%" }]);
    await service.listStopPoints({ q: "Bến xe 50%", limit: 20 });
    const [withQuery] = findMany.mock.calls[0] as unknown as [
      { where: Record<string, unknown> },
    ];
    expect(withQuery.where.searchText).toEqual({ contains: "ben xe 50\\%" });

    await service.listStopPoints({ limit: 20 });
    const [withoutQuery] = findMany.mock.calls[1] as unknown as [
      { where: Record<string, unknown> },
    ];
    expect(withoutQuery.where).not.toHaveProperty("searchText");
    expect(queryRaw).toHaveBeenCalledTimes(1);
  });

  it("nextCursor = id cuối trang khi còn dòng; null ở trang cuối", async () => {
    const rows = ["a", "b", "c"].map(stopPoint);
    const more = await serviceWith(rows).service.listStopPoints({ limit: 2 });
    expect(more.items.map((item) => item.id)).toEqual(["a", "b"]);
    expect(more.nextCursor).toBe("b");

    const last = await serviceWith(rows.slice(0, 2)).service.listStopPoints({
      limit: 2,
    });
    expect(last.items).toHaveLength(2);
    expect(last.nextCursor).toBeNull();
  });
});

describe("CatalogService — nhà xe tiêu biểu", () => {
  it("ghép khóa logo thành địa chỉ ở kho công khai; chưa có logo → logoUrl null; không lộ khóa object", async () => {
    const withLogo = randomUUID();
    const withoutLogo = randomUUID();
    const logoKey = `operator-logos/${withLogo}/${randomUUID()}.png`;
    vi.mocked(loadFeaturedOperators).mockResolvedValueOnce([
      { operatorId: withLogo, displayName: "Phương Trang", logoObjectKey: logoKey, averageRating: 4.6, reviewCount: 12, routes: [] },
      { operatorId: withoutLogo, displayName: "Thành Bưởi", logoObjectKey: null, averageRating: null, reviewCount: 0, routes: [] },
    ]);
    const { items } = await serviceWith([]).service.listFeaturedOperators(5);
    expect(items.map((item) => item.logoUrl)).toEqual([`https://cdn.test/${logoKey}`, null]);
    expect(JSON.stringify(items)).not.toContain("logoObjectKey");
  });
});
