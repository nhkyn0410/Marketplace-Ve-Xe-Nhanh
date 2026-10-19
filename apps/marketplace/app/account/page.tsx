import React from "react";
import type { Metadata } from "next";
import { getPreview } from "../../lib/preview";
import { userProfileFixture } from "../../lib/preview/fixtures/auth";
import { getAccountProfile } from "../../lib/data/auth";
import { AccountProfileView } from "../../components/account/account-profile-view";
import { FeatureUnavailable } from "../../components/states/feature-unavailable";

export const metadata: Metadata = {
  title: "Tài khoản của tôi | Vé Xe Nhanh",
  description: "Quản lý thông tin cá nhân, sổ hành khách, điểm thưởng thành viên và phương thức đăng nhập bảo mật."
};

interface AccountPageProps {
  readonly searchParams: Promise<{
    readonly [key: string]: string | string[] | undefined;
  }>;
}

/**
 * Trang Tài khoản của tôi / Hồ sơ cá nhân (SCR-PSG-11 - node 1447:18295).
 */
export default async function AccountPage({
  searchParams
}: AccountPageProps): Promise<React.JSX.Element> {
  const params = await searchParams;
  const previewState = getPreview(params);

  // 1. Nhánh Preview phục vụ duyệt giao diện theo Figma
  if (previewState === "ideal") {
    return <AccountProfileView user={userProfileFixture} isPreview={true} />;
  }

  // 2. Nhánh thật gọi data service
  const res = await getAccountProfile();

  if (res.status === "unavailable") {
    return (
      <div className="container mx-auto px-4 sm:px-6 py-10 max-w-7xl">
        <FeatureUnavailable
          title="Thông tin tài khoản cá nhân"
          endpoint="GET /me/profile"
          description="Hệ thống quản lý tài khoản người dùng đang chờ kết nối cổng API backend. Bạn có thể sử dụng chế độ xem trước để duyệt giao diện."
        />
      </div>
    );
  }

  if (res.status === "error") {
    return (
      <div className="container mx-auto px-4 sm:px-6 py-10 max-w-7xl">
        <FeatureUnavailable
          title="Thông tin tài khoản cá nhân"
          description={res.message ?? "Không thể tải thông tin hồ sơ tài khoản."}
        />
      </div>
    );
  }

  return <AccountProfileView user={res.data} isPreview={false} />;
}
