import { randomUUID } from "node:crypto";
import { afterAll, beforeAll, describe, expect, it } from "vitest";
import { parseAppConfig } from "../config/env.config";
import { reconcileEscrow } from "./escrow-reconciliation";
import { PrismaService } from "./prisma.service";

const url = process.env.DATABASE_URL;
const requireDb = process.env.REQUIRE_DB_TESTS === "1";
describe.skipIf(!url && !requireDb)("Đối soát escrow / kỳ chi trả — Postgres", () => {
  const operatorId = randomUUID();
  const payoutId = randomUUID();
  const entryId = randomUUID();
  const tag = randomUUID().slice(0, 8);
  let prisma: PrismaService;
  beforeAll(async () => {
    prisma = new PrismaService(parseAppConfig({ DATABASE_URL: url }));
    await prisma.withSystem(async (tx) => {
      await tx.operatorProfile.create({ data: { id: operatorId, operatorSlug: `reconcile-${tag}`, displayName: "Nhà xe đối soát" } });
      await tx.escrowLedger.create({ data: { id: entryId, operatorId, entryType: "ADJUSTMENT", amount: 9_007_199_254_740_993n, eligibleAt: new Date(), note: "Bút toán kiểm thử đối soát", createdBy: "system" } });
      await tx.payout.create({ data: {
        id: payoutId, payoutCode: `PO-20261019-${Math.floor(Math.random() * 1000000)}`, operatorId, period: new Date("2026-10-19"),
        status: "ON_HOLD", holdReason: "Kiểm thử đối soát", grossAmount: 0n, commissionAmount: 0n, refundAmount: 0n,
        adjustmentAmount: 9_007_199_254_740_993n, amount: 9_007_199_254_740_993n,
        items: { create: [{ ledgerEntryId: entryId, entryType: "ADJUSTMENT", amount: 9_007_199_254_740_993n }] },
      } });
    });
  });
  afterAll(async () => {
    if (!prisma) return;
    await prisma.withSystem(async (tx) => {
      await tx.$executeRaw`SELECT set_config('app.allow_ledger_delete', 'on', true)`;
      await tx.payoutItem.deleteMany({ where: { payoutId } });
      await tx.payout.deleteMany({ where: { id: payoutId } });
      await tx.escrowLedger.deleteMany({ where: { id: entryId } });
      await tx.operatorProfile.deleteMany({ where: { id: operatorId } });
    });
    await prisma.$disconnect();
  });
  it("khớp số lớn chính xác; phát hiện lệch item / tổng kỳ mà không tự sửa", async () => {
    expect((await reconcileEscrow(prisma)).issues.filter((issue) => issue.operatorId === operatorId)).toEqual([]);
    await prisma.withSystem((tx) => tx.payoutItem.updateMany({ where: { payoutId }, data: { amount: 9_007_199_254_740_992n } }));
    const result = await reconcileEscrow(prisma);
    expect(result.issues.filter((issue) => issue.operatorId === operatorId)).toEqual(expect.arrayContaining([
      expect.objectContaining({ checkpoint: "PAYOUT_TOTAL", expected: "9007199254740993", actual: "9007199254740992" }),
      expect.objectContaining({ checkpoint: "PAYOUT_ITEM", expected: "9007199254740993", actual: "9007199254740992" }),
    ]));
    expect(await prisma.withSystem((tx) => tx.payoutItem.findFirstOrThrow({ where: { payoutId }, select: { amount: true } }))).toEqual({ amount: 9_007_199_254_740_992n });
  });
});
