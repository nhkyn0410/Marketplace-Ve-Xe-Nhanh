"use client";

import {
  type AuthMe,
  type AuthPortal,
  AuthProvider as PortalAuthProvider
} from "@vexenhanh/ui/components/auth/auth-context";
import { LoginHero } from "@vexenhanh/ui/components/auth/auth-ui";
import Link from "next/link";
import type { ReactNode } from "react";

export type { AuthMe, AuthNotice, AuthState } from "@vexenhanh/ui/components/auth/auth-context";
export { useAuth } from "@vexenhanh/ui/components/auth/auth-context";

// v1 Operator OS chỉ dành cho Owner (06 UI §4/§7, TASK-IAM-006 Q4).
const OPERATOR_OWNER = "OPERATOR_OWNER";

/** Cổng nhà xe: đăng nhập Owner, chữ và màu theo Figma "Giao diện nhà xe" (section 830:1977). */
export const OPERATOR_PORTAL: AuthPortal = {
  id: "operator",
  loginPath: "/auth/operator/login",
  accept: (me: AuthMe) => me.scope === "operator" && me.role === OPERATOR_OWNER,
  texts: {
    footer: "Cổng quản lý dành cho chủ nhà xe",
    loginTitle: "Đăng nhập nhà xe",
    loginSubtitle: "Dùng tài khoản đối tác đã được xác minh.",
    identifierPlaceholder: "nhaxe/taikhoan",
    securityChip: "Bảo mật tài khoản",
    accountNoun: "tài khoản nhà xe",
    destination: "trang quản lý",
    contact: "quản trị nền tảng",
    mfaHero: {
      accent: "Xác thực an toàn.",
      title: "Tiếp tục vận hành.",
      description: ["Dùng mã từ ứng dụng xác thực hoặc mã dự phòng", "để truy cập trang quản lý nhà xe."]
    }
  },
  loginHero: <LoginHero />,
  // Owner không tự đặt lại mật khẩu (closed enrollment, ADR-017): chỉ hướng dẫn liên hệ.
  passwordHelp: {
    title: "Cấp lại mật khẩu",
    description: ["Mật khẩu nhà xe do quản trị nền tảng cấp.", "Vui lòng liên hệ quản trị nền tảng để được cấp lại."]
  },
  loginFooter: (
    // Figma 840:2074 — nhà xe chưa có tài khoản nộp hồ sơ đăng ký công khai (TASK-OPR-001, BR-75).
    <div className="flex items-end gap-3.5 rounded-[10px] border border-warning-500 bg-gradient-to-br from-[#fff7e6] to-[#ffeac7] p-4">
      <div className="flex min-w-0 flex-1 flex-col gap-0.5">
        <p className="text-sm font-semibold text-vxn-ink">Trở thành đối tác</p>
        <p className="text-sm leading-5 text-vxn-fg-3">Gửi hồ sơ đăng ký. Tài khoản được cấp sau khi hồ sơ được phê duyệt.</p>
      </div>
      <Link
        href="/register"
        className="flex h-[34px] shrink-0 items-center rounded px-3.5 text-[13px] font-semibold text-white outline-none bg-warning-500 hover:bg-warning-600 focus-visible:ring-2 focus-visible:ring-ring"
      >
        Đăng ký
      </Link>
    </div>
  )
};

/** Phiên web của Operator OS: chỉ Owner scope `operator` mới được vào. */
export function AuthProvider({ children }: { children: ReactNode }) {
  return <PortalAuthProvider portal={OPERATOR_PORTAL}>{children}</PortalAuthProvider>;
}
