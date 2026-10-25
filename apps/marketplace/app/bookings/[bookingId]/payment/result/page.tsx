import { Metadata } from "next";
import { getBookingPaymentResult } from "../../../../../lib/data/booking";
import { getPreview } from "../../../../../lib/preview";
import {
  paymentResultProcessingFixture,
  paymentResultSuccessFixture,
  paymentResultFailedFixture
} from "../../../../../lib/preview/fixtures/booking";
import { PassengerTopBar } from "../../../../../components/passenger-topbar";
import { FeatureUnavailable, ErrorState } from "../../../../../components/states";
import { PaymentResultView } from "../../../../../components/payment-result/payment-result-view";

export const metadata: Metadata = {
  title: "Kết quả thanh toán | Vé Xe Nhanh",
  description: "Trạng thái giao dịch thanh toán vé xe trực tuyến và thông tin vé điện tử."
};

interface BookingPaymentResultPageProps {
  readonly params: Promise<{ readonly bookingId: string }>;
  readonly searchParams: Promise<{ readonly [key: string]: string | readonly string[] | undefined }>;
}

/**
 * Trang kết quả thanh toán B4 (SCR-PSG-21, 22, 23).
 * Route: /bookings/[bookingId]/payment/result
 */
export default async function BookingPaymentResultPage({
  params,
  searchParams
}: BookingPaymentResultPageProps) {
  const { bookingId } = await params;
  const resolvedSearchParams = await searchParams;
  const preview = getPreview(resolvedSearchParams);

  const isSuccess = preview === "success";

  const breadcrumbs = [
    { label: "Trang chủ", href: "/" },
    { label: "Mua vé", href: "/trips" },
    { label: isSuccess ? "Hoàn tất" : "Thanh toán" }
  ];

  // Nhánh Preview (môi trường dev)
  if (preview === "processing") {
    return (
      <div className="flex-1 bg-neutral-50/40 pb-16">
        <PassengerTopBar breadcrumbs={breadcrumbs} />
        <PaymentResultView result={paymentResultProcessingFixture} />
      </div>
    );
  }

  if (preview === "success") {
    return (
      <div className="flex-1 bg-neutral-50/40 pb-16">
        <PassengerTopBar breadcrumbs={breadcrumbs} />
        <PaymentResultView result={paymentResultSuccessFixture} />
      </div>
    );
  }

  if (preview === "failed") {
    return (
      <div className="flex-1 bg-neutral-50/40 pb-16">
        <PassengerTopBar breadcrumbs={breadcrumbs} />
        <PaymentResultView result={paymentResultFailedFixture} />
      </div>
    );
  }

  // Nhánh dữ liệu thật (gọi hàm data)
  const result = await getBookingPaymentResult(bookingId);

  if (result.status === "unavailable") {
    return (
      <div className="flex-1 bg-neutral-50/40 pb-16">
        <PassengerTopBar breadcrumbs={breadcrumbs} />
        <div className="mx-auto w-full max-w-[1200px] px-4 py-12 sm:px-6 lg:px-14">
          <FeatureUnavailable
            endpoint={result.endpoint}
            title="Kết quả giao dịch đang được cập nhật"
            description="Hệ thống đang tích hợp cổng nhận kết quả thanh toán tự động từ đối tác ngân hàng. Vui lòng quay lại sau."
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
            title="Không thể tải kết quả thanh toán"
            description="Đơn đặt vé không tồn tại hoặc đã có lỗi phát sinh trong quá trình truy vấn kết quả."
          />
        </div>
      </div>
    );
  }

  return (
    <div className="flex-1 bg-neutral-50/40 pb-16">
      <PassengerTopBar breadcrumbs={breadcrumbs} />
      <PaymentResultView result={result.data} />
    </div>
  );
}
