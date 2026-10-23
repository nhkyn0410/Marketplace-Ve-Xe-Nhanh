import Link from "next/link";
import { Ticket, Search, Compass } from "lucide-react";

/**
 * Trạng thái chưa có chuyến đi nào theo Figma 1450:23264.
 */
export function TicketsEmptyCard() {
  return (
    <div className="rounded-3xl border border-vxn-border bg-white p-8 sm:p-14 text-center shadow-xs">
      {/* Icon vé xe trong vòng tròn */}
      <div className="mx-auto flex h-16 w-16 items-center justify-center rounded-2xl bg-teal-50 text-vxn-teal-800 border border-teal-100">
        <Ticket className="h-8 w-8" />
      </div>

      <h3 className="mt-5 text-lg sm:text-xl font-black text-vxn-ink">
        Bạn chưa có chuyến sắp tới
      </h3>

      <p className="mt-2 text-xs sm:text-sm text-vxn-fg-4 max-w-md mx-auto leading-relaxed">
        Vé bạn đặt khi đã đăng nhập sẽ hiện ở đây. Vé đặt lúc chưa đăng nhập có thể tra cứu bằng mã đặt vé và email.
      </p>

      {/* 2 nút điều hướng */}
      <div className="mt-6 flex flex-col sm:flex-row items-center justify-center gap-3">
        <Link
          href="/tickets/lookup"
          className="inline-flex w-full sm:w-auto items-center justify-center gap-2 rounded-xl border border-neutral-300 bg-white px-5 py-2.5 text-xs sm:text-sm font-semibold text-neutral-800 transition hover:bg-neutral-50"
        >
          <Search className="h-4 w-4 text-neutral-500" />
          <span>Tra cứu vé khách vãng lai</span>
        </Link>

        <Link
          href="/trips"
          className="inline-flex w-full sm:w-auto items-center justify-center gap-2 rounded-xl bg-[#00506a] px-6 py-2.5 text-xs sm:text-sm font-bold text-white shadow-xs transition hover:bg-[#00476b] active:scale-[0.99]"
        >
          <Compass className="h-4 w-4" />
          <span>Tìm chuyến</span>
        </Link>
      </div>
    </div>
  );
}
