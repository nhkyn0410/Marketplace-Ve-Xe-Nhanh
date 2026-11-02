"use client";

import { useInfiniteQuery, useQuery } from "@tanstack/react-query";
import { Badge } from "@vexenhanh/ui/components/badge";
import { Button } from "@vexenhanh/ui/components/button";
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
import { CircleAlert, FileText, ImageIcon, Pencil, RefreshCw } from "lucide-react";
import Link from "next/link";
import { useMemo, useState, type ReactNode } from "react";

import {
  listArticleCategories,
  listArticles,
  type ArticleFilters,
  type ArticleStatus,
  type ArticleSummary
} from "../../lib/article/article-api";
import { ARTICLE_STATUS, formatDate, STATUS_ORDER } from "../../lib/article/article-format";

/**
 * Tab "Bài viết" (Figma ADM-13a): mọi trạng thái, sửa gần nhất trước; tìm tiêu đề / slug, lọc trạng thái và chuyên
 * mục; mỗi dòng có ảnh bìa thu nhỏ, chuyên mục, nhãn trạng thái / nổi bật, ngày xuất bản, lượt xem.
 */
export function ArticleList() {
  const [search, setSearch] = useState("");
  const [status, setStatus] = useState<string>(ALL);
  const [categoryId, setCategoryId] = useState<string>(ALL);
  const q = useDebouncedValue(search.trim());
  const categories = useQuery({ queryKey: ["admin-article-categories"], queryFn: listArticleCategories });

  const filters = useMemo<ArticleFilters>(
    () => ({
      q: q || undefined,
      status: status === ALL ? undefined : (status as ArticleStatus),
      categoryId: categoryId === ALL ? undefined : categoryId
    }),
    [q, status, categoryId]
  );
  const pages = useInfiniteQuery({
    queryKey: ["admin-articles", filters],
    queryFn: ({ pageParam }) => listArticles(filters, pageParam),
    initialPageParam: null as string | null,
    getNextPageParam: (last) => last.nextCursor
  });
  const rows = pages.data?.pages.flatMap((page) => page.items) ?? [];
  const total = pages.data?.pages[0]?.total ?? 0;
  const filtered = q !== "" || status !== ALL || categoryId !== ALL;

  let body: ReactNode;
  let footer: ReactNode = null;
  if (pages.isError && rows.length === 0) {
    body = (
      <ListStatePanel
        icon={<CircleAlert className="size-6 text-warning-700" />}
        title="Không tải được bài viết"
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
    body = <TableSkeleton label="Đang tải bài viết" />;
  } else if (rows.length === 0) {
    body = (
      <ListStatePanel
        icon={<FileText className="size-6 text-vxn-fg-3" />}
        title={filtered ? "Không có bài viết phù hợp" : "Chưa có bài viết nào"}
        description={filtered ? "Đổi bộ lọc hoặc từ khóa." : "Bấm \"Viết bài mới\" để soạn bài đầu tiên cho trang Khám phá."}
        action={
          filtered ? (
            <Button
              variant="outline"
              className={`${BUTTON} bg-card`}
              onClick={() => {
                setSearch("");
                setStatus(ALL);
                setCategoryId(ALL);
              }}
            >
              Bỏ lọc
            </Button>
          ) : undefined
        }
      />
    );
  } else {
    body = <ArticleTable rows={rows} />;
    footer = (
      <ListLoadMoreFooter
        hasMore={pages.hasNextPage}
        loading={pages.isFetchingNextPage}
        failed={pages.isFetchNextPageError}
        loadedText={`Đã tải ${rows.length} / ${total.toLocaleString("vi-VN")} bài viết`}
        endText={`Đã hiện tất cả ${rows.length} bài viết`}
        errorText="Không tải thêm được bài viết. Kiểm tra kết nối rồi thử lại."
        onLoadMore={() => void pages.fetchNextPage()}
      />
    );
  }

  return (
    <section aria-label="Danh sách bài viết" className="flex flex-col rounded-xl border bg-card p-6">
      <div className="flex flex-wrap items-end gap-x-4 gap-y-3 pb-5">
        <SearchField label="Tìm bài viết" placeholder="Tiêu đề hoặc slug" value={search} onChange={setSearch} />
        <FilterSelect
          label="Trạng thái"
          allLabel="Tất cả trạng thái"
          value={status}
          onChange={setStatus}
          options={STATUS_ORDER.map((value) => ({ value, label: ARTICLE_STATUS[value].label }))}
          className="w-52"
        />
        <FilterSelect
          label="Chuyên mục"
          allLabel="Tất cả chuyên mục"
          value={categoryId}
          onChange={setCategoryId}
          options={(categories.data ?? []).map((category) => ({ value: category.id, label: category.name }))}
          className="w-56"
        />
      </div>
      <div className="min-h-[320px]">{body}</div>
      {footer && <div className="flex min-h-14 items-center pt-5">{footer}</div>}
    </section>
  );
}

// Độ rộng cột theo Figma ADM-13a (co giãn ở cột Bài viết).
const COLUMNS = ["", "w-[13%]", "w-[12%]", "w-[9%]", "w-[12%]", "w-[9%]", "w-[6%]"];
const HEADINGS = ["Bài viết", "Chuyên mục", "Trạng thái", "Nổi bật", "Xuất bản", "Lượt xem", ""];

function ArticleTable({ rows }: { rows: ArticleSummary[] }) {
  return (
    <div className="relative overflow-x-auto">
      <table className={`${TABLE} min-w-[900px]`}>
        <colgroup>
          {COLUMNS.map((width, index) => (
            <col key={index} className={width} />
          ))}
        </colgroup>
        <thead>
          <tr className={TABLE_HEAD_ROW}>
            {HEADINGS.map((heading, index) => (
              <th key={index} scope="col" className={`${TABLE_HEAD_CELL} ${index === 5 ? "text-right" : ""}`}>
                {heading || <span className="sr-only">Thao tác</span>}
              </th>
            ))}
          </tr>
        </thead>
        <tbody>
          {rows.map((row) => {
            const status = ARTICLE_STATUS[row.status];
            return (
              <tr key={row.id} className="h-[68px] border-b">
                <td className={TABLE_CELL}>
                  <div className="flex min-w-0 items-center gap-3">
                    <div className="relative h-10 w-14 shrink-0 overflow-hidden rounded-md bg-muted">
                      {row.coverImageUrl ? (
                        <img src={row.coverImageUrl} alt="" className="absolute inset-0 size-full object-cover" />
                      ) : (
                        <ImageIcon className="absolute inset-0 m-auto size-4 text-muted-foreground" />
                      )}
                    </div>
                    <div className="flex min-w-0 flex-col">
                      <span className="truncate font-semibold text-vxn-ink">{row.title}</span>
                      <span className="truncate text-xs leading-[18px] text-muted-foreground">{row.slug}</span>
                    </div>
                  </div>
                </td>
                <td className={TABLE_CELL}>
                  <span className="line-clamp-2">{row.categoryName}</span>
                </td>
                <td className={TABLE_CELL}>
                  <Badge tone={status.tone}>{status.label}</Badge>
                </td>
                <td className={TABLE_CELL}>{row.featured ? <Badge tone="warning">Nổi bật</Badge> : "—"}</td>
                <td className={TABLE_CELL}>{row.status === "DRAFT" ? "—" : formatDate(row.publishedAt)}</td>
                <td className={`${TABLE_CELL} text-right`}>{row.status === "DRAFT" ? "—" : row.viewCount.toLocaleString("vi-VN")}</td>
                <td className={TABLE_CELL}>
                  <Link
                    href={`/articles/${row.id}`}
                    aria-label={`Sửa bài ${row.title}`}
                    className="inline-flex size-8 items-center justify-center rounded-md text-vxn-ink outline-none hover:bg-muted focus-visible:ring-[3px] focus-visible:ring-ring/50"
                  >
                    <Pencil className="size-4" />
                  </Link>
                </td>
              </tr>
            );
          })}
        </tbody>
      </table>
    </div>
  );
}
