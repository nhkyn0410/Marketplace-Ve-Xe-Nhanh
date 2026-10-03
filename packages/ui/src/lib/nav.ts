import type { ComponentType, SVGProps } from "react";

export type NavItem = {
  href: string;
  label: string;
  icon: ComponentType<SVGProps<SVGSVGElement>>;
};

export type NavGroup = {
  /** Không có label = nhóm đầu, hiển thị không tiêu đề. */
  label?: string;
  items: NavItem[];
};

/** `/` chỉ active đúng trang chủ; mục khác active cho cả route con (`/trips` ↔ `/trips/123`). */
export function isNavItemActive(pathname: string, href: string): boolean {
  if (href === "/") {
    return pathname === "/";
  }
  return pathname === href || pathname.startsWith(`${href}/`);
}
