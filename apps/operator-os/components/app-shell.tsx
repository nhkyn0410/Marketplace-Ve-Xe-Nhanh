"use client";

import { DashboardShell } from "@vexenhanh/ui/components/dashboard-shell";
import { LogoMark } from "@vexenhanh/ui/components/logo";
import { isNavPathAllowed, type NavGroup, visibleNavGroups } from "@vexenhanh/ui/lib/nav";
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
  Megaphone,
  Route,
  ShieldOff,
  Tag,
  Ticket,
  UserCog,
  Users,
  Wallet
} from "lucide-react";
import Link from "next/link";
import { usePathname } from "next/navigation";
import type { ReactNode } from "react";

import { ListStatePanel } from "./list-parts";
import { useAuth } from "../lib/auth/auth-context";
import { isPublicPath } from "../lib/public-routes";

// Theo 06 UI/UX §5 (Information architecture — Operator OS). `permissions` = quyền của API trang gọi để ghi (TASK-IAM-007):
// tài khoản quản lý chỉ thấy mục được tick; chủ nhà xe có đủ.
export const NAV_GROUPS: NavGroup[] = [
  { items: [{ href: "/", label: "Tổng quan", icon: LayoutDashboard }] },
  {
    label: "Vận tải",
    items: [
      { href: "/vehicles", label: "Phương tiện", icon: Bus, permissions: ["vehicle:manage"] },
      { href: "/seat-maps", label: "Sơ đồ ghế", icon: Armchair, permissions: ["vehicle:manage"] },
      { href: "/stop-points", label: "Điểm dừng", icon: MapPin, permissions: ["route:manage"] },
      { href: "/routes", label: "Tuyến đường", icon: Route, permissions: ["route:manage"] },
      { href: "/fares", label: "Bảng giá", icon: Tag, permissions: ["trip:manage"] },
      { href: "/trips", label: "Chuyến xe", icon: CalendarClock, permissions: ["trip:manage"] }
    ]
  },
  {
    label: "Kinh doanh",
    items: [
      { href: "/bookings", label: "Đặt vé", icon: Ticket, permissions: ["booking:read"] },
      // Figma "VXN / Operator sidebar" (Khanh duyệt thêm mục 13/10/2026).
      { href: "/promotions", label: "Khuyến mãi", icon: Megaphone, permissions: ["promotion:manage"] },
      { href: "/finance", label: "Tài chính", icon: Wallet, permissions: ["finance:read"] },
      { href: "/reports", label: "Báo cáo", icon: ChartColumn, permissions: ["finance:read"] }
    ]
  },
  {
    label: "Nhà xe",
    items: [
      { href: "/profile", label: "Hồ sơ & KYC", icon: Building2, permissions: ["kyc:submit"] },
      { href: "/employees", label: "Nhân viên", icon: Users, permissions: ["employee:manage"] },
      { href: "/managers", label: "Tài khoản quản lý", icon: UserCog, permissions: ["manager:manage"] },
      { href: "/support", label: "Hỗ trợ", icon: LifeBuoy, permissions: ["support:respond"] }
    ]
  }
];

/**
 * Khung trang Operator OS theo Figma "VXN / Operator sidebar": thương hiệu hai dòng, thẻ nhà xe đang đăng
 * nhập, menu, thẻ hỗ trợ và khối tài khoản kèm nút đăng xuất.
 */
export function AppShell({ children }: { children: ReactNode }) {
  const { state, logout } = useAuth();
  const pathname = usePathname();
  // Trang đăng ký nhà xe công khai có khung riêng (`RegisterShell`), không có thanh quản trị.
  if (isPublicPath(pathname)) {
    return children;
  }
  // `AuthGate` chỉ dựng khung này khi đã đăng nhập; kiểm lại để kiểu dữ liệu chặt.
  const me = state.status === "authenticated" ? state.me : null;
  // `/auth/me` chưa trả tên hiển thị của nhà xe nên tạm dùng mã nhà xe (slug).
  const operator = me?.operatorSlug ?? "";
  const username = me?.username ?? "";
  const granted = me?.permissions ?? [];
  const accountLabel = me?.role === "OPERATOR_MANAGER" ? "Tài khoản quản lý" : "Chủ nhà xe";

  return (
    <DashboardShell
      title="Trang quản lý nhà xe"
      navGroups={visibleNavGroups(NAV_GROUPS, granted)}
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
          <p className="text-xs leading-[18px] text-muted-foreground">{me?.role === "OPERATOR_MANAGER" ? "Tài khoản quản lý" : "Tài khoản chủ nhà xe"}</p>
        </div>
      }
      sidebarBottom={
        <>
          <Link href="/support" className="mx-4 flex flex-col gap-1 rounded-lg bg-accent p-3 hover:bg-vxn-teal-100">
            <span className="text-sm leading-5 font-semibold text-vxn-teal-700">Cần hỗ trợ vận hành?</span>
            <span className="text-xs leading-[18px] text-vxn-teal-700">Trung tâm hỗ trợ</span>
          </Link>
          <div className="flex items-center gap-1 px-3 py-4">
            {/* Khối tài khoản mở màn Tài khoản và bảo mật (phiên đăng nhập — FR-IAM-15). */}
            <Link
              href="/account"
              aria-label="Tài khoản và bảo mật"
              title="Tài khoản và bảo mật"
              className="flex min-w-0 flex-1 items-center gap-3 rounded-lg p-2 outline-none hover:bg-muted focus-visible:ring-[3px] focus-visible:ring-ring/50"
            >
              <span
                aria-hidden
                className="flex size-9 shrink-0 items-center justify-center rounded-lg bg-accent text-sm font-semibold text-vxn-teal-700"
              >
                {username.slice(0, 2).toUpperCase()}
              </span>
              <span className="min-w-0 flex-1">
                <span className="block truncate text-sm leading-5 font-semibold text-vxn-fg-1">{accountLabel}</span>
                <span className="block truncate text-xs leading-[18px] text-muted-foreground">{username}</span>
              </span>
            </Link>
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
      {isNavPathAllowed(NAV_GROUPS, pathname, granted) ? (
        children
      ) : (
        <ListStatePanel
          icon={<ShieldOff className="size-6 text-vxn-fg-3" />}
          title="Bạn chưa được cấp quyền dùng trang này"
          description="Liên hệ chủ nhà xe nếu công việc của bạn cần trang này."
        />
      )}
    </DashboardShell>
  );
}
