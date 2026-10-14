import type { Metadata } from "next";

import { EmployeeList } from "../../components/employee/employee-list";

export const metadata: Metadata = { title: "Nhân viên" };

export default function EmployeesPage() {
  return <EmployeeList />;
}
