import React from "react";
import type { Metadata } from "next";
import { getPreview } from "../../lib/preview";
import { registerFixture } from "../../lib/preview/fixtures/auth";
import { RegisterView } from "../../components/auth/register-view";

export const metadata: Metadata = {
  title: "Tạo tài khoản | Vé Xe Nhanh",
  description: "Tạo tài khoản hành khách Vé Xe Nhanh để lưu thông tin vé, tích điểm thành viên và nhận ưu đãi độc quyền."
};

interface RegisterPageProps {
  readonly searchParams: Promise<{
    readonly [key: string]: string | string[] | undefined;
  }>;
}

/**
 * Trang Tạo tài khoản hành khách (SCR-PSG-08 - node 1447:17057).
 */
export default async function RegisterPage({
  searchParams
}: RegisterPageProps): Promise<React.JSX.Element> {
  const params = await searchParams;
  const previewState = getPreview(params);

  // 1. Nhánh Preview phục vụ duyệt giao diện theo Figma
  if (previewState === "ideal") {
    return <RegisterView initialData={registerFixture} isPreview={true} />;
  }

  // 2. Nhánh thật
  const nameParam = params["name"];
  const emailParam = params["email"];
  const phoneParam = params["phone"];

  const initialData = {
    fullName: typeof nameParam === "string" ? nameParam : "",
    email: typeof emailParam === "string" ? emailParam : "",
    phone: typeof phoneParam === "string" ? phoneParam : ""
  };

  return <RegisterView initialData={initialData} isPreview={false} />;
}
