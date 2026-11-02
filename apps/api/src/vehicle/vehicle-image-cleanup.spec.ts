import { describe, expect, it, vi } from "vitest";
import type { PrismaService } from "../database/prisma.service";
import { ATTACHABLE_MAX_AGE_MS } from "./vehicle-image.service";
import {
  deleteOrphanVehicleImages,
  ORPHAN_MIN_AGE_MS,
  VEHICLE_IMAGE_CLEANUP_SCHEDULE,
  VEHICLE_IMAGE_ROOT,
} from "./vehicle-image-cleanup";

const now = new Date("2026-10-14T03:30:00.000Z");
const hoursAgo = (hours: number) => new Date(now.getTime() - hours * 3_600_000);

function setup(objects: { key: string; lastModified: Date }[], referenced: string[]) {
  const deleted: string[] = [];
  const findMany = vi.fn(async ({ where }: { where: { objectKey: { in: string[] } } }) =>
    referenced.filter((key) => where.objectKey.in.includes(key)).map((objectKey) => ({ objectKey })),
  );
  const withSystem = vi.fn((work: (tx: unknown) => Promise<unknown>) => work({ vehicleImage: { findMany } }));
  const list = vi.fn(async function* (_prefix: string) {
    yield* objects;
  });
  const storage = {
    list,
    delete: vi.fn(async (key: string) => {
      deleted.push(key);
    }),
  };
  return { storage, prisma: { withSystem } as unknown as PrismaService, deleted, findMany, withSystem, list };
}

describe("deleteOrphanVehicleImages", () => {
  it("chỉ xóa object cũ hơn 24 giờ và không còn dòng tham chiếu", async () => {
    const { storage, prisma, deleted, list, withSystem } = setup(
      [
        { key: "vehicles/o/v/orphan-old.jpg", lastModified: hoursAgo(25) },
        { key: "vehicles/o/v/attached-old.jpg", lastModified: hoursAgo(24 * 30) },
        // Vừa tải lên, người dùng chưa kịp bấm lưu.
        { key: "vehicles/o/v/orphan-new.jpg", lastModified: hoursAgo(1) },
        { key: "vehicles/o/v/orphan-edge.jpg", lastModified: new Date(now.getTime() - ORPHAN_MIN_AGE_MS) },
      ],
      ["vehicles/o/v/attached-old.jpg"],
    );
    expect(await deleteOrphanVehicleImages(storage, prisma, now)).toBe(1);
    expect(deleted).toEqual(["vehicles/o/v/orphan-old.jpg"]);
    expect(list).toHaveBeenCalledWith(VEHICLE_IMAGE_ROOT);
    // Bảng có RLS: đọc ngoài ngữ cảnh system thì mọi ảnh trông như mồ côi và bị xóa hết.
    expect(withSystem).toHaveBeenCalledOnce();
  });

  it("kho trống → không hỏi DB, không xóa gì", async () => {
    const { storage, prisma, withSystem } = setup([], []);
    expect(await deleteOrphanVehicleImages(storage, prisma, now)).toBe(0);
    expect(withSystem).not.toHaveBeenCalled();
    expect(storage.delete).not.toHaveBeenCalled();
  });

  it("nhiều object: hỏi DB theo lô, không bỏ sót lô cuối", async () => {
    const objects = Array.from({ length: 1201 }, (_, index) => ({
      key: `vehicles/o/v/${index}.jpg`,
      lastModified: hoursAgo(48),
    }));
    const { storage, prisma, deleted, findMany } = setup(objects, ["vehicles/o/v/0.jpg", "vehicles/o/v/1200.jpg"]);
    expect(await deleteOrphanVehicleImages(storage, prisma, now)).toBe(1199);
    expect(findMany).toHaveBeenCalledTimes(3);
    expect(deleted).not.toContain("vehicles/o/v/0.jpg");
    expect(deleted).not.toContain("vehicles/o/v/1200.jpg");
  });

  it("mốc gắn ảnh nhỏ hơn mốc dọn: object còn gắn được thì job chưa đụng tới", () => {
    expect(ATTACHABLE_MAX_AGE_MS).toBeLessThan(ORPHAN_MIN_AGE_MS);
  });

  it("lịch chạy 03:30 giờ VN mỗi ngày", () => {
    expect(VEHICLE_IMAGE_CLEANUP_SCHEDULE).toEqual({ pattern: "30 3 * * *", tz: "Asia/Ho_Chi_Minh" });
  });
});
