import type { Metadata } from "next";
import { Suspense } from "react";

import { SupportScreen } from "../../components/support/support-screen";

export const metadata: Metadata = { title: "Khiếu nại & tranh chấp" };

/** Khiếu nại & tranh chấp (Figma ADM-09a, 09c; TASK-TRUST-001). */
export default function DisputesPage() {
  // `useSearchParams` (tab đang mở) cần ranh giới Suspense khi build tĩnh.
  return (
    <Suspense>
      <SupportScreen />
    </Suspense>
  );
}
