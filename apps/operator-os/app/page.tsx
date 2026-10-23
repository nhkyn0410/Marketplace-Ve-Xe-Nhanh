import type { Metadata } from "next";

import { OperatorOverview } from "../components/overview/operator-overview";

export const metadata: Metadata = { title: "Tổng quan" };

/** Tổng quan Operator OS (TASK-RPT-001). */
export default function OperatorOsPage() {
  return <OperatorOverview />;
}
