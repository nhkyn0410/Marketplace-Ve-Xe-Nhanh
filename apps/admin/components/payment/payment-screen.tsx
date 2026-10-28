"use client";

import { useQuery } from "@tanstack/react-query";
import { TAB_TRIGGER } from "@vexenhanh/ui/components/list-controls";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@vexenhanh/ui/components/tabs";
import { usePathname, useRouter, useSearchParams } from "next/navigation";

import { listPayments } from "../../lib/payment/payment-api";
import { PageHeader } from "../page-header";
import { PaymentList } from "./payment-list";
import { RefundList } from "./refund-list";

const TABS = ["payments", "refunds", "reconcile"] as const;
type Tab = (typeof TABS)[number];

/**
 * Giao dịch (Figma ADM-07a, 07c; TASK-ADM-002, FR-ADM-10, FR-BTP-17, UC-32): tab Thanh toán / Hoàn tiền / Cần
 * đối soát (`?tab=`). Thanh toán cần đối soát = cổng đã trừ tiền nhưng thanh toán không nhận vào booking.
 */
export function PaymentScreen() {
  const router = useRouter();
  const pathname = usePathname();
  const params = useSearchParams();
  const requested = params.get("tab") ?? "";
  const tab: Tab = (TABS as readonly string[]).includes(requested) ? (requested as Tab) : "payments";
  const reconcile = useQuery({ queryKey: ["admin-payments", "reconcile-count"], queryFn: () => listPayments({ reconcile: "open" }) });
  const reconcileOpen = reconcile.data?.reconcileOpen;

  return (
    <div className="flex flex-col gap-6">
      <PageHeader title="Giao dịch" description="Giám sát giao dịch qua cổng thanh toán, hoàn tiền và các khoản cần đối soát." />
      <Tabs
        value={tab}
        onValueChange={(next) => router.replace(next === "payments" ? pathname : `${pathname}?tab=${next}`, { scroll: false })}
        className="flex flex-col gap-6"
      >
        <TabsList className="h-10 w-fit max-w-full overflow-x-auto" aria-label="Nhóm giao dịch">
          <TabsTrigger value="payments" className={TAB_TRIGGER}>
            Thanh toán
          </TabsTrigger>
          <TabsTrigger value="refunds" className={TAB_TRIGGER}>
            Hoàn tiền
          </TabsTrigger>
          <TabsTrigger value="reconcile" className={TAB_TRIGGER}>
            Cần đối soát{reconcileOpen !== undefined ? ` (${reconcileOpen})` : ""}
          </TabsTrigger>
        </TabsList>
        <TabsContent value="payments" className="flex flex-col gap-6">
          <PaymentList mode="all" />
        </TabsContent>
        <TabsContent value="refunds" className="flex flex-col gap-6">
          <RefundList />
        </TabsContent>
        <TabsContent value="reconcile" className="flex flex-col gap-6">
          <PaymentList mode="reconcile" />
        </TabsContent>
      </Tabs>
    </div>
  );
}
