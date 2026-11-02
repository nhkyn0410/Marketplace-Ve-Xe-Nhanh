"use client";

import { MapMarker, MapView } from "@vexenhanh/ui/components/map";
import { isValidPoint } from "@vexenhanh/ui/lib/map";
import { GOONG_MAPTILES_KEY } from "@vexenhanh/ui/lib/map-config";

import type { TripTimelineStop } from "../../../lib/data/types";

/** Thuộc tính của sơ đồ vị trí các điểm dừng. */
interface TripRouteMapProps {
  readonly timeline: readonly TripTimelineStop[];
}

/** Hiển thị bản đồ Goong và danh sách vị trí các điểm dừng của chuyến. */
export function TripRouteMap({ timeline }: TripRouteMapProps) {
  const stops = timeline.filter((stop): stop is TripTimelineStop & { readonly lat: number; readonly lng: number } =>
    typeof stop.lat === "number" && typeof stop.lng === "number" && isValidPoint({ latitude: stop.lat, longitude: stop.lng }));
  if (!stops.length) return null;
  const points = stops.map((stop) => ({ latitude: stop.lat, longitude: stop.lng }));
  return (
    <div className="space-y-4 rounded-2xl border border-neutral-200 bg-white p-6 shadow-xs">
      <h3 className="text-base font-semibold text-neutral-900">Vị trí các điểm dừng</h3>
      <p className="text-xs text-neutral-500">Xem địa chỉ và thời gian tại mục Lịch trình và điểm dừng.</p>
      {GOONG_MAPTILES_KEY && (
        <MapView
          mapKey={GOONG_MAPTILES_KEY}
          label="Bản đồ vị trí các điểm dừng"
          className="h-64 border border-neutral-200 sm:h-80"
          fitPoints={points}
          cooperativeGestures
        >
          {stops.map((stop, index) => (
            <MapMarker key={`${stop.stationName}-${index}`} point={points[index]}>
              <span
                role="img"
                aria-label={`Điểm ${index + 1}: ${stop.stationName}`}
                title={stop.stationName}
                className={`flex size-7 items-center justify-center rounded-full border-2 border-white text-xs font-semibold text-white shadow-md ${stop.isRestStop ? "bg-warning-700" : "bg-vxn-teal-700"}`}
              >
                {index + 1}
              </span>
            </MapMarker>
          ))}
        </MapView>
      )}
      <ol className="grid gap-2 text-xs text-neutral-600 sm:grid-cols-2">{stops.map((stop, index) => <li key={`${stop.stationName}-${index}`}><span className="font-semibold">{index + 1}. {stop.stationName}</span><span className="mt-0.5 block text-neutral-400">{stop.lat.toFixed(5)}, {stop.lng.toFixed(5)}</span></li>)}</ol>
    </div>
  );
}
