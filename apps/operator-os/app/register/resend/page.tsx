import type { Metadata } from "next";
import { Suspense } from "react";

import { ResendLink } from "../../../components/register/resend-link";

export const metadata: Metadata = { title: "Gửi lại link hồ sơ" };

export default function ResendPage() {
  // `useSearchParams` cần Suspense để Next dựng trang tĩnh.
  return (
    <Suspense>
      <ResendLink />
    </Suspense>
  );
}
