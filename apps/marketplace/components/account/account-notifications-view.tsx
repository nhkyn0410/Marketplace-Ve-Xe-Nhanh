"use client";

import React, { useState } from "react";
import Link from "next/link";
import { Lock, Check, AlertCircle, RotateCcw } from "lucide-react";
import { Button } from "@vexenhanh/ui/components/button";
import type {
  UserProfileData,
  NotificationSettingsData,
  NotificationSettingItem
} from "../../lib/data/types";
import { updateNotificationSettings } from "../../lib/data/auth";
import { AccountSidebar } from "./account-sidebar";

export interface AccountNotificationsViewProps {
  readonly user?: UserProfileData;
  readonly initialSettings?: NotificationSettingsData;
  readonly isPreview?: boolean;
}

/**
 * Màn hình Cài đặt thông báo chuẩn Figma node 1447:18811
 */
export const AccountNotificationsView: React.FC<AccountNotificationsViewProps> = ({
  user,
  initialSettings = {
    mandatoryItems: [
      {
        id: "mand-01",
        title: "Bảo mật tài khoản",
        description: "Đăng nhập mới, đổi email, thu hồi phiên.",
        isMandatory: true,
        emailEnabled: true,
        pushEnabled: true
      },
      {
        id: "mand-02",
        title: "Vé và đặt chỗ",
        description: "Xác nhận đặt vé, vé điện tử, check-in.",
        isMandatory: true,
        emailEnabled: true,
        pushEnabled: true
      },
      {
        id: "mand-03",
        title: "Thanh toán và hoàn tiền",
        description: "Kết quả thanh toán, tiến độ hoàn tiền.",
        isMandatory: true,
        emailEnabled: true,
        pushEnabled: true
      },
      {
        id: "mand-04",
        title: "Đổi / hủy chuyến",
        description: "Nhà xe đổi giờ, đổi xe hoặc hủy chuyến bạn đã đặt.",
        isMandatory: true,
        emailEnabled: true,
        pushEnabled: true
      },
      {
        id: "mand-05",
        title: "Khiếu nại và tranh chấp",
        description: "Phản hồi mới, yêu cầu bổ sung, kết quả xử lý.",
        isMandatory: true,
        emailEnabled: true,
        pushEnabled: true
      }
    ],
    optionalItems: [
      {
        id: "opt-01",
        title: "Nhắc trước giờ khởi hành",
        description: "Nhắc trước chuyến 24 giờ và 2 giờ.",
        isMandatory: false,
        emailEnabled: true,
        pushEnabled: true
      },
      {
        id: "opt-02",
        title: "Điểm VXN Plus và hạng thành viên",
        description: "Cộng điểm sau chuyến, thay đổi hạng.",
        isMandatory: false,
        emailEnabled: true,
        pushEnabled: false
      },
      {
        id: "opt-03",
        title: "Điểm sắp hết hạn",
        description: "Nhắc trước khi điểm hết hạn.",
        isMandatory: false,
        emailEnabled: true,
        pushEnabled: true
      },
      {
        id: "opt-04",
        title: "Khuyến mãi và voucher",
        description: "Mã khuyến mãi mới, voucher sắp hết hạn.",
        isMandatory: false,
        emailEnabled: false,
        pushEnabled: false
      },
      {
        id: "opt-05",
        title: "Tin tức và cẩm nang",
        description: "Bài viết mới ở trang Khám phá.",
        isMandatory: false,
        emailEnabled: false,
        pushEnabled: false
      }
    ]
  },
  isPreview = false
}) => {
  const [optionalSettings, setOptionalSettings] = useState<NotificationSettingItem[]>(() => [
    ...initialSettings.optionalItems
  ]);
  const [statusMessage, setStatusMessage] = useState<{
    readonly type: "success" | "error";
    readonly text: string;
  } | null>(null);
  const [isSaving, setIsSaving] = useState<boolean>(false);

  const handleToggle = (id: string, channel: "email" | "push") => {
    setOptionalSettings((prev) =>
      prev.map((item) => {
        if (item.id === id) {
          return {
            ...item,
            emailEnabled: channel === "email" ? !item.emailEnabled : item.emailEnabled,
            pushEnabled: channel === "push" ? !item.pushEnabled : item.pushEnabled
          };
        }
        return item;
      })
    );
  };

  const handleReset = () => {
    setOptionalSettings([...initialSettings.optionalItems]);
    setStatusMessage({
      type: "success",
      text: "Đã khôi phục cài đặt thông báo về mặc định."
    });
    setTimeout(() => setStatusMessage(null), 3000);
  };

  const handleSave = async () => {
    setStatusMessage(null);

    if (isPreview) {
      setStatusMessage({
        type: "success",
        text: "Đã lưu cài đặt thông báo thành công."
      });
      setTimeout(() => setStatusMessage(null), 3000);
      return;
    }

    setIsSaving(true);
    try {
      const res = await updateNotificationSettings({
        mandatoryItems: initialSettings.mandatoryItems,
        optionalItems: optionalSettings
      });
      if (res.status === "unavailable") {
        setStatusMessage({
          type: "error",
          text: "Chức năng lưu cài đặt thông báo đang chờ kết nối cổng API backend (PUT /me/notification-preferences)."
        });
      } else if (res.status === "error") {
        setStatusMessage({
          type: "error",
          text: res.message ?? "Không thể lưu cài đặt thông báo. Vui lòng thử lại."
        });
      }
    } catch {
      setStatusMessage({
        type: "error",
        text: "Đã xảy ra lỗi khi lưu cài đặt thông báo."
      });
    } finally {
      setIsSaving(false);
    }
  };

  return (
    <div className="container mx-auto px-4 sm:px-6 py-6 max-w-7xl space-y-6">
      {/* Breadcrumb */}
      <nav className="text-xs text-muted-foreground flex items-center gap-1.5">
        <Link href="/" className="hover:text-foreground">
          Trang chủ
        </Link>
        <span>›</span>
        <Link href={isPreview ? "/account?preview=ideal" : "/account"} className="hover:text-foreground">
          Tài khoản
        </Link>
        <span>›</span>
        <span className="text-foreground font-medium">Thông báo</span>
      </nav>

      {/* Thông báo kết quả thao tác */}
      {statusMessage && (
        <div
          className={`p-3.5 rounded-xl text-xs flex items-center gap-2 ${
            statusMessage.type === "success"
              ? "bg-emerald-50 dark:bg-emerald-950/40 border border-emerald-200 text-emerald-800 dark:text-emerald-300"
              : "bg-destructive/10 border border-destructive/20 text-destructive"
          }`}
        >
          {statusMessage.type === "success" ? (
            <Check className="w-4 h-4 shrink-0" />
          ) : (
            <AlertCircle className="w-4 h-4 shrink-0" />
          )}
          <span>{statusMessage.text}</span>
        </div>
      )}

      {/* Bố cục 2 cột */}
      <div className="flex flex-col lg:flex-row gap-6 items-start">
        {/* Cột trái: Sidebar tài khoản */}
        <AccountSidebar activeTab="notifications" user={user} isPreview={isPreview} />

        {/* Cột phải: Bảng cài đặt thông báo */}
        <div className="flex-1 w-full space-y-6">
          {/* Đầu trang tiêu đề */}
          <div className="space-y-1">
            <h1 className="text-2xl font-bold tracking-tight text-foreground">
              Cài đặt thông báo
            </h1>
            <p className="text-xs text-muted-foreground">
              Chọn kênh nhận cho từng loại thông báo. Thông báo bắt buộc luôn được gửi và không thể tắt.
            </p>
          </div>

          {/* Bảng thông báo chuẩn Figma node 1447:19125 */}
          <div className="bg-white dark:bg-card rounded-2xl border border-border shadow-2xs overflow-hidden">
            {/* 1. Phần BẮT BUỘC */}
            <div className="bg-slate-50 dark:bg-muted/40 px-6 py-3 border-b border-border flex items-center justify-between text-xs font-semibold text-muted-foreground">
              <span className="tracking-wider uppercase text-[11px]">BẮT BUỘC</span>
              <div className="flex items-center gap-8 sm:gap-14 pr-2">
                <span className="w-12 text-center tracking-wider uppercase text-[11px]">EMAIL</span>
                <span className="w-16 text-center tracking-wider uppercase text-[11px]">PUSH (APP)</span>
              </div>
            </div>

            <div className="divide-y divide-border px-6">
              {initialSettings.mandatoryItems.map((item) => (
                <div
                  key={item.id}
                  className="py-4 flex items-center justify-between gap-4"
                >
                  <div className="space-y-0.5 max-w-lg">
                    <div className="flex items-center gap-1.5">
                      <span className="text-xs font-semibold text-foreground">
                        {item.title}
                      </span>
                      <Lock className="w-3 h-3 text-muted-foreground" />
                    </div>
                    <p className="text-xs text-muted-foreground">
                      {item.description}
                    </p>
                  </div>

                  <div className="flex items-center gap-8 sm:gap-14 pr-2 shrink-0">
                    {/* Toggle Email bắt buộc (disabled, luôn bật) */}
                    <div className="w-12 flex justify-center">
                      <div className="w-10 h-5 rounded-full bg-slate-300 dark:bg-slate-700 p-0.5 cursor-not-allowed opacity-80 flex items-center">
                        <div className="w-4 h-4 rounded-full bg-white shadow-xs ml-auto" />
                      </div>
                    </div>
                    {/* Toggle Push bắt buộc (disabled, luôn bật) */}
                    <div className="w-16 flex justify-center">
                      <div className="w-10 h-5 rounded-full bg-slate-300 dark:bg-slate-700 p-0.5 cursor-not-allowed opacity-80 flex items-center">
                        <div className="w-4 h-4 rounded-full bg-white shadow-xs ml-auto" />
                      </div>
                    </div>
                  </div>
                </div>
              ))}
            </div>

            {/* 2. Phần TÙY CHỌN */}
            <div className="bg-slate-50 dark:bg-muted/40 px-6 py-3 border-y border-border flex items-center justify-between text-xs font-semibold text-muted-foreground">
              <span className="tracking-wider uppercase text-[11px]">TÙY CHỌN</span>
              <div className="flex items-center gap-8 sm:gap-14 pr-2">
                <span className="w-12 text-center tracking-wider uppercase text-[11px]">EMAIL</span>
                <span className="w-16 text-center tracking-wider uppercase text-[11px]">PUSH (APP)</span>
              </div>
            </div>

            <div className="divide-y divide-border px-6">
              {optionalSettings.map((item) => (
                <div
                  key={item.id}
                  className="py-4 flex items-center justify-between gap-4"
                >
                  <div className="space-y-0.5 max-w-lg">
                    <p className="text-xs font-semibold text-foreground">
                      {item.title}
                    </p>
                    <p className="text-xs text-muted-foreground">
                      {item.description}
                    </p>
                  </div>

                  <div className="flex items-center gap-8 sm:gap-14 pr-2 shrink-0">
                    {/* Toggle Email tùy chọn */}
                    <div className="w-12 flex justify-center">
                      <button
                        type="button"
                        role="switch"
                        aria-checked={item.emailEnabled}
                        onClick={() => handleToggle(item.id, "email")}
                        className={`w-10 h-5 rounded-full p-0.5 transition-colors focus:outline-none focus:ring-2 focus:ring-[#0F5B60] flex items-center ${
                          item.emailEnabled
                            ? "bg-[#0F5B60]"
                            : "bg-slate-200 dark:bg-slate-700"
                        }`}
                      >
                        <div
                          className={`w-4 h-4 rounded-full bg-white shadow-xs transition-transform ${
                            item.emailEnabled ? "ml-auto" : "mr-auto"
                          }`}
                        />
                      </button>
                    </div>

                    {/* Toggle Push tùy chọn */}
                    <div className="w-16 flex justify-center">
                      <button
                        type="button"
                        role="switch"
                        aria-checked={item.pushEnabled}
                        onClick={() => handleToggle(item.id, "push")}
                        className={`w-10 h-5 rounded-full p-0.5 transition-colors focus:outline-none focus:ring-2 focus:ring-[#0F5B60] flex items-center ${
                          item.pushEnabled
                            ? "bg-[#0F5B60]"
                            : "bg-slate-200 dark:bg-slate-700"
                        }`}
                      >
                        <div
                          className={`w-4 h-4 rounded-full bg-white shadow-xs transition-transform ${
                            item.pushEnabled ? "ml-auto" : "mr-auto"
                          }`}
                        />
                      </button>
                    </div>
                  </div>
                </div>
              ))}
            </div>
          </div>

          {/* Hàng nút bấm thao tác */}
          <div className="flex items-center justify-end gap-3 pt-2">
            <Button
              type="button"
              variant="outline"
              onClick={handleReset}
              className="h-10 px-4 rounded-xl text-xs gap-1.5 border-border bg-white dark:bg-card"
            >
              <RotateCcw className="w-3.5 h-3.5" />
              <span>Khôi phục mặc định</span>
            </Button>

            <Button
              type="button"
              disabled={isSaving}
              onClick={handleSave}
              className="h-10 px-5 rounded-xl text-xs gap-1.5 bg-[#0F5B60] hover:bg-[#0c474b] text-white font-medium"
            >
              <Check className="w-4 h-4" />
              <span>{isSaving ? "Đang lưu..." : "Lưu thay đổi"}</span>
            </Button>
          </div>
        </div>
      </div>
    </div>
  );
};
