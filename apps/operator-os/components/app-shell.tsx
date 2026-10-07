"use client";

import { DashboardShell } from "@vexenhanh/ui/components/dashboard-shell";
import { LogoMark } from "@vexenhanh/ui/components/logo";
import type { NavGroup } from "@vexenhanh/ui/lib/nav";
import {
  Armchair,
  Building2,
  Bus,
  CalendarClock,
  ChartColumn,
  LayoutDashboard,
  LifeBuoy,
  LogOut,
  MapPin,
  Route,
  Ticket,
  Users,
  Wallet
} from "lucide-react";
import Link from "next/link";
import type { ReactNode } from "react";

import { useAuth } from "../lib/auth/auth-context";

// Theo 06 UI/UX §5 (Information architecture — Operator OS).
const NAV_GROUPS: NavGroup[] = [
  { items: [{ href: "/", label: "Tổng quan", icon: LayoutDashboard }] },
  {
    label: "Vận tải",
    items: [
      { href: "/vehicles", label: "Phương tiện", icon: Bus },
      { href: "/seat-maps", label: "Sơ đồ ghế", icon: Armchair },
      { href: "/stop-points", label: "Điểm dừng", icon: MapPin },
      { href: "/routes", label: "Tuyến đường", icon: Route },
      { href: "/trips", label: "Chuyến xe", icon: CalendarClock }
    ]
  },
  {
    label: "Kinh doanh",
    items: [
      { href: "/bookings", label: "Đặt vé", icon: Ticket },
      { href: "/finance", label: "Tài chính", icon: Wallet },
      { href: "/reports", label: "Báo cáo", icon: ChartColumn }
    ]
  },
  {
    label: "Nhà xe",
    items: [
      { href: "/profile", label: "Hồ sơ & KYC", icon: Building2 },
      { href: "/employees", label: "Nhân viên", icon: Users },
      { href: "/support", label: "Hỗ trợ", icon: LifeBuoy }
    ]
  }
];

/**
 * Khung trang Operator OS theo Figma "VXN / Operator sidebar": thương hiệu hai dòng, thẻ nhà xe đang đăng
 * nhập, menu, thẻ hỗ trợ và khối tài khoản kèm nút đăng xuất.
 */
export function AppShell({ children }: { children: ReactNode }) {
  const { state, logout } = useAuth();
  // `AuthGate` chỉ dựng khung này khi đã đăng nhập; kiểm lại để kiểu dữ liệu chặt.
  const me = state.status === "authenticated" ? state.me : null;
  // `/auth/me` chưa trả tên hiển thị của nhà xe nên tạm dùng mã nhà xe (slug).
  const operator = me?.operatorSlug ?? "";
  const username = me?.username ?? "";

  return (
    <DashboardShell
      title="Trang quản lý nhà xe"
      navGroups={NAV_GROUPS}
      brand={
        <Link href="/" className="flex h-[88px] shrink-0 items-center gap-3 p-5">
          <LogoMark className="size-9 shrink-0 text-vxn-teal-500" />
          <span className="text-sm leading-5 font-semibold text-vxn-teal-700">
            Vé Xe Nhanh
            <br />
            Trang quản lý nhà xe
          </span>
        </Link>
      }
      sidebarTop={
        <div className="mx-4 flex flex-col gap-1 rounded-lg bg-muted p-3">
          <p className="truncate text-sm leading-5 font-semibold text-vxn-fg-1">{operator}</p>
          <p className="text-xs leading-[18px] text-muted-foreground">Tài khoản chủ nhà xe</p>
        </div>
      }
      sidebarBottom={
        <>
          <Link href="/support" className="mx-4 flex flex-col gap-1 rounded-lg bg-accent p-3 hover:bg-vxn-teal-100">
            <span className="text-sm leading-5 font-semibold text-vxn-teal-700">Cần hỗ trợ vận hành?</span>
            <span className="text-xs leading-[18px] text-vxn-teal-700">Trung tâm hỗ trợ</span>
          </Link>
          <div className="flex items-center gap-3 px-5 py-4">
            <span
              aria-hidden
              className="flex size-9 shrink-0 items-center justify-center rounded-lg bg-accent text-sm font-semibold text-vxn-teal-700"
            >
              {username.slice(0, 2).toUpperCase()}
            </span>
            <div className="min-w-0 flex-1">
              <p className="truncate text-sm leading-5 font-semibold text-vxn-fg-1">Chủ nhà xe</p>
              <p className="truncate text-xs leading-[18px] text-muted-foreground">{username}</p>
            </div>
            <button
              type="button"
              aria-label="Đăng xuất"
              title="Đăng xuất"
              onClick={() => void logout()}
              className="flex size-9 shrink-0 items-center justify-center rounded-lg text-vxn-fg-3 outline-none hover:bg-muted focus-visible:ring-[3px] focus-visible:ring-ring/50"
            >
              <LogOut className="size-5" />
            </button>
          </div>
        </>
      }
    >
      {children}
    </DashboardShell>
  );
}
