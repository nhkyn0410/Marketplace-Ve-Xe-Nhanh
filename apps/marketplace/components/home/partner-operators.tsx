import { Star } from "lucide-react";
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
      <section className="mx-auto w-full max-w-[1200px] px-4 py-8 sm:px-6 lg:px-14">
        <div className="flex items-center justify-between pb-4">
          <h2 className="text-xl font-extrabold text-[#0f172a] sm:text-2xl">
            Nhà xe đối tác
          </h2>
        </div>
        <FeatureUnavailableCompact
          endpoint="GET /catalog/featured-operators"
          title="Danh sách nhà xe đối tác chưa sẵn sàng"
        />
      </section>
    );
  }

  return (
    <section className="mx-auto w-full max-w-[1200px] px-4 py-8 sm:px-6 lg:px-14">
      {/* Tiêu đề mục */}
      <div className="flex items-end justify-between pb-5">
        <h2 className="text-xl font-extrabold text-[#0f172a] sm:text-2xl">
          Nhà xe đối tác
        </h2>
        <Link
          href="/operators/opr-phuongnam"
          className="text-xs font-bold text-[#00506a] hover:underline"
        >
          Xem các nhà xe
        </Link>
      </div>

      {/* Lưới 5 thẻ nhà xe tinh gọn chuẩn Figma */}
      <div className="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-5">
        {operators.map((operator) => (
          <Link
            key={operator.id}
            href={`/operators/${operator.id}`}
            className="group flex flex-col justify-between rounded-2xl border border-slate-200 bg-white p-4 shadow-2xs transition hover:border-[#00506a] hover:shadow-md"
          >
            <div>
              {operator.logoUrl ? (
                <img
                  src={operator.logoUrl}
                  alt={`Logo ${operator.name}`}
                  loading="lazy"
                  className="h-10 w-10 rounded-xl border border-slate-200 bg-white object-contain"
                />
              ) : (
                <div
                  className="flex h-10 w-10 items-center justify-center rounded-xl text-xs font-extrabold text-white"
                  style={{ backgroundColor: operator.accentColor ?? "#00506a" }}
                >
                  {operator.shortCode}
                </div>
              )}

              <h4 className="mt-3.5 text-xs font-bold text-[#0f172a] group-hover:text-[#00506a]">
                {operator.name}
              </h4>

              <div className="mt-1 flex items-center gap-1 text-[11px] text-slate-500">
                {operator.rating !== null && (
                  <>
                    <Star className="h-3 w-3 fill-[#f3a826] text-[#f3a826]" />
                    <span className="font-bold text-[#0f172a]">{operator.rating.toFixed(1)}</span>
                    <span>·</span>
                  </>
                )}
                <span>{operator.ratingCountText}</span>
              </div>
            </div>
          </Link>
        ))}
      </div>
    </section>
  );
}
