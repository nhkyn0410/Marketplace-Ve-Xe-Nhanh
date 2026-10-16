"use client";

import { Button } from "@vexenhanh/ui/components/button";
import { TAB_TRIGGER } from "@vexenhanh/ui/components/list-controls";
import { BUTTON } from "@vexenhanh/ui/components/list-parts";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@vexenhanh/ui/components/tabs";
import { Plus } from "lucide-react";
import Link from "next/link";
import { usePathname, useRouter, useSearchParams } from "next/navigation";

import { PageHeader } from "../page-header";
import { PublicContentPanel } from "./public-content-panel";
import { VehicleImageReview } from "./vehicle-image-review";

const PUBLIC_CONTENT = "public-content";

/**
 * Màn Kiểm duyệt (Figma ADM-10a…10d; UC-28): tab "Ảnh phương tiện" (FR-ADM-20) và "Nội dung công khai" (banner, câu hỏi
 * thường gặp, trang tĩnh — FR-ADM-13). Tab đang mở nằm trên URL (`?tab=public-content`). "Đánh giá" chờ `TASK-TRUST-001`.
 */
export function ModerationScreen() {
  const router = useRouter();
  const pathname = usePathname();
  const params = useSearchParams();
  const tab = params.get("tab") === PUBLIC_CONTENT ? PUBLIC_CONTENT : "vehicle-images";
  return (
    <div className="flex flex-col gap-6">
      <PageHeader
        title="Kiểm duyệt"
        description="Kiểm duyệt nội dung hiển thị công khai trên Vé Xe Nhanh."
        actions={
          tab === PUBLIC_CONTENT ? (
            <Button asChild className={BUTTON}>
              <Link href="/moderation/content/new">
                <Plus className="size-[18px]" />
                Thêm nội dung
              </Link>
            </Button>
          ) : undefined
        }
      />
      <Tabs
        value={tab}
        onValueChange={(next) => router.replace(next === PUBLIC_CONTENT ? `${pathname}?tab=${PUBLIC_CONTENT}` : pathname, { scroll: false })}
        className="flex flex-col gap-6"
      >
        <TabsList className="h-10 w-fit max-w-full overflow-x-auto" aria-label="Loại nội dung">
          <TabsTrigger value="reviews" disabled className={TAB_TRIGGER} title="Chưa có trong bản này">
            Đánh giá
          </TabsTrigger>
          <TabsTrigger value="vehicle-images" className={TAB_TRIGGER}>
            Ảnh phương tiện
          </TabsTrigger>
          <TabsTrigger value={PUBLIC_CONTENT} className={TAB_TRIGGER}>
            Nội dung công khai
          </TabsTrigger>
        </TabsList>
        <TabsContent value="vehicle-images" className="flex flex-col gap-6">
          <VehicleImageReview />
        </TabsContent>
        <TabsContent value={PUBLIC_CONTENT} className="flex flex-col gap-6">
          <PublicContentPanel />
        </TabsContent>
      </Tabs>
    </div>
  );
}
