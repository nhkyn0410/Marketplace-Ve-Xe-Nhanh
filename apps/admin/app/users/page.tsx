import { Suspense } from "react";

import { UserScreen } from "../../components/user/user-screen";

export default function UsersPage() {
  // `useSearchParams` (tab đang mở) cần ranh giới Suspense khi build tĩnh.
  return (
    <Suspense>
      <UserScreen />
    </Suspense>
  );
}
