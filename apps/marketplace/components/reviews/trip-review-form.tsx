"use client";

import React, { useState } from "react";
import { Send, Star } from "lucide-react";
import { Button } from "@vexenhanh/ui/components/button";

const ratingLabels: Record<number, string> = {
  1: "Rất tệ",
  2: "Chưa tốt",
  3: "Bình thường",
  4: "Hài lòng",
  5: "Tuyệt vời"
};

export interface TripReviewFormProps {
  readonly initialRating?: number;
  readonly initialComment?: string;
  readonly submitting: boolean;
  readonly onSubmit: (rating: number, comment: string) => void;
  /** Thao tác phụ đặt trước nút gửi (vd link quay lại). */
  readonly secondaryAction?: React.ReactNode;
}

/**
 * Form chấm sao + nhận xét chuyến đi (Figma 1448:19193). Dùng ở "Đánh giá của tôi" và khối đánh giá dưới thẻ vé
 * (PASSENGER-PARITY Q20). Đổi chuyến cần đánh giá thì đổi `key` để form nhận lại giá trị ban đầu.
 */
export function TripReviewForm({
  initialRating = 4,
  initialComment = "",
  submitting,
  onSubmit,
  secondaryAction
}: TripReviewFormProps) {
  const [rating, setRating] = useState<number>(initialRating);
  const [comment, setComment] = useState<string>(initialComment);

  return (
    <form
      onSubmit={(event) => {
        event.preventDefault();
        onSubmit(rating, comment);
      }}
      className="space-y-4"
    >
      {/* Chọn sao */}
      <div className="space-y-1.5">
        <label className="text-xs font-semibold text-foreground">
          Bạn chấm chuyến đi mấy sao? *
        </label>
        <div className="flex items-center gap-2">
          <div className="flex items-center gap-1">
            {[1, 2, 3, 4, 5].map((starVal) => (
              <button
                key={starVal}
                type="button"
                aria-label={`${starVal} sao`}
                aria-pressed={starVal === rating}
                disabled={submitting}
                onClick={() => setRating(starVal)}
                className="p-1 text-amber-400 hover:scale-110 transition-transform"
              >
                <Star
                  className={`w-6 h-6 ${
                    starVal <= rating
                      ? "fill-amber-400 text-amber-400"
                      : "text-slate-300 dark:text-slate-600"
                  }`}
                />
              </button>
            ))}
          </div>
          <span className="text-xs font-medium text-muted-foreground pl-1">
            {ratingLabels[rating]}
          </span>
        </div>
      </div>

      {/* Nhận xét text */}
      <div className="space-y-1.5">
        <label className="text-xs font-semibold text-foreground">
          Nhận xét của bạn (không bắt buộc)
        </label>
        <textarea
          maxLength={1000}
          rows={3}
          value={comment}
          onChange={(e) => setComment(e.target.value)}
          placeholder="Chia sẻ trải nghiệm của bạn về tài xế, chất lượng xe, điểm đón trả..."
          className="w-full p-3.5 rounded-xl border border-input bg-background text-sm text-foreground placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-[#0F5B60] transition-all resize-y"
        />
        <p className="text-[11px] text-muted-foreground">
          Tối đa 1.000 ký tự. Trạng thái hiển thị được cập nhật sau khi gửi.
        </p>
      </div>

      {/* Nút thao tác form */}
      <div className="flex items-center justify-end gap-3 pt-2">
        {secondaryAction}

        <Button
          type="submit"
          disabled={submitting}
          className="h-10 px-5 rounded-xl text-xs gap-1.5 bg-[#0F5B60] hover:bg-[#0c474b] text-white font-medium"
        >
          <Send className="w-3.5 h-3.5" />
          <span>{submitting ? "Đang gửi..." : "Gửi đánh giá"}</span>
        </Button>
      </div>
    </form>
  );
}
