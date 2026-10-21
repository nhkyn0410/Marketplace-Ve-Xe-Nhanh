import { beforeEach, describe, expect, it, vi } from "vitest";
import { getProvinces, getStopPoints } from "./catalog";
import { getArticles, getLegalDocument } from "./content";
import { searchTrips } from "./trips";
import { apiRequest } from "./api";

vi.mock("./api", () => ({ apiRequest: vi.fn() }));

describe("public web API adapters", () => {
  beforeEach(() => { vi.mocked(apiRequest).mockReset(); });

  it("unwraps catalog envelopes instead of treating the response object as an array", async () => {
    const province = { id: "province", code: "79", name: "TP. Hồ Chí Minh" };
    vi.mocked(apiRequest).mockResolvedValueOnce({ status: "ok", data: { items: [province] } });
    expect(await getProvinces()).toEqual({ status: "ok", data: [province] });
    vi.mocked(apiRequest).mockResolvedValueOnce({ status: "ok", data: { items: [], nextCursor: null } });
    expect(await getStopPoints("Bến xe & Văn phòng")).toEqual({ status: "ok", data: [] });
    expect(apiRequest).toHaveBeenLastCalledWith("/catalog/stop-points?limit=100&q=B%E1%BA%BFn+xe+%26+V%C4%83n+ph%C3%B2ng");
  });

  it("preserves API failures instead of showing preview catalog data", async () => {
    const failure = { status: "error", endpoint: "GET /catalog/provinces", message: "Máy chủ tạm gián đoạn" } as const;
    vi.mocked(apiRequest).mockResolvedValue(failure);
    expect(await getProvinces()).toEqual(failure);
  });

  it("passes filter query and keeps the server total for pagination even if the current page is empty", async () => {
    vi.mocked(apiRequest).mockResolvedValue({ status: "ok", data: { items: [], total: 41, page: 3, limit: 20, facets: { operators: [], priceMin: null, priceMax: null } } });
    const result = await searchTrips({ origin: "p1", destination: "p2", date: "2026-10-22", page: "3", passengers: 2 });
    expect(apiRequest).toHaveBeenCalledWith("/trips/search?date=2026-10-22&passengers=2&fromProvinceId=p1&toProvinceId=p2&page=3&sort=departure");
    expect(result).toMatchObject({ status: "ok", data: { summary: { totalTrips: 41, passengerCount: 2 }, trips: [] } });
  });

  it("maps categories, article pagination and nullable cover without invented view counts", async () => {
    vi.mocked(apiRequest).mockImplementation(async (path) => path.startsWith("/articles?")
      ? { status: "ok", data: { items: [{ title: "Đi xe", slug: "di-xe", summary: "Cẩm nang", coverImageUrl: null,
        featured: false, category: { name: "Cẩm nang", slug: "cam-nang" }, publishedAt: "2026-10-20T00:00:00Z" }], nextCursor: "next" } }
      : { status: "ok", data: { items: [{ name: "Cẩm nang", slug: "cam-nang", articleCount: 2 }] } });
    const result = await getArticles("cam-nang", "previous");
    expect(apiRequest).toHaveBeenCalledWith("/articles?limit=24&category=cam-nang&cursor=previous");
    expect(result).toMatchObject({ status: "ok", data: { nextCursor: "next", articles: [{ slug: "di-xe", coverImageUrl: "", viewsCountText: "" }], categories: [{ count: 2 }, { slug: "cam-nang", count: 2 }] } });
  });

  it("uses published static content and never substitutes an invented effective date", async () => {
    vi.mocked(apiRequest).mockResolvedValue({ status: "ok", data: { id: "legal", title: "Điều khoản", bodyMarkdown: "Nội dung thật", updatedAt: "2026-10-20T00:00:00Z" } });
    expect(await getLegalDocument("terms")).toMatchObject({ status: "ok", data: { title: "Điều khoản", effectiveDateText: "", sections: [{ paragraphs: ["Nội dung thật"] }] } });
    expect(apiRequest).toHaveBeenCalledWith("/content-pages/terms");
  });
});
