"use client";

import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { Badge } from "@vexenhanh/ui/components/badge";
import { Button } from "@vexenhanh/ui/components/button";
import { BUTTON } from "@vexenhanh/ui/components/list-parts";
import { emptyPromotion, PromotionForm, type PromotionFormValues } from "@vexenhanh/ui/components/promotion-form";
import { Skeleton } from "@vexenhanh/ui/components/skeleton";
import { ApiError } from "@vexenhanh/ui/lib/auth/api-client";
import { capLabel, discountLabel, minOrderLabel, PROMOTION_DISPLAY } from "@vexenhanh/ui/lib/promotion-format";
import { ArrowLeft, CircleAlert, CircleCheck, Info, Tag } from "lucide-react";
import Link from "next/link";
import { useRouter } from "next/navigation";
import { useState } from "react";

import { formatVnd } from "../../lib/fare/fare-format";
import { createPromotion, describePromotionError, getPermission, getPromotion, setPromotionStatus, updatePromotion, type Permission, type Promotion } from "../../lib/promotion/promotion-api";
import { listAllRoutes } from "../../lib/route/route-api";

const DAY_MS = 86_400_000;

/**
 * Tạo / sửa khuyến mãi của nhà xe (Figma "Nhà xe · Khuyến mãi / Tạo"; TASK-PROM-001): giới hạn được cấp + kiểm tại chỗ, "Hành khách
 * sẽ thấy"; lưu nháp / kích hoạt; đã có đơn dùng mã → chỉ xem + đổi trạng thái (BR-47).
 */
export function PromotionEditor({ promotionId }: { promotionId?: string }) {
  const permission = useQuery({ queryKey: ["operator-promotion-permission"], queryFn: getPermission });
  const routes = useQuery({ queryKey: ["routes", "all"], queryFn: () => listAllRoutes() });
  const promotion = useQuery({
    queryKey: ["operator-promotion", promotionId],
    queryFn: () => getPromotion(promotionId!),
    enabled: Boolean(promotionId),
    retry: (count, error) => !(error instanceof ApiError && error.status === 404) && count < 2
  });
  const ready = permission.data && routes.data && (!promotionId || promotion.data);
  return (
    <div className="flex flex-col gap-6">
      <Link href="/promotions" className="flex w-fit items-center gap-1.5 text-sm leading-5 font-medium text-primary hover:underline">
        <ArrowLeft className="size-[18px]" />
        Quay lại danh sách khuyến mãi
      </Link>
      {ready ? (
        <EditorBody
          key={promotion.data?.promotionId ?? "new"}
          promotion={promotion.data ?? null}
          permission={permission.data!}
          routes={(routes.data ?? []).filter((route) => permission.data!.routeIds.length === 0 || permission.data!.routeIds.includes(route.id)).map((route) => ({ value: route.id, label: route.name }))}
        />
      ) : promotion.isError || permission.isError ? (
        <p role="alert" className="rounded-xl border bg-card px-6 py-10 text-center text-sm text-muted-foreground">
          Không tải được khuyến mãi. Tải lại trang.
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
    routeId: promotion.routeId,
    tripId: promotion.tripId,
    startsAt: promotion.startsAt,
    endsAt: promotion.endsAt,
    usageLimit: promotion.usageLimit
  };
}

/** Kiểm giới hạn tại chỗ (server kiểm lại khi lưu / kích hoạt). */
function checks(values: PromotionFormValues, permission: Permission) {
  const cap =
    values.discountType === "PERCENT"
      ? permission.maxPercent !== null && values.discountValue <= permission.maxPercent && (permission.maxAmount === null || (values.maxDiscount !== null && values.maxDiscount <= permission.maxAmount))
      : permission.maxAmount !== null && values.discountValue <= permission.maxAmount;
  const duration = Date.parse(values.endsAt) - Date.parse(values.startsAt) <= permission.maxDurationDays * DAY_MS;
  return [
    { ok: cap, label: cap ? "Mức giảm trong giới hạn" : "Mức giảm vượt giới hạn" },
    { ok: duration, label: duration ? "Thời gian hiệu lực trong giới hạn" : "Thời gian hiệu lực vượt giới hạn" }
  ];
}

function EditorBody({ promotion, permission, routes }: { promotion: Promotion | null; permission: Permission; routes: { value: string; label: string }[] }) {
  const router = useRouter();
  const queryClient = useQueryClient();
  const [error, setError] = useState<string | null>(null);
  const [notice, setNotice] = useState<string | null>(null);
  const done = (next: Promotion) => {
    queryClient.setQueryData(["operator-promotion", next.promotionId], next);
    void queryClient.invalidateQueries({ queryKey: ["operator-promotions"] });
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
  if (!promotion && !permission.enabled) {
    return (
      <p role="note" className="rounded-xl border bg-card px-6 py-10 text-center text-sm text-muted-foreground">
        Nhà xe chưa được Vé Xe Nhanh cấp quyền tạo khuyến mãi.
      </p>
    );
  }
  return (
    <>
      <header className="flex flex-wrap items-start justify-between gap-4">
        <div className="flex min-w-0 flex-1 basis-80 flex-col gap-1.5">
          <h1 className="text-[30px] leading-[38px] font-semibold text-vxn-ink">{promotion ? promotion.code : "Tạo khuyến mãi"}</h1>
          <p className="text-sm leading-5 text-muted-foreground">Chương trình chỉ áp dụng cho tuyến và chuyến của {permission.operatorName}.</p>
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
        <p role="note" className="flex gap-2.5 rounded-lg bg-accent px-5 py-3 text-sm leading-5 text-vxn-teal-700">
          <Info className="mt-0.5 size-4 shrink-0" aria-hidden />
          Khuyến mãi đã có đơn dùng mã hoặc đã kết thúc — không sửa điều kiện. Kết thúc và tạo chương trình mới nếu cần đổi.
        </p>
      )}
      <PromotionForm
        initial={promotion ? toValues(promotion) : { ...emptyPromotion(), routeId: permission.routeIds[0] ?? null }}
        routes={routes}
        pending={save.isPending}
        serverError={error}
        editable={!promotion || promotion.editable}
        onSubmit={(values, activate) => save.mutate({ values, activate })}
        aside={(values) => (
          <>
            <section aria-label="Giới hạn được cấp" className="flex flex-col gap-3 rounded-xl border bg-card p-6 text-sm leading-5">
              <div className="flex flex-col gap-1">
                <h2 className="text-lg leading-7 font-semibold text-vxn-ink">Giới hạn được cấp</h2>
                <p className="text-xs leading-[18px] text-muted-foreground">Do Vé Xe Nhanh đặt cho nhà xe.</p>
              </div>
              <Row label="Mức giảm tối đa" value={capLabel(permission.maxPercent, permission.maxAmount)} />
              <Row label="Tuyến được áp dụng" value={permission.routeIds.length === 0 ? "Mọi tuyến của nhà xe" : permission.routeNames.join(", ")} />
              <Row label="Thời gian hiệu lực tối đa" value={`${permission.maxDurationDays} ngày`} />
              <Row label="Ngân sách" value={permission.monthlyBudget === null ? "Không giới hạn" : `${formatVnd(permission.monthlyBudget)} / tháng`} />
              <ul className="flex flex-col gap-2 border-t pt-3">
                {checks(values, permission).map((check) => (
                  <li key={check.label} className={`flex items-center gap-2 text-xs leading-[18px] ${check.ok ? "text-success-700" : "text-error-600"}`}>
                    {check.ok ? <CircleCheck className="size-4" aria-hidden /> : <CircleAlert className="size-4" aria-hidden />}
                    {check.label}
                  </li>
                ))}
              </ul>
            </section>
            <section aria-label="Hành khách sẽ thấy" className="flex flex-col gap-4 rounded-xl border bg-card p-6">
              <h2 className="text-lg leading-7 font-semibold text-vxn-ink">Hành khách sẽ thấy</h2>
              <div className="flex overflow-hidden rounded-lg border">
                <div className="flex w-16 items-center justify-center bg-warning-50">
                  <Tag className="size-5 text-warning-700" aria-hidden />
                </div>
                <div className="flex min-w-0 flex-col gap-0.5 px-4 py-3 text-xs leading-[18px] text-muted-foreground">
                  <p className="text-sm leading-5 font-semibold text-vxn-ink">
                    {values.code || "MÃ"} · {discountLabel(values)}
                  </p>
                  <p>
                    {permission.operatorName} · {minOrderLabel(values.minOrder)}
                  </p>
                </div>
              </div>
              <p className="rounded-lg bg-accent px-4 py-3 text-xs leading-[18px] text-vxn-teal-700">Phần giảm của khuyến mãi nhà xe trừ vào doanh thu của nhà xe.</p>
            </section>
          </>
        )}
      />
    </>
  );
}

function Row({ label, value }: { label: string; value: string }) {
  return (
    <p className="flex justify-between gap-3">
      <span className="text-muted-foreground">{label}</span>
      <span className="text-right font-semibold text-vxn-ink">{value}</span>
    </p>
  );
}
