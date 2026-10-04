import type { Metadata } from "next";

import { VehicleList } from "../../components/vehicle/vehicle-list";

export const metadata: Metadata = { title: "Phương tiện" };

export default function VehiclesPage() {
  return <VehicleList />;
}
