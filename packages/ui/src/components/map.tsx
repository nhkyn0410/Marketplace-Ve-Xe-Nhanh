"use client";

import "maplibre-gl/dist/maplibre-gl.css";

import { CircleAlert, RefreshCw } from "lucide-react";
import type { GeoJSONSource, Map as MapLibreMap, Marker, Popup, PositionAnchor } from "maplibre-gl";
import { createContext, useContext, useEffect, useId, useRef, useState, type ReactNode } from "react";
import { createPortal } from "react-dom";

import { boundsOf, goongStyleUrl, pointsKey, VIETNAM_BOUNDS, type MapPoint } from "../lib/map";
import { cn } from "../lib/utils";
import { Button } from "./button";
import { Skeleton } from "./skeleton";

type MapLibrary = typeof import("maplibre-gl");
type MapContextValue = { map: MapLibreMap; library: MapLibrary };

const MapContext = createContext<MapContextValue | null>(null);

// Bản đồ đã bị hủy: phần con (đường nối) dọn dẹp sau đó không được gọi vào nó nữa.
const removedMaps = new WeakSet<MapLibreMap>();

const FIT_PADDING = 40;
const FIT_MAX_ZOOM = 14;

/** Chữ của các nút do thư viện vẽ. */
const LOCALE = {
  "AttributionControl.ToggleAttribution": "Hiện / ẩn nguồn bản đồ",
  "NavigationControl.ZoomIn": "Phóng to",
  "NavigationControl.ZoomOut": "Thu nhỏ",
  "CooperativeGesturesHandler.WindowsHelpText": "Giữ Ctrl và cuộn để phóng to bản đồ",
  "CooperativeGesturesHandler.MacHelpText": "Giữ ⌘ và cuộn để phóng to bản đồ",
  "CooperativeGesturesHandler.MobileHelpText": "Dùng hai ngón tay để di chuyển bản đồ"
};

let libraryPromise: Promise<MapLibrary> | null = null;

/** Tải thư viện vẽ bản đồ khi cần lần đầu (khoảng 1 MB) — trang không mở bản đồ thì không phải tải. */
function loadLibrary(): Promise<MapLibrary> {
  libraryPromise ??= import("maplibre-gl").then(
    (library) => {
      // Bản 6 chạy phần xử lý nền ở một file riêng; bundler không tự suy ra được nên phải chỉ đường dẫn.
      library.setWorkerUrl(new URL("maplibre-gl/dist/maplibre-gl-worker.mjs", import.meta.url).href);
      return library;
    },
    (error: unknown) => {
      // Lần sau thử tải lại thay vì giữ mãi kết quả lỗi.
      libraryPromise = null;
      throw error;
    }
  );
  return libraryPromise;
}

/** Điểm bản đồ cần chuyển tới. Đổi `token` để chuyển lại tới đúng điểm cũ sau khi người dùng đã kéo đi chỗ khác. */
export type MapFocus = MapPoint & { zoom?: number; token?: string | number };

type MapProblem = "error" | "unsupported";

/**
 * Bản đồ nền Goong (ADR-027) vẽ bằng MapLibre. Ghim, thẻ nổi và đường nối là phần tử con (`MapMarker`,
 * `MapPopup`, `MapLine`).
 * Không có nguồn bản đồ nền dự phòng: tải lỗi thì hiện thông báo, không vẽ bản đồ khác thay thế.
 */
export function MapView({
  mapKey,
  label,
  className,
  fitPoints,
  focus = null,
  cooperativeGestures = false,
  onClick,
  children
}: {
  /** Khóa Goong Maptiles (khóa công khai phía trình duyệt). */
  mapKey: string;
  /** Tên bản đồ cho trình đọc màn hình. */
  label: string;
  /** Phải đặt chiều cao (vd `h-80`). */
  className?: string;
  /** Khung nhìn bao các điểm này và đổi theo khi tập điểm đổi; trống = toàn Việt Nam. */
  fitPoints?: readonly MapPoint[];
  focus?: MapFocus | null;
  /** Bản đồ nằm trong trang cuộn: phải giữ Ctrl mới phóng to bằng con lăn, để cuộn trang không bị bản đồ giữ lại. */
  cooperativeGestures?: boolean;
  /** Bấm vào nền bản đồ (không tính bấm vào ghim). */
  onClick?: (point: MapPoint) => void;
  children?: ReactNode;
}) {
  const containerRef = useRef<HTMLDivElement>(null);
  const fittedMapRef = useRef<MapLibreMap | null>(null);
  const onClickRef = useRef(onClick);
  const [context, setContext] = useState<MapContextValue | null>(null);
  const [problem, setProblem] = useState<MapProblem | null>(null);
  const [attempt, setAttempt] = useState(0);

  useEffect(() => {
    onClickRef.current = onClick;
  });

  useEffect(() => {
    const container = containerRef.current;
    if (!container) {
      return;
    }
    let cancelled = false;
    let map: MapLibreMap | null = null;

    loadLibrary()
      .then((library) => {
        if (cancelled) {
          return;
        }
        let created: MapLibreMap;
        try {
          created = new library.Map({
            container,
            style: goongStyleUrl(mapKey),
            bounds: [VIETNAM_BOUNDS.west, VIETNAM_BOUNDS.south, VIETNAM_BOUNDS.east, VIETNAM_BOUNDS.north],
            // Dòng ghi nguồn ("© Goong Maps") có sẵn trong bản đồ nền của Goong, không tự thêm nữa kẻo lặp.
            attributionControl: { compact: true },
            cooperativeGestures,
            // Bản đồ luôn hướng bắc, nhìn thẳng từ trên xuống.
            dragRotate: false,
            touchPitch: false,
            locale: { ...LOCALE, "Map.Title": label }
          });
        } catch {
          // Trình duyệt không có WebGL2 (thư viện bắt buộc).
          setProblem("unsupported");
          return;
        }
        map = created;
        created.touchZoomRotate.disableRotation();
        created.keyboard.disableRotation();
        created.addControl(new library.NavigationControl({ showCompass: false }), "top-right");

        let loaded = false;
        created.on("load", () => {
          loaded = true;
          if (!cancelled) {
            setProblem(null);
            setContext({ map: created, library });
          }
        });
        created.on("error", () => {
          // Lỗi sau khi bản đồ đã lên (một ô bản đồ tải hỏng) không che bản đồ đang dùng.
          if (!loaded && !cancelled) {
            setProblem("error");
          }
        });
        created.on("click", (event) => {
          const target = event.originalEvent.target;
          if (target instanceof Element && target.closest(".maplibregl-marker")) {
            return;
          }
          onClickRef.current?.({ latitude: event.lngLat.lat, longitude: event.lngLat.lng });
        });
      })
      .catch(() => {
        if (!cancelled) {
          setProblem("error");
        }
      });

    return () => {
      cancelled = true;
      setContext(null);
      if (map) {
        removedMaps.add(map);
        map.remove();
      }
    };
  }, [mapKey, label, cooperativeGestures, attempt]);

  const { west, south, east, north } = boundsOf(fitPoints ?? []) ?? VIETNAM_BOUNDS;
  useEffect(() => {
    if (!context) {
      return;
    }
    // Lần đầu đặt khung nhìn ngay; các lần sau trượt tới để người dùng thấy bản đồ đổi.
    const first = fittedMapRef.current !== context.map;
    fittedMapRef.current = context.map;
    context.map.fitBounds([west, south, east, north], { padding: FIT_PADDING, maxZoom: FIT_MAX_ZOOM, animate: !first });
  }, [context, west, south, east, north]);

  const focusLatitude = focus?.latitude;
  const focusLongitude = focus?.longitude;
  const focusZoom = focus?.zoom;
  const focusToken = focus?.token;
  useEffect(() => {
    if (!context || focusLatitude === undefined || focusLongitude === undefined) {
      return;
    }
    const { map } = context;
    const center: [number, number] = [focusLongitude, focusLatitude];
    map.easeTo(focusZoom === undefined ? { center } : { center, zoom: Math.max(map.getZoom(), focusZoom) });
  }, [context, focusLatitude, focusLongitude, focusZoom, focusToken]);

  return (
    <div className={cn("relative isolate overflow-hidden rounded-lg bg-vxn-bg-mist", className)}>
      <div ref={containerRef} className="size-full" />
      {!context && !problem && (
        <Skeleton role="status" aria-label="Đang tải bản đồ" className="absolute inset-0 rounded-none" />
      )}
      {problem && (
        <div
          role="alert"
          className="absolute inset-0 flex flex-col items-center justify-center gap-2 bg-card px-4 text-center"
        >
          <CircleAlert className="size-6 text-warning-700" aria-hidden />
          <p className="text-sm leading-5 font-semibold text-vxn-ink">
            {problem === "unsupported" ? "Trình duyệt này không hiển thị được bản đồ" : "Không tải được bản đồ"}
          </p>
          <p className="max-w-sm text-xs leading-[18px] text-muted-foreground">
            {problem === "unsupported"
              ? "Bạn vẫn dùng được các phần còn lại của trang."
              : "Kiểm tra kết nối mạng rồi thử lại. Các phần còn lại của trang vẫn dùng được."}
          </p>
          {problem === "error" && (
            <Button
              type="button"
              variant="outline"
              className="mt-1 h-9 rounded-lg bg-card px-3 text-sm font-semibold"
              onClick={() => {
                setProblem(null);
                setAttempt((current) => current + 1);
              }}
            >
              <RefreshCw className="size-4" />
              Thử lại
            </Button>
          )}
        </div>
      )}
      {context && <MapContext.Provider value={context}>{children}</MapContext.Provider>}
    </div>
  );
}

/**
 * Một ghim trên bản đồ; nội dung ghim là phần tử con (nút, chấm màu, thẻ thông tin…). Đặt trong `MapView`.
 */
export function MapMarker({
  point,
  anchor = "center",
  offset,
  zIndex,
  draggable = false,
  onDragEnd,
  children
}: {
  point: MapPoint;
  /** Phần nào của ghim nằm đúng tại tọa độ. */
  anchor?: PositionAnchor;
  /** Lệch so với tọa độ, tính bằng pixel `[ngang, dọc]`. */
  offset?: readonly [number, number];
  zIndex?: number;
  draggable?: boolean;
  onDragEnd?: (point: MapPoint) => void;
  children: ReactNode;
}) {
  const context = useContext(MapContext);
  const [element] = useState(() => document.createElement("div"));
  const { latitude, longitude } = point;
  const [offsetX, offsetY] = offset ?? [0, 0];
  const markerRef = useRef<Marker | null>(null);
  const positionRef = useRef<[number, number]>([longitude, latitude]);
  const onDragEndRef = useRef(onDragEnd);

  useEffect(() => {
    onDragEndRef.current = onDragEnd;
  });

  // Chạy trước hiệu ứng tạo ghim bên dưới, nên ghim mới luôn được đặt ở tọa độ mới nhất.
  useEffect(() => {
    positionRef.current = [longitude, latitude];
    markerRef.current?.setLngLat([longitude, latitude]);
  }, [latitude, longitude]);

  useEffect(() => {
    if (!context) {
      return;
    }
    const marker = new context.library.Marker({ element, anchor, offset: [offsetX, offsetY], draggable })
      .setLngLat(positionRef.current)
      .addTo(context.map);
    marker.on("dragend", () => {
      const position = marker.getLngLat();
      onDragEndRef.current?.({ latitude: position.lat, longitude: position.lng });
    });
    markerRef.current = marker;
    return () => {
      markerRef.current = null;
      marker.remove();
    };
  }, [context, element, anchor, offsetX, offsetY, draggable]);

  useEffect(() => {
    element.style.zIndex = zIndex === undefined ? "" : String(zIndex);
  }, [element, zIndex]);

  return createPortal(children, element);
}

/**
 * Thẻ nổi cạnh một điểm trên bản đồ (thẻ thông tin, nhãn). Thư viện tự chọn phía đặt thẻ để thẻ không bị mép
 * bản đồ cắt mất. Khung của thẻ do phần tử con tự vẽ. Đặt trong `MapView`.
 */
export function MapPopup({
  point,
  offset = 12,
  children
}: {
  point: MapPoint;
  /** Khoảng cách từ điểm tới thẻ, tính bằng pixel. */
  offset?: number;
  children: ReactNode;
}) {
  const context = useContext(MapContext);
  const [element] = useState(() => document.createElement("div"));
  const { latitude, longitude } = point;
  const popupRef = useRef<Popup | null>(null);
  const positionRef = useRef<[number, number]>([longitude, latitude]);

  // Chạy trước hiệu ứng tạo thẻ bên dưới, nên thẻ mới luôn được đặt ở tọa độ mới nhất.
  useEffect(() => {
    positionRef.current = [longitude, latitude];
    popupRef.current?.setLngLat([longitude, latitude]);
  }, [latitude, longitude]);

  useEffect(() => {
    if (!context) {
      return;
    }
    const popup = new context.library.Popup({
      className: "vxn-map-popup",
      offset,
      maxWidth: "none",
      // Việc mở / đóng do nơi dùng quyết định, thư viện không tự đóng và không giành tiêu điểm.
      closeButton: false,
      closeOnClick: false,
      focusAfterOpen: false
    })
      .setLngLat(positionRef.current)
      .setDOMContent(element)
      .addTo(context.map);
    popupRef.current = popup;
    return () => {
      popupRef.current = null;
      popup.remove();
    };
  }, [context, element, offset]);

  return createPortal(children, element);
}

/** Đường gấp khúc nối các điểm theo thứ tự (đường thẳng giữa hai điểm, không phải đường đi thực tế). */
export function MapLine({
  points,
  color,
  width = 2,
  dashed = false
}: {
  points: readonly MapPoint[];
  /** Mã màu dạng `#rrggbb` — lớp vẽ của bản đồ không đọc được biến CSS. */
  color: string;
  width?: number;
  dashed?: boolean;
}) {
  const context = useContext(MapContext);
  const id = `vxn-line-${useId()}`;
  const key = pointsKey(points);
  const pointsRef = useRef(points);

  useEffect(() => {
    pointsRef.current = points;
  });

  useEffect(() => {
    if (!context) {
      return;
    }
    const { map } = context;
    map.addSource(id, { type: "geojson", data: lineOf([]) });
    map.addLayer({
      id,
      type: "line",
      source: id,
      paint: { "line-color": color, "line-width": width, ...(dashed ? { "line-dasharray": [3, 2] } : {}) }
    });
    return () => {
      if (removedMaps.has(map)) {
        return;
      }
      map.removeLayer(id);
      map.removeSource(id);
    };
  }, [context, id, color, width, dashed]);

  // Khai báo sau hiệu ứng tạo lớp vẽ: lớp vừa tạo (hoặc tạo lại) luôn được nạp dãy điểm hiện tại.
  useEffect(() => {
    context?.map.getSource<GeoJSONSource>(id)?.setData(lineOf(pointsRef.current));
  }, [context, id, key, color, width, dashed]);

  return null;
}

function lineOf(points: readonly MapPoint[]) {
  return {
    type: "Feature" as const,
    properties: {},
    geometry: {
      type: "LineString" as const,
      coordinates: points.map((point) => [point.longitude, point.latitude])
    }
  };
}
