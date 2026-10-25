import { Metadata } from "next";
import { getMyTickets } from "../../lib/data/tickets";
import { getPreview } from "../../lib/preview";
import {
  myTicketsIdealFixture,
  myTicketsEmptyFixture
} from "../../lib/preview/fixtures/tickets";
import { PassengerTopBar } from "../../components/passenger-topbar";
import { FeatureUnavailable, ErrorState } from "../../components/states";
import { MyTicketsView } from "../../components/my-tickets/my-tickets-view";

export const metadata: Metadata = {
  title: "Hành trình của tôi",
  description: "Xem vé đã đặt, theo dõi hoàn tiền và đánh giá các chuyến xe đã đi."
};

interface MyTicketsPageProps {
  readonly searchParams: Promise<{ readonly [key: string]: string | readonly string[] | undefined }>;
}

/**
 * Trang Hành trình của tôi (SCR-PSG-24).
 * Route: /my-tickets
 */
export default async function MyTicketsPage({ searchParams }: MyTicketsPageProps) {
  const resolvedSearchParams = await searchParams;
  const preview = getPreview(resolvedSearchParams);

  const breadcrumbs = [
    { label: "Trang chủ", href: "/" },
    { label: "Hành trình" }
  ];

  // Nhánh Preview (môi trường dev)
  if (preview === "ideal") {
    return (
      <div className="flex-1 bg-neutral-50/40 pb-16">
        <PassengerTopBar breadcrumbs={breadcrumbs} />
        <MyTicketsView initialData={myTicketsIdealFixture} />
      </div>
    );
  }

  if (preview === "empty") {
    return (
      <div className="flex-1 bg-neutral-50/40 pb-16">
        <PassengerTopBar breadcrumbs={breadcrumbs} />
        <MyTicketsView initialData={myTicketsEmptyFixture} />
      </div>
    );
  }

  // Nhánh dữ liệu thật (gọi hàm data)
  const result = await getMyTickets();

  if (result.status === "unavailable") {
    return (
      <div className="flex-1 bg-neutral-50/40 pb-16">
        <PassengerTopBar breadcrumbs={breadcrumbs} />
        <div className="mx-auto w-full max-w-[1200px] px-4 py-12 sm:px-6 lg:px-14">
          <FeatureUnavailable
            endpoint={result.endpoint}
            title="Danh sách vé đang được đồng bộ"
            description="Hệ thống đang tích hợp cổng quản lý vé điện tử trực tuyến. Quý khách có thể sử dụng tính năng Tra cứu vé để kiểm tra thông tin đặt chỗ."
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
            title="Không thể tải danh sách vé"
            description="Đã xảy ra lỗi khi kết nối tới máy chủ. Vui lòng thử lại sau."
          />
        </div>
      </div>
    );
  }

  return (
    <div className="flex-1 bg-neutral-50/40 pb-16">
      <PassengerTopBar breadcrumbs={breadcrumbs} />
      <MyTicketsView initialData={result.data} />
    </div>
  );
}
