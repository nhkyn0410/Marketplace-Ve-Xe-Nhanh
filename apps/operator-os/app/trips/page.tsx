import type { Metadata } from "next";

import { TripList } from "../../components/trip/trip-list";

export const metadata: Metadata = { title: "Chuyến xe" };

export default function TripsPage() {
  return <TripList />;
}
