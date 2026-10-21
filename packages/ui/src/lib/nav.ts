import type { ComponentType, SVGProps } from "react";

export type NavItem = {
  href: string;
  label: string;
  icon: ComponentType<SVGProps<SVGSVGElement>>;
  /** Cần MỘT trong các quyền này (TASK-IAM-007); không khai = ai vào cổng cũng thấy. */
  permissions?: readonly string[];
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

function allowed(item: NavItem, granted: readonly string[]): boolean {
  return !item.permissions || item.permissions.some((permission) => granted.includes(permission));
}

/** Menu theo quyền của phiên (TASK-IAM-007): bỏ mục không có quyền, bỏ nhóm rỗng. */
export function visibleNavGroups(groups: readonly NavGroup[], granted: readonly string[]): NavGroup[] {
  return groups
    .map((group) => ({ ...group, items: group.items.filter((item) => allowed(item, granted)) }))
    .filter((group) => group.items.length > 0);
}

/**
 * Trang đang mở có thuộc mục menu mà phiên không có quyền không — vào thẳng URL thì hiện "không có quyền" thay vì
 * để từng truy vấn lỗi 403. Lấy mục khớp dài nhất; trang không thuộc mục nào → được vào.
 */
export function isNavPathAllowed(groups: readonly NavGroup[], pathname: string, granted: readonly string[]): boolean {
  const match = groups
    .flatMap((group) => group.items)
    .filter((item) => isNavItemActive(pathname, item.href))
    .sort((a, b) => b.href.length - a.href.length)[0];
  return !match || allowed(match, granted);
}
