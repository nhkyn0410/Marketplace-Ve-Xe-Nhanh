"use client";

import { Suspense } from "react";

import { ArticleEditor } from "../../../components/article/article-editor";

export default function NewArticlePage() {
  return (
    <Suspense>
      <ArticleEditor articleId={null} />
    </Suspense>
  );
}
