"use client";

import { useInfiniteQuery, useQuery } from "@tanstack/react-query";
import { Badge } from "@vexenhanh/ui/components/badge";
import { Button } from "@vexenhanh/ui/components/button";
import { Dialog, DialogContent, DialogDescription, DialogHeader, DialogTitle } from "@vexenhanh/ui/components/dialog";
import {
  ALL,
  FilterSelect,
  SearchField,
  TABLE,
  TABLE_CELL,
  TABLE_HEAD_CELL,
  TABLE_HEAD_ROW,
  TableSkeleton,
  useDebouncedValue
} from "@vexenhanh/ui/components/list-controls";
import { BUTTON, ListLoadMoreFooter, ListStatePanel } from "@vexenhanh/ui/components/list-parts";
import { CircleAlert, Eye, FileText, LoaderCircle, Pencil, RefreshCw } from "lucide-react";
import Link from "next/link";
import { useMemo, useState, type ReactNode } from "react";

import { formatDate } from "../../lib/article/article-format";
import {
  getContentPage,
  listContentPages,
  type ContentPageFilters,
  type ContentPageStatus,
  type ContentPageSummary,
  type ContentPageType
} from "../../lib/content/content-page-api";
import { CONTENT_STATUS, PLACEMENT_LABEL, TYPE_LABEL, TYPE_ORDER } from "../../lib/content/content-page-format";
import { MarkdownPreview } from "../article/markdown-preview";

/**
 * Tab "Nội dung công khai" của màn Kiểm duyệt (Figma ADM-10d; FR-ADM-13, UC-28; TASK-ADM-003): banner, câu hỏi thường gặp,
 * trang tĩnh — mới sửa trước; lọc loại / tình trạng, tìm tiêu đề; sửa (bút) và xem trước (mắt).
 */
export function PublicContentPanel() {
  const [search, setSearch] = useState("");
  const [type, setType] = useState<string>(ALL);
  const [status, setStatus] = useState<string>(ALL);
  const [previewId, setPreviewId] = useState<string | null>(null);
  const q = useDebouncedValue(search.trim());
  const filters = useMemo<ContentPageFilters>(
    () => ({
      q: q || undefined,
      type: type === ALL ? undefined : (type as ContentPageType),
      status: status === ALL ? undefined : (status as ContentPageStatus)
    }),
    [q, type, status]
  );
  const pages = useInfiniteQuery({
    queryKey: ["admin-content-pages", filters],
    queryFn: ({ pageParam }) => listContentPages(filters, pageParam),
    initialPageParam: null as string | null,
    getNextPageParam: (last) => last.nextCursor
  });
  const rows = pages.data?.pages.flatMap((page) => page.items) ?? [];
  const total = pages.data?.pages[0]?.total ?? 0;
  const filtered = q !== "" || type !== ALL || status !== ALL;

  let body: ReactNode;
  let footer: ReactNode = null;
  if (pages.isError && rows.length === 0) {
    body = (
      <ListStatePanel
        icon={<CircleAlert className="size-6 text-warning-700" />}
        title="Không tải được nội dung"
        description="Kiểm tra kết nối mạng rồi thử lại."
        action={
          <Button className={`${BUTTON} w-36`} onClick={() => void pages.refetch()}>
            <RefreshCw className="size-[18px]" />
            Thử lại
          </Button>
        }
      />
    );
  } else if (pages.isPending) {
    body = <TableSkeleton label="Đang tải nội dung" />;
  } else if (rows.length === 0) {
    body = (
      <ListStatePanel
        icon={<FileText className="size-6 text-vxn-fg-3" />}
        title={filtered ? "Không có nội dung phù hợp" : "Chưa có nội dung công khai"}
        description={
          filtered ? "Đổi bộ lọc hoặc từ khóa." : "Bấm \"Thêm nội dung\" để tạo banner trang chủ, câu hỏi thường gặp hoặc trang tĩnh."
        }
        action={
          filtered ? (
            <Button
              variant="outline"
              className={`${BUTTON} bg-card`}
              onClick={() => {
                setSearch("");
                setType(ALL);
                setStatus(ALL);
              }}
            >
              Bỏ lọc
            </Button>
          ) : undefined
        }
      />
    );
  } else {
    body = <ContentTable rows={rows} onPreview={setPreviewId} />;
    footer = (
      <ListLoadMoreFooter
        hasMore={pages.hasNextPage}
        loading={pages.isFetchingNextPage}
        failed={pages.isFetchNextPageError}
        loadedText={`Đã tải ${rows.length} / ${total.toLocaleString("vi-VN")} nội dung`}
        endText={`Đã hiện tất cả ${rows.length} nội dung`}
        errorText="Không tải thêm được nội dung. Kiểm tra kết nối rồi thử lại."
        onLoadMore={() => void pages.fetchNextPage()}
      />
    );
  }

  return (
    <section aria-label="Nội dung công khai" className="flex flex-col rounded-xl border bg-card p-6">
      <div className="flex flex-wrap items-end gap-x-4 gap-y-3 pb-5">
        <FilterSelect
          label="Loại nội dung"
          allLabel="Tất cả"
          value={type}
          onChange={setType}
          options={TYPE_ORDER.map((value) => ({ value, label: TYPE_LABEL[value] }))}
        />
        <FilterSelect
          label="Tình trạng"
          allLabel="Tất cả"
          value={status}
          onChange={setStatus}
          options={(["PUBLISHED", "DRAFT"] as const).map((value) => ({ value, label: CONTENT_STATUS[value].label }))}
        />
        <SearchField label="Tìm kiếm" placeholder="Tiêu đề" value={search} onChange={setSearch} />
      </div>
      <div className="min-h-[320px]">{body}</div>
      {footer && <div className="flex min-h-14 items-center pt-5">{footer}</div>}
      <PreviewDialog id={previewId} onClose={() => setPreviewId(null)} />
    </section>
  );
}

// Độ rộng cột theo Figma ADM-10d (co giãn ở cột Tiêu đề).
const COLUMNS = ["", "w-[15%]", "w-[19%]", "w-[13%]", "w-[13%]", "w-[88px]"];
const HEADINGS = ["Tiêu đề", "Loại", "Vị trí hiển thị", "Cập nhật", "Tình trạng", ""];

function ContentTable({ rows, onPreview }: { rows: ContentPageSummary[]; onPreview: (id: string) => void }) {
  return (
    <div className="relative overflow-x-auto">
      <table className={`${TABLE} min-w-[860px]`}>
        <colgroup>
          {COLUMNS.map((width, index) => (
            <col key={index} className={width} />
          ))}
        </colgroup>
        <thead>
          <tr className={TABLE_HEAD_ROW}>
            {HEADINGS.map((heading, index) => (
              <th key={index} scope="col" className={TABLE_HEAD_CELL}>
                {heading || <span className="sr-only">Thao tác</span>}
              </th>
            ))}
          </tr>
        </thead>
        <tbody>
          {rows.map((row) => {
            const status = CONTENT_STATUS[row.status];
            return (
              <tr key={row.id} className="h-[55px] border-b">
                <td className={TABLE_CELL}>
                  <span className="block truncate font-semibold text-vxn-ink">{row.title}</span>
                </td>
                <td className={TABLE_CELL}>{TYPE_LABEL[row.type]}</td>
                <td className={TABLE_CELL}>{PLACEMENT_LABEL[row.placement]}</td>
                <td className={TABLE_CELL}>{formatDate(row.updatedAt)}</td>
                <td className={TABLE_CELL}>
                  <Badge tone={status.tone}>{status.label}</Badge>
                </td>
                <td className={TABLE_CELL}>
                  <div className="flex items-center gap-1">
                    <Link
                      href={`/moderation/content/${row.id}`}
                      aria-label={`Sửa ${row.title}`}
                      className="inline-flex size-8 items-center justify-center rounded-md text-vxn-fg-2 outline-none hover:bg-muted focus-visible:ring-[3px] focus-visible:ring-ring/50"
                    >
                      <Pencil className="size-4" />
                    </Link>
                    <button
                      type="button"
                      aria-label={`Xem trước ${row.title}`}
                      onClick={() => onPreview(row.id)}
                      className="inline-flex size-8 items-center justify-center rounded-md text-vxn-fg-2 outline-none hover:bg-muted focus-visible:ring-[3px] focus-visible:ring-ring/50"
                    >
                      <Eye className="size-4" />
                    </button>
                  </div>
                </td>
              </tr>
            );
          })}
        </tbody>
      </table>
    </div>
  );
}

/** Xem trước nội dung như sẽ hiện ngoài trang công khai (Markdown không render HTML thô). */
function PreviewDialog({ id, onClose }: { id: string | null; onClose: () => void }) {
  const detail = useQuery({ queryKey: ["admin-content-page", id], queryFn: () => getContentPage(id!), enabled: id !== null });
  const page = detail.data;
  return (
    <Dialog open={id !== null} onOpenChange={(open) => !open && onClose()}>
      <DialogContent className="max-h-[85vh] overflow-y-auto sm:max-w-2xl">
        <DialogHeader>
          <DialogTitle>{page?.title ?? "Xem trước"}</DialogTitle>
          <DialogDescription>
            {page ? `${TYPE_LABEL[page.type]} · ${PLACEMENT_LABEL[page.placement]} · ${CONTENT_STATUS[page.status].label}` : "Đang tải…"}
          </DialogDescription>
        </DialogHeader>
        {detail.isPending ? (
          <LoaderCircle aria-label="Đang tải nội dung" className="mx-auto size-6 animate-spin text-muted-foreground" />
        ) : detail.isError ? (
          <p role="alert" className="text-sm text-error-600">
            Không tải được nội dung.
          </p>
        ) : (
          <div className="flex flex-col gap-3">
            {page?.imageUrl && <img src={page.imageUrl} alt="" className="aspect-[21/9] w-full rounded-lg object-cover" />}
            <MarkdownPreview markdown={page?.bodyMarkdown ?? ""} />
            {page?.linkUrl && <p className="text-xs text-muted-foreground">Bấm banner mở: {page.linkUrl}</p>}
            {page?.slug && <p className="text-xs text-muted-foreground">Đường dẫn: /trang/{page.slug}</p>}
          </div>
        )}
      </DialogContent>
    </Dialog>
  );
}
