import { Suspense } from "react";

import { StopPointScreen } from "../../components/stop-point/stop-point-screen";

export default function StopPointsPage() {
  // `useSearchParams` (tab đang mở) cần ranh giới Suspense khi build tĩnh.
  return (
    <Suspense>
      <StopPointScreen />
    </Suspense>
  );
}
