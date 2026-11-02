import type { Metadata } from "next";
import { Suspense } from "react";

import { TripScheduleForm } from "../../../../components/trip/trip-schedule-form";

export const metadata: Metadata = { title: "Lịch chạy lặp lại" };

export default async function TripSchedulePage({ params }: { params: Promise<{ scheduleId: string }> }) {
  const { scheduleId } = await params;
  // `useSearchParams` (thông báo vừa lưu) cần ranh giới Suspense khi build tĩnh.
  return (
    <Suspense>
      <TripScheduleForm scheduleId={scheduleId} />
    </Suspense>
  );
}
