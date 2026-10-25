"use client";

import React, { useState } from "react";
import Link from "next/link";
import { Monitor, Smartphone, ShieldCheck, LogOut, Check, AlertCircle } from "lucide-react";
import { Button } from "@vexenhanh/ui/components/button";
import type { UserProfileData, UserSessionItem } from "../../lib/data/types";
import { revokeSession, revokeAllOtherSessions } from "../../lib/data/auth";
import { AccountSidebar } from "./account-sidebar";

export interface AccountSessionsViewProps {
  readonly user?: UserProfileData;
  readonly initialSessions?: readonly UserSessionItem[];
  readonly isPreview?: boolean;
}

/**
 * Màn hình Phiên đăng nhập / Thiết bị chuẩn Figma node 1448:18809
 */
export const AccountSessionsView: React.FC<AccountSessionsViewProps> = ({
  user,
  initialSessions = [
    {
      id: "sess-01",
      deviceName: "Chrome trên Windows",
      deviceType: "desktop",
      ipAddress: "113.161.***.***",
      locationText: "TP. Hồ Chí Minh",
      loginDateText: "08/10/2026",
      lastActiveText: "Hoạt động vừa xong",
      isCurrent: true
    },
    {
      id: "sess-02",
      deviceName: "Ứng dụng Vé Xe Nhanh trên Android",
      deviceType: "mobile",
      ipAddress: "14.169.***.***",
      locationText: "TP. Hồ Chí Minh",
      loginDateText: "02/10/2026",
      lastActiveText: "Hoạt động 2 giờ trước",
      isCurrent: false
    },
    {
      id: "sess-03",
      deviceName: "Safari trên iPhone",
      deviceType: "mobile",
      ipAddress: "27.72.***.***",
      locationText: "Đà Lạt",
      loginDateText: "21/09/2026",
      lastActiveText: "Hoạt động 3 ngày trước",
      isCurrent: false
    }
  ],
  isPreview = false
}) => {
  const [sessions, setSessions] = useState<UserSessionItem[]>([...initialSessions]);
  const [isRevoking, setIsRevoking] = useState(false);
  const [statusMessage, setStatusMessage] = useState<{
    readonly type: "success" | "error";
    readonly text: string;
  } | null>(null);

  const handleRevokeOne = async (session: UserSessionItem) => {
    if (isRevoking) return;
    setStatusMessage(null);

    if (isPreview) {
      setSessions((prev) => prev.filter((s) => s.id !== session.id));
      setStatusMessage({
        type: "success",
        text: `Đã thu hồi phiên đăng nhập trên ${session.deviceName}.`
      });
      setTimeout(() => setStatusMessage(null), 3000);
      return;
    }

    setIsRevoking(true);
    try {
      const res = await revokeSession(session.id);
      if (res.status === "ok") {
        setSessions((prev) => prev.filter((item) => item.id !== session.id));
        setStatusMessage({ type: "success", text: `Đã thu hồi phiên trên ${session.deviceName}.` });
      } else if (res.status === "unavailable") {
        setStatusMessage({
          type: "error",
          text: "Chưa thể thu hồi phiên. Vui lòng thử lại sau."
        });
      } else if (res.status === "error") {
        setStatusMessage({
          type: "error",
          text: res.message ?? "Không thể thu hồi phiên đăng nhập."
        });
      }
    } catch {
      setStatusMessage({
        type: "error",
        text: "Đã xảy ra lỗi khi thu hồi phiên đăng nhập."
      });
    } finally {
      setIsRevoking(false);
    }
  };

  const handleRevokeOthers = async () => {
    if (isRevoking) return;
    setStatusMessage(null);

    if (isPreview) {
      setSessions((prev) => prev.filter((s) => s.isCurrent));
      setStatusMessage({
        type: "success",
        text: "Đã đăng xuất tất cả các phiên khác thành công."
      });
      setTimeout(() => setStatusMessage(null), 3000);
      return;
    }

    setIsRevoking(true);
    try {
      const res = await revokeAllOtherSessions();
      if (res.status === "ok") {
        setSessions((prev) => prev.filter((item) => item.isCurrent));
        setStatusMessage({ type: "success", text: `Đã đăng xuất ${res.data.revokedCount} phiên khác.` });
      } else if (res.status === "unavailable") {
        setStatusMessage({
          type: "error",
          text: "Chưa thể đăng xuất các phiên khác. Vui lòng thử lại sau."
        });
      } else if (res.status === "error") {
        setStatusMessage({
          type: "error",
          text: res.message ?? "Không thể đăng xuất các phiên khác."
        });
      }
    } catch {
      setStatusMessage({
        type: "error",
        text: "Đã xảy ra lỗi khi đăng xuất các phiên khác."
      });
    } finally {
      setIsRevoking(false);
    }
  };

  return (
    <div className="mx-auto w-full px-4 sm:px-6 py-6 max-w-[1200px] space-y-6 lg:px-14">
      {/* Breadcrumb điều hướng */}
      <nav className="text-xs text-muted-foreground flex items-center gap-1.5">
        <Link href="/" className="hover:text-foreground">
          Trang chủ
        </Link>
        <span>›</span>
        <Link href={isPreview ? "/account?preview=ideal" : "/account"} className="hover:text-foreground">
          Tài khoản
        </Link>
        <span>›</span>
        <Link href={isPreview ? "/account?preview=ideal" : "/account"} className="hover:text-foreground">
          Bảo mật
        </Link>
        <span>›</span>
        <span className="text-foreground font-medium">Phiên đăng nhập</span>
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
        <AccountSidebar activeTab="security" user={user} isPreview={isPreview} />

        {/* Cột phải: Danh sách phiên đăng nhập */}
        <div className="flex-1 w-full space-y-6">
          {/* Đầu trang tiêu đề & nút đăng xuất tất cả */}
          <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
            <div className="space-y-1">
              <h1 className="text-2xl font-bold tracking-tight text-foreground">
                Phiên đăng nhập
              </h1>
              <p className="text-xs text-muted-foreground">
                Các thiết bị đang đăng nhập tài khoản của bạn. Thu hồi phiên lạ để bảo vệ tài khoản.
              </p>
            </div>

            <Button
              type="button"
              variant="outline"
              size="sm"
              disabled={isRevoking || !sessions.some((session) => !session.isCurrent)}
              onClick={handleRevokeOthers}
              className="h-9 px-3.5 rounded-xl text-xs gap-1.5 text-destructive border-destructive/30 hover:bg-destructive/10 hover:border-destructive/50 shrink-0"
            >
              <LogOut className="w-3.5 h-3.5" />
              <span>Đăng xuất tất cả phiên khác</span>
            </Button>
          </div>

          {/* Danh sách phiên (chuẩn Figma node 1448:19133) */}
          <div className="bg-white dark:bg-card rounded-2xl border border-border shadow-2xs divide-y divide-border overflow-hidden">
            {sessions.length === 0 && <p className="p-5 text-sm text-muted-foreground">Không có phiên đăng nhập đang hoạt động.</p>}
            {sessions.map((session) => {
              const Icon = session.deviceType === "mobile" ? Smartphone : Monitor;

              return (
                <div
                  key={session.id}
                  className="p-5 flex items-center justify-between gap-4"
                >
                  <div className="flex items-start sm:items-center gap-3.5">
                    {/* Icon thiết bị */}
                    <div className="w-10 h-10 rounded-xl bg-slate-100 dark:bg-muted text-slate-700 dark:text-foreground flex items-center justify-center shrink-0 mt-0.5 sm:mt-0">
                      <Icon className="w-5 h-5" />
                    </div>

                    <div className="space-y-1">
                      <div className="flex items-center gap-2 flex-wrap">
                        <span className="text-sm font-semibold text-foreground">
                          {session.deviceName}
                        </span>
                        {session.isCurrent && (
                          <span className="px-2 py-0.5 rounded-md bg-emerald-50 dark:bg-emerald-950/40 text-emerald-700 dark:text-emerald-400 font-medium text-[11px] border border-emerald-200/50">
                            Phiên hiện tại
                          </span>
                        )}
                      </div>

                      <p className="text-xs text-muted-foreground">
                        IP {session.ipAddress} · Đăng nhập {session.loginDateText ?? "Không có dữ liệu"} · Hoạt động lần cuối {session.lastActiveText}
                      </p>
                    </div>
                  </div>

                  {/* Nút thu hồi phiên đối với các thiết bị khác */}
                  {!session.isCurrent && (
                    <Button
                      type="button"
                      variant="outline"
                      size="sm"
                      disabled={isRevoking}
                      onClick={() => handleRevokeOne(session)}
                      className="h-8 px-3 rounded-xl text-xs gap-1.5 border-border hover:bg-muted text-foreground shrink-0"
                    >
                      <LogOut className="w-3.5 h-3.5" />
                      <span>Thu hồi</span>
                    </Button>
                  )}
                </div>
              );
            })}
          </div>

          {/* Dải ghi chú an toàn bảo mật */}
          <div className="bg-[#EEF8FA] dark:bg-teal-950/30 rounded-2xl p-4 flex items-start gap-3 text-left shadow-2xs">
            <ShieldCheck className="w-4 h-4 text-[#0F5B60] shrink-0 mt-0.5" />
            <p className="text-xs text-[#0F5B60] dark:text-teal-200 leading-relaxed">
              Phiên bị thu hồi sẽ phải đăng nhập lại. Bạn có thể đăng xuất tài khoản trên trình duyệt hiện tại từ menu tài khoản.
            </p>
          </div>
        </div>
      </div>
    </div>
  );
};
