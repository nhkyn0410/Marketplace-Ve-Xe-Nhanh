import { ArrowRight } from "lucide-react";
import Link from "next/link";
import { HandbookArticleItem } from "../../lib/data/types";

/**
 * Thuộc tính của khối VXN Plus & Cẩm nang xe khách.
 */
export interface PlusAndGuideSectionProps {
  readonly articles?: readonly HandbookArticleItem[];
  readonly isUnavailable?: boolean;
}

/**
 * Khối Banner Vé Xe Nhanh Plus & Cẩm nang xe khách chuẩn theo Figma 776:791.
 */
export function PlusAndGuideSection({
  articles,
  isUnavailable = false
}: PlusAndGuideSectionProps) {
  return (
    <section className="mx-auto max-w-7xl px-4 py-12 sm:px-6 lg:px-8">
      <div className="grid grid-cols-1 gap-8 lg:grid-cols-12">
        {/* Banner VXN Plus bên trái (5 cột) */}
        <div className="relative flex flex-col justify-between overflow-hidden rounded-2xl border border-teal-100 bg-gradient-to-br from-[#e6f7f2] via-[#f0fbf7] to-[#fdf7e7] p-8 shadow-2xs lg:col-span-5">
          <div>
            <span className="text-xs font-bold tracking-wider text-vxn-fg-4 uppercase">
              VXN PLUS
            </span>

            <h3 className="mt-4 text-2xl font-black text-vxn-ink sm:text-3xl">
              Tích điểm cùng Vé xe nhanh
            </h3>

            <p className="mt-4 text-sm leading-relaxed text-vxn-fg-2">
              Tích điểm sau chuyến đi hoàn thành.
              <br />
              Đổi điểm lấy voucher giảm giá.
            </p>
          </div>

          <div className="mt-8">
            <Link
              href="/plus"
              className="inline-flex items-center justify-center rounded-xl bg-[#00506a] px-6 py-2.5 text-sm font-bold text-white shadow-xs transition hover:bg-[#00476b]"
            >
              <span>Khám phá ngay</span>
            </Link>
          </div>
        </div>

        {/* Danh sách Cẩm nang xe khách bên phải (7 cột) */}
        <div className="flex flex-col justify-between rounded-2xl border border-vxn-border bg-white p-6 shadow-2xs lg:col-span-7">
          <div>
            <div className="flex items-center justify-between border-b border-vxn-border/60 pb-4">
              <h3 className="text-lg font-bold text-vxn-ink">Cẩm nang xe khách</h3>
              <Link
              href="/explore"
                className="inline-flex items-center text-xs font-semibold text-vxn-teal-700 hover:underline"
              >
                <span>Tin tức</span>
                <ArrowRight className="ml-1 h-3 w-3" />
              </Link>
            </div>

            {isUnavailable || !articles || articles.length === 0 ? (
              <div className="pt-4">
                <p className="text-sm text-vxn-fg-4">{isUnavailable ? "Chưa tải được bài viết. Bạn có thể thử lại tại mục Khám phá." : "Chưa có bài viết được xuất bản."}</p>
              </div>
            ) : (
              <div className="mt-2 divide-y divide-vxn-border/60">
                {articles.slice(0, 4).map((article) => (
                  <Link
                    key={article.id}
                    href={`/explore/${article.slug}`}
                    className="group flex items-center gap-4 py-3.5 transition hover:bg-vxn-bg-soft/60 rounded-xl px-2"
                  >
                    <div className="flex-1 overflow-hidden">
                      <h4 className="truncate text-sm font-bold text-vxn-ink group-hover:text-vxn-teal-700">
                        {article.title}
                      </h4>
                      <p className="mt-0.5 text-xs text-vxn-fg-4">
                        {article.category}
                      </p>
                    </div>
                  </Link>
                ))}
              </div>
            )}
          </div>
        </div>
      </div>
    </section>
  );
}
