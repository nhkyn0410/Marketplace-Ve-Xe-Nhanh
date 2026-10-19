"use client";

import { useQuery } from "@tanstack/react-query";
import { Badge } from "@vexenhanh/ui/components/badge";
import { Skeleton } from "@vexenhanh/ui/components/skeleton";
import { ChevronRight, Info } from "lucide-react";
import Link from "next/link";

import { listApplications } from "../../lib/operator-application/application-api";
import { listProposals } from "../../lib/stop-point/stop-point-api";
import { getIntegrations } from "../../lib/system/system-format";
import { listOperators } from "../../lib/user/user-api";
import { formatDateTime } from "../../lib/user/user-format";
import { PageHeader } from "../page-header";

const CARD = "flex min-w-0 flex-col gap-4 rounded-xl border bg-card p-6";

/** Số của một hàng đợi; `null` khi đang tải / lỗi. Hồ sơ đăng ký chưa có `total` nên đếm tối đa một trang (20+). */
function useCounts() {
  const applications = useQuery({
    queryKey: ["admin-overview", "applications"],
    queryFn: async () => {
      const page = await listApplications({ status: "SUBMITTED" }, null);
      return { count: page.items.length, more: page.nextCursor !== null };
    }
  });
  const proposals = useQuery({ queryKey: ["admin-overview", "proposals"], queryFn: () => listProposals({ status: "PENDING" }, null) });
  const bankChanges = useQuery({ queryKey: ["admin-overview", "bank"], queryFn: () => listOperators({ bankChange: "PENDING" }, null) });
  const operators = useQuery({ queryKey: ["admin-overview", "operators"], queryFn: () => listOperators({}, null) });
  const active = useQuery({ queryKey: ["admin-overview", "operators-active"], queryFn: () => listOperators({ status: "ACTIVE" }, null) });
  const integrations = useQuery({ queryKey: ["admin-system", "integrations"], queryFn: getIntegrations });
  return { applications, proposals, bankChanges, operators, active, integrations };
}

/**
 * Tổng quan nền tảng (Figma ADM-01). Số liệu có thật ngay bây giờ — hàng đợi duyệt, nhà xe, tích hợp — lấy từ API; chỉ
 * số giao dịch / tiền giữ hộ / chi trả cần đặt vé và thanh toán (TASK-BTP-*, RPT-002) nên hiện "—", không số liệu mẫu.
 */
export function OverviewScreen() {
  const { applications, proposals, bankChanges, operators, active, integrations } = useCounts();
  const down = integrations.data?.items.filter((item) => item.status === "DOWN").length ?? 0;
  const checked = integrations.data?.items.filter((item) => item.status === "UP").length ?? 0;
  const queue: { label: string; hint: string; href: string | null; value: string | null }[] = [
    {
      label: "Hồ sơ nhà xe chờ duyệt",
      hint: "Hồ sơ đã gửi, chưa có quyết định",
      href: "/operators",
      value: applications.data ? `${applications.data.count}${applications.data.more ? "+" : ""}` : null
    },
    {
      label: "Đề xuất điểm dừng chờ duyệt",
      hint: "Nhà xe đề xuất bến / điểm đón trả mới",
      href: "/stop-points?tab=proposals",
      value: proposals.data ? String(proposals.data.total) : null
    },
    {
      label: "Yêu cầu đổi tài khoản nhận tiền",
      hint: "Chờ Admin xác minh trước khi dùng để chi trả",
      href: "/operators?tab=operators",
      value: bankChanges.data ? String(bankChanges.data.total) : null
    },
    { label: "Chi trả chờ rà soát", hint: "Có khi bật thanh toán và chi trả", href: null, value: "—" },
    { label: "Tranh chấp đang mở", hint: "Có khi có đặt vé và khiếu nại", href: null, value: "—" },
    { label: "Hoàn tiền cần xử lý thủ công", hint: "Có khi bật thanh toán", href: null, value: "—" }
  ];

  return (
    <div className="flex flex-col gap-6">
      <PageHeader title="Tổng quan nền tảng" description="Số liệu toàn hệ thống. Chỉ số giao dịch hiện khi có đặt vé và thanh toán." />
      <div className="grid gap-4 sm:grid-cols-2 xl:grid-cols-4">
        <Stat label="Giá trị giao dịch" value="—" hint="Có khi bật thanh toán" />
        <Stat label="Đơn đặt vé" value="—" hint="Có khi bật đặt vé" />
        <Stat label="Vé đã phát hành" value="—" hint="Có khi bật đặt vé" />
        <Stat
          label="Nhà xe đang hoạt động"
          value={active.data && operators.data ? `${active.data.total} / ${operators.data.total}` : null}
          hint={operators.data && active.data ? `${operators.data.total - active.data.total} bị khóa` : ""}
        />
      </div>
      <div className="grid items-start gap-6 xl:grid-cols-[minmax(0,1fr)_380px]">
        <section aria-labelledby="overview-queue" className={CARD}>
          <div className="flex flex-col gap-1">
            <h2 id="overview-queue" className="text-lg leading-7 font-semibold text-vxn-ink">
              Việc cần xử lý
            </h2>
            <p className="text-sm leading-5 text-muted-foreground">Các hàng đợi đang chờ Admin.</p>
          </div>
          <ul className="flex flex-col divide-y">
            {queue.map((item) => {
              const content = (
                <>
                  <span className="flex min-w-0 flex-1 flex-col">
                    <span className="font-semibold text-vxn-ink">{item.label}</span>
                    <span className="text-xs leading-[18px] text-muted-foreground">{item.hint}</span>
                  </span>
                  {item.value === null ? (
                    <Skeleton className="h-6 w-10" />
                  ) : (
                    <span className={`text-lg font-semibold ${item.href ? "text-vxn-ink" : "text-muted-foreground"}`}>{item.value}</span>
                  )}
                  {item.href && <ChevronRight className="size-4 text-muted-foreground" />}
                </>
              );
              return (
                <li key={item.label}>
                  {item.href ? (
                    <Link href={item.href} className="flex items-center gap-3 py-3 text-sm hover:bg-muted/50">
                      {content}
                    </Link>
                  ) : (
                    <div className="flex items-center gap-3 py-3 text-sm">{content}</div>
                  )}
                </li>
              );
            })}
          </ul>
        </section>
        <div className="flex min-w-0 flex-col gap-6">
          <section aria-labelledby="overview-escrow" className={CARD}>
            <h2 id="overview-escrow" className="text-lg leading-7 font-semibold text-vxn-ink">
              Tiền đang giữ (escrow)
            </h2>
            <p className="text-sm leading-5 text-muted-foreground">Tiền hành khách đã thanh toán, Platform giữ đến khi đủ điều kiện chi trả.</p>
            <p className="text-[30px] leading-[38px] font-semibold text-muted-foreground">—</p>
            <p className="text-xs leading-[18px] text-muted-foreground">Có khi bật thanh toán và sổ giữ hộ (TASK-BTP-006).</p>
          </section>
          <section aria-labelledby="overview-integrations" className={CARD}>
            <div className="flex items-center justify-between gap-3">
              <h2 id="overview-integrations" className="text-lg leading-7 font-semibold text-vxn-ink">
                Trạng thái tích hợp
              </h2>
              {integrations.data && <Badge tone={down > 0 ? "danger" : "success"}>{down > 0 ? `${down} lỗi` : "Ổn định"}</Badge>}
            </div>
            {integrations.data ? (
              <p className="text-sm leading-5 text-muted-foreground">
                {checked} dịch vụ hoạt động, {down} lỗi · kiểm tra lúc {formatDateTime(integrations.data.checkedAt)}.
              </p>
            ) : (
              <Skeleton className="h-5 w-full" />
            )}
            <Link href="/system" className="inline-flex items-center gap-1 text-sm font-semibold text-primary hover:underline">
              Xem chi tiết
              <ChevronRight className="size-4" />
            </Link>
          </section>
        </div>
      </div>
      <div role="note" className="flex gap-3 rounded-lg bg-accent px-5 py-4 text-sm leading-5 text-accent-foreground">
        <Info className="mt-px size-5 shrink-0" />
        Giá trị giao dịch theo ngày, tiền giữ hộ, chi trả, hoàn tiền và tranh chấp xuất hiện khi các chức năng đặt vé / thanh toán được xây; trang không hiển
        thị số liệu mẫu.
      </div>
    </div>
  );
}

function Stat({ label, value, hint }: { label: string; value: string | null; hint: string }) {
  return (
    <div className="flex flex-col gap-2 rounded-xl border bg-card p-5">
      <p className="text-sm leading-5 text-muted-foreground">{label}</p>
      {value === null ? (
        <Skeleton className="h-[38px] w-24" />
      ) : (
        <p className={`text-[30px] leading-[38px] font-semibold ${value === "—" ? "text-muted-foreground" : "text-vxn-ink"}`}>{value}</p>
      )}
      <p className="text-xs leading-[18px] text-muted-foreground">{hint}</p>
    </div>
  );
}
