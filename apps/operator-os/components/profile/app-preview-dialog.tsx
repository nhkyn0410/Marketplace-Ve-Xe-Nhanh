"use client";

import { useQuery } from "@tanstack/react-query";
import { Button } from "@vexenhanh/ui/components/button";
import { Dialog, DialogContent, DialogDescription, DialogHeader, DialogTitle } from "@vexenhanh/ui/components/dialog";
import { Skeleton } from "@vexenhanh/ui/components/skeleton";
import { ArrowLeft, CircleAlert, Mail, MapPin, Phone, RefreshCw, Star } from "lucide-react";
import type { ReactNode } from "react";

import { ApiError } from "../../lib/auth/api-client";
import { getPublicProfile, type PublicOperatorProfile } from "../../lib/profile/profile-api";
import { formatDate } from "../../lib/profile/profile-format";
import { previewMetrics } from "../../lib/profile/public-page";
import { OperatorLogo } from "./operator-logo";

/** Khóa query hồ sơ công khai — màn Hồ sơ làm mới sau khi đổi thông tin / logo. */
export const PUBLIC_PROFILE_QUERY_KEY = "operator-public-profile";

const SECTION = "flex flex-col gap-2.5 rounded-2xl border bg-white p-4";
const SECTION_TITLE = "text-sm font-semibold text-vxn-ink";
const MUTED = "text-xs leading-5 text-muted-foreground";

/**
 * "Xem trước trên ứng dụng" của màn Hồ sơ & KYC (TASK-MKT-001; tự thiết kế 27/10/2026, chờ duyệt — chưa có khung Figma):
 * mô phỏng màn nhà xe của app hành khách trong khung điện thoại, bằng đúng dữ liệu API công khai trả cho hành khách.
 * App hành khách chưa có màn này nên các khối bám theo trang nhà xe trên web (SCR-PSG-17).
 */
export function AppPreviewDialog({ operatorId, open, onClose }: { operatorId: string; open: boolean; onClose: () => void }) {
  const preview = useQuery({
    queryKey: [PUBLIC_PROFILE_QUERY_KEY, operatorId],
    queryFn: () => getPublicProfile(operatorId),
    enabled: open
  });
  return (
    <Dialog open={open} onOpenChange={(next) => !next && onClose()}>
      <DialogContent className="sm:max-w-[440px]">
        <DialogHeader>
          <DialogTitle>Xem trước trên ứng dụng</DialogTitle>
          <DialogDescription>Hành khách thấy nhà xe như bên dưới trong ứng dụng Vé Xe Nhanh, theo dữ liệu đang công khai.</DialogDescription>
        </DialogHeader>
        <div className="mx-auto w-full max-w-[340px] rounded-[44px] bg-vxn-ink p-3 shadow-lg">
          <div
            role="region"
            aria-label="Màn hình ứng dụng"
            className="flex h-[600px] max-h-[calc(var(--vxn-vh)_-_18rem)] min-h-[360px] flex-col overflow-hidden rounded-[34px] bg-[#f9f9ff]"
          >
            <div aria-hidden className="flex h-9 shrink-0 items-center justify-between px-6 text-[11px] font-semibold text-vxn-ink">
              <span>9:41</span>
              <span className="h-[18px] w-20 rounded-full bg-vxn-ink" />
              <span>5G</span>
            </div>
            {preview.data ? (
              <PreviewScreen profile={preview.data} />
            ) : preview.isError ? (
              <PreviewError error={preview.error} onRetry={() => void preview.refetch()} />
            ) : (
              <div aria-label="Đang tải bản xem trước" className="flex flex-col gap-3 p-4">
                <Skeleton className="h-40 rounded-2xl" />
                <Skeleton className="h-28 rounded-2xl" />
                <Skeleton className="h-24 rounded-2xl" />
              </div>
            )}
          </div>
        </div>
        <p className={`${MUTED} text-center`}>Mô phỏng theo dữ liệu công khai hiện tại; bố cục trên ứng dụng thật có thể khác đôi chút.</p>
      </DialogContent>
    </Dialog>
  );
}

function ContactRow({ icon, children }: { icon: ReactNode; children: ReactNode }) {
  return (
    <li className="flex items-start gap-2">
      <span className="mt-0.5 text-neutral-400">{icon}</span>
      <span className="min-w-0 break-words">{children}</span>
    </li>
  );
}

function PreviewScreen({ profile }: { profile: PublicOperatorProfile }) {
  const { averageRating, reviewCount } = profile.scorecard;
  return (
    <div className="flex min-h-0 flex-1 flex-col">
      <div className="flex h-12 shrink-0 items-center gap-2 border-b bg-white px-4 text-vxn-ink">
        <ArrowLeft aria-hidden className="size-5" />
        <span className="text-[15px] font-semibold">Thông tin nhà xe</span>
      </div>
      <div className="flex min-h-0 flex-1 flex-col gap-3 overflow-y-auto p-4">
        <section aria-label="Nhà xe" className={SECTION}>
          <div className="flex items-center gap-3">
            <OperatorLogo name={profile.displayName} logoUrl={profile.logoUrl} className="size-14 rounded-2xl text-lg" />
            <div className="flex min-w-0 flex-col gap-0.5">
              <p className="text-base leading-6 font-semibold break-words text-vxn-ink">{profile.displayName}</p>
              <p className="flex items-center gap-1 text-xs text-muted-foreground">
                <Star aria-hidden className="size-3.5 fill-[#f3a826] text-[#f3a826]" />
                {averageRating === null ? "Chưa có đánh giá" : `${averageRating.toFixed(1)} · ${reviewCount} đánh giá`}
              </p>
            </div>
          </div>
          {profile.description && <p className="text-xs leading-5 whitespace-pre-line text-neutral-600">{profile.description}</p>}
          <ul className="flex flex-col gap-1.5 text-xs leading-5 text-neutral-600">
            {profile.hotline && <ContactRow icon={<Phone className="size-3.5" />}>{profile.hotline}</ContactRow>}
            {profile.publicEmail && <ContactRow icon={<Mail className="size-3.5" />}>{profile.publicEmail}</ContactRow>}
            {profile.address && <ContactRow icon={<MapPin className="size-3.5" />}>{profile.address}</ContactRow>}
          </ul>
          <span className="flex h-10 items-center justify-center rounded-xl bg-vxn-teal-700 text-sm font-bold text-white">
            Tìm chuyến của nhà xe
          </span>
        </section>

        <section aria-label="Chỉ số chất lượng" className={SECTION}>
          <h3 className={SECTION_TITLE}>Chỉ số chất lượng</h3>
          <dl className="grid grid-cols-2 gap-2">
            {previewMetrics(profile.scorecard).map((metric) => (
              <div key={metric.label} className="flex flex-col gap-1 rounded-xl bg-[#f9f9ff] p-3">
                <dt className="text-[11px] leading-4 text-muted-foreground">{metric.label}</dt>
                <dd className="text-sm font-bold break-words text-vxn-ink">{metric.value}</dd>
                {metric.note && <dd className="text-[11px] text-muted-foreground">{metric.note}</dd>}
              </div>
            ))}
          </dl>
        </section>

        <section aria-label="Tuyến tiêu biểu" className={SECTION}>
          <h3 className={SECTION_TITLE}>Tuyến tiêu biểu</h3>
          {profile.routes.length > 0 ? (
            <ul className="flex flex-col gap-1.5">
              {profile.routes.map((route) => (
                <li key={route.routeId} className="rounded-lg bg-vxn-teal-50 px-3 py-2 text-xs font-medium text-vxn-teal-800">
                  {route.name}
                </li>
              ))}
            </ul>
          ) : (
            <p className={MUTED}>Chưa có tuyến đang mở bán.</p>
          )}
        </section>

        <section aria-label="Đánh giá từ hành khách" className={SECTION}>
          <h3 className={SECTION_TITLE}>Đánh giá từ hành khách</h3>
          {profile.reviews.length > 0 ? (
            <ul className="flex flex-col gap-3">
              {profile.reviews.map((review) => (
                <li key={review.reviewId} className="flex flex-col gap-1 border-b pb-3 last:border-b-0 last:pb-0">
                  <div className="flex items-center justify-between gap-2 text-xs">
                    <span className="truncate font-semibold text-vxn-ink">{review.authorName}</span>
                    <span className="shrink-0 text-muted-foreground">{formatDate(review.createdAt)}</span>
                  </div>
                  <span aria-label={`${review.rating} trên 5 sao`} className="flex gap-0.5">
                    {Array.from({ length: 5 }, (_, index) => (
                      <Star
                        key={index}
                        aria-hidden
                        className={`size-3 ${index < review.rating ? "fill-[#f3a826] text-[#f3a826]" : "text-neutral-300"}`}
                      />
                    ))}
                  </span>
                  {review.comment && <p className="text-xs leading-5 text-neutral-600">{review.comment}</p>}
                </li>
              ))}
            </ul>
          ) : (
            <p className={MUTED}>Chưa có đánh giá.</p>
          )}
        </section>

        {profile.serviceTerms && (
          <section aria-label="Điều khoản dịch vụ" className={SECTION}>
            <h3 className={SECTION_TITLE}>Điều khoản dịch vụ</h3>
            <p className="line-clamp-6 text-xs leading-5 whitespace-pre-line text-neutral-600">{profile.serviceTerms.contentMarkdown}</p>
          </section>
        )}
      </div>
    </div>
  );
}

function PreviewError({ error, onRetry }: { error: unknown; onRetry: () => void }) {
  const hidden = error instanceof ApiError && error.status === 404;
  return (
    <div role="alert" className="flex flex-1 flex-col items-center justify-center gap-3 p-6 text-center">
      <CircleAlert className="size-6 text-warning-700" />
      <p className="text-sm font-semibold text-vxn-ink">{hidden ? "Trang nhà xe đang ẩn" : "Không tải được bản xem trước"}</p>
      <p className={MUTED}>
        {hidden
          ? "Nhà xe đang tạm khóa nên hành khách không xem được trang này."
          : "Kiểm tra kết nối mạng rồi thử lại."}
      </p>
      {!hidden && (
        <Button type="button" variant="outline" className="h-9 bg-card px-3 font-semibold" onClick={onRetry}>
          <RefreshCw className="size-4" />
          Thử lại
        </Button>
      )}
    </div>
  );
}
