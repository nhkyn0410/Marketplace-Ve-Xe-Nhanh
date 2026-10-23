import type { Metadata } from "next";
import { Suspense } from "react";

import { LoyaltyScreen } from "../../components/loyalty/loyalty-screen";

export const metadata: Metadata = { title: "VXN Plus" };

/** VXN Plus (Figma ADM-12a…12d; TASK-LOY-001). */
export default function LoyaltyPage() {
  // `useSearchParams` (tab đang mở) cần ranh giới Suspense khi build tĩnh.
  return (
    <Suspense>
      <LoyaltyScreen />
    </Suspense>
  );
}
