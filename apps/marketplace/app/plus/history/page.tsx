import { PassengerTopBar } from "../../../components/passenger-topbar";
import { ErrorState, FeatureUnavailable } from "../../../components/states";
import { AccountSignInRequired } from "../../../components/account/account-sign-in-required";
import { LoyaltyHistoryView } from "../../../components/loyalty/loyalty-history-view";
import { getLoyaltyHistory } from "../../../lib/data/loyalty";
import { getPreview } from "../../../lib/preview";
import { loyaltyHistoryFixture } from "../../../lib/preview/fixtures/loyalty";

/**
 * Thuộc tính của trang Lịch sử điểm (SCR-PSG-34).
 */
export interface PlusHistoryPageProps {
  readonly searchParams?: Promise<{ readonly [key: string]: string | string[] | undefined }>;
}

/**
 * Trang Lịch sử điểm thưởng VXN Plus (SCR-PSG-34 - Figma 1448:19985).
 * URL hỗ trợ preview:
 * - ?preview=ideal: Xem bảng lịch sử điểm đầy đủ dữ liệu
 * - Không có preview: Gọi API GET /me/loyalty/transactions thật.
 */
export default async function PlusHistoryPage(props: PlusHistoryPageProps) {
  const resolvedParams = props.searchParams ? await props.searchParams : undefined;
  const preview = getPreview(resolvedParams);

  const topBarHeader = (
    <PassengerTopBar
      breadcrumbs={[
        { label: "Trang chủ", href: "/" },
        { label: "Thành viên", href: "/plus" },
        { label: "Lịch sử điểm" }
      ]}
    />
  );

  // Nhánh Preview: ideal
  if (preview === "ideal") {
    return (
      <div className="min-h-viewport bg-[#f9f9ff]">
        {topBarHeader}
        <main className="mx-auto w-full max-w-[1200px] px-4 py-8 sm:px-6 lg:px-14">
          <LoyaltyHistoryView historyData={loyaltyHistoryFixture} isPreview />
        </main>
      </div>
    );
  }

  // Nhánh Thật: gọi API backend
  const result = await getLoyaltyHistory();

  if (result.status === "unavailable") {
    return (
      <div className="min-h-viewport bg-[#f9f9ff]">
        {topBarHeader}
        <main className="mx-auto w-full max-w-[1200px] px-4 py-12 sm:px-6 lg:px-14">
          <FeatureUnavailable
            title="Lịch sử điểm chưa sẵn sàng"
            description="Lịch sử điểm hiện chưa khả dụng. Vui lòng quay lại sau."
            endpoint={result.endpoint}
          />
        </main>
      </div>
    );
  }

  if (result.status === "error") {
    if (result.httpStatus === 401) return <AccountSignInRequired />;
    return (
      <div className="min-h-viewport bg-[#f9f9ff]">
        {topBarHeader}
        <main className="mx-auto w-full max-w-[1200px] px-4 py-12 sm:px-6 lg:px-14">
          <ErrorState
            title="Không thể tải lịch sử điểm"
            description={result.message}
          />
        </main>
      </div>
    );
  }

  return (
    <div className="min-h-viewport bg-[#f9f9ff]">
      {topBarHeader}
      <main className="mx-auto w-full max-w-[1200px] px-4 py-8 sm:px-6 lg:px-14">
        <LoyaltyHistoryView historyData={result.data} />
      </main>
    </div>
  );
}
