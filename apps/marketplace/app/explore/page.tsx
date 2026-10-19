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
    <div className="border-b border-vxn-border/60 bg-white">
      <div className="mx-auto max-w-7xl px-4 py-2.5 sm:px-6 lg:px-8">
        <PassengerTopBar
          breadcrumbs={[
            { label: "Trang chủ", href: "/" },
            { label: "Khám phá" }
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
          <ExploreView
            categories={articleCategoriesFixture}
            featuredArticle={featuredArticleFixture}
            articles={articlesListFixture}
          />
        </main>
      </div>
    );
  }

  // Nhánh Thật: gọi API backend
  const result = await getArticles();

  if (result.status === "unavailable") {
    return (
      <div className="min-h-screen bg-[#f9f9ff]">
        {topBarHeader}
        <main className="mx-auto max-w-7xl px-4 py-12 sm:px-6 lg:px-8">
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
      <div className="min-h-screen bg-[#f9f9ff]">
        {topBarHeader}
        <main className="mx-auto max-w-7xl px-4 py-12 sm:px-6 lg:px-8">
          <FeatureUnavailable
            title="Không thể tải danh sách bài viết"
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
        <ExploreView
          categories={result.data.categories}
          featuredArticle={result.data.articles[0] ?? featuredArticleFixture}
          articles={result.data.articles}
        />
      </main>
    </div>
  );
}
