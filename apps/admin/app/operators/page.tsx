import { Suspense } from "react";

import { OperatorScreen } from "../../components/operator/operator-screen";

export default function OperatorsPage() {
  // `useSearchParams` (tab đang mở) cần ranh giới Suspense khi build tĩnh.
  return (
    <Suspense>
      <OperatorScreen />
    </Suspense>
  );
}
