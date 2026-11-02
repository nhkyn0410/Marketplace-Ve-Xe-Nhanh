"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";
import { MenuIcon } from "lucide-react";
import { useEffect, useRef, useState, type ReactNode } from "react";

import { isNavItemActive, type NavGroup } from "../lib/nav";
import { cn } from "../lib/utils";
import { Button } from "./button";
import { LogoMark } from "./logo";
import { Sheet, SheetContent, SheetTitle, SheetTrigger } from "./sheet";

type DashboardShellProps = {
  /** Tên cổng, vd "Trang quản lý nhà xe". */
  title: string;
  /** Nhãn phụ màu saffron cạnh tên cổng, vd "Hệ thống". */
  badge?: string;
  navGroups: NavGroup[];
  /** Thay khối thương hiệu mặc định ở đầu sidebar (vd. logo + hai dòng tên của Operator OS). */
  brand?: ReactNode;
  /** Khối giữa thương hiệu và menu, vd. thẻ nhà xe đang đăng nhập. */
  sidebarTop?: ReactNode;
  /** Khối cuối sidebar, vd. thẻ hỗ trợ và tài khoản + đăng xuất. */
  sidebarBottom?: ReactNode;
  /** `dark` = sidebar nền tối của Admin (Figma "VXN / Admin sidebar"); mặc định sidebar sáng của Operator OS. */
  tone?: "light" | "dark";
  children: ReactNode;
};

/** Màu sidebar tối của Admin (Figma 1661:24142). */
const DARK = {
  aside: "border-[#2a3156] bg-[#151b36] [scrollbar-gutter:auto] [scrollbar-width:none]",
  item: "pr-2 text-[#e7e9f7] hover:bg-[#2b3472] hover:text-white",
  active: "bg-[#2b3472] font-semibold text-white",
  group: "px-3.5 pt-3 pb-1 text-xs leading-[18px] font-semibold text-[#9aa3c7] uppercase"
};

const MIN_SIDEBAR_WIDTH = 192;
const MIN_CONTENT_WIDTH = 320;

/** Khung Operator OS / Admin: sidebar kéo đổi độ rộng trên desktop, menu trượt trên mobile. */
export function DashboardShell({
  title,
  badge,
  navGroups,
  brand,
  sidebarTop,
  sidebarBottom,
  tone = "light",
  children
}: DashboardShellProps) {
  const [mobileNavOpen, setMobileNavOpen] = useState(false);
  const [sidebarWidth, setSidebarWidth] = useState<number>();
  const [sidebarSize, setSidebarSize] = useState({ width: 240, maxWidth: 704 });
  const sidebarRef = useRef<HTMLElement>(null);
  const resizeStart = useRef<{ pointerX: number; width: number } | null>(null);

  useEffect(() => {
    const aside = sidebarRef.current;
    if (!aside) return;
    const measure = () => {
      setSidebarSize({
        width: Math.round(aside.getBoundingClientRect().width),
        maxWidth: Math.max(MIN_SIDEBAR_WIDTH, window.innerWidth - MIN_CONTENT_WIDTH)
      });
    };
    const observer = new ResizeObserver(measure);
    observer.observe(aside);
    window.addEventListener("resize", measure);
    return () => {
      observer.disconnect();
      window.removeEventListener("resize", measure);
    };
  }, []);

  const resizeSidebar = (width: number) => {
    const maxWidth = Math.max(MIN_SIDEBAR_WIDTH, window.innerWidth - MIN_CONTENT_WIDTH);
    setSidebarWidth(Math.min(Math.max(width, MIN_SIDEBAR_WIDTH), maxWidth));
  };
  const closeMobileNav = () => setMobileNavOpen(false);
  // Một nội dung cho cả sidebar desktop và menu trượt mobile; `onNavigate` đóng menu trượt sau khi chọn.
  const sidebar = (onNavigate?: () => void) => (
    <>
      {brand ?? <Brand title={title} badge={badge} />}
      {sidebarTop && <div className="min-w-0 [contain:inline-size]">{sidebarTop}</div>}
      <SidebarNav navGroups={navGroups} onNavigate={onNavigate} tone={tone} />
      {sidebarBottom && <div className="mt-auto min-w-0 [contain:inline-size]">{sidebarBottom}</div>}
    </>
  );

  return (
    <div className="flex min-h-screen">
      <aside
        ref={sidebarRef}
        className="sticky top-0 hidden h-screen shrink-0 flex-col lg:flex"
        style={{
          width: sidebarWidth ?? "max-content",
          minWidth: sidebarWidth === undefined ? 240 : MIN_SIDEBAR_WIDTH,
          maxWidth: `calc(100vw - ${MIN_CONTENT_WIDTH}px)`
        }}
      >
        <div
          className={cn(
            "flex min-h-0 flex-1 flex-col overflow-x-hidden overflow-y-auto border-r [scrollbar-gutter:stable]",
            tone === "dark" ? DARK.aside : "bg-card"
          )}
        >
          {sidebar()}
        </div>
        <div
          role="separator"
          tabIndex={0}
          aria-label="Thay đổi độ rộng thanh điều hướng"
          aria-orientation="vertical"
          aria-valuemin={MIN_SIDEBAR_WIDTH}
          aria-valuemax={sidebarSize.maxWidth}
          aria-valuenow={sidebarSize.width}
          aria-valuetext={`${sidebarSize.width} pixel`}
          title="Kéo để đổi độ rộng. Nhấn Home để vừa nội dung."
          className="absolute inset-y-0 -right-1 z-10 w-2 cursor-col-resize touch-none hover:bg-ring/30 focus-visible:bg-ring/30 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring active:bg-ring/50"
          onPointerDown={(event) => {
            if (event.button !== 0) return;
            event.preventDefault();
            event.currentTarget.setPointerCapture(event.pointerId);
            resizeStart.current = {
              pointerX: event.clientX,
              width: sidebarRef.current?.getBoundingClientRect().width ?? sidebarSize.width
            };
          }}
          onPointerMove={(event) => {
            if (!resizeStart.current || !event.currentTarget.hasPointerCapture(event.pointerId)) return;
            resizeSidebar(resizeStart.current.width + event.clientX - resizeStart.current.pointerX);
          }}
          onPointerUp={(event) => {
            if (event.currentTarget.hasPointerCapture(event.pointerId)) {
              event.currentTarget.releasePointerCapture(event.pointerId);
            }
          }}
          onLostPointerCapture={() => {
            resizeStart.current = null;
          }}
          onKeyDown={(event) => {
            if (event.key === "Home") {
              event.preventDefault();
              setSidebarWidth(undefined);
            } else if (event.key === "ArrowLeft" || event.key === "ArrowRight") {
              event.preventDefault();
              resizeSidebar(sidebarSize.width + (event.key === "ArrowRight" ? 16 : -16));
            }
          }}
        />
      </aside>

      <div className="flex min-w-0 flex-1 flex-col">
        <header className="sticky top-0 z-40 flex h-16 items-center gap-2 border-b bg-card px-2 lg:hidden">
          <Sheet open={mobileNavOpen} onOpenChange={setMobileNavOpen}>
            <SheetTrigger asChild>
              <Button variant="ghost" size="icon" aria-label="Mở menu">
                <MenuIcon className="size-5" />
              </Button>
            </SheetTrigger>
            <SheetContent
              side="left"
              className={cn("w-72 gap-0 overflow-y-auto p-0 [scrollbar-gutter:stable]", tone === "dark" && DARK.aside)}
              aria-describedby={undefined}
            >
              <SheetTitle className="sr-only">Điều hướng</SheetTitle>
              {sidebar(closeMobileNav)}
            </SheetContent>
          </Sheet>
          <span className="truncate text-sm font-semibold text-vxn-ink">{title}</span>
        </header>

        <main className="min-w-0 flex-1 px-4 py-6 sm:px-6 lg:px-8 lg:py-7">{children}</main>
      </div>
    </div>
  );
}

function Brand({ title, badge }: { title: string; badge?: string }) {
  return (
    <Link href="/" className="flex h-[73px] shrink-0 items-center gap-2.5 border-b px-5">
      <LogoMark className="size-9 shrink-0 text-vxn-teal-500" />
      <span className="text-base leading-tight font-semibold text-balance text-vxn-ink">
        {title}
        {badge && (
          <span className="ml-2 text-[11px] font-medium tracking-widest text-vxn-saffron-600 uppercase">
            {badge}
          </span>
        )}
      </span>
    </Link>
  );
}

function SidebarNav({
  navGroups,
  onNavigate,
  tone
}: {
  navGroups: NavGroup[];
  onNavigate?: () => void;
  tone: "light" | "dark";
}) {
  const dark = tone === "dark";
  const pathname = usePathname();

  return (
    <nav aria-label="Điều hướng chính" className="flex flex-col p-3">
      {navGroups.map((group, index) => (
        <div key={group.label ?? index}>
          {group.label && (
            <div
              className={cn(
                "truncate",
                dark ? DARK.group : "px-3.5 pt-3.5 pb-1.5 text-[10px] font-medium tracking-widest text-vxn-fg-5 uppercase"
              )}
              title={group.label}
            >
              {group.label}
            </div>
          )}
          <ul className="flex flex-col gap-0.5">
            {group.items.map(({ href, label, icon: Icon }) => {
              const active = isNavItemActive(pathname, href);
              return (
                <li key={href}>
                  <Link
                    href={href}
                    onClick={onNavigate}
                    aria-current={active ? "page" : undefined}
                    className={cn(
                      "flex min-w-0 items-center gap-3 rounded-lg px-3.5 py-2.5 text-sm transition-colors",
                      dark
                        ? cn(DARK.item, active && DARK.active)
                        : cn(
                            "text-vxn-fg-2 hover:bg-accent hover:text-accent-foreground",
                            active && "bg-accent font-medium text-accent-foreground"
                          )
                    )}
                  >
                    <Icon className={cn("size-[18px] shrink-0", !active && "opacity-75")} />
                    <span className="truncate" title={label}>
                      {label}
                    </span>
                  </Link>
                </li>
              );
            })}
          </ul>
        </div>
      ))}
    </nav>
  );
}
