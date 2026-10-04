import type { Metadata } from "next";

import { SeatMapList } from "../../components/seat-map/seat-map-list";

export const metadata: Metadata = { title: "Sơ đồ ghế" };

export default function SeatMapsPage() {
  return <SeatMapList />;
}
