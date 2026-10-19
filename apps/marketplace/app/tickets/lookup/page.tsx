import React from "react";
import type { Metadata } from "next";
import { getPreview } from "../../../lib/preview";
import {
  ticketLookupIdealFixture,
  ticketLookupOtpFixture
} from "../../../lib/preview/fixtures/tickets";
import { LookupView } from "../../../components/tickets/lookup/lookup-view";

export const metadata: Metadata = {
  title: "Tra cứu vé | VeXeNhanh",
  description: "Tra cứu thông tin vé xe đã đặt bằng mã vé và email mà không cần đăng nhập."
};

interface TicketLookupPageProps {
  readonly searchParams: Promise<{ readonly [key: string]: string | readonly string[] | undefined }>;
}

/**
 * Trang Tra cứu vé không đăng nhập B1 & B2 OTP (SCR-PSG-27 & SCR-PSG-28).
 * Route: /tickets/lookup
 */
export default async function TicketLookupPage({
  searchParams
}: TicketLookupPageProps) {
  const resolvedSearchParams = await searchParams;
  const previewState = getPreview(resolvedSearchParams);

  // Nhánh Preview phục vụ kiểm thử thiết kế Figma
  if (previewState) {
    if (previewState === "otp") {
      return (
        <LookupView
          initialStep="otp"
          formData={ticketLookupIdealFixture}
          otpData={ticketLookupOtpFixture}
        />
      );
    }

    // Mặc định preview=ideal (B1)
    return (
      <LookupView
        initialStep="form"
        formData={ticketLookupIdealFixture}
        otpData={ticketLookupOtpFixture}
      />
    );
  }

  // Nhánh thật
  return (
    <LookupView
      initialStep="form"
      otpData={ticketLookupOtpFixture}
    />
  );
}
