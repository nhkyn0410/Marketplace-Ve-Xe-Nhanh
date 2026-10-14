import type { Metadata } from "next";
import { Suspense } from "react";

import { FareEditor } from "../../../components/fare/fare-editor";

export const metadata: Metadata = { title: "Chỉnh sửa bảng giá" };

export default async function EditFarePage({ params }: { params: Promise<{ fareId: string }> }) {
  const { fareId } = await params;
  return (
    <Suspense>
      <FareEditor fareId={fareId} />
    </Suspense>
  );
}
