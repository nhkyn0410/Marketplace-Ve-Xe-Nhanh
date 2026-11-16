"use client";

import React, { useState } from "react";
import { AlertCircle, Star } from "lucide-react";
import { submitTripReview } from "../../lib/data/auth";
import type { TicketReviewState } from "../../lib/data/types";
import { TripReviewForm } from "../reviews/trip-review-form";

const MODERATION_NOTES: Partial<Record<"VISIBLE" | "HELD" | "HIDDEN", string>> = {
  HELD: "Đánh giá đang chờ duyệt",
  HIDDEN: "Đánh giá hiện không được hiển thị"
};

export interface TicketReviewBlockProps {
  readonly bookingId: string;
  readonly initial: TicketReviewState;
}

/**
 * Khối đánh giá dưới thẻ vé (SCR-PSG-25 Partial/Edge, PASSENGER-PARITY Q20 — như app): chuyến đủ điều kiện thì mời đánh giá
 * bằng form của "Đánh giá của tôi", đã gửi thì hiện lại sao + nhận xét. Không đủ điều kiện thì không chiếm chỗ.
 */
export function TicketReviewBlock({ bookingId, initial }: TicketReviewBlockProps) {
  const [state, setState] = useState<TicketReviewState>(initial);
  const [submitting, setSubmitting] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const { review, canReview } = state;
  if (!review && !canReview) return null;

  const submit = async (rating: number, comment: string) => {
    setSubmitting(true);
    setError(null);
    try {
      const result = await submitTripReview({ bookingId, tripId: "", rating, content: comment });
      if (result.status === "ok") {
        const status = result.data.status === "HELD" || result.data.status === "HIDDEN" ? result.data.status : "VISIBLE";
        setState({ review: { rating, comment: comment.trim(), status }, canReview: false });
      } else {
        setError(result.status === "error" && result.message ? result.message : "Chưa thể gửi đánh giá. Vui lòng thử lại sau.");
      }
    } catch {
      setError("Đã xảy ra lỗi khi gửi đánh giá.");
    } finally {
      setSubmitting(false);
    }
  };

  const moderationNote = review ? MODERATION_NOTES[review.status] : undefined;
  return (
    <section data-testid="ticket-review-block" className="rounded-2xl border border-border/80 bg-card p-5 shadow-xs sm:p-6 space-y-4">
      {review ? (
        <>
          <h2 className="text-base font-bold text-foreground">Đánh giá của bạn</h2>
          <div className="flex items-center gap-0.5" aria-label={`${review.rating} trên 5 sao`}>
            {[1, 2, 3, 4, 5].map((star) => (
              <Star
                key={star}
                className={`h-4 w-4 ${star <= review.rating ? "fill-amber-400 text-amber-400" : "text-slate-300 dark:text-slate-600"}`}
              />
            ))}
          </div>
          {review.comment && <p className="text-sm leading-relaxed text-foreground">{review.comment}</p>}
          {moderationNote && <p className="text-xs text-muted-foreground">{moderationNote}</p>}
        </>
      ) : (
        <>
          <div className="space-y-1">
            <h2 className="text-base font-bold text-foreground">Chuyến đi đã hoàn thành</h2>
            <p className="text-xs text-muted-foreground">Đánh giá của bạn giúp nhà xe phục vụ tốt hơn.</p>
          </div>
          {error && (
            <p role="alert" className="flex items-center gap-2 rounded-xl border border-destructive/20 bg-destructive/10 p-3 text-xs text-destructive">
              <AlertCircle className="h-4 w-4 shrink-0" />
              <span>{error}</span>
            </p>
          )}
          <TripReviewForm submitting={submitting} onSubmit={(rating, comment) => void submit(rating, comment)} />
        </>
      )}
    </section>
  );
}
