"use client";

import { useQuery } from "@tanstack/react-query";
import { Button } from "@vexenhanh/ui/components/button";
import { BUTTON } from "@vexenhanh/ui/components/list-parts";
import { TAB_TRIGGER } from "@vexenhanh/ui/components/list-controls";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@vexenhanh/ui/components/tabs";
import { CircleCheck, Plus } from "lucide-react";
import { usePathname, useRouter, useSearchParams } from "next/navigation";
import { useState } from "react";

import {
  listOperatorStopPoints,
  listProposals,
  listSharedStopPoints
} from "../../lib/stop-point/stop-point-api";
import { formatCount } from "../../lib/stop-point/stop-point-format";
import { PageHeader } from "../page-header";
import { OperatorPointList } from "./operator-point-list";
import { ProposalList } from "./proposal-list";
import { SharedDialog, type SharedDialogTarget } from "./shared-dialog";
import { SharedList } from "./shared-list";

const TABS = ["shared", "proposals", "operator"] as const;
type Tab = (typeof TABS)[number];

/**
 * Màn Điểm dừng của Admin (Figma ADM-05a / 05b / 05d; UI §9; TASK-ADM-004): ba tab Dùng chung, Chờ duyệt, Của nhà
 * xe. Tab đang mở nằm trên địa chỉ (`?tab=`) để quay lại từ trang xem xét đề xuất đúng chỗ.
 */
export function StopPointScreen() {
  const router = useRouter();
  const pathname = usePathname();
  const params = useSearchParams();
  const tab: Tab = (TABS as readonly string[]).includes(params.get("tab") ?? "") ? (params.get("tab") as Tab) : "shared";
  const [dialog, setDialog] = useState<SharedDialogTarget | null>(null);
  const [notice, setNotice] = useState<string | null>(null);

  // Số trên ba tab: tổng không lọc (Chờ duyệt = đề xuất đang chờ).
  const counts = {
    shared: useQuery({ queryKey: ["admin-stop-points", "count", "shared"], queryFn: () => listSharedStopPoints({}, null) }),
    proposals: useQuery({
      queryKey: ["admin-stop-points", "count", "proposals"],
      queryFn: () => listProposals({ status: "PENDING" }, null)
    }),
    operator: useQuery({ queryKey: ["admin-stop-points", "count", "operator"], queryFn: () => listOperatorStopPoints({}, null) })
  };
  const label = (text: string, key: Tab) => {
    const total = counts[key].data?.total;
    return total === undefined ? text : `${text} (${formatCount(total)})`;
  };

  function selectTab(next: string) {
    setNotice(null);
    router.replace(`${pathname}?tab=${next}`, { scroll: false });
  }

  return (
    <div className="flex flex-col gap-6">
      <PageHeader
        title="Điểm dừng"
        description="Danh mục điểm dừng của nền tảng, đề xuất từ nhà xe và điểm dừng riêng của từng nhà xe."
        actions={
          <Button className={`${BUTTON} w-48`} onClick={() => setDialog({ kind: "create" })}>
            <Plus className="size-[18px]" />
            Thêm điểm dừng
          </Button>
        }
      />
      {notice && (
        <div role="status" className="flex items-center gap-3 rounded-lg bg-success-50 px-5 py-3 text-sm leading-5 text-success-700">
          <CircleCheck className="size-5 shrink-0" />
          {notice}
        </div>
      )}
      <Tabs value={tab} onValueChange={selectTab} className="flex flex-col gap-6">
        <TabsList className="h-10 w-fit max-w-full overflow-x-auto" aria-label="Phạm vi điểm dừng">
          <TabsTrigger value="shared" className={TAB_TRIGGER}>
            {label("Dùng chung", "shared")}
          </TabsTrigger>
          <TabsTrigger value="proposals" className={TAB_TRIGGER}>
            {label("Chờ duyệt", "proposals")}
          </TabsTrigger>
          <TabsTrigger value="operator" className={TAB_TRIGGER}>
            {label("Của nhà xe", "operator")}
          </TabsTrigger>
        </TabsList>
        <TabsContent value="shared" className="flex flex-col gap-6">
          <SharedList onEdit={(stopPoint) => setDialog({ kind: "edit", stopPoint })} onNotice={setNotice} />
        </TabsContent>
        <TabsContent value="proposals" className="flex flex-col gap-6">
          <ProposalList />
        </TabsContent>
        <TabsContent value="operator" className="flex flex-col gap-6">
          <OperatorPointList onNotice={setNotice} />
        </TabsContent>
      </Tabs>
      <SharedDialog
        target={dialog}
        onClose={() => setDialog(null)}
        onSaved={(message) => {
          setNotice(message);
          if (tab !== "shared") {
            router.replace(`${pathname}?tab=shared`, { scroll: false });
          }
        }}
      />
    </div>
  );
}
