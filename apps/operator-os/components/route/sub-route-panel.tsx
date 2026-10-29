"use client";

import { useQuery, useQueryClient } from "@tanstack/react-query";
import { Badge } from "@vexenhanh/ui/components/badge";
import { Button } from "@vexenhanh/ui/components/button";
import { Input } from "@vexenhanh/ui/components/input";
import { Skeleton } from "@vexenhanh/ui/components/skeleton";
import { CircleAlert, CircleCheck, LoaderCircle, Pencil, Plus, Tag } from "lucide-react";
import Link from "next/link";
import { useState } from "react";

import { createFare } from "../../lib/fare/fare-api";
import { parsePrice } from "../../lib/fare/fare-form";
import {
  createSubRoute,
  listSubRouteSuggestions,
  type Route,
  type SubRoute,
  type SubRouteSuggestion
} from "../../lib/route/route-api";
import { formatDistance, formatDuration, ROUTE_STATUS } from "../../lib/route/route-format";
import { describeSubRouteError, generalPrice, pointKey, suggestedFareRules, suggestionInput } from "../../lib/route/sub-route";
import { BUTTON } from "../list-parts";

const CARD = "flex flex-col gap-5 rounded-xl border bg-card p-6";
const HELPER = "text-xs leading-[18px] text-muted-foreground";
const VND = new Intl.NumberFormat("vi-VN");

const suggestionKey = (item: SubRouteSuggestion) => `${pointKey(item.from)}>${pointKey(item.to)}`;

/**
 * Mục "Tuyến con" của trang sửa tuyến chính (giai đoạn 3.2, tự thiết kế 29/10/2026, chờ duyệt): tuyến con đang có kèm bảng
 * giá, và đoạn gợi ý theo nhóm nơi với giá gợi ý nhà xe sửa được — "Lưu nháp" tạo tuyến con ở Nháp + bảng giá, xem lại giá
 * rồi mới bật ở trang của từng tuyến con.
 */
export function SubRoutePanel({ route }: { route: Route }) {
  const queryClient = useQueryClient();
  const suggestions = useQuery({
    queryKey: ["sub-route-suggestions", route.id, route.updatedAt, route.subRoutes.length],
    queryFn: () => listSubRouteSuggestions(route.id)
  });
  const [selected, setSelected] = useState<Set<string>>(new Set());
  const [prices, setPrices] = useState<Record<string, string>>({});
  const [saving, setSaving] = useState(false);
  const [result, setResult] = useState<{ tone: "success" | "error"; message: string } | null>(null);

  const items = suggestions.data ?? [];
  const priceText = (item: SubRouteSuggestion) => {
    const key = suggestionKey(item);
    if (key in prices) {
      return prices[key]!;
    }
    const price = generalPrice(item.suggestedRules);
    return price === null ? "" : String(price);
  };
  const invalidPrice = (item: SubRouteSuggestion) => priceText(item).trim() !== "" && parsePrice(priceText(item)) === null;
  const chosen = items.filter((item) => selected.has(suggestionKey(item)));

  async function saveDrafts() {
    if (chosen.some(invalidPrice)) {
      setResult({ tone: "error", message: "Giá là số nguyên từ 0 đến 100.000.000 ₫ (vd 150000 hoặc 150.000)." });
      return;
    }
    setSaving(true);
    setResult(null);
    let created = 0;
    const problems: string[] = [];
    for (const item of chosen) {
      try {
        const sub = await createSubRoute(route.id, suggestionInput(item));
        created++;
        const text = priceText(item).trim();
        const rules = suggestedFareRules(item.suggestedRules, text === "" ? null : parsePrice(text));
        if (rules) {
          await createFare({ routeId: sub.id, status: "ACTIVE", note: null, rules }).catch(() => {
            problems.push(`${sub.name}: chưa tạo được bảng giá — mở Bảng giá để tạo`);
          });
        }
      } catch (error) {
        problems.push(`${item.name}: ${describeSubRouteError(error).message}`);
      }
    }
    setSaving(false);
    setSelected(new Set());
    void queryClient.invalidateQueries({ queryKey: ["route", route.id] });
    void queryClient.invalidateQueries({ queryKey: ["routes"] });
    void queryClient.invalidateQueries({ queryKey: ["fares"] });
    void queryClient.invalidateQueries({ queryKey: ["sub-route-suggestions", route.id] });
    setResult(
      problems.length === 0
        ? { tone: "success", message: `Đã lưu nháp ${created} tuyến con. Xem lại giá rồi bật ở trang của từng tuyến con.` }
        : { tone: "error", message: `Đã lưu nháp ${created} tuyến con. ${problems.join("; ")}.` }
    );
  }

  return (
    <section aria-labelledby="sub-routes-heading" className={CARD}>
      <div className="flex flex-wrap items-start gap-4">
        <div className="flex min-w-0 flex-1 flex-col gap-1">
          <h2 id="sub-routes-heading" className="text-base leading-6 font-semibold text-vxn-ink">
            Tuyến con
          </h2>
          <p className={HELPER}>
            Đoạn của tuyến này có giá riêng (vd chỉ đi tới điểm giữa). Tuyến con dùng điểm dừng của tuyến chính và không
            có chuyến riêng: khách mua chặng trên chuyến của tuyến chính. Bật tuyến con cần có bảng giá.
          </p>
        </div>
        <Button asChild variant="outline" className={`${BUTTON} bg-card`}>
          <Link href={`/routes/new?parentRouteId=${route.id}`}>
            <Plus className="size-[18px]" />
            Thêm tuyến con
          </Link>
        </Button>
      </div>

      {result && (
        <div
          role={result.tone === "error" ? "alert" : "status"}
          className={`flex items-start gap-3 rounded-lg px-4 py-3 text-sm leading-5 ${
            result.tone === "error" ? "bg-error-50 text-error-600" : "bg-success-50 text-success-600"
          }`}
        >
          {result.tone === "error" ? <CircleAlert className="mt-px size-5 shrink-0" /> : <CircleCheck className="mt-px size-5 shrink-0" />}
          {result.message}
        </div>
      )}

      {route.subRoutes.length === 0 ? (
        <p className="rounded-lg border border-dashed px-4 py-4 text-center text-sm leading-5 text-muted-foreground">
          Tuyến này chưa có tuyến con.
        </p>
      ) : (
        <ul className="flex flex-col divide-y rounded-lg border">
          {route.subRoutes.map((sub) => (
            <SubRouteRow key={sub.id} sub={sub} />
          ))}
        </ul>
      )}

      <div className="flex flex-col gap-3">
        <h3 className="text-sm leading-5 font-semibold text-vxn-ink">Gợi ý theo nơi đón trả</h3>
        {suggestions.isPending ? (
          <Skeleton className="h-24 rounded-lg" aria-label="Đang tải gợi ý tuyến con" />
        ) : suggestions.isError ? (
          <p className="text-sm text-error-600">Chưa tải được gợi ý tuyến con. Vui lòng thử lại sau.</p>
        ) : items.length === 0 ? (
          <p className={HELPER}>
            Không còn gợi ý. Gợi ý có khi tuyến có điểm giữa cho đón / trả ở nơi khác điểm đầu và điểm cuối.
          </p>
        ) : (
          <>
            <ul className="flex flex-col divide-y rounded-lg border">
              {items.map((item) => {
                const key = suggestionKey(item);
                return (
                  <li key={key} className="flex flex-wrap items-center gap-x-4 gap-y-2 px-4 py-3">
                    <label className="flex min-w-0 flex-1 items-start gap-3">
                      <input
                        type="checkbox"
                        className="mt-1 size-4 shrink-0 accent-primary"
                        checked={selected.has(key)}
                        disabled={saving}
                        onChange={(event) =>
                          setSelected((current) => {
                            const next = new Set(current);
                            if (event.target.checked) next.add(key);
                            else next.delete(key);
                            return next;
                          })
                        }
                      />
                      <span className="flex min-w-0 flex-col gap-0.5">
                        <span className="text-sm leading-5 font-semibold text-vxn-ink">{item.name}</span>
                        <span className={HELPER}>
                          {item.from.name} → {item.to.name} · {formatDistance(item.totalDistanceMeters)} ·{" "}
                          {formatDuration(item.totalDurationSeconds)}
                        </span>
                      </span>
                    </label>
                    <div className="flex w-56 flex-col gap-1">
                      <Input
                        aria-label={`Giá chung của ${item.name} (₫)`}
                        inputMode="numeric"
                        placeholder="Giá chung (₫)"
                        value={priceText(item)}
                        disabled={saving}
                        aria-invalid={invalidPrice(item)}
                        onChange={(event) => setPrices((current) => ({ ...current, [key]: event.target.value }))}
                      />
                      <span className={HELPER}>
                        {item.suggestedRules
                          ? `Gợi ý theo tỉ lệ quãng đường${item.suggestedRules.length > 1 ? ` · ${item.suggestedRules.length} mức giá` : ""}`
                          : "Tuyến chính chưa có bảng giá"}
                      </span>
                    </div>
                  </li>
                );
              })}
            </ul>
            <div className="flex flex-wrap items-center gap-4">
              <Button type="button" className={`${BUTTON}`} disabled={saving || chosen.length === 0} onClick={() => void saveDrafts()}>
                {saving && <LoaderCircle className="size-[18px] animate-spin" />}
                {saving ? "Đang lưu nháp…" : `Lưu nháp ${chosen.length > 0 ? `${chosen.length} ` : ""}tuyến con`}
              </Button>
              <p className={HELPER}>
                Giá chung sửa được; các mức giá khác (loại xe, loại chỗ, khung giờ) theo tỉ lệ quãng đường, chỉnh sau ở Bảng giá.
              </p>
            </div>
          </>
        )}
      </div>
    </section>
  );
}

function SubRouteRow({ sub }: { sub: SubRoute }) {
  const state = ROUTE_STATUS[sub.status];
  const fare = sub.fare;
  const price =
    fare?.minPrice === null || fare?.minPrice === undefined
      ? "Chưa có giá"
      : fare.minPrice === fare.maxPrice
        ? `${VND.format(fare.minPrice)} ₫`
        : `${VND.format(fare.minPrice)}–${VND.format(fare.maxPrice!)} ₫`;
  return (
    <li className="flex flex-wrap items-center gap-x-4 gap-y-2 px-4 py-3">
      <div className="flex min-w-0 flex-1 flex-col gap-0.5">
        <Link href={`/routes/${sub.id}`} className="truncate text-sm leading-5 font-semibold text-vxn-teal-700 hover:underline">
          {sub.name}
        </Link>
        <span className={HELPER}>
          {sub.from.name} → {sub.to.name} · {formatDistance(sub.totalDistanceMeters)} · {formatDuration(sub.totalDurationSeconds)}
        </span>
        {sub.needsReview && (
          <span className="flex items-center gap-1 text-xs leading-[18px] text-warning-700">
            <CircleAlert className="size-3.5" />
            Cần xem lại: điểm đầu / cuối không còn trên tuyến chính
          </span>
        )}
      </div>
      <span className={`text-sm leading-5 ${fare ? "text-vxn-ink" : "text-muted-foreground"}`}>{price}</span>
      <Badge tone={state.tone}>{state.label}</Badge>
      <div className="flex items-center gap-1">
        <Button asChild variant="ghost" className={`${BUTTON} text-vxn-fg-1`}>
          <Link href={fare ? `/fares/${fare.id}` : `/fares/new?routeId=${sub.id}`} aria-label={`Bảng giá ${sub.name}`}>
            <Tag className="size-[18px]" />
            Bảng giá
          </Link>
        </Button>
        <Button asChild variant="ghost" className={`${BUTTON} text-vxn-fg-1`}>
          <Link href={`/routes/${sub.id}`} aria-label={`Sửa tuyến con ${sub.name}`}>
            <Pencil className="size-[18px]" />
            Sửa
          </Link>
        </Button>
      </div>
    </li>
  );
}
