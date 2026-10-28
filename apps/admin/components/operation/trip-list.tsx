"use client";

import { useInfiniteQuery, useQuery } from "@tanstack/react-query";
import { Badge } from "@vexenhanh/ui/components/badge";
import { Button } from "@vexenhanh/ui/components/button";
import {
  ALL,
  FilterSelect,
  SearchField,
  TABLE,
  TABLE_CELL,
  TABLE_HEAD_CELL,
  TABLE_HEAD_ROW,
  TableSkeleton,
  useDebouncedValue
} from "@vexenhanh/ui/components/list-controls";
import { BUTTON, ListLoadMoreFooter, ListStatePanel } from "@vexenhanh/ui/components/list-parts";
import { BusFront, CircleAlert, RefreshCw } from "lucide-react";
import Link from "next/link";
import { useMemo, useState, type ReactNode } from "react";

import { listTrips, type AdminTrip } from "../../lib/operation/operation-api";
import { count, fillLabel, TRIP_STATUS, TRIP_STATUS_ORDER, tripTime } from "../../lib/operation/operation-format";
import { listOperatorOptions } from "../../lib/report/report-api";
import { vnDate } from "../../lib/report/report-format";
import { PeriodFields } from "./period-fields";

const DAY_MS = 86_400_000;
/** Kỳ tối đa như máy chủ (92 ngày). */
const MAX_DAYS = 92;

function nextDays(days: number, now: Date = new Date()): { from: string; to: string } {
  return { from: vnDate(now), to: vnDate(new Date(now.getTime() + (days - 1) * DAY_MS)) };
}

function periodOk(period: { from: string; to: string }): boolean {
  const pattern = /^\d{4}-\d{2}-\d{2}$/;
  return pattern.test(period.from) && pattern.test(period.to) && period.from <= period.to && Date.parse(period.to) - Date.parse(period.from) <= MAX_DAYS * DAY_MS;
}

/**
 * Danh sách chuyến của mọi nhà xe (tự thiết kế 28/10/2026, chờ duyệt): mặc định hôm nay + 6 ngày, lọc nhà xe / trạng thái,
 * tìm biển số hoặc tên tuyến; bấm chuyến để xem chi tiết + danh sách người đi. `operatorId` cố định = trong chi tiết nhà xe.
 */
export function TripList({ operatorId }: { operatorId?: string }) {
  const [search, setSearch] = useState("");
  const [operator, setOperator] = useState<string>(ALL);
  const [status, setStatus] = useState<string>(ALL);
  const [period, setPeriod] = useState(() => nextDays(7));
  const q = useDebouncedValue(search.trim());
  const valid = periodOk(period);
  const filters = useMemo(
    () => ({
      q: q || undefined,
      operatorId: operatorId ?? (operator === ALL ? undefined : operator),
      status: status === ALL ? undefined : status,
      ...period
    }),
    [q, operatorId, operator, status, period]
  );
  const pages = useInfiniteQuery({
    queryKey: ["admin-trips", filters],
    queryFn: ({ pageParam }) => listTrips(filters, pageParam),
    initialPageParam: null as string | null,
    getNextPageParam: (last) => last.nextCursor,
    enabled: valid
  });
  const operators = useQuery({ queryKey: ["admin-report", "operators"], queryFn: listOperatorOptions, enabled: !operatorId });
  const rows = pages.data?.pages.flatMap((page) => page.items) ?? [];
  const total = pages.data?.pages[0]?.total ?? 0;
  const filtered = q !== "" || operator !== ALL || status !== ALL;

  let body: ReactNode;
  let footer: ReactNode = null;
  if (!valid) {
    body = <ListStatePanel icon={<CircleAlert className="size-6 text-warning-700" />} title="Kỳ không hợp lệ" description="Ngày bắt đầu không sau ngày kết thúc, tối đa 92 ngày." />;
  } else if (pages.isError && rows.length === 0) {
    body = (
      <ListStatePanel
        icon={<CircleAlert className="size-6 text-warning-700" />}
        title="Không tải được chuyến"
        description="Kiểm tra kết nối mạng rồi thử lại."
        action={
          <Button className={`${BUTTON} w-36`} onClick={() => void pages.refetch()}>
            <RefreshCw className="size-[18px]" />
            Thử lại
          </Button>
        }
      />
    );
  } else if (pages.isPending) {
    body = <TableSkeleton label="Đang tải chuyến" />;
  } else if (rows.length === 0) {
    body = (
      <ListStatePanel
        icon={<BusFront className="size-6 text-vxn-fg-3" />}
        title={filtered ? "Không có chuyến phù hợp" : "Không có chuyến trong kỳ"}
        description={filtered ? "Đổi bộ lọc hoặc từ khóa." : "Đổi khoảng ngày để xem chuyến khác."}
      />
    );
  } else {
    body = <TripTable rows={rows} showOperator={!operatorId} />;
    footer = (
      <ListLoadMoreFooter
        hasMore={pages.hasNextPage}
        loading={pages.isFetchingNextPage}
        failed={pages.isFetchNextPageError}
        loadedText={`Đã tải ${rows.length} / ${count(total)} chuyến`}
        endText={`Đã hiện tất cả ${rows.length} chuyến`}
        errorText="Không tải thêm được chuyến. Kiểm tra kết nối rồi thử lại."
        onLoadMore={() => void pages.fetchNextPage()}
      />
    );
  }

  return (
    <section aria-label="Danh sách chuyến" className="flex flex-col rounded-xl border bg-card p-6">
      <div className="flex flex-wrap items-end gap-x-4 gap-y-3 pb-5">
        <SearchField label="Tìm chuyến" placeholder="Biển số xe hoặc tên tuyến" value={search} onChange={setSearch} />
        {!operatorId && (
          <FilterSelect label="Nhà xe" allLabel="Tất cả nhà xe" value={operator} onChange={setOperator} options={operators.data ?? []} className="w-56" />
        )}
        <FilterSelect
          label="Trạng thái"
          allLabel="Tất cả trạng thái"
          value={status}
          onChange={setStatus}
          options={TRIP_STATUS_ORDER.map((value) => ({ value, label: TRIP_STATUS[value]!.label }))}
          className="w-52"
        />
        <PeriodFields value={period} onChange={setPeriod} />
      </div>
      <div className="min-h-[320px]">{body}</div>
      {footer && <div className="flex min-h-14 items-center pt-5">{footer}</div>}
    </section>
  );
}

function TripTable({ rows, showOperator }: { rows: AdminTrip[]; showOperator: boolean }) {
  return (
    <div className="relative overflow-x-auto">
      <table className={`${TABLE} min-w-[880px]`}>
        <thead>
          <tr className={TABLE_HEAD_ROW}>
            {["Giờ khởi hành", "Tuyến", "Xe", "Đã bán / tổng chỗ", "Trạng thái"].map((heading, index) => (
              <th key={heading} scope="col" className={`${TABLE_HEAD_CELL} ${index === 3 ? "text-right" : ""} ${index === 1 ? "w-[34%]" : ""}`}>
                {heading}
              </th>
            ))}
          </tr>
        </thead>
        <tbody>
          {rows.map((row) => {
            const status = TRIP_STATUS[row.status] ?? { label: row.status, tone: "neutral" as const };
            return (
              <tr key={row.id} className="h-[68px] border-b hover:bg-muted/50">
                <td className={TABLE_CELL}>
                  <Link href={`/routes/trips/${row.id}`} className="font-semibold text-vxn-ink tabular-nums hover:text-primary hover:underline">
                    {tripTime(row.departureAt)}
                  </Link>
                </td>
                <td className={TABLE_CELL}>
                  <div className="flex min-w-0 flex-col gap-0.5">
                    <Link href={`/routes/${row.routeId}`} className="truncate font-medium text-vxn-ink hover:text-primary hover:underline">
                      {row.routeName}
                    </Link>
                    {showOperator && <span className="truncate text-xs leading-[18px] text-muted-foreground">{row.operatorName}</span>}
                  </div>
                </td>
                <td className={TABLE_CELL}>{row.vehiclePlate ?? "Chưa gắn xe"}</td>
                <td className={`${TABLE_CELL} text-right tabular-nums`}>
                  <div className="flex flex-col">
                    <span className="font-semibold">
                      {count(row.ticketsSold)} / {count(row.seats)}
                    </span>
                    <span className="text-xs leading-[18px] text-muted-foreground">{fillLabel(row.ticketsSold, row.seats)}</span>
                  </div>
                </td>
                <td className={TABLE_CELL}>
                  <Badge tone={status.tone}>{status.label}</Badge>
                </td>
              </tr>
            );
          })}
        </tbody>
      </table>
    </div>
  );
}
