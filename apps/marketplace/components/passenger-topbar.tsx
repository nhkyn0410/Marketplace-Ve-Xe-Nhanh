import { cn } from "@vexenhanh/ui/lib/utils";
import { ChevronDown, ChevronRight, Phone } from "lucide-react";
import Link from "next/link";

/**
 * Mục phần tử trong đường dẫn phân cấp (breadcrumb).
 */
export interface BreadcrumbItem {
  readonly label: string;
  readonly href?: string;
}

/**
 * Thuộc tính của thanh trên PassengerTopBar.
 */
export interface PassengerTopBarProps {
  readonly breadcrumbs?: readonly BreadcrumbItem[];
  readonly className?: string;
}

/**
 * Thanh trên cùng cho khu vực hành khách (VXN / Passenger topbar) theo Figma kit 1434:11610.
 */
export function PassengerTopBar({
  breadcrumbs = [{ label: "Trang chủ", href: "/" }],
  className
}: PassengerTopBarProps) {
  return (
    <div
      className={cn(
        "flex h-16 w-full items-center justify-between border-b border-vxn-border/60 bg-white px-4 sm:px-8",
        className
      )}
    >
      {/* Breadcrumb bên trái */}
      <nav aria-label="Đường dẫn phân cấp" className="flex items-center gap-2 text-xs text-vxn-fg-4 sm:text-sm">
        {breadcrumbs.map((item, index) => {
          const isLast = index === breadcrumbs.length - 1;
          return (
            <div key={item.label} className="flex items-center gap-2">
              {index > 0 && <ChevronRight className="size-3.5 text-vxn-fg-5" />}
              {item.href && !isLast ? (
                <Link
                  href={item.href}
                  className="font-medium text-vxn-fg-3 transition-colors hover:text-vxn-teal-700"
                >
                  {item.label}
                </Link>
              ) : (
                <span className={isLast ? "font-semibold text-vxn-ink" : "text-vxn-fg-4"}>
                  {item.label}
                </span>
              )}
            </div>
          );
        })}
      </nav>

      {/* Tiện ích liên hệ và ngôn ngữ bên phải */}
      <div className="flex items-center gap-3">
        <a
          href="tel:19006067"
          className="hidden items-center gap-2 rounded-full border border-vxn-border bg-white px-3.5 py-1.5 text-xs font-semibold text-vxn-ink shadow-2xs transition-colors hover:bg-vxn-bg-2 sm:inline-flex"
        >
          <Phone className="size-3.5 text-amber-600" />
          <span>CSKH 1900 6067</span>
        </a>

        {/* Nút chọn ngôn ngữ */}
        <div className="flex items-center gap-1.5 rounded-full bg-vxn-teal-800 px-3 py-1.5 text-xs font-semibold text-white shadow-2xs">
          <span className="flex size-4 items-center justify-center rounded-full bg-red-600 text-[9px] font-bold text-yellow-300">
            ★
          </span>
          <span>VI</span>
          <ChevronDown className="size-3 text-white/70" />
        </div>
      </div>
    </div>
  );
}
