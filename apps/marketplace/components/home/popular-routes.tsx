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
 * Ảnh nền minh họa cho từng tuyến xe đặc trưng.
 */
const ROUTE_BACKGROUND_IMAGES: Record<string, string> = {
  "route-sg-dalat": "https://images.unsplash.com/photo-1519681393784-d120267933ba?auto=format&fit=crop&w=1000&q=80",
  "route-hn-sapa": "https://images.unsplash.com/photo-1528127269322-539801943592?auto=format&fit=crop&w=600&q=80",
  "route-sg-vungtau": "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=600&q=80",
  "route-hn-halong": "https://images.unsplash.com/photo-1528181304800-259b08848526?auto=format&fit=crop&w=600&q=80",
  "route-dn-hue": "https://images.unsplash.com/photo-1559592413-7cec4d0cae2b?auto=format&fit=crop&w=600&q=80",
  "route-sg-nhatrang": "https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=600&q=80",
  "route-hn-ninhbinh": "https://images.unsplash.com/photo-1509316975850-ff9c5deb0cd9?auto=format&fit=crop&w=600&q=80"
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
      <section className="mx-auto max-w-7xl px-4 py-12 sm:px-6 lg:px-8">
        <div className="flex items-center justify-between pb-4">
          <div>
            <span className="text-xs font-semibold tracking-wider text-vxn-teal-700 uppercase">
              Tuyến phổ biến
            </span>
            <h2 className="text-2xl font-bold text-vxn-ink">Việt Nam, mọi cung đường</h2>
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
    <section className="mx-auto max-w-7xl px-4 py-12 sm:px-6 lg:px-8">
      {/* Tiêu đề mục */}
      <div className="flex items-end justify-between pb-6">
        <div>
          <span className="text-xs font-bold tracking-wider text-vxn-teal-700 uppercase">
            TUYẾN PHỔ BIẾN
          </span>
          <h2 className="mt-1 text-2xl font-black text-vxn-ink sm:text-3xl">
            Việt Nam, mọi cung đường
          </h2>
        </div>
        <Link
          href="/routes"
          className="inline-flex items-center gap-1 text-sm font-semibold text-vxn-teal-700 hover:text-vxn-teal-800"
        >
          <span>Xem tất cả tuyến</span>
          <ArrowRight className="h-4 w-4" />
        </Link>
      </div>

      {/* Lưới các tuyến xe */}
      <div className="grid grid-cols-1 gap-6 lg:grid-cols-12">
        {/* Thẻ lớn Nổi bật bên trái (5 cột) */}
        {featuredRoute && (
          <div
            className="group relative flex min-h-[380px] flex-col justify-between overflow-hidden rounded-2xl bg-cover bg-center p-6 text-white shadow-md transition hover:shadow-xl lg:col-span-5"
            style={{
              backgroundImage: `url('${ROUTE_BACKGROUND_IMAGES[featuredRoute.id] ?? ROUTE_BACKGROUND_IMAGES["route-sg-dalat"]}')`
            }}
          >
            {/* Lớp gradient overlay */}
            <div className="absolute inset-0 bg-gradient-to-t from-black/85 via-black/40 to-black/20" />

            <div className="relative z-10">
              <div className="flex items-center gap-2">
                <span className="rounded-full bg-[#f3b132] px-3 py-1 text-xs font-black text-vxn-ink">
                  NỔI BẬT
                </span>
                <div className="flex items-center gap-1 rounded-full bg-black/40 px-2.5 py-0.5 text-xs font-bold text-white backdrop-blur-xs">
                  <Star className="h-3.5 w-3.5 fill-amber-300 text-amber-300" />
                  <span>{featuredRoute.rating.toFixed(1)}</span>
                </div>
              </div>
            </div>

            <div className="relative z-10">
              <p className="text-xs font-medium text-white/85">
                {featuredRoute.distanceKm} km • {featuredRoute.durationText} • {featuredRoute.vehicleTypeText}
              </p>
              <h3 className="mt-1 text-2xl font-black tracking-tight sm:text-3xl">
                {featuredRoute.fromCity} &gt; {featuredRoute.toCity}
              </h3>

              <div className="mt-6 flex items-center justify-between border-t border-white/20 pt-4">
                <div>
                  <span className="text-xs text-white/80">Từ </span>
                  <span className="text-2xl font-black text-[#f3b132]">
                    {formatVnd(featuredRoute.minPriceVnd)}
                  </span>
                </div>
                <Link
                  href={`/trips?from=${encodeURIComponent(featuredRoute.fromCity)}&to=${encodeURIComponent(featuredRoute.toCity)}`}
                  className="inline-flex items-center gap-1.5 rounded-xl bg-white/20 px-4 py-2 text-sm font-bold text-white backdrop-blur-sm transition hover:bg-white hover:text-vxn-ink"
                >
                  <span>Đặt vé ngay</span>
                  <ChevronRight className="h-4 w-4" />
                </Link>
              </div>
            </div>
          </div>
        )}

        {/* 6 Thẻ nhỏ bên phải (7 cột - grid 2 hoặc 3 cột con) */}
        <div className="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:col-span-7">
          {standardRoutes.map((route) => (
            <Link
              key={route.id}
              href={`/trips?from=${encodeURIComponent(route.fromCity)}&to=${encodeURIComponent(route.toCity)}`}
              className="group relative flex min-h-[175px] flex-col justify-between overflow-hidden rounded-2xl bg-cover bg-center p-4 text-white shadow-xs transition hover:scale-[1.01] hover:shadow-lg"
              style={{
                backgroundImage: `url('${ROUTE_BACKGROUND_IMAGES[route.id] ?? ROUTE_BACKGROUND_IMAGES["route-hn-sapa"]}')`
              }}
            >
              {/* Lớp gradient overlay tối */}
              <div className="absolute inset-0 bg-gradient-to-t from-black/85 via-black/40 to-black/25" />

              <div className="relative z-10 flex items-center justify-between">
                <div className="flex items-center gap-1 rounded-full bg-black/40 px-2 py-0.5 text-xs font-bold text-white backdrop-blur-xs">
                  <Star className="h-3 w-3 fill-amber-300 text-amber-300" />
                  <span>{route.rating.toFixed(1)}</span>
                </div>
              </div>

              <div className="relative z-10">
                <h4 className="text-base font-bold text-white drop-shadow-xs group-hover:text-amber-200">
                  {route.fromCity} &rarr; {route.toCity}
                </h4>

                <div className="mt-2 flex items-center justify-between border-t border-white/20 pt-2 text-xs">
                  <div>
                    <span className="text-white/80">Từ </span>
                    <span className="font-extrabold text-[#f3b132]">
                      {formatVnd(route.minPriceVnd)}
                    </span>
                  </div>
                  <span className="font-medium text-white/80 group-hover:text-white">
                    Xem chuyến
                  </span>
                </div>
              </div>
            </Link>
          ))}
        </div>
      </div>
    </section>
  );
}
