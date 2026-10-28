import type { AuthMe } from "../auth/auth-context";

/** Nhận biết các trang thuộc cổng bán vé riêng. */
export function isCounterPath(pathname: string | null): boolean {
  return pathname === "/counter" || pathname?.startsWith("/counter/") === true || pathname === "/auth/counter/login";
}

/** Chỉ chủ nhà xe và nhân viên bán vé dùng cổng bán vé. */
export function acceptsCounterSession(me: Pick<AuthMe, "scope" | "role">): boolean {
  return me.scope === "operator" && (me.role === "OPERATOR_OWNER" || me.role === "SALES_STAFF");
}
