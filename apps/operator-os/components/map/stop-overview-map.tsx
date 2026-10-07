"use client";

import { MapMarker, MapPopup, MapView, type MapFocus } from "@vexenhanh/ui/components/map";
import type { MapPoint } from "@vexenhanh/ui/lib/map";
import { X } from "lucide-react";
import { useEffect, useId, useMemo, useRef } from "react";

import type { MapLegendItem, MarkerKind, OverviewSelection } from "../../lib/map/stop-map";
import { MapDot, MapLegend, MapToggle } from "./map-parts";

/** Một điểm dừng trên bản đồ tổng quan. */
export type OverviewPoint = {
  id: string;
  name: string;
  address: string;
  /** Dòng phụ trong thẻ xem nhanh, vd "Văn phòng trung chuyển · 3 tuyến". */
  meta: string;
  kind: MarkerKind;
  point: MapPoint;
};

// Bấm một dòng trong bảng thì phóng tới mức đủ thấy đường phố quanh điểm.
const ROW_FOCUS_ZOOM = 14;

/**
 * Khối "Bản đồ điểm dừng" đóng mở được nằm trên bảng (Figma "Overview map panel"; UI §7): hiện các điểm đang
 * có trong danh sách, bấm ghim để xem nhanh, bấm một dòng của bảng thì bản đồ chuyển tới điểm đó.
 */
export function StopOverviewMap({
  mapKey,
  points,
  legend,
  open,
  onOpenChange,
  selection,
  onSelect
}: {
  mapKey: string;
  points: readonly OverviewPoint[];
  legend: readonly MapLegendItem[];
  open: boolean;
  onOpenChange: (open: boolean) => void;
  selection: OverviewSelection | null;
  /** Người dùng bấm một ghim (`id`) hoặc đóng thẻ xem nhanh / bấm ra nền bản đồ (`null`). */
  onSelect: (id: string | null) => void;
}) {
  const headingId = useId();
  const bodyId = useId();
  const sectionRef = useRef<HTMLElement>(null);
  const selected = selection ? (points.find((item) => item.id === selection.id) ?? null) : null;
  const fitPoints = useMemo(() => points.map((item) => item.point), [points]);
  const focus: MapFocus | null =
    selected && selection
      ? { ...selected.point, zoom: selection.zoomIn ? ROW_FOCUS_ZOOM : undefined, token: selection.token }
      : null;

  // Bảng dài thì bản đồ nằm ngoài màn hình: chọn một điểm là đưa bản đồ vào tầm nhìn.
  const selectionToken = selection?.token;
  useEffect(() => {
    if (open && selectionToken !== undefined) {
      sectionRef.current?.scrollIntoView({ block: "nearest" });
    }
  }, [open, selectionToken]);

  return (
    <section ref={sectionRef} aria-labelledby={headingId} className="flex flex-col gap-4 rounded-xl border bg-card px-6 py-4">
      <div className="flex flex-wrap items-center gap-x-6 gap-y-2">
        <div className="flex min-w-[240px] flex-1 flex-col gap-0.5">
          <h2 id={headingId} className="text-base leading-6 font-semibold text-vxn-ink">
            Bản đồ điểm dừng
          </h2>
          <p className="text-xs leading-[18px] text-muted-foreground">
            {!open
              ? "Mở để xem vị trí các điểm đang có trong danh sách bên dưới."
              : points.length === 0
                ? "Danh sách bên dưới chưa có điểm nào để hiện trên bản đồ."
                : `Đang hiện ${points.length} điểm trong danh sách bên dưới. Bấm vào một ghim để xem nhanh, bấm vào dòng trong bảng để bản đồ chuyển tới điểm đó.`}
          </p>
        </div>
        {open && <MapLegend items={legend} />}
        <MapToggle open={open} controls={bodyId} onToggle={onOpenChange} />
      </div>

      <div id={bodyId} hidden={!open}>
        {open && (
          <MapView
            mapKey={mapKey}
            label="Bản đồ điểm dừng"
            className="h-80"
            fitPoints={fitPoints}
            focus={focus}
            cooperativeGestures
            onClick={() => onSelect(null)}
          >
            {points.map((item) => (
              <MapMarker key={item.id} point={item.point} zIndex={item.id === selected?.id ? 2 : 1}>
                <button
                  type="button"
                  aria-label={`Xem nhanh ${item.name}`}
                  aria-pressed={item.id === selected?.id}
                  className="block cursor-pointer rounded-full outline-none focus-visible:ring-[3px] focus-visible:ring-ring/60"
                  onClick={() => onSelect(item.id)}
                >
                  <MapDot kind={item.kind} className={item.id === selected?.id ? "size-[26px]" : undefined} />
                </button>
              </MapMarker>
            ))}
            {selected && (
              <MapPopup point={selected.point} offset={18}>
                <div
                  role="group"
                  aria-label={`Thông tin ${selected.name}`}
                  className="flex w-64 cursor-default items-start gap-2 rounded-lg border bg-card py-2.5 pr-2 pl-3 shadow-lg"
                >
                  <div className="flex min-w-0 flex-1 flex-col gap-0.5" role="status">
                    <span className="text-sm leading-5 font-semibold text-vxn-ink">{selected.name}</span>
                    <span className="text-xs leading-[18px] text-muted-foreground">{selected.address}</span>
                    <span className="text-xs leading-[18px] font-medium text-vxn-teal-700">{selected.meta}</span>
                  </div>
                  <button
                    type="button"
                    aria-label="Đóng thẻ xem nhanh"
                    className="flex size-6 shrink-0 cursor-pointer items-center justify-center rounded text-muted-foreground outline-none hover:bg-muted focus-visible:ring-[3px] focus-visible:ring-ring/50"
                    onClick={() => onSelect(null)}
                  >
                    <X className="size-4" />
                  </button>
                </div>
              </MapPopup>
            )}
          </MapView>
        )}
      </div>
    </section>
  );
}
