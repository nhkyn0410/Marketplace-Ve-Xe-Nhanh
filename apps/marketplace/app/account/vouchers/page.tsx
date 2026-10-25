import { PassengerTopBar } from "../../../components/passenger-topbar";
import { ErrorState, FeatureUnavailable } from "../../../components/states";
import { AccountSignInRequired } from "../../../components/account/account-sign-in-required";
import { VouchersView } from "../../../components/vouchers/vouchers-view";
import { getUserVouchers } from "../../../lib/data/loyalty";
import { getPreview } from "../../../lib/preview";
import { userVouchersFixture } from "../../../lib/preview/fixtures/loyalty";
import type { Metadata } from "next";

export const metadata: Metadata = { title: "Ví voucher" };

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
    <PassengerTopBar
      breadcrumbs={[
        { label: "Trang chủ", href: "/" },
        { label: "Thành viên", href: "/plus" },
        { label: "Ví voucher" }
      ]}
    />
  );

  // Nhánh Preview: ideal
  if (preview === "ideal") {
    return (
      <div className="min-h-viewport bg-[#f9f9ff]">
        {topBarHeader}
        <div className="mx-auto w-full max-w-[1200px] px-4 py-8 sm:px-6 lg:px-14">
          <VouchersView vouchersData={userVouchersFixture} isPreview />
        </div>
      </div>
    );
  }

  // Nhánh Thật: gọi API backend
  const result = await getUserVouchers();

  if (result.status === "unavailable") {
    return (
      <div className="min-h-viewport bg-[#f9f9ff]">
        {topBarHeader}
        <div className="mx-auto w-full max-w-[1200px] px-4 py-12 sm:px-6 lg:px-14">
          <FeatureUnavailable
            title="Ví voucher chưa sẵn sàng"
            description="Ví voucher hiện chưa khả dụng. Vui lòng quay lại sau."
            endpoint={result.endpoint}
          />
        </div>
      </div>
    );
  }

  if (result.status === "error") {
    if (result.httpStatus === 401) return <AccountSignInRequired />;
    return (
      <div className="min-h-viewport bg-[#f9f9ff]">
        {topBarHeader}
        <div className="mx-auto w-full max-w-[1200px] px-4 py-12 sm:px-6 lg:px-14">
          <ErrorState
            title="Không thể tải ví voucher"
            description={result.message}
          />
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-viewport bg-[#f9f9ff]">
      {topBarHeader}
      <div className="mx-auto w-full max-w-[1200px] px-4 py-8 sm:px-6 lg:px-14">
        <VouchersView vouchersData={result.data} />
      </div>
    </div>
  );
}
