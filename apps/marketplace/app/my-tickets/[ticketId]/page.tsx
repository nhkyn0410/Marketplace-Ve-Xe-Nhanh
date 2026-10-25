import React from "react";
import type { Metadata } from "next";
import { getPreview } from "../../../lib/preview";
import { getTicketDetail } from "../../../lib/data/tickets";
import { ticketDetailFixture } from "../../../lib/preview/fixtures/tickets";
import { TicketDetailView } from "../../../components/ticket-detail/ticket-detail-view";
import { FeatureUnavailable, ErrorState } from "../../../components/states";

export const metadata: Metadata = {
  title: "Chi tiết vé",
  description: "Thông tin chi tiết vé xe điện tử, mã QR soát vé và hướng dẫn lên xe."
};

interface TicketDetailPageProps {
  readonly params: Promise<{ readonly ticketId: string }>;
  readonly searchParams: Promise<{ readonly [key: string]: string | readonly string[] | undefined }>;
}

/**
 * Trang chi tiết vé điện tử (SCR-PSG-25) & Hộp thoại hủy vé (SCR-PSG-26)
 */
export default async function TicketDetailPage({
  params,
  searchParams
}: TicketDetailPageProps) {
  const resolvedParams = await params;
  const resolvedSearchParams = await searchParams;
  const previewState = getPreview(resolvedSearchParams);

  // Nhánh Preview phục vụ kiểm thử thiết kế
  if (previewState) {
    if (previewState === "cancel") {
      return (
        <TicketDetailView
          ticketDetail={ticketDetailFixture}
          defaultOpenCancelDialog={true}
        />
      );
    }

    // Mặc định hoặc preview=ideal
    return (
      <TicketDetailView
        ticketDetail={ticketDetailFixture}
        defaultOpenCancelDialog={false}
      />
    );
  }

  // Nhánh Thật kết nối hệ thống
  const bookingId = resolvedSearchParams["bookingId"];
  const result = await getTicketDetail(resolvedParams.ticketId, typeof bookingId === "string" ? bookingId : undefined);

  if (result.status === "unavailable") {
    return (
      <div className="container mx-auto px-4 py-12 max-w-4xl">
        <FeatureUnavailable
          title="Chi tiết vé điện tử"
          endpoint={result.endpoint}
        />
      </div>
    );
  }

  if (result.status === "error") {
    return (
      <div className="container mx-auto px-4 py-12 max-w-4xl">
        <ErrorState
          title="Không thể tải chi tiết vé"
          description={result.message}
        />
      </div>
    );
  }

  return (
    <TicketDetailView
      ticketDetail={result.data}
      defaultOpenCancelDialog={resolvedSearchParams["cancel"] === "true"}
    />
  );
}
