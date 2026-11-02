import type { Metadata } from "next";

import { CampaignEditor } from "../../../components/notification/campaign-editor";

export const metadata: Metadata = { title: "Thông báo" };

/** Bản nháp hoặc kết quả gửi của một chiến dịch (TASK-NSR-003). */
export default async function NotificationPage({ params }: { params: Promise<{ campaignId: string }> }) {
  const { campaignId } = await params;
  return <CampaignEditor campaignId={campaignId} />;
}
