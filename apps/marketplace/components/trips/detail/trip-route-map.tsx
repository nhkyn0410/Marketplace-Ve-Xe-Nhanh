import type { TripTimelineStop } from "../../../lib/data/types";

/** Thuộc tính của sơ đồ vị trí các điểm dừng. */
interface TripRouteMapProps {
  readonly timeline: readonly TripTimelineStop[];
}

/** Hiển thị vị trí từ tọa độ điểm dừng; sơ đồ không mô phỏng đường đi trên bản đồ. */
export function TripRouteMap({ timeline }: TripRouteMapProps) {
  const stops = timeline.filter((stop): stop is TripTimelineStop & { readonly lat: number; readonly lng: number } =>
    typeof stop.lat === "number" && typeof stop.lng === "number" && Number.isFinite(stop.lat) && Number.isFinite(stop.lng));
  if (!stops.length) return null;
  const minLat = Math.min(...stops.map((stop) => stop.lat));
  const maxLat = Math.max(...stops.map((stop) => stop.lat));
  const minLng = Math.min(...stops.map((stop) => stop.lng));
  const maxLng = Math.max(...stops.map((stop) => stop.lng));
  const points = stops.map((stop) => ({ ...stop,
    x: maxLng === minLng ? 400 : 40 + (stop.lng - minLng) / (maxLng - minLng) * 720,
    y: maxLat === minLat ? 140 : 240 - (stop.lat - minLat) / (maxLat - minLat) * 200
  }));
  return (
    <div className="space-y-4 rounded-2xl border border-neutral-200 bg-white p-6 shadow-xs">
      <h3 className="text-base font-semibold text-neutral-900">Vị trí các điểm dừng</h3>
      <p className="text-xs text-neutral-500">Sơ đồ vị trí theo tọa độ. Xem địa chỉ và thời gian tại mục Lịch trình và điểm dừng.</p>
      <svg viewBox="0 0 800 280" role="img" aria-label="Sơ đồ vị trí các điểm dừng theo tọa độ" className="w-full rounded-xl border border-neutral-200 bg-neutral-50">
        {points.map((point, index) => <g key={`${point.stationName}-${index}`}><title>{point.stationName}</title><circle cx={point.x} cy={point.y} r="12" fill={point.isRestStop ? "#b45309" : "#00506a"} /><text x={point.x} y={point.y + 4} fill="white" fontSize="12" textAnchor="middle">{index + 1}</text></g>)}
      </svg>
      <ol className="grid gap-2 text-xs text-neutral-600 sm:grid-cols-2">{points.map((point, index) => <li key={`${point.stationName}-${index}`}><span className="font-semibold">{index + 1}. {point.stationName}</span><span className="mt-0.5 block text-neutral-400">{point.lat.toFixed(5)}, {point.lng.toFixed(5)}</span></li>)}</ol>
    </div>
  );
}
