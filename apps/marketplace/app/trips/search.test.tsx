import { renderToReadableStream } from "react-dom/server";
import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";
import ExplorePage from "./explore/page";
import TripsPage from "./page";

const mocks = vi.hoisted(() => ({ cookie: undefined as string | undefined, search: vi.fn() }));

vi.mock("next/headers", () => ({ cookies: async () => ({ get: () => mocks.cookie ? { value: mocks.cookie } : undefined }) }));
vi.mock("next/navigation", () => ({ useRouter: () => ({ push: vi.fn() }), redirect: vi.fn() }));
vi.mock("../../components/passenger-topbar", () => ({ PassengerTopBar: () => null }));
vi.mock("../../lib/data/catalog", () => ({ getProvinces: async () => ({ status: "ok", data: [] }) }));
vi.mock("../../lib/data/trips", () => ({ searchTrips: mocks.search }));

const render = async (page: Awaited<ReturnType<typeof ExplorePage>>) =>
  (await new Response(await renderToReadableStream(page)).text()).replaceAll("<!-- -->", "");

describe("khám phá và tìm chuyến chỉ theo ngày", () => {
  beforeEach(() => {
    vi.useFakeTimers({ toFake: ["Date"] });
    vi.setSystemTime(new Date("2026-10-30T03:00:00Z"));
    mocks.cookie = undefined;
    mocks.search.mockReset().mockResolvedValue({
      status: "ok", data: {
        trips: [], summary: { totalTrips: 0, departureDateText: "2026-11-02", departureDateShortText: "02/11/2026" },
        pagination: { page: 1, limit: 20 }, widenedToProvince: { from: false, to: false }
      }
    });
  });

  afterEach(() => vi.useRealTimers());

  it("mở trang chưa tìm lần nào: xem mọi tuyến trong 14 ngày, có link lọc ngày", async () => {
    const html = await render(await ExplorePage({}));
    expect(mocks.search).toHaveBeenCalledWith({ anyDate: true, date: undefined, sortBy: "earliest" });
    expect(html).toContain("trong 14 ngày tới");
    expect(html).toContain("/trips/explore?all=1&amp;date=2026-10-30");
    expect(html).toContain("Có thể chỉ chọn ngày đi");
  });

  it("chọn ngày mà không chọn điểm: bỏ qua tuyến đã lưu, tải mọi tuyến của đúng ngày", async () => {
    mocks.cookie = "origin=saved-a&destination=saved-b&date=2026-11-01&passengers=3";
    const html = await render(await ExplorePage({ searchParams: Promise.resolve({ date: "2026-11-02" }) }));
    expect(mocks.search).toHaveBeenCalledWith({ anyDate: true, date: "2026-11-02", sortBy: "earliest" });
    expect(html).toContain("02/11/2026");
    expect(html).toContain("Hiện chưa có chuyến mở bán trong ngày đã chọn");
    expect(html).toContain("Xem mọi chuyến trong 14 ngày tới");
  });

  it("có đủ hành trình trên URL thì vẫn tìm theo tuyến và số khách đã chọn", async () => {
    await render(await ExplorePage({ searchParams: Promise.resolve({ origin: "a", destination: "b", date: "2026-11-02", passengers: "2" }) }));
    expect(mocks.search).toHaveBeenCalledWith(expect.objectContaining({ origin: "a", destination: "b", date: "2026-11-02", passengers: 2 }));
  });

  it("trang kết quả nhận ngày và số khách mà không yêu cầu điểm đi / đến", async () => {
    const html = await render(await TripsPage({ searchParams: Promise.resolve({ date: "2026-11-02", passengers: "2" }) }));
    expect(mocks.search).toHaveBeenCalledWith(expect.objectContaining({ origin: undefined, destination: undefined, date: "2026-11-02", passengers: 2 }));
    expect(html).toContain("0 chuyến đang mở bán");
    expect(html).not.toContain("Chọn ngày để xem chuyến");
  });
});
