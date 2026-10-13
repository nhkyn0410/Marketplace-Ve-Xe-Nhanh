import type { Metadata } from "next";
import { Suspense } from "react";

import { RouteForm } from "../../../components/route/route-form";

export const metadata: Metadata = { title: "Thêm tuyến" };

export default function NewRoutePage() {
  // `Suspense`: form đọc tham số URL (`useSearchParams`) nên Next yêu cầu ranh giới này khi dựng tĩnh.
  return (
    <Suspense>
      <RouteForm />
    </Suspense>
  );
}
