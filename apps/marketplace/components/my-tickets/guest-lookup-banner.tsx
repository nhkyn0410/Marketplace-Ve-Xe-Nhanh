import Link from "next/link";
import { Search, ArrowRight } from "lucide-react";

/**
 * Banner hướng dẫn tra cứu vé cho khách chưa đăng nhập theo Figma 1445:14030.
 */
export function GuestLookupBanner() {
  return (
    <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 rounded-2xl border border-vxn-border bg-neutral-50/80 p-4 sm:p-5">
      <div className="flex items-center gap-3 text-xs sm:text-sm text-neutral-600">
        <Search className="h-4 w-4 text-neutral-400 shrink-0" />
        <span>
          Đã đặt vé khi chưa đăng nhập? Tra cứu bằng mã đặt vé và email liên hệ.
        </span>
      </div>

      <Link
        href="/tickets/lookup"
        className="inline-flex items-center justify-center gap-1.5 self-start sm:self-auto rounded-xl border border-neutral-300 bg-white px-4 py-2 text-xs sm:text-sm font-semibold text-neutral-800 transition hover:bg-neutral-50 shrink-0"
      >
        <span>Tra cứu vé</span>
        <ArrowRight className="h-3.5 w-3.5 text-neutral-400" />
      </Link>
    </div>
  );
}
