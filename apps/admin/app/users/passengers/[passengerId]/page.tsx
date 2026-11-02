import type { Metadata } from "next";

import { PassengerDetailScreen } from "../../../../components/user/passenger-detail";

export const metadata: Metadata = { title: "Chi tiết hành khách" };

export default async function PassengerDetailPage({ params }: { params: Promise<{ passengerId: string }> }) {
  const { passengerId } = await params;
  return <PassengerDetailScreen passengerId={decodeURIComponent(passengerId)} />;
}
