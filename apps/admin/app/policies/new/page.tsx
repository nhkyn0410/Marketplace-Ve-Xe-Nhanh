import { Suspense } from "react";

import { NewPolicyPage } from "../../../components/policy/policy-version-page";

export default function NewPolicyVersionPage() {
  return (
    <Suspense>
      <NewPolicyPage />
    </Suspense>
  );
}
