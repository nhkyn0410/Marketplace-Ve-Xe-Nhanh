"use client";

import { Button } from "@vexenhanh/ui/components/button";
import { AlertCircle } from "lucide-react";
import Link from "next/link";
import { useRouter } from "next/navigation";
import React, { useState } from "react";

import { updateAccountProfile } from "../../lib/data/auth";
import { AuthModalShell, type AuthModalVariant } from "./auth-modal-shell";
import { AUTH_INPUT, AUTH_LABEL, AUTH_LINK, AUTH_PRIMARY_BUTTON, AUTH_SUBTITLE, AUTH_TITLE } from "./auth-styles";

export interface RegisterProfileViewProps {
  readonly email: string;
  readonly initialFullName?: string;
  readonly initialPhone?: string;
  readonly isPreview?: boolean;
  readonly variant?: AuthModalVariant;
}

const PHONE = /^(0|\+84)\d{9}$/;

/**
 * Bước 2 của Tạo tài khoản: sau khi xác minh email, ghi nhận họ tên và số điện thoại (PUT /me/profile).
 * Bỏ qua được — thông tin sửa lại ở Hồ sơ cá nhân.
 */
export function RegisterProfileView({ email, initialFullName = "", initialPhone = "", isPreview = false, variant = "page" }: RegisterProfileViewProps) {
  const router = useRouter();
  const [fullName, setFullName] = useState(initialFullName);
  const [phone, setPhone] = useState(initialPhone);
  const [errorMessage, setErrorMessage] = useState<string | null>(null);
  const [isSubmitting, setIsSubmitting] = useState(false);
  const nextHref = isPreview ? "/account?preview=ideal" : "/account";

  const handleSubmit = async (event: React.FormEvent) => {
    event.preventDefault();
    const name = fullName.trim();
    const phoneValue = phone.trim();
    if (!name) {
      setErrorMessage("Vui lòng nhập họ và tên.");
      return;
    }
    if (phoneValue && !PHONE.test(phoneValue)) {
      setErrorMessage("Số điện thoại cần 10 số (bắt đầu bằng 0) hoặc đầu +84.");
      return;
    }
    setErrorMessage(null);
    if (isPreview) {
      router.push(nextHref);
      return;
    }
    setIsSubmitting(true);
    try {
      const result = await updateAccountProfile({ name, phone: phoneValue || null });
      if (result.status === "ok") {
        router.push(nextHref);
        router.refresh();
      } else {
        setErrorMessage(result.status === "error" ? result.message ?? "Không thể lưu thông tin." : "Chưa thể lưu thông tin. Vui lòng thử lại sau.");
      }
    } catch {
      setErrorMessage("Đã xảy ra lỗi khi lưu thông tin. Vui lòng thử lại.");
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <AuthModalShell variant={variant} showClose={false}>
      <div className="flex w-full flex-col items-center gap-1.5 text-center">
        <p className="text-xs font-semibold tracking-wide text-vxn-teal-500 uppercase">Bước 2 / 2</p>
        <h1 className={AUTH_TITLE}>Hoàn thiện hồ sơ</h1>
        <p className={AUTH_SUBTITLE}>Thông tin giúp điền sẵn khi đặt vé. Bạn có thể sửa lại trong Hồ sơ cá nhân.</p>
      </div>

      <form onSubmit={handleSubmit} className="flex w-full flex-col gap-4">
        <div className="flex flex-col gap-2 text-left">
          <label htmlFor="profile-email" className={AUTH_LABEL}>Email</label>
          <input id="profile-email" value={email} readOnly className={`${AUTH_INPUT} border-[#e4e5e7] bg-vxn-bg-soft text-vxn-fg-5`} />
        </div>
        <div className="flex flex-col gap-2 text-left">
          <label htmlFor="profile-name" className={AUTH_LABEL}>Họ và tên</label>
          <input
            id="profile-name"
            required
            maxLength={100}
            autoComplete="name"
            value={fullName}
            onChange={(e) => setFullName(e.target.value)}
            placeholder="Nguyễn Văn A"
            className={`${AUTH_INPUT} border-[#e4e5e7]`}
          />
        </div>
        <div className="flex flex-col gap-2 text-left">
          <label htmlFor="profile-phone" className={AUTH_LABEL}>Số điện thoại (không bắt buộc)</label>
          <input
            id="profile-phone"
            inputMode="tel"
            autoComplete="tel"
            value={phone}
            onChange={(e) => setPhone(e.target.value)}
            placeholder="0901 234 567"
            className={`${AUTH_INPUT} border-[#e4e5e7]`}
          />
        </div>

        {errorMessage && (
          <div role="alert" className="flex items-start gap-2 rounded-xl bg-destructive/10 p-3 text-sm text-destructive">
            <AlertCircle className="mt-0.5 size-4 shrink-0" />
            <span>{errorMessage}</span>
          </div>
        )}

        <Button type="submit" disabled={isSubmitting} className={AUTH_PRIMARY_BUTTON}>
          {isSubmitting ? "Đang lưu..." : "Hoàn tất"}
        </Button>
      </form>

      <Link href={nextHref} className={`text-[13px] ${AUTH_LINK}`}>
        Bỏ qua, để sau
      </Link>
    </AuthModalShell>
  );
}
