"use client";

import { useInfiniteQuery } from "@tanstack/react-query";
import { Badge } from "@vexenhanh/ui/components/badge";
import { Button } from "@vexenhanh/ui/components/button";
import { ArrowUpRight, CircleAlert, FileX2, MapPin, Pencil, Plus, RefreshCw } from "lucide-react";
import Link from "next/link";
import { useMemo, useState, type ReactNode } from "react";

import { listRoutes, type RouteStatus, type RouteSummary } from "../../lib/route/route-api";
import {
  formatDistance,
  formatDuration,
  ROUTE_STATUS,
  ROUTE_STATUS_ORDER,
  stopCountLabel
} from "../../lib/route/route-format";
import { formatDate } from "../../lib/stop-point/stop-point-format";
import { BUTTON, ListFooterNote, ListLoadMoreFooter, ListStatePanel } from "../list-parts";
import { PageHeader } from "../page-header";
import {
  ALL,
  FilterSelect,
  TABLE,
  TABLE_CELL,
  TABLE_HEAD_CELL,
  TABLE_HEAD_ROW,
  TableSkeleton
} from "../stop-point/list-controls";

/** Màn danh sách tuyến của nhà xe (Figma "01 · Tuyến đường / Danh sách"; FR-OPS-04, UC-13). */
export function RouteList() {
  const [status, setStatus] = useState<string>(ALL);

  const routes = useInfiniteQuery({
    queryKey: ["routes", status],
    queryFn: ({ pageParam }) =>
      listRoutes({ status: status === ALL ? undefined : (status as RouteStatus), cursor: pageParam }),
    initialPageParam: undefined as string | undefined,
    getNextPageParam: (lastPage) => lastPage.nextCursor ?? undefined
  });
  const items = useMemo(() => routes.data?.pages.flatMap((page) => page.items) ?? [], [routes.data]);
  const filtered = status !== ALL;

  let subtitle: string;
  let body: ReactNode;
  let footer: ReactNode = null;
  // Lỗi khi tải thêm KHÔNG thuộc nhánh này: các tuyến đã tải vẫn được giữ lại (xem chân bảng).
  if (routes.isError && !routes.data) {
    subtitle = "Chưa tải được dữ liệu";
    body = (
      <ListStatePanel
        icon={<CircleAlert className="size-6 text-warning-700" />}
        title="Không tải được tuyến"
        description="Kiểm tra kết nối mạng rồi thử lại."
        action={
          <Button className={`${BUTTON} w-36`} onClick={() => void routes.refetch()}>
            <RefreshCw className="size-[18px]" />
            Thử lại
          </Button>
        }
      />
    );
  } else if (routes.isPending) {
    subtitle = "Đang tải tuyến…";
    body = <TableSkeleton label="Đang tải danh sách tuyến" />;
    footer = <ListFooterNote>Đang tải danh sách tuyến…</ListFooterNote>;
  } else if (items.length === 0) {
    subtitle = filtered ? "Không có tuyến ở trạng thái này" : "Nhà xe chưa có tuyến";
    body = filtered ? (
      <ListStatePanel
        icon={<FileX2 className="size-6 text-vxn-fg-3" />}
        title="Không có tuyến ở trạng thái này"
        description="Chọn trạng thái khác hoặc bỏ lọc để xem toàn bộ tuyến."
        action={
          <Button variant="outline" className={`${BUTTON} bg-card`} onClick={() => setStatus(ALL)}>
            Bỏ lọc
          </Button>
        }
      />
    ) : (
      <ListStatePanel
        icon={<FileX2 className="size-6 text-vxn-fg-3" />}
        title="Lập tuyến đầu tiên"
        description="Chọn các điểm dừng theo thứ tự hành trình. Quãng đường và thời gian được tính tự động khi lưu."
        action={
          <Button asChild className={`${BUTTON} w-[180px]`}>
            <Link href="/routes/new">
              <Plus className="size-[18px]" />
              Thêm tuyến
            </Link>
          </Button>
        }
      />
    );
  } else {
    subtitle = `Đang hiển thị ${items.length} tuyến`;
    body = <RouteTable items={items} />;
    footer = (
      <ListLoadMoreFooter
        hasMore={routes.hasNextPage}
        loading={routes.isFetchingNextPage}
        failed={routes.isFetchNextPageError}
        loadedText={`Đã tải ${items.length} tuyến`}
        endText={`Đã hiển thị tất cả ${items.length} tuyến`}
        errorText="Chưa tải thêm được tuyến. Các tuyến đã tải vẫn được giữ lại."
        onLoadMore={() => void routes.fetchNextPage()}
      />
    );
  }

  return (
    <div className="flex flex-col gap-6">
      <PageHeader
        title="Tuyến đường"
        description="Lập tuyến từ các điểm dừng theo thứ tự hành trình. Quãng đường và thời gian được tính tự động khi lưu."
        actions={
          <Button asChild className={`${BUTTON} w-40`}>
            <Link href="/routes/new">
              <Plus className="size-[18px]" />
              Thêm tuyến
            </Link>
          </Button>
        }
      />

      <section aria-labelledby="route-list-heading" className="flex flex-col rounded-xl border bg-card p-6">
        <div className="flex flex-wrap items-end gap-x-5 gap-y-3 pb-5">
          <div className="flex min-w-0 flex-1 flex-col gap-1">
            <h2 id="route-list-heading" className="text-base leading-6 font-semibold text-vxn-ink">
              Danh sách tuyến
            </h2>
            <p className="text-xs leading-[18px] text-muted-foreground" aria-live="polite">
              {subtitle}
            </p>
          </div>
          <FilterSelect
            label="Trạng thái"
            allLabel="Tất cả trạng thái"
            value={status}
            onChange={setStatus}
            options={ROUTE_STATUS_ORDER.map((value) => ({ value, label: ROUTE_STATUS[value].label }))}
            className="w-56"
          />
        </div>
        <div className="min-h-[504px]">{body}</div>
        {footer && <div className="flex min-h-20 flex-wrap items-center gap-3 py-5">{footer}</div>}
      </section>

      <div className="flex flex-wrap items-center gap-x-4 gap-y-2 rounded-lg bg-accent px-5 py-3.5">
        <MapPin className="size-5 shrink-0 text-vxn-teal-700" />
        <p className="min-w-0 flex-1 text-sm leading-5 text-vxn-teal-700">
          Tuyến cần ít nhất 2 điểm dừng. Tạo văn phòng trung chuyển, trạm dừng nghỉ ở mục Điểm dừng trước khi lập
          tuyến.
        </p>
        <Button asChild variant="ghost" className={`${BUTTON} text-vxn-fg-1 hover:bg-vxn-teal-100`}>
          <Link href="/stop-points">
            <ArrowUpRight className="size-[18px]" />
            Tới Điểm dừng
          </Link>
        </Button>
      </div>
    </div>
  );
}

// Tỉ lệ cột theo Figma (tên co giãn / 290 / 110 / 110 / 130 / 120 / 100 trên bảng rộng 1088).
const COLUMNS = ["", "w-[26.6%]", "w-[10%]", "w-[10%]", "w-[12%]", "w-[11%]", "w-28"];
const HEADINGS = ["Tên tuyến", "Điểm đầu → Điểm cuối", "Số điểm dừng", "Quãng đường", "Thời gian chạy", "Trạng thái", "Thao tác"];

function RouteTable({ items }: { items: RouteSummary[] }) {
  return (
    <div className="overflow-x-auto">
      <table className={`${TABLE} min-w-[980px]`}>
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
          {items.map((route) => {
            const state = ROUTE_STATUS[route.status];
            const inactive = route.status === "INACTIVE";
            return (
              <tr key={route.id} className="h-[76px] border-b">
                <td className={TABLE_CELL}>
                  <div className="flex flex-col gap-1">
                    <span className={`truncate font-semibold ${inactive ? "text-muted-foreground" : "text-vxn-teal-700"}`}>
                      {route.name}
                    </span>
                    <span className="text-xs leading-[18px] text-muted-foreground">
                      Cập nhật {formatDate(route.updatedAt)}
                    </span>
                  </div>
                </td>
                <td className={TABLE_CELL}>
                  <div className={`flex flex-col gap-1 text-xs leading-[18px] ${inactive ? "text-muted-foreground" : ""}`}>
                    <Endpoint dot="bg-primary" label="Điểm đầu" name={route.originName} />
                    <Endpoint dot="bg-vxn-saffron-500" label="Điểm cuối" name={route.destinationName} />
                  </div>
                </td>
                <td className={TABLE_CELL}>{stopCountLabel(route.stopCount)}</td>
                <td className={TABLE_CELL}>
                  {formatDistance(route.totalDistanceMeters)}
                  {/* Môi trường chưa có khóa Goong: số liệu chỉ là ước lượng đường chim bay. */}
                  {route.metricsSource === "ESTIMATE" && (
                    <span className="block text-xs leading-[18px] text-muted-foreground">Ước lượng</span>
                  )}
                </td>
                <td className={TABLE_CELL}>{formatDuration(route.totalDurationSeconds)}</td>
                <td className={TABLE_CELL}>
                  <Badge tone={state.tone}>{state.label}</Badge>
                </td>
                <td className={TABLE_CELL}>
                  <Button asChild variant="ghost" className={`${BUTTON} w-24 text-vxn-fg-1`}>
                    <Link href={`/routes/${route.id}`} aria-label={`Sửa tuyến ${route.name}`}>
                      <Pencil className="size-[18px]" />
                      Sửa
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

function Endpoint({ dot, label, name }: { dot: string; label: string; name: string }) {
  return (
    <span className="flex items-center gap-2">
      <span className={`size-2 shrink-0 rounded-full ${dot}`} aria-hidden />
      <span className="sr-only">{label}: </span>
      <span className="truncate">{name}</span>
    </span>
  );
}
