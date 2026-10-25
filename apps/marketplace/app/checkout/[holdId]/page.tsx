import { Metadata } from "next";
import { getCheckoutHoldData } from "../../../lib/data/booking";
import { getPreview } from "../../../lib/preview";
import {
  checkoutHoldIdealFixture,
  checkoutHoldStaleFixture
} from "../../../lib/preview/fixtures/booking";
import { PassengerTopBar } from "../../../components/passenger-topbar";
import { FeatureUnavailable, ErrorState } from "../../../components/states";
import { CheckoutFormView } from "../../../components/checkout/checkout-form-view";

export const metadata: Metadata = {
  title: "Thông tin hành khách & Đặt vé | Vé Xe Nhanh",
  description: "Xác nhận điểm đón trả, nhập thông tin hành khách và áp dụng mã ưu đãi."
};

interface CheckoutPageProps {
  readonly params: Promise<{ readonly holdId: string }>;
  readonly searchParams: Promise<{ readonly [key: string]: string | readonly string[] | undefined }>;
}

/**
 * Trang nhập thông tin hành khách B2 (SCR-PSG-19).
 * Route: /checkout/[holdId]
 */
export default async function CheckoutPage({
  params,
  searchParams
}: CheckoutPageProps) {
  const { holdId } = await params;
  const resolvedSearchParams = await searchParams;
  const preview = getPreview(resolvedSearchParams);

  const breadcrumbs = [
    { label: "Trang chủ", href: "/" },
    { label: "Mua vé", href: "/trips" },
    { label: "Thông tin hành khách" }
  ];

  // Nhánh Preview (môi trường dev)
  if (preview === "ideal") {
    return (
      <div className="flex-1 bg-neutral-50/40 pb-16">
        <PassengerTopBar breadcrumbs={breadcrumbs} />
        <CheckoutFormView initialData={checkoutHoldIdealFixture} isPreview />
      </div>
    );
  }

  if (preview === "stale") {
    return (
      <div className="flex-1 bg-neutral-50/40 pb-16">
        <PassengerTopBar breadcrumbs={breadcrumbs} />
        <CheckoutFormView initialData={checkoutHoldStaleFixture} isPreview />
      </div>
    );
  }

  // Nhánh dữ liệu thật (gọi hàm data)
  const result = await getCheckoutHoldData(holdId);

  if (result.status === "unavailable") {
    return (
      <div className="flex-1 bg-neutral-50/40 pb-16">
        <PassengerTopBar breadcrumbs={breadcrumbs} />
        <div className="mx-auto w-full max-w-[1200px] px-4 py-12 sm:px-6 lg:px-14">
          <FeatureUnavailable
            endpoint={result.endpoint}
            title="Chức năng đặt vé đang được phát triển"
            description="Hệ thống đang hoàn thiện kết nối dữ liệu giữ chỗ và tiếp nhận thông tin hành khách trực tuyến."
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
            title="Không thể tải thông tin đặt vé"
            description="Lượt giữ chỗ có thể đã hết hạn hoặc đã xảy ra lỗi khi kết nối với máy chủ."
          />
        </div>
      </div>
    );
  }

  return (
    <div className="flex-1 bg-neutral-50/40 pb-16">
      <PassengerTopBar breadcrumbs={breadcrumbs} />
      <CheckoutFormView initialData={result.data} />
    </div>
  );
}
