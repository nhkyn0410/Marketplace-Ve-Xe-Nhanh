"use client";

import { MapLine, MapMarker, MapPopup, MapView } from "@vexenhanh/ui/components/map";
import { useId, useMemo } from "react";

import { routeMapCandidates, routeMapStops, type MapLegendItem } from "../../lib/map/stop-map";
import type { DraftStop, StopCandidate } from "../../lib/route/route-form";
import { MapLegend, MapToggle } from "./map-parts";

// Màu `--primary` của giao diện; lớp vẽ của bản đồ không đọc được biến CSS nên phải ghi mã màu.
const LINE_COLOR = "#006481";

const TONE_CLASS = {
  primary: "bg-primary text-primary-foreground",
  // Chữ đậm trên nền vàng để số thứ tự đọc được (Figma dùng chữ trắng, độ tương phản quá thấp).
  amber: "bg-vxn-saffron-500 text-vxn-ink"
} as const;

const LEGEND: MapLegendItem[] = [
  { kind: "busStation", label: "Điểm đón / trả khách" },
  { kind: "restStop", label: "Trạm dừng nghỉ" }
];
const PICKER_LEGEND: MapLegendItem[] = [...LEGEND, { kind: "muted", label: "Điểm trong bảng chọn" }];

/**
 * Thẻ "Lộ trình trên bản đồ" của form tuyến (Figma "Route map"; UI §7): ghim đánh số theo thứ tự điểm dừng,
 * nối bằng đường thẳng nét đứt. Khi bảng chọn điểm dừng đang mở, các điểm trong bảng hiện bằng chấm xám để
 * thấy điểm sắp thêm nằm ở đâu so với tuyến.
 */
export function RouteMap({
  mapKey,
  stops,
  candidates,
  highlightedKey,
  pickerOpen,
  open,
  onOpenChange
}: {
  mapKey: string;
  stops: DraftStop[];
  /** Các điểm bảng chọn đang liệt kê. */
  candidates: readonly StopCandidate[];
  /** Khóa (`stopKey`) của dòng đang được rê chuột / đưa tiêu điểm tới trong bảng chọn. */
  highlightedKey: string | null;
  pickerOpen: boolean;
  open: boolean;
  onOpenChange: (open: boolean) => void;
}) {
  const headingId = useId();
  const bodyId = useId();
  const markers = useMemo(() => routeMapStops(stops), [stops]);
  const dots = useMemo(
    () => (pickerOpen ? routeMapCandidates(stops, candidates, highlightedKey) : []),
    [pickerOpen, stops, candidates, highlightedKey]
  );
  const line = useMemo(() => markers.map((marker) => marker.point), [markers]);
  // Bảng chọn đang mở thì khung nhìn bao cả các điểm trong bảng, để chấm xám không nằm ngoài bản đồ.
  const fitPoints = useMemo(() => [...line, ...dots.map((dot) => dot.point)], [line, dots]);
  const highlighted = dots.find((dot) => dot.highlighted) ?? null;

  return (
    <section aria-labelledby={headingId} className="flex flex-col gap-4 rounded-xl border bg-card p-6">
      <div className="flex items-start gap-3">
        <div className="flex min-w-0 flex-1 flex-col gap-1">
          <h2 id={headingId} className="text-base leading-6 font-semibold text-vxn-ink">
            Lộ trình trên bản đồ
          </h2>
          <p className="text-xs leading-[18px] text-muted-foreground">
            Cập nhật ngay khi thêm, bỏ hoặc đổi thứ tự điểm dừng.
          </p>
        </div>
        <MapToggle open={open} controls={bodyId} onToggle={onOpenChange} />
      </div>

      <div id={bodyId} hidden={!open} className="flex flex-col gap-4">
        {open && (
          <>
            <MapView
              mapKey={mapKey}
              label="Bản đồ lộ trình của tuyến"
              className="h-[260px]"
              fitPoints={fitPoints}
              cooperativeGestures
            >
              {line.length > 1 && <MapLine points={line} color={LINE_COLOR} dashed />}
              {dots.map((dot) => (
                <MapMarker key={dot.key} point={dot.point} zIndex={dot.highlighted ? 3 : 1}>
                  <span
                    aria-hidden
                    className={
                      dot.highlighted
                        ? "block size-[18px] rounded-full border-2 border-card bg-primary shadow-md"
                        : "block size-3.5 rounded-full border-2 border-card bg-vxn-fg-5 shadow"
                    }
                  />
                </MapMarker>
              ))}
              {markers.map((marker) => (
                <MapMarker key={marker.key} point={marker.point} zIndex={2}>
                  <span
                    role="img"
                    aria-label={`Điểm ${marker.order}: ${marker.name}`}
                    title={marker.name}
                    className={`flex size-[26px] items-center justify-center rounded-full border-2 border-card text-xs leading-none font-semibold shadow-md ${TONE_CLASS[marker.tone]}`}
                  >
                    {marker.order}
                  </span>
                </MapMarker>
              ))}
              {highlighted && (
                <MapPopup point={highlighted.point} offset={14}>
                  <div aria-hidden className="flex max-w-48 flex-col rounded-md border bg-card px-2.5 py-1.5 shadow-lg">
                    <span className="text-xs leading-[18px] font-semibold text-vxn-ink">{highlighted.name}</span>
                    <span className="text-xs leading-[18px] text-muted-foreground">Chưa có trong tuyến</span>
                  </div>
                </MapPopup>
              )}
            </MapView>
            <MapLegend items={pickerOpen ? PICKER_LEGEND : LEGEND} />
            <p className="text-xs leading-[18px] text-muted-foreground">
              Đường nối thẳng giữa các điểm chỉ để xem thứ tự và vị trí. Quãng đường thực tế do hệ thống tính khi lưu.
            </p>
          </>
        )}
      </div>
    </section>
  );
}
