import React from "react";
import type { Metadata } from "next";
import { getPreview } from "../../lib/preview";
import { verifyEmailFixture } from "../../lib/preview/fixtures/auth";
import { VerifyEmailView } from "../../components/auth/verify-email-view";

export const metadata: Metadata = {
  title: "Xác minh mã OTP | Vé Xe Nhanh",
  description: "Nhập mã xác minh gồm 6 chữ số gửi qua email để hoàn tất đăng nhập hoặc tạo tài khoản."
};

interface VerifyEmailPageProps {
  readonly searchParams: Promise<{
    readonly [key: string]: string | string[] | undefined;
  }>;
}

/**
 * Trang Nhập mã OTP xác minh email (SCR-PSG-09 - node 1447:17487).
 */
export default async function VerifyEmailPage({
  searchParams
}: VerifyEmailPageProps): Promise<React.JSX.Element> {
  const params = await searchParams;
  const previewState = getPreview(params);

  // 1. Nhánh Preview phục vụ duyệt giao diện theo Figma
  if (previewState === "ideal") {
    return <VerifyEmailView initialData={verifyEmailFixture} isPreview={true} />;
  }

  // 2. Nhánh thật
  const emailParam = params["email"];
  const email = typeof emailParam === "string" ? emailParam : "khach.nguyen@gmail.com";

  return (
    <VerifyEmailView
      initialData={{
        email,
        otpDigits: ["", "", "", "", "", ""],
        expiresInSeconds: 300,
        resendCountdownSeconds: 30,
        remainingAttempts: 5
      }}
      isPreview={false}
    />
  );
}
