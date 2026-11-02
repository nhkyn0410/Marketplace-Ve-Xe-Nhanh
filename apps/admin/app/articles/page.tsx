import { Suspense } from "react";

import { ArticleScreen } from "../../components/article/article-screen";

export default function ArticlesPage() {
  // `useSearchParams` (tab đang mở) cần ranh giới Suspense khi build tĩnh.
  return (
    <Suspense>
      <ArticleScreen />
    </Suspense>
  );
}
