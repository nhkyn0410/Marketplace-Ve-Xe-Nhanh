import { Suspense } from "react";

import { PolicyVersionPage } from "../../../../components/policy/policy-version-page";

export default function PolicyVersionDetailPage() {
  return (
    <Suspense>
      <PolicyVersionPage />
    </Suspense>
  );
}
