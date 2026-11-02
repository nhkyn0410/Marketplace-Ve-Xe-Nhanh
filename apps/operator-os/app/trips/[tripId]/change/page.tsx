import type { Metadata } from "next";

import { TripChangeForm } from "../../../../components/trip/trip-change-form";

export const metadata: Metadata = { title: "Đổi lịch chạy" };

/** Đổi lịch chạy của chuyến đang bán / đã bán vé (TASK-TRN-008). */
export default async function ChangeTripPage({ params }: { params: Promise<{ tripId: string }> }) {
  const { tripId } = await params;
  return <TripChangeForm tripId={tripId} />;
}
