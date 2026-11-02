import type { Metadata } from "next";

import { DisputeDetailScreen } from "../../../../components/support/dispute-detail";

export const metadata: Metadata = { title: "Chi tiết tranh chấp" };

/** Chi tiết tranh chấp (Figma ADM-09d, 09e; TASK-TRUST-001). */
export default async function DisputeDetailPage({ params }: { params: Promise<{ disputeId: string }> }) {
  const { disputeId } = await params;
  return <DisputeDetailScreen disputeId={disputeId} />;
}
