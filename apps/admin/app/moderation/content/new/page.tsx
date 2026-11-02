import { Suspense } from "react";

import { ContentPageEditor } from "../../../../components/moderation/content-page-editor";

export default function NewContentPage() {
  // `useSearchParams` (thông báo vừa tạo) cần ranh giới Suspense khi build tĩnh.
  return (
    <Suspense>
      <ContentPageEditor id={null} />
    </Suspense>
  );
}
