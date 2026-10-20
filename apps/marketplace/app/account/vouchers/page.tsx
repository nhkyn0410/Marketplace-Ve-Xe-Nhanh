import { PassengerTopBar } from "../../../components/passenger-topbar";
import { FeatureUnavailable } from "../../../components/states";
import { VouchersView } from "../../../components/vouchers/vouchers-view";
import { getUserVouchers } from "../../../lib/data/loyalty";
import { getPreview } from "../../../lib/preview";
import { userVouchersFixture } from "../../../lib/preview/fixtures/loyalty";

/**
 * Thuộc tính của trang Ví voucher (SCR-PSG-36).
 */
export interface AccountVouchersPageProps {
  readonly searchParams?: Promise<{ readonly [key: string]: string | string[] | undefined }>;
}

/**
 * Trang Ví voucher (SCR-PSG-36 - Figma 1448:20565).
 * URL hỗ trợ preview:
 * - ?preview=ideal: Xem danh sách voucher khả dụng, đã dùng, hết hạn đầy đủ
 * - Không có preview: Gọi API GET /me/vouchers thật (hiện FeatureUnavailable)
 */
export default async function AccountVouchersPage(props: AccountVouchersPageProps) {
  const resolvedParams = props.searchParams ? await props.searchParams : undefined;
  const preview = getPreview(resolvedParams);

  const topBarHeader = (
    <div className="border-b border-vxn-border/60 bg-white">
      <div className="mx-auto max-w-7xl px-4 py-2.5 sm:px-6 lg:px-8">
        <PassengerTopBar
          breadcrumbs={[
            { label: "Trang chủ", href: "/" },
            { label: "Thành viên", href: "/plus" },
            { label: "Ví voucher" }
          ]}
        />
      </div>
    </div>
  );

  // Nhánh Preview: ideal
  if (preview === "ideal") {
    return (
      <div className="min-h-screen bg-[#f9f9ff]">
        {topBarHeader}
        <main className="mx-auto max-w-7xl px-4 py-8 sm:px-6 lg:px-8">
          <VouchersView vouchersData={userVouchersFixture} isPreview />
        </main>
      </div>
    );
  }

  // Nhánh Thật: gọi API backend
  const result = await getUserVouchers();

  if (result.status === "unavailable") {
    return (
      <div className="min-h-screen bg-[#f9f9ff]">
        {topBarHeader}
        <main className="mx-auto max-w-7xl px-4 py-12 sm:px-6 lg:px-8">
          <FeatureUnavailable
            title="Ví voucher chưa sẵn sàng"
            description="Dịch vụ quản lý ví voucher đang được kết nối với hệ thống backend. Vui lòng quay lại sau."
            endpoint={result.endpoint}
          />
        </main>
      </div>
    );
  }

  if (result.status === "error") {
    return (
      <div className="min-h-screen bg-[#f9f9ff]">
        {topBarHeader}
        <main className="mx-auto max-w-7xl px-4 py-12 sm:px-6 lg:px-8">
          <FeatureUnavailable
            title="Không thể tải ví voucher"
            description={result.message}
          />
        </main>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-[#f9f9ff]">
      {topBarHeader}
      <main className="mx-auto max-w-7xl px-4 py-8 sm:px-6 lg:px-8">
        <VouchersView vouchersData={result.data} />
      </main>
    </div>
  );
}
