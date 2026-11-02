"use client";

import { cn } from "@vexenhanh/ui/lib/utils";

import { formatDuration } from "../../lib/route/route-format";
import type { TripSummary } from "../../lib/trip/trip-api";
import { formatDay, formatTime, formatWeekdayDate, fromLocalParts } from "../../lib/trip/trip-format";
import { buildSchedule, dayWindow, type DestinationOf } from "../../lib/trip/vehicle-schedule";

const AXIS = ["00:00", "06:00", "12:00", "18:00", "24:00"];

/**
 * Thẻ "Lịch xe trong ngày" ở form chuyến (Figma khung 02, TASK-TRN-015): dải các chuyến của xe đang chọn trong ngày
 * khởi hành + chuyến đang tạo (viền đứt), chuyến trước, khoảng nghỉ và lúc xe rảnh lại sau chuyến này. Giờ đến là dự kiến.
 */
export function VehicleDayCard({
  plate,
  vehicleId,
  date,
  trips,
  draft,
  destinationOf,
  draftDestination,
  exceptTripId
}: {
  plate: string;
  vehicleId: string;
  /** Ngày khởi hành `2026-10-10`. */
  date: string;
  trips: TripSummary[];
  /** Khoảng giờ của chuyến đang tạo / sửa; `null` khi chưa nhập đủ giờ. */
  draft: { departureAt: string; arrivalAt: string } | null;
  destinationOf: DestinationOf;
  draftDestination: string | undefined;
  exceptTripId?: string;
}) {
  const others = trips.filter((trip) => trip.id !== exceptTripId);
  const { rows } = buildSchedule([{ id: vehicleId }], others, date, destinationOf);
  const bars = rows[0]!.bars.filter((bar) => bar.trip.status !== "CANCELLED");
  const { startMs, endMs } = dayWindow(date);
  const draftMs = draft ? { from: new Date(draft.departureAt).getTime(), to: new Date(draft.arrivalAt).getTime() } : null;
  const previous = draftMs
    ? others
        .filter((trip) => trip.vehicleId === vehicleId && trip.status !== "CANCELLED" && new Date(trip.arrivalAt).getTime() <= draftMs.from)
        .sort((a, b) => new Date(b.arrivalAt).getTime() - new Date(a.arrivalAt).getTime())[0]
    : undefined;
  const pct = (value: number) => ((Math.min(Math.max(value, startMs), endMs) - startMs) / (endMs - startMs)) * 100;

  return (
    <section aria-labelledby="vehicle-day-heading" className="flex flex-col gap-3.5 rounded-xl border bg-card p-6">
      <div className="flex flex-col gap-0.5">
        <h2 id="vehicle-day-heading" className="text-base leading-6 font-semibold text-vxn-ink">
          Lịch xe trong ngày
        </h2>
        <p className="text-xs leading-[18px] text-muted-foreground">
          {plate} · {formatWeekdayDate(fromLocalParts(date, "12:00"))} · giờ đến là giờ dự kiến
        </p>
      </div>
      <div>
        <div className="relative h-9 rounded-md bg-muted">
          {bars.map((bar) => (
            <span
              key={bar.trip.id}
              title={`${bar.trip.routeName} · ${formatTime(bar.trip.departureAt)}–${formatTime(bar.trip.arrivalAt)}`}
              className="absolute top-1 bottom-1 flex items-center overflow-hidden rounded border-l-4 border-vxn-teal-700 bg-card px-1.5 text-[11px] font-semibold whitespace-nowrap text-vxn-teal-700"
              style={{ left: `${bar.leftPct}%`, width: `${bar.widthPct}%` }}
            >
              {formatTime(bar.trip.departureAt)}–{formatTime(bar.trip.arrivalAt)}
            </span>
          ))}
          {draftMs && draftMs.to > startMs && draftMs.from < endMs && (
            <span
              className="absolute top-1 bottom-1 flex items-center overflow-hidden rounded border border-dashed border-vxn-teal-700 bg-accent px-1.5 text-[11px] font-semibold whitespace-nowrap text-vxn-teal-700"
              style={{ left: `${pct(draftMs.from)}%`, width: `${Math.max(pct(draftMs.to) - pct(draftMs.from), 2)}%` }}
            >
              {formatTime(draft!.departureAt)} →
            </span>
          )}
        </div>
        <div className="mt-1 flex justify-between text-[11px] leading-4 text-muted-foreground">
          {AXIS.map((label) => (
            <span key={label}>{label}</span>
          ))}
        </div>
        <ul className="mt-1.5 flex flex-wrap gap-x-4 gap-y-1 text-[11px] leading-4 text-muted-foreground">
          <li className="flex items-center gap-1.5">
            <span aria-hidden className="h-2.5 w-3 rounded-sm border-l-4 border-vxn-teal-700 bg-card" />
            Chuyến đã có của xe
          </li>
          <li className="flex items-center gap-1.5">
            <span aria-hidden className="h-2.5 w-3 rounded-sm border border-dashed border-vxn-teal-700" />
            Chuyến đang tạo
          </li>
        </ul>
      </div>
      <dl className="flex flex-col gap-3 text-sm leading-5">
        <Row
          label="Chuyến trước"
          value={previous ? `${previous.routeName} · đến ${formatTime(previous.arrivalAt)}` : "Không có"}
          highlight={false}
        />
        <Row
          label="Khoảng nghỉ"
          value={previous && draftMs ? formatDuration((draftMs.from - new Date(previous.arrivalAt).getTime()) / 1000) || "0 phút" : "—"}
          highlight={false}
        />
        <Row
          label="Sau chuyến này"
          value={
            draft
              ? `Rảnh từ ${formatTime(draft.arrivalAt)} · ${formatDay(draft.arrivalAt).slice(0, 5)}${draftDestination ? ` · tại ${draftDestination}` : ""}`
              : "Nhập giờ khởi hành và giờ đến"
          }
          highlight
        />
      </dl>
    </section>
  );
}

function Row({ label, value, highlight }: { label: string; value: string; highlight: boolean }) {
  return (
    <div className="flex items-baseline justify-between gap-4">
      <dt className="shrink-0 text-muted-foreground">{label}</dt>
      <dd className={cn("text-right font-semibold text-vxn-ink", highlight && "text-vxn-teal-700")}>{value}</dd>
    </div>
  );
}
