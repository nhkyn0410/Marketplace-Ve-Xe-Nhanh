import type { Metadata } from "next";

import { ProfileScreen } from "../../components/profile/profile-screen";

export const metadata: Metadata = { title: "Hồ sơ & KYC" };

export default function ProfilePage() {
  return <ProfileScreen />;
}
