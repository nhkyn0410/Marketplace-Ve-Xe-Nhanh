"use client";

import { TAB_TRIGGER } from "@vexenhanh/ui/components/list-controls";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@vexenhanh/ui/components/tabs";
import { Award } from "lucide-react";
import { usePathname, useRouter, useSearchParams } from "next/navigation";
import type { ReactNode } from "react";

import type { LoyaltyTier } from "../../lib/loyalty/loyalty-api";
import { TIER_LABEL } from "../../lib/loyalty/loyalty-format";
import { PageHeader } from "../page-header";
import { LoyaltyMembersTab } from "./loyalty-members-tab";
import { LoyaltyPolicyTab } from "./loyalty-policy-tab";
import { LoyaltyReportTab } from "./loyalty-report-tab";

const TABS = ["policy", "members", "report"] as const;
export type LoyaltyTab = (typeof TABS)[number];

/**
 * VXN Plus (Figma ADM-12a…12d; TASK-LOY-001, FR-LOY-10..12, UC-39): tham số chương trình theo phiên bản, điểm thành viên +
 * điều chỉnh điểm, báo cáo theo quý. Mỗi tab tự dựng đầu trang để đặt nút riêng (Lưu nháp / Kích hoạt, Xuất báo cáo).
 */
export function LoyaltyScreen() {
  const params = useSearchParams();
  const requested = params.get("tab") ?? "";
  const tab: LoyaltyTab = (TABS as readonly string[]).includes(requested) ? (requested as LoyaltyTab) : "policy";
  if (tab === "members") {
    return <LoyaltyMembersTab />;
  }
  return tab === "report" ? <LoyaltyReportTab /> : <LoyaltyPolicyTab />;
}

/** Đầu trang + thanh tab chung; `actions` = nút của tab đang mở. */
export function LoyaltyFrame({ tab, actions, children }: { tab: LoyaltyTab; actions?: ReactNode; children: ReactNode }) {
  const router = useRouter();
  const pathname = usePathname();
  return (
    <div className="flex flex-col gap-6">
      <PageHeader title="VXN Plus" description="Chương trình thành viên của Vé Xe Nhanh: tham số tích điểm, điểm thành viên và báo cáo." actions={actions} />
      <Tabs value={tab} onValueChange={(next) => router.replace(next === "policy" ? pathname : `${pathname}?tab=${next}`, { scroll: false })} className="flex flex-col gap-6">
        <TabsList className="h-10 w-fit max-w-full overflow-x-auto" aria-label="Nhóm VXN Plus">
          <TabsTrigger value="policy" className={TAB_TRIGGER}>
            Chính sách chương trình
          </TabsTrigger>
          <TabsTrigger value="members" className={TAB_TRIGGER}>
            Điểm thành viên
          </TabsTrigger>
          <TabsTrigger value="report" className={TAB_TRIGGER}>
            Báo cáo
          </TabsTrigger>
        </TabsList>
        <TabsContent value={tab} className="flex flex-col gap-6">
          {children}
        </TabsContent>
      </Tabs>
    </div>
  );
}

const TIER_COLOR: Record<LoyaltyTier, string> = { BRONZE: "#b45309", SILVER: "#64748b", GOLD: "#f59e0b", PLATINUM: "#18181b" };

/** Huy hiệu hạng (Figma ADM-12a: vòng màu + biểu tượng). */
export function TierMark({ tier }: { tier: LoyaltyTier }) {
  return (
    <span className="inline-flex items-center gap-2.5 font-semibold text-vxn-ink">
      <span aria-hidden className="flex size-7 items-center justify-center rounded-full text-white" style={{ backgroundColor: TIER_COLOR[tier] }}>
        <Award className="size-4" />
      </span>
      {TIER_LABEL[tier]}
    </span>
  );
}
