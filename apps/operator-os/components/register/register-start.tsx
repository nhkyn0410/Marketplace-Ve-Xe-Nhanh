"use client";

import { zodResolver } from "@hookform/resolvers/zod";
import { Button } from "@vexenhanh/ui/components/button";
import { Input } from "@vexenhanh/ui/components/input";
import { CircleAlert, Info, LoaderCircle, MailCheck, Send } from "lucide-react";
import Link from "next/link";
import { useState } from "react";
import { useForm } from "react-hook-form";

import { describeApplicationError, registerSchema, type RegisterValues } from "../../lib/register/application";
import { createApplication } from "../../lib/register/application-api";
import { FormField } from "../form-field";
import { RegisterCard, RegisterShell } from "./register-shell";

/** Đăng ký trở thành đối tác nhà xe (Figma 01) → "Kiểm tra hộp thư của bạn" (Figma 02). UC-10 bước 1–2. */
export function RegisterStart() {
  const [sentTo, setSentTo] = useState<string | null>(null);
  const [error, setError] = useState<string | null>(null);
  const form = useForm<RegisterValues>({
    resolver: zodResolver(registerSchema),
    defaultValues: { operatorName: "", contactName: "", contactEmail: "", acceptTerms: false }
  });
  const { errors, isSubmitting } = form.formState;

  async function submit(values: RegisterValues) {
    setError(null);
    try {
      await createApplication({ ...values, acceptTerms: true });
      setSentTo(values.contactEmail);
    } catch (caught) {
      setError(describeApplicationError(caught));
    }
  }

  if (sentTo) {
    return (
      <RegisterShell step={2}>
        <RegisterCard className="items-center text-center">
          <span className="flex size-12 items-center justify-center rounded-full bg-accent">
            <MailCheck className="size-6 text-vxn-teal-700" aria-hidden />
          </span>
          <h1 className="text-xl leading-7 font-semibold text-vxn-ink">Kiểm tra hộp thư của bạn</h1>
          {/* Câu "nếu thông tin hợp lệ": phản hồi không cho biết email đã có hồ sơ khác hay chưa (Security §11). */}
          <p className="text-sm leading-5 text-muted-foreground">
            Nếu thông tin hợp lệ, một link bảo mật đã được gửi tới <strong className="text-vxn-fg-1">{sentTo}</strong>.
            Link có hạn dùng và chỉ mở đúng hồ sơ của bạn; mã hồ sơ nằm trong email.
          </p>
          <Button asChild variant="outline" className="h-10 w-full rounded-lg bg-card text-sm font-semibold">
            <Link href="/register/resend">Gửi lại link</Link>
          </Button>
          <p className="text-xs leading-[18px] text-muted-foreground">
            Không thấy email? Hãy kiểm tra thư rác hoặc thử gửi lại sau ít phút.
          </p>
        </RegisterCard>
      </RegisterShell>
    );
  }

  return (
    <RegisterShell step={1}>
      <RegisterCard>
        <div className="flex flex-col gap-1">
          <h1 className="text-xl leading-7 font-semibold text-vxn-ink">Đăng ký trở thành đối tác nhà xe</h1>
          <p className="text-sm leading-5 text-muted-foreground">Điền thông tin liên hệ để nhận link hoàn thiện hồ sơ.</p>
        </div>
        <form noValidate onSubmit={(event) => void form.handleSubmit(submit)(event)} className="flex flex-col gap-4">
          <FormField label="Tên nhà xe *" error={errors.operatorName?.message}>
            {(control) => <Input {...control} {...form.register("operatorName")} maxLength={100} autoComplete="organization" />}
          </FormField>
          <FormField label="Họ tên người liên hệ *" error={errors.contactName?.message}>
            {(control) => <Input {...control} {...form.register("contactName")} maxLength={100} autoComplete="name" />}
          </FormField>
          <FormField label="Email liên hệ *" error={errors.contactEmail?.message}>
            {(control) => (
              <Input {...control} {...form.register("contactEmail")} type="email" maxLength={254} autoComplete="email" />
            )}
          </FormField>
          <div className="flex flex-col gap-1.5">
            <label className="flex items-start gap-2 text-sm leading-5 text-vxn-fg-1">
              <input
                type="checkbox"
                {...form.register("acceptTerms")}
                aria-invalid={Boolean(errors.acceptTerms)}
                className="mt-0.5 size-4 shrink-0 accent-[var(--primary)]"
              />
              <span>Tôi đồng ý Điều khoản đối tác và Chính sách bảo mật của Vé Xe Nhanh.</span>
            </label>
            {errors.acceptTerms && (
              <p role="alert" className="text-xs leading-[18px] text-error-600">
                {errors.acceptTerms.message}
              </p>
            )}
          </div>
          {error && (
            <p role="alert" className="flex items-start gap-2 rounded-lg bg-error-50 px-3 py-2.5 text-sm leading-5 text-error-600">
              <CircleAlert className="mt-0.5 size-4 shrink-0" />
              {error}
            </p>
          )}
          <Button type="submit" className="h-10 rounded-lg text-sm font-semibold" disabled={isSubmitting}>
            {isSubmitting ? <LoaderCircle className="size-[18px] animate-spin" /> : <Send className="size-[18px]" />}
            {isSubmitting ? "Đang gửi đăng ký…" : "Gửi đăng ký"}
          </Button>
        </form>
        <p className="flex gap-2 rounded-lg bg-accent p-3 text-xs leading-[18px] text-vxn-teal-700">
          <Info className="mt-px size-4 shrink-0" aria-hidden />
          Vé Xe Nhanh gửi một link bảo mật tới email này để bạn hoàn thiện hồ sơ và tải giấy tờ. Tài khoản chủ nhà xe
          chỉ được cấp sau khi hồ sơ được duyệt.
        </p>
        <p className="text-center text-sm leading-5 text-muted-foreground">
          Đã có mã hồ sơ?{" "}
          <Link href="/register/resend" className="font-semibold text-vxn-teal-700 hover:underline">
            Gửi lại link ›
          </Link>
        </p>
      </RegisterCard>
    </RegisterShell>
  );
}
