import React from "react";
import { FeatureUnavailable } from "../../../components/states";
import { LegalView } from "../../../components/legal/legal-view";
import { getLegalDocument, getPublishedPageLinks } from "../../../lib/data/content";
import { getPreview } from "../../../lib/preview";
import { legalTermsDocumentFixture } from "../../../lib/preview/fixtures/content";

export interface LegalDocumentPageProps {
  readonly params: Promise<{ readonly slug: string }>;
  readonly searchParams?: Promise<{ readonly [key: string]: string | string[] | undefined }>;
}

/**
 * Trang Văn bản pháp lý & Điều khoản (SCR-PSG-06 - Figma 1449:22136).
 * URL: /legal/[slug]
 * - Preview: /legal/terms-of-service?preview=ideal
 * - Thật: Không có ?preview, gọi hàm getLegalDocument(slug) (hiện FeatureUnavailable)
 */
export default async function LegalDocumentPage(
  props: LegalDocumentPageProps
): Promise<React.JSX.Element> {
  const resolvedParams = await props.params;
  const slug = resolvedParams.slug;
  const resolvedSearchParams = props.searchParams ? await props.searchParams : undefined;
  const preview = getPreview(resolvedSearchParams);

  // Nhánh Preview: ideal
  if (
    preview === "ideal" ||
    slug === "terms-of-service" && preview ||
    slug === "dieu-khoan-su-dung" && preview
  ) {
    return (
      <LegalView
        document={legalTermsDocumentFixture}
        currentSlug={slug}
        isPreview={true}
      />
    );
  }

  // Nhánh Thật: gọi API backend
  const [result, pageLinks] = await Promise.all([getLegalDocument(slug), getPublishedPageLinks()]);

  if (result.status === "unavailable") {
    return (
      <div className="min-h-viewport bg-background">
        <div className="mx-auto max-w-5xl px-4 py-16 sm:px-6 lg:px-8">
          <FeatureUnavailable
            title="Văn bản pháp lý chưa sẵn sàng"
            description="Nội dung điều khoản pháp lý đang được cập nhật từ ban quản trị. Vui lòng quay lại sau hoặc liên hệ tổng đài hỗ trợ."
            endpoint={result.endpoint}
          />
        </div>
      </div>
    );
  }

  if (result.status === "error") {
    return (
      <div className="min-h-viewport bg-background">
        <div className="mx-auto max-w-5xl px-4 py-16 sm:px-6 lg:px-8">
          <FeatureUnavailable
            title="Không thể tải văn bản pháp lý"
            description={result.message}
          />
        </div>
      </div>
    );
  }

  return (
    <LegalView
      document={result.data}
      currentSlug={slug}
      isPreview={false}
      pageLinks={pageLinks}
    />
  );
}
