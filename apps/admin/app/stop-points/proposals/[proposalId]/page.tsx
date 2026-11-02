"use client";

import { useParams } from "next/navigation";

import { ProposalReview } from "../../../../components/stop-point/proposal-review";

export default function ProposalReviewPage() {
  const { proposalId } = useParams<{ proposalId: string }>();
  return <ProposalReview key={proposalId} proposalId={proposalId} />;
}
