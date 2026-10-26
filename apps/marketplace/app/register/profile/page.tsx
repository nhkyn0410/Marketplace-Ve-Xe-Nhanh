import type { Metadata } from "next";
import { RegisterProfileEntry } from "../../../components/auth/auth-entries";

export const metadata: Metadata = {
  title: "Hoàn thiện hồ sơ",
  description: "Bổ sung họ tên và số điện thoại sau khi xác minh email."
};

/**
 * Tạo tài khoản bước 2 — họ tên, số điện thoại (PUT /me/profile).
 */
export default async function Page({ searchParams }: { readonly searchParams: Promise<{ readonly [key: string]: string | string[] | undefined }> }) {
  return <RegisterProfileEntry params={await searchParams} variant="page" />;
}
