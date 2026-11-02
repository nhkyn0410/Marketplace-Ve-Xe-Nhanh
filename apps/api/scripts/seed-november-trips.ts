import { existsSync } from "node:fs";
import { resolve } from "node:path";
import { PrismaPg } from "@prisma/adapter-pg";
import { PrismaClient, RouteStatus, TripStatus } from "../src/generated/prisma/client";
import { dateOnly, departureOf, scheduleDates } from "../src/trip/trip-schedule-dates";
import { insertDraftTrip } from "../src/trip/trip.service";
import { isDeadlock, isVehicleOverlapViolation } from "../src/trip/trip.errors";

/**
 * Tải biến môi trường từ .env và .env.development
 */
function loadEnv(): void {
  const nodeEnv = process.env.NODE_ENV?.trim() || "development";
  for (const file of [".env", `.env.${nodeEnv}`]) {
    const path = resolve(process.cwd(), file);
    if (existsSync(path)) {
      process.loadEnvFile(path);
    }
  }
}

/**
 * Script bổ sung dữ liệu: sinh chuyến xe (trips) tự động cho toàn bộ các lịch (schedules)
 * từ ngày hiện tại đến hết tháng 11/2026, kèm tạo sơ đồ ghế và mở bán công khai.
 */
async function main(): Promise<void> {
  loadEnv();

  const connectionString = process.env.MIGRATION_DATABASE_URL ?? process.env.DATABASE_URL;
  if (!connectionString) {
    throw new Error("MIGRATION_DATABASE_URL hoặc DATABASE_URL là bắt buộc để kết nối DB.");
  }

  const prisma = new PrismaClient({
    adapter: new PrismaPg({ connectionString }),
  });

  try {
    console.log("Bắt đầu sinh chuyến bổ sung từ các lịch định kỳ (Trip Schedules)...");

    // Lấy toàn bộ các lịch đang hoạt động
    const schedules = await prisma.$transaction(async (tx) => {
      await tx.$executeRaw`SELECT set_config('app.scope', 'system', true)`;
      return tx.tripSchedule.findMany({
        select: {
          id: true,
          operatorId: true,
          routeId: true,
          vehicleId: true,
          departureMinute: true,
          onlineSaleCutoffMinutes: true,
          note: true,
          startDate: true,
          endDate: true,
          daysOfWeek: true,
        },
      });
    });

    console.log(`Tìm thấy ${schedules.length} lịch chuyến đang cấu hình trong hệ thống.`);

    let createdCount = 0;
    let skippedCount = 0;
    let conflictCount = 0;

    const now = new Date();
    // Giới hạn sinh đến ngày 30/11/2026
    const limitEndDate = new Date("2026-11-30T23:59:59.999Z");

    for (const schedule of schedules) {
      // Điều chỉnh khoảng ngày hiệu lực để tập trung vào tháng 11/2026
      const effectiveEndDate = schedule.endDate < limitEndDate ? schedule.endDate : limitEndDate;
      if (effectiveEndDate < schedule.startDate) {
        continue;
      }

      const dates = scheduleDates({
        startDate: schedule.startDate,
        endDate: effectiveEndDate,
        daysOfWeek: schedule.daysOfWeek,
      });

      for (const serviceDateStr of dates) {
        const departureAt = departureOf(serviceDateStr, schedule.departureMinute);
        if (departureAt.getTime() <= now.getTime()) {
          // Bỏ qua chuyến trong quá khứ
          skippedCount++;
          continue;
        }

        const serviceDate = dateOnly(serviceDateStr);

        try {
          const tripId = await prisma.$transaction(
            async (tx) => {
              await tx.$executeRaw`SELECT set_config('app.scope', 'system', true)`;

              // Kiểm tra xem chuyến cho ngày này đã sinh chưa
              const existing = await tx.trip.findFirst({
                where: {
                  operatorId: schedule.operatorId,
                  scheduleId: schedule.id,
                  serviceDate,
                },
                select: { id: true },
              });

              if (existing) {
                return null;
              }

              // Lấy các chặng con (sub-routes) được mở bán theo lịch
              const subRoutes = await tx.route.findMany({
                where: {
                  operatorId: schedule.operatorId,
                  parentRouteId: schedule.routeId,
                  status: RouteStatus.ACTIVE,
                  scheduleOffers: { some: { scheduleId: schedule.id } },
                },
                select: { id: true },
              });

              // Tạo chuyến nháp cùng sơ đồ ghế và điểm dừng
              const newTripId = await insertDraftTrip(
                tx,
                schedule.operatorId,
                {
                  routeId: schedule.routeId,
                  vehicleId: schedule.vehicleId,
                  departureAt,
                  stopTimes: null,
                  onlineSaleCutoffMinutes: schedule.onlineSaleCutoffMinutes,
                  note: schedule.note,
                  subRouteIds: subRoutes.map((r) => r.id),
                },
                { scheduleId: schedule.id, serviceDate },
              );

              // Cập nhật trạng thái mở bán công khai (OPEN_FOR_SALE)
              await tx.trip.update({
                where: { id: newTripId },
                data: { status: TripStatus.OPEN_FOR_SALE },
              });

              return newTripId;
            },
            { timeout: 30_000 },
          );

          if (tripId) {
            createdCount++;
            if (createdCount % 50 === 0) {
              console.log(`Đã tạo và mở bán ${createdCount} chuyến mới...`);
            }
          } else {
            skippedCount++;
          }
        } catch (error: unknown) {
          if (isVehicleOverlapViolation(error) || isDeadlock(error)) {
            conflictCount++;
          } else {
            const message = error instanceof Error ? error.message : String(error);
            console.warn(`Lỗi khi sinh chuyến ngày ${serviceDateStr} cho lịch ${schedule.id}: ${message}`);
          }
        }
      }
    }

    console.log("Hoàn thành sinh chuyến bổ sung!");
    console.log(`- Số chuyến mới được tạo & mở bán: ${createdCount}`);
    console.log(`- Số chuyến đã tồn tại hoặc bỏ qua: ${skippedCount}`);
    console.log(`- Số chuyến xung đột xe: ${conflictCount}`);

    // Kiểm tra tổng số chuyến sau khi bổ sung
    const totalTrips = await prisma.trip.count();
    const openTrips = await prisma.trip.count({ where: { status: TripStatus.OPEN_FOR_SALE } });
    console.log(`=> Tổng số chuyến trong DB hiện tại: ${totalTrips} (trong đó mở bán: ${openTrips})`);
  } finally {
    await prisma.$disconnect();
  }
}

void main();
