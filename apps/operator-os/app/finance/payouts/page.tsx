import type { Metadata } from "next";

import { PayoutList } from "../../../components/finance/payout-list";

export const metadata: Metadata = { title: "Chi trả" };

/** Tài chính — Chi trả (Figma "Nhà xe · Tài chính / 02"; TASK-OPR-002). */
export default function PayoutsPage() {
  return <PayoutList />;
}
