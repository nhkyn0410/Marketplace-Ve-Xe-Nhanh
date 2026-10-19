import { Bus, Calendar, ChevronRight, X } from "lucide-react";
import Link from "next/link";
import { formatVnd } from "../../lib/format";

/**
 * Gợi ý ngày đi gần nhất khi rỗng.
 */
export interface NearestDateSuggestion {
  readonly dateText: string;
  readonly tripCount: number;
}

/**
 * Tuyến phổ biến thay thế.
 */
export interface AlternativeRoute {
  readonly id: string;
  readonly fromCity: string;
  readonly toCity: string;
  readonly durationText: string;
  readonly frequencyText: string;
  readonly minPriceVnd: string;
  readonly imageUrl: string;
}

/**
 * Thuộc tính của component TripEmptyState.
 */
export interface TripEmptyStateProps {
  readonly nearestDateSuggestions?: readonly NearestDateSuggestion[];
  readonly alternativeRoutes?: readonly AlternativeRoute[];
}

/**
 * Component hiển thị trạng thái không tìm thấy chuyến xe (Figma 1450:22017).
 */
export function TripEmptyState({
  nearestDateSuggestions = [],
  alternativeRoutes = []
}: TripEmptyStateProps) {
  return (
    <div className="space-y-12">
      {/* Khối Thông báo rỗng */}
      <div className="flex flex-col items-center justify-center rounded-2xl border border-vxn-border bg-white px-6 py-16 text-center shadow-2xs">
        <div className="flex h-16 w-16 items-center justify-center rounded-full bg-teal-50 text-vxn-teal-700">
          <Bus className="h-8 w-8" />
        </div>

        <h3 className="mt-5 text-xl font-black text-vxn-ink sm:text-2xl">
          Chưa có chuyến phù hợp cho ngày 16/10/2026
        </h3>

        <p className="mt-2 max-w-lg text-xs leading-relaxed text-vxn-fg-3 sm:text-sm">
          Không có chuyến nào đang mở bán và còn đủ 2 chỗ cho tuyến này. Thử đổi ngày đi hoặc chọn địa danh khác gần đó.
        </p>

        {/* Ngày gần nhất có chuyến */}
        <div className="mt-6 flex flex-wrap items-center justify-center gap-2 text-xs">
          <span className="font-medium text-vxn-fg-4">Ngày gần nhất có chuyến:</span>
          {nearestDateSuggestions.map((s, idx) => (
            <button
              key={idx}
              type="button"
              className="inline-flex items-center gap-1.5 rounded-lg border border-vxn-border bg-vxn-bg-soft px-3 py-1.5 font-semibold text-vxn-teal-800 transition hover:border-vxn-teal-500"
            >
              <Calendar className="h-3.5 w-3.5 text-vxn-teal-600" />
              <span>{s.dateText} • {s.tripCount} chuyến</span>
            </button>
          ))}
        </div>

        {/* 2 Nút thao tác */}
        <div className="mt-8 flex flex-wrap items-center justify-center gap-3">
          <button
            type="button"
            className="inline-flex items-center gap-1.5 rounded-xl border border-vxn-border bg-white px-5 py-2.5 text-xs font-bold text-vxn-fg-2 shadow-2xs transition hover:bg-vxn-bg-soft"
          >
            <X className="h-4 w-4" />
            <span>Xóa bộ lọc</span>
          </button>
          <button
            type="button"
            className="inline-flex items-center gap-1.5 rounded-xl bg-[#00506a] px-5 py-2.5 text-xs font-bold text-white shadow-xs transition hover:bg-[#00476b]"
          >
            <Calendar className="h-4 w-4" />
            <span>Đổi ngày đi</span>
          </button>
        </div>
      </div>

      {/* Tuyến phổ biến từ TP. Hồ Chí Minh */}
      <div>
        <h3 className="text-lg font-black text-vxn-ink sm:text-xl">
          Tuyến phổ biến từ TP. Hồ Chí Minh
        </h3>

        <div className="mt-4 grid grid-cols-1 gap-6 sm:grid-cols-2 lg:grid-cols-3">
          {alternativeRoutes.map((route) => (
            <div
              key={route.id}
              className="flex flex-col overflow-hidden rounded-2xl border border-vxn-border bg-white shadow-2xs transition hover:shadow-md"
            >
              <div
                className="h-40 w-full bg-cover bg-center"
                style={{ backgroundImage: `url('${route.imageUrl}')` }}
              />
              <div className="flex flex-1 flex-col justify-between p-4">
                <div>
                  <h4 className="text-base font-bold text-vxn-ink">
                    {route.fromCity} &rarr; {route.toCity}
                  </h4>
                  <p className="mt-1 text-xs text-vxn-fg-4">
                    {route.durationText} • {route.frequencyText}
                  </p>
                </div>

                <div className="mt-4 flex items-center justify-between border-t border-vxn-border/60 pt-3">
                  <div>
                    <span className="text-2xs text-vxn-fg-4">Từ </span>
                    <span className="text-sm font-black text-vxn-teal-800">
                      {formatVnd(route.minPriceVnd)}
                    </span>
                  </div>
                  <Link
                    href={`/trips?from=${encodeURIComponent(route.fromCity)}&to=${encodeURIComponent(route.toCity)}`}
                    className="inline-flex items-center text-xs font-bold text-vxn-teal-700 hover:underline"
                  >
                    <span>Xem chuyến</span>
                    <ChevronRight className="h-3.5 w-3.5" />
                  </Link>
                </div>
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}
