import type { Metadata } from "next";

import { PromotionEditor } from "../../../components/promotion/promotion-editor";

export const metadata: Metadata = { title: "Tạo khuyến mãi" };

/** Tạo khuyến mãi (Figma "Nhà xe · Khuyến mãi / Tạo"; TASK-PROM-001). */
export default function NewPromotionPage() {
  return <PromotionEditor />;
}
