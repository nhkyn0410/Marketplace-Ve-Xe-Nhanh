import type { Metadata } from "next";

import { PayoutDetailScreen } from "../../../components/payout/payout-detail";

export const metadata: Metadata = { title: "Chi tiết chi trả" };

export default async function PayoutDetailPage({ params }: { params: Promise<{ payoutId: string }> }) {
  const { payoutId } = await params;
  return <PayoutDetailScreen payoutId={payoutId} />;
}
