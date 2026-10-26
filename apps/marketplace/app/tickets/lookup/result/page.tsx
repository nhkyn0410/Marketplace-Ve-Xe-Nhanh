import React from "react";
import type { Metadata } from "next";
import { getPreview } from "../../../../lib/preview";
import { ticketLookupBookingsFixture, ticketLookupResultFixture } from "../../../../lib/preview/fixtures/tickets";
import { getTicketLookupBookings, getTicketLookupResult } from "../../../../lib/data/tickets";
import type { DataResult } from "../../../../lib/data/result";
import { FeatureUnavailable } from "../../../../components/states/feature-unavailable";
import { ErrorState } from "../../../../components/states/error-state";
import { LookupResultView } from "../../../../components/tickets/lookup-result/lookup-result-view";
import { LookupBookingsView } from "../../../../components/tickets/lookup-result/lookup-bookings-view";

export const metadata: Metadata = {
  title: "Kết quả tra cứu vé",
  description: "Chi tiết vé xe khách dành cho hành khách tra cứu bằng mã đơn hoặc số vé."
};

interface TicketLookupResultPageProps {
  readonly searchParams: Promise<{
    readonly [key: string]: string | string[] | undefined;
  }>;
}

/** Lỗi / hết phiên: hướng dẫn tra cứu lại từ đầu. */
function LookupFailure({ result }: { readonly result: Exclude<DataResult<unknown>, { status: "ok" }> }) {
  return (
    <div className="max-w-4xl mx-auto px-4 py-12">
      {result.status === "unavailable" ? (
        <FeatureUnavailable endpoint={result.endpoint} description="Tra cứu vé tạm thời chưa khả dụng. Vui lòng quay lại sau." />
      ) : (
        <ErrorState
          title="Không thể tải kết quả tra cứu vé"
          description={result.message ?? "Phiên tra cứu của bạn có thể đã hết hạn. Vui lòng thử tra cứu lại từ đầu."}
        />
      )}
    </div>
  );
}

/**
 * Trang kết quả tra cứu vé dành cho khách vãng lai (SCR-PSG-29 - node 1446:15578). Phiên theo email (không nhập mã đặt
 * vé) mở danh sách đơn 12 tháng; `?bookingId=` mở một đơn trong danh sách. Preview: `ideal` = một đơn, `list` = danh sách.
 */
export default async function TicketLookupResultPage({
  searchParams
}: TicketLookupResultPageProps): Promise<React.JSX.Element> {
  const params = await searchParams;
  const previewState = getPreview(params);

  // 1. Nhánh Preview phục vụ duyệt UI theo Figma
  if (previewState === "list") {
    return <LookupBookingsView data={ticketLookupBookingsFixture} isPreview />;
  }
  if (previewState === "ideal") {
    return <LookupResultView data={ticketLookupResultFixture} />;
  }

  // 2. Nhánh thật: danh sách đơn của phiên quyết định mở danh sách hay thẳng một đơn
  const list = await getTicketLookupBookings();
  if (list.status !== "ok") return <LookupFailure result={list} />;
  const loginPrompt = list.data.accountSuggested ? { maskedEmail: list.data.maskedEmail, hasAccount: list.data.hasAccount } : null;
  const bookingId = typeof params.bookingId === "string" ? params.bookingId : undefined;
  const byEmail = list.data.scope === "EMAIL";
  if (byEmail && !bookingId) {
    return <LookupBookingsView data={list.data} />;
  }

  const result = await getTicketLookupResult(byEmail ? bookingId : undefined);
  if (result.status !== "ok") return <LookupFailure result={result} />;
  return <LookupResultView data={result.data} backToList={byEmail} loginPrompt={loginPrompt} />;
}
