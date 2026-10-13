"use client";

import { useInfiniteQuery, useQuery } from "@tanstack/react-query";
import { Button } from "@vexenhanh/ui/components/button";
import { CircleAlert, FileX2, RefreshCw } from "lucide-react";
import { useMemo, useState, type ReactNode } from "react";

import { GOONG_MAPTILES_KEY } from "../../lib/map/map-config";
import { markerKind, nextSelection, SHARED_MAP_LEGEND, type OverviewSelection } from "../../lib/map/stop-map";
import { useMapOpen } from "../../lib/map/use-map-open";
import {
  listProvinces,
  listSharedStopPoints,
  type SharedStopPoint,
  type StopPointType
} from "../../lib/stop-point/stop-point-api";
import { provinceLabel, SHARED_STOP_POINT_TYPES, STOP_POINT_TYPE_LABELS } from "../../lib/stop-point/stop-point-format";
import { BUTTON, ListFooterNote, ListLoadMoreFooter, ListStatePanel } from "../list-parts";
import { StopOverviewMap, type OverviewPoint } from "../map/stop-overview-map";
import {
  ALL,
  FilterSelect,
  LocatableName,
  locatableRow,
  SearchField,
  TABLE,
  TABLE_CELL,
  TABLE_HEAD_CELL,
  TABLE_HEAD_ROW,
  TableSkeleton,
  useDebouncedValue
} from "./list-controls";

/**
 * Tab "Dùng chung", phần danh mục: bến xe, điểm dừng đón trả khách và trạm dừng nghỉ do Platform quản lý
 * (Figma 02; BR-38). Chỉ xem; API danh mục chỉ trả điểm đang hoạt động nên không có cột trạng thái. Khối bản
 * đồ tổng quan nằm trên bảng, hiện đúng các điểm bảng đang liệt kê (TASK-TRN-014).
 */
export function SharedStopPointList() {
  const [search, setSearch] = useState("");
  const [type, setType] = useState<string>(ALL);
  const [provinceId, setProvinceId] = useState<string>(ALL);
  const q = useDebouncedValue(search.trim());
  const [mapOpen, setMapOpen] = useMapOpen("stop-overview", false);
  const [selection, setSelection] = useState<OverviewSelection | null>(null);

  const stopPoints = useInfiniteQuery({
    queryKey: ["stop-points", "shared", { q, type, provinceId }],
    queryFn: ({ pageParam }) =>
      listSharedStopPoints({
        q: q || undefined,
        type: type === ALL ? undefined : (type as StopPointType),
        provinceId: provinceId === ALL ? undefined : provinceId,
        cursor: pageParam
      }),
    initialPageParam: undefined as string | undefined,
    getNextPageParam: (lastPage) => lastPage.nextCursor ?? undefined
  });
  const provinces = useQuery({ queryKey: ["catalog", "provinces"], queryFn: listProvinces, staleTime: 300_000 });

  const provinceNames = useMemo(
    () => new Map((provinces.data ?? []).map((province) => [province.id, province.name])),
    [provinces.data]
  );
  const items = useMemo(() => stopPoints.data?.pages.flatMap((page) => page.items) ?? [], [stopPoints.data]);
  const mapPoints = useMemo(
    () =>
      items.map(
        (stopPoint): OverviewPoint => ({
          id: stopPoint.id,
          name: stopPoint.name,
          address: stopPoint.address,
          meta: `${STOP_POINT_TYPE_LABELS[stopPoint.type]} · ${provinceLabel(provinceNames, stopPoint.provinceId)}`,
          kind: markerKind(stopPoint.type),
          point: { latitude: stopPoint.latitude, longitude: stopPoint.longitude }
        })
      ),
    [items, provinceNames]
  );
  const filtered = q !== "" || type !== ALL || provinceId !== ALL;
  const pending = stopPoints.isPending || provinces.isPending;
  const failed = (stopPoints.isError && !stopPoints.data) || provinces.isError;

  let body: ReactNode;
  let footer: ReactNode = null;
  if (failed) {
    body = (
      <ListStatePanel
        compact
        icon={<CircleAlert className="size-6 text-warning-700" />}
        title="Không tải được danh mục dùng chung"
        description="Kiểm tra kết nối mạng rồi thử lại."
        action={
          <Button
            className={`${BUTTON} w-36`}
            onClick={() => [stopPoints, provinces].filter((query) => query.isError).forEach((query) => void query.refetch())}
          >
            <RefreshCw className="size-[18px]" />
            Thử lại
          </Button>
        }
      />
    );
  } else if (pending) {
    body = <TableSkeleton label="Đang tải danh mục dùng chung" rows={4} />;
    footer = <ListFooterNote>Đang tải danh mục dùng chung…</ListFooterNote>;
  } else if (items.length === 0) {
    body = filtered ? (
      <ListStatePanel
        compact
        icon={<FileX2 className="size-6 text-vxn-fg-3" />}
        title="Không có điểm dừng phù hợp"
        description="Thử từ khoá khác hoặc bỏ lọc. Nếu danh mục còn thiếu, hãy gửi đề xuất điểm dừng."
        action={
          <Button
            variant="outline"
            className={`${BUTTON} bg-card`}
            onClick={() => {
              setSearch("");
              setType(ALL);
              setProvinceId(ALL);
            }}
          >
            Bỏ lọc
          </Button>
        }
      />
    ) : (
      <ListStatePanel
        compact
        icon={<FileX2 className="size-6 text-vxn-fg-3" />}
        title="Danh mục chưa có điểm dừng"
        description="Platform chưa đưa điểm nào vào danh mục dùng chung. Bạn có thể gửi đề xuất điểm dừng còn thiếu."
      />
    );
  } else {
    body = (
      <SharedTable
        items={items}
        provinceNames={provinceNames}
        selectedId={selection?.id ?? null}
        onLocate={
          GOONG_MAPTILES_KEY && mapOpen ? (id) => setSelection((current) => nextSelection(current, id, true)) : undefined
        }
      />
    );
    footer = (
      <ListLoadMoreFooter
        hasMore={stopPoints.hasNextPage}
        loading={stopPoints.isFetchingNextPage}
        failed={stopPoints.isFetchNextPageError}
        loadedText={`Đã tải ${items.length} điểm dừng`}
        endText={`Đã hiển thị tất cả ${items.length} điểm dừng`}
        errorText="Chưa tải thêm được điểm dừng. Các dòng đã tải vẫn được giữ lại."
        onLoadMore={() => void stopPoints.fetchNextPage()}
      />
    );
  }

  return (
    <>
      {GOONG_MAPTILES_KEY && (
        <StopOverviewMap
          mapKey={GOONG_MAPTILES_KEY}
          points={mapPoints}
          legend={SHARED_MAP_LEGEND}
          open={mapOpen}
          onOpenChange={setMapOpen}
          selection={selection}
          onSelect={(id) => setSelection((current) => nextSelection(current, id, false))}
        />
      )}
      <section aria-labelledby="shared-stop-points-heading" className="flex flex-col rounded-xl border bg-card p-6">
        <div className="flex flex-col gap-1 pb-5">
          <h2 id="shared-stop-points-heading" className="text-base leading-6 font-semibold text-vxn-ink">
            Danh mục dùng chung
          </h2>
          <p className="text-xs leading-[18px] text-muted-foreground">
            Bến xe, điểm dừng đón trả khách và trạm dừng nghỉ do Platform quản lý. Chọn các điểm này khi lập tuyến.
          </p>
        </div>
        <div className="flex flex-wrap items-end gap-4 pb-5">
          <SearchField value={search} onChange={setSearch} />
          <FilterSelect
            label="Loại điểm"
            allLabel="Tất cả loại"
            value={type}
            onChange={setType}
            options={SHARED_STOP_POINT_TYPES.map((value) => ({ value, label: STOP_POINT_TYPE_LABELS[value] }))}
            className="w-60"
          />
          <FilterSelect
            label="Tỉnh / thành"
            allLabel="Tất cả tỉnh / thành"
            value={provinceId}
            onChange={setProvinceId}
            options={(provinces.data ?? []).map((province) => ({ value: province.id, label: province.name }))}
            disabled={!provinces.data}
            className="w-56"
          />
        </div>
        <div className="min-h-[240px]">{body}</div>
        {footer && <div className="flex min-h-20 flex-wrap items-center gap-3 py-5">{footer}</div>}
      </section>
    </>
  );
}

// Tỉ lệ cột theo Figma (tên co giãn / 260 / 240 trên bảng rộng 1088).
const COLUMNS = ["", "w-[24%]", "w-[22%]"];

function SharedTable({
  items,
  provinceNames,
  selectedId,
  onLocate
}: {
  items: SharedStopPoint[];
  provinceNames: ReadonlyMap<string, string>;
  /** Điểm đang được chọn trên bản đồ — dòng tương ứng được tô nền. */
  selectedId: string | null;
  /** Có giá trị khi bản đồ đang mở: bấm một dòng thì bản đồ chuyển tới điểm đó. */
  onLocate?: (id: string) => void;
}) {
  return (
    <div className="overflow-x-auto">
      <table className={`${TABLE} min-w-[640px]`}>
        <colgroup>
          {COLUMNS.map((width, index) => (
            <col key={index} className={width} />
          ))}
        </colgroup>
        <thead>
          <tr className={TABLE_HEAD_ROW}>
            {["Tên và địa chỉ", "Loại điểm", "Tỉnh / thành"].map((heading) => (
              <th key={heading} scope="col" className={TABLE_HEAD_CELL}>
                {heading}
              </th>
            ))}
          </tr>
        </thead>
        <tbody>
          {items.map((stopPoint) => (
            <tr key={stopPoint.id} {...locatableRow(stopPoint.id, selectedId, onLocate)}>
              <td className={TABLE_CELL}>
                <div className="flex flex-col gap-1">
                  <LocatableName
                    id={stopPoint.id}
                    name={stopPoint.name}
                    className="truncate font-semibold text-vxn-ink"
                    onLocate={onLocate}
                  />
                  <span className="truncate text-xs leading-[18px] text-muted-foreground">{stopPoint.address}</span>
                </div>
              </td>
              <td className={TABLE_CELL}>{STOP_POINT_TYPE_LABELS[stopPoint.type]}</td>
              <td className={TABLE_CELL}>{provinceLabel(provinceNames, stopPoint.provinceId)}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}
