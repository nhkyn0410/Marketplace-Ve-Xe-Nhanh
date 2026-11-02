"use client";

import { useInfiniteQuery, useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { Badge } from "@vexenhanh/ui/components/badge";
import { Button } from "@vexenhanh/ui/components/button";
import { Textarea } from "@vexenhanh/ui/components/textarea";
import { CircleAlert, Flag, Info, LoaderCircle, MessageSquare, RefreshCw, Star } from "lucide-react";
import { useState } from "react";

import { listAllRoutes } from "../../lib/route/route-api";
import { listReviews, replyReview, reportReview, type Review } from "../../lib/support/support-api";
import { dayOf, shortMoment } from "../../lib/support/support-format";
import { BUTTON, ListLoadMoreFooter, ListStatePanel } from "../list-parts";
import { ALL, FilterSelect, TableSkeleton } from "../stop-point/list-controls";

const COUNT = new Intl.NumberFormat("vi-VN");
const SCORE = new Intl.NumberFormat("vi-VN", { minimumFractionDigits: 1, maximumFractionDigits: 1 });

/**
 * Đánh giá của hành khách (Figma "Nhà xe · Hỗ trợ / Đánh giá"; TASK-TRUST-001, FR-NSR-10/11): lọc tuyến / số sao / đã phản hồi, điểm
 * trung bình đánh giá hợp lệ; nhà xe viết / sửa phản hồi hoặc báo vi phạm — không sửa / xóa được đánh giá.
 */
export function ReviewPanel() {
  const [routeId, setRouteId] = useState(ALL);
  const [rating, setRating] = useState(ALL);
  const [replied, setReplied] = useState(ALL);
  const routes = useQuery({ queryKey: ["routes", "all"], queryFn: () => listAllRoutes() });
  const reviews = useInfiniteQuery({
    queryKey: ["operator-reviews", routeId, rating, replied],
    queryFn: ({ pageParam }) =>
      listReviews({
        routeId: routeId === ALL ? undefined : routeId,
        rating: rating === ALL ? undefined : Number(rating),
        replied: replied === ALL ? undefined : (replied as "yes" | "no"),
        cursor: pageParam ?? undefined
      }),
    initialPageParam: null as string | null,
    getNextPageParam: (page) => page.nextCursor
  });
  const first = reviews.data?.pages[0];
  const items = reviews.data?.pages.flatMap((page) => page.items) ?? [];

  let body;
  if (reviews.isPending) {
    body = <TableSkeleton label="Đang tải đánh giá" rows={4} />;
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
        compact
      />
    );
  } else if (items.length === 0) {
    body = <ListStatePanel icon={<Star className="size-6 text-vxn-fg-3" />} title="Chưa có đánh giá" description="Đánh giá từ hành khách có vé hợp lệ trên chuyến đã hoàn thành hiện ở đây." compact />;
  } else {
    body = (
      <ul className="flex flex-col divide-y">
        {items.map((review) => (
          <ReviewItem key={review.reviewId} review={review} />
        ))}
      </ul>
    );
  }

  return (
    <>
      <section aria-label="Đánh giá" className="flex flex-col rounded-xl border bg-card p-6">
        <div className="flex flex-wrap items-end justify-between gap-4 pb-5">
          <div className="flex flex-wrap items-end gap-x-4 gap-y-3">
            <FilterSelect label="Tuyến" allLabel="Tất cả tuyến" value={routeId} onChange={setRouteId} options={(routes.data ?? []).map((route) => ({ value: route.id, label: route.name }))} />
            <FilterSelect label="Số sao" allLabel="Tất cả" value={rating} onChange={setRating} options={[5, 4, 3, 2, 1].map((value) => ({ value: String(value), label: `${value} sao` }))} className="w-40" />
            <FilterSelect
              label="Phản hồi"
              allLabel="Tất cả"
              value={replied}
              onChange={setReplied}
              options={[
                { value: "no", label: "Chưa phản hồi" },
                { value: "yes", label: "Đã phản hồi" }
              ]}
              className="w-40"
            />
          </div>
          {first && (
            <p className="flex items-baseline gap-2">
              <span className="text-[28px] leading-9 font-semibold text-vxn-ink">{first.average === null ? "—" : SCORE.format(first.average)}</span>
              <span className="text-sm leading-5 text-muted-foreground">{COUNT.format(first.validCount)} đánh giá hợp lệ</span>
            </p>
          )}
        </div>
        {body}
        {items.length > 0 && (
          <div className="flex pt-5">
            <ListLoadMoreFooter
              hasMore={reviews.hasNextPage}
              loading={reviews.isFetchingNextPage}
              failed={reviews.isFetchNextPageError}
              loadedText={`Đã tải ${items.length} / ${COUNT.format(first?.total ?? 0)} đánh giá`}
              endText={`Đã hiển thị tất cả ${COUNT.format(items.length)} đánh giá`}
              errorText="Chưa tải thêm được đánh giá."
              onLoadMore={() => void reviews.fetchNextPage()}
            />
          </div>
        )}
      </section>
      <div role="note" className="flex items-center gap-3 rounded-lg bg-accent px-5 py-4 text-sm leading-5 text-vxn-teal-700">
        <Info className="size-[18px] shrink-0" aria-hidden />
        Đánh giá chỉ đến từ hành khách có vé hợp lệ trên chuyến đã hoàn thành. Nhà xe không sửa hoặc xóa được đánh giá; nội dung vi phạm do Vé Xe Nhanh kiểm duyệt.
      </div>
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

function ReviewItem({ review }: { review: Review }) {
  const queryClient = useQueryClient();
  const [mode, setMode] = useState<"reply" | "report" | null>(null);
  const [text, setText] = useState("");
  const [error, setError] = useState<string | null>(null);
  const submit = useMutation({
    mutationFn: () => (mode === "report" ? reportReview(review.reviewId, text.trim()) : replyReview(review.reviewId, text.trim())),
    onSuccess: () => {
      void queryClient.invalidateQueries({ queryKey: ["operator-reviews"] });
      setMode(null);
      setText("");
      setError(null);
    },
    onError: () => setError(mode === "report" ? "Chưa gửi được báo cáo. Vui lòng thử lại." : "Chưa lưu được phản hồi. Vui lòng thử lại.")
  });
  const start = (next: "reply" | "report") => {
    setMode(next);
    setText(next === "reply" ? (review.operatorReply ?? "") : "");
    setError(null);
  };
  return (
    <li className="flex flex-col gap-3 py-4">
      <div className="flex flex-wrap items-start justify-between gap-3">
        <div className="flex flex-col gap-0.5">
          <p className="flex items-center gap-2 text-sm leading-5 font-semibold text-vxn-ink">
            {review.authorName} <Stars rating={review.rating} />
          </p>
          <p className="text-xs leading-[18px] text-muted-foreground">
            {review.routeName} · chuyến {shortMoment(review.departureAt)}
          </p>
        </div>
        <div className="flex flex-wrap gap-2">
          {review.status === "HELD" && <Badge tone="warning">Đang giữ chờ</Badge>}
          {review.operatorReportedAt && <Badge tone="warning">Đã báo vi phạm</Badge>}
          <Badge tone={review.operatorReply ? "success" : "neutral"}>{review.operatorReply ? "Đã phản hồi" : "Chưa phản hồi"}</Badge>
        </div>
      </div>
      {review.comment && <p className="text-sm leading-5 text-vxn-fg-1">{review.comment}</p>}
      {review.operatorReply && mode !== "reply" && (
        <div className="rounded-lg bg-muted px-4 py-3">
          <p className="text-xs leading-[18px] text-muted-foreground">Phản hồi của nhà xe{review.operatorRepliedAt ? ` · ${dayOf(review.operatorRepliedAt)}` : ""}</p>
          <p className="text-sm leading-5 text-vxn-fg-1">{review.operatorReply}</p>
        </div>
      )}
      {mode ? (
        <form
          className="flex flex-col gap-2"
          onSubmit={(event) => {
            event.preventDefault();
            if (text.trim().length < (mode === "report" ? 3 : 1)) {
              setError(mode === "report" ? "Nhập lý do (3–500 ký tự)." : "Nhập nội dung phản hồi.");
              return;
            }
            submit.mutate();
          }}
        >
          <Textarea
            aria-label={mode === "report" ? "Lý do báo vi phạm" : "Phản hồi đánh giá"}
            rows={2}
            maxLength={mode === "report" ? 500 : 1000}
            value={text}
            disabled={submit.isPending}
            placeholder={mode === "report" ? "Vì sao đánh giá này vi phạm (quảng cáo, sai sự thật…)?" : "Phản hồi công khai cho hành khách…"}
            onChange={(event) => setText(event.target.value)}
          />
          {error && (
            <p role="alert" className="text-sm leading-5 text-error-600">
              {error}
            </p>
          )}
          <div className="flex gap-2">
            <Button type="submit" className={BUTTON} disabled={submit.isPending}>
              {submit.isPending && <LoaderCircle className="size-[18px] animate-spin" />}
              {mode === "report" ? "Gửi báo cáo" : "Lưu phản hồi"}
            </Button>
            <Button type="button" variant="outline" className={`${BUTTON} bg-card`} disabled={submit.isPending} onClick={() => setMode(null)}>
              Hủy
            </Button>
          </div>
        </form>
      ) : (
        <div className="flex flex-wrap gap-2">
          <Button variant="outline" className={`${BUTTON} bg-card`} onClick={() => start("reply")}>
            <MessageSquare className="size-[18px]" />
            {review.operatorReply ? "Sửa phản hồi" : "Viết phản hồi"}
          </Button>
          {!review.operatorReportedAt && (
            <Button variant="outline" className={`${BUTTON} bg-card`} onClick={() => start("report")}>
              <Flag className="size-[18px]" />
              Báo vi phạm
            </Button>
          )}
        </div>
      )}
    </li>
  );
}
