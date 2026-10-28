"use client";

import { useQuery } from "@tanstack/react-query";
import { useCan } from "@vexenhanh/ui/components/auth/auth-context";
import { Badge } from "@vexenhanh/ui/components/badge";
import {
  TABLE,
  TABLE_CELL,
  TABLE_HEAD_CELL,
  TABLE_HEAD_ROW,
} from "@vexenhanh/ui/components/list-controls";
import { MapLine, MapMarker, MapView } from "@vexenhanh/ui/components/map";
import { GOONG_MAPTILES_KEY } from "@vexenhanh/ui/lib/map-config";
import Link from "next/link";
import { useMemo, useState } from "react";

import { getRoute, type RouteDetail } from "../../lib/operation/operation-api";
import {
  count,
  dayLabel,
  distanceLabel,
  durationLabel,
  fillLabel,
  provincePair,
  ratingLabel,
  ROUTE_STATUS,
  TRIP_STATUS,
  tripTime,
} from "../../lib/operation/operation-format";
import { formatVnd } from "../../lib/payment/payment-format";
import { lastDays, validRange } from "../../lib/report/report-format";
import { STOP_POINT_TYPE_LABELS } from "../../lib/stop-point/stop-point-format";
import {
  Card,
  DetailHeader,
  DetailShell,
  detailState,
  retryUnlessFinal,
  Stat,
} from "./detail-parts";
import { PeriodFields } from "./period-fields";

// Màu `--primary` bảng Admin (indigo); lớp vẽ của bản đồ không đọc được biến CSS.
const LINE_COLOR = "#4338ca";
const BACK = { href: "/routes", label: "Quay lại Tuyến & chuyến" };

/**
 * Chi tiết tuyến (tự thiết kế 28/10/2026, chờ duyệt; chưa có Figma): số liệu theo kỳ, lộ trình trên bản đồ (đường thẳng nối
 * các điểm theo thứ tự — không phải đường đi thực tế), bảng điểm dừng, 10 chuyến sắp chạy.
 */
export function RouteDetailScreen({ routeId }: { routeId: string }) {
  const [period, setPeriod] = useState(() => lastDays(30));
  const valid = validRange(period.from, period.to);
  const route = useQuery({
    queryKey: ["admin-route", routeId, period],
    queryFn: () => getRoute(routeId, period),
    enabled: valid,
    placeholderData: (previous) => previous,
    retry: retryUnlessFinal,
  });
  const pending = detailState(route, "tuyến");
  return (
    <DetailShell back={BACK}>
      {pending ?? (
        <RouteBody
          route={route.data!}
          period={period}
          onPeriod={setPeriod}
          valid={valid}
        />
      )}
    </DetailShell>
  );
}

function RouteBody({
  route,
  period,
  onPeriod,
  valid,
}: {
  route: RouteDetail;
  period: { from: string; to: string };
  onPeriod: (next: { from: string; to: string }) => void;
  valid: boolean;
}) {
  const showMoney = useCan()("payment:monitor");
  const status = ROUTE_STATUS[route.status];
  const points = useMemo(
    () =>
      route.stops.map((stop) => ({
        latitude: stop.latitude,
        longitude: stop.longitude,
      })),
    [route.stops],
  );
  return (
    <>
      <DetailHeader
        title={route.name}
        badges={status && <Badge tone={status.tone}>{status.label}</Badge>}
        subtitle={
          <>
            <Link
              href={`/operators/${route.operatorId}`}
              className="font-medium text-primary hover:underline"
            >
              {route.operatorName}
            </Link>
            {` · ${provincePair(route.origin, route.destination)} · ${distanceLabel(route.distanceMeters)} · ${durationLabel(route.durationSeconds)}`}
          </>
        }
      />
      <div className="flex flex-wrap items-end gap-4">
        <PeriodFields value={period} onChange={onPeriod} />
        <p className="pb-2 text-xs leading-[18px] text-muted-foreground">
          {valid
            ? `Số liệu chuyến khởi hành ${dayLabel(route.period.from)} – ${dayLabel(route.period.to)}.`
            : "Kỳ không hợp lệ (tối đa 366 ngày)."}
        </p>
      </div>
      <div className="grid gap-4 sm:grid-cols-2 xl:grid-cols-5">
        <Stat
          label="Chuyến"
          value={count(route.trips)}
          note={`${count(route.completedTrips)} hoàn thành · ${count(route.cancelledTrips)} đã hủy`}
        />
        <Stat
          label="Vé bán"
          value={count(route.ticketsSold)}
          note={`${count(route.seats)} chỗ mở bán`}
        />
        <Stat
          label="Lấp đầy"
          value={fillLabel(route.ticketsSold, route.seats)}
        />
        {showMoney && (
          <Stat
            label="Doanh thu vé"
            value={
              route.ticketRevenue === null
                ? "—"
                : formatVnd(route.ticketRevenue)
            }
          />
        )}
        <Stat
          label="Đánh giá"
          value={ratingLabel(route.averageRating, route.reviewCount)}
          note={`${count(route.upcomingTrips)} chuyến đang mở bán`}
        />
      </div>
      <div className="grid items-start gap-6 xl:grid-cols-[minmax(0,1fr)_420px]">
        <Card
          title="Điểm dừng"
          description={`${route.stopCount} điểm theo thứ tự chạy`}
        >
          {route.stops.length === 0 ? (
            <p className="text-sm leading-5 text-muted-foreground">
              Tuyến chưa có điểm dừng.
            </p>
          ) : (
            <div className="relative overflow-x-auto">
              <table className={`${TABLE} min-w-[640px]`}>
                <thead>
                  <tr className={TABLE_HEAD_ROW}>
                    {[
                      "#",
                      "Điểm dừng",
                      "Loại",
                      "Đón / trả",
                      "Từ điểm trước",
                    ].map((heading) => (
                      <th key={heading} scope="col" className={TABLE_HEAD_CELL}>
                        {heading}
                      </th>
                    ))}
                  </tr>
                </thead>
                <tbody>
                  {route.stops.map((stop) => (
                    <tr key={stop.sequence} className="h-[64px] border-b">
                      <td className={`${TABLE_CELL} w-10 tabular-nums`}>
                        {stop.sequence}
                      </td>
                      <td className={TABLE_CELL}>
                        <div className="flex min-w-0 flex-col">
                          <span className="truncate font-semibold text-vxn-ink">
                            {stop.name}
                          </span>
                          <span className="truncate text-xs leading-[18px] text-muted-foreground">
                            {[stop.address, stop.provinceName]
                              .filter(Boolean)
                              .join(" · ")}
                          </span>
                        </div>
                      </td>
                      <td className={TABLE_CELL}>
                        {STOP_POINT_TYPE_LABELS[stop.type]}
                        <span className="block text-xs leading-[18px] text-muted-foreground">
                          {stop.shared ? "Dùng chung" : "Của nhà xe"}
                        </span>
                      </td>
                      <td className={TABLE_CELL}>
                        {[
                          stop.allowPickup ? "Đón" : null,
                          stop.allowDropoff ? "Trả" : null,
                        ]
                          .filter(Boolean)
                          .join(" · ") || "—"}
                      </td>
                      <td className={`${TABLE_CELL} tabular-nums`}>
                        {stop.distanceMetersFromPrevious === null
                          ? "—"
                          : distanceLabel(stop.distanceMetersFromPrevious)}
                        {stop.durationSecondsFromPrevious !== null && (
                          <span className="block text-xs leading-[18px] text-muted-foreground">
                            {durationLabel(stop.durationSecondsFromPrevious)}
                          </span>
                        )}
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          )}
        </Card>
        <Card
          title="Lộ trình trên bản đồ"
          description="Đường nối thẳng giữa các điểm chỉ để xem thứ tự và vị trí, không phải đường đi thực tế."
        >
          {GOONG_MAPTILES_KEY ? (
            <MapView
              mapKey={GOONG_MAPTILES_KEY}
              label={`Bản đồ lộ trình tuyến ${route.name}`}
              className="h-[360px] overflow-hidden rounded-lg"
              fitPoints={points}
              cooperativeGestures
            >
              {points.length > 1 && (
                <MapLine points={points} color={LINE_COLOR} dashed />
              )}
              {route.stops.map((stop) => (
                <MapMarker
                  key={stop.sequence}
                  point={{ latitude: stop.latitude, longitude: stop.longitude }}
                  zIndex={2}
                >
                  <span
                    role="img"
                    aria-label={`Điểm ${stop.sequence}: ${stop.name}`}
                    title={stop.name}
                    className="flex size-[26px] items-center justify-center rounded-full border-2 border-card bg-primary text-xs leading-none font-semibold text-primary-foreground shadow-md"
                  >
                    {stop.sequence}
                  </span>
                </MapMarker>
              ))}
            </MapView>
          ) : (
            <p className="rounded-lg bg-warning-50 px-4 py-3 text-sm leading-5 text-warning-700">
              Chưa cấu hình khóa bản đồ (NEXT_PUBLIC_GOONG_MAPTILES_KEY) nên
              không vẽ được lộ trình.
            </p>
          )}
        </Card>
      </div>
      <Card
        title="Chuyến sắp chạy"
        description="10 chuyến gần nhất chưa khởi hành (trừ nháp, đã hủy)."
      >
        {route.nextTrips.length === 0 ? (
          <p className="text-sm leading-5 text-muted-foreground">
            Tuyến chưa có chuyến sắp chạy.
          </p>
        ) : (
          <div className="relative overflow-x-auto">
            <table className={`${TABLE} min-w-[560px]`}>
              <thead>
                <tr className={TABLE_HEAD_ROW}>
                  {[
                    "Giờ khởi hành",
                    "Xe",
                    "Đã bán / tổng chỗ",
                    "Trạng thái",
                  ].map((heading) => (
                    <th key={heading} scope="col" className={TABLE_HEAD_CELL}>
                      {heading}
                    </th>
                  ))}
                </tr>
              </thead>
              <tbody>
                {route.nextTrips.map((trip) => {
                  const tripStatus = TRIP_STATUS[trip.status] ?? {
                    label: trip.status,
                    tone: "neutral" as const,
                  };
                  return (
                    <tr key={trip.id} className="h-[56px] border-b">
                      <td className={TABLE_CELL}>
                        <Link
                          href={`/routes/trips/${trip.id}`}
                          className="font-semibold text-vxn-ink tabular-nums hover:text-primary hover:underline"
                        >
                          {tripTime(trip.departureAt)}
                        </Link>
                      </td>
                      <td className={TABLE_CELL}>
                        {trip.vehiclePlate ?? "Chưa gắn xe"}
                      </td>
                      <td className={`${TABLE_CELL} tabular-nums`}>
                        {count(trip.ticketsSold)} / {count(trip.seats)} ·{" "}
                        {fillLabel(trip.ticketsSold, trip.seats)}
                      </td>
                      <td className={TABLE_CELL}>
                        <Badge tone={tripStatus.tone}>{tripStatus.label}</Badge>
                      </td>
                    </tr>
                  );
                })}
              </tbody>
            </table>
          </div>
        )}
      </Card>
    </>
  );
}
