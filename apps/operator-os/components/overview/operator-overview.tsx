"use client";

import { useQuery } from "@tanstack/react-query";
import { Badge } from "@vexenhanh/ui/components/badge";
import { Button } from "@vexenhanh/ui/components/button";
import { Skeleton } from "@vexenhanh/ui/components/skeleton";
import { BusFront, ChevronRight, CircleAlert, RefreshCw } from "lucide-react";
import Link from "next/link";
import type { ReactNode } from "react";

import { shortMoment } from "../../lib/booking/booking-format";
import { formatVnd } from "../../lib/fare/fare-format";
import { getOperatorOverview, type OperatorOverview as Overview } from "../../lib/report/report-api";
import { countLabel, percentLabel } from "../../lib/report/report-format";
import { TRIP_STATUS } from "../../lib/trip/trip-format";
import { formatPlateNumber } from "../../lib/vehicle/vehicle-format";
import { BUTTON, ListStatePanel } from "../list-parts";
import { PageHeader } from "../page-header";
import { TABLE, TABLE_CELL, TABLE_HEAD_CELL, TABLE_HEAD_ROW, TableSkeleton } from "../stop-point/list-controls";

/**
 * Tổng quan Operator OS (TASK-RPT-001; Figma chưa có khung riêng — bố cục theo thẻ chỉ số + bảng của màn Báo cáo): chuyến hôm nay,
 * 7 ngày tới, doanh thu tháng này, việc cần chú ý (chuyến sắp chạy chưa có tài xế, chuyến nháp, đơn chờ hoàn) và chuyến sắp chạy.
 */
export function OperatorOverview() {
  const overview = useQuery({ queryKey: ["operator-overview"], queryFn: getOperatorOverview });
  const data = overview.data;

  if (overview.isError && !data) {
    return (
      <div className="flex flex-col gap-6">
        <Header />
        <ListStatePanel
          icon={<CircleAlert className="size-6 text-warning-700" />}
          title="Không tải được tổng quan"
          description="Không kết nối được máy chủ. Vui lòng kiểm tra kết nối và thử lại."
          action={
            <Button variant="outline" className={`${BUTTON} bg-card`} onClick={() => void overview.refetch()}>
              <RefreshCw className="size-[18px]" />
              Thử lại
            </Button>
          }
        />
      </div>
    );
  }

  return (
    <div className="flex flex-col gap-6">
      <Header />
      <div className="grid gap-4 sm:grid-cols-2 xl:grid-cols-4">
        <Stat label="Chuyến hôm nay" value={data && countLabel(data.today.trips)} note={data && `${countLabel(data.today.running)} chuyến đang chạy`} />
        <Stat label="Vé bán cho hôm nay" value={data && countLabel(data.today.ticketsSold)} note={data && `Lấp đầy ${percentLabel(data.today.ticketsSold, data.today.seats)}`} />
        <Stat label="7 ngày tới" value={data && `${countLabel(data.nextWeek.trips)} chuyến`} note={data && `${countLabel(data.nextWeek.ticketsSold)} / ${countLabel(data.nextWeek.seats)} chỗ đã bán`} />
        <Stat label="Doanh thu gộp tháng này" value={data && formatVnd(data.month.grossRevenue)} note={data && `${countLabel(data.month.ticketsSold)} vé · ${countLabel(data.month.completedTrips)} chuyến đã chạy`} />
      </div>
      <div className="grid gap-6 xl:grid-cols-[minmax(0,1fr)_360px]">
        <Panel title="Chuyến sắp chạy" action={<PanelLink href="/trips">Xem tất cả chuyến</PanelLink>}>
          {!data ? <TableSkeleton label="Đang tải chuyến sắp chạy" rows={4} /> : <UpcomingTable trips={data.upcoming} />}
        </Panel>
        <Panel title="Cần chú ý">
          {!data ? (
            <div className="flex flex-col gap-3">
              {[0, 1, 2].map((index) => (
                <Skeleton key={index} className="h-14 w-full" />
              ))}
            </div>
          ) : (
            <Attention attention={data.attention} />
          )}
        </Panel>
      </div>
    </div>
  );
}

function Header() {
  return <PageHeader title="Tổng quan" description="Tình hình vận hành và bán vé của nhà xe hôm nay và những ngày tới." />;
}

function UpcomingTable({ trips }: { trips: Overview["upcoming"] }) {
  if (trips.length === 0) {
    return <ListStatePanel icon={<BusFront className="size-6 text-vxn-fg-3" />} title="Chưa có chuyến sắp chạy" description="Chuyến đã mở bán hoặc đang chạy hiện ở đây theo giờ khởi hành." compact />;
  }
  return (
    <div className="overflow-x-auto">
      <table className={`${TABLE} min-w-[700px]`}>
        <thead>
          <tr className={TABLE_HEAD_ROW}>
            <th scope="col" className={`${TABLE_HEAD_CELL} w-[15%]`}>
              Khởi hành
            </th>
            <th scope="col" className={`${TABLE_HEAD_CELL} w-[31%]`}>
              Tuyến
            </th>
            <th scope="col" className={`${TABLE_HEAD_CELL} w-[19%]`}>
              Tài xế
            </th>
            <th scope="col" className={`${TABLE_HEAD_CELL} w-[11%] text-right`}>
              Vé bán
            </th>
            <th scope="col" className={`${TABLE_HEAD_CELL} w-[24%] pl-4`}>
              Trạng thái
            </th>
          </tr>
        </thead>
        <tbody>
          {trips.map((trip) => (
            <tr key={trip.tripId} className="border-b last:border-b-0">
              <td className={`${TABLE_CELL} tabular-nums`}>{shortMoment(trip.departureAt)}</td>
              <td className={TABLE_CELL}>
                <Link href={`/trips/${trip.tripId}`} className="block truncate font-semibold text-vxn-ink hover:underline">
                  {trip.routeName}
                </Link>
                <p className="text-xs leading-[18px] text-muted-foreground">{trip.vehiclePlateNumber ? formatPlateNumber(trip.vehiclePlateNumber) : "Chưa gắn xe"}</p>
              </td>
              <td className={`${TABLE_CELL} truncate`}>{trip.driverName ?? <span className="text-warning-700">Chưa phân công</span>}</td>
              <td className={`${TABLE_CELL} text-right tabular-nums`}>
                {trip.ticketsSold} / {trip.seats}
              </td>
              <td className={`${TABLE_CELL} pl-4`}>
                <Badge tone={TRIP_STATUS[trip.status].tone}>{TRIP_STATUS[trip.status].label}</Badge>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}

function Attention({ attention }: { attention: Overview["attention"] }) {
  const items = [
    { count: attention.tripsWithoutDriver, label: "chuyến trong 48 giờ tới chưa có tài xế", href: "/trips" },
    { count: attention.draftTrips, label: "chuyến nháp khởi hành trong 7 ngày tới", href: "/trips" },
    { count: attention.pendingRefunds, label: "đơn đang chờ hoàn tiền", href: "/bookings" }
  ];
  if (items.every((item) => item.count === 0)) {
    return <p className="rounded-lg bg-accent px-4 py-3 text-sm leading-5 text-vxn-teal-700">Không có việc cần xử lý.</p>;
  }
  return (
    <ul className="flex flex-col gap-3">
      {items
        .filter((item) => item.count > 0)
        .map((item) => (
          <li key={item.label}>
            <Link href={item.href} className="flex items-center gap-3 rounded-lg border px-4 py-3 text-sm leading-5 hover:bg-muted">
              <span className="text-lg leading-7 font-semibold text-warning-700 tabular-nums">{item.count}</span>
              <span className="flex-1 text-vxn-fg-1">{item.label}</span>
              <ChevronRight className="size-4 text-muted-foreground" aria-hidden />
            </Link>
          </li>
        ))}
    </ul>
  );
}

function Stat({ label, value, note }: { label: string; value: string | undefined; note: string | undefined }) {
  return (
    <div className="flex flex-col gap-1.5 rounded-xl border bg-card p-5">
      <p className="text-sm leading-5 text-muted-foreground">{label}</p>
      {value === undefined ? <Skeleton className="h-9 w-40" /> : <p className="text-[28px] leading-9 font-semibold text-vxn-ink tabular-nums">{value}</p>}
      <p className="text-xs leading-[18px] text-muted-foreground">{note ?? " "}</p>
    </div>
  );
}

function Panel({ title, action, children }: { title: string; action?: ReactNode; children: ReactNode }) {
  return (
    <section aria-label={title} className="flex min-w-0 flex-col gap-5 rounded-xl border bg-card p-6">
      <div className="flex items-center justify-between gap-3">
        <h2 className="text-lg leading-7 font-semibold text-vxn-ink">{title}</h2>
        {action}
      </div>
      {children}
    </section>
  );
}

function PanelLink({ href, children }: { href: string; children: ReactNode }) {
  return (
    <Link href={href} className="text-sm leading-5 font-semibold text-primary hover:underline">
      {children}
    </Link>
  );
}
