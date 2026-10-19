import type { Metadata } from "next";

import { ReportScreen } from "../../components/report/report-screen";

export const metadata: Metadata = { title: "Báo cáo" };

/** Báo cáo toàn hệ thống (Figma ADM-14a; TASK-RPT-002). */
export default function ReportsPage() {
  return <ReportScreen />;
}
