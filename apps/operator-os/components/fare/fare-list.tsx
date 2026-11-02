"use client";

import { useQuery } from "@tanstack/react-query";
import { Badge } from "@vexenhanh/ui/components/badge";
import { Button } from "@vexenhanh/ui/components/button";
import { ChevronRight, CircleAlert, FileX2, Plus, RefreshCw } from "lucide-react";
import Link from "next/link";
import { useMemo, useState, type ReactNode } from "react";

import { listAllFares, type FareSummary } from "../../lib/fare/fare-api";
import { FARE_STATUS, FARE_STATUS_ORDER, priceRangeLabel, ruleCountLabel } from "../../lib/fare/fare-format";
import { listAllRoutes, type RouteSummary } from "../../lib/route/route-api";
import { formatDay, formatTime } from "../../lib/trip/trip-format";
import { BUTTON, ListFooterNote, ListStatePanel } from "../list-parts";
import { PageHeader } from "../page-header";
import {
  ALL,
  FilterSelect,
  SearchField,
  TABLE,
  TABLE_CELL,
  TABLE_HEAD_CELL,
  TABLE_HEAD_ROW,
  TableSkeleton
} from "../stop-point/list-controls";

/** Giá trị ô lọc trạng thái cho tuyến chưa có bảng giá. */
const NO_FARE = "NONE";

type Row = { route: RouteSummary; fare: FareSummary | undefined };

/** Bỏ dấu + chữ thường để gõ không dấu vẫn tìm ra tên tuyến. */
const fold = (value: string) =>
  value
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "")
    .replace(/đ/gi, "d")
    .toLowerCase();

/**
 * Màn danh sách bảng giá (Figma "01 · Bảng giá / Danh sách"; FR-OPS-08). Mỗi tuyến một dòng: tuyến đã có bảng
 * giá thì mở để sửa, chưa có thì tạo. Ghép danh sách tuyến với danh sách bảng giá ở phía giao diện.
 */
export function FareList() {
  const [search, setSearch] = useState("");
  const [status, setStatus] = useState<string>(ALL);
  // Tuyến con (3.2) có bảng giá riêng nên ô lọc liệt kê cả tuyến con.
  const routes = useQuery({ queryKey: ["routes", "all", "with-sub-routes"], queryFn: () => listAllRoutes(undefined, { includeSubRoutes: true }) });
  const fares = useQuery({ queryKey: ["fares", "all"], queryFn: listAllFares });

  const rows = useMemo<Row[]>(() => {
    const byRoute = new Map((fares.data ?? []).map((fare) => [fare.routeId, fare]));
    return (
      (routes.data ?? [])
        .map((route) => ({ route, fare: byRoute.get(route.id) }))
        // Tuyến đã ngừng dùng mà chưa có bảng giá thì không tạo được nữa — không cần hiện.
        .filter((row) => row.fare !== undefined || row.route.status === "ACTIVE")
        .sort((a, b) => a.route.name.localeCompare(b.route.name, "vi"))
    );
  }, [routes.data, fares.data]);
  const visible = useMemo(() => {
    const needle = fold(search.trim());
    return rows.filter(
      (row) =>
        (needle === "" || fold(row.route.name).includes(needle)) &&
        (status === ALL || (row.fare?.status ?? NO_FARE) === status)
    );
  }, [rows, search, status]);
  const filtered = search.trim() !== "" || status !== ALL;

  let body: ReactNode;
  let footer: ReactNode = null;
  if (routes.isError || fares.isError) {
    body = (
      <ListStatePanel
        icon={<CircleAlert className="size-6 text-warning-700" />}
        title="Không tải được bảng giá"
        description="Kiểm tra kết nối mạng rồi thử lại."
        action={
          <Button
            className={`${BUTTON} w-36`}
            onClick={() => {
              void routes.refetch();
              void fares.refetch();
            }}
          >
            <RefreshCw className="size-[18px]" />
            Thử lại
          </Button>
        }
      />
    );
  } else if (routes.isPending || fares.isPending) {
    body = <TableSkeleton label="Đang tải danh sách bảng giá" />;
    footer = <ListFooterNote>Đang tải danh sách bảng giá…</ListFooterNote>;
  } else if (rows.length === 0) {
    body = (
      <ListStatePanel
        icon={<FileX2 className="size-6 text-vxn-fg-3" />}
        title="Chưa có tuyến để đặt giá"
        description="Bảng giá gắn với tuyến. Lập tuyến ở mục Tuyến đường trước rồi quay lại đặt giá."
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
  } else if (visible.length === 0) {
    body = (
      <ListStatePanel
        icon={<FileX2 className="size-6 text-vxn-fg-3" />}
        title="Không có tuyến phù hợp"
        description="Đổi từ khóa hoặc trạng thái, hoặc bỏ lọc để xem toàn bộ tuyến."
        action={
          <Button
            variant="outline"
            className={`${BUTTON} bg-card`}
            onClick={() => {
              setSearch("");
              setStatus(ALL);
            }}
          >
            Bỏ lọc
          </Button>
        }
      />
    );
  } else {
    body = <FareTable rows={visible} />;
    footer = (
      <ListFooterNote>
        {filtered ? `Đang hiển thị ${visible.length} / ${rows.length} tuyến` : `Đã tải ${rows.length} tuyến`}
      </ListFooterNote>
    );
  }

  return (
    <div className="flex flex-col gap-6">
      <PageHeader
        title="Bảng giá"
        description="Mỗi tuyến có một bảng giá. Giá tính theo loại xe, loại chỗ và khung giờ khởi hành."
        actions={
          <Button asChild className={`${BUTTON} w-44`}>
            <Link href="/fares/new">
              <Plus className="size-[18px]" />
              Tạo bảng giá
            </Link>
          </Button>
        }
      />

      <section aria-label="Danh sách bảng giá" className="flex flex-col rounded-xl border bg-card p-6">
        <div className="flex flex-wrap items-end gap-x-4 gap-y-3 pb-5">
          <SearchField
            label="Tìm tuyến"
            placeholder="Tìm theo tên tuyến"
            value={search}
            onChange={setSearch}
            className="max-w-xs"
          />
          <FilterSelect
            label="Trạng thái"
            allLabel="Tất cả trạng thái"
            value={status}
            onChange={setStatus}
            options={[
              ...FARE_STATUS_ORDER.map((value) => ({ value: value as string, label: FARE_STATUS[value].label })),
              { value: NO_FARE, label: "Chưa có bảng giá" }
            ]}
            className="w-56"
          />
        </div>
        <div className="min-h-[360px]">{body}</div>
        {footer && <div className="flex min-h-14 items-center pt-5">{footer}</div>}
      </section>

      <div className="flex items-center gap-4 rounded-lg bg-accent px-5 py-4">
        <CircleAlert className="size-5 shrink-0 text-vxn-teal-700" />
        <p className="min-w-0 flex-1 text-sm leading-5 text-vxn-teal-700">
          Chuyến chỉ mở bán được khi tuyến có bảng giá đang áp dụng và mọi chỗ trên xe đều có giá lớn hơn 0.
        </p>
      </div>
    </div>
  );
}

// Độ rộng cột theo Figma (co giãn / 130 / 230 / 170 / 160 / 90 trên bảng rộng 1086).
const COLUMNS = ["", "w-[12%]", "w-[21.2%]", "w-[15.7%]", "w-[14.7%]", "w-24"];
const HEADINGS = ["Tuyến", "Quy tắc giá", "Khoảng giá mỗi chỗ", "Trạng thái", "Cập nhật", "Thao tác"];
const SUBLINE = "truncate text-xs leading-[18px] text-muted-foreground";
const STRONG = "truncate font-semibold text-vxn-ink";

function FareTable({ rows }: { rows: Row[] }) {
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
          {rows.map(({ route, fare }) => (
            <tr key={route.id} className="h-[69px] border-b">
              <td className={TABLE_CELL}>
                <div className="flex flex-col gap-0.5">
                  <span className={STRONG}>{route.name}</span>
                  <span className={SUBLINE}>
                    {route.originName} → {route.destinationName}
                  </span>
                </div>
              </td>
              <td className={TABLE_CELL}>{fare ? ruleCountLabel(fare.ruleCount) : "—"}</td>
              <td className={TABLE_CELL}>
                <div className="flex flex-col gap-0.5">
                  <span className={STRONG}>{fare ? priceRangeLabel(fare.minPrice, fare.maxPrice) : "—"}</span>
                  {fare?.hasDoubleSeatPrice && <span className={SUBLINE}>Gồm giá chỗ đôi</span>}
                </div>
              </td>
              <td className={TABLE_CELL}>
                {fare ? (
                  <Badge tone={FARE_STATUS[fare.status].tone}>{FARE_STATUS[fare.status].label}</Badge>
                ) : (
                  <Badge tone="warning">Chưa có bảng giá</Badge>
                )}
              </td>
              <td className={TABLE_CELL}>
                {fare ? (
                  <div className="flex flex-col gap-0.5">
                    <span className={STRONG}>{formatDay(fare.updatedAt)}</span>
                    <span className={SUBLINE}>{formatTime(fare.updatedAt)}</span>
                  </div>
                ) : (
                  "—"
                )}
              </td>
              <td className={TABLE_CELL}>
                <Button asChild variant="ghost" className={`${BUTTON} w-[84px] gap-1.5 px-2 text-vxn-fg-1`}>
                  {fare ? (
                    <Link href={`/fares/${fare.id}`} aria-label={`Sửa bảng giá tuyến ${route.name}`}>
                      Sửa
                      <ChevronRight className="size-4" />
                    </Link>
                  ) : (
                    <Link href={`/fares/new?routeId=${route.id}`} aria-label={`Tạo bảng giá cho tuyến ${route.name}`}>
                      Tạo
                      <Plus className="size-4" />
                    </Link>
                  )}
                </Button>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}
