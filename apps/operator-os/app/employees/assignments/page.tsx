import type { Metadata } from "next";

import { TripAssignmentList } from "../../../components/employee/trip-assignment-list";

export const metadata: Metadata = { title: "Phân công chuyến" };

export default function TripAssignmentsPage() {
  return <TripAssignmentList />;
}
