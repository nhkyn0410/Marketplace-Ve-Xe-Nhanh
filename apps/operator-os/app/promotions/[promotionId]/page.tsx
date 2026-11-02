import type { Metadata } from "next";

import { PromotionEditor } from "../../../components/promotion/promotion-editor";

export const metadata: Metadata = { title: "Khuyến mãi" };

/** Chi tiết / sửa khuyến mãi của nhà xe (TASK-PROM-001). */
export default async function PromotionPage({ params }: { params: Promise<{ promotionId: string }> }) {
  const { promotionId } = await params;
  return <PromotionEditor promotionId={promotionId} />;
}
