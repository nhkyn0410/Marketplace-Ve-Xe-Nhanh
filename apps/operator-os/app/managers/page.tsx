import type { Metadata } from "next";

import { ManagerList } from "../../components/manager/manager-list";

export const metadata: Metadata = { title: "Tài khoản quản lý" };

export default function ManagersPage() {
  return <ManagerList />;
}
