import { randomUUID } from "node:crypto";
import { afterAll, beforeAll, describe, expect, it } from "vitest";
import { parseAppConfig } from "../../config/env.config";
import { PrismaService } from "../../database/prisma.service";
import type { VerifiedAccessToken } from "../auth/token.service";
import { PassengerProfileService } from "./passenger-profile.service";

const url = process.env.DATABASE_URL;
const requireDb = process.env.REQUIRE_DB_TESTS === "1";
describe.skipIf(!url && !requireDb)("Hồ sơ hành khách — Postgres, cô lập chủ sở hữu", () => {
  const userA = `profile-${randomUUID()}`;
  const userB = `profile-${randomUUID()}`;
  const actor = (sub: string): VerifiedAccessToken => ({ sub, sid: randomUUID(), scope: "passenger", role: "PASSENGER" });
  let prisma: PrismaService;
  let profiles: PassengerProfileService;
  beforeAll(async () => {
    prisma = new PrismaService(parseAppConfig({ DATABASE_URL: url }));
    profiles = new PassengerProfileService(prisma);
    await prisma.withSystem((tx) => tx.user.createMany({ data: [userA, userB].map((id) => ({ id, email: `${id}@example.com`, name: id })) }));
  });
  afterAll(async () => {
    if (!prisma) return;
    await prisma.withSystem((tx) => tx.user.deleteMany({ where: { id: { in: [userA, userB] } } }));
    await prisma.$disconnect();
  });
  it("chỉ sửa hồ sơ mình; không đọc, sửa, xóa hành khách người khác", async () => {
    await profiles.update(actor(userA), { name: "Nguyễn Văn A", phone: "0901234567", dateOfBirth: "1998-01-02" });
    expect(await profiles.get(actor(userA))).toMatchObject({ name: "Nguyễn Văn A", dateOfBirth: "1998-01-02", phone: "0901234567" });
    expect(await profiles.get(actor(userB))).toMatchObject({ name: userB, phone: null });
    const saved = await profiles.createSaved(actor(userA), { fullName: "Nguyễn Văn B", phone: null });
    expect((await profiles.saved(actor(userB))).items).toEqual([]);
    await expect(profiles.updateSaved(actor(userB), saved.passengerId, { fullName: "Giả mạo", phone: null })).rejects.toMatchObject({ status: 404 });
    await expect(profiles.deleteSaved(actor(userB), saved.passengerId)).rejects.toMatchObject({ status: 404 });
    expect((await profiles.saved(actor(userA))).items).toEqual([saved]);
    await profiles.deleteSaved(actor(userA), saved.passengerId);
  });
});
