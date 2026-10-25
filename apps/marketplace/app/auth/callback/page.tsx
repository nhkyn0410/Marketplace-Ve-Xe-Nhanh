import React from "react";
import type { Metadata } from "next";
import Link from "next/link";
import { getPreview } from "../../../lib/preview";
import { oauthCallbackFixture } from "../../../lib/preview/fixtures/auth";
import { OAuthCallbackView } from "../../../components/auth/oauth-callback-view";
import { AUTH_PRIMARY_BUTTON, AUTH_SUBTITLE, AUTH_TITLE } from "../../../components/auth/auth-styles";
import { AuthModalShell } from "../../../components/auth/auth-modal-shell";

export const metadata: Metadata = {
  title: "Đang xác thực OAuth",
  description: "Xử lý đăng nhập thông qua tài khoản mạng xã hội liên kết."
};

interface OAuthCallbackPageProps {
  readonly searchParams: Promise<{
    readonly [key: string]: string | string[] | undefined;
  }>;
}

/**
 * Trang OAuth Callback (SCR-PSG-10 - node 1447:17897).
 */
export default async function OAuthCallbackPage({
  searchParams
}: OAuthCallbackPageProps): Promise<React.JSX.Element> {
  const params = await searchParams;
  const previewState = getPreview(params);

  // 1. Nhánh Preview phục vụ duyệt giao diện theo Figma
  if (previewState === "ideal") {
    return <OAuthCallbackView data={oauthCallbackFixture} isPreview={true} />;
  }

  return (
    <AuthModalShell>
      <div className="flex w-full flex-col items-center gap-1.5 text-center">
        <h1 className={AUTH_TITLE}>Đăng nhập mạng xã hội chưa khả dụng</h1>
        <p className={AUTH_SUBTITLE}>Vui lòng đăng nhập bằng mã xác minh gửi tới email của bạn.</p>
      </div>
      <Link href="/login" className={`${AUTH_PRIMARY_BUTTON} flex items-center justify-center`}>
        Đăng nhập bằng email
      </Link>
    </AuthModalShell>
  );
}
