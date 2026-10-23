import type { Metadata } from "next";
import { Suspense } from "react";

import { TripScheduleForm } from "../../../../components/trip/trip-schedule-form";

export const metadata: Metadata = { title: "Tạo lịch chạy lặp lại" };

export default function NewTripSchedulePage() {
  // `useSearchParams` (thông báo vừa lưu) cần ranh giới Suspense khi build tĩnh.
  return (
    <Suspense>
      <TripScheduleForm />
    </Suspense>
  );
}
