import type { Metadata } from "next";

import { TicketDetailScreen } from "../../../../components/support/ticket-detail";

export const metadata: Metadata = { title: "Chi tiết khiếu nại" };

/** Chi tiết khiếu nại (Figma ADM-09b; TASK-TRUST-001). */
export default async function TicketDetailPage({ params }: { params: Promise<{ ticketId: string }> }) {
  const { ticketId } = await params;
  return <TicketDetailScreen ticketId={ticketId} />;
}
