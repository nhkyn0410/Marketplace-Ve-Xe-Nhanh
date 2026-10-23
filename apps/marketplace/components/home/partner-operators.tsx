import { ArrowRight, Star } from "lucide-react";
import Link from "next/link";
import { FeaturedOperatorItem } from "../../lib/data/types";
import { FeatureUnavailableCompact } from "../states";

/**
 * Thuộc tính của khối Nhà xe đối tác.
 */
export interface PartnerOperatorsSectionProps {
  readonly operators?: readonly FeaturedOperatorItem[];
  readonly isUnavailable?: boolean;
}

/**
 * Khối Nhà xe đối tác tiêu biểu trên trang chủ chuẩn theo Figma 776:791.
 */
export function PartnerOperatorsSection({
  operators,
  isUnavailable = false
}: PartnerOperatorsSectionProps) {
  if (isUnavailable || !operators || operators.length === 0) {
    return (
      <section className="mx-auto max-w-7xl px-4 py-12 sm:px-6 lg:px-8">
        <div className="flex items-center justify-between pb-4">
          <div>
            <span className="text-xs font-bold tracking-wider text-vxn-teal-700 uppercase">
              NHÀ XE ĐỐI TÁC
            </span>
            <h2 className="text-2xl font-black text-vxn-ink">
          Nhà xe đồng hành cùng bạn
            </h2>
          </div>
        </div>
        <FeatureUnavailableCompact
          endpoint="GET /catalog/featured-operators"
          title="Danh sách nhà xe đối tác chưa sẵn sàng"
        />
      </section>
    );
  }

  return (
    <section className="mx-auto max-w-7xl px-4 py-12 sm:px-6 lg:px-8">
      {/* Tiêu đề mục */}
      <div className="flex items-end justify-between pb-6">
        <div>
          <h2 className="text-2xl font-black text-vxn-ink sm:text-3xl">
            Nhà xe đối tác
          </h2>
        </div>
        <Link
          href="/trips"
          className="inline-flex items-center gap-1 text-sm font-semibold text-vxn-teal-700 hover:text-vxn-teal-800"
        >
          <span>Xem các nhà xe</span>
          <ArrowRight className="h-4 w-4" />
        </Link>
      </div>

      {/* Lưới 5 thẻ nhà xe tinh gọn chuẩn Figma */}
      <div className="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-5">
        {operators.map((operator) => (
          <Link
            key={operator.id}
            href={`/operators/${operator.id}`}
            className="group flex flex-col justify-between rounded-xl border border-vxn-border bg-white p-5 shadow-2xs transition hover:border-vxn-teal-500 hover:shadow-md"
          >
            <div>
              <div
                className="flex h-12 w-12 items-center justify-center rounded-xl text-base font-black text-white shadow-xs"
                style={{ backgroundColor: operator.accentColor ?? "#00506a" }}
              >
                {operator.shortCode}
              </div>

              <h4 className="mt-4 text-sm font-bold text-vxn-ink group-hover:text-vxn-teal-700">
                {operator.name}
              </h4>

              <div className="mt-1.5 flex items-center gap-1 text-xs text-vxn-fg-4">
                <Star className="h-3.5 w-3.5 fill-amber-400 text-amber-500" />
                <span className="font-bold text-vxn-ink">{operator.rating.toFixed(1)}</span>
                <span>•</span>
                <span>{operator.ratingCountText}</span>
              </div>
            </div>
          </Link>
        ))}
      </div>
    </section>
  );
}
