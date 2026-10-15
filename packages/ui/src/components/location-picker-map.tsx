"use client";

import { MapMarker, MapView, type MapFocus } from "@vexenhanh/ui/components/map";
import type { MapPoint } from "@vexenhanh/ui/lib/map";
import { useState } from "react";

import { roundPoint, samePoint, type MarkerKind } from "../../lib/map/stop-map";
import { MapDot } from "./map-parts";

// Gõ tọa độ bằng tay thì bản đồ phóng tới mức đủ để kiểm ghim nằm đúng chỗ.
const TYPED_FOCUS_ZOOM = 15;

/**
 * Bản đồ chọn vị trí trong hộp thoại điểm dừng (Figma "Vị trí trên bản đồ"; UI §7): bấm vào bản đồ để đặt
 * ghim, kéo ghim để chỉnh. Hai ô vĩ độ / kinh độ vẫn gõ tay được — gõ xong ghim nhảy theo.
 */
export function LocationPickerMap({
  mapKey,
  value,
  kind,
  onChange
}: {
  mapKey: string;
  /** Vị trí đang có trong hai ô nhập; `null` khi còn trống hoặc chưa hợp lệ. */
  value: MapPoint | null;
  kind: MarkerKind;
  onChange: (point: MapPoint) => void;
}) {
  // Khung nhìn ban đầu theo vị trí lúc mở hộp thoại; sau đó không tự đổi khi người dùng bấm / kéo ghim.
  const [initialPoints] = useState(() => (value ? [value] : []));
  // Vị trí bản đồ đã biết (lúc mở, hoặc lần bấm / kéo ghim gần nhất). Vị trí khác thế này là do gõ tay vào
  // ô nhập → đưa bản đồ tới đó.
  const [picked, setPicked] = useState<MapPoint | null>(value);
  const focus: MapFocus | null =
    value !== null && !samePoint(value, picked) ? { ...value, zoom: TYPED_FOCUS_ZOOM } : null;

  function pick(point: MapPoint) {
    const rounded = roundPoint(point);
    setPicked(rounded);
    onChange(rounded);
  }

  return (
    <div className="relative">
      <MapView
        mapKey={mapKey}
        label="Bản đồ chọn vị trí điểm dừng"
        className="h-60"
        fitPoints={initialPoints}
        focus={focus}
        onClick={pick}
      >
        {value && (
          <MapMarker point={value} draggable onDragEnd={pick}>
            <MapDot kind={kind} className="cursor-grab active:cursor-grabbing" />
          </MapMarker>
        )}
      </MapView>
      {/* Góc dưới trái: góc dưới phải là dòng ghi nguồn bản đồ, góc trên phải là nút phóng to / thu nhỏ. */}
      <p className="pointer-events-none absolute bottom-3 left-3 rounded-md border bg-card px-2.5 py-1 text-xs leading-[18px] text-vxn-fg-1 shadow-sm">
        {value ? "Bấm hoặc kéo ghim để chọn vị trí" : "Bấm vào bản đồ để đặt ghim"}
      </p>
    </div>
  );
}
