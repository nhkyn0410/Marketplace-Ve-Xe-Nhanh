"use client";

import { TAB_TRIGGER } from "@vexenhanh/ui/components/list-controls";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@vexenhanh/ui/components/tabs";

import { PageHeader } from "../page-header";
import { VehicleImageReview } from "./vehicle-image-review";

/**
 * Màn Kiểm duyệt (Figma ADM-10a…10d; UC-28). Mới có tab "Ảnh phương tiện" (FR-ADM-20); "Đánh giá" và "Nội dung
 * công khai" thuộc phần còn lại của `TASK-ADM-003` (cần review / FAQ / banner) nên chưa mở được.
 */
export function ModerationScreen() {
  return (
    <div className="flex flex-col gap-6">
      <PageHeader title="Kiểm duyệt" description="Kiểm duyệt nội dung hiển thị công khai trên Vé Xe Nhanh." />
      <Tabs value="vehicle-images" className="flex flex-col gap-6">
        <TabsList className="h-10 w-fit max-w-full overflow-x-auto" aria-label="Loại nội dung">
          <TabsTrigger value="reviews" disabled className={TAB_TRIGGER} title="Chưa có trong bản này">
            Đánh giá
          </TabsTrigger>
          <TabsTrigger value="vehicle-images" className={TAB_TRIGGER}>
            Ảnh phương tiện
          </TabsTrigger>
          <TabsTrigger value="public-content" disabled className={TAB_TRIGGER} title="Chưa có trong bản này">
            Nội dung công khai
          </TabsTrigger>
        </TabsList>
        <TabsContent value="vehicle-images" className="flex flex-col gap-6">
          <VehicleImageReview />
        </TabsContent>
      </Tabs>
    </div>
  );
}
