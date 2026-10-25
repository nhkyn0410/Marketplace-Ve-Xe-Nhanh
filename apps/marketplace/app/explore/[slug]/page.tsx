import React from "react";
import { FeatureUnavailable } from "../../../components/states";
import { ArticleDetailView } from "../../../components/explore/article-detail-view";
import { getArticleBySlug } from "../../../lib/data/content";
import { getPreview } from "../../../lib/preview";
import { articleDetailFixture } from "../../../lib/preview/fixtures/content";

export interface ArticleDetailPageProps {
  readonly params: Promise<{ readonly slug: string }>;
  readonly searchParams?: Promise<{ readonly [key: string]: string | string[] | undefined }>;
}

/**
 * Trang Chi tiết bài viết cẩm nang (SCR-PSG-37 - Figma 1449:20924).
 * URL: /explore/[slug]
 * - Preview: /explore/da-lat-mua-da-quy?preview=ideal
 * - Thật: Không có ?preview, gọi hàm getArticleBySlug(slug) (hiện FeatureUnavailable)
 */
export default async function ArticleDetailPage(
  props: ArticleDetailPageProps
): Promise<React.JSX.Element> {
  const resolvedParams = await props.params;
  const slug = resolvedParams.slug;
  const resolvedSearchParams = props.searchParams ? await props.searchParams : undefined;
  const preview = getPreview(resolvedSearchParams);

  // Nhánh Preview: slug mẫu hoặc preview=ideal
  if (preview === "ideal" || slug === "da-lat-mua-da-quy" && preview) {
    return (
      <ArticleDetailView
        article={articleDetailFixture}
        isPreview={true}
      />
    );
  }

  // Nhánh Thật: gọi API backend
  const result = await getArticleBySlug(slug);

  if (result.status === "unavailable") {
    return (
      <div className="min-h-viewport bg-background">
        <main className="mx-auto max-w-5xl px-4 py-16 sm:px-6 lg:px-8">
          <FeatureUnavailable
            title="Nội dung bài viết chưa sẵn sàng"
            description="Bài viết cẩm nang đang được cập nhật từ hệ thống quản trị nội dung. Vui lòng quay lại sau."
            endpoint={result.endpoint}
          />
        </main>
      </div>
    );
  }

  if (result.status === "error") {
    return (
      <div className="min-h-viewport bg-background">
        <main className="mx-auto max-w-5xl px-4 py-16 sm:px-6 lg:px-8">
          <FeatureUnavailable
            title="Không thể tải bài viết"
            description={result.message}
          />
        </main>
      </div>
    );
  }

  return (
    <ArticleDetailView
      article={result.data}
      isPreview={false}
    />
  );
}
