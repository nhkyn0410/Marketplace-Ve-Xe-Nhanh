import { Metadata } from "next";
import { redirect } from "next/navigation";
import { getBookingPaymentData } from "../../../../lib/data/booking";
import { getPreview } from "../../../../lib/preview";
import {
  bookingPaymentIdealFixture,
  bookingPaymentExpiredFixture
} from "../../../../lib/preview/fixtures/booking";
import { PassengerTopBar } from "../../../../components/passenger-topbar";
import { FeatureUnavailable, ErrorState } from "../../../../components/states";
import { PaymentPageView } from "../../../../components/payment/payment-page-view";

export const metadata: Metadata = {
  title: "Thanh toán vé xe",
  description: "Chọn phương thức thanh toán VNPay, MoMo và hoàn tất mua vé trực tuyến an toàn."
};

interface BookingPaymentPageProps {
  readonly params: Promise<{ readonly bookingId: string }>;
  readonly searchParams: Promise<{ readonly [key: string]: string | readonly string[] | undefined }>;
}

/**
 * Trang thanh toán B3 (SCR-PSG-20).
 * Route: /bookings/[bookingId]/payment
 */
export default async function BookingPaymentPage({
  params,
  searchParams
}: BookingPaymentPageProps) {
  const { bookingId } = await params;
  const resolvedSearchParams = await searchParams;
  const preview = getPreview(resolvedSearchParams);

  const breadcrumbs = [
    { label: "Trang chủ", href: "/" },
    { label: "Mua vé", href: "/trips" },
    { label: "Thanh toán" }
  ];

  // Nhánh Preview (môi trường dev)
  if (preview === "ideal") {
    return (
      <div className="flex-1 bg-neutral-50/40 pb-16">
        <PassengerTopBar breadcrumbs={breadcrumbs} />
        <PaymentPageView paymentData={bookingPaymentIdealFixture} />
      </div>
    );
  }

  if (preview === "expired") {
    return (
      <div className="flex-1 bg-neutral-50/40 pb-16">
        <PassengerTopBar breadcrumbs={breadcrumbs} />
        <PaymentPageView
          paymentData={bookingPaymentExpiredFixture}
          isExpired={true}
        />
      </div>
    );
  }

  // Nhánh dữ liệu thật (gọi hàm data)
  const result = await getBookingPaymentData(bookingId);
  if (result.status === "ok" && result.data.bookingStatus && !["PENDING_PAYMENT", "EXPIRED"].includes(result.data.bookingStatus)) {
    redirect(`/bookings/${bookingId}/payment/result`);
  }

  if (result.status === "unavailable") {
    return (
      <div className="flex-1 bg-neutral-50/40 pb-16">
        <PassengerTopBar breadcrumbs={breadcrumbs} />
        <div className="mx-auto w-full max-w-[1200px] px-4 py-12 sm:px-6 lg:px-14">
          <FeatureUnavailable
            endpoint={result.endpoint}
            title="Cổng thanh toán đang được kết nối"
            description="Hệ thống đang tích hợp cổng thanh toán trực tuyến bảo mật. Vui lòng quay lại sau."
          />
        </div>
      </div>
    );
  }

  if (result.status === "error") {
    return (
      <div className="flex-1 bg-neutral-50/40 pb-16">
        <PassengerTopBar breadcrumbs={breadcrumbs} />
        <div className="mx-auto w-full max-w-[1200px] px-4 py-12 sm:px-6 lg:px-14">
          <ErrorState
            title="Không thể tải thông tin thanh toán"
            description="Đơn đặt vé không tồn tại hoặc đã hết hạn giữ chỗ."
          />
        </div>
      </div>
    );
  }

  return (
    <div className="flex-1 bg-neutral-50/40 pb-16">
      <PassengerTopBar breadcrumbs={breadcrumbs} />
      <PaymentPageView paymentData={result.data} />
    </div>
  );
}
