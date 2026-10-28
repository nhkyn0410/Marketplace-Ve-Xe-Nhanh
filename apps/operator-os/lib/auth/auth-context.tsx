"use client";

import {
  type AuthMe,
  type AuthPortal,
  AuthProvider as PortalAuthProvider
} from "@vexenhanh/ui/components/auth/auth-context";
import { LoginHero } from "@vexenhanh/ui/components/auth/auth-ui";
import Link from "next/link";
import { usePathname } from "next/navigation";
import type { ReactNode } from "react";
import { acceptsCounterSession, isCounterPath } from "../counter/portal";

export type { AuthMe, AuthNotice, AuthState } from "@vexenhanh/ui/components/auth/auth-context";
export { useAuth } from "@vexenhanh/ui/components/auth/auth-context";

// Operator OS: chủ nhà xe + tài khoản quản lý do chủ nhà xe cấp (06 UI §4/§7, TASK-IAM-006 Q4; TASK-IAM-007).
const OPERATOR_OS_ROLES: readonly string[] = ["OPERATOR_OWNER", "OPERATOR_MANAGER"];

/** Cổng nhà xe: đăng nhập chủ nhà xe / tài khoản quản lý, chữ và màu theo Figma "Giao diện nhà xe" (section 830:1977). */
export const OPERATOR_PORTAL: AuthPortal = {
  id: "operator",
  loginPath: "/auth/operator/login",
  accept: (me: AuthMe) => me.scope === "operator" && OPERATOR_OS_ROLES.includes(me.role),
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

/** Cổng bán tại quầy dùng tài khoản nhân viên bán vé hoặc tài khoản chủ nhà xe. */
export const COUNTER_PORTAL: AuthPortal = {
  ...OPERATOR_PORTAL,
  id: "counter",
  loginPath: "/auth/counter/login",
  accept: acceptsCounterSession,
  loginHero: <div className="hidden min-w-0 flex-1 flex-col gap-5 text-white lg:flex"><span className="w-fit rounded-full bg-white/15 px-5 py-2 text-xs font-semibold uppercase tracking-wide">Văn phòng nhà xe</span><h2 className="text-4xl leading-tight font-semibold">Bán vé nhanh.<br /><span className="text-vxn-saffron-500">Theo dõi từng khoản thu.</span></h2><p className="max-w-md text-base leading-7 text-white/80">Chọn chuyến và ghế, ghi nhận người bán, thu tiền và phát vé từ cùng một nơi.</p></div>,
  texts: {
    ...OPERATOR_PORTAL.texts,
    footer: "Cổng bán vé tại văn phòng nhà xe",
    loginTitle: "Đăng nhập bán vé tại quầy",
    loginSubtitle: "Dùng tài khoản nhân viên bán vé hoặc chủ nhà xe.",
    identifierPlaceholder: "nhaxe/nv.banve",
    destination: "cổng bán vé",
    contact: "chủ nhà xe",
    accountNoun: "tài khoản bán vé",
  },
  loginFooter: <Link href="/" className="block text-center text-sm text-primary underline">Về cổng quản lý nhà xe</Link>,
  passwordHelp: { title: "Cấp lại mật khẩu", description: ["Tài khoản nhân viên do nhà xe cấp.", "Liên hệ chủ nhà xe để được cấp lại mật khẩu."] },
};

/** Phiên web của Operator OS: chỉ Owner scope `operator` mới được vào. */
export function AuthProvider({ children }: { children: ReactNode }) {
  const portal = isCounterPath(usePathname()) ? COUNTER_PORTAL : OPERATOR_PORTAL;
  return <PortalAuthProvider key={portal.id} portal={portal}>{children}</PortalAuthProvider>;
}
