import {
  Phone,
  RotateCcw,
  ShieldCheck,
  Star
} from "lucide-react";
import Link from "next/link";

/**
 * Khối Khám phá hành trình và 4 ưu điểm nền tảng chuẩn theo Figma 776:791.
 */
export function ExploreCardsSection() {
  return (
    <section className="pt-8 pb-4">
      <div className="mx-auto w-full max-w-[1200px] px-4 sm:px-6 lg:px-14">
        {/* Tiêu đề & Link */}
        <div className="flex items-end justify-between pb-5">
          <div>
            <span className="text-xs font-bold tracking-wider text-[#d9881c] uppercase">
              KHÁM PHÁ
            </span>
            <h2 className="mt-1 text-2xl font-extrabold text-[#0f172a] sm:text-[28px]">
              Hành trình • Văn hóa • Ẩm thực
            </h2>
          </div>
          <Link
            href="/explore"
            className="text-xs font-bold text-[#00506a] hover:underline"
          >
            Khám phá thêm
          </Link>
        </div>

        {/* 2 Thẻ khám phá lớn (ảnh bên trái + nội dung bên phải) */}
        <div className="grid grid-cols-1 gap-6 md:grid-cols-2">
          {/* Thẻ 1: Khám phá miền Bắc */}
          <div className="flex min-h-[168px] overflow-hidden rounded-2xl border border-slate-200 bg-white shadow-2xs transition hover:shadow-md">
            <div
              className="w-[175px] shrink-0 bg-cover bg-center sm:w-[190px]"
              style={{
                backgroundImage: "url('/images/explore-north.png')"
              }}
            />
            <div className="flex flex-1 flex-col justify-center p-6">
              <h3 className="text-lg font-extrabold text-[#0f172a]">
                Khám phá miền Bắc
              </h3>
              <p className="mt-1.5 text-xs leading-relaxed text-slate-500">
                Tìm chuyến theo lịch trình của bạn.
              </p>
              <div className="mt-3">
                <Link
                  href="/explore"
                  className="text-xs font-bold text-[#00506a] hover:underline"
                >
                  Khám phá
                </Link>
              </div>
            </div>
          </div>

          {/* Thẻ 2: Chuyến đi đầu tiên */}
          <div className="flex min-h-[168px] overflow-hidden rounded-2xl border border-slate-200 bg-white shadow-2xs transition hover:shadow-md">
            <div
              className="w-[175px] shrink-0 bg-cover bg-center sm:w-[190px]"
              style={{
                backgroundImage: "url('/images/explore-first-trip.png')"
              }}
            />
            <div className="flex flex-1 flex-col justify-center p-6">
              <h3 className="text-lg font-extrabold text-[#0f172a]">
                Chuyến đi đầu tiên?
              </h3>
              <p className="mt-1.5 text-xs leading-relaxed text-slate-500">
                Chọn tuyến và ngày đi để tìm chuyến phù hợp.
              </p>
              <div className="mt-3">
                <Link
                  href="/trips"
                  className="text-xs font-bold text-[#00506a] hover:underline"
                >
                  Tìm chuyến phù hợp
                </Link>
              </div>
            </div>
          </div>
        </div>
      </div>

      {/* Dải 4 ưu điểm nền tảng trên nền xanh nhạt chuẩn Figma */}
      <div className="mt-8 bg-[#f4f8fb] py-8">
        <div className="mx-auto grid w-full max-w-[1200px] grid-cols-1 gap-6 px-4 sm:grid-cols-2 sm:px-6 lg:grid-cols-4 lg:px-14">
          {/* Lợi ích 1 */}
          <div className="flex items-start gap-3.5">
            <div className="flex h-10 w-10 shrink-0 items-center justify-center rounded-xl border border-slate-200/80 bg-white text-[#00506a] shadow-2xs">
              <ShieldCheck className="h-4.5 w-4.5" />
            </div>
            <div>
              <h4 className="text-xs font-bold text-[#0f172a]">Vé điện tử QR</h4>
              <p className="mt-1 text-xs leading-relaxed text-slate-500">
                Nhận vé điện tử để xuất trình khi lên xe.
              </p>
            </div>
          </div>

          {/* Lợi ích 2 */}
          <div className="flex items-start gap-3.5">
            <div className="flex h-10 w-10 shrink-0 items-center justify-center rounded-xl border border-slate-200/80 bg-white text-[#00506a] shadow-2xs">
              <RotateCcw className="h-4.5 w-4.5" />
            </div>
            <div>
              <h4 className="text-xs font-bold text-[#0f172a]">Chính sách hủy rõ ràng</h4>
              <p className="mt-1 text-xs leading-relaxed text-slate-500">
                Xem điều kiện hủy và hoàn tiền trước khi đặt.
              </p>
            </div>
          </div>

          {/* Lợi ích 3 */}
          <div className="flex items-start gap-3.5">
            <div className="flex h-10 w-10 shrink-0 items-center justify-center rounded-xl border border-slate-200/80 bg-white text-[#00506a] shadow-2xs">
              <Star className="h-4.5 w-4.5" />
            </div>
            <div>
              <h4 className="text-xs font-bold text-[#0f172a]">Tích điểm thành viên</h4>
              <p className="mt-1 text-xs leading-relaxed text-slate-500">
                Tích điểm sau chuyến đi, đổi điểm lấy voucher.
              </p>
            </div>
          </div>

          {/* Lợi ích 4 */}
          <div className="flex items-start gap-3.5">
            <div className="flex h-10 w-10 shrink-0 items-center justify-center rounded-xl border border-slate-200/80 bg-white text-[#00506a] shadow-2xs">
              <Phone className="h-4.5 w-4.5" />
            </div>
            <div>
              <h4 className="text-xs font-bold text-[#0f172a]">Hỗ trợ khách hàng</h4>
              <p className="mt-1 text-xs leading-relaxed text-slate-500">
                Liên hệ hỗ trợ qua ứng dụng và hotline.
              </p>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}
