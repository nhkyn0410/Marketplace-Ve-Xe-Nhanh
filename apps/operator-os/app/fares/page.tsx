import type { Metadata } from "next";

import { FareList } from "../../components/fare/fare-list";

export const metadata: Metadata = { title: "Bảng giá" };

export default function FaresPage() {
  return <FareList />;
}
