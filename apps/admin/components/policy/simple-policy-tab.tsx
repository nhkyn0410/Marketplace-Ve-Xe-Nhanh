"use client";

import { useQuery } from "@tanstack/react-query";
import { Button } from "@vexenhanh/ui/components/button";
import { TableSkeleton } from "@vexenhanh/ui/components/list-controls";
import { BUTTON, ListStatePanel } from "@vexenhanh/ui/components/list-parts";
import { Banknote, CircleAlert, Clock, Info, Pencil, RefreshCw } from "lucide-react";
import Link from "next/link";
import type { ReactNode } from "react";

import { getPolicyOverview, type PolicyVersion } from "../../lib/policy/policy-api";
import { STATE } from "../../lib/policy/policy-format";
import { formatDate } from "../../lib/user/user-format";
import { CARD, CARD_TITLE } from "./cancellation-tab";
import { VersionTable } from "./version-table";

type SimpleType = "SEAT_HOLD" | "PAYOUT";

/** Các dòng của thẻ tóm tắt (Figma ADM-06d) theo nội dung phiên bản. */
export function ruleRows(type: SimpleType, rules: PolicyVersion["rules"]): [string, string][] {
  if (type === "SEAT_HOLD") {
    return [
      ["Thời gian giữ chỗ", `${"holdMinutes" in rules ? rules.holdMinutes : "—"} phút`],
      ["Phạm vi", "Toàn nền tảng"]
    ];
  }
  return [
    ["Chu kỳ", `T+${"delayDays" in rules ? rules.delayDays : "—"} sau khi chuyến hoàn thành`],
    ["Kênh chi trả", "Chuyển khoản ngân hàng"],
    ["Xác nhận", "Thủ công bởi Admin"],
    ["Ngưỡng tối thiểu", "Không đặt"]
  ];
}

const COPY: Record<SimpleType, { title: string; icon: ReactNode; note: string }> = {
  SEAT_HOLD: {
    title: "Giữ chỗ",
    icon: <Clock className="size-5" />,
    note: "Phiên bản hiện tại chưa cấu hình thời gian giữ chỗ riêng cho từng nhà xe (BR-02)."
  },
  PAYOUT: {
    title: "Chi trả cho nhà xe",
    icon: <Banknote className="size-5" />,
    note: "Chi trả bằng chuyển khoản và luôn cần Admin xác nhận thủ công trước khi đánh dấu thành công."
  }
};

/** Tab "Giữ chỗ" / "Chi trả" (Figma ADM-06d): thẻ phiên bản đang áp dụng + lịch sử phiên bản. Chỉ cấp nền tảng. */
export function SimplePolicyTab({ type }: { type: SimpleType }) {
  const overview = useQuery({ queryKey: ["admin-policy", type, null], queryFn: () => getPolicyOverview(type, null) });
  if (!overview.data) {
    return overview.isError ? (
      <ListStatePanel
        icon={<CircleAlert className="size-6 text-warning-700" />}
        title="Không tải được chính sách"
        description="Kiểm tra kết nối mạng rồi thử lại."
        action={
          <Button className={`${BUTTON} w-36`} onClick={() => void overview.refetch()}>
            <RefreshCw className="size-[18px]" />
            Thử lại
          </Button>
        }
      />
    ) : (
      <TableSkeleton label="Đang tải chính sách" />
    );
  }
  const copy = COPY[type];
  const current = overview.data.versions.find((version) => version.state === "ACTIVE");
  const scheduled = overview.data.versions.find((version) => version.state === "SCHEDULED");
  return (
    <>
      <div className="grid items-start gap-6 xl:grid-cols-[360px_minmax(0,1fr)]">
        <section aria-labelledby={`${type}-current`} className={CARD}>
          <div className="flex items-center gap-3">
            <span aria-hidden className="flex size-10 shrink-0 items-center justify-center rounded-lg bg-accent text-accent-foreground">
              {copy.icon}
            </span>
            <div className="flex min-w-0 flex-col">
              <h2 id={`${type}-current`} className={CARD_TITLE}>
                {copy.title}
              </h2>
              <p className="text-xs leading-[18px] text-muted-foreground">
                {current ? `Phiên bản ${current.version} · từ ${formatDate(current.effectiveFrom)}` : "Chưa có phiên bản có hiệu lực"}
              </p>
            </div>
          </div>
          {current && (
            <dl className="flex flex-col gap-3">
              {ruleRows(type, current.rules).map(([label, value]) => (
                <div key={label} className="flex items-baseline justify-between gap-4 text-[15px] leading-[22px]">
                  <dt className="text-muted-foreground">{label}</dt>
                  <dd className="text-right font-semibold text-vxn-ink">{value}</dd>
                </div>
              ))}
            </dl>
          )}
          {scheduled && (
            <p className="rounded-lg bg-warning-50 px-4 py-3 text-sm leading-5 text-warning-700">
              Phiên bản {scheduled.version} {STATE.SCHEDULED.label.toLowerCase()} từ {formatDate(scheduled.effectiveFrom)}.
            </p>
          )}
          <div role="note" className="flex gap-3 rounded-lg bg-accent px-4 py-3 text-sm leading-5 text-accent-foreground">
            <Info className="mt-px size-5 shrink-0" />
            {copy.note}
          </div>
          <Button asChild variant="outline" className={`${BUTTON} bg-card`}>
            <Link href={`/policies/new?type=${type}`}>
              <Pencil className="size-[18px]" />
              Tạo phiên bản mới
            </Link>
          </Button>
        </section>
        <section aria-labelledby={`${type}-history`} className={CARD}>
          <h2 id={`${type}-history`} className={CARD_TITLE}>
            Lịch sử phiên bản
          </h2>
          <VersionTable versions={overview.data.versions} />
        </section>
      </div>
      {type === "SEAT_HOLD" && (
        <div role="note" className="flex items-center gap-3 rounded-lg bg-accent px-5 py-4 text-sm leading-5 text-accent-foreground">
          <Info className="size-5 shrink-0" />
          Thời gian ngừng bán online hiện được đặt theo từng chuyến của nhà xe, không nằm trong nhóm chính sách này.
        </div>
      )}
    </>
  );
}
