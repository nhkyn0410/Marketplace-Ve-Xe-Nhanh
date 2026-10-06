"use client";

import { useInfiniteQuery } from "@tanstack/react-query";
import { Badge } from "@vexenhanh/ui/components/badge";
import { Button } from "@vexenhanh/ui/components/button";
import { Skeleton } from "@vexenhanh/ui/components/skeleton";
import { Armchair, CircleAlert, Copy, FileX2, Plus, RefreshCw } from "lucide-react";
import Link from "next/link";
import { useMemo, type ReactNode } from "react";

import { listSeatMaps, type SeatMapSummary } from "../../lib/vehicle/vehicle-api";
import { BUTTON, ListFooterNote, ListLoadMoreFooter, ListStatePanel } from "../list-parts";
import { PageHeader } from "../page-header";

const UPDATED_AT = new Intl.DateTimeFormat("vi-VN", { day: "2-digit", month: "2-digit", year: "numeric" });

/** Màn danh sách sơ đồ ghế của nhà xe (Figma `1180:6017`; FR-OPS-03, UC-12). */
export function SeatMapList() {
  const seatMaps = useInfiniteQuery({
    queryKey: ["seat-maps", "list"],
    queryFn: ({ pageParam }) => listSeatMaps({ cursor: pageParam }),
    initialPageParam: undefined as string | undefined,
    getNextPageParam: (lastPage) => lastPage.nextCursor ?? undefined
  });
  const items = useMemo(() => seatMaps.data?.pages.flatMap((page) => page.items) ?? [], [seatMaps.data]);

  let hint = "Số chỗ là số đơn vị bán vé. Sức chứa là số hành khách tối đa.";
  let body: ReactNode;
  let footer: ReactNode = null;
  if (seatMaps.isError && !seatMaps.data) {
    body = (
      <ListStatePanel
        icon={<CircleAlert className="size-6 text-warning-700" />}
        title="Không tải được danh sách sơ đồ"
        description="Kiểm tra kết nối mạng rồi thử lại."
        action={
          <Button className={`${BUTTON} w-36`} onClick={() => void seatMaps.refetch()}>
            <RefreshCw className="size-[18px]" />
            Thử lại
          </Button>
        }
      />
    );
  } else if (seatMaps.isPending) {
    hint = "Đang tải danh sách sơ đồ…";
    body = <LoadingRows />;
    footer = <ListFooterNote>Đang tải sơ đồ…</ListFooterNote>;
  } else if (items.length === 0) {
    body = (
      <ListStatePanel
        icon={<FileX2 className="size-6 text-vxn-fg-3" />}
        title="Chưa có sơ đồ ghế"
        description="Tạo sơ đồ đầu tiên để bố trí chỗ và gắn cho phương tiện."
        action={
          <Button asChild className={`${BUTTON} w-[220px]`}>
            <Link href="/seat-maps/new">
              <Plus className="size-[18px]" />
              Tạo sơ đồ đầu tiên
            </Link>
          </Button>
        }
      />
    );
  } else {
    body = <SeatMapTable items={items} />;
    footer = (
      <ListLoadMoreFooter
        hasMore={seatMaps.hasNextPage}
        loading={seatMaps.isFetchingNextPage}
        failed={seatMaps.isFetchNextPageError}
        loadedText={`Đã tải ${items.length} sơ đồ`}
        endText={`Đã hiển thị tất cả ${items.length} sơ đồ`}
        errorText="Chưa tải được thêm sơ đồ. Các dữ liệu đã tải vẫn được giữ lại."
        onLoadMore={() => void seatMaps.fetchNextPage()}
      />
    );
  }

  return (
    <div className="flex flex-col gap-6">
      <PageHeader
        title="Sơ đồ ghế"
        description="Quản lý bố trí chỗ và sức chứa của phương tiện."
        actions={
          <Button asChild className={`${BUTTON} w-36`}>
            <Link href="/seat-maps/new">
              <Plus className="size-[18px]" />
              Tạo sơ đồ
            </Link>
          </Button>
        }
      />

      <section aria-labelledby="seat-map-list-heading" className="flex flex-col rounded-xl border bg-card p-6">
        <div className="flex flex-col gap-1 pb-7">
          <h2 id="seat-map-list-heading" className="text-base leading-6 font-semibold text-vxn-ink">
            Danh sách sơ đồ ghế
          </h2>
          <p className="text-xs leading-[18px] text-muted-foreground" aria-live="polite">
            {hint}
          </p>
        </div>
        <div className="min-h-[504px]">{body}</div>
        {footer && <div className="flex min-h-20 flex-wrap items-center gap-3 py-5">{footer}</div>}
        {/* Chỉ nhắc khi thật sự có sơ đồ đang bị khóa; trước TRN-003 API luôn trả `inUse = false`. */}
        {items.some((item) => item.inUse) && (
          <p className="rounded-lg bg-warning-50 px-4 py-[17px] text-xs leading-[18px] text-warning-700">
            Sơ đồ đang dùng cho chuyến chỉ có thể xem. Tạo bản sao để chỉnh sửa riêng.
          </p>
        )}
      </section>

      <div className="flex items-center gap-3 rounded-lg bg-accent px-5 py-6">
        <Armchair className="size-5 shrink-0 text-vxn-teal-700" />
        <p className="text-sm leading-5 text-vxn-teal-700">
          Một sơ đồ có thể dùng chung cho nhiều xe. Tạo bản sao khi cần bố trí riêng.
        </p>
      </div>
    </div>
  );
}

// Tỉ lệ cột theo Figma (300 / 72 / 92 / 124 / 220 / 280 trên bảng rộng 1088).
const COLUMNS = ["w-[27.6%]", "w-[6.6%]", "w-[8.5%]", "w-[11.4%]", "w-[20.2%]", "w-[280px]"];

function SeatMapTable({ items }: { items: SeatMapSummary[] }) {
  return (
    <div className="overflow-x-auto">
      <table className="w-full min-w-[920px] table-fixed border-collapse text-left">
        <colgroup>
          {COLUMNS.map((width) => (
            <col key={width} className={width} />
          ))}
        </colgroup>
        <thead>
          <tr className="h-11 text-xs leading-[18px] text-muted-foreground">
            <th scope="col" className="rounded-l-lg bg-muted pl-4 font-medium">
              Tên sơ đồ
            </th>
            {["Số tầng", "Số chỗ", "Sức chứa", "Trạng thái sử dụng"].map((heading) => (
              <th key={heading} scope="col" className="bg-muted font-medium">
                {heading}
              </th>
            ))}
            <th scope="col" className="rounded-r-lg bg-muted pl-4 font-medium">
              Thao tác
            </th>
          </tr>
        </thead>
        <tbody>
          {items.map((seatMap) => (
            <tr key={seatMap.id} className="h-[84px] border-b">
              <td className="pr-4 pl-4">
                <div className="flex flex-col gap-1">
                  <span className="truncate text-sm leading-5 font-semibold text-vxn-teal-700">{seatMap.name}</span>
                  <span className="text-xs leading-[18px] text-muted-foreground">
                    Cập nhật {UPDATED_AT.format(new Date(seatMap.updatedAt))}
                  </span>
                </div>
              </td>
              <td className="text-sm leading-5 text-vxn-fg-1">{seatMap.deckCount}</td>
              <td className="text-sm leading-5 text-vxn-fg-1">{seatMap.seatCount}</td>
              <td className="text-sm leading-5 font-semibold text-vxn-fg-1">{seatMap.passengerCapacity} người</td>
              <td>
                {seatMap.inUse ? (
                  <Badge tone="warning">Đang dùng cho chuyến</Badge>
                ) : (
                  <Badge>Có thể chỉnh sửa</Badge>
                )}
              </td>
              <td>
                <div className="flex items-center justify-end gap-2">
                  {/* Sơ đồ đang dùng mở ở chế độ chỉ xem; trang chi tiết tự chọn chế độ theo `inUse`. */}
                  <Button asChild variant="ghost" className={`${BUTTON} w-28 text-vxn-fg-1`}>
                    <Link
                      href={`/seat-maps/${seatMap.id}`}
                      aria-label={`${seatMap.inUse ? "Xem" : "Chỉnh sửa"} sơ đồ ${seatMap.name}`}
                    >
                      {seatMap.inUse ? "Xem" : "Chỉnh sửa"}
                    </Link>
                  </Button>
                  <Button asChild variant="outline" className={`${BUTTON} w-36 bg-card text-vxn-fg-1`}>
                    <Link href={`/seat-maps/new?copyFrom=${seatMap.id}`} aria-label={`Tạo bản sao của sơ đồ ${seatMap.name}`}>
                      <Copy className="size-[18px]" />
                      Tạo bản sao
                    </Link>
                  </Button>
                </div>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}

function LoadingRows() {
  return (
    <div role="status" aria-label="Đang tải danh sách sơ đồ ghế" className="flex flex-col">
      <div className="h-11 rounded-lg bg-muted" />
      {Array.from({ length: 6 }, (_, row) => (
        <div key={row} className="flex h-[84px] items-center border-b">
          <div className="flex w-[27.6%] flex-col gap-2 pl-4">
            <Skeleton className="h-4 w-[190px] max-w-full" />
            <Skeleton className="h-3 w-[136px] max-w-full" />
          </div>
          <div className="w-[6.6%]">
            <Skeleton className="h-4 w-7" />
          </div>
          <div className="w-[8.5%]">
            <Skeleton className="h-4 w-8" />
          </div>
          <div className="w-[11.4%]">
            <Skeleton className="h-4 w-[76px] max-w-full" />
          </div>
          <div className="w-[20.2%]">
            <Skeleton className="h-4 w-[156px] max-w-full" />
          </div>
          <div className="flex flex-1 justify-end">
            <Skeleton className="h-9 w-[232px] max-w-full" />
          </div>
        </div>
      ))}
    </div>
  );
}
