import React from "react";
import type { Metadata } from "next";
import { getPreview } from "../../../lib/preview";
import { oauthCallbackFixture } from "../../../lib/preview/fixtures/auth";
import { OAuthCallbackView } from "../../../components/auth/oauth-callback-view";

export const metadata: Metadata = {
  title: "Đang xác thực OAuth | Vé Xe Nhanh",
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

  // 2. Nhánh thật
  const providerParam = params["provider"];
  const emailParam = params["email"];
  const redirectParam = params["redirect"];

  const provider = typeof providerParam === "string" ? providerParam : "Google";
  const email = typeof emailParam === "string" ? emailParam : "khach.nguyen@gmail.com";
  const redirectUrl = typeof redirectParam === "string" ? redirectParam : "/";

  // In log cảnh báo chưa có backend hoàn chỉnh luồng OAuth
  console.warn(`[marketplace] OAuth callback nhận provider=${provider}, chưa có API session exchange`);

  return (
    <OAuthCallbackView
      data={{
        provider,
        email,
        isExistingLinked: true,
        redirectUrl
      }}
      isPreview={false}
    />
  );
}
