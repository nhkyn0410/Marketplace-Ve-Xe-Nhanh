import type { Metadata } from "next";
import { Suspense } from "react";

import { FareEditor } from "../../../components/fare/fare-editor";

export const metadata: Metadata = { title: "Tạo bảng giá" };

export default function NewFarePage() {
  // `Suspense`: trình soạn đọc tham số URL (`useSearchParams`) nên Next yêu cầu ranh giới này khi dựng tĩnh.
  return (
    <Suspense>
      <FareEditor />
    </Suspense>
  );
}
