"use client";

import { TAB_TRIGGER } from "@vexenhanh/ui/components/list-controls";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@vexenhanh/ui/components/tabs";
import { usePathname, useRouter, useSearchParams } from "next/navigation";

import { PageHeader } from "../page-header";
import { RouteList } from "./route-list";
import { TripList } from "./trip-list";

/**
 * Màn Tuyến & chuyến (tự thiết kế 28/10/2026, chờ duyệt; chưa có Figma): tab Tuyến đường (hiệu suất theo kỳ, tuyến phổ
 * biến) / Chuyến xe (`?tab=trips`). Chỉ xem — thao tác trên tuyến, chuyến do nhà xe làm ở Operator OS.
 */
export function OperationScreen() {
  const router = useRouter();
  const pathname = usePathname();
  const params = useSearchParams();
  const tab = params.get("tab") === "trips" ? "trips" : "routes";
  return (
    <div className="flex flex-col gap-6">
      <PageHeader title="Tuyến & chuyến" description="Giám sát tuyến và chuyến của mọi nhà xe: hiệu suất tuyến, tuyến phổ biến, chuyến đang chạy và sắp chạy." />
      <Tabs
        value={tab}
        onValueChange={(next) => router.replace(next === "trips" ? `${pathname}?tab=trips` : pathname, { scroll: false })}
        className="flex flex-col gap-6"
      >
        <TabsList className="h-10 w-fit max-w-full overflow-x-auto" aria-label="Tuyến và chuyến">
          <TabsTrigger value="routes" className={TAB_TRIGGER}>
            Tuyến đường
          </TabsTrigger>
          <TabsTrigger value="trips" className={TAB_TRIGGER}>
            Chuyến xe
          </TabsTrigger>
        </TabsList>
        <TabsContent value="routes" className="flex flex-col gap-6">
          <RouteList />
        </TabsContent>
        <TabsContent value="trips" className="flex flex-col gap-6">
          <TripList />
        </TabsContent>
      </Tabs>
    </div>
  );
}
