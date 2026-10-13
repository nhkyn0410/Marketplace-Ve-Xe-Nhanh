"use client";

import { useInfiniteQuery, useQuery } from "@tanstack/react-query";
import { Badge } from "@vexenhanh/ui/components/badge";
import { Button } from "@vexenhanh/ui/components/button";
import { CircleAlert, FileX2, LockKeyhole, Pencil, Plus, RefreshCw } from "lucide-react";
import { useMemo, useState, type ReactNode } from "react";

import { GOONG_MAPTILES_KEY } from "../../lib/map/map-config";
import { markerKind, nextSelection, OWN_MAP_LEGEND, type OverviewSelection } from "../../lib/map/stop-map";
import { useMapOpen } from "../../lib/map/use-map-open";
import {
  listProvinces,
  listStopPoints,
  type StopPoint,
  type StopPointStatus,
  type StopPointType
} from "../../lib/stop-point/stop-point-api";
import {
  OWN_STOP_POINT_TYPES,
  provinceLabel,
  routeCountLabel,
  STOP_POINT_STATUS,
  STOP_POINT_STATUS_ORDER,
  STOP_POINT_TYPE_LABELS
} from "../../lib/stop-point/stop-point-format";
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
 * Tab "Của nhà xe": văn phòng trung chuyển và trạm dừng nghỉ của riêng nhà xe (Figma 01; FR-OPS-17, BR-38).
 * Điểm bị Platform khóa hiện lý do và không có nút Sửa (BR-81). Khối bản đồ tổng quan nằm trên bảng, hiện
 * đúng các điểm bảng đang liệt kê (TASK-TRN-014).
 */
export function OwnStopPointList({
  onCreate,
  onEdit
}: {
  onCreate: () => void;
  onEdit: (stopPoint: StopPoint) => void;
}) {
  const [search, setSearch] = useState("");
  const [type, setType] = useState<string>(ALL);
  const [provinceId, setProvinceId] = useState<string>(ALL);
  const [status, setStatus] = useState<string>(ALL);
  const q = useDebouncedValue(search.trim());
  const [mapOpen, setMapOpen] = useMapOpen("stop-overview", false);
  const [selection, setSelection] = useState<OverviewSelection | null>(null);

  const stopPoints = useInfiniteQuery({
    queryKey: ["stop-points", "own", { q, type, provinceId, status }],
    queryFn: ({ pageParam }) =>
      listStopPoints({
        q: q || undefined,
        type: type === ALL ? undefined : (type as StopPointType),
        provinceId: provinceId === ALL ? undefined : provinceId,
        status: status === ALL ? undefined : (status as StopPointStatus),
        cursor: pageParam
      }),
    initialPageParam: undefined as string | undefined,
    getNextPageParam: (lastPage) => lastPage.nextCursor ?? undefined
  });
  // Danh mục ít đổi: giữ lâu để chuyển tab / mở hộp thoại không gọi lại.
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
          meta:
            stopPoint.status === "ACTIVE"
              ? `${STOP_POINT_TYPE_LABELS[stopPoint.type]} · ${stopPoint.routeCount > 0 ? `${stopPoint.routeCount} tuyến đang dùng` : "chưa dùng trong tuyến nào"}`
              : `${STOP_POINT_TYPE_LABELS[stopPoint.type]} · ${STOP_POINT_STATUS[stopPoint.status].label}`,
          kind: markerKind(stopPoint.type, stopPoint.status),
          point: { latitude: stopPoint.latitude, longitude: stopPoint.longitude }
        })
      ),
    [items]
  );
  const filtered = q !== "" || type !== ALL || provinceId !== ALL || status !== ALL;
  const pending = stopPoints.isPending || provinces.isPending;
  // Lỗi khi tải thêm KHÔNG thuộc nhánh này: các dòng đã tải vẫn được giữ lại (xem chân bảng).
  const failed = (stopPoints.isError && !stopPoints.data) || provinces.isError;

  function clearFilters() {
    setSearch("");
    setType(ALL);
    setProvinceId(ALL);
    setStatus(ALL);
  }

  let body: ReactNode;
  let footer: ReactNode = null;
  if (failed) {
    body = (
      <ListStatePanel
        icon={<CircleAlert className="size-6 text-warning-700" />}
        title="Không tải được điểm dừng"
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
    body = <TableSkeleton label="Đang tải danh sách điểm dừng" />;
    footer = <ListFooterNote>Đang tải danh sách điểm dừng…</ListFooterNote>;
  } else if (items.length === 0) {
    body = filtered ? (
      <ListStatePanel
        icon={<FileX2 className="size-6 text-vxn-fg-3" />}
        title="Không có điểm dừng phù hợp"
        description="Thử từ khoá khác hoặc bỏ lọc để xem toàn bộ điểm dừng của nhà xe."
        action={
          <Button variant="outline" className={`${BUTTON} bg-card`} onClick={clearFilters}>
            Bỏ lọc
          </Button>
        }
      />
    ) : (
      <ListStatePanel
        icon={<FileX2 className="size-6 text-vxn-fg-3" />}
        title="Thêm điểm dừng đầu tiên"
        description="Tạo văn phòng trung chuyển hoặc trạm dừng nghỉ của nhà xe để dùng khi lập tuyến."
        action={
          <Button className={`${BUTTON} w-[200px]`} onClick={onCreate}>
            <Plus className="size-[18px]" />
            Thêm điểm dừng
          </Button>
        }
      />
    );
  } else {
    body = (
      <OwnTable
        items={items}
        provinceNames={provinceNames}
        onEdit={onEdit}
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
          legend={OWN_MAP_LEGEND}
          open={mapOpen}
          onOpenChange={setMapOpen}
          selection={selection}
          onSelect={(id) => setSelection((current) => nextSelection(current, id, false))}
        />
      )}
      <section aria-label="Điểm dừng của nhà xe" className="flex flex-col rounded-xl border bg-card p-6">
        <div className="flex flex-wrap items-end gap-4 pb-5">
          <SearchField value={search} onChange={setSearch} />
          <FilterSelect
            label="Loại điểm"
            allLabel="Tất cả loại"
            value={type}
            onChange={setType}
            options={OWN_STOP_POINT_TYPES.map((value) => ({ value, label: STOP_POINT_TYPE_LABELS[value] }))}
          />
          <FilterSelect
            label="Tỉnh / thành"
            allLabel="Tất cả tỉnh / thành"
            value={provinceId}
            onChange={setProvinceId}
            options={(provinces.data ?? []).map((province) => ({ value: province.id, label: province.name }))}
            disabled={!provinces.data}
          />
          <FilterSelect
            label="Trạng thái"
            allLabel="Tất cả trạng thái"
            value={status}
            onChange={setStatus}
            options={STOP_POINT_STATUS_ORDER.map((value) => ({ value, label: STOP_POINT_STATUS[value].label }))}
            className="w-48"
          />
        </div>
        <div className="min-h-[504px]">{body}</div>
        {footer && <div className="flex min-h-20 flex-wrap items-center gap-3 py-5">{footer}</div>}
      </section>
    </>
  );
}

// Tỉ lệ cột theo Figma (tên co giãn / 200 / 170 / 120 / 130 / 112 trên bảng rộng 1088).
const COLUMNS = ["", "w-[18.4%]", "w-[15.6%]", "w-[11%]", "w-[12%]", "w-28"];

function OwnTable({
  items,
  provinceNames,
  onEdit,
  selectedId,
  onLocate
}: {
  items: StopPoint[];
  provinceNames: ReadonlyMap<string, string>;
  onEdit: (stopPoint: StopPoint) => void;
  /** Điểm đang được chọn trên bản đồ — dòng tương ứng được tô nền. */
  selectedId: string | null;
  /** Có giá trị khi bản đồ đang mở: bấm một dòng thì bản đồ chuyển tới điểm đó. */
  onLocate?: (id: string) => void;
}) {
  return (
    <div className="overflow-x-auto">
      <table className={`${TABLE} min-w-[920px]`}>
        <colgroup>
          {COLUMNS.map((width, index) => (
            <col key={index} className={width} />
          ))}
        </colgroup>
        <thead>
          <tr className={TABLE_HEAD_ROW}>
            {["Tên và địa chỉ", "Loại điểm", "Tỉnh / thành", "Tuyến đang dùng", "Trạng thái", "Thao tác"].map((heading) => (
              <th key={heading} scope="col" className={TABLE_HEAD_CELL}>
                {heading}
              </th>
            ))}
          </tr>
        </thead>
        <tbody>
          {items.map((stopPoint) => {
            const state = STOP_POINT_STATUS[stopPoint.status];
            const suspended = stopPoint.status === "SUSPENDED";
            const nameClass = `truncate font-semibold ${stopPoint.status === "INACTIVE" ? "text-muted-foreground" : "text-vxn-teal-700"}`;
            return (
              <tr key={stopPoint.id} {...locatableRow(stopPoint.id, selectedId, onLocate)}>
                <td className={TABLE_CELL}>
                  <div className="flex flex-col gap-1">
                    <LocatableName id={stopPoint.id} name={stopPoint.name} className={nameClass} onLocate={onLocate} />
                    <span className="truncate text-xs leading-[18px] text-muted-foreground">{stopPoint.address}</span>
                    {suspended && (
                      <span className="flex items-start gap-1.5 text-xs leading-[18px] text-error-600">
                        <LockKeyhole className="mt-px size-4 shrink-0" aria-hidden />
                        <span>Platform đã khóa: {stopPoint.suspensionReason}</span>
                      </span>
                    )}
                  </div>
                </td>
                <td className={TABLE_CELL}>{STOP_POINT_TYPE_LABELS[stopPoint.type]}</td>
                <td className={TABLE_CELL}>{provinceLabel(provinceNames, stopPoint.provinceId)}</td>
                <td className={TABLE_CELL}>{routeCountLabel(stopPoint.routeCount)}</td>
                <td className={TABLE_CELL}>
                  <Badge tone={state.tone}>{state.label}</Badge>
                </td>
                <td className={TABLE_CELL}>
                  {suspended ? (
                    <span className="text-xs leading-[18px] text-muted-foreground">Không sửa được</span>
                  ) : (
                    <Button
                      variant="ghost"
                      className={`${BUTTON} w-24 text-vxn-fg-1`}
                      aria-label={`Sửa điểm dừng ${stopPoint.name}`}
                      onClick={() => onEdit(stopPoint)}
                    >
                      <Pencil className="size-[18px]" />
                      Sửa
                    </Button>
                  )}
                </td>
              </tr>
            );
          })}
        </tbody>
      </table>
    </div>
  );
}
