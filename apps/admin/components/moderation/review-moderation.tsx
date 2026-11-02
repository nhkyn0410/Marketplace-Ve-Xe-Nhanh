"use client";

import { useInfiniteQuery, useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { Badge } from "@vexenhanh/ui/components/badge";
import { Button } from "@vexenhanh/ui/components/button";
import { Dialog, DialogContent, DialogDescription, DialogFooter, DialogHeader, DialogTitle } from "@vexenhanh/ui/components/dialog";
import { FormField } from "@vexenhanh/ui/components/form-field";
import { ALL, FilterSelect, SearchField, TABLE, TABLE_CELL, TABLE_HEAD_CELL, TABLE_HEAD_ROW, TableSkeleton, useDebouncedValue } from "@vexenhanh/ui/components/list-controls";
import { BUTTON, ListLoadMoreFooter, ListStatePanel } from "@vexenhanh/ui/components/list-parts";
import { Textarea } from "@vexenhanh/ui/components/textarea";
import { CircleAlert, CircleCheck, Info, LoaderCircle, RefreshCw, Star } from "lucide-react";
import { useState } from "react";

import { listOperatorOptions } from "../../lib/report/report-api";
import { listReviews, moderateReview, type Review, type ReviewStatus } from "../../lib/support/support-api";
import { describeCaseError, REVIEW_STATUS, shortMoment, SIGNAL } from "../../lib/support/support-format";

const ATTENTION = "attention";
const COUNT = new Intl.NumberFormat("vi-VN");
type Action = "HOLD" | "HIDE" | "SHOW";
const ACTION_LABEL: Record<Action, string> = { HOLD: "Giữ chờ", HIDE: "Ẩn đánh giá", SHOW: "Hiển thị lại" };

/**
 * Kiểm duyệt đánh giá (Figma ADM-10a; TASK-TRUST-001, BR-55, UC-28): mặc định "Cần xem xét" (đang giữ chờ, nhà xe báo cáo, nghi spam,
 * nội dung lặp, đơn đang tranh chấp), tín hiệu từng đánh giá; Giữ chờ / Ẩn (bắt buộc lý do) / Hiển thị lại — mọi lần ghi audit.
 */
export function ReviewModeration() {
  const [status, setStatus] = useState(ATTENTION);
  const [operatorId, setOperatorId] = useState(ALL);
  const [rating, setRating] = useState(ALL);
  const [search, setSearch] = useState("");
  const [acting, setActing] = useState<{ review: Review; action: Action } | null>(null);
  const [notice, setNotice] = useState<string | null>(null);
  const q = useDebouncedValue(search.trim());
  const operators = useQuery({ queryKey: ["admin-report", "operators"], queryFn: listOperatorOptions });
  const reviews = useInfiniteQuery({
    queryKey: ["admin-reviews", status, operatorId, rating, q],
    queryFn: ({ pageParam }) =>
      listReviews({
        status: status === ALL ? undefined : (status as ReviewStatus | "attention"),
        operatorId: operatorId === ALL ? undefined : operatorId,
        rating: rating === ALL ? undefined : Number(rating),
        q: q || undefined,
        cursor: pageParam ?? undefined
      }),
    initialPageParam: null as string | null,
    getNextPageParam: (page) => page.nextCursor
  });
  const items = reviews.data?.pages.flatMap((page) => page.items) ?? [];
  const total = reviews.data?.pages[0]?.total ?? 0;
  const filtered = status !== ATTENTION || operatorId !== ALL || rating !== ALL || q !== "";

  let body;
  if (reviews.isPending) {
    body = <TableSkeleton label="Đang tải đánh giá" rows={5} />;
  } else if (reviews.isError && !reviews.data) {
    body = (
      <ListStatePanel
        icon={<CircleAlert className="size-6 text-warning-700" />}
        title="Không tải được đánh giá"
        description="Không kết nối được máy chủ. Vui lòng kiểm tra kết nối và thử lại."
        action={
          <Button variant="outline" className={`${BUTTON} bg-card`} onClick={() => void reviews.refetch()}>
            <RefreshCw className="size-[18px]" />
            Thử lại
          </Button>
        }
      />
    );
  } else if (items.length === 0) {
    body = (
      <ListStatePanel
        icon={status === ATTENTION && !filtered ? <CircleCheck className="size-6 text-success-600" /> : <Star className="size-6 text-vxn-fg-3" />}
        title={status === ATTENTION ? "Không có đánh giá cần xem xét" : "Không có đánh giá phù hợp"}
        description="Đánh giá bị nhà xe báo cáo, nghi spam, nội dung lặp hoặc thuộc đơn đang tranh chấp hiện ở tab Cần xem xét."
        compact
      />
    );
  } else {
    body = (
      <div className="overflow-x-auto">
        <table className={`${TABLE} min-w-[980px]`}>
          <colgroup>
            {["w-[34%]", "w-[20%]", "w-[16%]", "w-[12%]", "w-[18%]"].map((width, index) => (
              <col key={index} className={width} />
            ))}
          </colgroup>
          <thead>
            <tr className={TABLE_HEAD_ROW}>
              {["Đánh giá", "Nhà xe và chuyến", "Tín hiệu", "Tình trạng", "Thao tác"].map((heading) => (
                <th key={heading} scope="col" className={TABLE_HEAD_CELL}>
                  {heading}
                </th>
              ))}
            </tr>
          </thead>
          <tbody>
            {items.map((review) => (
              <ReviewRow key={review.reviewId} review={review} onAct={(action) => setActing({ review, action })} />
            ))}
          </tbody>
        </table>
      </div>
    );
  }

  return (
    <>
      {notice && (
        <p role="status" className="rounded-lg bg-success-50 px-5 py-3 text-sm leading-5 text-success-700">
          {notice}
        </p>
      )}
      <section aria-label="Đánh giá" className="flex flex-col rounded-xl border bg-card p-6">
        <div className="flex flex-wrap items-end gap-x-4 gap-y-3 pb-5">
          <FilterSelect
            label="Tình trạng"
            allLabel="Tất cả"
            value={status}
            onChange={setStatus}
            options={[{ value: ATTENTION, label: "Cần xem xét" }, ...(Object.keys(REVIEW_STATUS) as ReviewStatus[]).map((value) => ({ value, label: REVIEW_STATUS[value].label }))]}
            className="w-44"
          />
          <FilterSelect label="Nhà xe" allLabel="Tất cả nhà xe" value={operatorId} onChange={setOperatorId} options={operators.data ?? []} className="w-48" />
          <FilterSelect label="Số sao" allLabel="Tất cả" value={rating} onChange={setRating} options={[5, 4, 3, 2, 1].map((value) => ({ value: String(value), label: `${value} sao` }))} className="w-32" />
          <SearchField value={search} onChange={setSearch} placeholder="Nội dung đánh giá hoặc mã đặt vé" />
        </div>
        {body}
        {items.length > 0 && (
          <div className="flex pt-5">
            <ListLoadMoreFooter
              hasMore={reviews.hasNextPage}
              loading={reviews.isFetchingNextPage}
              failed={reviews.isFetchNextPageError}
              loadedText={`Đã tải ${items.length} / ${COUNT.format(total)} đánh giá${status === ATTENTION ? " cần xem xét" : ""}`}
              endText={`Đã hiển thị tất cả ${COUNT.format(items.length)} đánh giá`}
              errorText="Chưa tải thêm được đánh giá. Các dòng đã tải vẫn được giữ lại."
              onLoadMore={() => void reviews.fetchNextPage()}
            />
          </div>
        )}
      </section>
      <div role="note" className="flex items-center gap-3 rounded-lg bg-accent px-5 py-4 text-sm leading-5 text-accent-foreground">
        <Info className="size-[18px] shrink-0" aria-hidden />
        Chỉ đánh giá hợp lệ mới được tính vào chỉ số chất lượng của nhà xe. Ẩn đánh giá cần lý do và được ghi nhật ký audit; đánh giá đang nằm trong tranh chấp có thể được giữ chờ.
      </div>
      {acting && (
        <ModerationDialog
          review={acting.review}
          action={acting.action}
          onClose={() => setActing(null)}
          onDone={(message) => {
            setActing(null);
            setNotice(message);
          }}
        />
      )}
    </>
  );
}

function Stars({ rating }: { rating: number }) {
  return (
    <span className="inline-flex" aria-label={`${rating} sao`}>
      {[1, 2, 3, 4, 5].map((value) => (
        <Star key={value} className={`size-3.5 ${value <= rating ? "fill-warning-500 text-warning-500" : "text-vxn-fg-3"}`} aria-hidden />
      ))}
    </span>
  );
}

function ReviewRow({ review, onAct }: { review: Review; onAct: (action: Action) => void }) {
  const status = REVIEW_STATUS[review.status];
  return (
    <tr className="border-b align-top last:border-b-0">
      <td className={TABLE_CELL}>
        <p className="flex items-center gap-2 font-semibold text-vxn-ink">
          {review.authorName} <Stars rating={review.rating} />
        </p>
        {review.comment && <p className="mt-1 line-clamp-3 text-sm leading-5 text-vxn-fg-1">{review.comment}</p>}
        {review.operatorReportReason && <p className="mt-1 text-xs leading-[18px] text-warning-700">Nhà xe báo: {review.operatorReportReason}</p>}
        {review.moderationReason && <p className="mt-1 text-xs leading-[18px] text-muted-foreground">Lý do kiểm duyệt: {review.moderationReason}</p>}
      </td>
      <td className={TABLE_CELL}>
        <p className="truncate font-semibold text-vxn-ink">{review.operatorName}</p>
        <p className="text-xs leading-[18px] text-muted-foreground">
          {shortMoment(review.departureAt)} · {review.routeName}
        </p>
      </td>
      <td className={TABLE_CELL}>
        <div className="flex flex-wrap gap-1.5">
          {review.signals.length === 0 ? <span className="text-muted-foreground">—</span> : review.signals.map((signal) => <Badge key={signal} tone={SIGNAL[signal].tone}>{SIGNAL[signal].label}</Badge>)}
        </div>
      </td>
      <td className={TABLE_CELL}>
        <Badge tone={status.tone}>{status.label}</Badge>
      </td>
      <td className={TABLE_CELL}>
        <div className="flex flex-wrap gap-2">
          {review.status !== "HELD" && (
            <Button variant="outline" size="sm" className="bg-card" onClick={() => onAct("HOLD")}>
              Giữ
            </Button>
          )}
          {review.status !== "HIDDEN" && (
            <Button variant="outline" size="sm" className="bg-card text-error-600" onClick={() => onAct("HIDE")}>
              Ẩn
            </Button>
          )}
          {review.status !== "VISIBLE" && (
            <Button variant="outline" size="sm" className="bg-card" onClick={() => onAct("SHOW")}>
              Hiện
            </Button>
          )}
        </div>
      </td>
    </tr>
  );
}

function ModerationDialog({ review, action, onClose, onDone }: { review: Review; action: Action; onClose: () => void; onDone: (message: string) => void }) {
  const queryClient = useQueryClient();
  const [reason, setReason] = useState("");
  const [error, setError] = useState<string | null>(null);
  const submit = useMutation({
    mutationFn: () => moderateReview(review.reviewId, { action, reason: reason.trim() || null }),
    onSuccess: () => {
      void queryClient.invalidateQueries({ queryKey: ["admin-reviews"] });
      onDone(action === "HIDE" ? "Đã ẩn đánh giá — không còn tính vào điểm nhà xe." : action === "HOLD" ? "Đã giữ chờ đánh giá." : "Đã hiển thị lại đánh giá.");
    },
    onError: (failure) => setError(describeCaseError(failure).message)
  });
  const required = action === "HIDE";
  return (
    <Dialog open onOpenChange={(next) => !next && onClose()}>
      <DialogContent className="sm:max-w-[520px]">
        <DialogHeader>
          <DialogTitle>{ACTION_LABEL[action]}</DialogTitle>
          <DialogDescription>
            {review.authorName} · {review.rating} sao · {review.operatorName}
          </DialogDescription>
        </DialogHeader>
        <form
          className="flex flex-col gap-4"
          onSubmit={(event) => {
            event.preventDefault();
            if ((required || reason.trim().length > 0) && reason.trim().length < 3) {
              setError("Nhập lý do (3–500 ký tự).");
              return;
            }
            submit.mutate();
          }}
        >
          {review.comment && <p className="rounded-lg bg-muted px-4 py-3 text-sm leading-5 text-vxn-fg-1">{review.comment}</p>}
          <FormField label={required ? "Lý do *" : "Lý do"} helper="Lý do được lưu vào nhật ký audit.">
            {(control) => <Textarea {...control} rows={3} maxLength={500} value={reason} disabled={submit.isPending} onChange={(event) => setReason(event.target.value)} />}
          </FormField>
          {error && (
            <p role="alert" className="text-sm leading-5 text-error-600">
              {error}
            </p>
          )}
          <DialogFooter>
            <Button type="button" variant="outline" className={BUTTON} disabled={submit.isPending} onClick={onClose}>
              Hủy
            </Button>
            <Button type="submit" className={BUTTON} variant={action === "HIDE" ? "destructive" : "default"} disabled={submit.isPending}>
              {submit.isPending && <LoaderCircle className="size-[18px] animate-spin" />}
              {ACTION_LABEL[action]}
            </Button>
          </DialogFooter>
        </form>
      </DialogContent>
    </Dialog>
  );
}
