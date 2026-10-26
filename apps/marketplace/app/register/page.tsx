import type { Metadata } from "next";
import { RegisterEntry } from "../../components/auth/auth-entries";

export const metadata: Metadata = {
  title: "Tạo tài khoản",
  description: "Tạo tài khoản hành khách Vé Xe Nhanh để lưu thông tin vé, tích điểm thành viên và nhận ưu đãi độc quyền."
};

/**
 * Tạo tài khoản bước 1 — email (SCR-PSG-08).
 */
export default async function Page({ searchParams }: { readonly searchParams: Promise<{ readonly [key: string]: string | string[] | undefined }> }) {
  return <RegisterEntry params={await searchParams} variant="page" />;
}
