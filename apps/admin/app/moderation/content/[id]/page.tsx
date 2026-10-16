import { Suspense } from "react";

import { ContentPageEditor } from "../../../../components/moderation/content-page-editor";

export default async function EditContentPage({ params }: { params: Promise<{ id: string }> }) {
  const { id } = await params;
  return (
    <Suspense>
      <ContentPageEditor id={id} />
    </Suspense>
  );
}
