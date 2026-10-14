import type { Metadata } from "next";

import { AccountSecurity } from "../../components/account/account-security";

export const metadata: Metadata = { title: "Tài khoản và bảo mật" };

export default function AccountPage() {
  return <AccountSecurity />;
}
