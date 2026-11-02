import type { Metadata } from "next";
import { Suspense } from "react";

import { SupportScreen } from "../../components/support/support-screen";

export const metadata: Metadata = { title: "Hỗ trợ" };

/** Hỗ trợ (Figma "Nhà xe · Hỗ trợ" 01–03; TASK-TRUST-001). */
export default function SupportPage() {
  // `useSearchParams` (tab + hồ sơ đang mở) cần ranh giới Suspense khi build tĩnh.
  return (
    <Suspense>
      <SupportScreen />
    </Suspense>
  );
}
