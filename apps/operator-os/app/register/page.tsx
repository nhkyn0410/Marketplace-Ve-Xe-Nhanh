import type { Metadata } from "next";

import { RegisterStart } from "../../components/register/register-start";

export const metadata: Metadata = { title: "Đăng ký nhà xe" };

export default function RegisterPage() {
  return <RegisterStart />;
}
