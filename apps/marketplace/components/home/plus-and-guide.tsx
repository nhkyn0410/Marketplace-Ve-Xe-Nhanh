import Link from "next/link";
import { HandbookArticleItem } from "../../lib/data/types";
import { FeatureUnavailableCompact } from "../states";

/**
 * Thuộc tính của khối VXN Plus & Cẩm nang xe khách.
 */
export interface PlusAndGuideSectionProps {
  readonly articles?: readonly HandbookArticleItem[];
  readonly isUnavailable?: boolean;
}

/**
 * Thumbnail ảnh cho từng bài viết cẩm nang chuẩn Figma 776:791.
 */
const ARTICLE_THUMBNAILS: readonly string[] = [
  "/images/article-1.png",
  "/images/article-2.png",
  "/images/article-3.png"
];

/**
 * Khối Banner Vé Xe Nhanh Plus & Cẩm nang xe khách chuẩn theo Figma 776:791.
 */
export function PlusAndGuideSection({
  articles,
  isUnavailable = false
}: PlusAndGuideSectionProps) {
  return (
    <section className="mx-auto w-full max-w-[1120px] px-4 pt-4 pb-14 sm:px-6 lg:px-8">
      <div className="grid grid-cols-1 gap-8 lg:grid-cols-12 lg:items-center">
        {/* Banner VXN Plus bên trái (7 cột) */}
        <div className="flex flex-col justify-between rounded-2xl bg-gradient-to-br from-[#dff3fa] via-[#e4f9eb] to-[#f8f5d7] p-7 sm:p-8 lg:col-span-7">
          <div>
            <span className="text-xs font-bold tracking-widest text-[#0f172a] uppercase">
              HẠNG THÀNH VIÊN
            </span>

            <h3 className="mt-4 text-2xl font-extrabold text-[#0f172a] sm:text-[28px]">
              Tích điểm cùng Vé xe nhanh
            </h3>

            <p className="mt-3 text-sm leading-relaxed text-slate-700">
              Tích điểm sau chuyến đi hoàn thành.
              <br />
              Đổi điểm lấy voucher giảm giá.
            </p>
          </div>

          <div className="mt-6 flex justify-end">
            <Link
              href="/plus"
              className="inline-flex h-11 items-center justify-center rounded-xl bg-[#00506a] px-8 text-xs font-bold text-white shadow-xs transition hover:bg-[#003f54]"
            >
              Khám phá ngay
            </Link>
          </div>
        </div>

        {/* Danh sách Cẩm nang xe khách bên phải (5 cột) */}
        <div className="flex flex-col justify-between lg:col-span-5">
          <div>
            <div className="flex items-center justify-between pb-3">
              <h3 className="text-base font-extrabold text-[#0f172a]">
                Cẩm nang xe khách
              </h3>
              <Link
                href="/explore"
                className="text-xs font-bold text-[#00506a] hover:underline"
              >
                Tin tức &rarr;
              </Link>
            </div>

            {isUnavailable || !articles || articles.length === 0 ? (
              <div className="pt-2">
                <FeatureUnavailableCompact
                  endpoint="GET /content/articles?tag=handbook"
                  title="Bài viết cẩm nang xe khách chưa sẵn sàng"
                />
              </div>
            ) : (
              <div className="divide-y divide-slate-100">
                {articles.map((article, idx) => (
                  <Link
                    key={article.id}
                    href={`/explore/${article.slug}`}
                    className="group flex items-center gap-3.5 py-3 transition hover:opacity-85"
                  >
                    <div
                      className="h-14 w-16 shrink-0 rounded-xl bg-cover bg-center shadow-2xs"
                      style={{
                        backgroundImage: `url('${ARTICLE_THUMBNAILS[idx % ARTICLE_THUMBNAILS.length]}')`
                      }}
                    />
                    <div className="min-w-0 flex-1">
                      <h4 className="line-clamp-2 text-xs font-bold leading-snug text-[#0f172a] group-hover:text-[#00506a]">
                        {article.title}
                      </h4>
                      <p className="mt-1 text-[11px] text-slate-500">
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
