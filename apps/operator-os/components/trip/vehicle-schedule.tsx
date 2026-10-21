"use client";

import { useQuery } from "@tanstack/react-query";
import { Button } from "@vexenhanh/ui/components/button";
import { Input } from "@vexenhanh/ui/components/input";
import { cn } from "@vexenhanh/ui/lib/utils";
import { CalendarClock, ChevronLeft, ChevronRight, CircleAlert, RefreshCw } from "lucide-react";
import Link from "next/link";
import { useRouter } from "next/navigation";
import { useEffect, useId, useMemo, useState, type MouseEvent, type ReactNode } from "react";

import { listAllRoutes } from "../../lib/route/route-api";
import type { TripStatus } from "../../lib/trip/trip-api";
import {
  formatWeekdayDate,
  fromLocalParts,
  nextLocalDate,
  todayLocalDate,
  TRIP_STATUS,
  TRIP_STATUS_ORDER
} from "../../lib/trip/trip-format";
import {
  barTimeLabel,
  buildSchedule,
  dayWindow,
  freeFromLabel,
  listTripsBetween,
  previousLocalDate,
  slotAt,
  type ScheduleBar
} from "../../lib/trip/vehicle-schedule";
import { listAllVehicles, listVehicleTypes } from "../../lib/vehicle/vehicle-api";
import { formatPlateNumber, vehicleTypeLabel } from "../../lib/vehicle/vehicle-format";
import { BUTTON, ListStatePanel } from "../list-parts";
import { ALL, FilterSelect, TableSkeleton } from "../stop-point/list-controls";

const HOURS = Array.from({ length: 12 }, (_, index) => `${String(index * 2).padStart(2, "0")}:00`);
/** Cột trái / phải của lưới (Figma: 168 / 168 trên 1086). */
const GRID = "grid grid-cols-[168px_minmax(0,1fr)_168px]";

/** Màu dải chuyến theo trạng thái (chú giải Figma 07). */
const BAR_STYLE: Record<TripStatus, string> = {
  DRAFT: "border border-dashed border-vxn-fg-3 bg-card text-vxn-fg-2",
  OPEN_FOR_SALE: "border-l-4 border-success-600 bg-success-50 text-success-700",
  SOLD_OUT: "border-l-4 border-vxn-teal-700 bg-accent text-vxn-teal-700",
  LOCKED: "border-l-4 border-warning-500 bg-warning-50 text-warning-700",
  BOARDING: "bg-vxn-teal-700 text-white",
  DEPARTED: "bg-vxn-teal-700 text-white",
  IN_PROGRESS: "bg-vxn-teal-700 text-white",
  COMPLETED: "border-l-4 border-vxn-fg-3 bg-muted text-vxn-fg-2",
  CANCELLED: "bg-error-50 text-error-600 line-through",
  INCIDENT: "bg-error-600 text-white"
};

const LEGEND: { label: string; className: string }[] = [
  { label: "Nháp", className: BAR_STYLE.DRAFT },
  { label: "Đang mở bán", className: BAR_STYLE.OPEN_FOR_SALE },
  { label: "Hết chỗ", className: BAR_STYLE.SOLD_OUT },
  { label: "Tạm dừng bán", className: BAR_STYLE.LOCKED },
  { label: "Đang chạy", className: BAR_STYLE.IN_PROGRESS },
  { label: "Hoàn thành", className: BAR_STYLE.COMPLETED },
  { label: "Đã hủy (không giữ xe)", className: "bg-error-50" }
];

/**
 * Lịch xe trong ngày (TASK-TRN-015; Figma "07 · Chuyến xe / Lịch xe"): mỗi xe một hàng trên trục 24 giờ, dải chuyến tô
 * theo trạng thái, hàng "Chưa gắn xe", cột "Rảnh từ (dự kiến)" kèm nơi xe dừng (chỉ hiển thị), vạch "bây giờ". Bấm một
 * chuyến để mở chi tiết; bấm khoảng trống của xe để tạo chuyến với xe và giờ điền sẵn.
 */
export function VehicleSchedule() {
  const router = useRouter();
  const today = useMemo(() => todayLocalDate(), []);
  const [date, setDate] = useState(today);
  const [routeId, setRouteId] = useState<string>(ALL);
  const [status, setStatus] = useState<string>(ALL);
  const [nowMs, setNowMs] = useState(() => Date.now());
  const dateId = useId();
  useEffect(() => {
    const timer = setInterval(() => setNowMs(Date.now()), 60_000);
    return () => clearInterval(timer);
  }, []);

  const validDate = /^\d{4}-\d{2}-\d{2}$/.test(date) && date >= "1971-01-01";
  const vehicles = useQuery({ queryKey: ["vehicles", "all"], queryFn: listAllVehicles });
  const vehicleTypes = useQuery({ queryKey: ["catalog", "vehicle-types"], queryFn: listVehicleTypes, staleTime: 300_000 });
  const routes = useQuery({ queryKey: ["routes", "all"], queryFn: () => listAllRoutes() });
  // API lọc theo giờ khởi hành: lấy từ đầu hôm trước để thấy chuyến qua đêm.
  const trips = useQuery({
    queryKey: ["trips", "schedule", date],
    queryFn: () => listTripsBetween(fromLocalParts(previousLocalDate(date), "00:00"), fromLocalParts(nextLocalDate(date), "00:00")),
    enabled: validDate
  });

  const destinations = useMemo(
    () => new Map((routes.data ?? []).map((route) => [route.id, route.destinationName])),
    [routes.data]
  );
  const typeNames = useMemo(
    () => new Map((vehicleTypes.data ?? []).map((type) => [type.id, vehicleTypeLabel(type)])),
    [vehicleTypes.data]
  );
  const schedule = useMemo(() => {
    if (!trips.data || !vehicles.data) {
      return null;
    }
    const shown = trips.data.filter(
      (trip) => (routeId === ALL || trip.routeId === routeId) && (status === ALL || trip.status === status)
    );
    // Xe đang hoạt động + xe ngừng dùng nhưng vẫn có chuyến trong ngày.
    const withTrips = new Set(trips.data.map((trip) => trip.vehicleId));
    const rows = vehicles.data.filter((vehicle) => vehicle.status === "ACTIVE" || withTrips.has(vehicle.id));
    return buildSchedule(rows, shown, date, (id) => destinations.get(id));
  }, [trips.data, vehicles.data, routeId, status, date, destinations]);

  const { startMs, endMs } = validDate ? dayWindow(date) : { startMs: 0, endMs: 0 };
  const nowPct = nowMs >= startMs && nowMs < endMs ? ((nowMs - startMs) / (endMs - startMs)) * 100 : null;

  function createAt(event: MouseEvent<HTMLDivElement>, vehicleId: string) {
    const box = event.currentTarget.getBoundingClientRect();
    const slot = slotAt(date, (event.clientX - box.left) / box.width);
    router.push(`/trips/new?vehicleId=${vehicleId}&date=${slot.date}&time=${slot.time}`);
  }

  let body;
  if (trips.isError || vehicles.isError) {
    body = (
      <ListStatePanel
        compact
        icon={<CircleAlert className="size-6 text-warning-700" />}
        title="Không tải được lịch xe"
        description="Không kết nối được máy chủ. Vui lòng kiểm tra kết nối và thử lại."
        action={
          <Button
            variant="outline"
            className={`${BUTTON} bg-card`}
            onClick={() => {
              void trips.refetch();
              void vehicles.refetch();
            }}
          >
            <RefreshCw className="size-[18px]" />
            Thử lại
          </Button>
        }
      />
    );
  } else if (!schedule) {
    body = <TableSkeleton label="Đang tải lịch xe" />;
  } else {
    const { rows, unassigned, summary } = schedule;
    body = (
      <>
        <div className="flex flex-wrap items-center justify-between gap-3 text-sm leading-5 text-muted-foreground">
          <p>
            {summary.vehicleCount} xe · {summary.departures} chuyến khởi hành trong ngày · {summary.unassigned} chuyến chưa gắn xe ·{" "}
            {summary.idleVehicles} xe chưa có chuyến
          </p>
          {nowPct !== null && (
            <p className="flex items-center gap-1.5 font-semibold text-error-600">
              <span aria-hidden className="size-2 rounded-full bg-error-600" />
              Bây giờ {new Date(nowMs + 7 * 3_600_000).toISOString().slice(11, 16)}
            </p>
          )}
        </div>
        <div className="relative overflow-x-auto">
          <div role="table" aria-label="Lịch xe trong ngày" className="min-w-[1000px]">
            <div role="row" className={cn(GRID, "h-11 items-center rounded-lg bg-muted text-xs leading-[18px] text-muted-foreground")}>
              <span role="columnheader" className="pl-4">
                Xe
              </span>
              <span role="columnheader" className="relative h-full">
                {HOURS.map((hour, index) => (
                  <span key={hour} className="absolute top-1/2 -translate-y-1/2" style={{ left: `calc(${(index / 12) * 100}% + 4px)` }}>
                    {hour}
                  </span>
                ))}
              </span>
              <span role="columnheader" className="pl-4">
                Rảnh từ (dự kiến)
              </span>
            </div>
            {unassigned.length > 0 && (
              <Row
                label="Chưa gắn xe"
                sub={`${unassigned.length} chuyến${unassigned.every((bar) => bar.trip.status === "DRAFT") ? " nháp" : ""}`}
                muted
                nowPct={nowPct}
                free={<Free main="—" sub="Gắn xe trước khi mở bán" />}
              >
                {unassigned.map((bar) => (
                  <Bar key={bar.trip.id} bar={bar} />
                ))}
              </Row>
            )}
            {rows.map((row) => {
              const typeName = typeNames.get(row.vehicle.vehicleTypeId);
              return (
                <Row
                  key={row.vehicle.id}
                  label={formatPlateNumber(row.vehicle.plateNumber)}
                  sub={[typeName, row.vehicle.seatMap ? `${row.vehicle.seatMap.seatCount} chỗ` : "Chưa có sơ đồ ghế"].filter(Boolean).join(" · ")}
                  nowPct={nowPct}
                  onEmptyClick={row.vehicle.status === "ACTIVE" && row.vehicle.seatMap ? (event) => createAt(event, row.vehicle.id) : undefined}
                  emptyLabel={`Tạo chuyến cho xe ${formatPlateNumber(row.vehicle.plateNumber)}`}
                  free={
                    row.freeFrom ? (
                      <Free main={freeFromLabel(row.freeFrom.at, date)} sub={row.freeFrom.place ? `tại ${row.freeFrom.place}` : ""} />
                    ) : (
                      <Free main="Cả ngày" sub="Chưa có chuyến" />
                    )
                  }
                >
                  {row.bars.length === 0 && (
                    <span className="pointer-events-none absolute inset-0 flex items-center justify-center text-sm text-muted-foreground">
                      Chưa có chuyến trong ngày
                    </span>
                  )}
                  {row.bars.map((bar) => (
                    <Bar key={bar.trip.id} bar={bar} />
                  ))}
                </Row>
              );
            })}
            {rows.length === 0 && unassigned.length === 0 && (
              <p className="px-4 py-10 text-center text-sm text-muted-foreground">Nhà xe chưa có xe đang hoạt động. Thêm xe ở mục Phương tiện.</p>
            )}
          </div>
        </div>
        <ul aria-label="Chú giải" className="flex flex-wrap items-center gap-x-5 gap-y-2 text-xs leading-[18px] text-vxn-fg-2">
          {LEGEND.map((item) => (
            <li key={item.label} className="flex items-center gap-1.5">
              <span aria-hidden className={cn("h-3 w-4 rounded-sm", item.className)} />
              {item.label}
            </li>
          ))}
          <li className="flex items-center gap-1.5">
            <span aria-hidden className="size-2.5 rounded-full bg-warning-500" />
            Nối chuyến sát giờ
          </li>
        </ul>
      </>
    );
  }

  return (
    <>
      <section aria-label="Lịch xe" className="flex flex-col gap-5 rounded-xl border bg-card p-6">
        <div className="flex flex-wrap items-end gap-x-4 gap-y-3">
          <div className="flex flex-col gap-1.5">
            <label htmlFor={dateId} className="text-xs leading-[18px] font-medium text-muted-foreground">
              Ngày
            </label>
            <div className="flex flex-wrap items-center gap-2">
              <Input id={dateId} type="date" className="w-44" value={date} onChange={(event) => setDate(event.target.value)} />
              <Button type="button" variant="outline" className="size-10 bg-card p-0" aria-label="Ngày trước" disabled={!validDate} onClick={() => setDate(previousLocalDate(date))}>
                <ChevronLeft className="size-4" />
              </Button>
              <Button type="button" variant="outline" className="size-10 bg-card p-0" aria-label="Ngày sau" disabled={!validDate} onClick={() => setDate(nextLocalDate(date))}>
                <ChevronRight className="size-4" />
              </Button>
              <Button type="button" variant="outline" className={`${BUTTON} bg-card`} onClick={() => setDate(today)}>
                Hôm nay
              </Button>
            </div>
          </div>
          {validDate && <p className="pb-2.5 text-sm font-semibold text-vxn-ink">{formatWeekdayDate(fromLocalParts(date, "12:00"))}</p>}
          <div className="ml-auto flex flex-wrap items-end gap-4">
            <FilterSelect
              label="Tuyến"
              allLabel="Tất cả tuyến"
              value={routeId}
              onChange={setRouteId}
              options={(routes.data ?? []).map((route) => ({ value: route.id, label: route.name }))}
              className="w-52"
            />
            <FilterSelect
              label="Trạng thái"
              allLabel="Tất cả trạng thái"
              value={status}
              onChange={setStatus}
              options={TRIP_STATUS_ORDER.map((value) => ({ value, label: TRIP_STATUS[value].label }))}
              className="w-52"
            />
          </div>
        </div>
        {body}
      </section>
      <div role="note" className="flex gap-3 rounded-lg bg-accent px-5 py-4 text-sm leading-5 text-vxn-teal-700">
        <CalendarClock className="mt-px size-5 shrink-0" />
        <p>
          Giờ đến là giờ dự kiến (giờ khởi hành + thời gian chạy của tuyến). Xe bận từ giờ khởi hành tới giờ đến; chuyến sau được khởi hành
          đúng lúc chuyến trước đến. Bấm vào một chuyến để mở chi tiết, bấm vào khoảng trống của xe để tạo chuyến với xe và giờ điền sẵn.
        </p>
      </div>
    </>
  );
}

function Row({
  label,
  sub,
  muted = false,
  nowPct,
  onEmptyClick,
  emptyLabel,
  free,
  children
}: {
  label: string;
  sub: string;
  muted?: boolean;
  nowPct: number | null;
  onEmptyClick?: (event: MouseEvent<HTMLDivElement>) => void;
  emptyLabel?: string;
  /** Ô "Rảnh từ (dự kiến)". */
  free: ReactNode;
  /** Các dải chuyến trên trục thời gian. */
  children: ReactNode;
}) {
  return (
    <div role="row" className={cn(GRID, "min-h-16 border-b", muted && "bg-muted/40")}>
      <div role="cell" className="flex min-w-0 flex-col justify-center py-2 pl-4">
        <span className={cn("truncate text-[15px] leading-[22px] font-semibold", muted ? "text-vxn-fg-2" : "text-vxn-ink")}>{label}</span>
        <span className="truncate text-xs leading-[18px] text-muted-foreground">{sub}</span>
      </div>
      <div role="cell" className="relative border-l">
        {HOURS.map((hour, index) => (
          <span key={hour} aria-hidden className="absolute inset-y-0 border-l border-border/60" style={{ left: `${(index / 12) * 100}%` }} />
        ))}
        {onEmptyClick && (
          <div
            role="button"
            tabIndex={-1}
            aria-label={emptyLabel}
            className="absolute inset-0 cursor-copy hover:bg-accent/40"
            onClick={onEmptyClick}
          />
        )}
        {children}
        {nowPct !== null && <span aria-hidden className="pointer-events-none absolute inset-y-0 z-20 w-0.5 bg-error-600" style={{ left: `${nowPct}%` }} />}
      </div>
      {free}
    </div>
  );
}

function Bar({ bar }: { bar: ScheduleBar }) {
  const { trip } = bar;
  return (
    <Link
      href={`/trips/${trip.id}`}
      title={`${trip.routeName} · ${barTimeLabel(bar)} · ${TRIP_STATUS[trip.status].label}`}
      aria-label={`${trip.routeName}, ${barTimeLabel(bar)}, ${TRIP_STATUS[trip.status].label}`}
      className={cn(
        "absolute top-2 bottom-2 z-10 flex min-w-6 flex-col justify-center overflow-hidden rounded-md px-2 text-xs leading-[18px] outline-none focus-visible:ring-[3px] focus-visible:ring-ring/50",
        BAR_STYLE[trip.status]
      )}
      style={{ left: `${bar.leftPct}%`, width: `${bar.widthPct}%` }}
    >
      {bar.tight && <span aria-hidden className="absolute top-1/2 -left-1 size-2.5 -translate-y-1/2 rounded-full bg-warning-500" />}
      <span className="truncate font-semibold">{trip.routeName}</span>
      <span className="truncate">{barTimeLabel(bar)}</span>
    </Link>
  );
}

function Free({ main, sub }: { main: string; sub: string }) {
  return (
    <div role="cell" className="flex min-w-0 flex-col justify-center py-2 pl-4">
      <span className="truncate text-[15px] leading-[22px] font-semibold text-vxn-ink">{main}</span>
      {sub && <span className="truncate text-xs leading-[18px] text-muted-foreground">{sub}</span>}
    </div>
  );
}
