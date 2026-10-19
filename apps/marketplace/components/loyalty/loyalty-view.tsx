"use client";

import { useState } from "react";
import Link from "next/link";
import { Award, Clock, Gift, History, Sparkles, Ticket } from "lucide-react";
import { formatVnd } from "../../lib/format";
import type { LoyaltyProfile, LoyaltyRedemptionQuote } from "../../lib/data/types";
import { LoyaltyRedemptionModal } from "./loyalty-redeem-modal";

/**
 * Thuộc tính của component trang VXN Plus (SCR-PSG-33).
 */
export interface LoyaltyViewProps {
  readonly profile: LoyaltyProfile;
  readonly defaultQuote?: LoyaltyRedemptionQuote;
  readonly initialOpenRedeemModal?: boolean;
}

/**
 * Component hiển thị trang VXN Plus · Thành viên (SCR-PSG-33 - Figma 1448:19617).
 */
export function LoyaltyView({
  profile,
  defaultQuote,
  initialOpenRedeemModal = false
}: LoyaltyViewProps) {
  const [isModalOpen, setIsModalOpen] = useState<boolean>(initialOpenRedeemModal);

  // Tính phần trăm thanh tiến trình lên hạng tiếp theo
  const progressPercent = Math.min(
    100,
    Math.round((profile.pointsIn12Months / profile.targetPointsForNextTier) * 100)
  );

  return (
    <div className="space-y-8">
      {/* 1. Banner Thẻ Thành Viên VXN Plus */}
      <div className="relative overflow-hidden rounded-3xl bg-linear-to-br from-[#0c2334] via-[#103046] to-[#1a4968] p-6 text-white shadow-xl sm:p-8 lg:p-10">
        {/* Nền trang trí trừu tượng */}
        <div className="pointer-events-none absolute -top-24 -right-24 h-72 w-72 rounded-full bg-teal-500/10 blur-3xl" />
        <div className="pointer-events-none absolute -bottom-24 -left-24 h-72 w-72 rounded-full bg-cyan-400/10 blur-3xl" />

        <div className="relative z-10">
          <div className="flex flex-wrap items-center justify-between gap-4">
            <div>
              <div className="inline-flex items-center gap-1.5 rounded-full bg-white/10 px-3 py-1 text-2xs font-bold tracking-wider text-teal-200 backdrop-blur-xs uppercase">
                <Sparkles className="h-3 w-3" />
                <span>VXN PLUS · THÀNH VIÊN</span>
              </div>
              <h1 className="mt-3 text-2xl font-black tracking-tight text-white sm:text-3xl lg:text-4xl">
                {profile.currentTierName}
              </h1>
            </div>

            <div className="inline-flex items-center gap-2 rounded-2xl border border-white/15 bg-white/10 px-4 py-2 text-xs font-bold text-white shadow-xs backdrop-blur-xs">
              <Award className="h-4 w-4 text-teal-300" />
              <span>{profile.multiplierText}</span>
            </div>
          </div>

          {/* Thanh tiến trình thăng hạng */}
          <div className="mt-8">
            <div className="flex flex-wrap items-center justify-between gap-2 text-xs">
              <span className="font-semibold text-slate-200">
                Đã tích {profile.pointsIn12Months.toLocaleString("vi-VN")} /{" "}
                {profile.targetPointsForNextTier.toLocaleString("vi-VN")} điểm trong 12 tháng gần nhất
              </span>
              <span className="text-2xs text-teal-200 font-bold">{progressPercent}%</span>
            </div>

            <div className="mt-2.5 h-2.5 w-full overflow-hidden rounded-full bg-white/15">
              <div
                className="h-full rounded-full bg-linear-to-r from-teal-400 to-cyan-300 transition-all duration-500"
                style={{ width: `${progressPercent}%` }}
              />
            </div>

            <p className="mt-2.5 text-xs text-slate-300">
              Cần thêm {profile.pointsRequiredForNextTier.toLocaleString("vi-VN")} điểm để lên hạng{" "}
              <span className="font-bold text-white">{profile.nextTierName}</span> (
              {profile.nextTierMultiplierText})
            </p>
          </div>
        </div>
      </div>

      {/* 2. Khối Điểm khả dụng & Các nút Thao tác */}
      <div className="flex flex-col gap-6 rounded-2xl border border-vxn-border bg-white p-6 shadow-2xs sm:p-8 lg:flex-row lg:items-center lg:justify-between">
        <div>
          <span className="text-xs font-bold text-vxn-fg-4 uppercase tracking-wider">
            Điểm khả dụng
          </span>
          <div className="mt-1 flex items-baseline gap-2">
            <span className="text-3xl font-black text-[#00506a] sm:text-4xl lg:text-5xl">
              {profile.availablePoints.toLocaleString("vi-VN")}
            </span>
            <span className="text-sm font-bold text-vxn-fg-3">điểm</span>
          </div>
          <p className="mt-1.5 text-xs font-medium text-vxn-fg-3">
            Ước tính quy đổi ≈{" "}
            <span className="font-bold text-vxn-teal-800">
              {formatVnd(profile.estimatedVoucherVnd)}
            </span>{" "}
            voucher
          </p>
        </div>

        <div className="flex flex-wrap items-center gap-3">
          <button
            type="button"
            onClick={() => setIsModalOpen(true)}
            className="inline-flex items-center gap-2 rounded-xl bg-[#00506a] px-5 py-3 text-xs font-bold text-white shadow-xs transition hover:bg-[#00476b]"
          >
            <Gift className="h-4 w-4" />
            <span>Đổi điểm lấy voucher</span>
          </button>

          <Link
            href="/plus/history"
            className="inline-flex items-center gap-2 rounded-xl border border-vxn-border bg-white px-4 py-3 text-xs font-bold text-vxn-fg-2 shadow-2xs transition hover:bg-vxn-bg-soft"
          >
            <History className="h-4 w-4 text-vxn-fg-4" />
            <span>Lịch sử điểm</span>
          </Link>

          <Link
            href="/account/vouchers"
            className="inline-flex items-center gap-2 rounded-xl border border-vxn-border bg-white px-4 py-3 text-xs font-bold text-vxn-fg-2 shadow-2xs transition hover:bg-vxn-bg-soft"
          >
            <Ticket className="h-4 w-4 text-vxn-fg-4" />
            <span>Ví voucher</span>
          </Link>
        </div>
      </div>

      {/* 3. Bảng hạng thành viên */}
      <div className="rounded-2xl border border-vxn-border bg-white p-6 shadow-2xs sm:p-8">
        <div>
          <h2 className="text-base font-black text-vxn-ink sm:text-lg">Bảng hạng thành viên</h2>
          <p className="mt-1 text-xs text-vxn-fg-4">
            Hạng xét theo tổng điểm tích trong 12 tháng gần nhất (không trừ điểm đã đổi hoặc hết hạn).
          </p>
        </div>

        <div className="mt-6 overflow-x-auto">
          <table className="w-full text-left text-xs">
            <thead>
              <tr className="border-b border-vxn-border text-2xs font-bold text-vxn-fg-4 uppercase">
                <th className="pb-3 pl-2">Hạng</th>
                <th className="pb-3 text-center sm:text-left">Mốc điểm tích trong 12 tháng</th>
                <th className="pb-3 text-right pr-2">Hệ số tích điểm</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-vxn-border/60">
              {profile.tiers.map((t) => (
                <tr
                  key={t.code}
                  className={`transition ${t.isCurrent ? "bg-teal-50/50 font-semibold" : "hover:bg-vxn-bg-soft/40"}`}
                >
                  <td className="py-4 pl-2 font-bold text-vxn-ink">
                    <div className="flex items-center gap-2">
                      <span>{t.name}</span>
                      {t.isCurrent && (
                        <span className="rounded-full bg-vxn-teal-700 px-2 py-0.5 text-2xs font-bold text-white">
                          Hạng của bạn
                        </span>
                      )}
                    </div>
                  </td>
                  <td className="py-4 text-vxn-fg-3 text-center sm:text-left">
                    {t.minPoints12mText}
                  </td>
                  <td className="py-4 pr-2 text-right font-black text-vxn-teal-800">
                    {t.multiplierText}
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>

        <p className="mt-4 text-2xs text-vxn-fg-4">
          Ở phiên bản hiện tại, hạng chỉ quyết định hệ số tích điểm. Hạng được cập nhật khi điểm thay
          đổi và theo định kỳ.
        </p>
      </div>

      {/* 4. Ba khối quyền lợi & nguyên tắc hoạt động */}
      <div className="grid grid-cols-1 gap-5 md:grid-cols-3">
        <div className="rounded-2xl border border-vxn-border bg-white p-5 shadow-2xs">
          <div className="flex h-9 w-9 items-center justify-center rounded-xl bg-teal-50 text-vxn-teal-700">
            <Sparkles className="h-4.5 w-4.5" />
          </div>
          <h3 className="mt-3.5 text-sm font-bold text-vxn-ink">Tích điểm sau mỗi chuyến</h3>
          <p className="mt-1.5 text-xs leading-relaxed text-vxn-fg-3">
            Điểm được cộng một lần cho mỗi đơn khi chuyến hoàn thành, tính trên số tiền bạn thực trả
            nhân với hệ số hạng.
          </p>
        </div>

        <div className="rounded-2xl border border-vxn-border bg-white p-5 shadow-2xs">
          <div className="flex h-9 w-9 items-center justify-center rounded-xl bg-cyan-50 text-cyan-700">
            <Gift className="h-4.5 w-4.5" />
          </div>
          <h3 className="mt-3.5 text-sm font-bold text-vxn-ink">Đổi điểm lấy voucher</h3>
          <p className="mt-1.5 text-xs leading-relaxed text-vxn-fg-3">
            Đổi từ 100 điểm lấy voucher giảm giá cố định, dùng cho mọi tuyến và mọi nhà xe. Điểm đã
            đổi không hoàn lại.
          </p>
        </div>

        <div className="rounded-2xl border border-vxn-border bg-white p-5 shadow-2xs">
          <div className="flex h-9 w-9 items-center justify-center rounded-xl bg-amber-50 text-amber-700">
            <Clock className="h-4.5 w-4.5" />
          </div>
          <h3 className="mt-3.5 text-sm font-bold text-vxn-ink">Điểm có hạn dùng</h3>
          <p className="mt-1.5 text-xs leading-relaxed text-vxn-fg-3">
            Điểm tích trước được dùng và hết hạn trước. Bật thông báo để được nhắc trước khi điểm hết
            hạn.
          </p>
        </div>
      </div>

      {/* Modal đổi điểm */}
      <LoyaltyRedemptionModal
        isOpen={isModalOpen}
        onClose={() => setIsModalOpen(false)}
        profile={profile}
        defaultQuote={defaultQuote}
      />
    </div>
  );
}
