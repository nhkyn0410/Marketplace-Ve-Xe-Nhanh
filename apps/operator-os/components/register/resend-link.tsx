"use client";

import { zodResolver } from "@hookform/resolvers/zod";
import { Button } from "@vexenhanh/ui/components/button";
import { Input } from "@vexenhanh/ui/components/input";
import { CircleAlert, LinkIcon, LoaderCircle, MailCheck, Send } from "lucide-react";
import { useSearchParams } from "next/navigation";
import { useState } from "react";
import { useForm } from "react-hook-form";

import { describeApplicationError, resendSchema, type ResendValues } from "../../lib/register/application";
import { requestAccessLink } from "../../lib/register/application-api";
import { FormField } from "../form-field";
import { RegisterCard, RegisterShell } from "./register-shell";

/**
 * Gửi lại link bảo mật bằng email liên hệ + mã hồ sơ (Figma 04, FR-OPR-12). `?reason=invalid` khi người dùng tới đây
 * vì link cũ không còn hiệu lực.
 */
export function ResendLink() {
  const invalid = useSearchParams().get("reason") === "invalid";
  const [sentTo, setSentTo] = useState<string | null>(null);
  const [error, setError] = useState<string | null>(null);
  const form = useForm<ResendValues>({
    resolver: zodResolver(resendSchema),
    defaultValues: { contactEmail: "", applicationCode: "" }
  });
  const { errors, isSubmitting } = form.formState;

  async function submit(values: ResendValues) {
    setError(null);
    try {
      const input = resendSchema.parse(values);
      await requestAccessLink(input);
      setSentTo(input.contactEmail);
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
          <p className="text-sm leading-5 text-muted-foreground">
            Nếu email và mã hồ sơ khớp một hồ sơ đang mở, link mới đã được gửi tới{" "}
            <strong className="text-vxn-fg-1">{sentTo}</strong>. Mọi link gửi trước đó không còn dùng được.
          </p>
        </RegisterCard>
      </RegisterShell>
    );
  }

  return (
    <RegisterShell step={2}>
      <RegisterCard>
        <div className="flex flex-col gap-1">
          {invalid && <LinkIcon className="mb-1 size-6 text-warning-700" aria-hidden />}
          <h1 className="text-xl leading-7 font-semibold text-vxn-ink">{invalid ? "Link không còn hiệu lực" : "Gửi lại link"}</h1>
          <p className="text-sm leading-5 text-muted-foreground">
            {invalid
              ? "Link đã hết hạn, đã được thay bằng link mới, hoặc hồ sơ đã có kết quả. Nhập email và mã hồ sơ để nhận link mới."
              : "Nhập email liên hệ và mã hồ sơ để nhận link mới."}
          </p>
        </div>
        <form noValidate onSubmit={(event) => void form.handleSubmit(submit)(event)} className="flex flex-col gap-4">
          <FormField label="Email liên hệ *" error={errors.contactEmail?.message}>
            {(control) => <Input {...control} {...form.register("contactEmail")} type="email" autoComplete="email" />}
          </FormField>
          <FormField
            label="Mã hồ sơ *"
            helper="Mã hồ sơ có trong email xác nhận đăng ký."
            error={errors.applicationCode?.message}
          >
            {(control) => <Input {...control} {...form.register("applicationCode")} placeholder="OA-2026-043152" maxLength={20} />}
          </FormField>
          {error && (
            <p role="alert" className="flex items-start gap-2 rounded-lg bg-error-50 px-3 py-2.5 text-sm leading-5 text-error-600">
              <CircleAlert className="mt-0.5 size-4 shrink-0" />
              {error}
            </p>
          )}
          <Button type="submit" className="h-10 rounded-lg text-sm font-semibold" disabled={isSubmitting}>
            {isSubmitting ? <LoaderCircle className="size-[18px] animate-spin" /> : <Send className="size-[18px]" />}
            {isSubmitting ? "Đang gửi…" : "Gửi lại link"}
          </Button>
          <p className="text-center text-xs leading-[18px] text-muted-foreground">
            Link mới sẽ thay thế mọi link đã gửi trước đó.
          </p>
        </form>
      </RegisterCard>
    </RegisterShell>
  );
}
