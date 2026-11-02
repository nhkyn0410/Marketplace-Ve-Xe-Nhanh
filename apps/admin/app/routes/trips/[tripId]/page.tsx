import type { Metadata } from "next";

import { TripDetailScreen } from "../../../../components/operation/trip-detail";

export const metadata: Metadata = { title: "Chi tiết chuyến" };

export default async function TripDetailPage({ params }: { params: Promise<{ tripId: string }> }) {
  const { tripId } = await params;
  return <TripDetailScreen tripId={tripId} />;
}
