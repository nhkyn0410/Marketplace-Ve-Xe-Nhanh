import React from "react";
import type { Metadata } from "next";
import { getPreview } from "../../lib/preview";
import { loginFixture } from "../../lib/preview/fixtures/auth";
import { LoginView } from "../../components/auth/login-view";

export const metadata: Metadata = {
  title: "Đăng nhập | Vé Xe Nhanh",
  description: "Đăng nhập tài khoản hành khách bằng email để quản lý vé xe, hành trình và ví voucher."
};

interface LoginPageProps {
  readonly searchParams: Promise<{
    readonly [key: string]: string | string[] | undefined;
  }>;
}

/**
 * Trang Đăng nhập tài khoản hành khách (SCR-PSG-07 - node 1447:16634).
 */
export default async function LoginPage({
  searchParams
}: LoginPageProps): Promise<React.JSX.Element> {
  const params = await searchParams;
  const previewState = getPreview(params);

  // 1. Nhánh Preview phục vụ duyệt giao diện theo Figma
  if (previewState === "ideal") {
    return <LoginView initialEmail={loginFixture.email} isPreview={true} />;
  }

  // 2. Nhánh thật
  const emailParam = params["email"];
  const email = typeof emailParam === "string" ? emailParam : "";

  return <LoginView initialEmail={email} isPreview={false} />;
}
