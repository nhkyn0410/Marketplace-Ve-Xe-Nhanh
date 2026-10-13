"use client";

import { useInfiniteQuery } from "@tanstack/react-query";
import { Badge } from "@vexenhanh/ui/components/badge";
import { Button } from "@vexenhanh/ui/components/button";
import { CircleAlert, FileX2, Pencil, RefreshCw } from "lucide-react";
import { useMemo, useState, type ReactNode } from "react";

import {
  listStopPointProposals,
  type StopPointProposal,
  type StopPointProposalStatus
} from "../../lib/stop-point/stop-point-api";
import {
  formatDate,
  PROPOSAL_STATUS,
  PROPOSAL_STATUS_ORDER,
  STOP_POINT_TYPE_LABELS
} from "../../lib/stop-point/stop-point-format";
import { BUTTON, ListFooterNote, ListLoadMoreFooter, ListStatePanel } from "../list-parts";
import { ALL, FilterSelect, TABLE, TABLE_CELL, TABLE_HEAD_CELL, TABLE_HEAD_ROW, TableSkeleton } from "./list-controls";

/**
 * Tab "Dùng chung", phần đề xuất của nhà xe (Figma 02; FR-OPS-17, BR-38): theo dõi Chờ duyệt / Đã duyệt /
 * Bị từ chối; bản bị từ chối hiện lý do và sửa, gửi lại được.
 */
export function ProposalList({ onResubmit }: { onResubmit: (proposal: StopPointProposal) => void }) {
  const [status, setStatus] = useState<string>(ALL);

  const proposals = useInfiniteQuery({
    queryKey: ["stop-point-proposals", status],
    queryFn: ({ pageParam }) =>
      listStopPointProposals({
        status: status === ALL ? undefined : (status as StopPointProposalStatus),
        cursor: pageParam
      }),
    initialPageParam: undefined as string | undefined,
    getNextPageParam: (lastPage) => lastPage.nextCursor ?? undefined
  });
  const items = useMemo(() => proposals.data?.pages.flatMap((page) => page.items) ?? [], [proposals.data]);
  const filtered = status !== ALL;

  let body: ReactNode;
  let footer: ReactNode = null;
  if (proposals.isError && !proposals.data) {
    body = (
      <ListStatePanel
        compact
        icon={<CircleAlert className="size-6 text-warning-700" />}
        title="Không tải được đề xuất"
        description="Kiểm tra kết nối mạng rồi thử lại."
        action={
          <Button className={`${BUTTON} w-36`} onClick={() => void proposals.refetch()}>
            <RefreshCw className="size-[18px]" />
            Thử lại
          </Button>
        }
      />
    );
  } else if (proposals.isPending) {
    body = <TableSkeleton label="Đang tải đề xuất của nhà xe" rows={2} />;
    footer = <ListFooterNote>Đang tải đề xuất…</ListFooterNote>;
  } else if (items.length === 0) {
    body = filtered ? (
      <ListStatePanel
        compact
        icon={<FileX2 className="size-6 text-vxn-fg-3" />}
        title="Không có đề xuất ở trạng thái này"
        description="Chọn trạng thái khác hoặc bỏ lọc để xem toàn bộ đề xuất."
        action={
          <Button variant="outline" className={`${BUTTON} bg-card`} onClick={() => setStatus(ALL)}>
            Bỏ lọc
          </Button>
        }
      />
    ) : (
      <ListStatePanel
        compact
        icon={<FileX2 className="size-6 text-vxn-fg-3" />}
        title="Chưa có đề xuất nào"
        description="Khi danh mục thiếu bến xe hoặc điểm dừng đón trả khách bạn cần, bấm “Đề xuất điểm dừng” ở đầu trang."
      />
    );
  } else {
    body = <ProposalTable items={items} onResubmit={onResubmit} />;
    footer = (
      <ListLoadMoreFooter
        hasMore={proposals.hasNextPage}
        loading={proposals.isFetchingNextPage}
        failed={proposals.isFetchNextPageError}
        loadedText={`Đã tải ${items.length} đề xuất`}
        endText={`Đã hiển thị tất cả ${items.length} đề xuất`}
        errorText="Chưa tải thêm được đề xuất. Các dòng đã tải vẫn được giữ lại."
        onLoadMore={() => void proposals.fetchNextPage()}
      />
    );
  }

  return (
    <section aria-labelledby="stop-point-proposals-heading" className="flex flex-col rounded-xl border bg-card p-6">
      <div className="flex flex-wrap items-end gap-4 pb-5">
        <div className="flex min-w-0 flex-1 flex-col gap-1">
          <h2 id="stop-point-proposals-heading" className="text-base leading-6 font-semibold text-vxn-ink">
            Đề xuất của nhà xe
          </h2>
          <p className="text-xs leading-[18px] text-muted-foreground">
            Thiếu bến xe hoặc điểm dừng đón trả khách? Gửi đề xuất kèm căn cứ công bố, Platform duyệt rồi đưa vào danh
            mục dùng chung.
          </p>
        </div>
        <FilterSelect
          label="Trạng thái"
          allLabel="Tất cả trạng thái"
          value={status}
          onChange={setStatus}
          options={PROPOSAL_STATUS_ORDER.map((value) => ({ value, label: PROPOSAL_STATUS[value].label }))}
        />
      </div>
      <div className="min-h-[240px]">{body}</div>
      {footer && <div className="flex min-h-20 flex-wrap items-center gap-3 py-5">{footer}</div>}
    </section>
  );
}

// Tỉ lệ cột theo Figma (tên co giãn / 180 / 230 / 110 / 120 / 176 trên bảng rộng 1088).
const COLUMNS = ["", "w-[16.5%]", "w-[21%]", "w-[10%]", "w-[11%]", "w-44"];

function ProposalTable({
  items,
  onResubmit
}: {
  items: StopPointProposal[];
  onResubmit: (proposal: StopPointProposal) => void;
}) {
  return (
    <div className="overflow-x-auto">
      <table className={`${TABLE} min-w-[960px]`}>
        <colgroup>
          {COLUMNS.map((width, index) => (
            <col key={index} className={width} />
          ))}
        </colgroup>
        <thead>
          <tr className={TABLE_HEAD_ROW}>
            {["Tên và địa chỉ", "Loại điểm", "Căn cứ công bố", "Ngày gửi", "Trạng thái", "Thao tác"].map((heading) => (
              <th key={heading} scope="col" className={TABLE_HEAD_CELL}>
                {heading}
              </th>
            ))}
          </tr>
        </thead>
        <tbody>
          {items.map((proposal) => {
            const state = PROPOSAL_STATUS[proposal.status];
            return (
              <tr key={proposal.id} className="h-[76px] border-b">
                <td className={TABLE_CELL}>
                  <div className="flex flex-col gap-1">
                    <span className="font-semibold text-vxn-ink">{proposal.name}</span>
                    <span className="text-xs leading-[18px] text-muted-foreground">{proposal.address}</span>
                    {proposal.status === "REJECTED" && (
                      <span className="flex items-start gap-1.5 text-xs leading-[18px] text-error-600">
                        <CircleAlert className="mt-px size-4 shrink-0" aria-hidden />
                        <span>Lý do từ chối: {proposal.rejectionReason}</span>
                      </span>
                    )}
                  </div>
                </td>
                <td className={TABLE_CELL}>{STOP_POINT_TYPE_LABELS[proposal.type]}</td>
                <td className={`${TABLE_CELL} break-words`}>{proposal.legalBasis}</td>
                <td className={TABLE_CELL}>{formatDate(proposal.createdAt)}</td>
                <td className={TABLE_CELL}>
                  <Badge tone={state.tone}>{state.label}</Badge>
                </td>
                <td className={TABLE_CELL}>
                  {proposal.status === "REJECTED" ? (
                    <Button
                      variant="outline"
                      className={`${BUTTON} bg-card`}
                      aria-label={`Sửa và gửi lại đề xuất ${proposal.name}`}
                      onClick={() => onResubmit(proposal)}
                    >
                      <Pencil className="size-[18px]" />
                      Sửa và gửi lại
                    </Button>
                  ) : (
                    <span className="text-xs leading-[18px] text-muted-foreground">{state.hint}</span>
                  )}
                </td>
              </tr>
            );
          })}
        </tbody>
      </table>
    </div>
  );
}
