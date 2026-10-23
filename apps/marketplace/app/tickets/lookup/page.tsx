import React from "react";
import type { Metadata } from "next";
import { getPreview } from "../../../lib/preview";
import { ticketLookupIdealFixture } from "../../../lib/preview/fixtures/tickets";
import { LookupView } from "../../../components/tickets/lookup/lookup-view";

export const metadata: Metadata = {
  title: "Tra cứu vé | VeXeNhanh",
  description: "Tra cứu thông tin vé xe đã đặt bằng mã đặt vé và email mà không cần đăng nhập."
};

interface TicketLookupPageProps {
  readonly searchParams: Promise<{ readonly [key: string]: string | readonly string[] | undefined }>;
}

/**
 * Trang tra cứu vé trực tiếp bằng mã đặt vé và email liên hệ.
 * Route: /tickets/lookup
 */
export default async function TicketLookupPage({
  searchParams
}: TicketLookupPageProps) {
  const resolvedSearchParams = await searchParams;
  const previewState = getPreview(resolvedSearchParams);

  // Nhánh Preview phục vụ kiểm thử thiết kế Figma
  if (previewState) {
    return <LookupView formData={ticketLookupIdealFixture} />;
  }

  // Nhánh thật
  return <LookupView />;
}
