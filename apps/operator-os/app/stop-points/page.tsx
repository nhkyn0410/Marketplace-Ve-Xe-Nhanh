import type { Metadata } from "next";
import { Suspense } from "react";

import { StopPointScreen } from "../../components/stop-point/stop-point-screen";

export const metadata: Metadata = { title: "Điểm dừng" };

export default function StopPointsPage() {
  // `Suspense`: màn đọc tab đang mở từ URL (`useSearchParams`) nên Next yêu cầu ranh giới này khi dựng tĩnh.
  return (
    <Suspense>
      <StopPointScreen />
    </Suspense>
  );
}
