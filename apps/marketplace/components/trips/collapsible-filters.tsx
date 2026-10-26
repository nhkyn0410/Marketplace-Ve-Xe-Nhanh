"use client";

import { cn } from "@vexenhanh/ui/lib/utils";
import { ChevronDown, SlidersHorizontal } from "lucide-react";
import { useState, type ReactNode } from "react";

/**
 * Cột bộ lọc trang danh sách chuyến: luôn mở trên desktop (280px), thu gọn sau nút "Bộ lọc" trên mobile
 * để kết quả chuyến không bị đẩy xuống dưới cả màn hình.
 */
export function CollapsibleFilters({ children }: { readonly children: ReactNode }) {
  const [open, setOpen] = useState(false);
  return (
    <div className="w-full shrink-0 lg:w-[280px]">
      <button
        type="button"
        onClick={() => setOpen((value) => !value)}
        aria-expanded={open}
        className="flex w-full items-center justify-between rounded-2xl border border-slate-200 bg-white px-4 py-3 text-sm font-bold text-slate-900 shadow-2xs lg:hidden"
      >
        <span className="flex items-center gap-2">
          <SlidersHorizontal className="h-4 w-4 text-[#00506a]" />
          Bộ lọc
        </span>
        <ChevronDown className={cn("h-4 w-4 transition-transform", open && "rotate-180")} />
      </button>
      <div className={cn("mt-3 lg:mt-0 lg:block", open ? "block" : "hidden")}>{children}</div>
    </div>
  );
}
