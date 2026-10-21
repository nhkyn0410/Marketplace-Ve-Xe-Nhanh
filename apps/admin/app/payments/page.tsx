import type { Metadata } from "next";
import { Suspense } from "react";

import { PaymentScreen } from "../../components/payment/payment-screen";

export const metadata: Metadata = { title: "Thanh toán & hoàn tiền" };

/** Thanh toán & hoàn tiền (Figma ADM-07a, 07c, 07d; TASK-ADM-002). */
export default function PaymentsPage() {
  // `useSearchParams` (tab đang mở) cần ranh giới Suspense khi build tĩnh.
  return (
    <Suspense>
      <PaymentScreen />
    </Suspense>
  );
}
