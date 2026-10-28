import type { NavGroup } from "@vexenhanh/ui/lib/nav";
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
  Route,
  Plug,
  ScrollText,
  ShieldCheck,
  Sparkles,
  TicketPercent,
  Users
} from "lucide-react";

/**
 * Thanh bên Admin theo Figma "VXN / Admin sidebar" (1661:24142); path bám resource của 05 API §7.5. `permissions` = quyền
 * của API mà trang gọi (TASK-IAM-007) — tài khoản được phân quyền chỉ thấy mục mình dùng được.
 */
export const NAV_GROUPS: NavGroup[] = [
  { items: [{ href: "/", label: "Tổng quan", icon: LayoutDashboard }] },
  {
    label: "Đối tác & người dùng",
    items: [
      { href: "/operators", label: "Nhà xe & KYC", icon: Building2, permissions: ["kyc:review", "user:manage"] },
      { href: "/users", label: "Người dùng", icon: Users, permissions: ["user:manage", "access:manage"] },
      { href: "/routes", label: "Tuyến & chuyến", icon: Route, permissions: ["user:manage"] }
    ]
  },
  {
    label: "Danh mục & chính sách",
    items: [
      { href: "/catalog", label: "Danh mục", icon: FolderTree, permissions: ["catalog:manage"] },
      { href: "/stop-points", label: "Điểm dừng", icon: MapPin, permissions: ["catalog:manage"] },
      { href: "/policies", label: "Chính sách", icon: ScrollText, permissions: ["finance:configure"] }
    ]
  },
  {
    label: "Tài chính",
    items: [
      { href: "/payments", label: "Giao dịch", icon: CreditCard, permissions: ["payment:monitor"] },
      { href: "/payouts", label: "Chi trả nhà xe", icon: Banknote, permissions: ["payment:monitor"] }
    ]
  },
  {
    label: "Hỗ trợ & nội dung",
    items: [
      { href: "/disputes", label: "Khiếu nại & tranh chấp", icon: MessageSquareWarning, permissions: ["support:manage"] },
      { href: "/moderation", label: "Kiểm duyệt", icon: ShieldCheck, permissions: ["content:moderate"] },
      { href: "/promotions", label: "Khuyến mãi", icon: TicketPercent, permissions: ["promotion:configure"] },
      { href: "/loyalty", label: "VXN Plus", icon: Sparkles, permissions: ["loyalty:manage"] },
      { href: "/articles", label: "Bài viết", icon: BookOpen, permissions: ["content:manage"] }
    ]
  },
  {
    label: "Hệ thống",
    items: [
      { href: "/reports", label: "Báo cáo", icon: ChartColumn, permissions: ["payment:monitor"] },
      { href: "/audit-logs", label: "Nhật ký audit", icon: History, permissions: ["audit:read"] },
      { href: "/system", label: "Tích hợp & hệ thống", icon: Plug, permissions: ["system:read"] }
    ]
  }
];
