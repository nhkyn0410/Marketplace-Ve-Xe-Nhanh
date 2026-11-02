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
import { BUTTON, ListFooterNote, ListLoadMoreFooter, ListStatePanel } from "@vexenhanh/ui/components/list-parts";
import { Ban, CircleAlert, FileX2, Info, Pencil, RefreshCw, RotateCcw } from "lucide-react";
import { useMemo, useState, type ReactNode } from "react";

import {
  listAllProvinces,
  listAmenities,
  listProvinces,
  listVehicleTypes,
  listWards,
  type CatalogItem,
  type CatalogKind
} from "../../lib/catalog/catalog-api";
import { CATALOG_STATUS, KIND_COPY, VEHICLE_CLASS, VEHICLE_FORM_LABELS } from "../../lib/catalog/catalog-format";

export type ItemAction = (kind: CatalogKind, item: CatalogItem) => void;
type ListProps = { onEdit: ItemAction; onToggle: ItemAction };

const STATUS_OPTIONS = (["ACTIVE", "INACTIVE"] as const).map((value) => ({ value, label: CATALOG_STATUS[value].label }));

/** Tab "Tỉnh / thành" (Figma ADM-04b): tìm theo tên / mã, lọc trạng thái, xếp theo mã, "Tải thêm". */
export function ProvinceList({ onEdit, onToggle }: ListProps) {
  const [search, setSearch] = useState("");
  const [status, setStatus] = useState<string>(ALL);
  const q = useDebouncedValue(search.trim());
  const filters = { q: q || undefined, status: status === ALL ? undefined : status };
  const pages = useInfiniteQuery({
    queryKey: ["admin-catalog", "provinces", filters],
    queryFn: ({ pageParam }) => listProvinces(filters, pageParam),
    initialPageParam: null as string | null,
    getNextPageParam: (last) => last.nextCursor
  });
  const items = useMemo(() => pages.data?.pages.flatMap((page) => page.items) ?? [], [pages.data]);
  return (
    <ListShell
      label="Tỉnh / thành"
      filters={
        <>
          <SearchField label="Tìm tỉnh / thành" placeholder="Tên hoặc mã" value={search} onChange={setSearch} className="max-w-sm" />
          <FilterSelect label="Trạng thái" allLabel="Tất cả" value={status} onChange={setStatus} options={STATUS_OPTIONS} />
        </>
      }
      pages={pages}
      empty={q || status !== ALL ? "Không có tỉnh / thành phù hợp" : "Danh mục chưa có tỉnh / thành"}
      footer={
        <ListLoadMoreFooter
          hasMore={pages.hasNextPage}
          loading={pages.isFetchingNextPage}
          failed={pages.isFetchNextPageError}
          loadedText={`Đã tải ${items.length} / ${pages.data?.pages[0]?.total ?? items.length} tỉnh / thành`}
          endText={`Đã hiển thị tất cả ${items.length} tỉnh / thành`}
          errorText="Chưa tải thêm được. Các dòng đã tải vẫn được giữ lại."
          onLoadMore={() => void pages.fetchNextPage()}
        />
      }
      table={
        <CatalogTable
          headings={["Mã", "Tên", "Phường / xã", "Điểm dừng dùng chung", "Trạng thái"]}
          columns={["w-[12%]", "", "w-[13%]", "w-[19%]", "w-[14%]"]}
          numeric={[2, 3]}
          rows={items.map((item) => ({
            item,
            cells: [item.code, <strong key="name">{item.name}</strong>, item.wardCount, item.stopPointCount]
          }))}
          kind="provinces"
          onEdit={onEdit}
          onToggle={onToggle}
        />
      }
      count={items.length}
      note="Phường / xã phải thuộc một tỉnh / thành. Mục ngừng dùng không chọn được cho dữ liệu mới; dữ liệu đang dùng mục đó giữ nguyên."
    />
  );
}

/** Tab "Phường / xã": lọc theo tỉnh / thành + trạng thái, tìm theo tên / mã. */
export function WardList({ onEdit, onToggle }: ListProps) {
  const [search, setSearch] = useState("");
  const [status, setStatus] = useState<string>(ALL);
  const [provinceId, setProvinceId] = useState<string>(ALL);
  const q = useDebouncedValue(search.trim());
  const provinces = useQuery({ queryKey: ["admin-catalog", "provinces", "all"], queryFn: listAllProvinces, staleTime: 60_000 });
  const filters = {
    q: q || undefined,
    status: status === ALL ? undefined : status,
    provinceId: provinceId === ALL ? undefined : provinceId
  };
  const pages = useInfiniteQuery({
    queryKey: ["admin-catalog", "wards", filters],
    queryFn: ({ pageParam }) => listWards(filters, pageParam),
    initialPageParam: null as string | null,
    getNextPageParam: (last) => last.nextCursor
  });
  const items = useMemo(() => pages.data?.pages.flatMap((page) => page.items) ?? [], [pages.data]);
  return (
    <ListShell
      label="Phường / xã"
      filters={
        <>
          <SearchField label="Tìm phường / xã" placeholder="Tên hoặc mã" value={search} onChange={setSearch} className="max-w-sm" />
          <FilterSelect
            label="Tỉnh / thành"
            allLabel="Tất cả"
            value={provinceId}
            onChange={setProvinceId}
            options={(provinces.data ?? []).map((province) => ({ value: province.id, label: province.name }))}
            disabled={!provinces.data}
            className="w-56"
          />
          <FilterSelect label="Trạng thái" allLabel="Tất cả" value={status} onChange={setStatus} options={STATUS_OPTIONS} />
        </>
      }
      pages={pages}
      empty={q || status !== ALL || provinceId !== ALL ? "Không có phường / xã phù hợp" : "Danh mục chưa có phường / xã"}
      footer={
        <ListLoadMoreFooter
          hasMore={pages.hasNextPage}
          loading={pages.isFetchingNextPage}
          failed={pages.isFetchNextPageError}
          loadedText={`Đã tải ${items.length} / ${pages.data?.pages[0]?.total ?? items.length} phường / xã`}
          endText={`Đã hiển thị tất cả ${items.length} phường / xã`}
          errorText="Chưa tải thêm được. Các dòng đã tải vẫn được giữ lại."
          onLoadMore={() => void pages.fetchNextPage()}
        />
      }
      table={
        <CatalogTable
          headings={["Mã", "Tên", "Tỉnh / thành", "Điểm dừng dùng chung", "Trạng thái"]}
          columns={["w-[12%]", "", "w-[22%]", "w-[19%]", "w-[14%]"]}
          numeric={[3]}
          rows={items.map((item) => ({
            item,
            cells: [item.code, <strong key="name">{item.name}</strong>, item.provinceName, item.stopPointCount]
          }))}
          kind="wards"
          onEdit={onEdit}
          onToggle={onToggle}
        />
      }
      count={items.length}
      note="Phường / xã gắn với tỉnh / thành từ lúc tạo, không đổi tỉnh được: điểm dừng tham chiếu cặp phường – tỉnh."
    />
  );
}

/** Tab "Loại xe" (Figma ADM-04a): mã, tên, dạng chỗ, hạng xe, số xe đang dùng. */
export function VehicleTypeList({ onEdit, onToggle }: ListProps) {
  const list = useQuery({ queryKey: ["admin-catalog", "vehicle-types"], queryFn: () => listVehicleTypes() });
  const items = list.data ?? [];
  return (
    <ListShell
      label="Loại xe"
      pages={list}
      empty="Danh mục chưa có loại xe"
      footer={<ListFooterNote>{`Đã tải ${items.length} loại xe`}</ListFooterNote>}
      table={
        <CatalogTable
          headings={["Mã", "Tên hiển thị", "Dạng chỗ", "Hạng xe", "Xe đang dùng", "Trạng thái"]}
          columns={["w-[21%]", "", "w-[14%]", "w-[15%]", "w-[11%]", "w-[12%]"]}
          numeric={[4]}
          rows={items.map((item) => ({
            item,
            cells: [
              <strong key="code">{item.code}</strong>,
              <strong key="name">{item.name}</strong>,
              VEHICLE_FORM_LABELS[item.form],
              <Badge key="class" tone={VEHICLE_CLASS[item.class].tone}>
                {VEHICLE_CLASS[item.class].label}
              </Badge>,
              item.vehicleCount
            ]
          }))}
          kind="vehicle-types"
          onEdit={onEdit}
          onToggle={onToggle}
        />
      }
      count={items.length}
      note="Dạng chỗ và hạng xe là hai thuộc tính độc lập. Hạng do nhà xe tự khai qua loại xe đã chọn; Vé Xe Nhanh không thẩm định tiêu chuẩn limousine."
    />
  );
}

/** Tab "Tiện ích": mã, tên, số xe đang khai. */
export function AmenityList({ onEdit, onToggle }: ListProps) {
  const list = useQuery({ queryKey: ["admin-catalog", "amenities"], queryFn: () => listAmenities() });
  const items = list.data ?? [];
  return (
    <ListShell
      label="Tiện ích"
      pages={list}
      empty="Danh mục chưa có tiện ích"
      footer={<ListFooterNote>{`Đã tải ${items.length} tiện ích`}</ListFooterNote>}
      table={
        <CatalogTable
          headings={["Mã", "Tên", "Xe đang khai", "Trạng thái"]}
          columns={["w-[24%]", "", "w-[15%]", "w-[14%]"]}
          numeric={[2]}
          rows={items.map((item) => ({
            item,
            cells: [<strong key="code">{item.code}</strong>, item.name, item.vehicleCount]
          }))}
          kind="amenities"
          onEdit={onEdit}
          onToggle={onToggle}
        />
      }
      count={items.length}
      note="Tiện ích hiện ở chi tiết chuyến cho hành khách theo xe nhà xe đã khai."
    />
  );
}

/** Khung chung: ô lọc, trạng thái tải / lỗi / rỗng, bảng, chân bảng, dòng chú thích. */
function ListShell({
  label,
  filters,
  pages,
  empty,
  table,
  footer,
  count,
  note
}: {
  label: string;
  filters?: ReactNode;
  pages: { isPending: boolean; isError: boolean; refetch: () => unknown };
  empty: string;
  table: ReactNode;
  footer: ReactNode;
  count: number;
  note: string;
}) {
  let body: ReactNode;
  if (pages.isError && count === 0) {
    body = (
      <ListStatePanel
        compact
        icon={<CircleAlert className="size-6 text-warning-700" />}
        title={`Không tải được ${label.toLowerCase()}`}
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
    body = <TableSkeleton label={`Đang tải ${label.toLowerCase()}`} rows={5} />;
  } else if (count === 0) {
    body = <ListStatePanel compact icon={<FileX2 className="size-6 text-vxn-fg-3" />} title={empty} description="Đổi bộ lọc hoặc thêm mục mới." />;
  } else {
    body = table;
  }
  return (
    <>
      <section aria-label={label} className="flex flex-col rounded-xl border bg-card p-6">
        {filters && <div className="flex flex-wrap items-end gap-4 pb-5">{filters}</div>}
        <div className="min-h-[200px]">{body}</div>
        {count > 0 && <div className="flex min-h-14 flex-wrap items-center gap-3 pt-5">{footer}</div>}
      </section>
      <div className="flex items-center gap-4 rounded-lg bg-accent px-5 py-4">
        <Info className="size-5 shrink-0 text-accent-foreground" />
        <p className="min-w-0 flex-1 text-sm leading-5 text-accent-foreground">{note}</p>
      </div>
    </>
  );
}

/** Bảng danh mục: các cột riêng + cột Trạng thái + hai nút sửa / ngừng dùng (dùng lại). */
function CatalogTable({
  headings,
  columns,
  numeric,
  rows,
  kind,
  onEdit,
  onToggle
}: {
  headings: string[];
  columns: string[];
  /** Vị trí các cột số (căn phải). */
  numeric: number[];
  rows: { item: CatalogItem; cells: ReactNode[] }[];
  kind: CatalogKind;
} & ListProps) {
  const noun = KIND_COPY[kind].noun;
  return (
    <div className="relative overflow-x-auto">
      <table className={`${TABLE} min-w-[760px]`}>
        <colgroup>
          {[...columns, "w-[96px]"].map((width, index) => (
            <col key={index} className={width} />
          ))}
        </colgroup>
        <thead>
          <tr className={TABLE_HEAD_ROW}>
            {headings.map((heading, index) => (
              <th key={heading} scope="col" className={`${TABLE_HEAD_CELL} ${numeric.includes(index) ? "pr-6 text-right" : ""}`}>
                {heading}
              </th>
            ))}
            <th scope="col" className={TABLE_HEAD_CELL}>
              <span className="sr-only">Thao tác</span>
            </th>
          </tr>
        </thead>
        <tbody>
          {rows.map(({ item, cells }) => {
            const status = CATALOG_STATUS[item.status];
            return (
              <tr key={item.id} className="h-14 border-b">
                {cells.map((cell, index) => (
                  <td
                    key={index}
                    className={`${TABLE_CELL} truncate ${numeric.includes(index) ? "pr-6 text-right" : ""} ${index === 0 ? "font-semibold text-vxn-ink" : ""}`}
                  >
                    {cell}
                  </td>
                ))}
                <td className={TABLE_CELL}>
                  <Badge tone={status.tone}>{status.label}</Badge>
                </td>
                <td className={TABLE_CELL}>
                  <div className="flex items-center gap-1">
                    <Button variant="ghost" size="icon" aria-label={`Sửa ${noun} ${item.name}`} onClick={() => onEdit(kind, item)}>
                      <Pencil className="size-4" />
                    </Button>
                    <Button
                      variant="ghost"
                      size="icon"
                      aria-label={item.status === "ACTIVE" ? `Ngừng dùng ${noun} ${item.name}` : `Dùng lại ${noun} ${item.name}`}
                      onClick={() => onToggle(kind, item)}
                    >
                      {item.status === "ACTIVE" ? <Ban className="size-4" /> : <RotateCcw className="size-4" />}
                    </Button>
                  </div>
                </td>
              </tr>
            );
          })}
        </tbody>
      </table>
    </div>
  );
}
