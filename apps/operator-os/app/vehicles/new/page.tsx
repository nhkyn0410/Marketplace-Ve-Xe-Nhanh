import type { Metadata } from "next";
import { Suspense } from "react";

import { VehicleForm } from "../../../components/vehicle/vehicle-form";

export const metadata: Metadata = { title: "Thêm phương tiện" };

export default function NewVehiclePage() {
  // `Suspense`: form đọc tham số URL (`useSearchParams`) nên Next yêu cầu ranh giới này khi dựng tĩnh.
  return (
    <Suspense>
      <VehicleForm />
    </Suspense>
  );
}
