import type { Metadata } from "next";

import { SeatMapEditor } from "../../../components/seat-map/seat-map-editor";

export const metadata: Metadata = { title: "Sơ đồ ghế" };

export default async function SeatMapPage({ params }: { params: Promise<{ seatMapId: string }> }) {
  const { seatMapId } = await params;
  return <SeatMapEditor seatMapId={seatMapId} />;
}
