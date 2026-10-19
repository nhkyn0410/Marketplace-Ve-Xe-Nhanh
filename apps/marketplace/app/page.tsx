import { ExploreCardsSection } from "../components/home/explore-cards";
import { PartnerOperatorsSection } from "../components/home/partner-operators";
import { PlusAndGuideSection } from "../components/home/plus-and-guide";
import { PopularRoutesSection } from "../components/home/popular-routes";
import { SearchHero } from "../components/home/search-hero";
import { PassengerTopBar } from "../components/passenger-topbar";
import { ForbiddenState, ServiceUnavailableState } from "../components/states";
import { getProvinces } from "../lib/data/catalog";
import { getFeaturedOperators, getHandbookArticles, getPopularRoutes } from "../lib/data/home";
import { getPreview } from "../lib/preview";
import {
  featuredOperatorsFixture,
  handbookArticlesFixture,
  popularRoutesFixture,
  provincesFixture
} from "../lib/preview/fixtures/home";
import ErrorPage from "./error";
import NotFound from "./not-found";

/**
 * Thuộc tính của trang chủ Marketplace.
 */
export interface MarketplacePageProps {
  readonly searchParams?: Promise<{ readonly [key: string]: string | string[] | undefined }>;
}

/**
 * Trang chủ Marketplace (SCR-PSG-01) — hỗ trợ preview các trạng thái:
 * - ideal: Giao diện đầy đủ theo Figma 776:791
 * - operator-tab: Tab Theo nhà xe (836:113)
 * - operator-picker: Popover chọn nhà xe (837:131)
 * - 404, 500, 403, 503: Các trang lỗi nền tảng Lô 0
 * - Không có preview: Nhánh dữ liệu thật với endpoint hiện có và khối chưa sẵn sàng
 */
export default async function MarketplacePage(props: MarketplacePageProps) {
  const resolvedParams = props.searchParams ? await props.searchParams : undefined;
  const preview = getPreview(resolvedParams);

  // Xử lý các màn lỗi thuộc Lô 0
  if (preview === "404") {
    return <NotFound />;
  }

  if (preview === "500") {
    return <ErrorPage error={new Error("Sự cố máy chủ thử nghiệm")} reset={() => {}} />;
  }

  if (preview === "403") {
    return (
      <div data-no-footer="true" className="flex min-h-[calc(100vh-4rem)] flex-col bg-white">
        <PassengerTopBar
          breadcrumbs={[
            { label: "Trang chủ", href: "/" },
            { label: "Bạn không có quyền xem nội dung này" }
          ]}
        />
        <ForbiddenState />
      </div>
    );
  }

  if (preview === "503") {
    return (
      <div data-no-footer="true" className="flex min-h-[calc(100vh-4rem)] flex-col bg-white">
        <PassengerTopBar
          breadcrumbs={[
            { label: "Trang chủ", href: "/" },
            { label: "Dịch vụ giữ chỗ đang tạm gián đoạn" }
          ]}
        />
        <ServiceUnavailableState />
      </div>
    );
  }

  // Nhánh PREVIEW của SCR-PSG-01 (Lô 1)
  if (preview === "ideal" || preview === "operator-tab" || preview === "operator-picker") {
    const isOperatorTab = preview === "operator-tab" || preview === "operator-picker";
    const isPickerOpen = preview === "operator-picker";

    return (
      <div className="flex flex-col bg-[#f9f9ff]">
        <SearchHero
          provinces={provincesFixture}
          featuredOperators={featuredOperatorsFixture}
          initialTab={isOperatorTab ? "operator" : "trip"}
          initialPickerOpen={isPickerOpen}
        />
        <PopularRoutesSection routes={popularRoutesFixture} />
        <ExploreCardsSection />
        <PartnerOperatorsSection operators={featuredOperatorsFixture} />
        <PlusAndGuideSection articles={handbookArticlesFixture} />
      </div>
    );
  }

  // Nhánh DỮ LIỆU THẬT (không có ?preview)
  const [provincesResult, popularRoutesResult, featuredOperatorsResult, articlesResult] =
    await Promise.all([
      getProvinces(),
      getPopularRoutes(),
      getFeaturedOperators(),
      getHandbookArticles()
    ]);

  const provinces =
    provincesResult.status === "ok" ? provincesResult.data : provincesFixture;

  return (
    <div className="flex flex-col bg-[#f9f9ff]">
      <SearchHero
        provinces={provinces}
        featuredOperators={
          featuredOperatorsResult.status === "ok" ? featuredOperatorsResult.data : []
        }
        initialTab="trip"
      />
      <PopularRoutesSection
        routes={popularRoutesResult.status === "ok" ? popularRoutesResult.data : undefined}
        isUnavailable={popularRoutesResult.status === "unavailable"}
      />
      <ExploreCardsSection />
      <PartnerOperatorsSection
        operators={
          featuredOperatorsResult.status === "ok" ? featuredOperatorsResult.data : undefined
        }
        isUnavailable={featuredOperatorsResult.status === "unavailable"}
      />
      <PlusAndGuideSection
        articles={articlesResult.status === "ok" ? articlesResult.data : undefined}
        isUnavailable={articlesResult.status === "unavailable"}
      />
    </div>
  );
}
