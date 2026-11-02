"use client";

import { useInfiniteQuery } from "@tanstack/react-query";
import { Badge } from "@vexenhanh/ui/components/badge";
import { Button } from "@vexenhanh/ui/components/button";
import { ALL, FilterSelect, TABLE, TABLE_CELL, TABLE_HEAD_CELL, TABLE_HEAD_ROW, TableSkeleton } from "@vexenhanh/ui/components/list-controls";
import { BUTTON, ListLoadMoreFooter, ListStatePanel } from "@vexenhanh/ui/components/list-parts";
import { ChevronRight, CircleAlert, Info, Megaphone, Plus, RefreshCw } from "lucide-react";
import Link from "next/link";
import { useState, type ReactNode } from "react";

import {
  audienceLabel,
  CAMPAIGN_PAGE_SIZE,
  CAMPAIGN_STATUS,
  CAMPAIGN_STATUS_ORDER,
  CAMPAIGN_TYPE,
  listCampaigns,
  type Campaign,
  type CampaignStatus
} from "../../lib/notification/campaign-api";
import { formatDateTime } from "../../lib/user/user-format";
import { PageHeader } from "../page-header";

const COUNT = new Intl.NumberFormat("vi-VN");

/** Thời điểm đáng chú ý nhất của chiến dịch ở danh sách. */
function sendTime(campaign: Campaign): string {
  if (campaign.status === "DRAFT") return "Chưa gửi";
  return formatDateTime(campaign.startedAt ?? campaign.scheduledAt ?? campaign.cancelledAt);
}

/** Chiến dịch thông báo (TASK-NSR-003): Admin gửi tin dịch vụ, khuyến mãi, tin tức tới hành khách qua hộp thư và push. */
export function CampaignScreen() {
  const [status, setStatus] = useState(ALL);
  const list = useInfiniteQuery({
    queryKey: ["admin-campaigns", status],
    queryFn: ({ pageParam }) => listCampaigns({ status: status === ALL ? undefined : (status as CampaignStatus), offset: pageParam }),
    initialPageParam: 0,
    getNextPageParam: (page) => (page.offset + CAMPAIGN_PAGE_SIZE < page.total ? page.offset + CAMPAIGN_PAGE_SIZE : undefined)
  });
  const items = list.data?.pages.flatMap((page) => page.items) ?? [];
  const total = list.data?.pages[0]?.total ?? 0;

  let body: ReactNode;
  if (list.isPending) {
    body = <TableSkeleton label="Đang tải chiến dịch" rows={5} />;
  } else if (list.isError && !list.data) {
    body = (
      <ListStatePanel
        icon={<CircleAlert className="size-6 text-warning-700" />}
        title="Không tải được chiến dịch"
        description="Không kết nối được máy chủ. Vui lòng kiểm tra kết nối và thử lại."
        action={
          <Button variant="outline" className={`${BUTTON} bg-card`} onClick={() => void list.refetch()}>
            <RefreshCw className="size-[18px]" />
            Thử lại
          </Button>
        }
        compact
      />
    );
  } else if (items.length === 0) {
    body = <ListStatePanel icon={<Megaphone className="size-6 text-vxn-fg-3" />} title="Chưa có chiến dịch" description="Tạo thông báo để gửi tới hành khách qua hộp thư và push." compact />;
  } else {
    body = (
      <div className="overflow-x-auto">
        <table className={`${TABLE} min-w-[860px]`}>
          <thead>
            <tr className={TABLE_HEAD_ROW}>
              {["Thông báo", "Đối tượng", "Thời gian gửi", "Đã nhận", "Trạng thái", ""].map((heading, index) => (
                <th key={index} scope="col" className={`${TABLE_HEAD_CELL} ${heading === "Đã nhận" ? "text-right" : ""}`}>
                  {heading}
                </th>
              ))}
            </tr>
          </thead>
          <tbody>
            {items.map((campaign) => (
              <tr key={campaign.id} className="border-b last:border-b-0">
                <td className={TABLE_CELL}>
                  <p className="truncate font-semibold text-vxn-ink">{campaign.title}</p>
                  <p className="text-xs leading-[18px] text-muted-foreground">{CAMPAIGN_TYPE[campaign.type].label}</p>
                </td>
                <td className={TABLE_CELL}>{audienceLabel(campaign)}</td>
                <td className={`${TABLE_CELL} tabular-nums`}>{sendTime(campaign)}</td>
                <td className={`${TABLE_CELL} text-right font-semibold tabular-nums`}>{COUNT.format(campaign.recipientCount)}</td>
                <td className={TABLE_CELL}>
                  <Badge tone={CAMPAIGN_STATUS[campaign.status].tone}>{CAMPAIGN_STATUS[campaign.status].label}</Badge>
                </td>
                <td className={TABLE_CELL}>
                  <Link href={`/notifications/${campaign.id}`} className="inline-flex items-center font-semibold text-vxn-ink" aria-label={`Xem ${campaign.title}`}>
                    Xem
                    <ChevronRight className="size-4" />
                  </Link>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    );
  }

  return (
    <div className="flex flex-col gap-6">
      <PageHeader
        title="Thông báo"
        description="Gửi tin dịch vụ, khuyến mãi và tin tức tới hành khách qua hộp thư trong ứng dụng và thông báo đẩy."
        actions={
          <Button asChild className={BUTTON}>
            <Link href="/notifications/new">
              <Plus className="size-[18px]" />
              Tạo thông báo
            </Link>
          </Button>
        }
      />
      <section aria-label="Chiến dịch thông báo" className="flex flex-col rounded-xl border bg-card p-6">
        <div className="flex flex-wrap items-end gap-x-4 gap-y-3 pb-5">
          <FilterSelect label="Trạng thái" allLabel="Tất cả trạng thái" value={status} onChange={setStatus} options={CAMPAIGN_STATUS_ORDER.map((value) => ({ value, label: CAMPAIGN_STATUS[value].label }))} />
        </div>
        {body}
        {items.length > 0 && (
          <div className="flex pt-5">
            <ListLoadMoreFooter
              hasMore={list.hasNextPage}
              loading={list.isFetchingNextPage}
              failed={list.isFetchNextPageError}
              loadedText={`Đã tải ${items.length} / ${COUNT.format(total)} chiến dịch`}
              endText={`Đã tải ${COUNT.format(items.length)} chiến dịch`}
              errorText="Chưa tải thêm được."
              onLoadMore={() => void list.fetchNextPage()}
            />
          </div>
        )}
      </section>
      <div role="note" className="flex items-center gap-3 rounded-lg bg-accent px-5 py-4 text-sm leading-5 text-accent-foreground">
        <Info className="size-[18px] shrink-0" aria-hidden />
        Chiến dịch chỉ gửi qua hộp thư và thông báo đẩy, không gửi email hàng loạt để không ảnh hưởng hạn mức email của mã đăng nhập.
      </div>
    </div>
  );
}
