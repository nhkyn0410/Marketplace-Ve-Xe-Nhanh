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
import { ReviewModeration } from "./review-moderation";
import { VehicleImageReview } from "./vehicle-image-review";

const PUBLIC_CONTENT = "public-content";
const VEHICLE_IMAGES = "vehicle-images";

/**
 * Màn Kiểm duyệt (Figma ADM-10a…10d; UC-28): tab "Ảnh phương tiện" (FR-ADM-20) và "Nội dung công khai" (banner, câu hỏi
 * thường gặp, trang tĩnh — FR-ADM-13) và "Đánh giá" (mặc định — TASK-TRUST-001, BR-55). Tab đang mở nằm trên URL (`?tab=`).
 */
export function ModerationScreen() {
  const router = useRouter();
  const pathname = usePathname();
  const params = useSearchParams();
  const requested = params.get("tab");
  const tab = requested === PUBLIC_CONTENT || requested === VEHICLE_IMAGES ? requested : "reviews";
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
        onValueChange={(next) => router.replace(next === "reviews" ? pathname : `${pathname}?tab=${next}`, { scroll: false })}
        className="flex flex-col gap-6"
      >
        <TabsList className="h-10 w-fit max-w-full overflow-x-auto" aria-label="Loại nội dung">
          <TabsTrigger value="reviews" className={TAB_TRIGGER}>
            Đánh giá
          </TabsTrigger>
          <TabsTrigger value={VEHICLE_IMAGES} className={TAB_TRIGGER}>
            Ảnh phương tiện
          </TabsTrigger>
          <TabsTrigger value={PUBLIC_CONTENT} className={TAB_TRIGGER}>
            Nội dung công khai
          </TabsTrigger>
        </TabsList>
        <TabsContent value="reviews" className="flex flex-col gap-6">
          <ReviewModeration />
        </TabsContent>
        <TabsContent value={VEHICLE_IMAGES} className="flex flex-col gap-6">
          <VehicleImageReview />
        </TabsContent>
        <TabsContent value={PUBLIC_CONTENT} className="flex flex-col gap-6">
          <PublicContentPanel />
        </TabsContent>
      </Tabs>
    </div>
  );
}
