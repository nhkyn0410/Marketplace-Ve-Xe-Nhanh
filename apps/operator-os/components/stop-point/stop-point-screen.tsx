"use client";

import { Button } from "@vexenhanh/ui/components/button";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@vexenhanh/ui/components/tabs";
import { CircleCheck, MapPin, Plus } from "lucide-react";
import { useRouter, useSearchParams } from "next/navigation";
import { useState } from "react";

import { BUTTON } from "../list-parts";
import { PageHeader } from "../page-header";
import { TAB_TRIGGER } from "./list-controls";
import { OwnStopPointList } from "./own-stop-point-list";
import { ProposalList } from "./proposal-list";
import { SharedStopPointList } from "./shared-stop-point-list";
import { StopPointDialog, type StopPointDialogTarget } from "./stop-point-dialog";

/**
 * Màn Điểm dừng của nhà xe (Figma "Nhà xe · Điểm dừng · TRN-013"; FR-OPS-17, BR-38): tab "Của nhà xe" quản
 * lý điểm riêng, tab "Dùng chung" xem danh mục Platform và theo dõi đề xuất. Tab đang mở nằm trên URL
 * (`?tab=shared`) để tải lại trang hay gửi link vẫn đúng chỗ.
 */
export function StopPointScreen() {
  const router = useRouter();
  const tab = useSearchParams().get("tab") === "shared" ? "shared" : "own";
  const [dialog, setDialog] = useState<StopPointDialogTarget | null>(null);
  const [notice, setNotice] = useState<string | null>(null);

  function selectTab(value: string) {
    router.replace(value === "shared" ? "/stop-points?tab=shared" : "/stop-points", { scroll: false });
  }

  return (
    <div className="flex flex-col gap-6">
      <PageHeader
        title="Điểm dừng"
        description="Quản lý văn phòng trung chuyển, trạm dừng nghỉ của nhà xe và tra cứu điểm dừng dùng chung."
        actions={
          tab === "own" ? (
            <Button className={`${BUTTON} w-48`} onClick={() => setDialog({ kind: "create" })}>
              <Plus className="size-[18px]" />
              Thêm điểm dừng
            </Button>
          ) : (
            <Button className={`${BUTTON} w-52`} onClick={() => setDialog({ kind: "propose" })}>
              <Plus className="size-[18px]" />
              Đề xuất điểm dừng
            </Button>
          )
        }
      />

      {notice && (
        <div role="status" className="flex flex-wrap items-center gap-3 rounded-lg bg-success-50 px-5 py-3.5">
          <CircleCheck className="size-5 shrink-0 text-success-600" />
          <p className="min-w-0 flex-1 text-sm leading-5 font-medium text-success-600">{notice}</p>
          <Button type="button" variant="outline" className={`${BUTTON} w-[100px] bg-card`} onClick={() => setNotice(null)}>
            Đóng
          </Button>
        </div>
      )}

      <Tabs value={tab} onValueChange={selectTab} className="gap-6">
        <TabsList className="h-10 w-fit" aria-label="Phạm vi điểm dừng">
          <TabsTrigger value="own" className={TAB_TRIGGER}>
            Của nhà xe
          </TabsTrigger>
          <TabsTrigger value="shared" className={TAB_TRIGGER}>
            Dùng chung
          </TabsTrigger>
        </TabsList>

        <TabsContent value="own" className="flex flex-col gap-6">
          <OwnStopPointList
            onCreate={() => setDialog({ kind: "create" })}
            onEdit={(stopPoint) => setDialog({ kind: "edit", stopPoint })}
          />
          <div className="flex flex-wrap items-center gap-x-4 gap-y-2 rounded-lg bg-accent px-5 py-3.5">
            <MapPin className="size-5 shrink-0 text-vxn-teal-700" />
            <p className="min-w-0 flex-1 text-sm leading-5 text-vxn-teal-700">
              Bến xe và điểm dừng đón trả khách nằm trong danh mục dùng chung do Platform quản lý. Nhà xe chỉ tự tạo
              văn phòng trung chuyển và trạm dừng nghỉ.
            </p>
            <Button
              variant="ghost"
              className={`${BUTTON} text-vxn-fg-1 hover:bg-vxn-teal-100`}
              onClick={() => selectTab("shared")}
            >
              Xem điểm dùng chung
            </Button>
          </div>
        </TabsContent>

        <TabsContent value="shared" className="flex flex-col gap-6">
          <SharedStopPointList />
          <ProposalList onResubmit={(proposal) => setDialog({ kind: "resubmit", proposal })} />
        </TabsContent>
      </Tabs>

      <StopPointDialog target={dialog} onClose={() => setDialog(null)} onSaved={setNotice} />
    </div>
  );
}
