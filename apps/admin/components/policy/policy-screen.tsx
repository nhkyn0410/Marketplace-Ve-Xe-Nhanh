"use client";

import { Button } from "@vexenhanh/ui/components/button";
import { TAB_TRIGGER } from "@vexenhanh/ui/components/list-controls";
import { BUTTON } from "@vexenhanh/ui/components/list-parts";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@vexenhanh/ui/components/tabs";
import { CircleCheck, Plus } from "lucide-react";
import Link from "next/link";
import { usePathname, useRouter, useSearchParams } from "next/navigation";
import { useState } from "react";

import { PageHeader } from "../page-header";
import { CancellationTab } from "./cancellation-tab";
import { CommissionTab } from "./commission-tab";
import { FareBandTab } from "./fare-band-tab";
import { SimplePolicyTab } from "./simple-policy-tab";

const TABS = ["cancellation", "seat-hold", "commission", "payout", "fare-bands"] as const;
type Tab = (typeof TABS)[number];

/**
 * Màn Chính sách (Figma ADM-06a, 06c, 06d; FR-ADM-06..09, UC-25): tab Hủy và hoàn tiền / Giữ chỗ / Hoa hồng / Chi trả /
 * Khung giá vé (`?tab=`). Thay đổi chỉ áp dụng cho giao dịch sau ngày hiệu lực (AS-23).
 */
export function PolicyScreen() {
  const router = useRouter();
  const pathname = usePathname();
  const params = useSearchParams();
  const requested = params.get("tab") ?? "";
  const tab: Tab = (TABS as readonly string[]).includes(requested) ? (requested as Tab) : "cancellation";
  const operatorId = tab === "cancellation" ? params.get("operatorId") : null;
  const [notice, setNotice] = useState<string | null>(null);
  const [creating, setCreating] = useState<"commission" | "fare-band" | null>(null);

  let action = null;
  if (tab === "cancellation") {
    action = (
      <Button asChild className={`${BUTTON} min-w-48`}>
        <Link href={`/policies/new?type=CANCELLATION${operatorId ? `&operatorId=${operatorId}` : ""}`}>
          <Plus className="size-[18px]" />
          Tạo phiên bản mới
        </Link>
      </Button>
    );
  } else if (tab === "commission") {
    action = (
      <Button className={`${BUTTON} min-w-52`} onClick={() => setCreating("commission")}>
        <Plus className="size-[18px]" />
        Thêm mức riêng cho nhà xe
      </Button>
    );
  } else if (tab === "fare-bands") {
    action = (
      <Button className={`${BUTTON} min-w-44`} onClick={() => setCreating("fare-band")}>
        <Plus className="size-[18px]" />
        Thiết lập khung giá
      </Button>
    );
  }

  return (
    <div className="flex flex-col gap-6">
      <PageHeader
        title="Chính sách"
        description="Chính sách cấp nền tảng. Thay đổi chỉ áp dụng cho giao dịch sau ngày hiệu lực."
        actions={action ?? undefined}
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
          router.replace(next === "cancellation" ? pathname : `${pathname}?tab=${next}`, { scroll: false });
        }}
        className="flex flex-col gap-6"
      >
        <TabsList className="h-10 w-fit max-w-full overflow-x-auto" aria-label="Nhóm chính sách">
          <TabsTrigger value="cancellation" className={TAB_TRIGGER}>
            Hủy và hoàn tiền
          </TabsTrigger>
          <TabsTrigger value="seat-hold" className={TAB_TRIGGER}>
            Giữ chỗ
          </TabsTrigger>
          <TabsTrigger value="commission" className={TAB_TRIGGER}>
            Hoa hồng
          </TabsTrigger>
          <TabsTrigger value="payout" className={TAB_TRIGGER}>
            Chi trả
          </TabsTrigger>
          <TabsTrigger value="fare-bands" className={TAB_TRIGGER}>
            Khung giá vé
          </TabsTrigger>
        </TabsList>
        <TabsContent value="cancellation" className="flex flex-col gap-6">
          <CancellationTab operatorId={operatorId} />
        </TabsContent>
        <TabsContent value="seat-hold" className="flex flex-col gap-6">
          <SimplePolicyTab type="SEAT_HOLD" />
        </TabsContent>
        <TabsContent value="commission" className="flex flex-col gap-6">
          <CommissionTab creating={creating === "commission"} onCloseCreate={() => setCreating(null)} onNotice={setNotice} />
        </TabsContent>
        <TabsContent value="payout" className="flex flex-col gap-6">
          <SimplePolicyTab type="PAYOUT" />
        </TabsContent>
        <TabsContent value="fare-bands" className="flex flex-col gap-6">
          <FareBandTab creating={creating === "fare-band"} onCloseCreate={() => setCreating(null)} onNotice={setNotice} />
        </TabsContent>
      </Tabs>
    </div>
  );
}
