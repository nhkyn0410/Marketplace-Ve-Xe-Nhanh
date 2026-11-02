import type { Metadata } from "next";

import { ReportScreen } from "../../components/report/report-screen";

export const metadata: Metadata = { title: "Báo cáo" };

/** Báo cáo (Figma "Nhà xe · Báo cáo / Tổng hợp"; TASK-RPT-001). */
export default function ReportsPage() {
  return <ReportScreen />;
}
