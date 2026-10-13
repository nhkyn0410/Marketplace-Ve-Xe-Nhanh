import type { Metadata } from "next";

import { TripForm } from "../../../../components/trip/trip-form";

export const metadata: Metadata = { title: "Sửa chuyến" };

export default async function EditTripPage({ params }: { params: Promise<{ tripId: string }> }) {
  const { tripId } = await params;
  return <TripForm tripId={tripId} />;
}
