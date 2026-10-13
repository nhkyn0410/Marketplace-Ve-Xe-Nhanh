import type { Metadata } from "next";

import { TripForm } from "../../../components/trip/trip-form";

export const metadata: Metadata = { title: "Tạo chuyến" };

export default function NewTripPage() {
  return <TripForm />;
}
