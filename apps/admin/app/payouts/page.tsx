import type { Metadata } from "next";

import { PayoutList } from "../../components/payout/payout-list";

export const metadata: Metadata = { title: "Chi trả nhà xe" };

/** Chi trả nhà xe (Figma ADM-08a; TASK-BTP-006 / ADM-002). */
export default function PayoutsPage() {
  return <PayoutList />;
}
