import type { Metadata } from "next";

import { RouteList } from "../../components/route/route-list";

export const metadata: Metadata = { title: "Tuyến đường" };

export default function RoutesPage() {
  return <RouteList />;
}
