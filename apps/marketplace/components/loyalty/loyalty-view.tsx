"use client";

import { useState } from "react";
import Link from "next/link";
import { Award, Clock, Gift, History, Sparkles, Tag } from "lucide-react";
import { formatVnd } from "../../lib/format";
import type { LoyaltyRedemptionQuote } from "../../lib/data/types";
import type { LoyaltyProfileData } from "../../lib/data/loyalty-mappers";
import { LoyaltyRedemptionModal } from "./loyalty-redeem-modal";

/** Màu huy hiệu hạng theo thứ tự tăng dần (Figma: Đồng, Bạc, Vàng, Bạch kim). */
const TIER_BADGE = ["bg-[#b45309]", "bg-[#64748b]", "bg-[#e89b26]", "bg-vxn-ink"];

/**
 * Thuộc tính của component trang VXN Plus (SCR-PSG-33).
 */
export interface LoyaltyViewProps {
  readonly profile: LoyaltyProfileData;
  readonly defaultQuote?: LoyaltyRedemptionQuote;
  readonly initialOpenRedeemModal?: boolean;
  readonly isPreview?: boolean;
}

/**
 * Component hiển thị trang VXN Plus · Thành viên (SCR-PSG-33 - Figma 1448:19617).
 */
export function LoyaltyView({
  profile,
  defaultQuote,
  initialOpenRedeemModal = false,
  isPreview = false
}: LoyaltyViewProps) {
  const [isModalOpen, setIsModalOpen] = useState<boolean>(initialOpenRedeemModal);
  const hasPolicy = Boolean(profile.rules);
  const hasNextTier = Boolean(profile.nextTier);
  const isHighestTier = hasPolicy && profile.nextTier === null;
  const accountActive = !profile.memberStatus || profile.memberStatus === "ACTIVE";
  const canRedeem = !isPreview && accountActive && !!profile.rules && profile.availablePoints >= profile.rules.minRedeemPoints;

  // Tính phần trăm thanh tiến trình lên hạng tiếp theo
  const progressPercent = Math.min(
    100,
    profile.targetPointsForNextTier > 0 ? Math.round((profile.pointsIn12Months / profile.targetPointsForNextTier) * 100) : 0
  );

  return (
    <div className="space-y-8">
      {/* 1. Thẻ hạng hiện tại + điểm khả dụng — Figma 1448:19859 */}
      <div className="flex flex-col gap-6 rounded-2xl bg-vxn-teal-700 p-6 text-white sm:p-7 lg:flex-row lg:items-center">
        <div className="flex min-w-0 flex-1 flex-col gap-2.5">
          <p className="text-xs/[18px] font-semibold uppercase opacity-75">VXN Plus · Thành viên</p>
          <div className="flex flex-wrap items-center gap-3">
            <span className="flex size-11 shrink-0 items-center justify-center rounded-full bg-white text-vxn-teal-700">
              <Award className="size-[22px]" />
            </span>
            <h1 className="text-[30px]/[38px] font-semibold">{profile.currentTierName}</h1>
            <span className="rounded-full bg-white/25 px-2.5 py-1 text-xs/[18px] font-medium">{profile.multiplierText}</span>
          </div>
          <p className="text-sm/5 opacity-90">
            Đã tích {profile.pointsIn12Months.toLocaleString("vi-VN")}{hasNextTier ? ` / ${profile.targetPointsForNextTier.toLocaleString("vi-VN")}` : ""} điểm trong 12 tháng gần nhất
          </p>
          {hasNextTier && (
            <div className="h-2 w-full max-w-[620px] overflow-hidden rounded-full bg-white/25" role="progressbar" aria-valuenow={progressPercent} aria-valuemin={0} aria-valuemax={100} aria-label="Tiến độ lên hạng tiếp theo">
              <div className="h-full rounded-full bg-vxn-saffron-500 transition-all duration-500" style={{ width: `${progressPercent}%` }} />
            </div>
          )}
          <p className="text-[13px]/[19.5px] opacity-85">
            {hasNextTier ? <>Cần thêm {profile.pointsRequiredForNextTier.toLocaleString("vi-VN")} điểm để lên hạng {profile.nextTierName} ({profile.nextTierMultiplierText})</> : isHighestTier ? "Bạn đang ở hạng thành viên cao nhất." : "Chính sách xét hạng đang được cập nhật."}
          </p>
        </div>

        <div className="flex w-full shrink-0 flex-col gap-2 rounded-xl border border-vxn-border bg-white p-5 text-vxn-ink lg:w-[320px]">
          <p className="text-[13px]/[19.5px] text-vxn-fg-5">Điểm khả dụng</p>
          <p className="text-[30px]/[38px] font-semibold text-vxn-teal-700">{profile.availablePoints.toLocaleString("vi-VN")}</p>
          {hasPolicy && (
            <p className="text-[13px]/[19.5px] text-vxn-fg-5">Ước tính quy đổi ≈ {formatVnd(profile.estimatedVoucherVnd)} voucher</p>
          )}
          <button
            type="button"
            onClick={() => setIsModalOpen(true)}
            disabled={!canRedeem}
            className="h-11 w-full rounded-xl bg-vxn-saffron-600 px-3 text-sm font-medium tracking-[0.14px] text-[#0a2840] transition hover:bg-vxn-saffron-500 disabled:cursor-not-allowed disabled:opacity-60"
          >
            Đổi điểm lấy voucher
          </button>
          <div className="flex gap-2">
            <Link href="/plus/history" className="flex h-10 flex-1 items-center justify-center gap-1.5 rounded-lg border border-vxn-border bg-white px-2 text-sm font-semibold whitespace-nowrap text-foreground transition hover:bg-vxn-bg-mist">
              <History className="size-4" />
              Lịch sử điểm
            </Link>
            <Link href="/account/vouchers" className="flex h-10 flex-1 items-center justify-center gap-1.5 rounded-lg border border-vxn-border bg-white px-2 text-sm font-semibold whitespace-nowrap text-foreground transition hover:bg-vxn-bg-mist">
              <Tag className="size-4" />
              Ví voucher
            </Link>
          </div>
        </div>
      </div>
      {!canRedeem && <p className="-mt-4 text-[13px] text-vxn-fg-5">{isPreview ? "Đây là giao diện xem trước; thao tác đổi điểm đã được tắt." : !accountActive ? "Tài khoản hiện chưa thể đổi điểm." : !hasPolicy ? "Chưa có chính sách đổi điểm đang áp dụng. Số dư điểm của bạn vẫn được giữ nguyên." : `Bạn cần ít nhất ${profile.rules!.minRedeemPoints.toLocaleString("vi-VN")} điểm để đổi voucher.`}</p>}

      {/* 2. Bảng hạng thành viên — Figma 1448:19901 */}
      <div className="overflow-hidden rounded-2xl border border-vxn-border bg-white">
        <div className="px-5 pt-5 pb-4">
          <h2 className="text-lg/6 font-semibold text-vxn-ink">Bảng hạng thành viên</h2>
          <p className="mt-1 text-[13px]/[19.5px] text-vxn-fg-5">
            Hạng xét theo tổng điểm tích trong 12 tháng gần nhất (không trừ điểm đã đổi hoặc hết hạn).
          </p>
        </div>

        {profile.tiers.length > 0 ? <div className="overflow-x-auto">
          <table className="w-full text-left text-sm">
            <thead>
              <tr className="border-y border-vxn-border bg-vxn-bg-soft text-xs font-semibold text-vxn-fg-5 uppercase">
                <th className="px-5 py-2.5">Hạng</th>
                <th className="py-2.5">Mốc điểm tích trong 12 tháng</th>
                <th className="px-5 py-2.5 text-right">Hệ số tích điểm</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-vxn-border/70">
              {profile.tiers.map((t, index) => (
                <tr key={t.code} className={t.isCurrent ? "bg-vxn-teal-50" : undefined}>
                  <td className="px-5 py-3.5">
                    <div className="flex items-center gap-2.5">
                      <span className={`flex size-8 shrink-0 items-center justify-center rounded-full text-white ${TIER_BADGE[Math.min(index, TIER_BADGE.length - 1)]}`}>
                        <Award className="size-4" />
                      </span>
                      <span className="font-medium text-vxn-ink">{t.name}</span>
                      {t.isCurrent && <span className="rounded-md bg-success-50 px-2 py-0.5 text-xs font-medium text-success-600">Hạng của bạn</span>}
                    </div>
                  </td>
                  <td className="py-3.5 text-foreground">{t.minPoints12mText}</td>
                  <td className="px-5 py-3.5 text-right font-semibold text-vxn-ink">{t.multiplierText}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div> : <p className="px-5 pb-5 text-sm text-vxn-fg-3">Bảng hạng sẽ hiển thị khi chính sách thành viên được công bố.</p>}

        <p className="border-t border-vxn-border px-5 py-3 text-[13px]/[19.5px] text-vxn-fg-5">
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
          <h3 className="mt-3.5 text-sm font-semibold text-vxn-ink">Tích điểm sau mỗi chuyến</h3>
          <p className="mt-1.5 text-[13px]/[19.5px] text-vxn-fg-3">
            {profile.rules ? <>Mỗi {formatVnd(String(profile.rules.earnUnit))} tiền vé đủ điều kiện được tính theo hệ số tích điểm của hạng, sau khi chuyến hoàn thành.</> : "Quy tắc tích điểm sẽ hiển thị khi có chính sách đang áp dụng."}
          </p>
        </div>

        <div className="rounded-2xl border border-vxn-border bg-white p-5 shadow-2xs">
          <div className="flex h-9 w-9 items-center justify-center rounded-xl bg-cyan-50 text-cyan-700">
            <Gift className="h-4.5 w-4.5" />
          </div>
          <h3 className="mt-3.5 text-sm font-semibold text-vxn-ink">Đổi điểm lấy voucher</h3>
          <p className="mt-1.5 text-[13px]/[19.5px] text-vxn-fg-3">
            {profile.rules ? <>Đổi từ {profile.rules.minRedeemPoints.toLocaleString("vi-VN")} điểm lấy voucher giảm giá cố định. Voucher được lưu trong ví; áp dụng khi đặt vé trên web hiện chưa khả dụng.</> : "Chưa có chính sách quy đổi đang áp dụng."}
          </p>
        </div>

        <div className="rounded-2xl border border-vxn-border bg-white p-5 shadow-2xs">
          <div className="flex h-9 w-9 items-center justify-center rounded-xl bg-amber-50 text-amber-700">
            <Clock className="h-4.5 w-4.5" />
          </div>
          <h3 className="mt-3.5 text-sm font-semibold text-vxn-ink">Điểm có hạn dùng</h3>
          <p className="mt-1.5 text-[13px]/[19.5px] text-vxn-fg-3">
            {profile.rules ? <>Điểm có hạn dùng {profile.rules.pointExpiryMonths} tháng theo chính sách hiện tại. Xem biến động điểm trong lịch sử.</> : "Thời hạn điểm sẽ hiển thị cùng chính sách thành viên."}
          </p>
        </div>
      </div>

      {/* Modal đổi điểm */}
      {isModalOpen && <LoyaltyRedemptionModal
        isOpen={isModalOpen}
        onClose={() => setIsModalOpen(false)}
        profile={profile}
        defaultQuote={defaultQuote}
        isPreview={isPreview}
      />}
    </div>
  );
}
