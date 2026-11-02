import type { Metadata } from "next";

import { ApplicationPage } from "../../../components/register/application-page";

export const metadata: Metadata = { title: "Hồ sơ đăng ký nhà xe" };

export default function RegisterApplicationPage() {
  return <ApplicationPage />;
}
