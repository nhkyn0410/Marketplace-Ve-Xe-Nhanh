import React from "react";
import type { Metadata } from "next";
import { getPreview } from "../../../../lib/preview";
import { ticketLookupResultFixture } from "../../../../lib/preview/fixtures/tickets";
import { getTicketLookupResult } from "../../../../lib/data/tickets";
import { FeatureUnavailable } from "../../../../components/states/feature-unavailable";
import { ErrorState } from "../../../../components/states/error-state";
import { LookupResultView } from "../../../../components/tickets/lookup-result/lookup-result-view";

export const metadata: Metadata = {
  title: "Kết quả tra cứu vé | Vé Xe Nhanh",
  description: "Chi tiết vé xe khách dành cho hành khách tra cứu bằng mã đơn hoặc số vé."
};

interface TicketLookupResultPageProps {
  readonly searchParams: Promise<{
    readonly [key: string]: string | string[] | undefined;
  }>;
}

/**
 * Trang kết quả tra cứu vé dành cho khách vãng lai (SCR-PSG-29 - node 1446:15578).
 */
export default async function TicketLookupResultPage({
  searchParams
}: TicketLookupResultPageProps): Promise<React.JSX.Element> {
  const params = await searchParams;
  const previewState = getPreview(params);

  // 1. Nhánh Preview phục vụ duyệt UI theo Figma
  if (previewState === "ideal") {
    return <LookupResultView data={ticketLookupResultFixture} />;
  }

  // 2. Nhánh thật: gọi API lấy dữ liệu kết quả tra cứu
  const tokenParam = params["token"];
  const lookupToken = typeof tokenParam === "string" ? tokenParam : "mock-guest-token";
  const result = await getTicketLookupResult(lookupToken);

  if (result.status === "unavailable") {
    return (
      <div className="max-w-4xl mx-auto px-4 py-12">
        <FeatureUnavailable
          endpoint={result.endpoint}
          description="Chức năng trả về kết quả tra cứu vé khách vãng lai đang chờ hoàn tất kết nối cổng API backend."
        />
      </div>
    );
  }

  if (result.status === "error") {
    return (
      <div className="max-w-4xl mx-auto px-4 py-12">
        <ErrorState
          title="Không thể tải kết quả tra cứu vé"
          description={result.message ?? "Phiên tra cứu của bạn có thể đã hết hạn. Vui lòng thử tra cứu lại từ đầu."}
        />
      </div>
    );
  }

  return <LookupResultView data={result.data} />;
}
