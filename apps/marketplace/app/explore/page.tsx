import { PassengerTopBar } from "../../components/passenger-topbar";
import { FeatureUnavailable } from "../../components/states";
import { ExploreView } from "../../components/explore/explore-view";
import { getArticles } from "../../lib/data/content";
import { getPreview } from "../../lib/preview";
import {
  articleCategoriesFixture,
  articlesListFixture,
  featuredArticleFixture
} from "../../lib/preview/fixtures/content";

/**
 * Thuộc tính của trang Khám phá (SCR-PSG-02).
 */
export interface ExplorePageProps {
  readonly searchParams?: Promise<{ readonly [key: string]: string | string[] | undefined }>;
}

/**
 * Trang Khám phá & Cẩm nang du lịch (SCR-PSG-02 - Figma 1449:20595).
 * URL hỗ trợ preview:
 * - ?preview=ideal: Xem danh sách bài viết cẩm nang đầy đủ
 * - Không có preview: Gọi API GET /articles thật (hiện FeatureUnavailable)
 */
export default async function ExplorePage(props: ExplorePageProps) {
  const resolvedParams = props.searchParams ? await props.searchParams : undefined;
  const preview = getPreview(resolvedParams);

  const topBarHeader = (
    <PassengerTopBar
      breadcrumbs={[
        { label: "Trang chủ", href: "/" },
        { label: "Khám phá" }
      ]}
    />
  );

  // Nhánh Preview: ideal
  if (preview === "ideal") {
    return (
      <div className="min-h-viewport bg-[#f9f9ff]">
        {topBarHeader}
        <main className="mx-auto w-full max-w-[1200px] px-4 py-8 sm:px-6 lg:px-14">
          <ExploreView
            categories={articleCategoriesFixture}
            featuredArticle={featuredArticleFixture}
            articles={articlesListFixture}
            isPreview
          />
        </main>
      </div>
    );
  }

  // Nhánh Thật: gọi API backend
  const category = typeof resolvedParams?.category === "string" ? resolvedParams.category : "all";
  const result = await getArticles(category, typeof resolvedParams?.cursor === "string" ? resolvedParams.cursor : undefined);

  if (result.status === "unavailable") {
    return (
      <div className="min-h-viewport bg-[#f9f9ff]">
        {topBarHeader}
        <main className="mx-auto w-full max-w-[1200px] px-4 py-12 sm:px-6 lg:px-14">
          <FeatureUnavailable
            title="Mục Khám phá chưa sẵn sàng"
            description="Dịch vụ bài viết cẩm nang đang được cập nhật từ hệ thống quản trị nội dung. Vui lòng quay lại sau."
            endpoint={result.endpoint}
          />
        </main>
      </div>
    );
  }

  if (result.status === "error") {
    return (
      <div className="min-h-viewport bg-[#f9f9ff]">
        {topBarHeader}
        <main className="mx-auto w-full max-w-[1200px] px-4 py-12 sm:px-6 lg:px-14">
          <FeatureUnavailable
            title="Không thể tải danh sách bài viết"
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
        <ExploreView
          key={`${category}:${typeof resolvedParams?.cursor === "string" ? resolvedParams.cursor : ""}`}
          initialCategory={category}
          categories={result.data.categories}
          featuredArticle={result.data.articles.find((article) => article.isFeatured)}
          articles={result.data.articles}
          nextCursor={result.data.nextCursor}
        />
      </main>
    </div>
  );
}
