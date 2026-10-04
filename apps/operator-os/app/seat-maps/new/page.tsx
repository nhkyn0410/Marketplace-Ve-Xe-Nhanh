import type { Metadata } from "next";

import { SeatMapEditor } from "../../../components/seat-map/seat-map-editor";
import { parseSeatMapId, parseVehicleReturn } from "../../../lib/seat-map/editor-params";

export const metadata: Metadata = { title: "Tạo sơ đồ ghế" };

export default async function NewSeatMapPage({
  searchParams
}: {
  searchParams: Promise<{ copyFrom?: string | string[]; vehicle?: string | string[] }>;
}) {
  const { copyFrom, vehicle } = await searchParams;
  return <SeatMapEditor copyFromId={parseSeatMapId(copyFrom)} vehicle={parseVehicleReturn(vehicle)} />;
}
