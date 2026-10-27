import { HttpException, Inject, Injectable, Logger } from "@nestjs/common";
import { AuditService } from "../audit/audit.service";
import type { DbScope } from "../database/db-scope";
import { PrismaService, type DbTransaction } from "../database/prisma.service";
import { RouteStatus, TripStatus, VehicleStatus } from "../database/prisma.types";
import type { Authorization } from "../iam/role/authorization";
import { requireTenant } from "../iam/role/require-tenant";
import type {
  TripScheduleGenerateInput,
  TripScheduleGenerateResponse,
  TripScheduleInput,
  TripScheduleListResponse,
  TripScheduleResponse,
} from "./dto/trip-schedule.dto";
import {
  dateOnly,
  daysToMask,
  departureOf,
  formatDateOnly,
  maskToDays,
  minuteOfDay,
  scheduleDates,
  timeOfDay,
} from "./trip-schedule-dates";
import {
  isDeadlock,
  isVehicleOverlapViolation,
  routeUnavailable,
  tripScheduleNotFound,
  vehicleUnavailable,
} from "./trip.errors";
import { insertDraftTrip, TripService, type TripActor } from "./trip.service";

const AUDIT_TARGET = "trip_schedule";
/** Số lịch tối đa trả về một lần — một nhà xe có vài chục tuyến, mỗi tuyến vài khung giờ. */
const LIST_LIMIT = 200;

type SkipReason = TripScheduleGenerateResponse["skipped"][number]["reason"];
type CreatedTrip = TripScheduleGenerateResponse["created"][number];

/**
 * Lịch chuyến lặp lại của nhà xe (TASK-TRN-007, FR-OPS-07, UC-14 bước 7 — thiết kế chờ Khanh duyệt). Lịch là quy tắc;
 * "Sinh chuyến" tạo chuyến `DRAFT` cho từng ngày khớp quy tắc, mỗi ngày một transaction khoá dòng lịch: chạy lại (kể cả
 * hai lần đồng thời) thấy ngày đã có chuyến và bỏ qua — UNIQUE `(schedule_id, service_date)` là chốt cuối. Sửa lịch chỉ áp
 * cho ngày chưa sinh; chuyến đã sinh sửa ở từng chuyến như chuyến lẻ.
 */
@Injectable()
export class TripScheduleService {
  private readonly logger = new Logger(TripScheduleService.name);

  constructor(
    @Inject(PrismaService) private readonly prisma: PrismaService,
    @Inject(TripService) private readonly trips: TripService,
    @Inject(AuditService) private readonly audit: AuditService,
  ) {}

  /** Lịch của nhà xe: lịch còn hiệu lực (ngày kết thúc xa nhất) trước. */
  async list(authz: Authorization): Promise<TripScheduleListResponse> {
    const { db, operatorId } = requireTenant(authz);
    const rows = await this.prisma.withScope(db, (tx) =>
      tx.tripSchedule.findMany({
        where: { operatorId },
        orderBy: [{ endDate: "desc" }, { createdAt: "desc" }],
        take: LIST_LIMIT,
        select: SCHEDULE_SELECT,
      }),
    );
    return { items: rows.map(toResponse) };
  }

  /** Chi tiết lịch; khác tenant trả 404 như không tồn tại. */
  async get(authz: Authorization, scheduleId: string): Promise<TripScheduleResponse> {
    const { db, operatorId } = requireTenant(authz);
    const row = await this.prisma.withScope(db, (tx) => findSchedule(tx, operatorId, scheduleId));
    if (!row) {
      throw tripScheduleNotFound();
    }
    return toResponse(row);
  }

  async create(actor: TripActor, authz: Authorization, input: TripScheduleInput): Promise<TripScheduleResponse> {
    const { db, operatorId } = requireTenant(authz);
    const row = await this.prisma.withScope(db, async (tx) => {
      const routeSeconds = await assertResources(tx, operatorId, input);
      const created = await tx.tripSchedule.create({
        data: { operatorId, ...ruleFields(input, routeSeconds), createdBy: actor.sub },
        select: { id: true },
      });
      return findSchedule(tx, operatorId, created.id);
    });
    const response = toResponse(row!);
    this.recordAudit(actor, operatorId, "trip_schedule.create", response.id, { after: auditRule(response) });
    return response;
  }

  /** Thay toàn bộ quy tắc của lịch. Chuyến đã sinh giữ nguyên. */
  async update(
    actor: TripActor,
    authz: Authorization,
    scheduleId: string,
    input: TripScheduleInput,
  ): Promise<TripScheduleResponse> {
    const { db, operatorId } = requireTenant(authz);
    const { before, after } = await this.prisma.withScope(db, async (tx) => {
      const current = await findSchedule(tx, operatorId, scheduleId);
      if (!current) {
        throw tripScheduleNotFound();
      }
      const routeSeconds = await assertResources(tx, operatorId, input);
      await tx.tripSchedule.updateMany({ where: { id: scheduleId, operatorId }, data: ruleFields(input, routeSeconds) });
      return { before: current, after: (await findSchedule(tx, operatorId, scheduleId))! };
    });
    const response = toResponse(after);
    this.recordAudit(actor, operatorId, "trip_schedule.update", scheduleId, {
      before: auditRule(toResponse(before)),
      after: auditRule(response),
    });
    return response;
  }

  /**
   * Sinh chuyến nháp cho mọi ngày khớp quy tắc còn ở tương lai. Ngày đã có chuyến của lịch (kể cả đã hủy) / giờ khởi hành
   * đã qua / xe trùng giờ chuyến khác (BR-14) → bỏ qua kèm lý do; chạy lại sau khi gỡ trùng sẽ sinh nốt. `openForSale` →
   * mở bán từng chuyến vừa sinh qua đúng luồng đổi trạng thái (BR-39 + audit); chưa đủ điều kiện thì giữ nháp + lý do.
   */
  async generate(
    actor: TripActor,
    authz: Authorization,
    scheduleId: string,
    input: TripScheduleGenerateInput,
  ): Promise<TripScheduleGenerateResponse> {
    const { db, operatorId } = requireTenant(authz);
    const schedule = await this.prisma.withScope(db, async (tx) => {
      const row = await tx.tripSchedule.findFirst({
        where: { id: scheduleId, operatorId },
        select: { routeId: true, vehicleId: true, startDate: true, endDate: true, daysOfWeek: true },
      });
      if (!row) {
        throw tripScheduleNotFound();
      }
      // Tuyến / xe không dùng được thì báo ngay, không sinh dở dang từng ngày.
      await assertResources(tx, operatorId, row);
      return row;
    });

    const created: CreatedTrip[] = [];
    const skipped: { serviceDate: string; reason: SkipReason }[] = [];
    for (const serviceDate of scheduleDates(schedule)) {
      const outcome = await this.generateOne(db, operatorId, scheduleId, serviceDate);
      if (typeof outcome === "string") {
        skipped.push({ serviceDate, reason: outcome });
      } else {
        created.push({ ...outcome, serviceDate, status: TripStatus.DRAFT, notOpenedReasons: [] });
      }
    }
    if (input.openForSale) {
      for (const trip of created) {
        await this.openForSale(actor, authz, trip);
      }
    }
    await this.prisma.withScope(db, (tx) =>
      tx.tripSchedule.updateMany({ where: { id: scheduleId, operatorId }, data: { lastGeneratedAt: new Date() } }),
    );
    this.recordAudit(actor, operatorId, "trip_schedule.generate", scheduleId, {
      after: {
        created: created.length,
        opened: created.filter((trip) => trip.status === TripStatus.OPEN_FOR_SALE).length,
        skipped: skipped.length,
        vehicleConflicts: skipped.filter((day) => day.reason === "VEHICLE_CONFLICT").map((day) => day.serviceDate),
      },
    });
    return { created, skipped };
  }

  /**
   * Một ngày, một transaction: khoá dòng lịch (xếp hàng với lần sinh / sửa lịch đồng thời) rồi đọc quy tắc HIỆN TẠI, kiểm
   * ngày đã có chuyến chưa, rồi chèn chuyến. Xe chồng giờ (EXCLUDE) → bỏ qua ngày đó.
   */
  private async generateOne(
    db: DbScope,
    operatorId: string,
    scheduleId: string,
    serviceDate: string,
  ): Promise<{ tripId: string; departureAt: string } | SkipReason> {
    try {
      return await this.prisma.withScope(db, async (tx) => {
        const [rule] = await tx.$queryRaw<
          {
            routeId: string;
            vehicleId: string | null;
            departureMinute: number;
            onlineSaleCutoffMinutes: number;
            note: string | null;
          }[]
        >`
          SELECT route_id AS "routeId", vehicle_id AS "vehicleId", departure_minute AS "departureMinute",
                 online_sale_cutoff_minutes AS "onlineSaleCutoffMinutes", note
          FROM trip_schedules
          WHERE id = ${scheduleId} AND operator_id = ${operatorId}
          FOR UPDATE`;
        if (!rule) {
          throw tripScheduleNotFound();
        }
        const existing = await tx.trip.findFirst({
          where: { operatorId, scheduleId, serviceDate: dateOnly(serviceDate) },
          select: { id: true },
        });
        if (existing) {
          return "EXISTS";
        }
        const departureAt = departureOf(serviceDate, rule.departureMinute);
        if (departureAt.getTime() <= Date.now()) {
          return "PAST";
        }
        // Giờ đến tính theo thời gian chạy HIỆN TẠI của tuyến (`insertDraftTrip`), không theo số lưu lúc tạo lịch.
        const tripId = await insertDraftTrip(
          tx,
          operatorId,
          {
            routeId: rule.routeId,
            vehicleId: rule.vehicleId,
            departureAt,
            stopTimes: null,
            onlineSaleCutoffMinutes: rule.onlineSaleCutoffMinutes,
            note: rule.note,
          },
          { scheduleId, serviceDate: dateOnly(serviceDate) },
        );
        return { tripId, departureAt: departureAt.toISOString() };
      });
    } catch (error) {
      if (isVehicleOverlapViolation(error) || isDeadlock(error)) {
        return "VEHICLE_CONFLICT";
      }
      throw error;
    }
  }

  private async openForSale(actor: TripActor, authz: Authorization, trip: CreatedTrip): Promise<void> {
    try {
      await this.trips.changeStatus(actor, authz, trip.tripId, { status: TripStatus.OPEN_FOR_SALE, reason: null });
      trip.status = TripStatus.OPEN_FOR_SALE;
    } catch (error) {
      if (!(error instanceof HttpException)) {
        throw error;
      }
      // Chưa đủ điều kiện (BR-39) → các mã lý do; lỗi khác (vd audit chưa ghi được → 503) → mã lỗi. Chuyến vẫn là nháp.
      const body = error.getResponse() as { code?: string; reasons?: string[] };
      trip.notOpenedReasons = body.reasons ?? [body.code ?? "UNKNOWN"];
    }
  }

  // Lịch chưa phải dữ liệu tiền / chống bán trùng: audit ghi SAU commit và không chờ, Mongo lỗi chỉ ghi log (mẫu khóa ghế).
  private recordAudit(
    actor: TripActor,
    operatorId: string,
    action: string,
    targetId: string,
    change: { before?: Record<string, unknown>; after?: Record<string, unknown> },
  ): void {
    this.audit
      .recordAuditEvent({ actorId: actor.sub, actorRole: actor.role, action, targetType: AUDIT_TARGET, targetId, operatorId, ...change })
      .catch((error: unknown) => {
        this.logger.error({ event: "audit.write_failed", action, scheduleId: targetId, error });
      });
  }
}

const SCHEDULE_SELECT = {
  id: true,
  routeId: true,
  vehicleId: true,
  departureMinute: true,
  durationMinutes: true,
  daysOfWeek: true,
  startDate: true,
  endDate: true,
  onlineSaleCutoffMinutes: true,
  note: true,
  lastGeneratedAt: true,
  createdAt: true,
  updatedAt: true,
  route: { select: { name: true } },
  vehicle: { select: { plateNumber: true } },
  _count: { select: { trips: true } },
} as const;

function findSchedule(tx: DbTransaction, operatorId: string, scheduleId: string) {
  return tx.tripSchedule.findFirst({ where: { id: scheduleId, operatorId }, select: SCHEDULE_SELECT });
}

/** Cột của quy tắc; `durationMinutes` = thời gian chạy của tuyến lúc lưu (chỉ để hiển thị, ít nhất 1 phút). */
function ruleFields(input: TripScheduleInput, routeSeconds: number) {
  return {
    routeId: input.routeId,
    vehicleId: input.vehicleId,
    departureMinute: minuteOfDay(input.departureTime),
    durationMinutes: Math.max(1, Math.round(routeSeconds / 60)),
    daysOfWeek: daysToMask(input.daysOfWeek),
    startDate: dateOnly(input.startDate),
    endDate: dateOnly(input.endDate),
    onlineSaleCutoffMinutes: input.onlineSaleCutoffMinutes,
    note: input.note,
  };
}

/**
 * Tuyến phải đang dùng; xe (nếu chọn) phải đang hoạt động và có sơ đồ ghế — như khi tạo chuyến lẻ (UC-14 A2). Không phân
 * biệt "không có" / "tenant khác" / "ngừng dùng" để không lộ dữ liệu tenant khác. Trả thời gian chạy của tuyến (giây).
 */
async function assertResources(
  tx: DbTransaction,
  operatorId: string,
  input: { routeId: string; vehicleId: string | null },
): Promise<number> {
  const route = await tx.route.findFirst({
    where: { id: input.routeId, operatorId, status: RouteStatus.ACTIVE },
    select: { totalDurationSeconds: true },
  });
  if (!route) {
    throw routeUnavailable();
  }
  if (input.vehicleId) {
    const vehicle = await tx.vehicle.findFirst({
      where: { id: input.vehicleId, operatorId, status: VehicleStatus.ACTIVE, seatMapId: { not: null } },
      select: { id: true },
    });
    if (!vehicle) {
      throw vehicleUnavailable();
    }
  }
  return route.totalDurationSeconds;
}

function toResponse(row: NonNullable<Awaited<ReturnType<typeof findSchedule>>>): TripScheduleResponse {
  const { route, vehicle, _count, departureMinute, daysOfWeek, startDate, endDate, ...schedule } = row;
  return {
    ...schedule,
    routeName: route.name,
    vehiclePlateNumber: vehicle?.plateNumber ?? null,
    departureTime: timeOfDay(departureMinute),
    daysOfWeek: maskToDays(daysOfWeek),
    startDate: formatDateOnly(startDate),
    endDate: formatDateOnly(endDate),
    tripCount: _count.trips,
    lastGeneratedAt: schedule.lastGeneratedAt?.toISOString() ?? null,
    createdAt: schedule.createdAt.toISOString(),
    updatedAt: schedule.updatedAt.toISOString(),
  };
}

function auditRule(schedule: TripScheduleResponse): Record<string, unknown> {
  const { tripCount: _count, lastGeneratedAt: _last, createdAt: _created, updatedAt: _updated, ...rule } = schedule;
  return rule;
}
