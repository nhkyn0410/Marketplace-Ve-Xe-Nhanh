import type { Metadata } from "next";

import { PaymentDetailScreen } from "../../../components/payment/payment-detail";

export const metadata: Metadata = { title: "Chi tiết thanh toán" };

/** Chi tiết thanh toán (Figma ADM-07b; TASK-ADM-002). */
export default async function PaymentDetailPage({ params }: { params: Promise<{ paymentId: string }> }) {
  const { paymentId } = await params;
  return <PaymentDetailScreen paymentId={paymentId} />;
}
