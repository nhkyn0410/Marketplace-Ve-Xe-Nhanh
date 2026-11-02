import { HttpException, HttpStatus, Inject, Injectable } from "@nestjs/common";
import type { UserVoucher } from "@vexenhanh/types";
import { withPassengerLoyalty } from "../database/passenger-loyalty-scope";
import { PrismaService, type DbTransaction } from "../database/prisma.service";
import { DiscountType, LoyaltyPointType, PromotionStatus, UserVoucherSource } from "../database/prisma.types";
import { summarize } from "./admin-loyalty.service";
import type { PassengerLoyaltyTransactionsQueryDto, VoucherListQueryDto } from "./dto/passenger-loyalty.dto";
import { loyaltyInsufficientPoints } from "./loyalty.errors";
import { expireForAccount } from "./loyalty-maintenance";
import { appendEntry, earnedWithinWindow, lockAccount, loyaltyPolicyAt, tierFor } from "./loyalty-rules";
import { queueLoyaltyNotice } from "./loyalty-notifications";

/** Lỗi voucher / đổi điểm theo mã nghiệp vụ trong LLD §7. */
export function voucherProblem(code: string, detail: string, status: HttpStatus = HttpStatus.CONFLICT): HttpException {
  return new HttpException({ code, detail, title: "Voucher error" }, status);
}

/** VXN Plus và ví voucher chỉ lấy chủ sở hữu từ token hành khách (FR-LOY-04..07, FR-PROM-08..10). */
@Injectable()
export class PassengerLoyaltyService {
  constructor(@Inject(PrismaService) private readonly prisma: PrismaService) {}

  /** Thẻ thành viên, hạng kế tiếp và tham số chương trình hiện hành. */
  async member(userId: string) {
    return withPassengerLoyalty(this.prisma, async (tx) => {
      const user = await tx.user.findUniqueOrThrow({ where: { id: userId }, select: { id: true, name: true, email: true, status: true, createdAt: true } });
      const now = new Date();
      const policy = await loyaltyPolicyAt(tx, now);
      return { ...await summarize(tx, user, now), rules: policy?.rules ?? null };
    });
  }

  /** Lịch sử điểm theo bộ lọc; tổng tích / đổi / hết hạn chỉ theo khoảng thời gian, không đổi khi lọc loại giao dịch. */
  async transactions(userId: string, query: PassengerLoyaltyTransactionsQueryDto) {
    return withPassengerLoyalty(this.prisma, async (tx) => {
      const period = { account: { userId }, createdAt: { ...(query.from ? { gte: new Date(query.from) } : {}), ...(query.to ? { lte: new Date(query.to) } : {}) } };
      const where = { ...period, ...(query.type ? { type: query.type } : {}) };
      const total = await tx.loyaltyPointTransaction.count({ where });
      const rows = await tx.loyaltyPointTransaction.findMany({ where, orderBy: [{ createdAt: "desc" }, { id: "desc" }], skip: query.offset, take: query.limit, select: { id: true, type: true, points: true, tier: true, sourceLabel: true, reason: true, policyVersion: true, expiresAt: true, createdAt: true } });
      const sums = await tx.loyaltyPointTransaction.groupBy({ by: ["type"], where: period, _sum: { points: true } });
      const value = (type: LoyaltyPointType) => sums.find((sum) => sum.type === type)?._sum.points ?? 0;
      return { total, items: rows.map((row) => ({ ...row, expiresAt: row.expiresAt?.toISOString() ?? null, createdAt: row.createdAt.toISOString() })), totals: { earned: value(LoyaltyPointType.EARN), redeemed: -value(LoyaltyPointType.REDEEM), expired: -value(LoyaltyPointType.EXPIRE) } };
    });
  }

  /** Khóa sổ điểm, trừ điểm và tạo đúng một voucher cho một khóa yêu cầu (BR-71). */
  async redeem(userId: string, points: number, idempotencyKey: string): Promise<UserVoucher> {
    return withPassengerLoyalty(this.prisma, async (tx) => {
      const account = await lockAccount(tx, userId);
      const key = `REDEEM:${userId}:${idempotencyKey}`;
      const prior = await tx.loyaltyPointTransaction.findUnique({ where: { idempotencyKey: key }, select: { id: true, points: true } });
      if (prior) {
        if (prior.points !== -points) throw voucherProblem("LOYALTY_REQUEST_CONFLICT", "Khóa yêu cầu đã được dùng với số điểm khác.");
        return presentVoucher(tx, await tx.userVoucher.findUniqueOrThrow({ where: { loyaltyTransactionId: prior.id } }));
      }
      const now = new Date();
      await expireForAccount(tx, account.id, now);
      const current = await tx.loyaltyAccount.findUniqueOrThrow({ where: { id: account.id }, select: { availablePoints: true } });
      const policy = await loyaltyPolicyAt(tx, now);
      if (!policy) throw voucherProblem("LOYALTY_NOT_ELIGIBLE", "Chương trình thành viên chưa áp dụng.");
      if (points < policy.rules.minRedeemPoints) throw voucherProblem("LOYALTY_BELOW_MIN_REDEEM", `Cần đổi ít nhất ${policy.rules.minRedeemPoints} điểm.`, HttpStatus.UNPROCESSABLE_ENTITY);
      if (points > current.availablePoints) throw loyaltyInsufficientPoints(current.availablePoints);
      await appendEntry(tx, account.id, { type: LoyaltyPointType.REDEEM, points: -points, tier: tierFor(policy.rules, await earnedWithinWindow(tx, account.id, now)).tier, sourceLabel: `Đổi ${points} điểm lấy voucher Vé Xe Nhanh`, idempotencyKey: key, actor: `user:${userId}`, policy }, now);
      const entry = await tx.loyaltyPointTransaction.findUniqueOrThrow({ where: { idempotencyKey: key }, select: { id: true } });
      const voucher = await tx.userVoucher.create({ data: { userId, source: UserVoucherSource.LOYALTY_REDEMPTION, discountAmount: BigInt(points) * BigInt(policy.rules.pointValue), loyaltyTransactionId: entry.id, policyVersion: policy.version, expiresAt: new Date(now.getTime() + policy.rules.voucherValidityDays * 86_400_000) } });
      await queueLoyaltyNotice(tx, userId, `LOYALTY_REDEEMED:${entry.id}`, "Đổi điểm VXN Plus thành công", `Bạn đã đổi ${points.toLocaleString("vi-VN")} điểm lấy voucher. Mở ví voucher để xem giá trị và hạn dùng.`);
      return presentVoucher(tx, voucher);
    });
  }

  /** Lưu một lần mã công khai đang hiệu lực; thao tác lưu không giữ lượt dùng promotion. */
  async save(userId: string, promotionCode: string): Promise<UserVoucher> {
    return withPassengerLoyalty(this.prisma, async (tx) => {
      const now = new Date();
      const promotion = await tx.promotion.findUnique({ where: { code: promotionCode }, select: { id: true, status: true, startsAt: true, endsAt: true } });
      if (!promotion || promotion.status !== PromotionStatus.ACTIVE || promotion.startsAt > now || promotion.endsAt <= now) throw voucherProblem("VOUCHER_NOT_APPLICABLE", "Mã khuyến mãi chưa hoặc hết hiệu lực.", HttpStatus.UNPROCESSABLE_ENTITY);
      await tx.$executeRaw`SELECT pg_advisory_xact_lock(hashtext(${`save-voucher:${userId}:${promotion.id}`}))`;
      if (await tx.userVoucher.findFirst({ where: { userId, promotionId: promotion.id }, select: { id: true } })) throw voucherProblem("VOUCHER_ALREADY_SAVED", "Mã này đã có trong ví voucher.");
      const voucher = await tx.userVoucher.create({ data: { userId, source: UserVoucherSource.SAVED_PROMOTION, promotionId: promotion.id, expiresAt: promotion.endsAt } });
      await queueLoyaltyNotice(tx, userId, `VOUCHER_SAVED:${voucher.id}`, "Đã lưu voucher", `Mã ${promotionCode} đã được lưu vào ví voucher của bạn.`);
      return presentVoucher(tx, voucher);
    });
  }

  /** Ví của chính hành khách, cập nhật các voucher đã hết hạn trước khi lọc trạng thái. */
  async vouchers(userId: string, query: VoucherListQueryDto) {
    return withPassengerLoyalty(this.prisma, async (tx) => {
      await expireWallet(tx, new Date(), userId);
      const where = { userId, ...(query.status ? { status: query.status } : {}) };
      const total = await tx.userVoucher.count({ where });
      const rows = await tx.userVoucher.findMany({ where, orderBy: [{ createdAt: "desc" }, { id: "desc" }], skip: query.offset, take: query.limit });
      const items: UserVoucher[] = [];
      for (const row of rows) items.push(await presentVoucher(tx, row));
      return { items, total };
    });
  }
}

type VoucherRow = Awaited<ReturnType<DbTransaction["userVoucher"]["findFirstOrThrow"]>>;

/** Chuyển voucher khả dụng đã quá hạn / promotion đã kết thúc sang hết hạn, không đụng voucher đang giữ. */
export async function expireWallet(tx: DbTransaction, now: Date, userId?: string): Promise<number> {
  const rows = await tx.$executeRaw`
    UPDATE user_vouchers v SET status = 'EXPIRED', updated_at = ${now}
    WHERE v.status = 'AVAILABLE' AND (${userId ?? null}::text IS NULL OR v.user_id = ${userId ?? null})
      AND (v.expires_at <= ${now} OR EXISTS (SELECT 1 FROM promotions p WHERE p.id = v.promotion_id AND (p.status IN ('PAUSED', 'ENDED') OR p.ends_at <= ${now})))`;
  return rows;
}

async function presentVoucher(tx: DbTransaction, voucher: VoucherRow): Promise<UserVoucher> {
  const promotion = voucher.promotionId ? await tx.promotion.findUnique({ where: { id: voucher.promotionId }, include: { operator: { select: { displayName: true } } } }) : null;
  return { userVoucherId: voucher.id, source: voucher.source, status: voucher.status, promotionCode: promotion?.code ?? null, name: promotion?.name ?? "Voucher VXN Plus", discountAmount: voucher.discountAmount?.toString() ?? null, discountType: promotion?.discountType ?? DiscountType.AMOUNT, discountValue: (promotion?.discountValue ?? voucher.discountAmount ?? 0n).toString(), maxDiscount: promotion?.maxDiscount?.toString() ?? null, minOrder: (promotion?.minOrder ?? 0n).toString(), appliesTo: promotion ? await promotionAppliesTo(tx, promotion) : "Mọi tuyến, mọi nhà xe", expiresAt: voucher.expiresAt.toISOString(), createdAt: voucher.createdAt.toISOString() };
}

/** Mô tả phạm vi khuyến mãi cho khách: nhà xe, tuyến và chuyến nếu bị giới hạn. */
async function promotionAppliesTo(tx: DbTransaction, promotion: { operator: { displayName: string } | null; routeId: string | null; routeIds: string[]; tripId: string | null }): Promise<string> {
  const routeIds = [...new Set([...promotion.routeIds, ...(promotion.routeId ? [promotion.routeId] : [])])];
  const routes = routeIds.length ? await tx.route.findMany({ where: { id: { in: routeIds } }, orderBy: { name: "asc" }, select: { name: true } }) : [];
  const where = promotion.tripId ? "một chuyến cụ thể" : routes.length ? routes.map((route) => route.name).join(", ") : "mọi tuyến";
  return `${promotion.operator?.displayName ?? "Mọi nhà xe"} · ${where}`;
}
