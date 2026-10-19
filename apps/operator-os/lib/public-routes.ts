// Trang công khai của Operator OS — không cần đăng nhập, không có khung quản trị (TASK-OPR-001: đăng ký nhà xe).
const PUBLIC_PREFIXES = ["/register"];

export function isPublicPath(pathname: string | null): boolean {
  return pathname !== null && PUBLIC_PREFIXES.some((prefix) => pathname === prefix || pathname.startsWith(`${prefix}/`));
}
