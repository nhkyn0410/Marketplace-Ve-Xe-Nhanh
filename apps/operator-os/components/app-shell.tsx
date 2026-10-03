"use client";

import { DashboardShell } from "@vexenhanh/ui/components/dashboard-shell";
import type { NavGroup } from "@vexenhanh/ui/lib/nav";
import {
  Armchair,
  Building2,
  Bus,
  CalendarClock,
  ChartColumn,
  LayoutDashboard,
  LifeBuoy,
  Route,
  Ticket,
  Users,
  Wallet
} from "lucide-react";
import type { ReactNode } from "react";

// Theo 06 UI/UX §5 (Information architecture — Operator OS).
const NAV_GROUPS: NavGroup[] = [
  { items: [{ href: "/", label: "Tổng quan", icon: LayoutDashboard }] },
  {
    label: "Vận tải",
    items: [
      { href: "/vehicles", label: "Phương tiện", icon: Bus },
      { href: "/seat-maps", label: "Sơ đồ ghế", icon: Armchair },
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

export function AppShell({ children }: { children: ReactNode }) {
  return (
    <DashboardShell title="Trang quản lý nhà xe" navGroups={NAV_GROUPS}>
      {children}
    </DashboardShell>
  );
}
