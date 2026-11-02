import type { Metadata } from "next";

import { OfficeScreen } from "../../components/office/office-screen";

export const metadata: Metadata = { title: "Văn phòng bán vé" };

/** Hiển thị danh sách văn phòng bán vé trong phạm vi tài khoản nhà xe. */
export default function OfficesPage() {
  return <OfficeScreen />;
}
