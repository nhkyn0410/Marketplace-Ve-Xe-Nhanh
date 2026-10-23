import React from "react";
import { FeatureUnavailable } from "../../components/states";
import { FaqView } from "../../components/faq/faq-view";
import { getFaqData } from "../../lib/data/content";
import { getPreview } from "../../lib/preview";
import { faqGroupsFixture } from "../../lib/preview/fixtures/content";

export interface FaqPageProps {
  readonly searchParams?: Promise<{ readonly [key: string]: string | string[] | undefined }>;
}

/**
 * Trang Câu hỏi thường gặp FAQ (SCR-PSG-03 - Figma 1449:21249).
 * URL: /faq
 * - Preview: /faq?preview=ideal
 * - Thật: Không có ?preview, gọi hàm getFaqData() (hiện FeatureUnavailable)
 */
export default async function FaqPage(
  props: FaqPageProps
): Promise<React.JSX.Element> {
  const resolvedSearchParams = props.searchParams ? await props.searchParams : undefined;
  const preview = getPreview(resolvedSearchParams);

  // Nhánh Preview: ideal
  if (preview === "ideal") {
    return (
      <FaqView
        faqGroups={faqGroupsFixture}
        isPreview={true}
      />
    );
  }

  // Nhánh Thật: gọi API backend
  const result = await getFaqData();

  if (result.status === "unavailable") {
    return (
      <div className="min-h-screen bg-background">
        <main className="mx-auto max-w-5xl px-4 py-16 sm:px-6 lg:px-8">
          <FeatureUnavailable
            title="Trung tâm trợ giúp FAQ chưa sẵn sàng"
            description="Hệ thống câu hỏi thường gặp đang được bảo trì và cập nhật dữ liệu. Bạn có thể gửi yêu cầu tại trung tâm hỗ trợ."
            endpoint={result.endpoint}
          />
        </main>
      </div>
    );
  }

  if (result.status === "error") {
    return (
      <div className="min-h-screen bg-background">
        <main className="mx-auto max-w-5xl px-4 py-16 sm:px-6 lg:px-8">
          <FeatureUnavailable
            title="Không thể tải câu hỏi thường gặp"
            description={result.message}
          />
        </main>
      </div>
    );
  }

  return (
    <FaqView
      faqGroups={result.data}
      isPreview={false}
    />
  );
}
