"use client";

import { Button } from "@vexenhanh/ui/components/button";
import { LogoWordmark } from "@vexenhanh/ui/components/logo";
import { Sheet, SheetContent, SheetTitle, SheetTrigger } from "@vexenhanh/ui/components/sheet";
import { isNavItemActive, type NavItem } from "@vexenhanh/ui/lib/nav";
import { cn } from "@vexenhanh/ui/lib/utils";
import { CircleHelp, FileSearch, House, LifeBuoy, MenuIcon, Ticket, TicketCheck } from "lucide-react";
import Link from "next/link";
import { usePathname } from "next/navigation";
import { useState, type ReactNode } from "react";

import { SiteFooter } from "./site-footer";

// Bố cục theo `CustomerShell` của FE cũ, chỉ giữ mục thuộc 06 UI/UX §5 (Marketplace/Passenger).
// Bỏ "Khám phá" (blog), "Dịch vụ bổ trợ", "Thành viên" (loyalty) vì nằm ngoài SRS.
const MAIN_NAV: NavItem[] = [
  { href: "/", label: "Trang chủ", icon: House },
  { href: "/trips", label: "Mua vé", icon: Ticket },
  { href: "/my-tickets", label: "Vé của tôi", icon: TicketCheck }
];

const SUPPORT_NAV: NavItem[] = [
  { href: "/tickets/lookup", label: "Tra cứu vé", icon: FileSearch },
  { href: "/support", label: "Hỗ trợ", icon: LifeBuoy },
  { href: "/faq", label: "Câu hỏi thường gặp", icon: CircleHelp }
];

/** Khung Marketplace: sidebar teal cố định trên desktop, thanh trên + menu trượt trên mobile. */
export function SiteShell({ children }: { children: ReactNode }) {
  const [mobileNavOpen, setMobileNavOpen] = useState(false);

  return (
    <div className="min-h-screen lg:flex">
      <aside className="sticky top-0 hidden h-screen w-72 shrink-0 lg:flex">
        <SidebarContent />
      </aside>

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
          <SheetContent side="left" className="w-72 border-0 p-0 text-white" aria-describedby={undefined}>
            <SheetTitle className="sr-only">Điều hướng</SheetTitle>
            <SidebarContent onNavigate={() => setMobileNavOpen(false)} />
          </SheetContent>
        </Sheet>
      </header>

      <div className="flex min-w-0 flex-1 flex-col">
        <main className="flex-1">{children}</main>
        <SiteFooter />
      </div>
    </div>
  );
}

function SidebarContent({ onNavigate }: { onNavigate?: () => void }) {
  const pathname = usePathname();

  return (
    <div className="flex h-full w-full flex-col justify-between bg-vxn-teal-700 text-white">
      <div className="flex min-h-0 flex-1 flex-col gap-4.5 overflow-y-auto pt-7">
        <Link href="/" onClick={onNavigate} className="mx-6 w-fit" aria-label="Về trang chủ Vé Xe Nhanh">
          <LogoWordmark className="h-9 w-auto text-[#f7f9fb]" />
        </Link>

        <Divider />
        <nav aria-label="Điều hướng chính" className="flex flex-col gap-0.5 px-3">
          {MAIN_NAV.map((item) => (
            <SidebarLink key={item.href} item={item} active={isNavItemActive(pathname, item.href)} onNavigate={onNavigate} />
          ))}
        </nav>

        <Divider />
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

      <div className="flex flex-col gap-3 border-t border-white/15 p-5">
        <Button asChild className="h-10.5 rounded bg-vxn-saffron-600 text-[15px] hover:bg-vxn-saffron-700">
          <Link href="/register" onClick={onNavigate}>
            Đăng ký
          </Link>
        </Button>
        <Button
          asChild
          variant="outline"
          className="h-10.5 rounded border-white/40 bg-transparent text-[15px] text-white hover:bg-white/10 hover:text-white"
        >
          <Link href="/login" onClick={onNavigate}>
            Đăng nhập
          </Link>
        </Button>
      </div>
    </div>
  );
}

function Divider() {
  return (
    <div className="px-4">
      <div className="h-px bg-white/15" />
    </div>
  );
}

function SidebarLink({
  item: { href, label, icon: Icon },
  active,
  onNavigate,
  compact = false
}: {
  item: NavItem;
  active: boolean;
  onNavigate?: () => void;
  compact?: boolean;
}) {
  return (
    <Link
      href={href}
      onClick={onNavigate}
      aria-current={active ? "page" : undefined}
      className={cn(
        "flex items-center gap-3 rounded-lg transition-colors hover:bg-white/10 hover:text-white",
        compact ? "h-10 px-3 text-sm" : "h-10.5 px-3.5 text-[15px]",
        active ? "bg-white/13 font-medium text-white" : "text-white/85"
      )}
    >
      <Icon className="size-[18px] shrink-0" />
      <span className="min-w-0 flex-1">{label}</span>
      {active && <span className="size-1.5 rounded-full bg-vxn-saffron-500" />}
    </Link>
  );
}
