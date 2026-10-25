"use client";

import React, { useState } from "react";
import Link from "next/link";
import { useRouter } from "next/navigation";
import { Check, AlertCircle } from "lucide-react";
import { Button } from "@vexenhanh/ui/components/button";
import { registerAccount } from "../../lib/data/auth";
import { AUTH_INPUT, AUTH_LABEL, AUTH_LINK, AUTH_PRIMARY_BUTTON, AUTH_SUBTITLE, AUTH_TITLE } from "./auth-styles";
import { AuthModalShell, type AuthModalVariant } from "./auth-modal-shell";

/**
 * Thuộc tính của RegisterView (SCR-PSG-08)
 */
export interface RegisterViewProps {
  readonly initialData?: {
    readonly fullName?: string;
    readonly email?: string;
    readonly phone?: string;
  };
  readonly isPreview?: boolean;
  readonly variant?: AuthModalVariant;
}

/**
 * Màn hình Tạo tài khoản hành khách chuẩn Figma node 1447:17057
 */
export const RegisterView: React.FC<RegisterViewProps> = ({
  initialData = {
    email: ""
  },
  isPreview = false,
  variant = "page"
}) => {
  const router = useRouter();
  const [email, setEmail] = useState<string>(initialData.email ?? "");
  const [agreeTerms, setAgreeTerms] = useState<boolean>(false);
  const [errorMessage, setErrorMessage] = useState<string | null>(null);
  const [isSubmitting, setIsSubmitting] = useState<boolean>(false);

  const isValidEmail = email.includes("@") && email.includes(".");

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!isValidEmail) {
      setErrorMessage("Vui lòng nhập địa chỉ email hợp lệ.");
      return;
    }
    if (!agreeTerms) {
      setErrorMessage("Vui lòng đồng ý với Điều khoản sử dụng và Chính sách bảo mật.");
      return;
    }

    setErrorMessage(null);

    if (isPreview) {
      router.push(`/verify-email?email=${encodeURIComponent(email)}&preview=ideal`);
      return;
    }

    setIsSubmitting(true);
    try {
      const res = await registerAccount({ email });
      if (res.status === "ok") {
        router.push(`/verify-email?email=${encodeURIComponent(res.data.email)}`);
      } else if (res.status === "unavailable") {
        setErrorMessage("Chưa thể tạo tài khoản. Vui lòng thử lại sau.");
      } else if (res.status === "error") {
        setErrorMessage(res.message ?? "Không thể hoàn tất đăng ký. Vui lòng thử lại sau.");
      }
    } catch {
      setErrorMessage("Đã xảy ra lỗi khi tạo tài khoản. Vui lòng thử lại.");
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <AuthModalShell variant={variant}>
      {/* Modal Tạo tài khoản — Figma 1447:17057 */}
      <div className="flex w-full flex-col items-center gap-1.5 text-center">
        <h1 className={AUTH_TITLE}>Tạo tài khoản</h1>
        <p className={AUTH_SUBTITLE}>Xác minh bằng mã OTP gửi qua email. Không cần mật khẩu.</p>
      </div>

      <form onSubmit={handleSubmit} className="flex w-full flex-col gap-4">
        <div className="flex flex-col gap-2 text-left">
          <label htmlFor="register-email" className={AUTH_LABEL}>
            Email
          </label>
          <div className="relative">
            <input
              id="register-email"
              type="email"
              required
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              placeholder="email@example.com"
              className={`${AUTH_INPUT} pr-11 ${isValidEmail ? "border-vxn-teal-500" : "border-[#e4e5e7]"}`}
            />
            {isValidEmail && (
              <div className="pointer-events-none absolute inset-y-0 right-4 flex items-center text-vxn-teal-500">
                <Check className="size-5" />
              </div>
            )}
          </div>
          <p className="text-xs/[18px] text-vxn-fg-5">
            Sau khi xác minh email, bạn có thể bổ sung họ tên, số điện thoại và ngày sinh tại Hồ sơ cá nhân.
          </p>
        </div>

        {/* Checkbox điều khoản */}
        <div className="flex items-start gap-2.5 text-left">
          <button
            type="button"
            role="checkbox"
            aria-checked={agreeTerms}
            aria-label="Đồng ý điều khoản"
            onClick={() => setAgreeTerms(!agreeTerms)}
            className={`mt-0.5 flex size-4 shrink-0 items-center justify-center rounded-sm border transition-colors ${
              agreeTerms ? "border-vxn-teal-500 bg-vxn-teal-500 text-white" : "border-input bg-background text-transparent"
            }`}
          >
            <Check className="size-3 stroke-[3]" />
          </button>
          <p className="text-[13px]/[19.5px] text-vxn-fg-5">
            Tôi đồng ý{" "}
            <Link href="/legal/terms-of-service" className={AUTH_LINK}>
              Điều khoản sử dụng
            </Link>{" "}
            và{" "}
            <Link href="/legal/privacy-policy" className={AUTH_LINK}>
              Chính sách bảo mật
            </Link>{" "}
            của Vé Xe Nhanh.
          </p>
        </div>

        {errorMessage && (
          <div role="alert" className="flex items-start gap-2 rounded-xl bg-destructive/10 p-3 text-sm text-destructive">
            <AlertCircle className="mt-0.5 size-4 shrink-0" />
            <span>{errorMessage}</span>
          </div>
        )}

        <Button type="submit" disabled={isSubmitting || !isValidEmail || !agreeTerms} className={AUTH_PRIMARY_BUTTON}>
          {isSubmitting ? "Đang xử lý..." : "Tạo tài khoản và gửi mã"}
        </Button>
      </form>

      <p className="text-[13px]/[19.5px] text-vxn-fg-5">
        Đã có tài khoản?{" "}
        <Link href={isPreview ? "/login?preview=ideal" : "/login"} className={AUTH_LINK}>
          Đăng nhập
        </Link>
      </p>
    </AuthModalShell>
  );
};
