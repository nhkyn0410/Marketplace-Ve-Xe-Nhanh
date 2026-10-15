import type { NavGroup, NavItem } from "@vexenhanh/ui/lib/nav";
import {
  Banknote,
  BookOpen,
  Building2,
  ChartColumn,
  CreditCard,
  FolderTree,
  History,
  LayoutDashboard,
  MapPin,
  MessageSquareWarning,
  Plug,
  ScrollText,
  ShieldCheck,
  Sparkles,
  TicketPercent,
  Users
} from "lucide-react";

/** Thanh bên Admin theo Figma "VXN / Admin sidebar" (1661:24142); path bám resource của 05 API §7.5. */
export const NAV_GROUPS: NavGroup[] = [
  { items: [{ href: "/", label: "Tổng quan", icon: LayoutDashboard }] },
  {
    label: "Đối tác & người dùng",
    items: [
      { href: "/operators", label: "Nhà xe & KYC", icon: Building2 },
      { href: "/users", label: "Người dùng", icon: Users }
    ]
  },
  {
    label: "Danh mục & chính sách",
    items: [
      { href: "/catalog", label: "Danh mục", icon: FolderTree },
      { href: "/stop-points", label: "Điểm dừng", icon: MapPin },
      { href: "/policies", label: "Chính sách", icon: ScrollText }
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
    label: "Hỗ trợ & nội dung",
    items: [
      { href: "/disputes", label: "Khiếu nại & tranh chấp", icon: MessageSquareWarning },
      { href: "/moderation", label: "Kiểm duyệt", icon: ShieldCheck },
      { href: "/promotions", label: "Khuyến mãi", icon: TicketPercent },
      { href: "/loyalty", label: "VXN Plus", icon: Sparkles },
      { href: "/articles", label: "Bài viết", icon: BookOpen }
    ]
  },
  {
    label: "Hệ thống",
    items: [
      { href: "/reports", label: "Báo cáo", icon: ChartColumn },
      { href: "/audit-logs", label: "Nhật ký audit", icon: History },
      { href: "/system", label: "Tích hợp & hệ thống", icon: Plug }
    ]
  }
];

/** Mục thanh bên ứng với một đường dẫn (mục dài nhất khớp tiền tố). */
export function navItemOf(pathname: string): NavItem | undefined {
  return NAV_GROUPS.flatMap((group) => group.items)
    .filter((item) => item.href !== "/" && (pathname === item.href || pathname.startsWith(`${item.href}/`)))
    .sort((a, b) => b.href.length - a.href.length)[0];
}
