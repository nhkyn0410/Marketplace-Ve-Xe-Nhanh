import type { Metadata } from "next";
import { Suspense } from "react";

import { PromotionScreen } from "../../components/promotion/promotion-screen";

export const metadata: Metadata = { title: "Khuyến mãi" };

/** Khuyến mãi (Figma ADM-11a, 11b; TASK-PROM-001). */
export default function PromotionsPage() {
  // `useSearchParams` (tab đang mở) cần ranh giới Suspense khi build tĩnh.
  return (
    <Suspense>
      <PromotionScreen />
    </Suspense>
  );
}
