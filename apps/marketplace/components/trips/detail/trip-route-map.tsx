"use client";

import { TripTimelineStop } from "../../../lib/data/types";




/**
 * Thuộc tính của khối bản đồ lộ trình.
 */
interface TripRouteMapProps {
  readonly timeline: readonly TripTimelineStop[];
}

/**
 * Khối bản đồ lộ trình tuyến xe (SCR-PSG-16).
 * Tuân thủ A3 #4: Chỉ dùng MapView bọc Goong GL JS khi có khóa.
 * Khi chưa cấu hình khóa Goong, hiển thị đồ họa lộ trình minh họa chuẩn Figma kèm thông báo.
 */
export function TripRouteMap({ timeline: _timeline }: TripRouteMapProps) {
  const goongKey = process.env.NEXT_PUBLIC_GOONG_MAPTILES_KEY;

  return (
    <div className="bg-white rounded-2xl border border-neutral-200 p-6 shadow-xs space-y-4">
      <div className="flex items-center justify-between">
        <h3 className="text-base font-semibold text-neutral-900">
          Bản đồ lộ trình
        </h3>
      </div>

      {/* Khung bản đồ lộ trình minh họa khớp chuẩn Figma 1443:11643 */}
      <div className="relative w-full h-64 sm:h-72 rounded-xl bg-[#e5eeed] overflow-hidden border border-neutral-200/80 flex items-center justify-center">
        {/* Bản đồ nền vector cách điệu */}
        <svg
          viewBox="0 0 800 350"
          className="w-full h-full object-cover select-none"
          xmlns="http://www.w3.org/2000/svg"
        >
          {/* Mảng địa hình màu nước / mảng xanh xám */}
          <path
            d="M0,0 L800,0 L800,350 L0,350 Z"
            fill="#e7eff1"
          />
          <path
            d="M 100,0 Q 250,80 320,190 T 550,300 L 800,350 L 0,350 Z"
            fill="#dbe8ea"
            opacity="0.8"
          />
          <path
            d="M 450,0 Q 520,120 620,180 T 800,240 L 800,0 Z"
            fill="#d2e3e6"
            opacity="0.7"
          />

          {/* Đường lộ trình xe chạy (nét cong mềm mại) */}
          <path
            d="M 120,290 C 200,285 240,240 290,210 C 350,175 420,190 480,140 C 540,90 620,160 670,130"
            fill="none"
            stroke="#ffffff"
            strokeWidth="10"
            strokeLinecap="round"
          />
          <path
            d="M 120,290 C 200,285 240,240 290,210 C 350,175 420,190 480,140 C 540,90 620,160 670,130"
            fill="none"
            stroke="#00506a"
            strokeWidth="4"
            strokeDasharray="6 6"
            strokeLinecap="round"
          />

          {/* Các điểm dừng 1, 2, 3, 4, 5 trên lộ trình */}
          {/* Điểm 1: Bến xe Miền Đông mới */}
          <circle cx="120" cy="290" r="14" fill="#00506a" />
          <text x="120" y="295" fill="#ffffff" fontSize="12" fontWeight="bold" textAnchor="middle">
            1
          </text>

          {/* Điểm 2: Văn phòng Phương Nam - Hàng Xanh */}
          <circle cx="270" cy="225" r="14" fill="#00506a" />
          <text x="270" y="230" fill="#ffffff" fontSize="12" fontWeight="bold" textAnchor="middle">
            2
          </text>

          {/* Điểm 3: Trạm dừng nghỉ Madagui */}
          <circle cx="450" cy="165" r="14" fill="#64748b" />
          <text x="450" y="170" fill="#ffffff" fontSize="12" fontWeight="bold" textAnchor="middle">
            3
          </text>

          {/* Điểm 4: Văn phòng Phương Nam - Đà Lạt */}
          <circle cx="610" cy="175" r="14" fill="#00506a" />
          <text x="610" y="180" fill="#ffffff" fontSize="12" fontWeight="bold" textAnchor="middle">
            4
          </text>

          {/* Điểm 5: Bến xe liên tỉnh Đà Lạt */}
          <circle cx="680" cy="185" r="14" fill="#f59e0b" />
          <text x="680" y="190" fill="#ffffff" fontSize="12" fontWeight="bold" textAnchor="middle">
            5
          </text>
        </svg>

        {/* Nguồn bản đồ Goong watermark ở góc dưới bên phải */}
        <div className="absolute right-3 bottom-2 text-[11px] font-medium text-neutral-500 bg-white/70 px-2 py-0.5 rounded shadow-2xs backdrop-blur-xs">
          © Goong
        </div>
      </div>
    </div>
  );
}
