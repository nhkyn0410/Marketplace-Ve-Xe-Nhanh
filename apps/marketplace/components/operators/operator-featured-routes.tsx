"use client";

import Link from "next/link";
import { ChevronRight } from "lucide-react";
import { formatVnd } from "../../lib/format";
import { OperatorFeaturedRoute } from "../../lib/data/types";

interface OperatorFeaturedRoutesProps {
  readonly routes: readonly OperatorFeaturedRoute[];
}

/**
 * Khối hiển thị các tuyến xe tiêu biểu của nhà xe (SCR-PSG-17).
 */
export function OperatorFeaturedRoutes({ routes }: OperatorFeaturedRoutesProps) {
  if (!routes.length) return null;
  return (
    <div className="space-y-3.5">
      <h2 className="text-base font-semibold text-neutral-900">
        Các tuyến đang khai thác
      </h2>

      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        {routes.map((route) => (
          <div
            key={route.id}
            className="bg-white rounded-2xl border border-neutral-200 overflow-hidden shadow-xs hover:shadow-md transition-shadow flex flex-col"
          >
            {/* Ảnh tuyến đường */}
            {route.imageUrl && <div className="relative h-44 w-full bg-neutral-100 overflow-hidden">
              {route.imageUrl && <img
                src={route.imageUrl}
                alt={route.routeName}
                className="w-full h-full object-cover hover:scale-105 transition-transform duration-300"
              />}
            </div>}

            {/* Nội dung thông tin tuyến */}
            <div className="p-5 flex-1 flex flex-col justify-between space-y-4">
              <div className="space-y-1">
                <h3 className="text-base font-bold text-neutral-900">
                  {route.routeName}
                </h3>
                <p className="text-xs text-neutral-500">
                  {route.metaText}
                </p>
              </div>

              {(route.minPriceVnd || route.searchUrl) && <div className="flex items-center justify-between pt-2 border-t border-neutral-100">
                <div className="flex items-baseline gap-1">
                  {route.minPriceVnd && <span className="text-xs text-neutral-500">Từ</span>}
                  <span className="text-base font-bold text-[#00506a]">
                    {route.minPriceVnd ? formatVnd(route.minPriceVnd) : "Xem giá theo chuyến"}
                  </span>
                </div>

                {route.searchUrl && <Link
                  href={route.searchUrl}
                  className="text-xs font-semibold text-[#00506a] hover:underline flex items-center gap-0.5"
                >
                  <span>Xem chuyến</span>
                  <ChevronRight className="w-3.5 h-3.5" />
                </Link>}
              </div>}
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}
