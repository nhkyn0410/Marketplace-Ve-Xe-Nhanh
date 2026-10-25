import React from "react";
import type { Metadata } from "next";
import Link from "next/link";
import { getPreview } from "../../../lib/preview";
import { oauthCallbackFixture } from "../../../lib/preview/fixtures/auth";
import { OAuthCallbackView } from "../../../components/auth/oauth-callback-view";

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
    <div className="mx-auto max-w-xl space-y-4 px-6 py-16 text-center">
      <h1 className="text-2xl font-semibold">Đăng nhập mạng xã hội chưa khả dụng</h1>
      <p className="text-muted-foreground">Vui lòng đăng nhập bằng mã xác minh gửi tới email của bạn.</p>
      <Link href="/login" className="inline-block rounded-lg bg-vxn-teal-700 px-5 py-3 text-white">Đăng nhập bằng email</Link>
    </div>
  );
}
