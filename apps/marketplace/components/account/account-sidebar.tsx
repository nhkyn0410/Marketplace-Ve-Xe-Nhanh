"use client";

import React from "react";
import Link from "next/link";
import {
  User,
  Users,
  Tag,
  History,
  ShieldCheck,
  Bell,
  Star,
  LifeBuoy,
  Award
} from "lucide-react";
import type { UserProfileData } from "../../lib/data/types";

export type AccountTabKey =
  | "profile"
  | "passengers"
  | "vouchers"
  | "points"
  | "security"
  | "notifications"
  | "reviews"
  | "support";

export interface AccountSidebarProps {
  readonly activeTab: AccountTabKey;
  readonly user?: UserProfileData;
  readonly isPreview?: boolean;
}

interface NavItem {
  readonly key: AccountTabKey;
  readonly label: string;
  readonly href: string;
  readonly icon: React.ComponentType<{ readonly className?: string }>;
}

const navItems: readonly NavItem[] = [
  { key: "profile", label: "Hồ sơ", href: "/account", icon: User },
  { key: "passengers", label: "Hành khách đã lưu", href: "/account", icon: Users },
  { key: "vouchers", label: "Ví voucher", href: "/account/vouchers", icon: Tag },
  { key: "points", label: "Lịch sử điểm", href: "/plus/history", icon: History },
  { key: "security", label: "Bảo mật", href: "/account", icon: ShieldCheck },
  { key: "notifications", label: "Thông báo", href: "/account/notifications", icon: Bell },
  { key: "reviews", label: "Đánh giá của tôi", href: "/account/reviews", icon: Star },
  { key: "support", label: "Hỗ trợ", href: "/support", icon: LifeBuoy }
];

/**
 * Thanh menu bên trái khu vực tài khoản hành khách chuẩn Figma node 1447:18537
 */
export const AccountSidebar: React.FC<AccountSidebarProps> = ({
  activeTab,
  user,
  isPreview = false
}) => {
  const fullName = user?.fullName ?? "Nguyễn Văn Khách";
  const email = user?.email ?? "khach.nguyen@gmail.com";
  const tierName = user?.tierName ?? "Hạng Bạc";

  // Lấy 2 chữ cái đầu cho Avatar
  const initials = fullName
    .split(" ")
    .filter(Boolean)
    .slice(-2)
    .map((w) => w[0]?.toUpperCase() ?? "")
    .join("") || "NK";

  return (
    <div className="w-full lg:w-72 shrink-0 space-y-4">
      {/* Thẻ người dùng tóm tắt */}
      <div className="bg-white dark:bg-card rounded-2xl border border-border p-5 text-center space-y-2 shadow-2xs">
        {/* Avatar tròn */}
        <div className="w-16 h-16 rounded-full bg-amber-500 text-white font-bold text-xl flex items-center justify-center mx-auto shadow-xs">
          {initials}
        </div>

        <div>
          <h2 className="text-base font-bold text-foreground">{fullName}</h2>
          <p className="text-xs text-muted-foreground">{email}</p>
        </div>

        {/* Huy hiệu Hạng thành viên */}
        <div className="inline-flex items-center gap-1.5 px-3 py-1 rounded-full bg-amber-50 dark:bg-amber-950/40 border border-amber-200/60 dark:border-amber-900/60 text-amber-700 dark:text-amber-400 text-xs font-medium">
          <Award className="w-3.5 h-3.5" />
          <span>VXN Plus · {tierName}</span>
        </div>
      </div>

      {/* Danh mục menu điều hướng */}
      <div className="bg-white dark:bg-card rounded-2xl border border-border p-2 space-y-1 shadow-2xs">
        {navItems.map((item) => {
          const isActive = activeTab === item.key;
          const Icon = item.icon;
          const hrefWithPreview = isPreview ? `${item.href}?preview=ideal` : item.href;

          return (
            <Link
              key={item.key}
              href={hrefWithPreview}
              className={`flex items-center gap-3 px-3.5 py-2.5 rounded-xl text-xs font-medium transition-colors ${
                isActive
                  ? "bg-teal-50 dark:bg-teal-950/40 text-[#0F5B60] dark:text-teal-400 font-semibold"
                  : "text-muted-foreground hover:text-foreground hover:bg-muted/60"
              }`}
            >
              <Icon
                className={`w-4 h-4 ${
                  isActive ? "text-[#0F5B60] dark:text-teal-400" : "text-muted-foreground"
                }`}
              />
              <span>{item.label}</span>
            </Link>
          );
        })}
      </div>
    </div>
  );
};
