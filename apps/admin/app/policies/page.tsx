import { Suspense } from "react";

import { PolicyScreen } from "../../components/policy/policy-screen";

export default function PoliciesPage() {
  // `useSearchParams` (tab đang mở) cần ranh giới Suspense khi build tĩnh.
  return (
    <Suspense>
      <PolicyScreen />
    </Suspense>
  );
}
