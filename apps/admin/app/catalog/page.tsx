import { Suspense } from "react";

import { CatalogScreen } from "../../components/catalog/catalog-screen";

export default function CatalogPage() {
  // `useSearchParams` (tab đang mở) cần ranh giới Suspense khi build tĩnh.
  return (
    <Suspense>
      <CatalogScreen />
    </Suspense>
  );
}
