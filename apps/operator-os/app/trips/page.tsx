import type { Metadata } from "next";
import { Suspense } from "react";

import { TripList } from "../../components/trip/trip-list";

export const metadata: Metadata = { title: "Chuyến xe" };

export default function TripsPage() {
  // `useSearchParams` (cách xem Danh sách / Lịch xe) cần ranh giới Suspense khi build tĩnh.
  return (
    <Suspense>
      <TripList />
    </Suspense>
  );
}
