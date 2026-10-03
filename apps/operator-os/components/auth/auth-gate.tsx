"use client";

import type { ReactNode } from "react";

import { useAuth } from "../../lib/auth/auth-context";
import { AuthLoading, AuthPage, NoticeDialog } from "./auth-ui";
import { LoginFlow } from "./login-flow";

/**
 * Chặn mọi màn nghiệp vụ cho tới khi có phiên Owner hợp lệ (06 UI §7). Đăng nhập hiển thị ngay tại URL
 * đang mở nên sau khi vào được app người dùng ở lại đúng trang — không có tham số redirect để lạm dụng.
 */
export function AuthGate({ children }: { children: ReactNode }) {
  const { state, completeLogin } = useAuth();

  if (state.status === "loading") {
    return <AuthLoading label="Đang kiểm tra phiên đăng nhập…" />;
  }
  if (state.status === "error") {
    return (
      <AuthPage languageChip={false}>
        <main className="flex-1" />
        <NoticeDialog
          tone="danger"
          title="Không thể kết nối"
          description={["Chưa kiểm tra được phiên đăng nhập.", "Vui lòng kiểm tra kết nối và thử lại."]}
          actionLabel="Thử lại"
          onAction={() => void completeLogin()}
        />
      </AuthPage>
    );
  }
  if (state.status === "anonymous") {
    // `key`: thông báo mới (hết phiên, phiên không hợp lệ) phải dựng lại luồng từ bước đầu để hiển thị.
    return <LoginFlow key={state.notice ?? ""} notice={state.notice} onAuthenticated={completeLogin} />;
  }
  return children;
}
