"use client";

import { TAB_TRIGGER } from "@vexenhanh/ui/components/list-controls";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@vexenhanh/ui/components/tabs";
import { usePathname, useRouter, useSearchParams } from "next/navigation";

import { ApplicationQueue } from "../operator-application/application-queue";
import { PageHeader } from "../page-header";
import { OperatorList } from "./operator-list";

/** Màn Nhà xe & KYC (Figma ADM-02a, ADM-02e): tab Hồ sơ đăng ký / Nhà xe, tab nằm trên địa chỉ (`?tab=operators`). */
export function OperatorScreen() {
  const router = useRouter();
  const pathname = usePathname();
  const params = useSearchParams();
  const tab = params.get("tab") === "operators" ? "operators" : "applications";
  return (
    <div className="flex flex-col gap-6">
      <PageHeader title="Nhà xe & KYC" description="Duyệt hồ sơ đăng ký và quản lý trạng thái hoạt động của nhà xe." />
      <Tabs
        value={tab}
        onValueChange={(next) => router.replace(next === "operators" ? `${pathname}?tab=operators` : pathname, { scroll: false })}
        className="flex flex-col gap-6"
      >
        <TabsList className="h-10 w-fit max-w-full overflow-x-auto" aria-label="Hồ sơ và nhà xe">
          <TabsTrigger value="applications" className={TAB_TRIGGER}>
            Hồ sơ đăng ký
          </TabsTrigger>
          <TabsTrigger value="operators" className={TAB_TRIGGER}>
            Nhà xe
          </TabsTrigger>
        </TabsList>
        <TabsContent value="applications" className="flex flex-col gap-6">
          <ApplicationQueue />
        </TabsContent>
        <TabsContent value="operators" className="flex flex-col gap-6">
          <OperatorList />
        </TabsContent>
      </Tabs>
    </div>
  );
}
