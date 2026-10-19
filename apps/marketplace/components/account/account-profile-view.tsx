"use client";

import React, { useState } from "react";
import Link from "next/link";
import {
  Pencil,
  Trash2,
  Plus,
  Info,
  Award,
  Tag,
  ArrowRight,
  Mail,
  Globe,
  Monitor,
  ChevronRight
} from "lucide-react";
import { Button } from "@vexenhanh/ui/components/button";
import type { UserProfileData } from "../../lib/data/types";
import { AccountSidebar } from "./account-sidebar";

export interface AccountProfileViewProps {
  readonly user?: UserProfileData;
  readonly isPreview?: boolean;
}

/**
 * Màn hình Tài khoản của tôi / Hồ sơ cá nhân chuẩn Figma node 1447:18295
 */
export const AccountProfileView: React.FC<AccountProfileViewProps> = ({
  user = {
    id: "usr-01",
    fullName: "Nguyễn Văn Khách",
    email: "khach.nguyen@gmail.com",
    phone: "0901 234 567",
    dateOfBirth: "12/03/1994",
    gender: "Nam",
    idNumber: "079 *** *** 234",
    tierName: "Hạng Bạc",
    points: 1250,
    periodPoints: 2450,
    pointsNeededNextTier: 2550,
    nextTierName: "Vàng",
    voucherCount: 3,
    savedPassengers: [
      {
        id: "sp-01",
        name: "Nguyễn Văn Khách (tôi)",
        phone: "0901 234 567",
        idNumber: "CCCD 079 *** *** 234",
        isSelf: true
      },
      {
        id: "sp-02",
        name: "Trần Thị Mai",
        phone: "0912 555 678",
        idNumber: "CCCD chưa có",
        isSelf: false
      },
      {
        id: "sp-03",
        name: "Nguyễn Minh Anh",
        phone: "0987 111 222",
        idNumber: "CCCD 079 *** *** 880",
        isSelf: false
      }
    ],
    securityMethods: {
      email: "khach.nguyen@gmail.com",
      googleLinked: true,
      googleLinkedDate: "02/09/2026",
      facebookLinked: false,
      appleLinked: false,
      activeSessionsCount: 3
    }
  },
  isPreview = false
}) => {
  const [actionNotice, setActionNotice] = useState<string | null>(null);

  const handleAction = (msg: string) => {
    setActionNotice(msg);
    setTimeout(() => setActionNotice(null), 3000);
  };

  const savedPassengers = user.savedPassengers ?? [];

  return (
    <div className="container mx-auto px-4 sm:px-6 py-6 max-w-7xl space-y-6">
      {/* Breadcrumb điều hướng */}
      <nav className="text-xs text-muted-foreground flex items-center gap-1.5">
        <Link href="/" className="hover:text-foreground">
          Trang chủ
        </Link>
        <span>›</span>
        <span className="text-foreground">Tài khoản</span>
        <span>›</span>
        <span className="text-foreground font-medium">Hồ sơ</span>
      </nav>

      {/* Thông báo thao tác nhanh nếu có */}
      {actionNotice && (
        <div className="p-3 rounded-xl bg-teal-50 dark:bg-teal-950/40 border border-teal-200 dark:border-teal-800 text-[#0F5B60] dark:text-teal-300 text-xs">
          {actionNotice}
        </div>
      )}

      {/* Bố cục 2 cột: Sidebar và Nội dung */}
      <div className="flex flex-col lg:flex-row gap-6 items-start">
        {/* Cột trái: Menu tài khoản */}
        <AccountSidebar activeTab="profile" user={user} isPreview={isPreview} />

        {/* Cột phải: Nội dung chính */}
        <div className="flex-1 w-full space-y-6">
          {/* Đầu trang tiêu đề */}
          <div className="space-y-1">
            <h1 className="text-2xl font-bold tracking-tight text-foreground">
              Tài khoản của tôi
            </h1>
            <p className="text-xs text-muted-foreground">
              Quản lý hồ sơ, hành khách thường đi và cách đăng nhập.
            </p>
          </div>

          {/* Khối 1: Hồ sơ cá nhân */}
          <div className="bg-white dark:bg-card rounded-2xl border border-border p-6 space-y-5 shadow-2xs">
            <div className="flex items-center justify-between">
              <h2 className="text-base font-bold text-foreground">
                Hồ sơ cá nhân
              </h2>
              <Button
                type="button"
                variant="outline"
                size="sm"
                onClick={() => handleAction("Chức năng chỉnh sửa thông tin cá nhân đang được hoàn thiện.")}
                className="h-8 px-3 rounded-xl text-xs gap-1.5"
              >
                <Pencil className="w-3.5 h-3.5" />
                <span>Chỉnh sửa</span>
              </Button>
            </div>

            {/* Grid 3 cột thông tin cá nhân */}
            <div className="grid grid-cols-1 md:grid-cols-3 gap-y-4 gap-x-6 text-xs">
              {/* Họ và tên */}
              <div className="space-y-1">
                <span className="text-muted-foreground">Họ và tên</span>
                <p className="font-semibold text-foreground text-sm">
                  {user.fullName}
                </p>
              </div>

              {/* Ngày sinh */}
              <div className="space-y-1">
                <span className="text-muted-foreground">Ngày sinh</span>
                <p className="font-semibold text-foreground text-sm">
                  {user.dateOfBirth ?? "12/03/1994"}
                </p>
              </div>

              {/* Giới tính */}
              <div className="space-y-1">
                <span className="text-muted-foreground">Giới tính</span>
                <p className="font-semibold text-foreground text-sm">
                  {user.gender ?? "Nam"}
                </p>
              </div>

              {/* Email */}
              <div className="space-y-1">
                <span className="text-muted-foreground">Email</span>
                <div className="flex items-center gap-2 flex-wrap">
                  <span className="font-semibold text-foreground text-sm">
                    {user.email}
                  </span>
                  <span className="px-2 py-0.5 rounded-md bg-emerald-50 dark:bg-emerald-950/40 text-emerald-700 dark:text-emerald-400 font-medium text-[11px] border border-emerald-200/50">
                    Đã xác minh
                  </span>
                </div>
              </div>

              {/* Số điện thoại */}
              <div className="space-y-1">
                <span className="text-muted-foreground">Số điện thoại</span>
                <p className="font-semibold text-foreground text-sm">
                  {user.phone}
                </p>
              </div>

              {/* CCCD / hộ chiếu */}
              <div className="space-y-1">
                <span className="text-muted-foreground">CCCD / hộ chiếu</span>
                <p className="font-semibold text-foreground text-sm">
                  {user.idNumber ?? "079 *** *** 234"}
                </p>
              </div>
            </div>

            {/* Dải thông báo nhỏ */}
            <div className="bg-[#EEF8FA] dark:bg-teal-950/30 rounded-xl p-3 flex items-center gap-2.5 text-xs text-[#0F5B60] dark:text-teal-300">
              <Info className="w-4 h-4 shrink-0" />
              <span>Đổi email cần xác minh bằng mã OTP gửi tới email mới.</span>
            </div>
          </div>

          {/* Khối 2: Banner VXN Plus */}
          <div className="bg-amber-50/70 dark:bg-amber-950/30 border border-amber-200/80 dark:border-amber-900/60 rounded-2xl p-5 flex flex-col md:flex-row items-start md:items-center justify-between gap-4 shadow-2xs">
            <div className="flex items-center gap-3.5">
              <div className="w-10 h-10 rounded-xl bg-amber-100 dark:bg-amber-900/50 text-amber-600 dark:text-amber-400 flex items-center justify-center shrink-0">
                <Award className="w-5 h-5" />
              </div>
              <div className="space-y-0.5">
                <h3 className="text-sm font-bold text-foreground">
                  {user.tierName} · {user.points.toLocaleString("vi-VN")} điểm khả dụng
                </h3>
                <p className="text-xs text-muted-foreground">
                  Đã tích {user.periodPoints?.toLocaleString("vi-VN") ?? "2.450"} điểm trong 12 tháng · cần thêm {user.pointsNeededNextTier?.toLocaleString("vi-VN") ?? "2.550"} điểm để lên hạng {user.nextTierName ?? "Vàng"}
                </p>
              </div>
            </div>

            <div className="flex items-center gap-2.5 w-full md:w-auto shrink-0">
              <Button
                type="button"
                variant="outline"
                size="sm"
                onClick={() => handleAction("Mở ví voucher.")}
                className="h-9 px-3.5 rounded-xl text-xs gap-1.5 bg-white dark:bg-card border-border"
              >
                <Tag className="w-3.5 h-3.5 text-amber-600" />
                <span>Ví voucher ({user.voucherCount})</span>
              </Button>
              <Button
                type="button"
                size="sm"
                onClick={() => handleAction("Xem chi tiết quyền lợi VXN Plus.")}
                className="h-9 px-3.5 rounded-xl text-xs gap-1.5 bg-[#0F5B60] hover:bg-[#0c474b] text-white"
              >
                <span>Xem VXN Plus</span>
                <ArrowRight className="w-3.5 h-3.5" />
              </Button>
            </div>
          </div>

          {/* Khối 3: Hành khách đã lưu (3 / 5) */}
          <div className="bg-white dark:bg-card rounded-2xl border border-border p-6 space-y-4 shadow-2xs">
            <div className="flex items-center justify-between">
              <div>
                <h2 className="text-base font-bold text-foreground">
                  Hành khách đã lưu ({savedPassengers.length} / 5)
                </h2>
                <p className="text-xs text-muted-foreground">
                  Dùng để điền nhanh thông tin khi đặt vé.
                </p>
              </div>
              <Button
                type="button"
                variant="outline"
                size="sm"
                onClick={() => handleAction("Chức năng thêm hành khách đang được kết nối.")}
                className="h-8 px-3 rounded-xl text-xs gap-1.5"
              >
                <Plus className="w-3.5 h-3.5" />
                <span>Thêm hành khách</span>
              </Button>
            </div>

            {/* Danh sách hành khách */}
            <div className="divide-y divide-border">
              {savedPassengers.map((passenger) => {
                const initial = passenger.name.charAt(0).toUpperCase();
                return (
                  <div
                    key={passenger.id}
                    className="py-3.5 flex items-center justify-between gap-4 first:pt-2 last:pb-1"
                  >
                    <div className="flex items-center gap-3">
                      <div className="w-9 h-9 rounded-full bg-slate-100 dark:bg-muted text-slate-700 dark:text-foreground font-semibold text-xs flex items-center justify-center shrink-0">
                        {initial}
                      </div>
                      <div className="space-y-0.5">
                        <p className="text-xs font-semibold text-foreground">
                          {passenger.name}
                        </p>
                        <p className="text-[11px] text-muted-foreground">
                          {passenger.phone} · {passenger.idNumber}
                        </p>
                      </div>
                    </div>

                    <div className="flex items-center gap-1">
                      <button
                        type="button"
                        onClick={() => handleAction(`Sửa thông tin hành khách ${passenger.name}`)}
                        aria-label="Sửa"
                        className="p-1.5 text-muted-foreground hover:text-foreground rounded-lg hover:bg-muted transition-colors"
                      >
                        <Pencil className="w-3.5 h-3.5" />
                      </button>
                      <button
                        type="button"
                        onClick={() => handleAction(`Xóa hành khách ${passenger.name}`)}
                        aria-label="Xóa"
                        className="p-1.5 text-muted-foreground hover:text-destructive rounded-lg hover:bg-destructive/10 transition-colors"
                      >
                        <Trash2 className="w-3.5 h-3.5" />
                      </button>
                    </div>
                  </div>
                );
              })}
            </div>
          </div>

          {/* Khối 4: Bảo mật và đăng nhập */}
          <div className="bg-white dark:bg-card rounded-2xl border border-border p-6 space-y-4 shadow-2xs">
            <div>
              <h2 className="text-base font-bold text-foreground">
                Bảo mật và đăng nhập
              </h2>
              <p className="text-xs text-muted-foreground">
                Tài khoản hành khách không dùng mật khẩu.
              </p>
            </div>

            <div className="divide-y divide-border">
              {/* 1. Mã OTP qua email */}
              <div className="py-3.5 flex items-center justify-between gap-4 first:pt-1">
                <div className="flex items-center gap-3">
                  <div className="w-9 h-9 rounded-full bg-slate-100 dark:bg-muted text-slate-600 dark:text-muted-foreground flex items-center justify-center shrink-0">
                    <Mail className="w-4 h-4" />
                  </div>
                  <div>
                    <p className="text-xs font-semibold text-foreground">
                      Mã OTP qua email
                    </p>
                    <p className="text-[11px] text-muted-foreground">
                      {user.email}
                    </p>
                  </div>
                </div>
                <div className="flex items-center gap-3">
                  <span className="px-2 py-0.5 rounded-md bg-emerald-50 dark:bg-emerald-950/40 text-emerald-700 dark:text-emerald-400 font-medium text-[11px] border border-emerald-200/50">
                    Đang dùng
                  </span>
                  <Link
                    href={isPreview ? "/verify-email?preview=ideal" : "/verify-email"}
                    className="text-xs font-medium text-[#0F5B60] hover:underline"
                  >
                    Đổi email
                  </Link>
                </div>
              </div>

              {/* 2. Google */}
              <div className="py-3.5 flex items-center justify-between gap-4">
                <div className="flex items-center gap-3">
                  <div className="w-9 h-9 rounded-full bg-slate-100 dark:bg-muted text-slate-600 dark:text-muted-foreground flex items-center justify-center shrink-0">
                    <Globe className="w-4 h-4" />
                  </div>
                  <div>
                    <p className="text-xs font-semibold text-foreground">
                      Google
                    </p>
                    <p className="text-[11px] text-muted-foreground">
                      Đã liên kết ngày {user.securityMethods?.googleLinkedDate ?? "02/09/2026"}
                    </p>
                  </div>
                </div>
                <div className="flex items-center gap-3">
                  <span className="px-2 py-0.5 rounded-md bg-slate-100 dark:bg-muted text-muted-foreground font-medium text-[11px]">
                    Đã liên kết
                  </span>
                  <button
                    type="button"
                    onClick={() => handleAction("Hủy liên kết tài khoản Google.")}
                    className="text-xs font-medium text-muted-foreground hover:text-destructive hover:underline"
                  >
                    Hủy liên kết
                  </button>
                </div>
              </div>

              {/* 3. Facebook */}
              <div className="py-3.5 flex items-center justify-between gap-4">
                <div className="flex items-center gap-3">
                  <div className="w-9 h-9 rounded-full bg-slate-100 dark:bg-muted text-slate-600 dark:text-muted-foreground flex items-center justify-center shrink-0">
                    <Globe className="w-4 h-4" />
                  </div>
                  <div>
                    <p className="text-xs font-semibold text-foreground">
                      Facebook
                    </p>
                    <p className="text-[11px] text-muted-foreground">
                      Chưa liên kết
                    </p>
                  </div>
                </div>
                <div>
                  <button
                    type="button"
                    onClick={() => handleAction("Liên kết tài khoản Facebook.")}
                    className="text-xs font-medium text-[#0F5B60] hover:underline"
                  >
                    Liên kết
                  </button>
                </div>
              </div>

              {/* 4. Apple */}
              <div className="py-3.5 flex items-center justify-between gap-4">
                <div className="flex items-center gap-3">
                  <div className="w-9 h-9 rounded-full bg-slate-100 dark:bg-muted text-slate-600 dark:text-muted-foreground flex items-center justify-center shrink-0">
                    <Globe className="w-4 h-4" />
                  </div>
                  <div>
                    <p className="text-xs font-semibold text-foreground">
                      Apple
                    </p>
                    <p className="text-[11px] text-muted-foreground">
                      Chưa liên kết
                    </p>
                  </div>
                </div>
                <div>
                  <button
                    type="button"
                    onClick={() => handleAction("Liên kết tài khoản Apple.")}
                    className="text-xs font-medium text-[#0F5B60] hover:underline"
                  >
                    Liên kết
                  </button>
                </div>
              </div>

              {/* 5. Phiên đăng nhập */}
              <div className="py-3.5 flex items-center justify-between gap-4 last:pb-1">
                <div className="flex items-center gap-3">
                  <div className="w-9 h-9 rounded-full bg-slate-100 dark:bg-muted text-slate-600 dark:text-muted-foreground flex items-center justify-center shrink-0">
                    <Monitor className="w-4 h-4" />
                  </div>
                  <div>
                    <p className="text-xs font-semibold text-foreground">
                      Phiên đăng nhập
                    </p>
                    <p className="text-[11px] text-muted-foreground">
                      {user.securityMethods?.activeSessionsCount ?? 3} thiết bị đang đăng nhập
                    </p>
                  </div>
                </div>
                <div>
                  <Link
                    href={isPreview ? "/account/sessions?preview=ideal" : "/account/sessions"}
                    className="inline-flex items-center gap-1 text-xs font-medium text-[#0F5B60] hover:underline"
                  >
                    <span>Quản lý</span>
                    <ChevronRight className="w-3.5 h-3.5" />
                  </Link>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};
