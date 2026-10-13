import type { Metadata } from "next";
import { Suspense } from "react";

import { TripDetail } from "../../../components/trip/trip-detail";

export const metadata: Metadata = { title: "Chi tiết chuyến" };

export default async function TripDetailPage({ params }: { params: Promise<{ tripId: string }> }) {
  const { tripId } = await params;
  // `Suspense`: trang đọc tham số URL (`useSearchParams`) nên Next yêu cầu ranh giới này khi dựng tĩnh.
  return (
    <Suspense>
      <TripDetail tripId={tripId} />
    </Suspense>
  );
}
