import type { Metadata } from "next";
import { Suspense } from "react";

import { OperatorDetailScreen } from "../../../components/operator/operator-detail";

export const metadata: Metadata = { title: "Chi tiết nhà xe" };

export default async function OperatorDetailPage({ params }: { params: Promise<{ operatorId: string }> }) {
  const { operatorId } = await params;
  // `useSearchParams` (tab đang mở) cần ranh giới Suspense khi build tĩnh.
  return (
    <Suspense>
      <OperatorDetailScreen operatorId={operatorId} />
    </Suspense>
  );
}
