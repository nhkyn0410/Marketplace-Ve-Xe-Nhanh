import type { Metadata } from "next";
import { Suspense } from "react";

import { RouteForm } from "../../../components/route/route-form";

export const metadata: Metadata = { title: "Chỉnh sửa tuyến" };

export default async function EditRoutePage({ params }: { params: Promise<{ routeId: string }> }) {
  const { routeId } = await params;
  return (
    <Suspense>
      <RouteForm routeId={routeId} />
    </Suspense>
  );
}
