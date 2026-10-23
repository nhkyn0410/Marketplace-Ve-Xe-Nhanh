"use client";

import { useParams } from "next/navigation";

import { ApplicationDetail } from "../../../../components/operator-application/application-detail";

export default function ApplicationDetailPage() {
  const { applicationId } = useParams<{ applicationId: string }>();
  return <ApplicationDetail key={applicationId} applicationId={applicationId} />;
}
