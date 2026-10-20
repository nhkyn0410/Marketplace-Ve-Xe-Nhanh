import React from "react";
import type { Metadata } from "next";
import { getPreview } from "../../../lib/preview";
import {
  userProfileFixture,
  userReviewsFixture
} from "../../../lib/preview/fixtures/auth";
import { getAccountReviews, getAccountProfile } from "../../../lib/data/auth";
import { AccountReviewsView } from "../../../components/account/account-reviews-view";
import { FeatureUnavailable } from "../../../components/states/feature-unavailable";

export const metadata: Metadata = {
  title: "Đánh giá của tôi | Vé Xe Nhanh",
  description: "Đánh giá chất lượng các chuyến xe đã hoàn thành và xem lại lịch sử nhận xét của bạn."
};

interface ReviewsPageProps {
  readonly searchParams: Promise<{
    readonly [key: string]: string | string[] | undefined;
  }>;
}

/**
 * Trang Đánh giá của tôi (SCR-PSG-14 - node 1448:19193).
 */
export default async function AccountReviewsPage({
  searchParams
}: ReviewsPageProps): Promise<React.JSX.Element> {
  const params = await searchParams;
  const previewState = getPreview(params);

  // 1. Nhánh Preview phục vụ duyệt giao diện theo Figma
  if (previewState === "ideal") {
    return (
      <AccountReviewsView
        user={userProfileFixture}
        initialData={userReviewsFixture}
        isPreview={true}
      />
    );
  }

  // 2. Nhánh thật gọi data service
  const [profileRes, reviewsRes] = await Promise.all([
    getAccountProfile(),
    getAccountReviews()
  ]);

  if (reviewsRes.status === "unavailable") {
    return (
      <div className="container mx-auto px-4 sm:px-6 py-10 max-w-7xl">
        <FeatureUnavailable
          title="Đánh giá của tôi"
          endpoint="GET /me/reviews"
          description="Hệ thống đánh giá chuyến xe của người dùng đang chờ kết nối cổng API backend. Bạn có thể sử dụng chế độ xem trước để duyệt giao diện."
        />
      </div>
    );
  }

  if (reviewsRes.status === "error") {
    return (
      <div className="container mx-auto px-4 sm:px-6 py-10 max-w-7xl">
        <FeatureUnavailable
          title="Đánh giá của tôi"
          description={reviewsRes.message ?? "Không thể tải danh sách đánh giá chuyến xe."}
        />
      </div>
    );
  }

  return (
    <AccountReviewsView
      user={profileRes.status === "ok" ? profileRes.data : undefined}
      initialData={reviewsRes.data}
      isPreview={false}
    />
  );
}
