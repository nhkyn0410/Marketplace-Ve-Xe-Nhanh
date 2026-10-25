import type { Metadata } from "next";
import { LoginEntry } from "../../components/auth/auth-entries";

export const metadata: Metadata = {
  title: "Đăng nhập",
  description: "Đăng nhập tài khoản hành khách bằng email để quản lý vé xe, hành trình và ví voucher."
};

/**
 * Đăng nhập (SCR-PSG-07) khi mở thẳng đường dẫn; mở từ trong web thì `app/@modal/(.)login` hiện modal phủ trang.
 */
export default async function Page({ searchParams }: { readonly searchParams: Promise<{ readonly [key: string]: string | string[] | undefined }> }) {
  return <LoginEntry params={await searchParams} variant="page" />;
}
