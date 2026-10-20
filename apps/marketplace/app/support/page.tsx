import React from "react";
import type { Metadata } from "next";
import { getPreview } from "../../lib/preview";
import {
  myComplaintsFixture,
  newComplaintModalFixture
} from "../../lib/preview/fixtures/support";
import { getMyComplaints } from "../../lib/data/support";
import { FeatureUnavailable } from "../../components/states/feature-unavailable";
import { ErrorState } from "../../components/states/error-state";
import { SupportView } from "../../components/support/support-view";

export const metadata: Metadata = {
  title: "Khiếu nại và hỗ trợ | Vé Xe Nhanh",
  description: "Theo dõi yêu cầu hỗ trợ và khiếu nại gắn với vé, chuyến xe, thanh toán hoặc hoàn tiền."
};

interface SupportPageProps {
  readonly searchParams: Promise<{
    readonly [key: string]: string | string[] | undefined;
  }>;
}

/**
 * Trang Khiếu nại và hỗ trợ của hành khách (SCR-PSG-30 & SCR-PSG-31).
 */
export default async function SupportPage({
  searchParams
}: SupportPageProps): Promise<React.JSX.Element> {
  const params = await searchParams;
  const previewState = getPreview(params);

  // 1. Nhánh Preview phục vụ duyệt giao diện theo Figma
  if (previewState === "ideal") {
    return <SupportView data={myComplaintsFixture} />;
  }

  if (previewState === "complaint") {
    return (
      <SupportView
        data={myComplaintsFixture}
        initialOpenNewModal={true}
        defaultDraft={newComplaintModalFixture}
      />
    );
  }

  // 2. Nhánh thật: gọi API lấy danh sách khiếu nại của người dùng
  const result = await getMyComplaints();

  if (result.status === "unavailable") {
    return (
      <div className="max-w-4xl mx-auto px-4 py-12">
        <FeatureUnavailable
          endpoint={result.endpoint}
          description="Chức năng quản lý khiếu nại của tài khoản đang chờ hoàn tất kết nối cổng API backend."
        />
      </div>
    );
  }

  if (result.status === "error") {
    return (
      <div className="max-w-4xl mx-auto px-4 py-12">
        <ErrorState
          title="Không thể tải danh sách khiếu nại"
          description={result.message ?? "Đã xảy ra sự cố khi tải dữ liệu khiếu nại của bạn. Vui lòng thử lại sau."}
        />
      </div>
    );
  }

  return <SupportView data={result.data} />;
}
