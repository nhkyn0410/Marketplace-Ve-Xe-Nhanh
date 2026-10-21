import type { Metadata } from "next";

import { FinanceOverview } from "../../components/finance/finance-overview";

export const metadata: Metadata = { title: "Tài chính" };

/** Tài chính — Tổng quan (Figma "Nhà xe · Tài chính / 01"; TASK-OPR-002). */
export default function FinancePage() {
  return <FinanceOverview />;
}
