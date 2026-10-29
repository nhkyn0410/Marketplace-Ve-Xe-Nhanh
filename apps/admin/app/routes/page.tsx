import type { Metadata } from "next";
import { Suspense } from "react";

import { OperationScreen } from "../../components/operation/operation-screen";

export const metadata: Metadata = { title: "Tuyến & chuyến" };

/** Tuyến & chuyến của mọi nhà xe (tự thiết kế 28/10/2026, chờ duyệt). */
export default function RoutesPage() {
  // `useSearchParams` (tab đang mở) cần ranh giới Suspense khi build tĩnh.
  return (
    <Suspense>
      <OperationScreen />
    </Suspense>
  );
}
