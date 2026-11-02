import type { Metadata } from "next";

import { CampaignScreen } from "../../components/notification/campaign-screen";

export const metadata: Metadata = { title: "Thông báo" };

/** Chiến dịch thông báo tới hành khách (TASK-NSR-003). */
export default function NotificationsPage() {
  return <CampaignScreen />;
}
