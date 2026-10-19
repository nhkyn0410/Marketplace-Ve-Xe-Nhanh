"use client";

import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { Badge } from "@vexenhanh/ui/components/badge";
import { Button } from "@vexenhanh/ui/components/button";
import { BUTTON } from "@vexenhanh/ui/components/list-parts";
import { emptyPromotion, PromotionForm, type PromotionFormValues } from "@vexenhanh/ui/components/promotion-form";
import { Skeleton } from "@vexenhanh/ui/components/skeleton";
import { ApiError } from "@vexenhanh/ui/lib/auth/api-client";
import { discountLabel, minOrderLabel, PROMOTION_DISPLAY, usageLabel, windowLabel } from "@vexenhanh/ui/lib/promotion-format";
import { ArrowLeft, Info, TicketPercent } from "lucide-react";
import Link from "next/link";
import { useRouter } from "next/navigation";
import { useState } from "react";

import { createPromotion, describePromotionError, getPromotion, setPromotionStatus, updatePromotion, type Promotion } from "../../lib/promotion/promotion-api";

/**
 * Tạo / sửa khuyến mãi nền tảng (Figma ADM-11a "Tạo khuyến mãi"; TASK-PROM-001): lưu nháp hoặc kích hoạt; khuyến mãi đã có đơn dùng mã
 * hoặc đã kết thúc chỉ xem + đổi trạng thái (BR-47).
 */
export function PromotionEditor({ promotionId }: { promotionId?: string }) {
  const promotion = useQuery({
    queryKey: ["admin-promotion", promotionId],
    queryFn: () => getPromotion(promotionId!),
    enabled: Boolean(promotionId),
    retry: (count, error) => !(error instanceof ApiError && error.status === 404) && count < 2
  });
  return (
    <div className="flex flex-col gap-6">
      <Link href="/promotions" className="flex w-fit items-center gap-1.5 text-sm leading-5 font-medium text-primary hover:underline">
        <ArrowLeft className="size-[18px]" />
        Quay lại danh sách khuyến mãi
      </Link>
      {!promotionId ? (
        <EditorBody promotion={null} />
      ) : promotion.data ? (
        <EditorBody key={promotion.data.promotionId} promotion={promotion.data} />
      ) : promotion.isError ? (
        <p role="alert" className="rounded-xl border bg-card px-6 py-10 text-center text-sm text-muted-foreground">
          {promotion.error instanceof ApiError && promotion.error.status === 404 ? "Không tìm thấy khuyến mãi." : "Không tải được khuyến mãi. Tải lại trang."}
        </p>
      ) : (
        <Skeleton role="status" aria-label="Đang tải khuyến mãi" className="h-[520px] rounded-xl" />
      )}
    </div>
  );
}

function toValues(promotion: Promotion): PromotionFormValues {
  return {
    code: promotion.code,
    name: promotion.name,
    discountType: promotion.discountType,
    discountValue: promotion.discountValue,
    maxDiscount: promotion.maxDiscount,
    minOrder: promotion.minOrder,
    routeId: null,
    tripId: null,
    startsAt: promotion.startsAt,
    endsAt: promotion.endsAt,
    usageLimit: promotion.usageLimit
  };
}

function EditorBody({ promotion }: { promotion: Promotion | null }) {
  const router = useRouter();
  const queryClient = useQueryClient();
  const [error, setError] = useState<string | null>(null);
  const [notice, setNotice] = useState<string | null>(null);
  const done = (next: Promotion) => {
    queryClient.setQueryData(["admin-promotion", next.promotionId], next);
    void queryClient.invalidateQueries({ queryKey: ["admin-promotions"] });
  };
  const save = useMutation({
    mutationFn: async ({ values, activate }: { values: PromotionFormValues; activate: boolean }) => {
      const saved = promotion ? await updatePromotion(promotion.promotionId, values) : await createPromotion(values);
      return activate ? setPromotionStatus(saved.promotionId, "ACTIVE") : saved;
    },
    onSuccess: (next) => {
      done(next);
      setError(null);
      if (!promotion) {
        router.replace(`/promotions/${next.promotionId}`);
      } else {
        setNotice(next.status === "ACTIVE" ? "Đã lưu và kích hoạt khuyến mãi." : "Đã lưu khuyến mãi.");
      }
    },
    onError: (failure) => setError(describePromotionError(failure))
  });
  const status = useMutation({
    mutationFn: (next: "ACTIVE" | "PAUSED" | "ENDED") => setPromotionStatus(promotion!.promotionId, next),
    onSuccess: (next) => {
      done(next);
      setNotice(`Khuyến mãi: ${PROMOTION_DISPLAY[next.display].label.toLowerCase()}.`);
    },
    onError: (failure) => setError(describePromotionError(failure))
  });
  const display = promotion ? PROMOTION_DISPLAY[promotion.display] : null;
  return (
    <>
      <header className="flex flex-wrap items-start justify-between gap-4">
        <div className="flex min-w-0 flex-1 basis-80 flex-col gap-1.5">
          <h1 className="text-[30px] leading-[38px] font-semibold text-vxn-ink">{promotion ? promotion.code : "Tạo khuyến mãi"}</h1>
          <p className="text-sm leading-5 text-muted-foreground">Khuyến mãi nền tảng — chỉ áp cho chuyến của nhà xe đã tham gia; nhà xe tham gia chịu phần giảm.</p>
        </div>
        {promotion && display && (
          <div className="flex flex-wrap items-center gap-3">
            <Badge tone={display.tone}>{display.label}</Badge>
            {(promotion.display === "RUNNING" || promotion.display === "SCHEDULED") && (
              <Button variant="outline" className={`${BUTTON} bg-card`} disabled={status.isPending} onClick={() => status.mutate("PAUSED")}>
                Tạm dừng
              </Button>
            )}
            {promotion.display === "PAUSED" && (
              <Button variant="outline" className={`${BUTTON} bg-card`} disabled={status.isPending} onClick={() => status.mutate("ACTIVE")}>
                Chạy lại
              </Button>
            )}
            {promotion.display !== "ENDED" && (
              <Button variant="outline" className={`${BUTTON} bg-card text-error-600`} disabled={status.isPending} onClick={() => status.mutate("ENDED")}>
                Kết thúc
              </Button>
            )}
          </div>
        )}
      </header>
      {notice && (
        <p role="status" className="rounded-lg bg-success-50 px-5 py-3 text-sm leading-5 text-success-700">
          {notice}
        </p>
      )}
      {promotion && !promotion.editable && (
        <p role="note" className="flex gap-2.5 rounded-lg bg-accent px-5 py-3 text-sm leading-5 text-accent-foreground">
          <Info className="mt-0.5 size-4 shrink-0" aria-hidden />
          Khuyến mãi đã có đơn dùng mã hoặc đã kết thúc — không sửa điều kiện. Kết thúc và tạo chương trình mới nếu cần đổi.
        </p>
      )}
      <PromotionForm
        initial={promotion ? toValues(promotion) : emptyPromotion()}
        pending={save.isPending}
        serverError={error}
        editable={!promotion || promotion.editable}
        onSubmit={(values, activate) => save.mutate({ values, activate })}
        aside={(values) => (
          <>
            <section aria-label="Hành khách sẽ thấy" className="flex flex-col gap-4 rounded-xl border bg-card p-6">
              <h2 className="text-lg leading-7 font-semibold text-vxn-ink">Hành khách sẽ thấy</h2>
              <div className="flex overflow-hidden rounded-lg border">
                <div className="flex w-16 items-center justify-center bg-accent">
                  <TicketPercent className="size-5 text-primary" aria-hidden />
                </div>
                <div className="flex min-w-0 flex-col gap-0.5 px-4 py-3 text-xs leading-[18px] text-muted-foreground">
                  <p className="text-sm leading-5 font-semibold text-vxn-ink">
                    {values.code || "MÃ"} · {discountLabel(values)}
                  </p>
                  <p>{minOrderLabel(values.minOrder)} · nhà xe tham gia</p>
                  <p>Hiệu lực {windowLabel(values.startsAt, values.endsAt)}</p>
                </div>
              </div>
            </section>
            {promotion && (
              <section aria-label="Kết quả" className="flex flex-col gap-3 rounded-xl border bg-card p-6 text-sm leading-5">
                <h2 className="text-lg leading-7 font-semibold text-vxn-ink">Kết quả</h2>
                <p className="flex justify-between gap-3">
                  <span className="text-muted-foreground">Lượt dùng</span>
                  <span className="font-semibold tabular-nums">{usageLabel(promotion.usedCount, promotion.usageLimit)}</span>
                </p>
                <p className="flex justify-between gap-3">
                  <span className="text-muted-foreground">Nhà xe tham gia</span>
                  <span className="font-semibold tabular-nums">{promotion.participants ?? 0}</span>
                </p>
              </section>
            )}
          </>
        )}
      />
    </>
  );
}
