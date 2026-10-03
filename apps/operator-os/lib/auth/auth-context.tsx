"use client";

import { createContext, useCallback, useContext, useEffect, useMemo, useState, type ReactNode } from "react";

import { ApiError, apiRequest, ensureCsrf, forgetCsrf, onSessionExpired } from "./api-client";

/** Response `GET /auth/me` (05 API §7.1.2). */
export type AuthMe = {
  subjectId: string;
  scope: "passenger" | "operator" | "platform";
  role: string;
  username: string;
  sessionId: string;
  accessExpiresAt: string;
  mfaVerified: boolean;
  operatorId?: string;
  operatorSlug?: string;
};

/** Lý do về lại màn đăng nhập — giao diện tự chọn nội dung thông báo (không nhắc app Nhân viên, UI v0.11). */
export type AuthNotice = "expired" | "invalid";

export type AuthState =
  | { status: "loading" }
  | { status: "anonymous"; notice?: AuthNotice }
  | { status: "authenticated"; me: AuthMe }
  /** Không kiểm được phiên do mạng/máy chủ (không phải hết phiên) — UI cho thử lại. */
  | { status: "error" };

type AuthContextValue = {
  state: AuthState;
  /** Gọi sau khi login/MFA cấp phiên cookie: đọc lại `/auth/me` rồi vào app. */
  completeLogin: () => Promise<void>;
  logout: (notice?: AuthNotice) => Promise<void>;
};

// v1 Operator OS chỉ dành cho Owner (06 UI §4/§7, TASK-IAM-006 Q4).
const OPERATOR_OWNER = "OPERATOR_OWNER";

const AuthContext = createContext<AuthContextValue | null>(null);

/**
 * State machine phiên web (06 UI §7): CSRF → `/auth/me` (401 thì refresh single-flight một lần) →
 * chỉ Owner scope `operator` mới được vào; phiên khác bị thu hồi ngay và quay về đăng nhập.
 */
export function AuthProvider({ children }: { children: ReactNode }) {
  const [state, setState] = useState<AuthState>({ status: "loading" });

  const logout = useCallback(async (notice?: AuthNotice) => {
    try {
      await apiRequest("/auth/logout", { method: "POST", body: {} });
    } catch {
      // Phiên đã chết/không gọi được API: vẫn về màn đăng nhập; cookie hết hạn tự rơi.
    }
    forgetCsrf();
    setState({ status: "anonymous", notice });
  }, []);

  const loadSession = useCallback(async () => {
    setState((current) => (current.status === "error" ? { status: "loading" } : current));
    try {
      await ensureCsrf();
      const me = await apiRequest<AuthMe>("/auth/me");
      if (me.scope !== "operator" || me.role !== OPERATOR_OWNER) {
        // Sai scope/role (nhân viên đã bị chặn ở cổng API riêng): lớp phòng thủ thứ hai, thông báo chung.
        await logout("invalid");
      } else {
        setState({ status: "authenticated", me });
      }
    } catch (error) {
      if (error instanceof ApiError && error.code === "AUTH_ORIGIN_FORBIDDEN") {
        // Cookie đang là phiên của cổng khác (Admin): API không cho dùng/thu hồi từ đây → chỉ về đăng nhập.
        setState({ status: "anonymous", notice: "invalid" });
      } else if (error instanceof ApiError && (error.status === 401 || error.status === 403)) {
        // Giữ thông báo hết phiên nếu listener vừa đặt; lần đầu vào trang thì không có thông báo.
        setState((current) => (current.status === "anonymous" ? current : { status: "anonymous" }));
      } else {
        setState({ status: "error" });
      }
    }
  }, [logout]);

  useEffect(() => {
    // Chỉ báo "hết hạn" khi người dùng đang ở trong app; khách mới mở trang thì chỉ thấy form đăng nhập.
    onSessionExpired(() =>
      setState((current) =>
        current.status === "authenticated" ? { status: "anonymous", notice: "expired" } : current
      )
    );
    void loadSession();
    return () => onSessionExpired(null);
  }, [loadSession]);

  const value = useMemo(() => ({ state, completeLogin: loadSession, logout }), [state, loadSession, logout]);
  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>;
}

/** Truy cập trạng thái phiên và hành động login/logout. */
export function useAuth(): AuthContextValue {
  const value = useContext(AuthContext);
  if (!value) {
    throw new Error("useAuth phải nằm trong <AuthProvider>.");
  }
  return value;
}
