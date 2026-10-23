import { ArrowRight, ChevronRight, Star } from "lucide-react";
import Link from "next/link";
import { formatVnd } from "../../lib/format";
import { PopularRouteItem } from "../../lib/data/types";
import { FeatureUnavailableCompact } from "../states";

/**
 * Thuộc tính của khối Tuyến xe phổ biến.
 */
export interface PopularRoutesSectionProps {
  readonly routes?: readonly PopularRouteItem[];
  readonly isUnavailable?: boolean;
}

/**
 * Ảnh nền cho từng tuyến xe phổ biến theo thiết kế Figma 776:791.
 */
const ROUTE_BACKGROUND_IMAGES: Record<string, string> = {
  "route-sg-dalat": "/images/route-sg-dalat.jpg",
  "route-hn-sapa": "/images/route-hn-sapa.jpg",
  "route-sg-vungtau": "/images/route-sg-vungtau.jpg",
  "route-hn-halong": "/images/route-hn-halong.jpg",
  "route-dn-hue": "/images/route-dn-hue.jpg",
  "route-sg-nhatrang": "/images/route-sg-nhatrang.jpg",
  "route-hn-ninhbinh": "/images/route-hn-ninhbinh.jpg"
};

/**
 * Khối Tuyến xe phổ biến trên trang chủ chuẩn theo Figma 776:791.
 */
export function PopularRoutesSection({
  routes,
  isUnavailable = false
}: PopularRoutesSectionProps) {
  if (isUnavailable || !routes || routes.length === 0) {
    return (
      <section className="mx-auto w-full max-w-[1120px] px-4 pt-12 pb-6 sm:px-6 lg:px-8">
        <div className="flex items-end justify-between pb-5">
          <div>
            <span className="text-xs font-bold tracking-wider text-[#d9881c] uppercase">
              TUYẾN PHỔ BIẾN
            </span>
            <h2 className="mt-1 text-2xl font-extrabold text-[#0f172a] sm:text-[28px]">
              Việt Nam, mọi cung đường
            </h2>
          </div>
        </div>
        <FeatureUnavailableCompact
          endpoint="GET /catalog/popular-routes"
          title="Danh sách tuyến xe phổ biến chưa sẵn sàng"
        />
      </section>
    );
  }

  const featuredRoute = routes.find((r) => r.isFeatured) ?? routes[0];
  const standardRoutes = routes.filter((r) => r.id !== featuredRoute?.id);

  return (
    <section className="mx-auto w-full max-w-[1120px] px-4 pt-12 pb-6 sm:px-6 lg:px-8">
      {/* Tiêu đề mục */}
      <div className="flex items-end justify-between pb-5">
        <div>
          <span className="text-xs font-bold tracking-wider text-[#d9881c] uppercase">
            TUYẾN PHỔ BIẾN
          </span>
          <h2 className="mt-1 text-2xl font-extrabold text-[#0f172a] sm:text-[28px]">
            Việt Nam, mọi cung đường
          </h2>
        </div>
        <Link
          href="/trips"
          className="text-xs font-bold text-[#00506a] hover:underline"
        >
          Xem tất cả tuyến
        </Link>
      </div>

      {/* Lưới 4 cột x 2 hàng chuẩn Figma */}
      <div className="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-4">
        {/* Thẻ lớn Nổi bật ở Hàng 1 (chiếm 2 cột) */}
        {featuredRoute && (
          <div
            className="group relative flex min-h-[245px] flex-col justify-between overflow-hidden rounded-2xl bg-cover bg-center p-5 text-white shadow-xs transition hover:shadow-lg sm:col-span-2 lg:col-span-2"
            style={{
              backgroundImage: `url('${ROUTE_BACKGROUND_IMAGES[featuredRoute.id] ?? ROUTE_BACKGROUND_IMAGES["route-sg-dalat"]}')`
            }}
          >
            {/* Lớp gradient overlay nửa dưới */}
            <div className="absolute inset-0 bg-gradient-to-t from-[#061824]/90 via-[#061824]/30 to-transparent" />

            <div className="relative z-10 flex items-center gap-2">
              <span className="rounded-full bg-[#fde8c4] px-3 py-1 text-[10px] font-extrabold tracking-wide text-[#9a5806] uppercase">
                NỔI BẬT
              </span>
              <div className="inline-flex items-center gap-1 rounded-full bg-black/45 px-2.5 py-1 text-xs font-bold text-white backdrop-blur-xs">
                <Star className="h-3 w-3 fill-[#f3a826] text-[#f3a826]" />
                <span>{featuredRoute.rating.toFixed(1)}</span>
              </div>
            </div>

            <div className="relative z-10">
              <p className="text-xs font-medium text-white/90">
                {featuredRoute.distanceKm} km • {featuredRoute.durationText} • {featuredRoute.vehicleTypeText}
              </p>
              <h3 className="mt-0.5 flex items-center gap-2 text-2xl font-extrabold tracking-tight text-white sm:text-[26px]">
                <span>{featuredRoute.fromCity}</span>
                <ChevronRight className="h-5 w-5 text-white/80" />
                <span>{featuredRoute.toCity}</span>
              </h3>

              <div className="mt-2 flex items-end justify-between">
                <div>
                  <span className="text-xs text-white/85">Từ </span>
                  <span className="text-xl font-extrabold text-[#f3a826]">
                    {formatVnd(featuredRoute.minPriceVnd)}
                  </span>
                </div>
                <Link
                  href={`/trips?from=${encodeURIComponent(featuredRoute.fromCity)}&to=${encodeURIComponent(featuredRoute.toCity)}`}
                  className="inline-flex items-center gap-1.5 rounded-lg bg-[#00506a]/90 px-3.5 py-2 text-xs font-bold text-white backdrop-blur-xs transition hover:bg-[#00506a]"
                >
                  <span>Đặt vé ngay</span>
                  <ArrowRight className="h-3.5 w-3.5" />
                </Link>
              </div>
            </div>
          </div>
        )}

        {/* 6 Thẻ còn lại: 2 thẻ ở Hàng 1 (cao 245px, có "Xem chuyến") và 4 thẻ ở Hàng 2 (cao 175px) */}
        {standardRoutes.map((route, idx) => {
          const isTopRow = idx < 2;
          return (
            <Link
              key={route.id}
              href={`/trips?from=${encodeURIComponent(route.fromCity)}&to=${encodeURIComponent(route.toCity)}`}
              className={`group relative flex flex-col justify-between overflow-hidden rounded-2xl bg-cover bg-center p-4 text-white shadow-xs transition hover:shadow-lg ${
                isTopRow ? "min-h-[245px]" : "min-h-[175px]"
              }`}
              style={{
                backgroundImage: `url('${ROUTE_BACKGROUND_IMAGES[route.id] ?? ROUTE_BACKGROUND_IMAGES["route-hn-sapa"]}')`
              }}
            >
              {/* Lớp gradient overlay nửa dưới */}
              <div className="absolute inset-0 bg-gradient-to-t from-[#061824]/90 via-[#061824]/25 to-transparent" />

              <div className="relative z-10 flex items-center">
                <div className="inline-flex items-center gap-1 rounded-full bg-black/45 px-2.5 py-0.5 text-[11px] font-bold text-white backdrop-blur-xs">
                  <Star className="h-3 w-3 fill-[#f3a826] text-[#f3a826]" />
                  <span>{route.rating.toFixed(1)}</span>
                </div>
              </div>

              <div className="relative z-10">
                <h4 className="text-[15px] font-extrabold text-white">
                  <span>{route.fromCity}</span>
                  <span className="mx-1.5 font-normal text-[#f3a826]">&rarr;</span>
                  <span>{route.toCity}</span>
                </h4>

                <div className="mt-1 flex items-center justify-between text-xs">
                  <div>
                    <span className="text-white/80">Từ </span>
                    <span className="text-sm font-extrabold text-[#f3a826]">
                      {formatVnd(route.minPriceVnd)}
                    </span>
                  </div>
                  {isTopRow && (
                    <span className="text-[11px] font-medium text-white/90 group-hover:underline">
                      Xem chuyến
                    </span>
                  )}
                </div>
              </div>
            </Link>
          );
        })}
      </div>
    </section>
  );
}
