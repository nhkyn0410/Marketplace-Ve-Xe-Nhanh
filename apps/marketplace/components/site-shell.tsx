"use client";

import { Button } from "@vexenhanh/ui/components/button";
import { LogoWordmark } from "@vexenhanh/ui/components/logo";
import { Sheet, SheetContent, SheetTitle, SheetTrigger } from "@vexenhanh/ui/components/sheet";
import { isNavItemActive, type NavItem } from "@vexenhanh/ui/lib/nav";
import { cn } from "@vexenhanh/ui/lib/utils";
import {
  CircleHelp,
  FileText,
  Globe,
  Headphones,
  MapPin,
  MenuIcon,
  Navigation,
  QrCode,
  Star
} from "lucide-react";
import Link from "next/link";
import { usePathname, useSearchParams } from "next/navigation";
import { Suspense, useState, type ReactNode } from "react";

import { SiteFooter } from "./site-footer";

/**
 * Danh sách mục điều hướng chính theo Figma (kit 1436:12785).
 * Đã bỏ "Dịch vụ bổ trợ" theo quyết định A3 #7.
 */
const MAIN_NAV: readonly NavItem[] = [
  { href: "/explore", label: "Khám phá", icon: Globe },
  { href: "/", label: "Trang chủ", icon: MapPin },
  { href: "/trips", label: "Mua vé", icon: FileText },
  { href: "/my-tickets", label: "Hành trình", icon: Navigation },
  { href: "/plus", label: "Thành viên", icon: Star }
];

/**
 * Danh sách mục điều hướng hỗ trợ theo Figma (kit 1436:12785).
 */
const SUPPORT_NAV: readonly NavItem[] = [
  { href: "/tickets/lookup", label: "Tra cứu vé", icon: QrCode },
  { href: "/support", label: "Khiếu nại", icon: Headphones },
  { href: "/faq", label: "Câu hỏi thường gặp", icon: CircleHelp }
];

/**
 * Khung trang giao diện Marketplace: thanh bên cố định trên desktop (w-[240px]), thanh trên kèm menu trượt trên mobile.
 */
export function SiteShell({ children }: { readonly children: ReactNode }) {
  const [mobileNavOpen, setMobileNavOpen] = useState(false);

  return (
    <div className="min-h-screen lg:flex">
      {/* Sidebar cố định trên desktop */}
      <aside className="sticky top-0 hidden h-screen w-[240px] shrink-0 lg:flex">
        <Suspense fallback={<SidebarSkeleton />}>
          <SidebarContent />
        </Suspense>
      </aside>

      {/* Header cho màn hình mobile / tablet */}
      <header className="sticky top-0 z-40 flex h-16 items-center justify-between bg-vxn-teal-700 px-4 lg:hidden">
        <Link href="/" aria-label="Về trang chủ Vé Xe Nhanh">
          <LogoWordmark className="h-8 w-auto text-[#f7f9fb]" />
        </Link>
        <Sheet open={mobileNavOpen} onOpenChange={setMobileNavOpen}>
          <SheetTrigger asChild>
            <Button
              variant="ghost"
              size="icon"
              className="border border-white/25 bg-white/10 text-white hover:bg-white/20 hover:text-white"
              aria-label="Mở menu"
            >
              <MenuIcon className="size-5" />
            </Button>
          </SheetTrigger>
          <SheetContent side="left" className="w-[240px] border-0 p-0 text-white" aria-describedby={undefined}>
            <SheetTitle className="sr-only">Điều hướng</SheetTitle>
            <Suspense fallback={<SidebarSkeleton />}>
              <SidebarContent onNavigate={() => setMobileNavOpen(false)} />
            </Suspense>
          </SheetContent>
        </Sheet>
      </header>

      {/* Vùng nội dung chính và footer */}
      <div className="flex min-w-0 flex-1 flex-col">
        <main className="flex flex-1 flex-col">{children}</main>
        <Suspense fallback={null}>
          <ConditionalFooter />
        </Suspense>
      </div>
    </div>
  );
}

/**
 * Điều khiển hiển thị footer: ẩn footer khi ở các màn hình lỗi theo thiết kế Figma SCR-PSG-05.
 */
function ConditionalFooter() {
  const searchParams = useSearchParams();
  const preview = searchParams.get("preview");
  const isErrorPreview = preview === "404" || preview === "500" || preview === "403" || preview === "503";

  if (isErrorPreview) {
    return null;
  }

  return <SiteFooter />;
}

/**
 * Skeleton tải thanh bên trong khi chờ Suspense.
 */
function SidebarSkeleton() {
  return <div className="h-full w-full bg-vxn-teal-700" />;
}

/**
 * Nội dung chi tiết của thanh bên điều hướng khách hàng.
 */
function SidebarContent({ onNavigate }: { readonly onNavigate?: () => void }) {
  const pathname = usePathname();
  const searchParams = useSearchParams();
  const isUser = searchParams.get("as") === "user";

  return (
    <div className="flex h-full w-full flex-col justify-between bg-vxn-teal-700 text-white">
      <div className="flex min-h-0 flex-1 flex-col overflow-y-auto pt-7 [scrollbar-gutter:stable]">
        {/* Logo */}
        <div className="px-6 pb-2">
          <Link href="/" onClick={onNavigate} aria-label="Về trang chủ Vé Xe Nhanh" className="inline-block">
            <LogoWordmark className="h-9 w-auto text-[#f7f9fb]" />
          </Link>
        </div>

        {/* Đường phân cách */}
        <Divider />

        {/* Nhóm điều hướng chính */}
        <nav aria-label="Điều hướng chính" className="flex flex-col gap-0.5 px-3">
          {MAIN_NAV.map((item) => (
            <SidebarLink
              key={item.href}
              item={item}
              active={isNavItemActive(pathname, item.href)}
              onNavigate={onNavigate}
            />
          ))}
        </nav>

        {/* Đường phân cách */}
        <Divider className="my-3" />

        {/* Nhóm điều hướng hỗ trợ */}
        <nav aria-label="Hỗ trợ" className="flex flex-col gap-0.5 px-4">
          {SUPPORT_NAV.map((item) => (
            <SidebarLink
              key={item.href}
              item={item}
              active={isNavItemActive(pathname, item.href)}
              onNavigate={onNavigate}
              compact
            />
          ))}
        </nav>
      </div>

      {/* Vùng tài khoản ở đáy thanh bên */}
      <div className="flex flex-col gap-3 border-t border-white/15 p-5">
        {isUser ? (
          <>
            <div className="flex items-center gap-3">
              <div className="flex size-10 shrink-0 items-center justify-center rounded-full bg-vxn-saffron-500 font-bold text-white text-sm">
                NK
              </div>
              <div className="min-w-0 flex-1">
                <p className="truncate text-sm font-semibold text-white leading-tight">
                  Nguyễn Văn Khách
                </p>
                <p className="truncate text-xs text-white/70 leading-tight mt-0.5">
                  VXN Plus · Hạng Bạc
                </p>
              </div>
            </div>
            <Button
              variant="outline"
              onClick={() => {
                console.warn("[marketplace] thao tác đăng xuất");
              }}
              className="h-[42px] rounded-lg border-white/25 bg-white/5 text-sm text-white hover:bg-white/15 hover:text-white"
            >
              Đăng xuất
            </Button>
          </>
        ) : (
          <Button
            asChild
            className="h-[42px] rounded-lg bg-vxn-saffron-500 text-[15px] font-bold text-white shadow-xs hover:bg-vxn-saffron-600"
          >
            <Link href="/login" onClick={onNavigate}>
              Đăng nhập
            </Link>
          </Button>
        )}
        <p className="text-center text-[12px] text-white/50">
          v.1.1 · vexenhanh.vn
        </p>
      </div>
    </div>
  );
}

/**
 * Đường kẻ phân chia khu vực trong thanh bên.
 */
function Divider({ className }: { readonly className?: string }) {
  return (
    <div className={cn("px-4 py-2", className)}>
      <div className="h-px bg-white/15" />
    </div>
  );
}

/**
 * Nút liên kết điều hướng trên thanh bên.
 */
function SidebarLink({
  item: { href, label, icon: Icon },
  active,
  onNavigate,
  compact = false
}: {
  readonly item: NavItem;
  readonly active: boolean;
  readonly onNavigate?: () => void;
  readonly compact?: boolean;
}) {
  return (
    <Link
      href={href}
      onClick={onNavigate}
      aria-current={active ? "page" : undefined}
      className={cn(
        "flex items-center gap-3 rounded-lg transition-colors hover:bg-white/10 hover:text-white",
        compact ? "h-10 px-3 text-sm" : "h-[42px] px-3.5 text-[15px]",
        active ? "bg-white/10 font-medium text-white" : "text-white/85"
      )}
    >
      <Icon className="size-[18px] shrink-0" />
      <span className="min-w-0 flex-1">{label}</span>
      {active && <span className="size-1.5 shrink-0 rounded-full bg-vxn-saffron-500" />}
    </Link>
  );
}
