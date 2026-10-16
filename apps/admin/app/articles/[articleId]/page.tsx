"use client";

import { useParams } from "next/navigation";
import { Suspense } from "react";

import { ArticleEditor } from "../../../components/article/article-editor";

export default function ArticleEditPage() {
  const { articleId } = useParams<{ articleId: string }>();
  return (
    <Suspense>
      <ArticleEditor key={articleId} articleId={articleId} />
    </Suspense>
  );
}
