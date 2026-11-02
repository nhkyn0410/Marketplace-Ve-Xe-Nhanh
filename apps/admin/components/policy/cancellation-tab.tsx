"use client";

import { useQuery } from "@tanstack/react-query";
import { Badge } from "@vexenhanh/ui/components/badge";
import { Button } from "@vexenhanh/ui/components/button";
import { TableSkeleton } from "@vexenhanh/ui/components/list-controls";
import { BUTTON, ListStatePanel } from "@vexenhanh/ui/components/list-parts";
import { ArrowLeft, ArrowUpRight, CircleAlert, Info, RefreshCw, ScrollText } from "lucide-react";
import Link from "next/link";
import { useState } from "react";

import { getPolicyOverview, type PolicyOverview } from "../../lib/policy/policy-api";
import { STATE, tierLabels, type Tier } from "../../lib/policy/policy-format";
import { formatDate } from "../../lib/user/user-format";
import { VersionTable } from "./version-table";

// `min-w-0`: thẻ là phần tử lưới — bảng rộng bên trong cuộn trong thẻ thay vì đẩy trang tràn ngang.
export const CARD = "flex min-w-0 flex-col gap-5 rounded-xl border bg-card p-6";
export const CARD_TITLE = "text-lg leading-7 font-semibold text-vxn-ink";

/**
 * Tab "Hủy và hoàn tiền" (Figma ADM-06a): lịch sử phiên bản của mặc định nền tảng (hoặc của một nhà xe khi có
 * `operatorId` — OQ-13) + thẻ "Đang áp dụng" (các mốc hoàn tiền) + danh sách nhà xe có chính sách riêng.
 */
export function CancellationTab({ operatorId }: { operatorId: string | null }) {
  const overview = useQuery({
    queryKey: ["admin-policy", "CANCELLATION", operatorId],
    queryFn: () => getPolicyOverview("CANCELLATION", operatorId)
  });

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

  const data = overview.data;
  return (
    <>
      {data.operatorName && (
        <div className="flex flex-wrap items-center gap-3 rounded-lg bg-accent px-5 py-3 text-sm leading-5 text-accent-foreground">
          <span className="min-w-0 flex-1">
            Đang xem chính sách riêng của <strong>{data.operatorName}</strong>. Nhà xe khác dùng chính sách mặc định nền tảng.
          </span>
          <Link href="/policies" className="inline-flex items-center gap-1 font-semibold hover:underline">
            <ArrowLeft className="size-4" />
            Về mặc định nền tảng
          </Link>
        </div>
      )}
      <div className="grid items-start gap-6 xl:grid-cols-[minmax(0,1fr)_340px]">
        <section aria-labelledby="cancel-history" className={CARD}>
          <h2 id="cancel-history" className={CARD_TITLE}>
            Lịch sử phiên bản
          </h2>
          {data.versions.length === 0 ? (
            <ListStatePanel
              compact
              icon={<ScrollText className="size-6 text-vxn-fg-3" />}
              title="Chưa có phiên bản nào"
              description="Tạo phiên bản đầu tiên: các mốc hoàn tiền theo thời gian còn lại trước giờ khởi hành."
            />
          ) : (
            <VersionTable versions={data.versions} />
          )}
          <div role="note" className="flex gap-3 rounded-lg bg-accent px-4 py-3 text-sm leading-5 text-accent-foreground">
            <Info className="mt-px size-5 shrink-0" />
            Đơn đã đặt giữ chính sách được lưu tại thời điểm đặt; phiên bản mới không áp ngược.
          </div>
        </section>
        <CurrentCard data={data} />
      </div>
    </>
  );
}

function CurrentCard({ data }: { data: PolicyOverview }) {
  const [showOverrides, setShowOverrides] = useState(false);
  const current = data.versions.find((version) => version.state === "ACTIVE");
  const tiers = current && "tiers" in current.rules ? (current.rules.tiers as Tier[]) : [];
  const labels = tierLabels(tiers);
  const sorted = [...tiers].sort((a, b) => b.minHoursBefore - a.minHoursBefore);
  return (
    <section aria-labelledby="cancel-current" className={CARD}>
      <div className="flex items-start justify-between gap-3">
        <div className="flex min-w-0 flex-col gap-1">
          <h2 id="cancel-current" className={CARD_TITLE}>
            Đang áp dụng
          </h2>
          <p className="text-sm leading-5 text-muted-foreground">
            {current ? `Phiên bản ${current.version} · từ ${formatDate(current.effectiveFrom)}` : "Chưa có phiên bản nào có hiệu lực."}
          </p>
        </div>
        <Badge tone="neutral">{data.operatorName ? "Riêng nhà xe" : "Mặc định nền tảng"}</Badge>
      </div>
      {current && (
        <dl className="flex flex-col gap-3">
          {sorted.map((tier, index) => (
            <div key={tier.minHoursBefore} className="flex items-baseline justify-between gap-4 text-[15px] leading-[22px]">
              <dt className="text-muted-foreground">Hủy {labels[index]!.charAt(0).toLowerCase() + labels[index]!.slice(1)}</dt>
              <dd className="shrink-0 font-semibold text-vxn-ink">
                {tier.refundPercent === 0 ? "Không hoàn" : `Hoàn ${tier.refundPercent}%`}
              </dd>
            </div>
          ))}
        </dl>
      )}
      {!data.operatorName && (
        <div className="flex flex-col gap-3 border-t pt-4">
          <div className="flex items-baseline justify-between gap-4 text-[15px] leading-[22px]">
            <span className="text-muted-foreground">Nhà xe có chính sách riêng</span>
            <span className="font-semibold text-vxn-ink">{data.overrides.length} nhà xe</span>
          </div>
          {data.overrides.length > 0 && (
            <Button type="button" variant="outline" className={`${BUTTON} bg-card`} onClick={() => setShowOverrides((open) => !open)}>
              <ArrowUpRight className="size-[18px]" />
              {showOverrides ? "Ẩn chính sách riêng của nhà xe" : "Xem chính sách riêng của nhà xe"}
            </Button>
          )}
          {showOverrides && (
            <ul className="flex flex-col gap-1" aria-label="Nhà xe có chính sách riêng">
              {data.overrides.map((override) => (
                <li key={override.operatorId}>
                  <Link
                    href={`/policies?operatorId=${override.operatorId}`}
                    className="flex items-center justify-between gap-3 rounded-lg px-3 py-2 text-sm hover:bg-muted"
                  >
                    <span className="min-w-0">
                      <span className="block truncate font-semibold text-vxn-ink">{override.operatorName}</span>
                      <span className="block text-xs text-muted-foreground">{override.operatorSlug}</span>
                    </span>
                    <Badge tone={STATE[override.state].tone}>{STATE[override.state].label}</Badge>
                  </Link>
                </li>
              ))}
            </ul>
          )}
        </div>
      )}
    </section>
  );
}
