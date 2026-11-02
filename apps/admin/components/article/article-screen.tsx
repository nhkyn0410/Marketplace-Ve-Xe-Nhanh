"use client";

import { Button } from "@vexenhanh/ui/components/button";
import { TAB_TRIGGER } from "@vexenhanh/ui/components/list-controls";
import { BUTTON } from "@vexenhanh/ui/components/list-parts";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@vexenhanh/ui/components/tabs";
import { CircleCheck, Plus } from "lucide-react";
import Link from "next/link";
import { usePathname, useRouter, useSearchParams } from "next/navigation";
import { useState } from "react";

import type { ArticleCategory } from "../../lib/article/article-api";
import { PageHeader } from "../page-header";
import { ArticleList } from "./article-list";
import { CategoryPanel } from "./category-panel";

/** Màn Bài viết (Figma ADM-13a, 13c; UC-40): tab Bài viết / Chuyên mục, tab nằm trên địa chỉ (`?tab=`). */
export function ArticleScreen() {
  const router = useRouter();
  const pathname = usePathname();
  const params = useSearchParams();
  const tab = params.get("tab") === "categories" ? "categories" : "articles";
  const [editing, setEditing] = useState<ArticleCategory | "new" | null>(null);
  const [notice, setNotice] = useState<string | null>(null);

  return (
    <div className="flex flex-col gap-6">
      <PageHeader
        title="Bài viết"
        description="Tin tức và cẩm nang hiển thị ở trang Khám phá."
        actions={
          tab === "articles" ? (
            <Button asChild className={`${BUTTON} min-w-40`}>
              <Link href="/articles/new">
                <Plus className="size-[18px]" />
                Viết bài mới
              </Link>
            </Button>
          ) : (
            <Button className={`${BUTTON} min-w-40`} onClick={() => setEditing("new")}>
              <Plus className="size-[18px]" />
              Thêm chuyên mục
            </Button>
          )
        }
      />
      {notice && (
        <div role="status" className="flex items-center gap-3 rounded-lg bg-success-50 px-5 py-3 text-sm leading-5 text-success-700">
          <CircleCheck className="size-5 shrink-0" />
          {notice}
        </div>
      )}
      <Tabs
        value={tab}
        onValueChange={(next) => {
          setNotice(null);
          router.replace(next === "categories" ? `${pathname}?tab=categories` : pathname, { scroll: false });
        }}
        className="flex flex-col gap-6"
      >
        <TabsList className="h-10 w-fit max-w-full overflow-x-auto" aria-label="Bài viết và chuyên mục">
          <TabsTrigger value="articles" className={TAB_TRIGGER}>
            Bài viết
          </TabsTrigger>
          <TabsTrigger value="categories" className={TAB_TRIGGER}>
            Chuyên mục
          </TabsTrigger>
        </TabsList>
        <TabsContent value="articles" className="flex flex-col gap-6">
          <ArticleList />
        </TabsContent>
        <TabsContent value="categories" className="flex flex-col gap-6">
          <CategoryPanel editing={editing} onEdit={setEditing} onCloseEdit={() => setEditing(null)} onDone={setNotice} />
        </TabsContent>
      </Tabs>
    </div>
  );
}
