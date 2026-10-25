import { Metadata } from "next";
import { getTripSeatSelection } from "../../../../lib/data/booking";
import { getPreview } from "../../../../lib/preview";
import {
  tripSeatSelectionIdealFixture,
  tripSeatSelectionErrorFixture
} from "../../../../lib/preview/fixtures/booking";
import { PassengerTopBar } from "../../../../components/passenger-topbar";
import { FeatureUnavailable, ErrorState } from "../../../../components/states";
import { SeatSelectionView } from "../../../../components/booking/seat-selection-view";

export const metadata: Metadata = {
  title: "Chọn ghế & Điểm đón trả | Vé Xe Nhanh",
  description: "Chọn điểm đón trả và chỗ ngồi trên chuyến xe khách chất lượng cao."
};

interface SeatsPageProps {
  readonly params: Promise<{ readonly tripId: string }>;
  readonly searchParams: Promise<{ readonly [key: string]: string | readonly string[] | undefined }>;
}

/**
 * Trang chọn điểm đón/trả và sơ đồ ghế (SCR-PSG-18).
 * Route: /trips/[tripId]/seats
 */
export default async function SeatsPage({ params, searchParams }: SeatsPageProps) {
  const { tripId } = await params;
  const resolvedSearchParams = await searchParams;
  const preview = getPreview(resolvedSearchParams);

  const breadcrumbs = [
    { label: "Trang chủ", href: "/" },
    { label: "Mua vé", href: "/trips" },
    { label: "Chọn chỗ" }
  ];

  // Nhánh Preview (môi trường dev)
  if (preview === "ideal") {
    return (
      <div className="flex-1 bg-neutral-50/40 pb-16">
        <PassengerTopBar breadcrumbs={breadcrumbs} />
        <SeatSelectionView initialData={tripSeatSelectionIdealFixture} />
      </div>
    );
  }

  if (preview === "error") {
    return (
      <div className="flex-1 bg-neutral-50/40 pb-16">
        <PassengerTopBar breadcrumbs={breadcrumbs} />
        <SeatSelectionView initialData={tripSeatSelectionErrorFixture} />
      </div>
    );
  }

  // Nhánh dữ liệu thật (gọi hàm data)
  const result = await getTripSeatSelection(tripId);

  if (result.status === "unavailable") {
    return (
      <div className="flex-1 bg-neutral-50/40 pb-16">
        <PassengerTopBar breadcrumbs={breadcrumbs} />
        <div className="mx-auto w-full max-w-[1200px] px-4 py-12 sm:px-6 lg:px-14">
          <FeatureUnavailable
            endpoint={result.endpoint}
            title="Chức năng chọn ghế đang được phát triển"
            description="Hệ thống đang hoàn thiện kết nối dữ liệu sơ đồ ghế và điểm đón/trả trực tuyến từ nhà xe."
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
            title="Không thể tải sơ đồ ghế"
            description="Đã xảy ra lỗi khi kết nối với máy chủ. Vui lòng thử lại sau."
          />
        </div>
      </div>
    );
  }

  return (
    <div className="flex-1 bg-neutral-50/40 pb-16">
      <PassengerTopBar breadcrumbs={breadcrumbs} />
      <SeatSelectionView initialData={result.data} />
    </div>
  );
}
