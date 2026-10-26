import type { Metadata } from "next";
import { VerifyEmailEntry } from "../../components/auth/auth-entries";

export const metadata: Metadata = {
  title: "Xác minh mã OTP",
  description: "Nhập mã xác minh gồm 6 chữ số gửi qua email để hoàn tất đăng nhập hoặc tạo tài khoản."
};

/**
 * Nhập mã OTP (SCR-PSG-09) cho đăng nhập (`flow=login`) và tạo tài khoản (`flow=register`).
 */
export default async function Page({ searchParams }: { readonly searchParams: Promise<{ readonly [key: string]: string | string[] | undefined }> }) {
  return <VerifyEmailEntry params={await searchParams} variant="page" />;
}
