import Link from "next/link";
import { Plus } from "lucide-react";

/**
 * Header trang Hành trình của tôi theo Figma 1445:14030.
 */
export function TicketsHeader() {
  return (
    <div className="flex flex-col gap-4 sm:flex-row sm:items-center sm:justify-between">
      <div>
        <h1 className="text-xl sm:text-2xl font-black text-vxn-ink">
          Hành trình của tôi
        </h1>
        <p className="mt-1 text-xs sm:text-sm text-vxn-fg-4">
          Xem vé đã đặt, theo dõi hoàn tiền và đánh giá chuyến đã đi.
        </p>
      </div>

      <Link
        href="/trips"
        className="inline-flex items-center justify-center gap-1.5 self-start sm:self-auto rounded-xl bg-[#00506a] px-5 py-2.5 text-xs sm:text-sm font-bold text-white shadow-xs transition hover:bg-[#00476b] active:scale-[0.99]"
      >
        <Plus className="h-4 w-4" />
        <span>Đặt vé mới</span>
      </Link>
    </div>
  );
}
