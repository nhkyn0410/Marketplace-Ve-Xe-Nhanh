import type { Metadata } from "next";

import { BookingList } from "../../components/booking/booking-list";

export const metadata: Metadata = { title: "Đặt vé" };

/** Đặt vé — danh sách đơn (Figma "Nhà xe · Đặt vé / 01"; TASK-OPR-003). */
export default function BookingsPage() {
  return <BookingList />;
}
