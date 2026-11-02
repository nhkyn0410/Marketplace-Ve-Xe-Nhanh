import { cn } from "@vexenhanh/ui/lib/utils";
import { ChevronDown, Phone } from "lucide-react";
import Link from "next/link";
import { Fragment } from "react";

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
 * Tự kẻ viền dưới và căn nội dung theo cùng khung trang (1200px, lề 56px) nên trang không cần bọc thêm.
 */
export function PassengerTopBar({
  breadcrumbs = [{ label: "Trang chủ", href: "/" }],
  className
}: PassengerTopBarProps) {
  return (
    <div className={cn("w-full border-b border-vxn-border bg-white", className)}>
      <div className="mx-auto flex h-16 w-full max-w-[1200px] items-center justify-between gap-4 px-4 sm:px-6 lg:px-14">
        {/* Breadcrumb bên trái */}
        <nav aria-label="Đường dẫn phân cấp" className="flex min-w-0 items-center text-[13px] leading-[19.5px] text-vxn-fg-5">
          {breadcrumbs.map((item, index) => {
            const isLast = index === breadcrumbs.length - 1;
            return (
              <Fragment key={item.label}>
                {index > 0 && <span aria-hidden="true" className="px-2">›</span>}
                {item.href && !isLast ? (
                  <Link href={item.href} className="shrink-0 transition-colors hover:text-vxn-teal-700">
                    {item.label}
                  </Link>
                ) : (
                  <span aria-current={isLast ? "page" : undefined} className="truncate">
                    {item.label}
                  </span>
                )}
              </Fragment>
            );
          })}
        </nav>

        {/* Tiện ích liên hệ và ngôn ngữ bên phải */}
        <div className="flex shrink-0 items-center gap-2">
          <a
            href="tel:19006067"
            className="hidden h-9 items-center gap-2 rounded-full border border-vxn-border bg-white/95 px-3.5 text-[13px] font-medium text-vxn-ink transition-colors hover:bg-vxn-bg-mist sm:inline-flex"
          >
            <Phone className="size-[13px] text-vxn-teal-700" />
            <span>CSKH 1900 6067</span>
          </a>

          {/* Nút chọn ngôn ngữ */}
          <div className="flex h-9 items-center gap-2 rounded-full bg-[rgb(7_54_76/0.75)] px-3.5 text-[13px] text-white backdrop-blur-[8px]">
            <span aria-hidden="true" className="flex h-3.5 w-[22px] items-center justify-center rounded-[2px] bg-[#da251d] text-[10px] leading-none text-[#ffcd00]">
              ★
            </span>
            <span>VI</span>
            <ChevronDown className="size-2.5" />
          </div>
        </div>
      </div>
    </div>
  );
}
