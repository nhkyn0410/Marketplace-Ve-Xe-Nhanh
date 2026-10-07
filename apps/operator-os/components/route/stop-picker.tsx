"use client";

import { useInfiniteQuery, useQuery } from "@tanstack/react-query";
import { Button } from "@vexenhanh/ui/components/button";
import { Skeleton } from "@vexenhanh/ui/components/skeleton";
import { Tabs, TabsList, TabsTrigger } from "@vexenhanh/ui/components/tabs";
import { Check, LoaderCircle, Plus, X } from "lucide-react";
import Link from "next/link";
import { useId, useMemo, useState } from "react";

import { MAX_ROUTE_STOPS, stopKey, type StopCandidate } from "../../lib/route/route-form";
import {
  listProvinces,
  listSharedStopPoints,
  listStopPoints,
  type StopPointType
} from "../../lib/stop-point/stop-point-api";
import {
  OWN_STOP_POINT_TYPES,
  provinceLabel,
  SHARED_STOP_POINT_TYPES,
  STOP_POINT_TYPE_LABELS
} from "../../lib/stop-point/stop-point-format";
import { BUTTON } from "../list-parts";
import { ALL, FilterSelect, SearchField, TAB_TRIGGER, useDebouncedValue } from "../stop-point/list-controls";

type Source = "shared" | "own";

/**
 * Bảng chọn điểm dừng mở ngay trong form tuyến (Figma "04 · Thêm điểm dừng ngay trong form"; Khanh chốt
 * 07/10/2026: không dùng hộp thoại che nền). Chỉ liệt kê điểm đang dùng được: danh mục dùng chung đang hoạt
 * động và điểm riêng `ACTIVE` của nhà xe.
 */
export function StopPicker({
  selectedKeys,
  stopCount,
  onAdd,
  onClose
}: {
  /** Khóa (`stopKey`) của các điểm đã có trong tuyến — hiện "Đã thêm" thay cho nút. */
  selectedKeys: ReadonlySet<string>;
  stopCount: number;
  onAdd: (candidate: StopCandidate) => void;
  onClose: () => void;
}) {
  const headingId = useId();
  const [source, setSource] = useState<Source>("shared");
  const [search, setSearch] = useState("");
  const [type, setType] = useState<string>(ALL);
  const [provinceId, setProvinceId] = useState<string>(ALL);
  const q = useDebouncedValue(search.trim());
  const filters = {
    q: q || undefined,
    type: type === ALL ? undefined : (type as StopPointType),
    provinceId: provinceId === ALL ? undefined : provinceId
  };

  const points = useInfiniteQuery({
    queryKey: ["stop-points", "picker", source, filters],
    queryFn: async ({ pageParam }): Promise<{ items: StopCandidate[]; provinceIds: string[]; nextCursor: string | null }> => {
      const page =
        source === "shared"
          ? await listSharedStopPoints({ ...filters, cursor: pageParam })
          : await listStopPoints({ ...filters, status: "ACTIVE", cursor: pageParam });
      return {
        items: page.items.map((point) => ({
          catalogStopPointId: source === "shared" ? point.id : null,
          stopPointId: source === "own" ? point.id : null,
          name: point.name,
          address: point.address,
          type: point.type
        })),
        provinceIds: page.items.map((point) => point.provinceId),
        nextCursor: page.nextCursor
      };
    },
    initialPageParam: undefined as string | undefined,
    getNextPageParam: (lastPage) => lastPage.nextCursor ?? undefined
  });
  const provinces = useQuery({ queryKey: ["catalog", "provinces"], queryFn: listProvinces, staleTime: 300_000 });
  const provinceNames = useMemo(
    () => new Map((provinces.data ?? []).map((province) => [province.id, province.name])),
    [provinces.data]
  );
  const rows = useMemo(
    () =>
      points.data?.pages.flatMap((page) =>
        page.items.map((item, index) => ({ item, provinceId: page.provinceIds[index]! }))
      ) ?? [],
    [points.data]
  );
  const full = stopCount >= MAX_ROUTE_STOPS;
  const filtered = q !== "" || type !== ALL || provinceId !== ALL;

  function selectSource(value: string) {
    setSource(value as Source);
    // Mỗi nguồn có bộ loại điểm riêng nên loại đang lọc không còn nghĩa.
    setType(ALL);
  }

  return (
    <section aria-labelledby={headingId} className="flex flex-col gap-4 rounded-lg border bg-background p-4">
      <div className="flex items-start gap-3">
        <div className="flex min-w-0 flex-1 flex-col gap-0.5">
          <h3 id={headingId} className="text-sm leading-5 font-semibold text-vxn-ink">
            Thêm điểm dừng vào tuyến
          </h3>
          <p className="text-xs leading-[18px] text-muted-foreground">
            Bấm Thêm để đưa điểm vào cuối tuyến, sau đó đổi thứ tự bằng nút mũi tên ở danh sách phía trên.
          </p>
        </div>
        <Button type="button" variant="ghost" className={`${BUTTON} text-vxn-fg-1`} onClick={onClose}>
          <X className="size-[18px]" />
          Đóng
        </Button>
      </div>

      <Tabs value={source} onValueChange={selectSource}>
        <TabsList className="h-10 w-fit" aria-label="Nguồn điểm dừng">
          <TabsTrigger value="shared" className={TAB_TRIGGER}>
            Dùng chung
          </TabsTrigger>
          <TabsTrigger value="own" className={TAB_TRIGGER}>
            Của nhà xe
          </TabsTrigger>
        </TabsList>
      </Tabs>

      <div className="flex flex-wrap items-end gap-3">
        <SearchField value={search} onChange={setSearch} />
        <FilterSelect
          label="Loại điểm"
          allLabel="Tất cả loại"
          value={type}
          onChange={setType}
          options={(source === "shared" ? SHARED_STOP_POINT_TYPES : OWN_STOP_POINT_TYPES).map((value) => ({
            value,
            label: STOP_POINT_TYPE_LABELS[value]
          }))}
          className="w-40"
        />
        <FilterSelect
          label="Tỉnh / thành"
          allLabel="Tất cả"
          value={provinceId}
          onChange={setProvinceId}
          options={(provinces.data ?? []).map((province) => ({ value: province.id, label: province.name }))}
          disabled={!provinces.data}
          className="w-40"
        />
      </div>

      <div className="overflow-hidden rounded-lg border bg-card">
        {points.isPending ? (
          <div role="status" aria-label="Đang tải điểm dừng" className="flex flex-col">
            {Array.from({ length: 4 }, (_, row) => (
              <div key={row} className="flex h-[68px] items-center gap-4 border-b px-4 last:border-b-0">
                <div className="flex flex-1 flex-col gap-2">
                  <Skeleton className="h-4 w-2/5" />
                  <Skeleton className="h-2.5 w-3/5" />
                </div>
                <Skeleton className="h-4 w-24" />
              </div>
            ))}
          </div>
        ) : points.isError && !points.data ? (
          <div role="alert" className="flex flex-wrap items-center gap-3 px-4 py-5">
            <p className="min-w-0 flex-1 text-sm leading-5 text-error-600">Chưa tải được danh sách điểm dừng.</p>
            <Button type="button" variant="outline" className={`${BUTTON} bg-card`} onClick={() => void points.refetch()}>
              Thử lại
            </Button>
          </div>
        ) : rows.length === 0 ? (
          <div className="flex flex-col items-center gap-1 px-4 py-8 text-center">
            <p className="text-sm leading-5 font-semibold text-vxn-ink">
              {filtered
                ? "Không có điểm dừng phù hợp"
                : source === "own"
                  ? "Nhà xe chưa có điểm dừng đang hoạt động"
                  : "Danh mục chưa có điểm dừng"}
            </p>
            <p className="text-xs leading-[18px] text-muted-foreground">
              {filtered ? (
                "Thử từ khoá khác hoặc bỏ bớt điều kiện lọc."
              ) : (
                <>
                  Thêm văn phòng trung chuyển, trạm dừng nghỉ hoặc gửi đề xuất ở mục{" "}
                  <Link href="/stop-points" className="font-medium text-vxn-teal-700 underline-offset-2 hover:underline">
                    Điểm dừng
                  </Link>
                  .
                </>
              )}
            </p>
          </div>
        ) : (
          <ul aria-label="Điểm dừng có thể thêm">
            {rows.map(({ item, provinceId: itemProvinceId }) => {
              const added = selectedKeys.has(stopKey(item));
              return (
                <li key={stopKey(item)} className="flex min-h-[68px] items-center gap-3 border-b px-4 py-3 last:border-b-0">
                  <div className="flex min-w-0 flex-1 flex-col gap-1">
                    <span className={`text-sm leading-5 font-semibold ${added ? "text-muted-foreground" : "text-vxn-ink"}`}>
                      {item.name}
                    </span>
                    <span className="text-xs leading-[18px] text-muted-foreground">{item.address}</span>
                  </div>
                  {/* Loại điểm và tỉnh / thành xếp chồng để tên điểm có đủ chỗ trong cột hẹp của form. */}
                  <div className="flex w-44 shrink-0 flex-col gap-1">
                    <span className={`text-sm leading-5 ${added ? "text-muted-foreground" : "text-vxn-fg-1"}`}>
                      {STOP_POINT_TYPE_LABELS[item.type]}
                    </span>
                    <span className="truncate text-xs leading-[18px] text-muted-foreground">
                      {provinceLabel(provinceNames, itemProvinceId)}
                    </span>
                  </div>
                  <div className="flex w-28 shrink-0 justify-end">
                    {added ? (
                      <span className="flex items-center gap-1.5 text-xs leading-[18px] text-muted-foreground">
                        <Check className="size-4 text-success-600" aria-hidden />
                        Đã thêm
                      </span>
                    ) : (
                      <Button
                        type="button"
                        variant="outline"
                        className={`${BUTTON} bg-card`}
                        disabled={full}
                        aria-label={`Thêm ${item.name} vào tuyến`}
                        onClick={() => onAdd(item)}
                      >
                        <Plus className="size-[18px]" />
                        Thêm
                      </Button>
                    )}
                  </div>
                </li>
              );
            })}
          </ul>
        )}
      </div>

      <div className="flex flex-wrap items-center gap-3">
        <p className="min-w-0 flex-1 text-xs leading-[18px] text-muted-foreground" aria-live="polite">
          {full
            ? `Tuyến đã đủ ${MAX_ROUTE_STOPS} điểm, không thêm được nữa.`
            : `Tuyến đang có ${stopCount} / ${MAX_ROUTE_STOPS} điểm`}
          {points.isFetchNextPageError && " · Chưa tải thêm được, bấm Tải thêm để thử lại."}
        </p>
        {points.hasNextPage && (
          <Button
            type="button"
            variant="outline"
            className={`${BUTTON} w-36 bg-card`}
            disabled={points.isFetchingNextPage}
            onClick={() => void points.fetchNextPage()}
          >
            {points.isFetchingNextPage && <LoaderCircle className="size-[18px] animate-spin" />}
            {points.isFetchingNextPage ? "Đang tải…" : "Tải thêm"}
          </Button>
        )}
      </div>
    </section>
  );
}
