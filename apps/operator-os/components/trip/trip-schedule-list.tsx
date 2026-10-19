"use client";

import { useQuery } from "@tanstack/react-query";
import { Badge } from "@vexenhanh/ui/components/badge";
import { Button } from "@vexenhanh/ui/components/button";
import { ArrowLeft, CalendarSync, ChevronRight, CircleAlert, Plus, RefreshCw } from "lucide-react";
import Link from "next/link";
import { useRouter } from "next/navigation";

import { listTripSchedules, type TripSchedule } from "../../lib/trip/trip-schedule-api";
import {
  formatDateOnly,
  scheduleDurationLabel,
  scheduleState,
  weekdaysLabel
} from "../../lib/trip/trip-schedule-form";
import { todayLocalDate } from "../../lib/trip/trip-format";
import { formatPlateNumber } from "../../lib/vehicle/vehicle-format";
import { BUTTON, ListFooterNote, ListStatePanel } from "../list-parts";
import { PageHeader } from "../page-header";
import { TABLE, TABLE_CELL, TABLE_HEAD_CELL, TABLE_HEAD_ROW, TableSkeleton } from "../stop-point/list-controls";

const COLUMNS = ["", "w-[10%]", "w-[13%]", "w-[14%]", "w-[13%]", "w-[9%]", "w-[11%]", "w-24"];
const HEADINGS = ["Tuyến", "Giờ chạy", "Ngày chạy", "Áp dụng", "Xe", "Đã sinh", "Trạng thái", "Thao tác"];

/**
 * Màn Lịch chạy lặp lại (TASK-TRN-007, FR-OPS-07 — chưa có khung Figma, dựng theo bộ kit màn Chuyến xe): mỗi lịch là quy
 * tắc thứ chạy + giờ chạy + khoảng ngày; mở lịch để sinh chuyến nháp.
 */
export function TripScheduleList() {
  const schedules = useQuery({ queryKey: ["trip-schedules"], queryFn: listTripSchedules });
  const today = todayLocalDate();

  let body;
  if (schedules.isPending) {
    body = <TableSkeleton label="Đang tải lịch chạy" rows={4} />;
  } else if (schedules.isError) {
    body = (
      <ListStatePanel
        icon={<CircleAlert className="size-6 text-warning-700" />}
        title="Không tải được lịch chạy"
        description="Không kết nối được máy chủ. Vui lòng kiểm tra kết nối và thử lại."
        action={
          <Button variant="outline" className={`${BUTTON} bg-card`} onClick={() => void schedules.refetch()}>
            <RefreshCw className="size-[18px]" />
            Thử lại
          </Button>
        }
      />
    );
  } else if (schedules.data.length === 0) {
    body = (
      <ListStatePanel
        icon={<CalendarSync className="size-6 text-vxn-fg-3" />}
        title="Chưa có lịch chạy lặp lại"
        description="Tuyến chạy cố định theo giờ? Lập lịch một lần (thứ chạy, giờ chạy, khoảng ngày) rồi sinh chuyến nháp cho cả khoảng ngày thay vì tạo từng chuyến."
        action={
          <Button asChild className={`${BUTTON} w-[180px]`}>
            <Link href="/trips/schedules/new">
              <Plus className="size-[18px]" />
              Tạo lịch
            </Link>
          </Button>
        }
      />
    );
  } else {
    body = <ScheduleTable items={schedules.data} today={today} />;
  }

  return (
    <div className="flex flex-col gap-6">
      <Link href="/trips" className="flex w-fit items-center gap-2 text-sm leading-5 font-medium text-vxn-teal-700 hover:underline">
        <ArrowLeft className="size-4" />
        Về danh sách chuyến
      </Link>
      <PageHeader
        title="Lịch chạy lặp lại"
        description="Lập quy tắc chạy theo thứ trong tuần rồi sinh chuyến nháp cho cả khoảng ngày. Chuyến sinh ra sửa, mở bán như chuyến tạo tay."
        actions={
          <Button asChild className={`${BUTTON} w-40`}>
            <Link href="/trips/schedules/new">
              <Plus className="size-[18px]" />
              Tạo lịch
            </Link>
          </Button>
        }
      />
      <section aria-label="Danh sách lịch chạy" className="flex flex-col rounded-xl border bg-card p-6">
        {body}
        {schedules.data && schedules.data.length > 0 && (
          <div className="flex pt-5">
            <ListFooterNote>
              {schedules.data.length} lịch · lịch hết hạn vẫn giữ để tra cứu; muốn chạy tiếp thì sửa ngày kết thúc hoặc tạo lịch mới.
            </ListFooterNote>
          </div>
        )}
      </section>
    </div>
  );
}

function ScheduleTable({ items, today }: { items: TripSchedule[]; today: string }) {
  const router = useRouter();
  return (
    <div className="overflow-x-auto">
      <table className={`${TABLE} min-w-[1040px]`}>
        <colgroup>
          {COLUMNS.map((width, index) => (
            <col key={index} className={width} />
          ))}
        </colgroup>
        <thead>
          <tr className={TABLE_HEAD_ROW}>
            {HEADINGS.map((heading) => (
              <th key={heading} scope="col" className={TABLE_HEAD_CELL}>
                {heading}
              </th>
            ))}
          </tr>
        </thead>
        <tbody>
          {items.map((schedule) => {
            const state = scheduleState(schedule, today);
            return (
              <tr
                key={schedule.id}
                className="h-[71px] cursor-pointer border-b hover:bg-muted/50"
                onClick={(event) => {
                  if (!(event.target as Element).closest("a, button")) {
                    router.push(`/trips/schedules/${schedule.id}`);
                  }
                }}
              >
                <td className={TABLE_CELL}>
                  <TwoLines first={schedule.routeName} second={scheduleDurationLabel(schedule.durationMinutes)} />
                </td>
                <td className={TABLE_CELL}>
                  <TwoLines first={schedule.departureTime} second="Giờ khởi hành" />
                </td>
                <td className={TABLE_CELL}>
                  <span className="font-semibold text-vxn-ink">{weekdaysLabel(schedule.daysOfWeek)}</span>
                </td>
                <td className={TABLE_CELL}>
                  <TwoLines first={formatDateOnly(schedule.startDate)} second={`đến ${formatDateOnly(schedule.endDate)}`} />
                </td>
                <td className={TABLE_CELL}>
                  {schedule.vehiclePlateNumber ? (
                    <span className="font-semibold text-vxn-ink">{formatPlateNumber(schedule.vehiclePlateNumber)}</span>
                  ) : (
                    <TwoLines first="Chưa gắn xe" second="Gắn ở từng chuyến" />
                  )}
                </td>
                <td className={TABLE_CELL}>{schedule.tripCount} chuyến</td>
                <td className={TABLE_CELL}>
                  <Badge tone={state.tone}>{state.label}</Badge>
                </td>
                <td className={TABLE_CELL}>
                  <Button asChild variant="ghost" className={`${BUTTON} w-[84px] gap-1.5 px-2 text-vxn-fg-1`}>
                    <Link
                      href={`/trips/schedules/${schedule.id}`}
                      aria-label={`Xem lịch ${schedule.routeName} ${schedule.departureTime} ${weekdaysLabel(schedule.daysOfWeek)}`}
                    >
                      Xem
                      <ChevronRight className="size-[18px]" />
                    </Link>
                  </Button>
                </td>
              </tr>
            );
          })}
        </tbody>
      </table>
    </div>
  );
}

function TwoLines({ first, second }: { first: string; second: string }) {
  return (
    <div className="flex min-w-0 flex-col gap-0.5">
      <span className="truncate font-semibold text-vxn-ink">{first}</span>
      <span className="truncate text-xs leading-[18px] text-muted-foreground">{second}</span>
    </div>
  );
}
