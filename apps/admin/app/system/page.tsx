import { Suspense } from "react";

import { SystemScreen } from "../../components/system/system-screen";

export default function SystemPage() {
  // `useSearchParams` (tab đang mở) cần ranh giới Suspense khi build tĩnh.
  return (
    <Suspense>
      <SystemScreen />
    </Suspense>
  );
}
