import React from "react";
import type { Metadata } from "next";
import { getPreview } from "../../../lib/preview";
import { guestSupportPageFixture } from "../../../lib/preview/fixtures/support";
import { getGuestComplaints } from "../../../lib/data/support";
import { FeatureUnavailable } from "../../../components/states/feature-unavailable";
import { ErrorState } from "../../../components/states/error-state";
import { GuestSupportView } from "../../../components/support/guest-support-view";

export const metadata: Metadata = {
  title: "Khiếu nại đơn hàng (Khách vãng lai) | Vé Xe Nhanh",
  description: "Theo dõi và gửi yêu cầu khiếu nại dành cho khách vãng lai đã xác minh đơn vé."
};

interface GuestSupportPageProps {
  readonly searchParams: Promise<{
    readonly [key: string]: string | string[] | undefined;
  }>;
}

/**
 * Trang Khiếu nại và hỗ trợ của khách vãng lai (SCR-PSG-32 - node 1446:16579).
 */
export default async function GuestSupportPage({
  searchParams
}: GuestSupportPageProps): Promise<React.JSX.Element> {
  const params = await searchParams;
  const previewState = getPreview(params);

  // 1. Nhánh Preview phục vụ duyệt giao diện theo Figma
  if (previewState === "ideal") {
    return <GuestSupportView data={guestSupportPageFixture} />;
  }

  // 2. Nhánh thật: gọi API lấy khiếu nại của khách vãng lai
  const tokenParam = params["token"];
  const token = typeof tokenParam === "string" ? tokenParam : undefined;
  const result = await getGuestComplaints(token);

  if (result.status === "unavailable") {
    return (
      <div className="max-w-4xl mx-auto px-4 py-12">
        <FeatureUnavailable
          endpoint={result.endpoint}
          description="Chức năng quản lý khiếu nại của khách vãng lai đang chờ hoàn tất kết nối cổng API backend."
        />
      </div>
    );
  }

  if (result.status === "error") {
    return (
      <div className="max-w-4xl mx-auto px-4 py-12">
        <ErrorState
          title="Không thể tải dữ liệu khiếu nại"
          description={result.message ?? "Phiên xác thực của bạn có thể đã hết hạn. Vui lòng tra cứu lại đơn vé."}
        />
      </div>
    );
  }

  return (
    <GuestSupportView
      data={{
        session: {
          maskedEmail: "khach@email.com",
          bookingCode: "VXN-DEMO",
          expiresInSeconds: 900
        },
        complaints: result.data
      }}
    />
  );
}
