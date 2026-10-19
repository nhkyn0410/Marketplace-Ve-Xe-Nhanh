"use client";

import { zodResolver } from "@hookform/resolvers/zod";
import { useMutation } from "@tanstack/react-query";
import { Button } from "@vexenhanh/ui/components/button";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle
} from "@vexenhanh/ui/components/dialog";
import { Input } from "@vexenhanh/ui/components/input";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@vexenhanh/ui/components/select";
import { Textarea } from "@vexenhanh/ui/components/textarea";
import { Check, CircleAlert, LoaderCircle, Send } from "lucide-react";
import { useState } from "react";
import { Controller, useForm } from "react-hook-form";

import { withReauth } from "../../lib/auth/reauth";
import { type OperatorProfile, requestBankChange, updateProfile } from "../../lib/profile/profile-api";
import {
  bankChangeFormSchema,
  type BankChangeFormValues,
  describeProfileError,
  profileFormSchema,
  type ProfileFormValues,
  toAccountHolder,
  toProfileForm,
  toProfileInput
} from "../../lib/profile/profile-format";
import { BANKS } from "../../lib/register/application";
import { IdentityField, useIdentityField } from "../auth/identity-field";
import { FormField } from "../form-field";
import { BUTTON } from "../list-parts";

function FormError({ message }: { message: string | null }) {
  if (!message) {
    return null;
  }
  return (
    <div role="alert" className="flex items-center gap-3 rounded-lg bg-error-50 px-4 py-3 text-sm leading-5 text-error-600">
      <CircleAlert className="size-5 shrink-0" />
      {message}
    </div>
  );
}

/** Hộp thoại "Chỉnh sửa" hồ sơ doanh nghiệp: tên hiển thị, hotline, email, địa chỉ, mô tả (UC-11 bước 2). */
export function ProfileEditDialog({
  profile,
  open,
  onClose,
  onSaved
}: {
  profile: OperatorProfile;
  open: boolean;
  onClose: () => void;
  onSaved: (profile: OperatorProfile) => void;
}) {
  const [pending, setPending] = useState(false);
  return (
    <Dialog open={open} onOpenChange={(next) => !next && !pending && onClose()}>
      {open && <ProfileForm profile={profile} onClose={onClose} onSaved={onSaved} onPendingChange={setPending} />}
    </Dialog>
  );
}

function ProfileForm({
  profile,
  onClose,
  onSaved,
  onPendingChange
}: {
  profile: OperatorProfile;
  onClose: () => void;
  onSaved: (profile: OperatorProfile) => void;
  onPendingChange: (pending: boolean) => void;
}) {
  const form = useForm<ProfileFormValues>({ resolver: zodResolver(profileFormSchema), defaultValues: toProfileForm(profile) });
  const { errors } = form.formState;
  const [formError, setFormError] = useState<string | null>(null);
  const save = useMutation({
    mutationFn: (values: ProfileFormValues) => updateProfile(toProfileInput(values)),
    onMutate: () => {
      setFormError(null);
      onPendingChange(true);
    },
    onSettled: () => onPendingChange(false),
    onSuccess: (saved) => {
      onSaved(saved);
      onClose();
    },
    onError: (error) => setFormError(describeProfileError(error).message)
  });

  return (
    <DialogContent className="sm:max-w-[600px]">
      <DialogHeader>
        <DialogTitle>Chỉnh sửa hồ sơ doanh nghiệp</DialogTitle>
        <DialogDescription>Hiển thị trên trang nhà xe và thẻ chuyến. Tên pháp lý và mã số thuế không đổi ở đây.</DialogDescription>
      </DialogHeader>
      <form noValidate onSubmit={form.handleSubmit((values) => save.mutate(values))} className="flex flex-col gap-4">
        <FormField label="Tên nhà xe *" error={errors.displayName?.message}>
          {(control) => <Input {...control} {...form.register("displayName")} maxLength={100} disabled={save.isPending} />}
        </FormField>
        <div className="grid gap-4 sm:grid-cols-2">
          <FormField label="Hotline *" error={errors.hotline?.message}>
            {(control) => (
              <Input {...control} {...form.register("hotline")} inputMode="tel" maxLength={20} disabled={save.isPending} />
            )}
          </FormField>
          <FormField label="Email *" error={errors.publicEmail?.message}>
            {(control) => (
              <Input {...control} {...form.register("publicEmail")} type="email" maxLength={254} disabled={save.isPending} />
            )}
          </FormField>
        </div>
        <FormField label="Địa chỉ *" error={errors.address?.message}>
          {(control) => <Input {...control} {...form.register("address")} maxLength={255} disabled={save.isPending} />}
        </FormField>
        <FormField label="Mô tả" helper="Không bắt buộc · tối đa 1000 ký tự" error={errors.description?.message}>
          {(control) => (
            <Textarea {...control} {...form.register("description")} rows={4} maxLength={1000} disabled={save.isPending} />
          )}
        </FormField>
        <FormError message={formError} />
        <DialogFooter>
          <Button type="button" variant="outline" className={`${BUTTON} bg-card`} disabled={save.isPending} onClick={onClose}>
            Hủy
          </Button>
          <Button type="submit" className={BUTTON} disabled={save.isPending}>
            {save.isPending ? <LoaderCircle className="size-[18px] animate-spin" /> : <Check className="size-[18px]" />}
            Lưu thay đổi
          </Button>
        </DialogFooter>
      </form>
    </DialogContent>
  );
}

/**
 * Hộp thoại "Đổi tài khoản nhận tiền" (Figma 1667:27586; UC-11 bước 3–4, BR-37): ngân hàng, số tài khoản, chủ tài
 * khoản (viết hoa, không dấu), lý do và xác nhận lại danh tính. Gửi xong thì chờ Admin xác minh.
 */
export function BankChangeDialog({
  profile,
  open,
  onClose,
  onSent
}: {
  profile: OperatorProfile;
  open: boolean;
  onClose: () => void;
  onSent: (profile: OperatorProfile) => void;
}) {
  const [pending, setPending] = useState(false);
  return (
    <Dialog open={open} onOpenChange={(next) => !next && !pending && onClose()}>
      {open && <BankChangeForm profile={profile} onClose={onClose} onSent={onSent} onPendingChange={setPending} />}
    </Dialog>
  );
}

function BankChangeForm({
  profile,
  onClose,
  onSent,
  onPendingChange
}: {
  profile: OperatorProfile;
  onClose: () => void;
  onSent: (profile: OperatorProfile) => void;
  onPendingChange: (pending: boolean) => void;
}) {
  const identity = useIdentityField();
  const form = useForm<BankChangeFormValues>({
    resolver: zodResolver(bankChangeFormSchema),
    defaultValues: { bankName: "", accountNumber: "", accountHolder: "", reason: "" }
  });
  const { errors } = form.formState;
  const [formError, setFormError] = useState<string | null>(null);
  const send = useMutation({
    mutationFn: (values: BankChangeFormValues) =>
      withReauth(identity.secret, () =>
        requestBankChange({
          bankName: values.bankName,
          accountNumber: values.accountNumber.replace(/[\s.-]/g, ""),
          accountHolder: toAccountHolder(values.accountHolder.trim()),
          reason: values.reason.trim()
        })
      ),
    onMutate: () => {
      setFormError(null);
      onPendingChange(true);
    },
    onSettled: () => onPendingChange(false),
    onSuccess: (saved) => {
      onSent(saved);
      onClose();
    },
    onError: (error) => {
      const described = describeProfileError(error);
      if (described.field === "identity") {
        identity.require(described.message);
        return;
      }
      identity.sync();
      setFormError(described.message);
    }
  });
  const current = profile.bankAccount;

  return (
    <DialogContent className="sm:max-w-[560px]">
      <DialogHeader>
        <DialogTitle>Đổi tài khoản nhận tiền</DialogTitle>
        <DialogDescription>
          {current ? `Tài khoản hiện tại: ${current.bankName} · ${current.accountNumberMasked}` : "Nhà xe chưa có tài khoản nhận tiền đã xác minh."}
        </DialogDescription>
      </DialogHeader>
      <form
        noValidate
        onSubmit={(event) => {
          event.preventDefault();
          const identityOk = identity.check();
          void form.handleSubmit((values) => {
            if (identityOk) {
              send.mutate(values);
            }
          })(event);
        }}
        className="flex flex-col gap-4"
      >
        <FormField label="Ngân hàng *" error={errors.bankName?.message}>
          {(control) => (
            <Controller
              control={form.control}
              name="bankName"
              render={({ field }) => (
                <Select value={field.value || undefined} onValueChange={field.onChange} disabled={send.isPending}>
                  <SelectTrigger {...control} onBlur={field.onBlur} className="w-full">
                    <SelectValue placeholder="Chọn ngân hàng" />
                  </SelectTrigger>
                  <SelectContent>
                    {BANKS.map((bank) => (
                      <SelectItem key={bank} value={bank}>
                        {bank}
                      </SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              )}
            />
          )}
        </FormField>
        <div className="grid gap-4 sm:grid-cols-2">
          <FormField label="Số tài khoản *" error={errors.accountNumber?.message}>
            {(control) => (
              <Input
                {...control}
                {...form.register("accountNumber")}
                inputMode="numeric"
                maxLength={30}
                autoComplete="off"
                placeholder="Nhập số tài khoản"
                disabled={send.isPending}
              />
            )}
          </FormField>
          <FormField label="Tên chủ tài khoản *" error={errors.accountHolder?.message}>
            {(control) => (
              <Input
                {...control}
                {...form.register("accountHolder")}
                maxLength={100}
                autoComplete="off"
                placeholder="Viết hoa, không dấu"
                className="uppercase"
                disabled={send.isPending}
              />
            )}
          </FormField>
        </div>
        <FormField label="Lý do đổi *" helper="Lý do được lưu vào nhật ký audit." error={errors.reason?.message}>
          {(control) => (
            <Textarea
              {...control}
              {...form.register("reason")}
              rows={3}
              maxLength={500}
              placeholder="Nhập lý do (3–500 ký tự)…"
              disabled={send.isPending}
            />
          )}
        </FormField>
        {identity.needed && (
          <IdentityField value={identity.value} error={identity.error} disabled={send.isPending} onChange={identity.change} />
        )}
        <FormError message={formError} />
        <DialogFooter>
          <Button type="button" variant="outline" className={`${BUTTON} bg-card`} disabled={send.isPending} onClick={onClose}>
            Hủy
          </Button>
          <Button type="submit" className={BUTTON} disabled={send.isPending}>
            {send.isPending ? <LoaderCircle className="size-[18px] animate-spin" /> : <Send className="size-[18px]" />}
            Gửi xác minh
          </Button>
        </DialogFooter>
      </form>
    </DialogContent>
  );
}
