import type { Metadata } from "next";

import { RouteDetailScreen } from "../../../components/operation/route-detail";

export const metadata: Metadata = { title: "Chi tiết tuyến" };

export default async function RouteDetailPage({ params }: { params: Promise<{ routeId: string }> }) {
  const { routeId } = await params;
  return <RouteDetailScreen routeId={routeId} />;
}
