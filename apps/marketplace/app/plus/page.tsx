import { PassengerTopBar } from "../../components/passenger-topbar";
import { ErrorState, FeatureUnavailable } from "../../components/states";
import { AccountSignInRequired } from "../../components/account/account-sign-in-required";
import { LoyaltyView } from "../../components/loyalty/loyalty-view";
import { getLoyaltyProfile } from "../../lib/data/loyalty";
import { getPreview } from "../../lib/preview";
import {
  loyaltyProfileFixture,
  loyaltyRedemptionQuoteFixture
} from "../../lib/preview/fixtures/loyalty";
import type { Metadata } from "next";

export const metadata: Metadata = { title: "VXN Plus" };

/**
 * Thuộc tính của trang VXN Plus (SCR-PSG-33/35).
 */
export interface PlusPageProps {
  readonly searchParams?: Promise<{ readonly [key: string]: string | string[] | undefined }>;
}

/**
 * Trang Thành viên VXN Plus (SCR-PSG-33) & Modal Đổi điểm (SCR-PSG-35).
 * URL hỗ trợ preview:
 * - ?preview=ideal: Xem trang VXN Plus đầy đủ (Figma 1448:19617)
 * - ?preview=redeem: Mở sẵn modal Đổi điểm lấy voucher (Figma 1448:20406)
 * - Không có preview: Gọi API GET /me/loyalty thật (hiện FeatureUnavailable)
 */
export default async function PlusPage(props: PlusPageProps) {
  const resolvedParams = props.searchParams ? await props.searchParams : undefined;
  const preview = getPreview(resolvedParams);

  const topBarHeader = (
    <PassengerTopBar
      breadcrumbs={[
        { label: "Trang chủ", href: "/" },
        { label: "Thành viên" }
      ]}
    />
  );

  // Nhánh Preview: ideal hoặc redeem
  if (preview === "ideal" || preview === "redeem") {
    return (
      <div className="min-h-viewport bg-[#f9f9ff]">
        {topBarHeader}
        <div className="mx-auto w-full max-w-[1200px] px-4 py-8 sm:px-6 lg:px-14">
          <LoyaltyView
            profile={loyaltyProfileFixture}
            defaultQuote={loyaltyRedemptionQuoteFixture}
            initialOpenRedeemModal={preview === "redeem"}
            isPreview
          />
        </div>
      </div>
    );
  }

  // Nhánh Thật: gọi API backend
  const result = await getLoyaltyProfile();

  if (result.status === "unavailable") {
    return (
      <div className="min-h-viewport bg-[#f9f9ff]">
        {topBarHeader}
        <div className="mx-auto max-w-5xl px-4 py-12 sm:px-6 lg:px-8">
          <FeatureUnavailable
            title="Tính năng VXN Plus chưa sẵn sàng"
            description="Thông tin thành viên hiện chưa khả dụng. Vui lòng quay lại sau."
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
        <div className="mx-auto max-w-5xl px-4 py-12 sm:px-6 lg:px-8">
          <ErrorState
            title="Không thể tải dữ liệu thành viên"
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
        <LoyaltyView profile={result.data} initialOpenRedeemModal={resolvedParams?.["redeem"] === "1" && !!result.data.rules && result.data.memberStatus === "ACTIVE" && result.data.availablePoints >= result.data.rules.minRedeemPoints} />
      </div>
    </div>
  );
}
