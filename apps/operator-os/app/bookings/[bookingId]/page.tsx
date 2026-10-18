import type { Metadata } from "next";

import { BookingDetail } from "../../../components/booking/booking-detail";

export const metadata: Metadata = { title: "Chi tiết đơn" };

export default async function BookingDetailPage({ params }: { params: Promise<{ bookingId: string }> }) {
  const { bookingId } = await params;
  return <BookingDetail bookingId={bookingId} />;
}
