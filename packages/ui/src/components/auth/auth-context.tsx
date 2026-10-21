"use client";

import { createContext, useCallback, useContext, useEffect, useMemo, useState, type ReactNode } from "react";

import { ApiError, apiRequest, ensureCsrf, forgetCsrf, onSessionExpired } from "../../lib/auth/api-client";
import { forgetReauth } from "../../lib/auth/reauth";

/** Response `GET /auth/me` (05 API §7.1.2). */
export type AuthMe = {
  subjectId: string;
  scope: "passenger" | "operator" | "platform";
  role: string;
  username: string;
  sessionId: string;
  accessExpiresAt: string;
  mfaVerified: boolean;
  /** Quyền hiệu lực `resource:action` (TASK-IAM-007) — ẩn menu / nút; server vẫn kiểm từng request. */
  permissions: string[];
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

/** Chữ hiển thị riêng của từng cổng trong luồng đăng nhập (Figma nhà xe 830:1977, Admin 1664:24143). */
export type AuthPortalTexts = {
  /** Chân trang mọi màn xác thực. */
  footer: string;
  /** Tiêu đề + mô tả thẻ đăng nhập. */
  loginTitle: string;
  loginSubtitle: string;
  identifierPlaceholder: string;
  /** Nhãn chip hero các bước bảo mật. */
  securityChip: string;
  /** "tài khoản nhà xe" / "tài khoản quản trị". */
  accountNoun: string;
  /** "trang quản lý" / "cổng quản trị". */
  destination: string;
  /** Người cần liên hệ khi tài khoản bị khóa. */
  contact: string;
  /** Hero màn xác thực hai lớp khi đã bật TOTP: dòng màu nhấn, dòng thường, hai dòng mô tả. */
  mfaHero: { accent: string; title: string; description: [string, string] };
};

/**
 * Cấu hình một cổng web dùng chung luồng đăng nhập (TASK-IAM-006): Operator OS (Owner) hoặc Admin (Platform). Cùng
 * state machine, chỉ khác endpoint, phiên được nhận, chữ và bảng màu.
 */
export type AuthPortal = {
  id: "operator" | "admin";
  /** Endpoint đăng nhập bằng tên đăng nhập + mật khẩu của cổng. */
  loginPath: string;
  /** Phiên nào được vào cổng; phiên khác bị thu hồi ngay và về màn đăng nhập (lớp phòng thủ thứ hai). */
  accept: (me: AuthMe) => boolean;
  texts: AuthPortalTexts;
  /** Hero bên trái màn đăng nhập. */
  loginHero: ReactNode;
  /** Khối dưới form đăng nhập (vd. "Trở thành đối tác" của nhà xe, ghi chú của Admin). */
  loginFooter?: ReactNode;
  /** Có nút "Cần cấp lại mật khẩu?" mở hộp thoại hướng dẫn (Operator OS); Admin thay bằng ghi chú. */
  passwordHelp?: { title: string; description: [string, string] };
};

type AuthContextValue = {
  state: AuthState;
  portal: AuthPortal;
  /** Gọi sau khi login/MFA cấp phiên cookie: đọc lại `/auth/me` rồi vào app. */
  completeLogin: () => Promise<void>;
  logout: (notice?: AuthNotice) => Promise<void>;
};

const AuthContext = createContext<AuthContextValue | null>(null);

/**
 * State machine phiên web (06 UI §7): CSRF → `/auth/me` (401 thì refresh single-flight một lần) → chỉ phiên mà cổng
 * nhận (`portal.accept`) mới được vào; phiên khác bị thu hồi ngay và quay về đăng nhập.
 */
export function AuthProvider({ portal, children }: { portal: AuthPortal; children: ReactNode }) {
  const [state, setState] = useState<AuthState>({ status: "loading" });
  const { accept } = portal;

  const logout = useCallback(async (notice?: AuthNotice) => {
    try {
      await apiRequest("/auth/logout", { method: "POST", body: {} });
    } catch {
      // Phiên đã chết/không gọi được API: vẫn về màn đăng nhập; cookie hết hạn tự rơi.
    }
    forgetCsrf();
    // Bằng chứng xác nhận lại danh tính gắn với phiên vừa đóng.
    forgetReauth();
    setState({ status: "anonymous", notice });
  }, []);

  const loadSession = useCallback(async () => {
    setState((current) => (current.status === "error" ? { status: "loading" } : current));
    try {
      await ensureCsrf();
      const me = await apiRequest<AuthMe>("/auth/me");
      if (!accept(me)) {
        // Sai scope/role: lớp phòng thủ thứ hai, thông báo chung.
        await logout("invalid");
      } else {
        setState({ status: "authenticated", me });
      }
    } catch (error) {
      if (error instanceof ApiError && error.code === "AUTH_ORIGIN_FORBIDDEN") {
        // Cookie đang là phiên của cổng khác: API không cho dùng/thu hồi từ đây → chỉ về đăng nhập.
        setState({ status: "anonymous", notice: "invalid" });
      } else if (error instanceof ApiError && (error.status === 401 || error.status === 403)) {
        // Giữ thông báo hết phiên nếu listener vừa đặt; lần đầu vào trang thì không có thông báo.
        setState((current) => (current.status === "anonymous" ? current : { status: "anonymous" }));
      } else {
        setState({ status: "error" });
      }
    }
  }, [accept, logout]);

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

  const value = useMemo(
    () => ({ state, portal, completeLogin: loadSession, logout }),
    [state, portal, loadSession, logout]
  );
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

/**
 * Hỏi quyền của phiên hiện tại (TASK-IAM-007): `can("payout:manage")` hoặc "có một trong các quyền". Chỉ để ẩn / khóa
 * giao diện — API vẫn trả 403 nếu thiếu quyền.
 */
export function useCan(): (...permissions: string[]) => boolean {
  const { state } = useAuth();
  const granted = state.status === "authenticated" ? state.me.permissions : [];
  return useCallback((...permissions: string[]) => permissions.some((permission) => granted.includes(permission)), [granted]);
}

/** Cấu hình cổng hiện tại (chữ, bảng màu) cho các màn xác thực. */
export function useAuthPortal(): AuthPortal {
  return useAuth().portal;
}
