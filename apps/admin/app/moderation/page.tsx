import { Suspense } from "react";

import { ModerationScreen } from "../../components/moderation/moderation-screen";

export default function ModerationPage() {
  // `useSearchParams` (tab đang mở) cần ranh giới Suspense khi build tĩnh.
  return (
    <Suspense>
      <ModerationScreen />
    </Suspense>
  );
}
