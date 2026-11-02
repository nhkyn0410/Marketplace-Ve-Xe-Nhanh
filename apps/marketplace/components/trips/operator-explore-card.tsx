import { ArrowRight, Route, Star } from "lucide-react";
import Link from "next/link";
import { placeSearchParams } from "../../lib/data/trip-mappers";
import type { FeaturedOperatorItem } from "../../lib/data/types";
import { formatVnd } from "../../lib/format";

type ServedRoute = NonNullable<FeaturedOperatorItem["routes"]>[number];

/**
 * Thẻ nhà xe ở tab "Nhà xe" của trang Khám phá (giống thẻ nhà xe tab Mua vé của app): đánh giá, tuyến đang phục vụ,
 * giá vé thấp nhất của tuyến đó vào ngày đang xem, nút Xem chuyến mở kết quả tìm lọc sẵn nhà xe.
 */
export function OperatorExploreCard({ operator, route, fareVnd, date }: {
  readonly operator: FeaturedOperatorItem;
  /** Tuyến khớp khu vực / tuyến đang lọc (không lọc = tuyến đầu tiên); `null` = nhà xe chưa có tuyến mở bán. */
  readonly route: ServedRoute | null;
  readonly fareVnd: string | null;
  readonly date: string;
}) {
  const otherRoutes = Math.max(0, (operator.routes?.length ?? 0) - 1);
  const tripsHref = route && `/trips?${new URLSearchParams({
    ...placeSearchParams("origin", { type: "province", id: route.originProvinceId, label: route.originName ?? "" }),
    ...placeSearchParams("destination", { type: "province", id: route.destinationProvinceId, label: route.destinationName ?? "" }),
    date,
    passengers: "1",
    operatorId: operator.id
  })}`;

  return (
    <article className="flex flex-col gap-4 rounded-2xl border border-slate-200 bg-white p-4 shadow-2xs sm:p-5">
      <div className="flex items-center gap-3">
        {operator.logoUrl ? (
          <img src={operator.logoUrl} alt="" className="h-11 w-11 shrink-0 rounded-xl border border-slate-100 object-contain" />
        ) : (
          <div
            className="flex h-11 w-11 shrink-0 items-center justify-center rounded-xl text-sm font-extrabold text-white"
            style={{ backgroundColor: operator.accentColor ?? "#00506a" }}
          >
            {operator.shortCode}
          </div>
        )}
        <div className="min-w-0">
          <Link href={`/operators/${encodeURIComponent(operator.id)}`} className="block truncate text-sm font-bold text-slate-900 hover:text-vxn-teal-700">
            {operator.name}
          </Link>
          <div className="mt-0.5 flex items-center gap-1 text-xs text-slate-500">
            {operator.rating !== null && (
              <>
                <Star className="h-3 w-3 shrink-0 fill-amber-400 text-amber-500" />
                <span className="font-bold text-slate-800">{operator.rating.toFixed(1)}</span>
                <span>·</span>
              </>
            )}
            <span className="truncate">{operator.ratingCountText}</span>
          </div>
        </div>
      </div>

      <div className="flex items-start gap-2 text-xs text-slate-600">
        <Route className="mt-0.5 h-3.5 w-3.5 shrink-0 text-[#00506a]" />
        <div className="min-w-0">
          <div className="font-medium text-slate-500">Tuyến đang phục vụ</div>
          <div className="mt-0.5 font-semibold text-slate-800">
            {route ? route.label : "Chưa có tuyến mở bán"}
            {route && otherRoutes > 0 && <span className="font-normal text-slate-500"> +{otherRoutes} tuyến</span>}
          </div>
        </div>
      </div>

      <div className="mt-auto flex items-end justify-between gap-3 border-t border-slate-100 pt-3">
        <div>
          <div className="text-[11px] text-slate-500">Giá vé từ</div>
          <div className="text-lg font-extrabold text-[#00506a]">{fareVnd ? formatVnd(fareVnd) : "—"}</div>
          {!fareVnd && route && <div className="text-[11px] text-slate-500">Chưa có chuyến ngày này</div>}
        </div>
        {tripsHref && (
          <Link
            href={tripsHref}
            className="inline-flex items-center gap-1.5 rounded-xl bg-[#00506a] px-4 py-2 text-sm font-bold text-white shadow-xs transition hover:bg-[#00476b]"
          >
            Xem chuyến <ArrowRight className="h-4 w-4" />
          </Link>
        )}
      </div>
    </article>
  );
}
