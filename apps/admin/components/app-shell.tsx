"use client";

import { DashboardShell } from "@vexenhanh/ui/components/dashboard-shell";
import type { NavGroup } from "@vexenhanh/ui/lib/nav";
import {
  Banknote,
  Building2,
  ChartColumn,
  CreditCard,
  FolderTree,
  History,
  LayoutDashboard,
  Plug,
  Scale,
  ScrollText,
  TicketPercent,
  Users
} from "lucide-react";
import type { ReactNode } from "react";

// Theo 06 UI/UX §5 (Information architecture — Admin); path bám resource của 05 API §7.5.
const NAV_GROUPS: NavGroup[] = [
  { items: [{ href: "/", label: "Tổng quan", icon: LayoutDashboard }] },
  {
    label: "Đối tác & người dùng",
    items: [
      { href: "/operators", label: "Nhà xe & KYC", icon: Building2 },
      { href: "/passengers", label: "Hành khách", icon: Users }
    ]
  },
  {
    label: "Cấu hình",
    items: [
      { href: "/catalog", label: "Danh mục", icon: FolderTree },
      { href: "/policies", label: "Chính sách", icon: ScrollText },
      { href: "/promotions", label: "Khuyến mãi", icon: TicketPercent }
    ]
  },
  {
    label: "Tài chính",
    items: [
      { href: "/payments", label: "Thanh toán & hoàn tiền", icon: CreditCard },
      { href: "/payouts", label: "Chi trả nhà xe", icon: Banknote }
    ]
  },
  {
    label: "Giám sát",
    items: [
      { href: "/disputes", label: "Tranh chấp", icon: Scale },
      { href: "/reports", label: "Báo cáo", icon: ChartColumn },
      { href: "/audit-logs", label: "Nhật ký kiểm toán", icon: History },
      { href: "/integrations", label: "Tích hợp", icon: Plug }
    ]
  }
];

export function AppShell({ children }: { children: ReactNode }) {
  return (
    <DashboardShell title="Admin" badge="Hệ thống" navGroups={NAV_GROUPS}>
      {children}
    </DashboardShell>
  );
}
