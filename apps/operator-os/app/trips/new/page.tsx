import type { Metadata } from "next";
import { Suspense } from "react";

import { TripForm } from "../../../components/trip/trip-form";

export const metadata: Metadata = { title: "Tạo chuyến" };

export default function NewTripPage() {
  // `useSearchParams` (xe / giờ điền sẵn khi mở từ Lịch xe) cần ranh giới Suspense khi build tĩnh.
  return (
    <Suspense>
      <TripForm />
    </Suspense>
  );
}
