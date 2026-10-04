import type { Metadata } from "next";
import { Suspense } from "react";

import { VehicleForm } from "../../../components/vehicle/vehicle-form";

export const metadata: Metadata = { title: "Sửa phương tiện" };

export default async function EditVehiclePage({ params }: { params: Promise<{ vehicleId: string }> }) {
  const { vehicleId } = await params;
  return (
    <Suspense>
      <VehicleForm vehicleId={vehicleId} />
    </Suspense>
  );
}
