import {
  ArrowRight,
  Headphones,
  RotateCcw,
  Sparkles,
  Ticket
} from "lucide-react";
import Link from "next/link";

/**
 * Khối Khám phá hành trình và 4 ưu điểm nền tảng chuẩn theo Figma 776:791.
 */
export function ExploreCardsSection() {
  return (
    <section className="mx-auto max-w-7xl px-4 py-12 sm:px-6 lg:px-8">
      {/* Tiêu đề & Link */}
      <div className="flex items-end justify-between pb-6">
        <div>
          <span className="text-xs font-bold tracking-wider text-vxn-teal-700 uppercase">
            KHÁM PHÁ
          </span>
          <h2 className="mt-1 text-2xl font-black text-vxn-ink sm:text-3xl">
            Chuẩn bị cho hành trình của bạn
          </h2>
        </div>
        <Link
            href="/explore"
          className="inline-flex items-center gap-1 text-sm font-semibold text-vxn-teal-700 hover:text-vxn-teal-800"
        >
          <span>Khám phá thêm</span>
          <ArrowRight className="h-4 w-4" />
        </Link>
      </div>

      {/* 2 Thẻ khám phá lớn (ảnh bên trái + nội dung bên phải) */}
      <div className="grid grid-cols-1 gap-6 md:grid-cols-2">
        {/* Thẻ 1: Khám phá miền Bắc */}
        <div className="flex overflow-hidden rounded-2xl border border-vxn-border bg-white shadow-2xs transition hover:shadow-md">
          <div
            className="w-2/5 shrink-0 bg-cover bg-center"
            style={{
              backgroundImage:
                "url('https://images.unsplash.com/photo-1528127269322-539801943592?auto=format&fit=crop&w=500&q=80')"
            }}
          />
          <div className="flex flex-col justify-between p-6">
            <div>
              <h3 className="text-xl font-bold text-vxn-ink">Cẩm nang xe khách</h3>
              <p className="mt-2 text-xs leading-relaxed text-vxn-fg-4">
                Đọc bài viết và kinh nghiệm để chuẩn bị cho chuyến đi.
              </p>
            </div>
            <div className="mt-4">
              <Link
              href="/explore"
                className="text-xs font-bold text-vxn-teal-700 hover:underline"
              >
                Khám phá &rarr;
              </Link>
            </div>
          </div>
        </div>

        {/* Thẻ 2: Chuyến đi đầu tiên */}
        <div className="flex overflow-hidden rounded-2xl border border-vxn-border bg-white shadow-2xs transition hover:shadow-md">
          <div
            className="w-2/5 shrink-0 bg-cover bg-center"
            style={{
              backgroundImage:
                "url('https://images.unsplash.com/photo-1544620347-c4fd4a3d5957?auto=format&fit=crop&w=500&q=80')"
            }}
          />
          <div className="flex flex-col justify-between p-6">
            <div>
              <h3 className="text-xl font-bold text-vxn-ink">Chuyến đi đầu tiên?</h3>
              <p className="mt-2 text-xs leading-relaxed text-vxn-fg-4">
                Tìm hiểu cách đặt vé, thanh toán và các câu hỏi thường gặp.
              </p>
            </div>
            <div className="mt-4">
              <Link
              href="/faq"
                className="text-xs font-bold text-vxn-teal-700 hover:underline"
              >
                Xem hướng dẫn &rarr;
              </Link>
            </div>
          </div>
        </div>
      </div>

      {/* 4 Ưu điểm nền tảng chuẩn text Figma */}
      <div className="mt-8 grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-4">
        {/* Lợi ích 1 */}
        <div className="rounded-xl border border-vxn-border bg-white p-5 shadow-2xs">
          <div className="flex h-10 w-10 items-center justify-center rounded-lg bg-teal-50 text-vxn-teal-700">
            <Ticket className="h-5 w-5" />
          </div>
          <h4 className="mt-3 text-sm font-bold text-vxn-ink">Vé điện tử QR</h4>
          <p className="mt-1 text-xs leading-relaxed text-vxn-fg-4">
            Nhận vé điện tử để xuất trình khi lên xe.
          </p>
        </div>

        {/* Lợi ích 2 - Theo A3 #6 trỏ /refund-policy */}
        <div className="rounded-xl border border-vxn-border bg-white p-5 shadow-2xs">
          <div className="flex h-10 w-10 items-center justify-center rounded-lg bg-teal-50 text-vxn-teal-700">
            <RotateCcw className="h-5 w-5" />
          </div>
          <h4 className="mt-3 text-sm font-bold text-vxn-ink">Chính sách hủy rõ ràng</h4>
          <p className="mt-1 text-xs leading-relaxed text-vxn-fg-4">
            Xem điều kiện hủy và hoàn tiền trước khi đặt.
          </p>
        </div>

        {/* Lợi ích 3 */}
        <div className="rounded-xl border border-vxn-border bg-white p-5 shadow-2xs">
          <div className="flex h-10 w-10 items-center justify-center rounded-lg bg-teal-50 text-vxn-teal-700">
            <Sparkles className="h-5 w-5" />
          </div>
          <h4 className="mt-3 text-sm font-bold text-vxn-ink">Tích điểm thành viên</h4>
          <p className="mt-1 text-xs leading-relaxed text-vxn-fg-4">
            Tích điểm sau chuyến đi, đổi điểm lấy voucher.
          </p>
          <Link
            href="/plus"
            className="mt-2 inline-block text-xs font-medium text-vxn-teal-700 hover:underline"
          >
            Tìm hiểu thêm &rarr;
          </Link>
        </div>

        {/* Lợi ích 4 */}
        <div className="rounded-xl border border-vxn-border bg-white p-5 shadow-2xs">
          <div className="flex h-10 w-10 items-center justify-center rounded-lg bg-teal-50 text-vxn-teal-700">
            <Headphones className="h-5 w-5" />
          </div>
          <h4 className="mt-3 text-sm font-bold text-vxn-ink">Hỗ trợ khách hàng</h4>
          <p className="mt-1 text-xs leading-relaxed text-vxn-fg-4">
            Gửi yêu cầu hỗ trợ theo vé đã đặt.
          </p>
          <Link href="/support" className="mt-2 inline-block text-xs font-medium text-vxn-teal-700 hover:underline">Trung tâm hỗ trợ &rarr;</Link>
        </div>
      </div>
    </section>
  );
}
