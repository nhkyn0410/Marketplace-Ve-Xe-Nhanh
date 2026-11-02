"use client";

import { useInfiniteQuery, useQuery } from "@tanstack/react-query";
import { useCan } from "@vexenhanh/ui/components/auth/auth-context";
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
import { CircleAlert, Route as RouteIcon, RefreshCw } from "lucide-react";
import Link from "next/link";
import { useMemo, useState, type ReactNode } from "react";

import { listRoutes, type AdminRoute, type RouteSort } from "../../lib/operation/operation-api";
import { count, distanceLabel, fillLabel, provincePair, ratingLabel, ROUTE_SORT_LABEL, ROUTE_STATUS } from "../../lib/operation/operation-format";
import { formatVnd } from "../../lib/payment/payment-format";
import { listOperatorOptions } from "../../lib/report/report-api";
import { lastDays, validRange } from "../../lib/report/report-format";
import { listProvinces } from "../../lib/stop-point/stop-point-api";
import { PeriodFields } from "./period-fields";

/**
 * Danh sách tuyến của mọi nhà xe kèm hiệu suất theo kỳ (tự thiết kế 28/10/2026, chờ duyệt; FR-NSR-13): lọc nhà xe / tỉnh đi
 * – đến / trạng thái / tên, kỳ mặc định 30 ngày, xếp theo vé bán để thấy tuyến phổ biến. Doanh thu chỉ hiện khi có quyền
 * xem thanh toán. `operatorId` cố định = danh sách trong trang chi tiết nhà xe (ẩn ô lọc nhà xe).
 */
export function RouteList({ operatorId }: { operatorId?: string }) {
  const can = useCan();
  const showMoney = can("payment:monitor");
  const [search, setSearch] = useState("");
  const [operator, setOperator] = useState<string>(ALL);
  const [origin, setOrigin] = useState<string>(ALL);
  const [destination, setDestination] = useState<string>(ALL);
  const [status, setStatus] = useState<string>(ALL);
  const [sort, setSort] = useState<RouteSort>("sold");
  const [period, setPeriod] = useState(() => lastDays(30));
  const q = useDebouncedValue(search.trim());
  const periodOk = validRange(period.from, period.to);
  const filters = useMemo(
    () => ({
      q: q || undefined,
      operatorId: operatorId ?? (operator === ALL ? undefined : operator),
      originProvinceId: origin === ALL ? undefined : origin,
      destinationProvinceId: destination === ALL ? undefined : destination,
      status: status === ALL ? undefined : status,
      sort,
      ...period
    }),
    [q, operatorId, operator, origin, destination, status, sort, period]
  );
  const pages = useInfiniteQuery({
    queryKey: ["admin-routes", filters],
    queryFn: ({ pageParam }) => listRoutes(filters, pageParam),
    initialPageParam: null as string | null,
    getNextPageParam: (last) => last.nextCursor,
    enabled: periodOk
  });
  const provinces = useQuery({ queryKey: ["catalog", "provinces"], queryFn: listProvinces, staleTime: 300_000 });
  const operators = useQuery({ queryKey: ["admin-report", "operators"], queryFn: listOperatorOptions, enabled: !operatorId });
  const rows = pages.data?.pages.flatMap((page) => page.items) ?? [];
  const total = pages.data?.pages[0]?.total ?? 0;
  const provinceOptions = (provinces.data ?? []).map((province) => ({ value: province.id, label: province.name }));
  const filtered = q !== "" || operator !== ALL || origin !== ALL || destination !== ALL || status !== ALL;

  let body: ReactNode;
  let footer: ReactNode = null;
  if (!periodOk) {
    body = <ListStatePanel icon={<CircleAlert className="size-6 text-warning-700" />} title="Kỳ không hợp lệ" description="Ngày bắt đầu không sau ngày kết thúc, tối đa 366 ngày." />;
  } else if (pages.isError && rows.length === 0) {
    body = (
      <ListStatePanel
        icon={<CircleAlert className="size-6 text-warning-700" />}
        title="Không tải được tuyến"
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
    body = <TableSkeleton label="Đang tải tuyến" />;
  } else if (rows.length === 0) {
    body = (
      <ListStatePanel
        icon={<RouteIcon className="size-6 text-vxn-fg-3" />}
        title={filtered ? "Không có tuyến phù hợp" : "Chưa có tuyến nào"}
        description={filtered ? "Đổi bộ lọc hoặc từ khóa." : "Tuyến xuất hiện ở đây khi nhà xe tạo tuyến ở Operator OS."}
      />
    );
  } else {
    body = <RouteTable rows={rows} showMoney={showMoney} showOperator={!operatorId} />;
    footer = (
      <ListLoadMoreFooter
        hasMore={pages.hasNextPage}
        loading={pages.isFetchingNextPage}
        failed={pages.isFetchNextPageError}
        loadedText={`Đã tải ${rows.length} / ${count(total)} tuyến`}
        endText={`Đã hiện tất cả ${rows.length} tuyến`}
        errorText="Không tải thêm được tuyến. Kiểm tra kết nối rồi thử lại."
        onLoadMore={() => void pages.fetchNextPage()}
      />
    );
  }

  return (
    <section aria-label="Danh sách tuyến" className="flex flex-col rounded-xl border bg-card p-6">
      <div className="flex flex-wrap items-end gap-x-4 gap-y-3 pb-5">
        <SearchField label="Tìm tuyến" placeholder="Tên tuyến" value={search} onChange={setSearch} />
        {!operatorId && (
          <FilterSelect label="Nhà xe" allLabel="Tất cả nhà xe" value={operator} onChange={setOperator} options={operators.data ?? []} className="w-56" />
        )}
        <FilterSelect label="Tỉnh đi" allLabel="Tất cả" value={origin} onChange={setOrigin} options={provinceOptions} disabled={!provinces.data} className="w-48" />
        <FilterSelect label="Tỉnh đến" allLabel="Tất cả" value={destination} onChange={setDestination} options={provinceOptions} disabled={!provinces.data} className="w-48" />
        <FilterSelect
          label="Trạng thái"
          allLabel="Tất cả"
          value={status}
          onChange={setStatus}
          options={Object.entries(ROUTE_STATUS).map(([value, item]) => ({ value, label: item.label }))}
          className="w-40"
        />
        <PeriodFields value={period} onChange={setPeriod} />
        <FilterSelect
          label="Xếp theo"
          allLabel={ROUTE_SORT_LABEL.sold!}
          value={sort === "sold" ? ALL : sort}
          onChange={(value) => setSort(value === ALL ? "sold" : (value as RouteSort))}
          options={(["revenue", "trips", "fill", "name"] as RouteSort[])
            .filter((value) => value !== "revenue" || showMoney)
            .map((value) => ({ value, label: ROUTE_SORT_LABEL[value]! }))}
          className="w-52"
        />
      </div>
      <div className="min-h-[320px]">{body}</div>
      {footer && <div className="flex min-h-14 items-center pt-5">{footer}</div>}
      <p className="pt-3 text-xs leading-[18px] text-muted-foreground">
        Số liệu tính trên chuyến khởi hành trong kỳ (trừ chuyến nháp); vé bán = vé còn đi chuyến, chưa hủy / hoàn. Đánh giá tính
        trên mọi chuyến của tuyến.
      </p>
    </section>
  );
}

function RouteTable({ rows, showMoney, showOperator }: { rows: AdminRoute[]; showMoney: boolean; showOperator: boolean }) {
  const headings = ["Tuyến", "Quãng đường", "Chuyến", "Vé bán", "Lấp đầy", ...(showMoney ? ["Doanh thu vé"] : []), "Đánh giá", "Sắp chạy"];
  return (
    <div className="relative overflow-x-auto">
      <table className={`${TABLE} min-w-[980px]`}>
        <thead>
          <tr className={TABLE_HEAD_ROW}>
            {headings.map((heading, index) => (
              <th key={heading} scope="col" className={`${TABLE_HEAD_CELL} ${index === 0 ? "w-[32%]" : "text-right"}`}>
                {heading}
              </th>
            ))}
          </tr>
        </thead>
        <tbody>
          {rows.map((row) => {
            const status = ROUTE_STATUS[row.status];
            return (
              <tr key={row.id} className="h-[72px] border-b hover:bg-muted/50">
                <td className={TABLE_CELL}>
                  <div className="flex min-w-0 flex-col gap-0.5">
                    <span className="flex min-w-0 items-center gap-2">
                      <Link href={`/routes/${row.id}`} className="truncate font-semibold text-vxn-ink hover:text-primary hover:underline">
                        {row.name}
                      </Link>
                      {row.status !== "ACTIVE" && status && <Badge tone={status.tone}>{status.label}</Badge>}
                    </span>
                    <span className="truncate text-xs leading-[18px] text-muted-foreground">
                      {[showOperator ? row.operatorName : null, provincePair(row.origin, row.destination)].filter(Boolean).join(" · ")}
                    </span>
                  </div>
                </td>
                <td className={`${TABLE_CELL} text-right`}>
                  <div className="flex flex-col">
                    <span>{distanceLabel(row.distanceMeters)}</span>
                    <span className="text-xs leading-[18px] text-muted-foreground">{row.stopCount} điểm dừng</span>
                  </div>
                </td>
                <td className={`${TABLE_CELL} text-right tabular-nums`}>{count(row.trips)}</td>
                <td className={`${TABLE_CELL} text-right font-semibold tabular-nums`}>{count(row.ticketsSold)}</td>
                <td className={`${TABLE_CELL} text-right tabular-nums`}>{fillLabel(row.ticketsSold, row.seats)}</td>
                {showMoney && <td className={`${TABLE_CELL} text-right tabular-nums`}>{row.ticketRevenue === null ? "—" : formatVnd(row.ticketRevenue)}</td>}
                <td className={`${TABLE_CELL} text-right tabular-nums`}>{ratingLabel(row.averageRating, row.reviewCount)}</td>
                <td className={`${TABLE_CELL} text-right tabular-nums`}>{count(row.upcomingTrips)}</td>
              </tr>
            );
          })}
        </tbody>
      </table>
    </div>
  );
}
