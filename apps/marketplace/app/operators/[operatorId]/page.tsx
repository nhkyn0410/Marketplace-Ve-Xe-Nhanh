import { Metadata } from "next";
import Link from "next/link";
import { getPreview, SearchParamsInput } from "../../../lib/preview";
import { operatorProfileFixture } from "../../../lib/preview/fixtures/operators";
import { getOperatorProfile } from "../../../lib/data/operators";
import { FeatureUnavailable } from "../../../components/states/feature-unavailable";
import { PassengerTopBar } from "../../../components/passenger-topbar";
import { OperatorHeader } from "../../../components/operators/operator-header";
import { OperatorMetrics } from "../../../components/operators/operator-metrics";
import { OperatorFeaturedRoutes } from "../../../components/operators/operator-featured-routes";
import { OperatorReviewsAndTerms } from "../../../components/operators/operator-reviews-and-terms";

export const metadata: Metadata = {
  title: "Thông tin nhà xe | Vé Xe Nhanh",
  description: "Xem đánh giá, tuyến đường và chỉ số chất lượng của nhà xe đối tác trên Vé Xe Nhanh."
};

interface PageProps {
  readonly params: Promise<{ readonly operatorId: string }>;
  readonly searchParams: Promise<SearchParamsInput>;
}

/**
 * Trang hồ sơ nhà xe SCR-PSG-17 (`/operators/[operatorId]`).
 */
export default async function OperatorDetailPage(props: PageProps) {
  const [params, searchParams] = await Promise.all([
    props.params,
    props.searchParams
  ]);

  const preview = getPreview(searchParams);

  // Topbar điều hướng theo Figma 1443:12312
  const topBarHeader = (operatorName: string) => (
    <div className="border-b border-vxn-border/60 bg-white">
      <div className="mx-auto max-w-7xl px-4 py-2.5 sm:px-6 lg:px-8">
        <PassengerTopBar
          breadcrumbs={[
            { label: "Trang chủ", href: "/" },
            { label: "Nhà xe", href: preview === "ideal" ? "/explore?preview=ideal" : "/explore" },
            { label: operatorName }
          ]}
        />
      </div>
    </div>
  );

  // Nhánh Preview phục vụ kiểm thử giao diện theo Figma
  if (preview === "ideal") {
    const operator = operatorProfileFixture;
    return (
      <div className="min-h-screen bg-[#f9f9ff]">
        {topBarHeader(operator.name)}
        <main className="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8 py-6 space-y-8">
          <OperatorHeader operator={operator} />
          <OperatorMetrics metrics={operator.metrics} />
          <OperatorFeaturedRoutes routes={operator.featuredRoutes} />
          <OperatorReviewsAndTerms
            reviews={operator.reviews}
            terms={operator.terms}
          />
        </main>
      </div>
    );
  }

  // Nhánh dữ liệu thật (Gọi API qua lib/data/operators.ts)
  const cursor = searchParams instanceof URLSearchParams ? searchParams.get("cursor") : searchParams?.cursor;
  const result = await getOperatorProfile(params.operatorId, typeof cursor === "string" ? cursor : undefined);

  if (result.status !== "ok") {
    return (
      <div className="min-h-screen bg-[#f9f9ff]">
        {topBarHeader("Hồ sơ nhà xe")}
        <main className="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8 py-12">
          <FeatureUnavailable
            title="Không thể tải hồ sơ nhà xe"
            description={result.status === "error" ? result.message : undefined}
          />
        </main>
      </div>
    );
  }

  // Hiển thị hồ sơ nhà xe từ API
  const operator = result.data;
  return (
    <div className="min-h-screen bg-[#f9f9ff]">
      {topBarHeader(operator.name)}
      <main className="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8 py-6 space-y-8">
        <OperatorHeader operator={operator} />
        <OperatorMetrics metrics={operator.metrics} />
        <OperatorFeaturedRoutes routes={operator.featuredRoutes} />
        <OperatorReviewsAndTerms
          reviews={operator.reviews}
          terms={operator.terms}
        />
        {operator.nextReviewCursor && <Link className="text-vxn-teal-800 underline" href={`/operators/${encodeURIComponent(params.operatorId)}?cursor=${encodeURIComponent(operator.nextReviewCursor)}#reviews`}>Trang đánh giá tiếp theo</Link>}
      </main>
    </div>
  );
}
