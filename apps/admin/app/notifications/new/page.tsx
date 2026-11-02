import type { Metadata } from "next";

import { CampaignEditor } from "../../../components/notification/campaign-editor";

export const metadata: Metadata = { title: "Tạo thông báo" };

/** Soạn chiến dịch thông báo mới (TASK-NSR-003). */
export default function NewNotificationPage() {
  return <CampaignEditor />;
}
