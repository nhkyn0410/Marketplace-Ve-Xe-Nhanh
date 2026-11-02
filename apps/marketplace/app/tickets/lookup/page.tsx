import React from "react";
import type { Metadata } from "next";
import { getPreview } from "../../../lib/preview";
import { ticketLookupIdealFixture, ticketLookupOtpFixture } from "../../../lib/preview/fixtures/tickets";
import { LookupView } from "../../../components/tickets/lookup/lookup-view";

export const metadata: Metadata = {
  title: "Tra cứu vé",
  description: "Tra cứu vé xe đã đặt bằng mã đặt vé, email và mã xác minh gửi về email, không cần đăng nhập."
};

interface TicketLookupPageProps {
  readonly searchParams: Promise<{ readonly [key: string]: string | readonly string[] | undefined }>;
}

/**
 * Trang tra cứu vé bằng mã đặt vé + email liên hệ, xác minh mã gửi về email (preview: `ideal` = B1, `otp` = B2).
 * Route: /tickets/lookup
 */
export default async function TicketLookupPage({
  searchParams
}: TicketLookupPageProps) {
  const resolvedSearchParams = await searchParams;
  const previewState = getPreview(resolvedSearchParams);

  // Nhánh Preview phục vụ kiểm thử thiết kế Figma
  if (previewState) {
    return <LookupView formData={ticketLookupIdealFixture} otpState={previewState === "otp" ? ticketLookupOtpFixture : undefined} isPreview />;
  }

  // Nhánh thật
  return <LookupView />;
}
