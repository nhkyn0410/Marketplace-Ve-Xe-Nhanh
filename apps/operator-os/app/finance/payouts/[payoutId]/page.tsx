import type { Metadata } from "next";

import { PayoutDetailScreen } from "../../../../components/finance/payout-detail";

export const metadata: Metadata = { title: "Kỳ chi trả" };

export default async function PayoutDetailPage({ params }: { params: Promise<{ payoutId: string }> }) {
  const { payoutId } = await params;
  return <PayoutDetailScreen payoutId={payoutId} />;
}
