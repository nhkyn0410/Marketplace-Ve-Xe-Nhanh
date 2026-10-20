import React from "react";
import type { Metadata } from "next";
import { getPreview } from "../../../lib/preview";
import {
  userProfileFixture,
  userSessionsFixture
} from "../../../lib/preview/fixtures/auth";
import { getAccountSessions, getAccountProfile } from "../../../lib/data/auth";
import { AccountSessionsView } from "../../../components/account/account-sessions-view";
import { FeatureUnavailable } from "../../../components/states/feature-unavailable";

export const metadata: Metadata = {
  title: "Phiên đăng nhập & Thiết bị | Vé Xe Nhanh",
  description: "Quản lý danh sách các thiết bị đang đăng nhập tài khoản hành khách và thu hồi phiên lạ."
};

interface SessionsPageProps {
  readonly searchParams: Promise<{
    readonly [key: string]: string | string[] | undefined;
  }>;
}

/**
 * Trang Quản lý phiên đăng nhập (SCR-PSG-13 - node 1448:18809).
 */
export default async function AccountSessionsPage({
  searchParams
}: SessionsPageProps): Promise<React.JSX.Element> {
  const params = await searchParams;
  const previewState = getPreview(params);

  // 1. Nhánh Preview phục vụ duyệt giao diện theo Figma
  if (previewState === "ideal") {
    return (
      <AccountSessionsView
        user={userProfileFixture}
        initialSessions={userSessionsFixture}
        isPreview={true}
      />
    );
  }

  // 2. Nhánh thật gọi data service
  const [profileRes, sessionsRes] = await Promise.all([
    getAccountProfile(),
    getAccountSessions()
  ]);

  if (sessionsRes.status === "unavailable") {
    return (
      <div className="container mx-auto px-4 sm:px-6 py-10 max-w-7xl">
        <FeatureUnavailable
          title="Phiên đăng nhập & Thiết bị"
          endpoint="GET /me/sessions"
          description="Hệ thống quản lý phiên đăng nhập thiết bị đang chờ kết nối cổng API backend. Bạn có thể sử dụng chế độ xem trước để duyệt giao diện."
        />
      </div>
    );
  }

  if (sessionsRes.status === "error") {
    return (
      <div className="container mx-auto px-4 sm:px-6 py-10 max-w-7xl">
        <FeatureUnavailable
          title="Phiên đăng nhập & Thiết bị"
          description={sessionsRes.message ?? "Không thể tải danh sách phiên đăng nhập."}
        />
      </div>
    );
  }

  return (
    <AccountSessionsView
      user={profileRes.status === "ok" ? profileRes.data : undefined}
      initialSessions={sessionsRes.data}
      isPreview={false}
    />
  );
}
