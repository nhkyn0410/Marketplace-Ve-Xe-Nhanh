import type { Metadata } from "next";
import { Suspense } from "react";

import { TripPassengerListScreen } from "../../../components/booking/trip-passenger-list";

export const metadata: Metadata = { title: "Danh sách hành khách" };

export default function TripPassengersPage() {
  // `Suspense`: màn đọc tham số URL (`useSearchParams`) nên Next yêu cầu ranh giới này khi dựng tĩnh.
  return (
    <Suspense>
      <TripPassengerListScreen />
    </Suspense>
  );
}
