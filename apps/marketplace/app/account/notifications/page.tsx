import React from "react";
import type { Metadata } from "next";
import { getPreview } from "../../../lib/preview";
import {
  userProfileFixture,
  notificationSettingsFixture
} from "../../../lib/preview/fixtures/auth";
import { getNotificationSettings, getAccountProfile } from "../../../lib/data/auth";
import { AccountNotificationsView } from "../../../components/account/account-notifications-view";
import { FeatureUnavailable } from "../../../components/states/feature-unavailable";
import { AccountSignInRequired } from "../../../components/account/account-sign-in-required";

export const metadata: Metadata = {
  title: "Cài đặt thông báo | Vé Xe Nhanh",
  description: "Tùy chỉnh kênh nhận thông báo chuyến đi, ví voucher và cập nhật hệ thống qua Email hoặc Push."
};

interface NotificationsPageProps {
  readonly searchParams: Promise<{
    readonly [key: string]: string | string[] | undefined;
  }>;
}

/**
 * Trang Cài đặt thông báo tài khoản (SCR-PSG-12 - node 1447:18811).
 */
export default async function AccountNotificationsPage({
  searchParams
}: NotificationsPageProps): Promise<React.JSX.Element> {
  const params = await searchParams;
  const previewState = getPreview(params);

  // 1. Nhánh Preview phục vụ duyệt giao diện theo Figma
  if (previewState === "ideal") {
    return (
      <AccountNotificationsView
        user={userProfileFixture}
        initialSettings={notificationSettingsFixture}
        isPreview={true}
      />
    );
  }

  // 2. Nhánh thật gọi data service
  const [profileRes, settingsRes] = await Promise.all([
    getAccountProfile(),
    getNotificationSettings()
  ]);

  if (settingsRes.status === "unavailable") {
    return (
      <div className="mx-auto w-full px-4 sm:px-6 py-10 max-w-[1200px] lg:px-14">
        <FeatureUnavailable
          title="Cài đặt thông báo"
          description="Cài đặt thông báo hiện chưa khả dụng. Vui lòng thử lại sau."
        />
      </div>
    );
  }

  if (settingsRes.status === "error") {
    if (settingsRes.httpStatus === 401) return <AccountSignInRequired />;
    return (
      <div className="mx-auto w-full px-4 sm:px-6 py-10 max-w-[1200px] lg:px-14">
        <FeatureUnavailable
          title="Cài đặt thông báo"
          description={settingsRes.message ?? "Không thể tải cài đặt thông báo."}
        />
      </div>
    );
  }

  return (
    <AccountNotificationsView
      user={profileRes.status === "ok" ? profileRes.data : undefined}
      initialSettings={settingsRes.data}
      isPreview={false}
    />
  );
}
