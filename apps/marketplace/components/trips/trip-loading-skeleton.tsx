import { Loader2 } from "lucide-react";

/**
 * Trạng thái đang tải dữ liệu tìm chuyến xe (Figma 1450:22373).
 */
export function TripLoadingSkeleton() {
  return (
    <div className="space-y-6">
      {/* Header trạng thái loading */}
      <div className="flex items-center gap-2.5 text-sm font-bold text-vxn-ink">
        <Loader2 className="h-5 w-5 animate-spin text-vxn-teal-700" />
        <span>Đang tìm chuyến...</span>
      </div>

      {/* 3 Khối Card Skeleton mô phỏng Figma */}
      <div className="space-y-4">
        {[1, 2, 3].map((i) => (
          <div
            key={i}
            className="flex flex-col overflow-hidden rounded-2xl border border-vxn-border bg-white shadow-2xs md:flex-row"
          >
            {/* Khối ảnh bên trái */}
            <div className="h-44 w-full shrink-0 bg-vxn-bg-mist md:h-auto md:w-56 lg:w-64 animate-pulse" />

            {/* Nội dung bên phải */}
            <div className="flex flex-1 flex-col justify-between p-5 space-y-4">
              <div>
                <div className="flex items-center justify-between">
                  <div className="h-5 w-40 rounded-lg bg-vxn-bg-mist animate-pulse" />
                  <div className="h-5 w-24 rounded-lg bg-vxn-bg-mist animate-pulse" />
                </div>
                <div className="mt-4 flex items-center gap-8">
                  <div className="h-8 w-20 rounded-lg bg-vxn-bg-mist animate-pulse" />
                  <div className="h-3 w-28 rounded-lg bg-vxn-bg-mist animate-pulse" />
                  <div className="h-8 w-20 rounded-lg bg-vxn-bg-mist animate-pulse" />
                </div>
                <div className="mt-4 h-4 w-72 rounded-lg bg-vxn-bg-mist animate-pulse" />
              </div>

              <div className="flex items-center justify-between border-t border-vxn-border/50 pt-3">
                <div className="h-6 w-32 rounded-lg bg-vxn-bg-mist animate-pulse" />
                <div className="h-9 w-28 rounded-xl bg-vxn-bg-mist animate-pulse" />
              </div>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}
