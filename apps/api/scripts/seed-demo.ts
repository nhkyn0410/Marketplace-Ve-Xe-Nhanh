import { randomUUID } from "node:crypto";
import { existsSync, mkdirSync, writeFileSync } from "node:fs";
import { resolve } from "node:path";
import { HttpException } from "@nestjs/common";
import { BookingService } from "../src/booking/booking.service";
import { parseAppConfig } from "../src/config/env.config";
import { PrismaService, type DbTransaction } from "../src/database/prisma.service";
import { payoutDelayDays } from "../src/escrow/escrow-entries";
import { CredentialService } from "../src/iam/auth/credential.service";
import { earnForBooking } from "../src/loyalty/loyalty-maintenance";
import { maskName } from "../src/payment/admin-payment.service";
import { applyPaymentCallback } from "../src/payment/payment-callback";
import { generatePayouts } from "../src/payout/payout-generation";
import { createTicketQrSigner, type TicketQrSigner } from "../src/ticket/ticket-qr";
import { dateOnly, departureOf, scheduleDates } from "../src/trip/trip-schedule-dates";
import { isDeadlock, isVehicleOverlapViolation } from "../src/trip/trip.errors";
import { insertDraftTrip } from "../src/trip/trip.service";

/**
 * Dữ liệu demo cho cả nền tảng, dùng được trên DB local lẫn production (DEMO-DATA-plan §11).
 *
 * Sinh lịch chạy mẫu cho tuyến chưa có lịch → chuyến từ D−lịch-sử tới D+tương-lai → nhân viên, văn phòng, phân công của nhà
 * xe trưng bày → hành khách mô phỏng → đơn đã đi (thanh toán DEMO, vé, soát vé, hoàn thành chuyến, điểm thưởng, đánh giá)
 * → đơn bán trước cho chuyến sắp chạy → payout từng ngày. Đi qua code nghiệp vụ thật với `now` lùi giờ.
 *
 * Chạy lại an toàn và chính là bước "làm mới" trước buổi demo: chuyến đã có đơn không sinh đơn nữa; chuyến vừa qua (kể cả
 * chuyến bán trước ở lần chạy trước) được soát vé + đóng theo giờ thật; chuyến có đơn KHÔNG phải demo không bị đụng.
 *
 * Không gửi gì ra ngoài: thông báo (vé điện tử, điểm thưởng) phát sinh trong CÙNG transaction được đánh dấu SKIPPED trước khi
 * commit, nên worker production không kịp gửi. Thanh toán chỉ dùng bản ghi cổng DEMO, không gọi cổng thật.
 *
 * Đơn demo nhận ra bằng `hold_id` bắt đầu `de30de30-`; lịch mẫu bằng ghi chú `SCHEDULE_NOTE`. Bút toán escrow và điểm thưởng
 * là append-only (trigger) → gỡ dữ liệu demo trên production = khôi phục bản sao lưu chụp trước khi chạy.
 *
 * Local (bản sao DB):  pnpm exec tsx scripts/seed-demo.ts --database vxn_demo_check
 * Production:          pnpm exec tsx scripts/seed-demo.ts --env .env.production --yes-production --showcase <slug> [--dry-run]
 */

const LOCAL_HOSTS = ["localhost", "127.0.0.1", "::1", "[::1]"];
const HOLD_MARK = "de30de30-";
const SCHEDULE_NOTE = "Lịch mẫu (dữ liệu demo)";
const ACTOR = "system:demo-seed";
const MINUTE = 60_000;
const HOUR = 60 * MINUTE;
const DAY = 24 * HOUR;
const CUTOFF_MINUTES = 30;

type Args = {
  env: string[];
  database?: string;
  operators?: string[];
  showcase?: string;
  historyDays: number;
  futureDays: number;
  presaleDays: number;
  customers: number;
  fill: number;
  passengerEmail?: string;
  reviews: boolean;
  payouts: boolean;
  concurrency: number;
  dryRun: boolean;
  yesProduction: boolean;
  allowDevDb: boolean;
};

type Stop = { sequence: number; allowPickup: boolean; allowDropoff: boolean; key: string; name: string; address: string };
type RouteInfo = { id: string; name: string; durationMinutes: number; stops: Stop[]; vehicleTypeIds: (string | null)[] };
type VehicleInfo = { id: string; plateNumber: string; vehicleTypeId: string };
type ScheduleRow = { id: string; operatorId: string; routeId: string; vehicleId: string | null; departureMinute: number; onlineSaleCutoffMinutes: number; note: string | null; startDate: Date; endDate: Date; daysOfWeek: number };
type OperatorInfo = { id: string; slug: string; name: string; routes: RouteInfo[]; vehicles: VehicleInfo[]; schedules: ScheduleRow[] };
type Customer = { id: string; name: string; phone: string; email: string };
type Staff = { drivers: string[]; ticketStaff: string[]; sales: string[] };
type InsertFn = (
  tx: DbTransaction,
  operatorId: string,
  user: { sub: string } | null,
  hold: unknown,
  input: unknown,
  accessToken: string,
  now: Date,
) => Promise<{ id: string; bookingCode: string }>;

const stats = { schedules: 0, trips: 0, overlaps: 0, staff: 0, assignments: 0, customers: 0, bookings: 0, seats: 0, checkedIn: 0, completed: 0, inProgress: 0, reviews: 0, loyalty: 0, payouts: 0, skippedTrips: 0, failures: 0 };

// --------------------------------------------------------------------------------------------- tham số + môi trường

function parseArgs(argv: string[]): Args {
  const value = (name: string): string | undefined => {
    const index = argv.indexOf(`--${name}`);
    return index >= 0 ? argv[index + 1] : undefined;
  };
  const flag = (name: string) => argv.includes(`--${name}`);
  const number = (name: string, fallback: number) => (value(name) === undefined ? fallback : Number(value(name)));
  // Mặc định như API dev: `.env` + `.env.development`. Production: chỉ `--env .env.production` (không trộn biến local).
  const envFiles = value("env")?.split(",") ?? [".env", ".env.development"];
  const production = envFiles.some((file) => file.includes("production"));
  return {
    env: envFiles,
    database: value("database"),
    operators: value("operators")?.split(","),
    showcase: value("showcase"),
    // Production nhỏ hơn: mỗi đơn ~50 lượt gọi DB qua mạng (≈ 2 giây từ VN tới Supabase SG).
    historyDays: number("history-days", production ? 14 : 30),
    futureDays: number("future-days", 21),
    presaleDays: number("presale-days", production ? 7 : 10),
    customers: number("customers", production ? 40 : 60),
    fill: number("fill", production ? 0.6 : 1),
    passengerEmail: value("passenger-email")?.toLowerCase(),
    // Đánh giá hiện công khai trên Marketplace production → mặc định tắt ở production (chỉ bật khi Khanh đồng ý).
    reviews: flag("reviews") || (!production && !flag("no-reviews")),
    payouts: !flag("no-payouts"),
    concurrency: number("concurrency", 4),
    dryRun: flag("dry-run"),
    yesProduction: flag("yes-production"),
    allowDevDb: flag("allow-dev-db"),
  };
}

function loadEnv(files: string[]): void {
  for (const file of files) {
    const path = resolve(process.cwd(), file);
    if (!existsSync(path)) {
      throw new Error(`Không thấy file môi trường ${file}.`);
    }
    process.loadEnvFile(path);
  }
}

// ------------------------------------------------------------------------------------------------ tiện ích thời gian

const vnDate = (at: Date) => new Date(at.getTime() + 7 * HOUR).toISOString().slice(0, 10);
const vnMidnight = (date: string) => new Date(`${date}T00:00:00+07:00`);
const addDays = (date: string, days: number) => vnDate(new Date(vnMidnight(date).getTime() + days * DAY + 12 * HOUR));
const clock = (minute: number) => `${String(Math.floor(minute / 60)).padStart(2, "0")}:${String(minute % 60).padStart(2, "0")}`;

// -------------------------------------------------------------------------------------------- ngẫu nhiên có hạt giống

function rng(seed: string): () => number {
  let h = 2166136261;
  for (let i = 0; i < seed.length; i++) h = Math.imul(h ^ seed.charCodeAt(i), 16777619);
  return () => {
    h += 0x6d2b79f5;
    let t = h;
    t = Math.imul(t ^ (t >>> 15), t | 1);
    t ^= t + Math.imul(t ^ (t >>> 7), t | 61);
    return ((t ^ (t >>> 14)) >>> 0) / 4294967296;
  };
}
const pick = <T>(random: () => number, items: readonly T[]): T => items[Math.floor(random() * items.length)]!;
const between = (random: () => number, min: number, max: number) => min + (max - min) * random();

const FAMILY = ["Nguyễn", "Trần", "Lê", "Phạm", "Hoàng", "Huỳnh", "Phan", "Vũ", "Võ", "Đặng", "Bùi", "Đỗ", "Hồ", "Ngô", "Dương", "Lý"];
const MIDDLE = ["Văn", "Thị", "Minh", "Ngọc", "Thanh", "Quốc", "Hoài", "Gia", "Bảo", "Thu", "Đức", "Hải", "Phương", "Anh"];
const GIVEN = ["An", "Bình", "Châu", "Dũng", "Giang", "Hà", "Hải", "Hạnh", "Hiếu", "Hoa", "Hùng", "Hương", "Khang", "Khánh", "Lan", "Linh", "Long", "Mai", "Nam", "Nga", "Ngân", "Nhung", "Phúc", "Quân", "Quỳnh", "Sơn", "Tâm", "Thảo", "Trang", "Trí", "Tú", "Tuấn", "Uyên", "Vy", "Yến"];
const PHONE_PREFIX = ["90", "91", "93", "94", "96", "97", "98", "86", "88", "89", "70", "77", "79", "81", "83", "85"];
const fullName = (random: () => number) => `${pick(random, FAMILY)} ${pick(random, MIDDLE)} ${pick(random, GIVEN)}`;
const phone = (random: () => number) => `0${pick(random, PHONE_PREFIX)}${String(Math.floor(random() * 10_000_000)).padStart(7, "0")}`;

const COMMENTS: Record<number, string[]> = {
  5: ["Xe sạch, tài xế chạy êm, đến đúng giờ.", "Nhân viên nhiệt tình, đón đúng điểm hẹn.", "Ghế thoải mái, có nước và khăn lạnh. Sẽ đi lại.", "Đặt vé trên app nhanh, lên xe chỉ cần quét mã.", "Chuyến đi êm, xe mới và thơm."],
  4: ["Xe ổn, xuất bến trễ khoảng 10 phút nhưng có báo trước.", "Tài xế chạy cẩn thận, điều hòa hơi lạnh.", "Đón đúng giờ, wifi hơi yếu, còn lại tốt.", "Giá hợp lý, chỗ để hành lý rộng."],
  3: ["Kẹt xe nên đến muộn gần một tiếng.", "Xe hơi cũ, ghế ngả không hết."],
};
const REPLIES = ["Cảm ơn anh/chị đã tin tưởng đồng hành cùng nhà xe. Hẹn gặp lại trên những chuyến sau!", "Nhà xe ghi nhận góp ý và sẽ nhắc tài xế xuất bến đúng giờ hơn. Cảm ơn anh/chị!", "Cảm ơn anh/chị đã đánh giá. Chúc anh/chị nhiều sức khỏe!"];

// --------------------------------------------------------------------------------------------------- DB + transaction

class Db {
  constructor(
    readonly prisma: PrismaService,
    private readonly readOnly = false,
  ) {}

  /** Transaction scope system, hạn dài hơn API (5 giây không đủ cho một vòng đời đơn qua mạng tới production). */
  run<T>(work: (tx: DbTransaction) => Promise<T>): Promise<T> {
    return this.prisma.$transaction(
      async (tx) => {
        // --dry-run: Postgres từ chối mọi lệnh ghi trong transaction, kể cả khi code có sai sót.
        if (this.readOnly) await tx.$executeRaw`SET TRANSACTION READ ONLY`;
        await tx.$executeRaw`SELECT set_config('app.scope', 'system', true), set_config('app.operator_id', '', true)`;
        return work(tx as DbTransaction);
      },
      { maxWait: 30_000, timeout: 120_000 },
    );
  }
}

/** Prisma "giả" chạy mọi `withSystem` / `withTenant` trên transaction đang mở — để `applyPaymentCallback` ghi chung transaction. */
function bound(tx: DbTransaction): PrismaService {
  const run = <T>(work: (inner: DbTransaction) => Promise<T>) => work(tx);
  return { withSystem: run, withTenant: (_operatorId: string, work: (inner: DbTransaction) => Promise<unknown>) => run(work) } as unknown as PrismaService;
}

async function mapLimit<T>(items: T[], limit: number, work: (item: T, index: number) => Promise<void>): Promise<void> {
  let next = 0;
  const lanes = Array.from({ length: Math.max(1, Math.min(limit, items.length)) }, async () => {
    while (next < items.length) {
      const index = next++;
      await work(items[index]!, index);
    }
  });
  await Promise.all(lanes);
}

// --------------------------------------------------------------------------------------------------------- main

async function main(): Promise<void> {
  const args = parseArgs(process.argv.slice(2));
  loadEnv(args.env);
  if (!process.env.DATABASE_URL) {
    throw new Error("Thiếu DATABASE_URL.");
  }
  const url = new URL(process.env.DATABASE_URL);
  if (args.database) {
    url.pathname = `/${args.database}`;
  }
  const local = LOCAL_HOSTS.includes(url.hostname);
  const dbName = url.pathname.slice(1);
  if (!args.dryRun && !local && !args.yesProduction) {
    throw new Error("DB không phải local: cần --yes-production (sau khi đã sao lưu) hoặc chạy --dry-run.");
  }
  if (!args.dryRun && local && dbName === "vexenhanh_dev" && !args.allowDevDb) {
    throw new Error("Không ghi thẳng vào vexenhanh_dev: dùng --database <bản sao> hoặc --allow-dev-db.");
  }
  if (!local && !args.dryRun && !args.showcase) {
    throw new Error("Production cần chỉ định --showcase <operator-slug>.");
  }

  const config = parseAppConfig({ ...process.env, DATABASE_URL: url.toString() });
  const prisma = new PrismaService(config);
  const db = new Db(prisma, args.dryRun);
  const qr = createTicketQrSigner(config);
  const now = new Date();
  const today = vnDate(now);
  const firstDay = addDays(today, -args.historyDays);
  const lastDay = addDays(today, args.futureDays);
  console.log(`Đích: ${local ? "local" : "PRODUCTION"} / ${dbName} · hôm nay ${today} · chuyến ${firstDay} → ${lastDay} · ${args.dryRun ? "CHỈ ĐỌC" : "GHI"}`);
  console.log(`Lịch sử ${args.historyDays} ngày · bán trước ${args.presaleDays} ngày · hệ số lấp ghế ${args.fill} · đánh giá ${args.reviews ? "bật" : "tắt"} · payout ${args.payouts ? "bật" : "tắt"}`);

  try {
    const operators = await loadScope(db, args);
    const showcase = operators.find((operator) => operator.slug === args.showcase) ?? (local ? [...operators].sort((a, b) => b.vehicles.length - a.vehicles.length)[0] : undefined);
    if (args.showcase && !showcase) {
      throw new Error(`Không thấy nhà xe trưng bày ${args.showcase} trong phạm vi (cần ACTIVE, có tuyến + giá + xe).`);
    }
    console.log(`Phạm vi: ${operators.map((operator) => `${operator.slug}(${operator.routes.length} tuyến, ${operator.vehicles.length} xe, ${operator.schedules.length} lịch)`).join(", ")}`);
    console.log(`Nhà xe trưng bày: ${showcase?.slug ?? "-"}`);

    const plans = planSchedules(operators, firstDay, lastDay);
    for (const plan of plans) {
      console.log(`  lịch mới ${plan.slug} | ${plan.routeName} | ${plan.plate} | ${clock(plan.departureMinute)} (~${Math.round(plan.durationMinutes / 6) / 10} giờ)`);
    }
    if (args.dryRun) {
      await dryRunReport(db, operators, plans.length, firstDay, lastDay, now);
      return;
    }

    await createSchedules(db, operators, plans, firstDay, lastDay);
    await createTrips(db, operators, firstDay, lastDay, now, args.concurrency);
    const staff = showcase ? await ensureShowcaseStaff(db, showcase, local) : null;
    if (showcase && staff) {
      await assignStaff(db, showcase, staff, firstDay, addDays(today, 3));
    }
    const customers = await ensureCustomers(db, args, local, firstDay);
    const persona = customers.persona;

    // Chuyến đã qua (trong khung lịch sử) → đơn đã đi + soát vé + đóng chuyến; chuyến sắp tới → bán trước.
    const trips = await listTrips(db, operators, vnMidnight(firstDay), vnMidnight(addDays(today, args.presaleDays + 1)));
    const loyaltyStart = await db.run((tx) => tx.policyVersion.findFirst({ where: { type: "LOYALTY", operatorId: null, status: "PUBLISHED" }, orderBy: { effectiveFrom: "asc" }, select: { effectiveFrom: true } }));
    const employees = await listCheckers(db, operators.map((operator) => operator.id));
    await mapLimit(trips, args.concurrency, async (trip) => {
      // Deadlock giữa các chuyến chạy song song: transaction đã rollback trọn vẹn, chạy lại chuyến đó (tối đa 3 lần).
      for (let attempt = 1; ; attempt++) {
        try {
          await processTrip(db, qr, trip, { now, args, customers: customers.pool, persona, showcaseId: showcase?.id ?? null, employees, loyaltyFrom: loyaltyStart?.effectiveFrom ?? null, today });
          return;
        } catch (error) {
          if (isDeadlock(error) && attempt < 3) continue;
          stats.failures++;
          console.warn(`  ! chuyến ${trip.id} (${trip.departureAt.toISOString()}): ${describe(error)}`);
          return;
        }
      }
    });

    if (args.payouts) {
      for (let date = addDays(firstDay, 1); date <= today; date = addDays(date, 1)) {
        const at = date === today ? now : new Date(vnMidnight(date).getTime() + 5 * MINUTE);
        const run = await generatePayouts(prisma, at);
        stats.payouts += run.created;
      }
    }
    await sweepNotifications(db);
    if (local) {
      writeAccounts(showcase, staff, persona);
    }
    console.log("Xong:", JSON.stringify(stats));
  } finally {
    await prisma.$disconnect();
  }
}

// --------------------------------------------------------------------------------------------------------- phạm vi

async function loadScope(db: Db, args: Args): Promise<OperatorInfo[]> {
  return db.run(async (tx) => {
    const operators = await tx.operatorProfile.findMany({
      where: { status: "ACTIVE", ...(args.operators ? { operatorSlug: { in: args.operators } } : {}) },
      orderBy: { operatorSlug: "asc" },
      select: { id: true, operatorSlug: true, displayName: true },
    });
    const result: OperatorInfo[] = [];
    for (const operator of operators) {
      const routes = await tx.route.findMany({
        where: { operatorId: operator.id, status: "ACTIVE", parentRouteId: null },
        orderBy: { name: "asc" },
        select: {
          id: true,
          name: true,
          totalDurationSeconds: true,
          stops: {
            orderBy: { sequence: "asc" },
            select: { sequence: true, allowPickup: true, allowDropoff: true, catalogStopPointId: true, stopPointId: true, catalogStopPoint: { select: { name: true, address: true } }, stopPoint: { select: { name: true, address: true } } },
          },
        },
      });
      const rules = await tx.fareRule.findMany({
        // Chỉ giá còn hiệu lực từ hôm nay trở đi — tuyến chỉ có giá đã hết hạn thì không sinh chuyến (bán không được).
        where: { operatorId: operator.id, fare: { status: "ACTIVE", routeId: { in: routes.map((route) => route.id) } }, OR: [{ validTo: null }, { validTo: { gt: new Date() } }] },
        select: { vehicleTypeId: true, fare: { select: { routeId: true } } },
      });
      const usable: RouteInfo[] = routes
        .filter((route) => route.stops.length >= 2 && rules.some((rule) => rule.fare.routeId === route.id))
        .map((route) => ({
          id: route.id,
          name: route.name,
          durationMinutes: Math.max(1, Math.round(route.totalDurationSeconds / 60)),
          vehicleTypeIds: rules.filter((rule) => rule.fare.routeId === route.id).map((rule) => rule.vehicleTypeId),
          stops: route.stops.map((stop) => {
            const place = stop.catalogStopPoint ?? stop.stopPoint;
            return { sequence: stop.sequence, allowPickup: stop.allowPickup, allowDropoff: stop.allowDropoff, key: stop.catalogStopPointId ?? stop.stopPointId ?? place?.name ?? "", name: place?.name ?? "", address: place?.address ?? "" };
          }),
        }));
      const vehicles = await tx.vehicle.findMany({
        where: { operatorId: operator.id, status: "ACTIVE", seatMapId: { not: null } },
        orderBy: { plateNumber: "asc" },
        select: { id: true, plateNumber: true, vehicleTypeId: true },
      });
      if (usable.length === 0 || vehicles.length === 0) {
        continue;
      }
      const schedules = await tx.tripSchedule.findMany({
        where: { operatorId: operator.id, routeId: { in: usable.map((route) => route.id) } },
        select: { id: true, operatorId: true, routeId: true, vehicleId: true, departureMinute: true, onlineSaleCutoffMinutes: true, note: true, startDate: true, endDate: true, daysOfWeek: true },
      });
      result.push({ id: operator.id, slug: operator.operatorSlug, name: operator.displayName, routes: usable, vehicles, schedules });
    }
    return result;
  });
}

// ---------------------------------------------------------------------------------------------------- lịch mẫu

type SchedulePlan = { operatorId: string; slug: string; routeId: string; routeName: string; vehicleId: string; plate: string; departureMinute: number; durationMinutes: number };

/**
 * Tuyến chưa có lịch nào (production hiện 0 lịch) → mỗi xe phù hợp giá chạy một chuỗi chuyến trong ngày. Hai tuyến ngược
 * chiều nhau đi thành cặp (đi rồi về); tuyến lẻ cách nhau đủ thời gian quay đầu. Xe chưa chắc rảnh (chuyến tạo tay) — trùng
 * thì bước tạo chuyến bỏ qua nhờ ràng buộc chống trùng xe.
 */
function planSchedules(operators: OperatorInfo[], firstDay: string, lastDay: string): SchedulePlan[] {
  void firstDay;
  void lastDay;
  const plans: SchedulePlan[] = [];
  for (const operator of operators) {
    const bare = operator.routes.filter((route) => !operator.schedules.some((schedule) => schedule.routeId === route.id));
    if (bare.length === 0) continue;
    const units: RouteInfo[][] = [];
    const used = new Set<string>();
    for (const route of bare) {
      if (used.has(route.id)) continue;
      const first = route.stops[0]!.key;
      const last = route.stops[route.stops.length - 1]!.key;
      const back = bare.find((other) => !used.has(other.id) && other.id !== route.id && other.stops[0]!.key === last && other.stops[other.stops.length - 1]!.key === first);
      used.add(route.id);
      if (back) used.add(back.id);
      units.push(back ? [route, back] : [route]);
    }
    const fits = (vehicle: VehicleInfo, unit: RouteInfo[]) => unit.every((route) => route.vehicleTypeIds.some((typeId) => typeId === null || typeId === vehicle.vehicleTypeId));
    const fleet = new Map<RouteInfo[], VehicleInfo[]>(units.map((unit) => [unit, []]));
    for (const vehicle of operator.vehicles) {
      const candidates = units.filter((unit) => fits(vehicle, unit));
      if (candidates.length === 0) continue;
      candidates.sort((a, b) => fleet.get(a)!.length - fleet.get(b)!.length);
      fleet.get(candidates[0]!)!.push(vehicle);
    }
    for (const [unit, vehicles] of fleet) {
      vehicles.forEach((vehicle, k) => {
        let minute = 6 * 60 + 30 + k * 80;
        for (let leg = 0; minute <= 21 * 60 && leg < 6; leg++) {
          const route = unit[leg % unit.length]!;
          plans.push({ operatorId: operator.id, slug: operator.slug, routeId: route.id, routeName: route.name, vehicleId: vehicle.id, plate: vehicle.plateNumber, departureMinute: minute, durationMinutes: route.durationMinutes });
          // Cặp tuyến: nghỉ 90 phút rồi chạy chiều về; tuyến lẻ: chạy rỗng về bến rồi mới chạy lượt sau.
          minute += unit.length === 2 ? route.durationMinutes + 90 : 2 * route.durationMinutes + 120;
          minute = Math.ceil(minute / 15) * 15;
        }
      });
    }
  }
  return plans;
}

async function createSchedules(db: Db, operators: OperatorInfo[], plans: SchedulePlan[], firstDay: string, lastDay: string): Promise<void> {
  for (const plan of plans) {
    const row = await db.run((tx) =>
      tx.tripSchedule.create({
        data: {
          operatorId: plan.operatorId,
          routeId: plan.routeId,
          vehicleId: plan.vehicleId,
          departureMinute: plan.departureMinute,
          durationMinutes: plan.durationMinutes,
          daysOfWeek: 0b1111111,
          startDate: dateOnly(firstDay),
          // CHECK `trip_schedules_date_range`: một lịch dài tối đa 92 ngày.
          endDate: dateOnly([addDays(lastDay, 60), addDays(firstDay, 90)].sort()[0]!),
          onlineSaleCutoffMinutes: CUTOFF_MINUTES,
          note: SCHEDULE_NOTE,
          createdBy: ACTOR,
        },
        select: { id: true, operatorId: true, routeId: true, vehicleId: true, departureMinute: true, onlineSaleCutoffMinutes: true, note: true, startDate: true, endDate: true, daysOfWeek: true },
      }),
    );
    operators.find((operator) => operator.id === plan.operatorId)!.schedules.push(row);
    stats.schedules++;
  }
}

// ----------------------------------------------------------------------------------------------------------- chuyến

async function createTrips(db: Db, operators: OperatorInfo[], firstDay: string, lastDay: string, now: Date, concurrency: number): Promise<void> {
  const jobs: { schedule: ScheduleRow; date: string }[] = [];
  for (const schedule of operators.flatMap((operator) => operator.schedules)) {
    const start = schedule.startDate > dateOnly(firstDay) ? schedule.startDate : dateOnly(firstDay);
    const end = schedule.endDate < dateOnly(lastDay) ? schedule.endDate : dateOnly(lastDay);
    if (end < start) continue;
    for (const date of scheduleDates({ startDate: start, endDate: end, daysOfWeek: schedule.daysOfWeek })) {
      jobs.push({ schedule, date });
    }
  }
  await mapLimit(jobs, concurrency, async ({ schedule, date }) => {
    const serviceDate = dateOnly(date);
    try {
      const created = await db.run(async (tx) => {
        if (await tx.trip.findFirst({ where: { operatorId: schedule.operatorId, scheduleId: schedule.id, serviceDate }, select: { id: true } })) {
          return false;
        }
        const subRoutes = await tx.route.findMany({
          where: { operatorId: schedule.operatorId, parentRouteId: schedule.routeId, status: "ACTIVE", scheduleOffers: { some: { scheduleId: schedule.id } } },
          select: { id: true },
        });
        const tripId = await insertDraftTrip(
          tx,
          schedule.operatorId,
          { routeId: schedule.routeId, vehicleId: schedule.vehicleId, departureAt: departureOf(date, schedule.departureMinute), stopTimes: null, onlineSaleCutoffMinutes: schedule.onlineSaleCutoffMinutes, note: schedule.note, subRouteIds: subRoutes.map((route) => route.id) },
          { scheduleId: schedule.id, serviceDate },
        );
        await tx.trip.update({ where: { id: tripId }, data: { status: "OPEN_FOR_SALE" } });
        // Chuyến của quá khứ: ngày tạo lùi về trước ngày chạy cho báo cáo hợp lý.
        const departure = departureOf(date, schedule.departureMinute);
        if (departure < now) {
          await tx.$executeRaw`UPDATE trips SET created_at = ${new Date(departure.getTime() - 20 * DAY)} WHERE id = ${tripId}`;
        }
        return true;
      });
      if (created) stats.trips++;
    } catch (error) {
      if (isVehicleOverlapViolation(error) || isDeadlock(error)) {
        stats.overlaps++;
      } else {
        stats.failures++;
        console.warn(`  ! sinh chuyến ${date} lịch ${schedule.id}: ${(error as Error).message.split("\n")[0]}`);
      }
    }
  });
  console.log(`Chuyến mới: ${stats.trips} · trùng xe bỏ qua: ${stats.overlaps}`);
}

type TripRow = { id: string; operatorId: string; departureAt: Date; arrivalAt: Date; status: string; onlineSaleCutoffMinutes: number; vehicleTypeId: string | null; vehicleId: string | null };

async function listTrips(db: Db, operators: OperatorInfo[], from: Date, to: Date): Promise<TripRow[]> {
  const rows = await db.run((tx) =>
    tx.trip.findMany({
      where: { operatorId: { in: operators.map((operator) => operator.id) }, departureAt: { gte: from, lt: to }, status: { in: ["OPEN_FOR_SALE", "BOARDING", "DEPARTED", "IN_PROGRESS"] } },
      orderBy: { departureAt: "asc" },
      select: { id: true, operatorId: true, departureAt: true, arrivalAt: true, status: true, onlineSaleCutoffMinutes: true, vehicleId: true, vehicle: { select: { vehicleTypeId: true } } },
    }),
  );
  return rows.map(({ vehicle, ...trip }) => ({ ...trip, vehicleTypeId: vehicle?.vehicleTypeId ?? null }));
}

// ------------------------------------------------------------------------------------------- nhân viên + phân công

async function ensureShowcaseStaff(db: Db, operator: OperatorInfo, local: boolean): Promise<Staff> {
  const existing = await db.run((tx) => tx.employeeAccount.findMany({ where: { operatorId: operator.id, status: "ACTIVE" }, orderBy: { createdAt: "asc" }, select: { id: true, role: true, username: true } }));
  const wanted: { username: string; role: "DRIVER" | "TICKET_STAFF" | "SALES_STAFF" }[] = [
    { username: "nv.taixe01", role: "DRIVER" },
    { username: "nv.taixe02", role: "DRIVER" },
    { username: "nv.soatve01", role: "TICKET_STAFF" },
    { username: "nv.banve01", role: "SALES_STAFF" },
  ];
  // Chỉ tạo cho đủ số người mỗi vai trò; nhà xe đã có nhân viên vai trò đó thì dùng người sẵn có.
  const missing: typeof wanted = [];
  for (const item of wanted) {
    const have = existing.filter((row) => row.role === item.role).length + missing.filter((row) => row.role === item.role).length;
    const need = wanted.filter((row) => row.role === item.role).length;
    if (have < need && !existing.some((row) => row.username === item.username)) missing.push(item);
  }
  let password = process.env.DEMO_STAFF_PASSWORD;
  if (missing.length > 0 && !password && local) {
    password = `Demo!${randomUUID().slice(0, 8)}`;
    process.env.DEMO_STAFF_PASSWORD = password;
  }
  if (missing.length > 0 && !password) {
    console.warn(`  ! Thiếu DEMO_STAFF_PASSWORD → không tạo ${missing.map((item) => item.username).join(", ")}.`);
  } else if (missing.length > 0) {
    const hash = await new CredentialService().hash(password!);
    await db.run(async (tx) => {
      for (const item of missing) {
        const created = await tx.employeeAccount.create({ data: { operatorId: operator.id, username: item.username, passwordHash: hash, role: item.role }, select: { id: true, role: true, username: true } });
        existing.push(created);
        stats.staff++;
      }
    });
  }
  const sales = existing.filter((row) => row.role === "SALES_STAFF").map((row) => row.id);
  if (sales.length > 0) {
    await db.run(async (tx) => {
      let office = await tx.salesOffice.findFirst({ where: { operatorId: operator.id, active: true }, orderBy: { createdAt: "asc" }, select: { id: true } });
      if (!office) {
        const origin = operator.routes[0]!.stops[0]!;
        office = await tx.salesOffice.create({ data: { operatorId: operator.id, code: "VP01", name: `Văn phòng ${origin.name}`, address: origin.address || origin.name }, select: { id: true } });
      }
      for (const employeeId of sales) {
        await tx.salesOfficeAssignment.upsert({ where: { officeId_employeeId: { officeId: office.id, employeeId } }, create: { officeId: office.id, employeeId, operatorId: operator.id }, update: {} });
      }
    });
  }
  return {
    drivers: existing.filter((row) => row.role === "DRIVER").map((row) => row.id),
    ticketStaff: existing.filter((row) => row.role === "TICKET_STAFF").map((row) => row.id),
    sales,
  };
}

/** Phân công tài xế (theo xe) + nhân viên soát vé cho chuyến của nhà xe trưng bày, chuyến đã có người thì giữ nguyên. */
async function assignStaff(db: Db, operator: OperatorInfo, staff: Staff, fromDay: string, toDay: string): Promise<void> {
  await db.run(async (tx) => {
    const trips = await tx.trip.findMany({
      where: { operatorId: operator.id, departureAt: { gte: vnMidnight(fromDay), lt: vnMidnight(addDays(toDay, 1)) }, status: { notIn: ["CANCELLED"] } },
      select: { id: true, vehicleId: true, assignments: { select: { role: true } } },
    });
    const vehicleIndex = new Map(operator.vehicles.map((vehicle, index) => [vehicle.id, index]));
    for (const trip of trips) {
      const roles = new Set(trip.assignments.map((assignment) => assignment.role));
      const rows: { employeeId: string; role: "DRIVER" | "TICKET_STAFF" }[] = [];
      if (!roles.has("DRIVER") && staff.drivers.length > 0) rows.push({ employeeId: staff.drivers[(vehicleIndex.get(trip.vehicleId ?? "") ?? 0) % staff.drivers.length]!, role: "DRIVER" });
      if (!roles.has("TICKET_STAFF") && staff.ticketStaff.length > 0) rows.push({ employeeId: staff.ticketStaff[0]!, role: "TICKET_STAFF" });
      for (const row of rows) {
        await tx.employeeAssignment.create({ data: { operatorId: operator.id, tripId: trip.id, employeeId: row.employeeId, role: row.role, assignedBy: ACTOR } });
        stats.assignments++;
      }
    }
  });
}

async function listCheckers(db: Db, operatorIds: string[]): Promise<Map<string, string>> {
  const rows = await db.run((tx) => tx.employeeAccount.findMany({ where: { operatorId: { in: operatorIds }, status: "ACTIVE", role: { in: ["TICKET_STAFF", "DRIVER"] } }, orderBy: [{ role: "desc" }, { createdAt: "asc" }], select: { id: true, operatorId: true } }));
  const map = new Map<string, string>();
  for (const row of rows) if (!map.has(row.operatorId)) map.set(row.operatorId, row.id);
  return map;
}

// ------------------------------------------------------------------------------------------------------ hành khách

async function ensureCustomers(db: Db, args: Args, local: boolean, firstDay: string): Promise<{ pool: Customer[]; persona: Customer | null }> {
  const random = rng("customers");
  const personaEmail = args.passengerEmail ?? (local ? "minhanh@example.com" : null);
  const wanted: { email: string; name: string; phone: string; joinedAt: Date }[] = [];
  for (let i = 1; i <= args.customers; i++) {
    wanted.push({ email: `khach${String(i).padStart(3, "0")}.demo@example.com`, name: fullName(random), phone: phone(random), joinedAt: new Date(vnMidnight(firstDay).getTime() - between(random, 1, 120) * DAY) });
  }
  const persona = personaEmail ? { email: personaEmail, name: "Nguyễn Minh Anh", phone: phone(random), joinedAt: new Date(vnMidnight(firstDay).getTime() - 90 * DAY) } : null;
  return db.run(async (tx) => {
    const ensure = async (item: { email: string; name: string; phone: string; joinedAt: Date }): Promise<Customer> => {
      const found = await tx.user.findUnique({ where: { email: item.email }, select: { id: true, name: true, phone: true, email: true } });
      if (found) return { id: found.id, name: found.name ?? item.name, phone: found.phone ?? item.phone, email: found.email };
      const created = await tx.user.create({ data: { id: randomUUID(), email: item.email, name: item.name, phone: item.phone, emailVerified: true, createdAt: item.joinedAt }, select: { id: true } });
      stats.customers++;
      return { id: created.id, name: item.name, phone: item.phone, email: item.email };
    };
    const pool: Customer[] = [];
    for (const item of wanted) pool.push(await ensure(item));
    return { pool, persona: persona ? await ensure(persona) : null };
  });
}

// ------------------------------------------------------------------------------------------------- vòng đời chuyến

type TripContext = {
  now: Date;
  args: Args;
  customers: Customer[];
  persona: Customer | null;
  showcaseId: string | null;
  employees: Map<string, string>;
  loyaltyFrom: Date | null;
  today: string;
};

async function processTrip(db: Db, qr: TicketQrSigner, trip: TripRow, ctx: TripContext): Promise<void> {
  const random = rng(trip.id);
  const bookings = await db.run((tx) => tx.booking.findMany({ where: { tripId: trip.id, operatorId: trip.operatorId }, select: { id: true, holdId: true } }));
  if (bookings.some((booking) => !booking.holdId.startsWith(HOLD_MARK))) {
    stats.skippedTrips++;
    return;
  }
  const past = trip.departureAt <= ctx.now;
  const salesClose = trip.departureAt.getTime() - trip.onlineSaleCutoffMinutes * MINUTE;
  const showcase = trip.operatorId === ctx.showcaseId;
  if (bookings.length === 0 && trip.status === "OPEN_FOR_SALE") {
    const days = (trip.departureAt.getTime() - ctx.now.getTime()) / DAY;
    const weekend = [0, 5, 6].includes(new Date(trip.departureAt.getTime() + 7 * HOUR).getUTCDay());
    let ratio = past ? between(random, 0.25, 0.7) + (weekend ? 0.1 : 0) : 0.55 * Math.exp(-days / 3) + between(random, 0, 0.08);
    ratio *= ctx.args.fill * (showcase ? 1.2 : 1);
    // Chuyến của nhà xe trưng bày trong 2 ngày tới để trống nhiều ghế cho đặt vé trực tiếp lúc demo.
    if (!past && showcase && days < 2) ratio = Math.min(ratio, 0.3);
    const latest = Math.min(salesClose - 5 * MINUTE, ctx.now.getTime() - MINUTE);
    if (latest > trip.departureAt.getTime() - 30 * DAY) {
      await sellSeats(db, qr, trip, Math.min(ratio, 0.95), latest, random, ctx, showcase);
    }
  }
  if (past) {
    await operateTrip(db, trip, random, ctx);
  }
}

/** Bán `ratio` số ghế còn trống (có giá) thành các đơn 1–3 ghế, mỗi đơn một transaction: đặt → thanh toán DEMO → vé. */
async function sellSeats(db: Db, qr: TicketQrSigner, trip: TripRow, ratio: number, latest: number, random: () => number, ctx: TripContext, showcase: boolean): Promise<void> {
  const { seats, stops, priced } = await db.run(async (tx) => {
    const seats = await tx.tripSeat.findMany({ where: { tripId: trip.id, operatorId: trip.operatorId, status: "AVAILABLE" }, orderBy: { seatCode: "asc" }, select: { seatCode: true, type: true } });
    const stops = await tx.tripStop.findMany({ where: { tripId: trip.id, operatorId: trip.operatorId }, orderBy: { sequence: "asc" }, select: { sequence: true, plannedAt: true, allowPickup: true, allowDropoff: true, catalogStopPoint: { select: { name: true } }, stopPoint: { select: { name: true } } } });
    const { routeId } = await tx.trip.findFirstOrThrow({ where: { id: trip.id }, select: { routeId: true } });
    const rules = await tx.fareRule.findMany({ where: { operatorId: trip.operatorId, fare: { status: "ACTIVE", routeId } }, select: { vehicleTypeId: true, seatType: true, validFrom: true, validTo: true } });
    // Ghế có giá tại giờ chạy (loại xe, loại ghế, khoảng hiệu lực) — như cách code đặt vé tính giá.
    const at = trip.departureAt.getTime();
    const live = rules.filter((rule) => (!rule.validFrom || rule.validFrom.getTime() <= at) && (!rule.validTo || rule.validTo.getTime() > at));
    const priced = new Set(seats.filter((seat) => live.some((rule) => (rule.vehicleTypeId === null || rule.vehicleTypeId === trip.vehicleTypeId) && (rule.seatType === null || rule.seatType === seat.type))).map((seat) => seat.seatCode));
    return { seats, stops, priced };
  });
  const pickup = stops.find((stop) => stop.allowPickup);
  const dropoff = [...stops].reverse().find((stop) => stop.allowDropoff && stop.sequence > (pickup?.sequence ?? 0));
  if (!pickup || !dropoff) return;
  const sellable = seats.filter((seat) => priced.has(seat.seatCode)).map((seat) => seat.seatCode);
  // Trộn ghế để đơn rải khắp sơ đồ, nhưng ghế của cùng một đơn liền nhau.
  const target = Math.round(sellable.length * ratio);
  const groups: string[][] = [];
  const pool = [...sellable];
  while (groups.flat().length < target && pool.length > 0) {
    const size = Math.min(pool.length, target - groups.flat().length, random() < 0.55 ? 1 : random() < 0.8 ? 2 : 3);
    const start = Math.floor(random() * (pool.length - size + 1));
    groups.push(pool.splice(start, size));
  }
  const point = (stop: (typeof stops)[number]) => ({ sequence: stop.sequence, name: (stop.catalogStopPoint ?? stop.stopPoint)?.name ?? "", plannedAt: stop.plannedAt.toISOString() });
  // Khách đặt trong 7 ngày trước giờ chạy; chuyến còn xa hơn thế thì đơn rải trong 3 ngày gần đây (không đơn nào ở tương lai).
  const weekBefore = trip.departureAt.getTime() - 7 * DAY;
  const earliest = weekBefore < latest - HOUR ? weekBefore : latest - 3 * DAY;
  const personaDay = showcase && ctx.persona && random() < 0.15;
  for (const [index, group] of groups.entries()) {
    const bookedAt = new Date(Math.floor(between(random, earliest, latest)));
    const registered = random() < 0.65;
    const customer = index === 0 && personaDay ? ctx.persona : registered ? pick(random, ctx.customers) : null;
    // Đơn online bắt buộc có email liên hệ (CHECK `bookings_online_contact_email`); khách vãng lai mô phỏng dùng @example.com.
    const guestEmail = `vanglai.${Math.floor(random() * 0xffffff).toString(16).padStart(6, "0")}@example.com`;
    const contact = customer ? { fullName: customer.name, phone: customer.phone, email: customer.email } : { fullName: fullName(random), phone: phone(random), email: guestEmail };
    const passengers = group.map((seatCode, i) => ({ seatCode, fullName: i === 0 ? contact.fullName : fullName(random), phone: i === 0 ? contact.phone : null, companionName: null }));
    try {
      await db.run((tx) => createPaidBooking(tx, qr, trip, { holdId: `${HOLD_MARK}${randomUUID().slice(9)}`, seats: group, pickup: point(pickup), dropoff: point(dropoff), customer, contact, passengers, bookedAt }));
      stats.bookings++;
      stats.seats += group.length;
    } catch (error) {
      stats.failures++;
      console.warn(`  ! đơn trên chuyến ${trip.id}: ${describe(error)}`);
    }
  }
}

type BookingDraft = {
  holdId: string;
  seats: string[];
  pickup: { sequence: number; name: string; plannedAt: string };
  dropoff: { sequence: number; name: string; plannedAt: string };
  customer: Customer | null;
  contact: { fullName: string; phone: string; email: string | null };
  passengers: { seatCode: string; fullName: string; phone: string | null; companionName: null }[];
  bookedAt: Date;
};

async function createPaidBooking(tx: DbTransaction, qr: TicketQrSigner, trip: TripRow, draft: BookingDraft): Promise<void> {
  const insert = (BookingService.prototype as unknown as { insert: InsertFn }).insert;
  const hold = { holdId: draft.holdId, tripId: trip.id, seatCodes: draft.seats, pickup: draft.pickup, dropoff: draft.dropoff, userId: draft.customer?.id ?? null, seats: [], subtotal: 0, createdAt: draft.bookedAt.toISOString(), expiresAt: new Date(draft.bookedAt.getTime() + 10 * MINUTE).toISOString() };
  const user = draft.customer ? { sub: draft.customer.id } : null;
  const input = (expectedTotal: number | string) => ({ contact: draft.contact, passengers: draft.passengers, note: null, expectedTotal });
  let booking: { id: string; bookingCode: string };
  try {
    booking = await insert(tx, trip.operatorId, user, hold, input(-1), randomUUID(), draft.bookedAt);
  } catch (error) {
    // Tổng tiền do code đặt vé tự tính (giá theo chặng, loại ghế) — lấy từ lỗi "giá đã đổi" rồi gửi lại đúng số.
    const body = error instanceof HttpException ? (error.getResponse() as { code?: string; reasons?: string[] }) : null;
    if (body?.code !== "BOOKING_SNAPSHOT_CHANGED" || !body.reasons?.[0]) throw error;
    booking = await insert(tx, trip.operatorId, user, hold, input(body.reasons[0]), randomUUID(), draft.bookedAt);
  }
  const total = (await tx.booking.findUniqueOrThrow({ where: { id: booking.id }, select: { total: true } })).total;
  const payStart = new Date(draft.bookedAt.getTime() + 20_000);
  const paidAt = new Date(draft.bookedAt.getTime() + 60_000 + Math.floor(Math.random() * 120_000));
  const actor = draft.customer ? `user:${draft.customer.id}` : "guest";
  const payment = await tx.payment.create({
    data: {
      paymentCode: `PAY${randomUUID().replace(/-/g, "").slice(0, 12).toUpperCase()}`,
      operatorId: trip.operatorId,
      bookingId: booking.id,
      provider: "DEMO",
      status: "PROCESSING",
      amount: total,
      expiresAt: new Date(draft.bookedAt.getTime() + 10 * MINUTE),
      createdAt: payStart,
      histories: { create: [{ toStatus: "INITIATED", actor, createdAt: payStart }, { fromStatus: "INITIATED", toStatus: "PROCESSING", reason: "Tạo link thanh toán.", actor: "system", createdAt: new Date(payStart.getTime() + 1000) }] },
    },
    select: { paymentCode: true },
  });
  const outcome = await applyPaymentCallback(bound(tx), { provider: "DEMO", paymentCode: payment.paymentCode, providerTxnId: `DEMO-${payment.paymentCode}`, amount: total.toString(), success: true, resultCode: "00", fields: { source: "demo-seed" } }, qr, paidAt);
  if (outcome !== "SUCCESS") {
    throw new Error(`thanh toán DEMO trả ${outcome}`);
  }
  // Mốc giờ do Prisma / DB tự điền (`now()` thật) → kéo về giờ mô phỏng.
  await tx.$executeRaw`UPDATE bookings SET created_at = ${draft.bookedAt} WHERE id = ${booking.id}`;
  await tx.$executeRaw`UPDATE booking_status_histories SET created_at = ${draft.bookedAt} WHERE booking_id = ${booking.id} AND from_status IS NULL`;
  await tx.$executeRaw`UPDATE payment_status_histories SET created_at = ${paidAt} WHERE payment_id = (SELECT id FROM payments WHERE payment_code = ${payment.paymentCode}) AND to_status = 'SUCCESS'`;
  await tx.$executeRaw`UPDATE tickets SET created_at = ${paidAt} WHERE booking_id = ${booking.id}`;
  await tx.$executeRaw`UPDATE ticket_status_histories SET created_at = ${paidAt} WHERE ticket_id IN (SELECT id FROM tickets WHERE booking_id = ${booking.id})`;
  await skipNotifications(tx, booking.id, paidAt);
}

/** Thông báo phát sinh từ đơn demo: không gửi email / push / hộp thư — đánh dấu xong ngay trong transaction ghi đơn. */
async function skipNotifications(tx: DbTransaction, bookingId: string, at: Date): Promise<void> {
  await tx.$executeRaw`
    UPDATE notification_deliveries SET status = 'SKIPPED', last_error = 'Dữ liệu demo: không gửi.', updated_at = CURRENT_TIMESTAMP
    WHERE status = 'PENDING' AND notification_id IN (SELECT id FROM notifications WHERE booking_id = ${bookingId})`;
  await tx.$executeRaw`
    UPDATE notifications SET channels_prepared_at = COALESCE(channels_prepared_at, ${at}), created_at = LEAST(created_at, ${at})
    WHERE booking_id = ${bookingId}`;
}

/**
 * Chuyến đã chạy: soát vé (≈ 90% vé lên xe, lịch sử ghi nhân viên của nhà xe), rồi theo giờ thật — đang chạy → `IN_PROGRESS`,
 * đã tới → `COMPLETED` như tài xế bấm (vé lên → USED, còn lại → NO_SHOW, mốc chi trả) + điểm thưởng + đánh giá.
 */
async function operateTrip(db: Db, trip: TripRow, random: () => number, ctx: TripContext): Promise<void> {
  const by = ctx.employees.has(trip.operatorId) ? `employee:${ctx.employees.get(trip.operatorId)}` : ACTOR;
  const departedAt = new Date(trip.departureAt.getTime() + Math.floor(between(random, 0, 8)) * MINUTE);
  const completedAt = new Date(trip.arrivalAt.getTime() + Math.floor(between(random, -10, 25)) * MINUTE);
  const arrived = completedAt.getTime() + 10 * MINUTE <= ctx.now.getTime();
  const reviewable: { bookingId: string; contactName: string; userId: string }[] = [];
  await db.run(async (tx) => {
    const [locked] = await tx.$queryRaw<{ status: string }[]>`SELECT status::text AS "status" FROM trips WHERE id = ${trip.id} FOR NO KEY UPDATE`;
    if (!locked) return;
    if (locked.status === "OPEN_FOR_SALE") {
      const tickets = await tx.ticket.findMany({ where: { tripId: trip.id, operatorId: trip.operatorId, status: "VALID" }, select: { id: true, seatCode: true } });
      for (const ticket of tickets) {
        if (random() > 0.9) continue;
        const at = new Date(trip.departureAt.getTime() - Math.floor(between(random, 5, 35)) * MINUTE);
        await tx.ticket.update({ where: { id: ticket.id }, data: { status: "CHECKED_IN", checkedInAt: at } });
        await tx.ticketStatusHistory.create({ data: { ticketId: ticket.id, operatorId: trip.operatorId, fromStatus: "VALID", toStatus: "CHECKED_IN", reason: "Soát vé lên xe.", actor: by, createdAt: at } });
        await tx.tripSeat.updateMany({ where: { tripId: trip.id, operatorId: trip.operatorId, seatCode: ticket.seatCode, status: "BOOKED" }, data: { status: "CHECKED_IN" } });
        stats.checkedIn++;
      }
    }
    if (!arrived) {
      if (["OPEN_FOR_SALE", "BOARDING", "DEPARTED"].includes(locked.status)) {
        await tx.trip.update({ where: { id: trip.id }, data: { status: "IN_PROGRESS", departedAt } });
        stats.inProgress++;
      }
      return;
    }
    if (!["OPEN_FOR_SALE", "BOARDING", "DEPARTED", "IN_PROGRESS"].includes(locked.status)) return;
    const payoutEligibleAt = new Date(completedAt.getTime() + (await payoutDelayDays(tx, completedAt)) * DAY);
    await tx.trip.update({ where: { id: trip.id }, data: { status: "COMPLETED", departedAt, completedAt, payoutEligibleAt } });
    for (const [from, to, reason] of [["CHECKED_IN", "USED", "Chuyến hoàn thành."], ["VALID", "NO_SHOW", "Chuyến hoàn thành, khách không lên xe."]] as const) {
      const tickets = await tx.ticket.findMany({ where: { tripId: trip.id, operatorId: trip.operatorId, status: from }, select: { id: true } });
      if (tickets.length === 0) continue;
      await tx.ticket.updateMany({ where: { id: { in: tickets.map((ticket) => ticket.id) } }, data: { status: to } });
      await tx.ticketStatusHistory.createMany({ data: tickets.map((ticket) => ({ ticketId: ticket.id, operatorId: trip.operatorId, fromStatus: from, toStatus: to, reason, actor: by, createdAt: completedAt })) });
    }
    stats.completed++;
    // Điểm thưởng ngay trong transaction đóng chuyến (job loyalty của worker sẽ thấy khóa EARN đã có, không cộng / gửi lại).
    // Khóa tài khoản điểm theo thứ tự `userId` cố định: các chuyến chạy song song không khóa chéo nhau (deadlock).
    const paid = await tx.booking.findMany({ where: { tripId: trip.id, operatorId: trip.operatorId, userId: { not: null }, paidAt: { not: null } }, orderBy: [{ userId: "asc" }, { id: "asc" }], select: { id: true, userId: true, contactName: true, tickets: { select: { status: true } } } });
    const earnAt = new Date(Math.min(ctx.now.getTime(), Math.max(completedAt.getTime() + 10 * MINUTE, (ctx.loyaltyFrom?.getTime() ?? 0) + MINUTE)));
    for (const booking of paid) {
      if (await earnForBooking(tx, booking.id, earnAt)) stats.loyalty++;
      await skipNotifications(tx, booking.id, earnAt);
      if (booking.tickets.some((ticket) => ticket.status === "USED")) reviewable.push({ bookingId: booking.id, contactName: booking.contactName, userId: booking.userId! });
    }
  });
  if (ctx.args.reviews && reviewable.length > 0) {
    await db.run(async (tx) => {
      for (const item of reviewable) {
        const persona = item.userId === ctx.persona?.id;
        if (random() > (persona ? 0.75 : 0.35)) continue;
        const createdAt = new Date(completedAt.getTime() + Math.floor(between(random, 60, 48 * 60)) * MINUTE);
        if (createdAt >= ctx.now || (await tx.review.findUnique({ where: { bookingId: item.bookingId }, select: { id: true } }))) continue;
        const roll = random();
        const rating = roll < 0.55 ? 5 : roll < 0.88 ? 4 : 3;
        const repliedAt = new Date(createdAt.getTime() + Math.floor(between(random, 120, 36 * 60)) * MINUTE);
        const reply = random() < 0.4 && repliedAt < ctx.now;
        await tx.review.create({
          data: {
            operatorId: trip.operatorId,
            bookingId: item.bookingId,
            tripId: trip.id,
            userId: item.userId,
            authorName: maskName(item.contactName),
            rating,
            comment: random() < 0.75 ? pick(random, COMMENTS[rating]!) : null,
            createdAt,
            ...(reply ? { operatorReply: pick(random, REPLIES), operatorRepliedAt: repliedAt } : {}),
          },
        });
        stats.reviews++;
      }
    });
  }
}

// --------------------------------------------------------------------------------------------------------- phụ trợ

/** Lưới an toàn cuối: còn thông báo PENDING nào của đơn demo (vd do job khác sinh) thì cũng bỏ qua. */
async function sweepNotifications(db: Db): Promise<void> {
  const swept = await db.run((tx) => tx.$executeRaw`
    UPDATE notification_deliveries d SET status = 'SKIPPED', last_error = 'Dữ liệu demo: không gửi.', updated_at = CURRENT_TIMESTAMP
    FROM notifications n JOIN bookings b ON b.id = n.booking_id
    WHERE d.notification_id = n.id AND d.status = 'PENDING' AND b.hold_id LIKE ${`${HOLD_MARK}%`}`);
  if (swept > 0) console.log(`Bỏ qua thêm ${swept} thông báo của đơn demo.`);
}

async function dryRunReport(db: Db, operators: OperatorInfo[], newSchedules: number, firstDay: string, lastDay: string, now: Date): Promise<void> {
  const ids = operators.map((operator) => operator.id);
  const counts = await db.run(async (tx) => ({
    trips: await tx.trip.count({ where: { operatorId: { in: ids }, departureAt: { gte: vnMidnight(firstDay), lt: vnMidnight(addDays(lastDay, 1)) } } }),
    pastOpen: await tx.trip.count({ where: { operatorId: { in: ids }, departureAt: { gte: vnMidnight(firstDay), lt: now }, status: "OPEN_FOR_SALE" } }),
    withRealBookings: await tx.trip.count({ where: { operatorId: { in: ids }, departureAt: { gte: vnMidnight(firstDay) }, bookings: { some: { NOT: { holdId: { startsWith: HOLD_MARK } } } } } }),
    demoBookings: await tx.booking.count({ where: { holdId: { startsWith: HOLD_MARK } } }),
    loyalty: await tx.policyVersion.count({ where: { type: "LOYALTY", status: "PUBLISHED" } }),
    cancellation: await tx.policyVersion.count({ where: { type: "CANCELLATION", status: "PUBLISHED" } }),
  }));
  console.log(`[dry-run] lịch mới ${newSchedules} · chuyến hiện có trong khung ${counts.trips} (đã qua còn mở bán ${counts.pastOpen}) · chuyến có đơn KHÔNG phải demo (sẽ bỏ qua) ${counts.withRealBookings}`);
  console.log(`[dry-run] đơn demo đã có ${counts.demoBookings} · chính sách LOYALTY ${counts.loyalty} · CANCELLATION ${counts.cancellation}`);
}

function writeAccounts(showcase: OperatorInfo | undefined, staff: Staff | null, persona: Customer | null): void {
  const dir = resolve(process.cwd(), "tmp/demo-seed");
  mkdirSync(dir, { recursive: true });
  const lines = [
    "# Tài khoản demo (local, KHÔNG commit)",
    "",
    showcase ? `- Nhà xe trưng bày: \`${showcase.slug}\` — nhân viên \`${showcase.slug}/nv.taixe01\`, \`nv.taixe02\`, \`nv.soatve01\`, \`nv.banve01\`` : "- Không có nhà xe trưng bày",
    process.env.DEMO_STAFF_PASSWORD ? `- Mật khẩu nhân viên mới tạo: \`${process.env.DEMO_STAFF_PASSWORD}\`` : "- Nhân viên dùng tài khoản sẵn có",
    `- Hành khách trưng bày: ${persona ? `\`${persona.email}\` (đăng nhập OTP email)` : "-"}`,
    `- Số nhân viên: tài xế ${staff?.drivers.length ?? 0}, soát vé ${staff?.ticketStaff.length ?? 0}, bán vé ${staff?.sales.length ?? 0}`,
  ];
  writeFileSync(resolve(dir, "accounts.local.md"), `${lines.join("\n")}\n`);
  console.log("Tài khoản demo: apps/api/tmp/demo-seed/accounts.local.md (không commit).");
}

function describe(error: unknown): string {
  if (error instanceof HttpException) {
    const body = error.getResponse() as { code?: string; detail?: string; reasons?: string[] };
    return `${body.code ?? error.getStatus()} ${body.detail ?? ""} ${body.reasons?.join(",") ?? ""}`.trim();
  }
  // Lỗi Prisma mở đầu bằng dòng trống; hai dòng có nội dung cuối cùng thường nêu nguyên nhân.
  const lines = String((error as Error).message ?? error).split("\n").map((line) => line.trim()).filter(Boolean);
  return lines.slice(-2).join(" | ") || String(error);
}

void main().catch((error: unknown) => {
  console.error(error);
  process.exitCode = 1;
});
