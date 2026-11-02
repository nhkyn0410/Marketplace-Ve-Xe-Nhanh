"use client";

import { Hourglass, Info } from "lucide-react";
import { useState } from "react";

import { TAB_TRIGGER, TABLE, TABLE_HEAD_CELL, TABLE_HEAD_ROW } from "./list-controls";
import { ListStatePanel } from "./list-parts";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "./tabs";

export type PlannedTab = {
  label: string;
  /** Tiêu đề cột theo Figma. */
  columns: string[];
  /** Câu ở trạng thái trống của tab. */
  empty: string;
};

/**
 * Khung giao diện của một màn chưa có dữ liệu thật (Khanh 16/10/2026: "Dựng khung giao diện trước"): thẻ số liệu hiện
 * "—", bảng chỉ có tiêu đề cột theo Figma và trạng thái trống ghi rõ màn chờ chức năng nào. KHÔNG hiển thị số liệu mẫu.
 */
export function PlannedScreen({
  stats = [],
  tabs,
  dependency
}: {
  stats?: { label: string; hint: string }[];
  tabs: PlannedTab[];
  /** Màn chờ chức năng nào (vd "đặt vé + thanh toán — TASK-BTP-001..005"). */
  dependency: string;
}) {
  const [tab, setTab] = useState(tabs[0]?.label ?? "");
  return (
    <>
      {stats.length > 0 && (
        <div className="grid gap-4 sm:grid-cols-2 xl:grid-cols-4">
          {stats.map((stat) => (
            <div key={stat.label} className="flex flex-col gap-2 rounded-xl border bg-card p-5">
              <p className="text-sm leading-5 text-muted-foreground">{stat.label}</p>
              <p className="text-[30px] leading-[38px] font-semibold text-muted-foreground" aria-label={`${stat.label}: chưa có dữ liệu`}>
                —
              </p>
              <p className="text-xs leading-[18px] text-muted-foreground">{stat.hint}</p>
            </div>
          ))}
        </div>
      )}
      <Tabs value={tab} onValueChange={setTab} className="flex flex-col gap-6">
        {tabs.length > 1 && (
          <TabsList className="h-10 w-fit max-w-full overflow-x-auto" aria-label="Nhóm nội dung">
            {tabs.map((item) => (
              <TabsTrigger key={item.label} value={item.label} className={TAB_TRIGGER}>
                {item.label}
              </TabsTrigger>
            ))}
          </TabsList>
        )}
        {tabs.map((item) => (
          <TabsContent key={item.label} value={item.label}>
            <section aria-label={item.label} className="flex min-w-0 flex-col rounded-xl border bg-card p-6">
              <div className="relative overflow-x-auto">
                <table className={`${TABLE} min-w-[720px]`}>
                  <thead>
                    <tr className={TABLE_HEAD_ROW}>
                      {item.columns.map((column) => (
                        <th key={column} scope="col" className={TABLE_HEAD_CELL}>
                          {column}
                        </th>
                      ))}
                    </tr>
                  </thead>
                </table>
              </div>
              <ListStatePanel
                compact
                icon={<Hourglass className="size-6 text-vxn-fg-3" />}
                title="Chưa có dữ liệu"
                description={item.empty}
              />
            </section>
          </TabsContent>
        ))}
      </Tabs>
      <div role="note" className="flex gap-3 rounded-lg bg-accent px-5 py-4 text-sm leading-5 text-accent-foreground">
        <Info className="mt-px size-5 shrink-0" />
        <p>
          Màn này mới dựng khung theo thiết kế; số liệu xuất hiện khi có {dependency}. Chưa có dữ liệu thật nên không hiển thị số liệu mẫu.
        </p>
      </div>
    </>
  );
}
