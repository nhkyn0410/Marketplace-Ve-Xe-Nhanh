import type Redis from "ioredis";
import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";
import type { PrismaService } from "../database/prisma.service";
import { searchTripCandidates } from "../database/public-trips";
import type { StorageProvider } from "../external/storage/storage-provider";
import { TripSearchQuerySchema } from "./dto/public-trip.dto";
import { TripSearchService } from "./trip-search.service";

vi.mock("../database/public-trips", async (importOriginal) => ({
  ...await importOriginal<typeof import("../database/public-trips")>(),
  searchTripCandidates: vi.fn(async () => []),
  loadActiveFareRules: vi.fn(async () => [])
}));
vi.mock("../database/public-highlights", () => ({ loadOperatorRatings: async () => new Map() }));
vi.mock("../database/segment-offers", () => ({ loadPublicSegmentOffers: async () => new Map() }));
vi.mock("../database/stop-localities", () => ({ loadWardLocalities: async () => new Map() }));

describe("xem chuyến mọi tuyến", () => {
  const redis = { get: vi.fn(async () => null), set: vi.fn(async () => "OK") };
  const service = new TripSearchService({} as PrismaService, {} as StorageProvider, redis as unknown as Redis);

  beforeEach(() => {
    vi.clearAllMocks();
    vi.useFakeTimers({ toFake: ["Date"] });
    vi.setSystemTime(new Date("2026-10-30T10:15:00Z"));
  });
  afterEach(() => vi.useRealTimers());

  it("không nhập ngày / điểm: tìm từ bây giờ tới mốc 14 ngày sau", async () => {
    await service.search(TripSearchQuerySchema.parse({}));
    expect(searchTripCandidates).toHaveBeenCalledWith(expect.anything(), expect.objectContaining({
      from: { any: true }, to: { any: true },
      dayStart: new Date("2026-10-30T10:15:00Z"), dayEnd: new Date("2026-11-13T10:15:00Z")
    }));
    expect(redis.set).toHaveBeenCalledWith(expect.stringMatching(/^trip-search:v4:/), expect.any(String), "EX", 60);
  });

  it("chỉ nhập ngày: khớp mọi tuyến trong đúng ngày theo giờ Việt Nam", async () => {
    await service.search(TripSearchQuerySchema.parse({ date: "2026-11-02", passengers: 2 }));
    expect(searchTripCandidates).toHaveBeenCalledWith(expect.anything(), expect.objectContaining({
      from: { any: true }, to: { any: true }, passengers: 2,
      dayStart: new Date("2026-11-01T17:00:00Z"), dayEnd: new Date("2026-11-02T17:00:00Z")
    }));
  });
});
