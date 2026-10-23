import type { AuthMe, AuthPortal } from "@vexenhanh/ui/components/auth/auth-context";
import { HeroChip } from "@vexenhanh/ui/components/auth/auth-ui";
import { Info } from "lucide-react";

/** Vai trò được vào cổng Admin (RBAC 8 vai trò, ADR-017). */
export const PLATFORM_ROLES = ["PLATFORM_ADMIN", "PLATFORM_SUPPORT"] as const;

export const ROLE_LABELS: Record<string, string> = {
  PLATFORM_ADMIN: "Quản trị viên nền tảng",
  PLATFORM_SUPPORT: "Hỗ trợ nền tảng"
};

/**
 * Cổng Admin (TASK-IAM-006 phần web Admin): đăng nhập `platform/{username}`, TOTP bắt buộc, chữ và màu theo Figma
 * ADM-00a / ADM-00b (mode `Admin`).
 */
export const ADMIN_PORTAL: AuthPortal = {
  id: "admin",
  loginPath: "/auth/platform/login",
  accept: (me: AuthMe) => me.scope === "platform" && (PLATFORM_ROLES as readonly string[]).includes(me.role),
  texts: {
    footer: "Cổng quản trị nền tảng Vé Xe Nhanh · Mọi thao tác nhạy cảm đều được ghi nhật ký audit",
    loginTitle: "Đăng nhập quản trị",
    loginSubtitle: "Dùng tài khoản nội bộ do Vé Xe Nhanh cấp.",
    identifierPlaceholder: "platform/taikhoan",
    securityChip: "Bảo mật tài khoản quản trị",
    accountNoun: "tài khoản quản trị",
    destination: "cổng quản trị",
    contact: "quản trị viên có thẩm quyền",
    mfaHero: {
      accent: "Xác thực an toàn.",
      title: "Tiếp tục quản trị.",
      description: [
        "Mọi tài khoản quản trị đều phải xác thực hai lớp. Dùng mã từ ứng dụng",
        "xác thực hoặc một mã dự phòng dùng một lần."
      ]
    }
  },
  loginHero: (
    <div className="flex w-[600px] min-w-0 flex-col gap-[18px]">
      <HeroChip dot="saffron">Cổng quản trị nền tảng</HeroChip>
      <p className="text-[44px] leading-[56px] font-bold text-white">
        Vận hành nền tảng.
        <br />
        <span className="text-[#f2b033]">Minh bạch từng thao tác.</span>
      </p>
      <p className="max-w-[520px] text-base leading-6 text-white/85">
        Dành riêng cho nhân sự Vé Xe Nhanh: duyệt nhà xe, giám sát thanh toán, chi trả và xử lý tranh chấp.
      </p>
    </div>
  ),
  // Không có đăng ký công khai và không tự cấp lại mật khẩu (closed enrollment, ADR-017) — Figma ADM-00a.
  loginFooter: (
    <p className="flex gap-2 rounded-lg bg-[#eef2ff] p-3 text-[13px] leading-[19.5px] text-[#2d3138]">
      <Info className="mt-0.5 size-4 shrink-0 text-[#4338ca]" aria-hidden />
      Không có đăng ký công khai. Cần cấp lại mật khẩu? Liên hệ quản trị viên có thẩm quyền; việc cấp lại được ghi nhật ký
      audit.
    </p>
  )
};
