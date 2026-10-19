"use client";

import React, { useState } from "react";
import Link from "next/link";
import { Star, Send, Check, AlertCircle } from "lucide-react";
import { Button } from "@vexenhanh/ui/components/button";
import type {
  UserProfileData,
  UserReviewsData,
  PendingReviewTrip,
  UserReviewItem
} from "../../lib/data/types";
import { submitTripReview } from "../../lib/data/auth";
import { AccountSidebar } from "./account-sidebar";

export interface AccountReviewsViewProps {
  readonly user?: UserProfileData;
  readonly initialData?: UserReviewsData;
  readonly isPreview?: boolean;
}

const ratingLabels: Record<number, string> = {
  1: "Rất tệ",
  2: "Chưa tốt",
  3: "Bình thường",
  4: "Hài lòng",
  5: "Tuyệt vời"
};

/**
 * Màn hình Đánh giá của tôi + form đánh giá chuẩn Figma node 1448:19193
 */
export const AccountReviewsView: React.FC<AccountReviewsViewProps> = ({
  user,
  initialData = {
    pendingTrips: [
      {
        tripId: "tr-pend-01",
        operatorName: "Phương Nam Travel",
        routeName: "TP. Hồ Chí Minh → Nha Trang",
        completedDateText: "Hoàn thành 20/09/2026",
        bookingCode: "VXN-7Q2L5B",
        initialRating: 4,
        initialComment:
          "Xe sạch, tài xế chạy êm. Điểm đón dễ tìm, nhân viên hỗ trợ hành lý nhiệt tình."
      }
    ],
    completedReviews: [
      {
        id: "rev-01",
        operatorName: "Phương Nam Travel",
        routeName: "TP. Hồ Chí Minh → Đà Lạt",
        reviewedDateText: "Đánh giá ngày 05/09/2026",
        rating: 5,
        content: "Khởi hành đúng giờ, giường rộng và có cổng sạc. Sẽ đi lại.",
        statusLabel: "Đang hiển thị"
      },
      {
        id: "rev-02",
        operatorName: "Hoàng Long Coach",
        routeName: "TP. Hồ Chí Minh → Vũng Tàu",
        reviewedDateText: "Đánh giá ngày 18/08/2026",
        rating: 3,
        content: "Xe đến trễ 20 phút so với giờ in trên vé.",
        statusLabel: "Đang kiểm duyệt"
      }
    ]
  },
  isPreview = false
}) => {
  const pendingTrip: PendingReviewTrip | undefined = initialData.pendingTrips[0];
  const [rating, setRating] = useState<number>(pendingTrip?.initialRating ?? 4);
  const [comment, setComment] = useState<string>(pendingTrip?.initialComment ?? "");
  const [completedReviews, setCompletedReviews] = useState<UserReviewItem[]>([
    ...initialData.completedReviews
  ]);
  const [isPendingSubmitted, setIsPendingSubmitted] = useState<boolean>(false);
  const [statusMessage, setStatusMessage] = useState<{
    readonly type: "success" | "error";
    readonly text: string;
  } | null>(null);
  const [isSubmitting, setIsSubmitting] = useState<boolean>(false);

  const handleSubmitReview = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!pendingTrip) return;

    setStatusMessage(null);

    if (isPreview) {
      setIsPendingSubmitted(true);
      setCompletedReviews((prev) => [
        {
          id: `rev-new-${Date.now()}`,
          operatorName: pendingTrip.operatorName,
          routeName: pendingTrip.routeName,
          reviewedDateText: "Vừa đánh giá xong",
          rating,
          content: comment,
          statusLabel: "Đang kiểm duyệt"
        },
        ...prev
      ]);
      setStatusMessage({
        type: "success",
        text: "Cảm ơn bạn đã gửi đánh giá! Đánh giá sẽ được hiển thị sau khi kiểm duyệt."
      });
      setTimeout(() => setStatusMessage(null), 4000);
      return;
    }

    setIsSubmitting(true);
    try {
      const res = await submitTripReview({
        tripId: pendingTrip.tripId,
        rating,
        content: comment
      });
      if (res.status === "unavailable") {
        setStatusMessage({
          type: "error",
          text: "Chức năng gửi đánh giá đang chờ kết nối cổng API backend (POST /me/reviews)."
        });
      } else if (res.status === "error") {
        setStatusMessage({
          type: "error",
          text: res.message ?? "Không thể gửi đánh giá chuyến xe."
        });
      }
    } catch {
      setStatusMessage({
        type: "error",
        text: "Đã xảy ra lỗi khi gửi đánh giá."
      });
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <div className="container mx-auto px-4 sm:px-6 py-6 max-w-7xl space-y-6">
      {/* Breadcrumb điều hướng */}
      <nav className="text-xs text-muted-foreground flex items-center gap-1.5">
        <Link href="/" className="hover:text-foreground">
          Trang chủ
        </Link>
        <span>›</span>
        <Link href={isPreview ? "/account?preview=ideal" : "/account"} className="hover:text-foreground">
          Tài khoản
        </Link>
        <span>›</span>
        <span className="text-foreground font-medium">Đánh giá của tôi</span>
      </nav>

      {/* Thông báo kết quả thao tác */}
      {statusMessage && (
        <div
          className={`p-3.5 rounded-xl text-xs flex items-center gap-2 ${
            statusMessage.type === "success"
              ? "bg-emerald-50 dark:bg-emerald-950/40 border border-emerald-200 text-emerald-800 dark:text-emerald-300"
              : "bg-destructive/10 border border-destructive/20 text-destructive"
          }`}
        >
          {statusMessage.type === "success" ? (
            <Check className="w-4 h-4 shrink-0" />
          ) : (
            <AlertCircle className="w-4 h-4 shrink-0" />
          )}
          <span>{statusMessage.text}</span>
        </div>
      )}

      {/* Bố cục 2 cột */}
      <div className="flex flex-col lg:flex-row gap-6 items-start">
        {/* Cột trái: Sidebar tài khoản */}
        <AccountSidebar activeTab="reviews" user={user} isPreview={isPreview} />

        {/* Cột phải: Nội dung Đánh giá của tôi */}
        <div className="flex-1 w-full space-y-6">
          {/* Đầu trang tiêu đề */}
          <div className="space-y-1">
            <h1 className="text-2xl font-bold tracking-tight text-foreground">
              Đánh giá của tôi
            </h1>
            <p className="text-xs text-muted-foreground">
              Bạn chỉ đánh giá được chuyến đã hoàn thành với vé hợp lệ.
            </p>
          </div>

          {/* Khối 1: Chờ đánh giá (chuẩn Figma node 1448:19507) */}
          {!isPendingSubmitted && pendingTrip && (
            <div className="bg-white dark:bg-card rounded-2xl border border-border p-6 space-y-5 shadow-2xs">
              <h2 className="text-base font-bold text-foreground">
                Chờ đánh giá (1)
              </h2>

              {/* Thẻ tóm tắt chuyến đi chờ đánh giá */}
              <div className="bg-slate-50 dark:bg-muted/40 rounded-xl p-4 flex flex-col sm:flex-row sm:items-center justify-between gap-3">
                <div className="flex items-center gap-3">
                  <div className="w-10 h-10 rounded-xl bg-[#0F5B60] text-white font-bold text-xs flex items-center justify-center shrink-0">
                    PN
                  </div>
                  <div className="space-y-0.5">
                    <p className="text-sm font-bold text-foreground">
                      {pendingTrip.routeName}
                    </p>
                    <p className="text-xs text-muted-foreground">
                      {pendingTrip.operatorName} · {pendingTrip.completedDateText} · Đơn {pendingTrip.bookingCode}
                    </p>
                  </div>
                </div>

                <span className="self-start sm:self-auto px-2.5 py-1 rounded-md bg-emerald-50 dark:bg-emerald-950/40 text-emerald-700 dark:text-emerald-400 font-medium text-xs border border-emerald-200/50">
                  Đã hoàn thành
                </span>
              </div>

              {/* Form chấm sao & viết nhận xét */}
              <form onSubmit={handleSubmitReview} className="space-y-4">
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
                    Nhận xét của bạn
                  </label>
                  <textarea
                    rows={3}
                    value={comment}
                    onChange={(e) => setComment(e.target.value)}
                    placeholder="Chia sẻ trải nghiệm của bạn về tài xế, chất lượng xe, điểm đón trả..."
                    className="w-full p-3.5 rounded-xl border border-input bg-background text-sm text-foreground placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-[#0F5B60] transition-all resize-y"
                  />
                  <p className="text-[11px] text-muted-foreground">
                    Nhận xét được kiểm duyệt trước khi hiển thị công khai.
                  </p>
                </div>

                {/* Nút thao tác form */}
                <div className="flex items-center justify-end gap-3 pt-2">
                  <Button
                    type="button"
                    variant="outline"
                    onClick={() => {
                      setStatusMessage({
                        type: "success",
                        text: "Đã lưu tạm đánh giá để thực hiện sau."
                      });
                      setTimeout(() => setStatusMessage(null), 3000);
                    }}
                    className="h-10 px-4 rounded-xl text-xs border-border bg-white dark:bg-card"
                  >
                    Để sau
                  </Button>

                  <Button
                    type="submit"
                    disabled={isSubmitting || !comment.trim()}
                    className="h-10 px-5 rounded-xl text-xs gap-1.5 bg-[#0F5B60] hover:bg-[#0c474b] text-white font-medium"
                  >
                    <Send className="w-3.5 h-3.5" />
                    <span>{isSubmitting ? "Đang gửi..." : "Gửi đánh giá"}</span>
                  </Button>
                </div>
              </form>
            </div>
          )}

          {/* Khối 2: Đã đánh giá (chuẩn Figma node 1448:19559) */}
          <div className="bg-white dark:bg-card rounded-2xl border border-border p-6 space-y-4 shadow-2xs">
            <h2 className="text-base font-bold text-foreground">
              Đã đánh giá ({completedReviews.length})
            </h2>

            <div className="divide-y divide-border">
              {completedReviews.map((review) => {
                const isApproved = review.statusLabel === "Đang hiển thị" || review.statusLabel === "Đã duyệt";
                return (
                  <div key={review.id} className="py-4 space-y-2 first:pt-1 last:pb-1">
                    <div className="flex items-center justify-between gap-3">
                      <div className="flex items-center gap-3">
                        <div className="w-9 h-9 rounded-xl bg-[#0F5B60] text-white font-bold text-xs flex items-center justify-center shrink-0">
                          PN
                        </div>
                        <div className="space-y-0.5">
                          <p className="text-xs font-bold text-foreground">
                            {review.routeName}
                          </p>
                          <p className="text-[11px] text-muted-foreground">
                            {review.operatorName} · {review.reviewedDateText}
                          </p>
                        </div>
                      </div>

                      <div className="flex items-center gap-3 shrink-0">
                        <span
                          className={`px-2 py-0.5 rounded-md font-medium text-[11px] border ${
                            isApproved
                              ? "bg-emerald-50 dark:bg-emerald-950/40 text-emerald-700 dark:text-emerald-400 border-emerald-200/50"
                              : "bg-amber-50 dark:bg-amber-950/40 text-amber-700 dark:text-amber-400 border-amber-200/50"
                          }`}
                        >
                          {review.statusLabel}
                        </span>
                        <button
                          type="button"
                          onClick={() => {
                            setStatusMessage({
                              type: "success",
                              text: `Mở chế độ chỉnh sửa đánh giá cho ${review.routeName}.`
                            });
                            setTimeout(() => setStatusMessage(null), 3000);
                          }}
                          className="text-xs font-medium text-[#0F5B60] hover:underline"
                        >
                          Sửa
                        </button>
                      </div>
                    </div>

                    {/* Hàng sao đánh giá */}
                    <div className="flex items-center gap-0.5 pl-12">
                      {[1, 2, 3, 4, 5].map((s) => (
                        <Star
                          key={s}
                          className={`w-4 h-4 ${
                            s <= review.rating
                              ? "fill-amber-400 text-amber-400"
                              : "text-slate-300 dark:text-slate-600"
                          }`}
                        />
                      ))}
                    </div>

                    {/* Nội dung nhận xét */}
                    <p className="text-xs text-foreground leading-relaxed pl-12">
                      {review.content}
                    </p>
                  </div>
                );
              })}
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};
