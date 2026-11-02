import React from "react";
import Link from "next/link";
import type { Metadata } from "next";
import { getPreview } from "../../../lib/preview";
import { guestSupportPageFixture } from "../../../lib/preview/fixtures/support";
import { getGuestComplaints } from "../../../lib/data/support";
import { bookingHeaders } from "../../../lib/data/booking-access";
import { FeatureUnavailable } from "../../../components/states/feature-unavailable";
import { ErrorState } from "../../../components/states/error-state";
import { GuestSupportView } from "../../../components/support/guest-support-view";
import { SupportView } from "../../../components/support/support-view";

export const metadata: Metadata = {
  title: "Khiếu nại đơn hàng (Khách vãng lai)",
  description: "Theo dõi và gửi hỗ trợ từ trình duyệt đã đặt vé."
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
  const bookingParam = params["bookingId"];
  const bookingId = typeof bookingParam === "string" ? bookingParam : undefined;
  if (!bookingId || !(await bookingHeaders(bookingId))["X-Booking-Token"]) {
    return <div className="mx-auto max-w-2xl space-y-4 px-4 py-12">
      <h1 className="text-2xl font-bold">Cần quyền truy cập đơn vé</h1>
      <p className="text-sm text-muted-foreground">Mở vé trên trình duyệt đã dùng để đặt rồi chọn gửi hỗ trợ. Nếu đặt bằng tài khoản, đăng nhập tài khoản đó để xem yêu cầu của bạn. Tra cứu bằng mã đơn và email chỉ cho phép xem vé.</p>
      <div className="flex flex-wrap gap-3 text-sm font-semibold">
        <Link href="/login?next=%2Fsupport" className="rounded-xl bg-teal-900 px-4 py-2 text-white">Đăng nhập để gửi hỗ trợ</Link>
        <Link href="/tickets/lookup" className="rounded-xl border px-4 py-2">Tra cứu thông tin vé</Link>
      </div>
    </div>;
  }
  const result = await getGuestComplaints(bookingId);

  if (result.status === "unavailable") {
    return (
      <div className="max-w-4xl mx-auto px-4 py-12">
        <FeatureUnavailable
          endpoint={result.endpoint}
          description="Hỗ trợ đơn vé tạm thời chưa khả dụng. Vui lòng quay lại sau."
        />
      </div>
    );
  }

  if (result.status === "error") {
    return (
      <div className="max-w-4xl mx-auto px-4 py-12">
        <ErrorState
          title="Không thể tải dữ liệu khiếu nại"
          description={result.message ?? "Không thể mở yêu cầu. Vui lòng dùng trình duyệt đã đặt vé hoặc đăng nhập tài khoản đặt vé."}
        />
      </div>
    );
  }

  return (
    <SupportView data={result.data} guestBookingId={bookingId} />
  );
}
