"use client";

import { Button } from "@vexenhanh/ui/components/button";
import { TAB_TRIGGER } from "@vexenhanh/ui/components/list-controls";
import { BUTTON } from "@vexenhanh/ui/components/list-parts";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@vexenhanh/ui/components/tabs";
import { CircleCheck, Plus } from "lucide-react";
import { usePathname, useRouter, useSearchParams } from "next/navigation";
import { useState } from "react";

import type { CatalogItem, CatalogKind } from "../../lib/catalog/catalog-api";
import { CATALOG_KINDS, KIND_COPY } from "../../lib/catalog/catalog-format";
import { PageHeader } from "../page-header";
import { ItemDialog, StatusDialog, type ItemTarget, type StatusTarget } from "./catalog-dialogs";
import { AmenityList, ProvinceList, VehicleTypeList, WardList } from "./catalog-lists";

/**
 * Màn Danh mục chuẩn (Figma ADM-04a…04c; UC-24, FR-ADM-04): bốn tab tỉnh / thành, phường / xã, loại xe, tiện ích.
 * Tab đang mở nằm trên địa chỉ (`?tab=`); nút "Thêm …" theo tab đang mở.
 */
export function CatalogScreen() {
  const router = useRouter();
  const pathname = usePathname();
  const params = useSearchParams();
  const requested = params.get("tab") ?? "";
  const tab: CatalogKind = (CATALOG_KINDS as readonly string[]).includes(requested) ? (requested as CatalogKind) : "provinces";
  const [itemTarget, setItemTarget] = useState<ItemTarget | null>(null);
  const [statusTarget, setStatusTarget] = useState<StatusTarget | null>(null);
  const [notice, setNotice] = useState<string | null>(null);

  const actions = {
    onEdit: (kind: CatalogKind, item: CatalogItem) => setItemTarget({ kind, item }),
    onToggle: (kind: CatalogKind, item: CatalogItem) => setStatusTarget({ kind, item })
  };

  return (
    <div className="flex flex-col gap-6">
      <PageHeader
        title="Danh mục chuẩn"
        description="Dữ liệu dùng chung cho mọi nhà xe: địa giới, loại xe và tiện ích."
        actions={
          <Button className={`${BUTTON} min-w-44`} onClick={() => setItemTarget({ kind: tab, item: null })}>
            <Plus className="size-[18px]" />
            {KIND_COPY[tab].add}
          </Button>
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
          router.replace(`${pathname}?tab=${next}`, { scroll: false });
        }}
        className="flex flex-col gap-6"
      >
        <TabsList className="h-10 w-fit max-w-full overflow-x-auto" aria-label="Loại danh mục">
          {CATALOG_KINDS.map((kind) => (
            <TabsTrigger key={kind} value={kind} className={TAB_TRIGGER}>
              {KIND_COPY[kind].tab}
            </TabsTrigger>
          ))}
        </TabsList>
        <TabsContent value="provinces" className="flex flex-col gap-6">
          <ProvinceList {...actions} />
        </TabsContent>
        <TabsContent value="wards" className="flex flex-col gap-6">
          <WardList {...actions} />
        </TabsContent>
        <TabsContent value="vehicle-types" className="flex flex-col gap-6">
          <VehicleTypeList {...actions} />
        </TabsContent>
        <TabsContent value="amenities" className="flex flex-col gap-6">
          <AmenityList {...actions} />
        </TabsContent>
      </Tabs>
      <ItemDialog target={itemTarget} onClose={() => setItemTarget(null)} onDone={setNotice} />
      <StatusDialog target={statusTarget} onClose={() => setStatusTarget(null)} onDone={setNotice} />
    </div>
  );
}
