import { randomUUID } from "node:crypto";
import type Redis from "ioredis";
import { beforeEach, describe, expect, it, vi } from "vitest";
import type { PrismaService } from "../database/prisma.service";
import { loadActiveFareRules, loadPublicTrip, searchTripCandidates, type SearchCandidate } from "../database/public-trips";
import type { StorageProvider } from "../external/storage/storage-provider";
import { PublicTripSchema, TripSearchQuerySchema, TripSearchResponseSchema } from "./dto/public-trip.dto";
import { TripSearchService } from "./trip-search.service";

vi.mock("../database/public-trips", async (importOriginal) => ({
  ...await importOriginal<typeof import("../database/public-trips")>(),
  searchTripCandidates: vi.fn(), loadPublicTrip: vi.fn(), loadActiveFareRules: vi.fn(),
  loadCancellationTiers: vi.fn(async () => new Map()),
}));
vi.mock("../database/public-highlights", async (importOriginal) => ({
  ...await importOriginal<typeof import("../database/public-highlights")>(),
  loadOperatorRatings: async () => new Map(),
}));
vi.mock("../database/segment-offers", () => ({ loadPublicSegmentOffers: async () => new Map() }));
vi.mock("../database/stop-localities", () => ({ loadWardLocalities: async () => new Map() }));

describe("logo nhà xe trong kết quả và chi tiết chuyến", () => {
  const operatorId = randomUUID();
  const tripId = randomUUID();
  const routeId = randomUUID();
  const departureAt = new Date("2031-05-10T01:00:00Z");
  const arrivalAt = new Date("2031-05-10T07:00:00Z");
  const logoKey = `operator-logos/${operatorId}/logo.png`;
  const publicUrl = vi.fn((key: string) => `https://cdn.test/${key}`);
  const service = new TripSearchService({} as PrismaService, { publicUrl } as unknown as StorageProvider,
    { get: async () => null, set: async () => "OK" } as unknown as Redis);

  beforeEach(() => {
    vi.clearAllMocks();
    vi.mocked(loadActiveFareRules).mockResolvedValue([
      { routeId, vehicleTypeId: null, seatType: null, validFrom: null, validTo: null, price: 300000n },
    ]);
  });

  it.each([true, false])("tìm chuyến trả URL logo riêng với ảnh xe, hoặc null khi chưa có: %s", async (hasLogo) => {
    const candidate: SearchCandidate = {
      tripId, operatorId, operatorName: "Nhà xe", operatorSlug: "nha-xe", operatorLogoKey: hasLogo ? logoKey : null,
      routeId, routeName: "A → B", vehicleTypeId: "vehicle-type", vehicleTypeName: "Giường nằm", vehicleForm: "SLEEPER", vehicleClass: "STANDARD",
      departureAt, arrivalAt, onlineSaleCutoffMinutes: 60,
      pickupSequence: 1, pickupName: "A", pickupAddress: "Địa chỉ A", pickupAt: departureAt, pickupWardId: "ward-a",
      dropoffSequence: 2, dropoffName: "B", dropoffAddress: "Địa chỉ B", dropoffAt: arrivalAt, dropoffWardId: "ward-b",
      availableSeats: 10, availableSeatTypes: ["BED"], coverImageKey: "vehicles/bus.jpg", amenityIds: [], amenityNames: [],
    };
    vi.mocked(searchTripCandidates).mockResolvedValue([candidate]);
    const result = TripSearchResponseSchema.parse(await service.search(TripSearchQuerySchema.parse({ date: "2031-05-10" })));
    expect(result.items[0]!.operator.logoUrl).toBe(hasLogo ? `https://cdn.test/${logoKey}` : null);
    expect(result.items[0]!.vehicleCoverImageUrl).toBe("https://cdn.test/vehicles/bus.jpg");
    expect(result.items[0]!.operator).not.toHaveProperty("logoObjectKey");
  });

  it.each([true, false])("chi tiết chuyến trả logo công khai hoặc null: %s", async (hasLogo) => {
    const point = { name: "Điểm", address: "Địa chỉ", wardId: "ward" };
    const trip = {
      id: tripId, departureAt, arrivalAt, onlineSaleCutoffMinutes: 60, note: null,
      operator: { id: operatorId, displayName: "Nhà xe", operatorSlug: "nha-xe", logoObjectKey: hasLogo ? logoKey : null, hotline: null },
      route: { id: routeId, name: "A → B" },
      vehicle: { vehicleType: { id: "type", name: "Giường nằm", form: "SLEEPER", class: "STANDARD" }, amenities: [], images: [] },
      seats: [],
      stops: [
        { sequence: 1, plannedAt: departureAt, allowPickup: true, allowDropoff: false, catalogStopPoint: point },
        { sequence: 2, plannedAt: arrivalAt, allowPickup: false, allowDropoff: true, catalogStopPoint: point },
      ],
    } as unknown as NonNullable<Awaited<ReturnType<typeof loadPublicTrip>>>;
    vi.mocked(loadPublicTrip).mockResolvedValue(trip);
    const result = await service.getTrip(tripId);
    const operator = PublicTripSchema.shape.operator.parse(result.operator);
    expect(operator.logoUrl).toBe(hasLogo ? `https://cdn.test/${logoKey}` : null);
    expect(operator).not.toHaveProperty("logoObjectKey");
  });
});
