"use client";

import { useQuery } from "@tanstack/react-query";
import { Badge } from "@vexenhanh/ui/components/badge";
import { Button } from "@vexenhanh/ui/components/button";
import { Skeleton } from "@vexenhanh/ui/components/skeleton";
import { ArrowLeft, CircleAlert, CircleCheck, FileX2, Pencil, RefreshCw } from "lucide-react";
import Link from "next/link";
import { useSearchParams } from "next/navigation";
import { useState, type ReactNode } from "react";

import { ApiError } from "../../lib/auth/api-client";
import { formatDateTime } from "../../lib/route/route-format";
import { getTrip, type Trip } from "../../lib/trip/trip-api";
import {
  arrivalDayNote,
  formatTime,
  formatWeekdayDate,
  seatCountLabel,
  stopMetaLabel,
  TRIP_STATUS,
  tripDurationLabel,
  tripHeadline
} from "../../lib/trip/trip-format";
import { formatPlateNumber } from "../../lib/vehicle/vehicle-format";
import { BUTTON } from "../list-parts";
import { TripSeatMap } from "./trip-seat-map";
import { StopTimeText, TripStopRow } from "./trip-stop-row";

const CARD = "flex flex-col gap-5 rounded-xl border bg-card p-6";
const CARD_TITLE = "text-base leading-6 font-semibold text-vxn-ink";
const HELPER = "text-xs leading-[18px] text-muted-foreground";

/**
 * Trang chi tiết một chuyến (Figma "03 · Chuyến xe / Chi tiết chuyến nháp"; FR-OPS-06, UC-14): sơ đồ ghế theo
 * chuyến, lịch trình và thông tin chuyến. Chuyến đang Nháp thì có nút Sửa chuyến; mở bán, hủy và khóa chỗ
 * thuộc TASK-TRN-006.
 */
export function TripDetail({ tripId }: { tripId: string }) {
  const trip = useQuery({ queryKey: ["trip", tripId], queryFn: () => getTrip(tripId) });
  const [saved, setSaved] = useState(useSearchParams().get("saved") === "1");

  if (trip.error instanceof ApiError && trip.error.status === 404) {
    return (
      <Shell>
        <StatePanel
          icon={<FileX2 className="size-6 text-vxn-fg-3" />}
          title="Không tìm thấy chuyến"
          description="Chuyến không tồn tại hoặc không thuộc nhà xe của bạn."
          action={
            <Button asChild variant="outline" className={`${BUTTON} bg-card`}>
              <Link href="/trips">Về danh sách chuyến</Link>
            </Button>
          }
        />
      </Shell>
    );
  }
  if (trip.isError) {
    return (
      <Shell>
        <StatePanel
          icon={<CircleAlert className="size-6 text-warning-700" />}
          title="Không tải được chuyến"
          description="Không kết nối được máy chủ. Vui lòng kiểm tra kết nối và thử lại."
          action={
            <Button variant="outline" className={`${BUTTON} bg-card`} onClick={() => void trip.refetch()}>
              <RefreshCw className="size-[18px]" />
              Thử lại
            </Button>
          }
        />
      </Shell>
    );
  }
  if (trip.isPending) {
    return (
      <Shell>
        <div role="status" aria-label="Đang tải chuyến" className="flex flex-col gap-6">
          <Skeleton className="h-16 w-2/3 rounded-xl" />
          <div className="grid gap-6 xl:grid-cols-[minmax(0,1fr)_440px]">
            <Skeleton className="h-[440px] rounded-xl" />
            <Skeleton className="h-[440px] rounded-xl" />
          </div>
        </div>
      </Shell>
    );
  }
  return <TripDetailBody trip={trip.data} saved={saved} onDismissSaved={() => setSaved(false)} />;
}

function TripDetailBody({ trip, saved, onDismissSaved }: { trip: Trip; saved: boolean; onDismissSaved: () => void }) {
  const state = TRIP_STATUS[trip.status];
  const plate = trip.vehiclePlateNumber && formatPlateNumber(trip.vehiclePlateNumber);
  const arrivalNote = arrivalDayNote(trip.departureAt, trip.arrivalAt);
  return (
    <Shell>
      <header className="flex flex-wrap items-center gap-x-6 gap-y-3">
        <div className="flex min-w-0 flex-1 flex-col gap-1.5">
          <div className="flex flex-wrap items-center gap-3">
            <h1 className="text-[30px] leading-[38px] font-semibold text-vxn-ink">{trip.routeName}</h1>
            <Badge tone={state.tone}>{state.label}</Badge>
          </div>
          <p className="text-sm leading-5 text-muted-foreground">{tripHeadline(trip, plate)}</p>
        </div>
        {trip.status === "DRAFT" && (
          <Button asChild variant="outline" className={`${BUTTON} bg-card`}>
            <Link href={`/trips/${trip.id}/edit`}>
              <Pencil className="size-[18px]" />
              Sửa chuyến
            </Link>
          </Button>
        )}
      </header>

      {saved && (
        <div role="status" className="flex flex-wrap items-center gap-3 rounded-lg bg-success-50 px-5 py-3.5">
          <CircleCheck className="size-5 shrink-0 text-success-600" />
          <div className="min-w-0 flex-1">
            <p className="text-sm leading-5 font-semibold text-success-600">Đã lưu chuyến nháp</p>
            <p className="text-sm leading-5 text-success-600">Chuyến chưa hiện với khách cho tới khi được mở bán.</p>
          </div>
          <Button type="button" variant="outline" className={`${BUTTON} w-[100px] bg-card`} onClick={onDismissSaved}>
            Đóng
          </Button>
        </div>
      )}

      <div className="grid items-start gap-6 xl:grid-cols-[minmax(0,1fr)_440px]">
        <div className="flex min-w-0 flex-col gap-6">
          <section aria-labelledby="trip-seats-heading" className={CARD}>
            <div className="flex flex-col gap-1">
              <h2 id="trip-seats-heading" className={CARD_TITLE}>
                Sơ đồ ghế theo chuyến
              </h2>
              <p className={HELPER}>
                {plate
                  ? `${seatCountLabel(trip.seatCount)} lấy từ sơ đồ ghế của xe ${plate} lúc gắn xe cho chuyến.`
                  : "Chuyến chưa gắn xe nên chưa có ghế."}
              </p>
            </div>
            {trip.seats.length > 0 ? (
              <TripSeatMap seats={trip.seats} />
            ) : (
              <p className="rounded-lg border border-dashed px-4 py-6 text-center text-sm leading-5 text-muted-foreground">
                {trip.status === "DRAFT"
                  ? "Bấm “Sửa chuyến” để gắn xe. Ghế của chuyến được tạo từ sơ đồ ghế của xe."
                  : "Chuyến này không có ghế."}
              </p>
            )}
          </section>

          <section aria-labelledby="trip-schedule-heading" className={CARD}>
            <div className="flex flex-col gap-1">
              <h2 id="trip-schedule-heading" className={CARD_TITLE}>
                Lịch trình
              </h2>
              <p className={HELPER}>Giờ dự kiến tại từng điểm dừng, chép từ tuyến lúc lưu chuyến.</p>
            </div>
            <ol aria-label="Điểm dừng của chuyến" className="flex flex-col gap-2">
              {trip.stops.map((stop) => (
                <TripStopRow
                  key={stop.sequence}
                  order={stop.sequence}
                  name={stop.name}
                  address={stop.address}
                  meta={stopMetaLabel(stop)}
                >
                  <StopTimeText timeMs={new Date(stop.plannedAt).getTime()} />
                </TripStopRow>
              ))}
            </ol>
          </section>
        </div>

        <section aria-labelledby="trip-info-heading" className={`${CARD} gap-3.5`}>
          <h2 id="trip-info-heading" className={CARD_TITLE}>
            Thông tin chuyến
          </h2>
          <dl className="flex flex-col gap-3.5">
            <InfoRow label="Tuyến" value={trip.routeName} />
            <InfoRow label="Khởi hành" value={`${formatTime(trip.departureAt)} · ${formatWeekdayDate(trip.departureAt)}`} />
            <InfoRow
              label="Đến"
              value={`${formatTime(trip.arrivalAt)} · ${arrivalNote === "Cùng ngày" ? "cùng ngày" : arrivalNote}`}
            />
            <InfoRow label="Thời lượng" value={tripDurationLabel(trip.departureAt, trip.arrivalAt)} />
            <InfoRow label="Xe" value={plate ?? "Chưa gắn xe"} />
            <InfoRow label="Số chỗ" value={seatCountLabel(trip.seatCount)} />
            <InfoRow label="Ghi chú" value={trip.note ?? "Không có"} />
            <InfoRow label="Cập nhật lần cuối" value={formatDateTime(trip.updatedAt)} />
          </dl>
        </section>
      </div>
    </Shell>
  );
}

function Shell({ children }: { children: ReactNode }) {
  return (
    <div className="flex flex-col gap-6">
      <Link
        href="/trips"
        className="flex w-fit items-center gap-1.5 rounded text-sm leading-5 font-medium text-muted-foreground outline-none hover:text-vxn-fg-1 focus-visible:ring-[3px] focus-visible:ring-ring/50"
      >
        <ArrowLeft className="size-[18px]" />
        Danh sách chuyến
      </Link>
      {children}
    </div>
  );
}

function InfoRow({ label, value }: { label: string; value: string }) {
  return (
    <div className="flex items-start gap-3">
      <dt className="w-[150px] shrink-0 text-sm leading-5 text-muted-foreground">{label}</dt>
      <dd className="min-w-0 flex-1 text-right text-sm leading-5 font-semibold break-words text-vxn-ink">{value}</dd>
    </div>
  );
}

function StatePanel({
  icon,
  title,
  description,
  action
}: {
  icon: ReactNode;
  title: string;
  description: string;
  action: ReactNode;
}) {
  return (
    <div className="flex min-h-[440px] flex-col items-center justify-center gap-3 rounded-xl border bg-card px-4 text-center">
      {icon}
      <p className="text-base leading-6 font-semibold text-vxn-ink">{title}</p>
      <p className="max-w-md text-sm leading-5 text-muted-foreground">{description}</p>
      {action}
    </div>
  );
}
