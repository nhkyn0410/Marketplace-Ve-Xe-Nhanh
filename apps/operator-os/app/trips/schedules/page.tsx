import type { Metadata } from "next";

import { TripScheduleList } from "../../../components/trip/trip-schedule-list";

export const metadata: Metadata = { title: "Lịch chạy lặp lại" };

export default function TripSchedulesPage() {
  return <TripScheduleList />;
}
