"use client";

import { useInfiniteQuery, useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { Badge } from "@vexenhanh/ui/components/badge";
import { Button } from "@vexenhanh/ui/components/button";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle
} from "@vexenhanh/ui/components/dialog";
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
} from "@vexenhanh/ui/components/list-controls";
import { BUTTON, ListLoadMoreFooter, ListStatePanel } from "@vexenhanh/ui/components/list-parts";
import { StopOverviewMap, type OverviewPoint } from "@vexenhanh/ui/components/stop-overview-map";
import { GOONG_MAPTILES_KEY } from "@vexenhanh/ui/lib/map-config";
import { markerKind, nextSelection, SHARED_MAP_LEGEND, type OverviewSelection } from "@vexenhanh/ui/lib/stop-map";
import { useMapOpen } from "@vexenhanh/ui/lib/use-map-open";
import { Ban, CircleAlert, FileX2, LoaderCircle, Pencil, RefreshCw, RotateCcw } from "lucide-react";
import { useMemo, useState, type ReactNode } from "react";

import {
  listProvinces,
  listSharedStopPoints,
  updateSharedStopPoint,
  type SharedStopPoint
} from "../../lib/stop-point/stop-point-api";
import {
  describeStopPointError,
  formatCount,
  SHARED_STATUS,
  SHARED_TYPES,
  STOP_POINT_TYPE_LABELS
} from "../../lib/stop-point/stop-point-format";

/**
 * Tab "Dùng chung" (Figma ADM-05a; UC-24, BR-38): bản đồ tổng quan + bảng mọi trạng thái, lọc loại / tỉnh /
 * trạng thái, tìm không dấu; sửa, ngừng dùng / dùng lại. Không xóa điểm dùng chung.
 */
export function SharedList({
  onEdit,
  onNotice
}: {
  onEdit: (stopPoint: SharedStopPoint) => void;
  onNotice: (message: string) => void;
}) {
  const [search, setSearch] = useState("");
  const [type, setType] = useState<string>(ALL);
  const [provinceId, setProvinceId] = useState<string>(ALL);
  const [status, setStatus] = useState<string>(ALL);
  const q = useDebouncedValue(search.trim());
  const [mapOpen, setMapOpen] = useMapOpen("stop-overview", true);
  const [selection, setSelection] = useState<OverviewSelection | null>(null);
  const [toggling, setToggling] = useState<SharedStopPoint | null>(null);

  const filters = {
    q: q || undefined,
    type: type === ALL ? undefined : type,
    provinceId: provinceId === ALL ? undefined : provinceId,
    status: status === ALL ? undefined : status
  };
  const pages = useInfiniteQuery({
    queryKey: ["admin-stop-points", "shared", filters],
    queryFn: ({ pageParam }) => listSharedStopPoints(filters, pageParam),
    initialPageParam: null as string | null,
    getNextPageParam: (last) => last.nextCursor
  });
  const provinces = useQuery({ queryKey: ["catalog", "provinces"], queryFn: listProvinces, staleTime: 300_000 });
  const items = useMemo(() => pages.data?.pages.flatMap((page) => page.items) ?? [], [pages.data]);
  const total = pages.data?.pages[0]?.total ?? 0;
  const mapPoints = useMemo(
    () =>
      items.map(
        (item): OverviewPoint => ({
          id: item.id,
          name: item.name,
          address: item.address,
          meta: `${STOP_POINT_TYPE_LABELS[item.type]} · ${item.routeCount} tuyến`,
          kind: item.status === "ACTIVE" ? markerKind(item.type) : "muted",
          point: { latitude: item.latitude, longitude: item.longitude }
        })
      ),
    [items]
  );
  const filtered = q !== "" || type !== ALL || provinceId !== ALL || status !== ALL;

  let body: ReactNode;
  let footer: ReactNode = null;
  if (pages.isError && items.length === 0) {
    body = (
      <ListStatePanel
        compact
        icon={<CircleAlert className="size-6 text-warning-700" />}
        title="Không tải được danh mục điểm dừng"
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
    body = <TableSkeleton label="Đang tải danh mục điểm dừng" rows={5} />;
  } else if (items.length === 0) {
    body = (
      <ListStatePanel
        compact
        icon={<FileX2 className="size-6 text-vxn-fg-3" />}
        title={filtered ? "Không có điểm dừng phù hợp" : "Danh mục chưa có điểm dừng"}
        description={filtered ? "Đổi từ khóa hoặc bộ lọc." : "Thêm bến xe, điểm dừng đón trả hoặc trạm dừng nghỉ đầu tiên."}
        action={
          filtered ? (
            <Button
              variant="outline"
              className={`${BUTTON} bg-card`}
              onClick={() => {
                setSearch("");
                setType(ALL);
                setProvinceId(ALL);
                setStatus(ALL);
              }}
            >
              Bỏ lọc
            </Button>
          ) : undefined
        }
      />
    );
  } else {
    body = (
      <SharedTable
        items={items}
        selectedId={selection?.id ?? null}
        onLocate={GOONG_MAPTILES_KEY && mapOpen ? (id) => setSelection((current) => nextSelection(current, id, true)) : undefined}
        onEdit={onEdit}
        onToggle={setToggling}
      />
    );
    footer = (
      <ListLoadMoreFooter
        hasMore={pages.hasNextPage}
        loading={pages.isFetchingNextPage}
        failed={pages.isFetchNextPageError}
        loadedText={`Đã tải ${formatCount(items.length)} / ${formatCount(total)} điểm dừng`}
        endText={`Đã hiển thị tất cả ${formatCount(items.length)} điểm dừng`}
        errorText="Chưa tải thêm được. Các dòng đã tải vẫn được giữ lại."
        onLoadMore={() => void pages.fetchNextPage()}
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
      <section aria-label="Điểm dừng dùng chung" className="flex flex-col rounded-xl border bg-card p-6">
        <div className="flex flex-wrap items-end gap-4 pb-5">
          <SearchField
            label="Tìm điểm dừng"
            placeholder="Tên hoặc địa chỉ (gõ không dấu vẫn tìm được)"
            value={search}
            onChange={setSearch}
          />
          <FilterSelect
            label="Loại điểm"
            allLabel="Tất cả loại"
            value={type}
            onChange={setType}
            options={SHARED_TYPES.map((value) => ({ value, label: STOP_POINT_TYPE_LABELS[value] }))}
            className="w-52"
          />
          <FilterSelect
            label="Tỉnh / thành"
            allLabel="Tất cả"
            value={provinceId}
            onChange={setProvinceId}
            options={(provinces.data ?? []).map((province) => ({ value: province.id, label: province.name }))}
            disabled={!provinces.data}
            className="w-52"
          />
          <FilterSelect
            label="Trạng thái"
            allLabel="Tất cả"
            value={status}
            onChange={setStatus}
            options={(["ACTIVE", "INACTIVE"] as const).map((value) => ({ value, label: SHARED_STATUS[value].label }))}
            className="w-44"
          />
        </div>
        <div className="min-h-[240px]">{body}</div>
        {footer && <div className="flex min-h-14 flex-wrap items-center gap-3 pt-5">{footer}</div>}
      </section>
      <ToggleDialog target={toggling} onClose={() => setToggling(null)} onDone={onNotice} />
    </>
  );
}

// Tỉ lệ cột theo Figma ADM-05a (tên co giãn / 175 / 135 / 240 / 60 / 120 / 70 trên bảng rộng 1056).
const COLUMNS = ["", "w-[16%]", "w-[12.5%]", "w-[21%]", "w-[6.5%]", "w-[11.5%]", "w-[86px]"];
const HEADINGS = ["Tên và địa chỉ", "Loại điểm", "Tỉnh / thành", "Căn cứ công bố", "Số tuyến", "Trạng thái", ""];

function SharedTable({
  items,
  selectedId,
  onLocate,
  onEdit,
  onToggle
}: {
  items: SharedStopPoint[];
  selectedId: string | null;
  onLocate?: (id: string) => void;
  onEdit: (stopPoint: SharedStopPoint) => void;
  onToggle: (stopPoint: SharedStopPoint) => void;
}) {
  return (
    <div className="relative overflow-x-auto">
      <table className={`${TABLE} min-w-[960px]`}>
        <colgroup>
          {COLUMNS.map((width, index) => (
            <col key={index} className={width} />
          ))}
        </colgroup>
        <thead>
          <tr className={TABLE_HEAD_ROW}>
            {HEADINGS.map((heading, index) => (
              <th key={index} scope="col" className={`${TABLE_HEAD_CELL} ${index === 4 ? "text-right" : ""}`}>
                {heading || <span className="sr-only">Thao tác</span>}
              </th>
            ))}
          </tr>
        </thead>
        <tbody>
          {items.map((item) => {
            const status = SHARED_STATUS[item.status];
            return (
              <tr key={item.id} {...locatableRow(item.id, selectedId, onLocate)}>
                <td className={TABLE_CELL}>
                  <div className="flex min-w-0 flex-col gap-1">
                    <LocatableName id={item.id} name={item.name} className="truncate font-semibold text-vxn-ink" onLocate={onLocate} />
                    <span className="truncate text-xs leading-[18px] text-muted-foreground">{item.address}</span>
                  </div>
                </td>
                <td className={TABLE_CELL}>{STOP_POINT_TYPE_LABELS[item.type]}</td>
                <td className={`${TABLE_CELL} truncate`}>{item.provinceName}</td>
                <td className={`${TABLE_CELL} truncate`} title={item.legalBasis ?? undefined}>
                  {item.legalBasis ?? "—"}
                </td>
                <td className={`${TABLE_CELL} text-right`}>{item.routeCount}</td>
                <td className={TABLE_CELL}>
                  <Badge tone={status.tone}>{status.label}</Badge>
                </td>
                <td className={TABLE_CELL}>
                  <div className="flex items-center gap-1">
                    <Button
                      variant="ghost"
                      size="icon"
                      className="size-9"
                      aria-label={`Sửa ${item.name}`}
                      onClick={() => onEdit(item)}
                    >
                      <Pencil className="size-4" />
                    </Button>
                    <Button
                      variant="ghost"
                      size="icon"
                      className="size-9"
                      aria-label={item.status === "ACTIVE" ? `Ngừng dùng ${item.name}` : `Dùng lại ${item.name}`}
                      onClick={() => onToggle(item)}
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

/** Xác nhận ngừng dùng / dùng lại một điểm dùng chung (gửi lại toàn bộ điểm với trạng thái mới). */
function ToggleDialog({
  target,
  onClose,
  onDone
}: {
  target: SharedStopPoint | null;
  onClose: () => void;
  onDone: (message: string) => void;
}) {
  const queryClient = useQueryClient();
  const [error, setError] = useState<string | null>(null);
  const deactivate = target?.status === "ACTIVE";
  const run = useMutation({
    mutationFn: (stopPoint: SharedStopPoint) =>
      updateSharedStopPoint(stopPoint.id, {
        name: stopPoint.name,
        type: stopPoint.type as "BUS_STATION" | "PICKUP_POINT" | "REST_STOP",
        address: stopPoint.address,
        provinceId: stopPoint.provinceId,
        wardId: stopPoint.wardId,
        latitude: stopPoint.latitude,
        longitude: stopPoint.longitude,
        description: stopPoint.description,
        legalBasis: stopPoint.legalBasis,
        status: stopPoint.status === "ACTIVE" ? "INACTIVE" : "ACTIVE"
      }),
    onSuccess: (saved) => {
      void queryClient.invalidateQueries({ queryKey: ["admin-stop-points"] });
      onDone(saved.status === "ACTIVE" ? `Đã dùng lại “${saved.name}”.` : `Đã ngừng dùng “${saved.name}”.`);
      close();
    },
    onError: (failure) => setError(describeStopPointError(failure).message)
  });

  function close() {
    setError(null);
    onClose();
  }

  return (
    <Dialog open={target !== null} onOpenChange={(open) => !open && !run.isPending && close()}>
      {target && (
        <DialogContent>
          <DialogHeader>
            <DialogTitle>{deactivate ? "Ngừng dùng điểm dừng" : "Dùng lại điểm dừng"}</DialogTitle>
            <DialogDescription>{target.name}</DialogDescription>
          </DialogHeader>
          <p className="text-sm leading-5 text-vxn-fg-1">
            {deactivate
              ? `Nhà xe không gắn mới được điểm này vào tuyến; ${target.routeCount} tuyến đang dùng vẫn giữ nguyên.`
              : "Nhà xe lại chọn được điểm này khi lập tuyến."}
          </p>
          {error && (
            <p role="alert" className="rounded-lg bg-error-50 px-4 py-3 text-sm leading-5 text-error-600">
              {error}
            </p>
          )}
          <DialogFooter>
            <Button variant="outline" className={`${BUTTON} bg-card`} disabled={run.isPending} onClick={close}>
              Hủy
            </Button>
            <Button
              variant={deactivate ? "destructive" : "default"}
              className={BUTTON}
              disabled={run.isPending}
              onClick={() => run.mutate(target)}
            >
              {run.isPending && <LoaderCircle className="size-[18px] animate-spin" />}
              {deactivate ? "Ngừng dùng" : "Dùng lại"}
            </Button>
          </DialogFooter>
        </DialogContent>
      )}
    </Dialog>
  );
}
