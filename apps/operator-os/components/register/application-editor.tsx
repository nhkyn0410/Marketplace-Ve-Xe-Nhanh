"use client";

import { zodResolver } from "@hookform/resolvers/zod";
import { Badge } from "@vexenhanh/ui/components/badge";
import { Button } from "@vexenhanh/ui/components/button";
import { DemoDataNotice } from "@vexenhanh/ui/components/demo-data-notice";
import { Input } from "@vexenhanh/ui/components/input";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@vexenhanh/ui/components/select";
import { Textarea } from "@vexenhanh/ui/components/textarea";
import { cn } from "@vexenhanh/ui/lib/utils";
import { CircleAlert, CircleCheck, FileText, LoaderCircle, Send, TriangleAlert, Upload } from "lucide-react";
import { useMemo, useRef, useState, type ReactNode } from "react";
import { Controller, useForm } from "react-hook-form";

import {
  type Application,
  applicationFormSchema,
  type ApplicationFormValues,
  BANKS,
  describeApplicationError,
  DOCUMENT_TYPES,
  documentFileProblem,
  type DocumentType,
  formatShortDateTime,
  formatTimeDate,
  type FormDocument,
  isLinkInvalid,
  missingFromForm,
  progressOf,
  STATUS_LABELS,
  toFormDocuments,
  toFormValues,
  toUpdateInput
} from "../../lib/register/application";
import { saveApplication, submitApplication, uploadDocument } from "../../lib/register/application-api";
import { FormField } from "../form-field";

const CARD = "flex flex-col gap-5 rounded-xl border bg-card p-6";
const CARD_TITLE = "text-base leading-6 font-semibold text-vxn-ink";
const HELPER = "text-xs leading-[18px] text-muted-foreground";

/**
 * Hoàn thiện hồ sơ và giấy tờ (Figma 03; UC-10 bước 4–7). Thông tin và giấy tờ chỉ lưu khi bấm "Lưu nháp" hoặc
 * "Gửi duyệt" (gửi duyệt = lưu rồi gửi). Giấy tờ tải thẳng lên kho riêng tư, gắn vào hồ sơ ở lần lưu.
 */
export function ApplicationEditor({
  token,
  application,
  onChange,
  onLinkInvalid,
  onViewDocument
}: {
  token: string;
  application: Application;
  onChange: (application: Application) => void;
  onLinkInvalid: () => void;
  onViewDocument: (type: DocumentType) => void;
}) {
  const form = useForm<ApplicationFormValues>({
    resolver: zodResolver(applicationFormSchema),
    defaultValues: toFormValues(application)
  });
  const { errors } = form.formState;
  const [documents, setDocuments] = useState<FormDocument[]>(() => toFormDocuments(application));
  const [uploading, setUploading] = useState<DocumentType | null>(null);
  const [documentErrors, setDocumentErrors] = useState<Partial<Record<DocumentType, string>>>({});
  const [busy, setBusy] = useState<"save" | "submit" | null>(null);
  const [notice, setNotice] = useState<{ tone: "success" | "error"; text: string } | null>(null);

  const values = form.watch();
  const missing = missingFromForm(values, documents, application.bankAccountNumberMasked !== null);
  const progress = progressOf(missing);
  const bankOptions = useMemo(
    () => (application.bankName && !BANKS.includes(application.bankName) ? [application.bankName, ...BANKS] : BANKS),
    [application.bankName]
  );

  function fail(error: unknown) {
    if (isLinkInvalid(error)) {
      onLinkInvalid();
      return;
    }
    setNotice({ tone: "error", text: describeApplicationError(error) });
  }

  async function persist(formValues: ApplicationFormValues): Promise<Application> {
    const saved = await saveApplication(token, toUpdateInput(formValues, documents));
    form.reset(toFormValues(saved));
    setDocuments(toFormDocuments(saved));
    return saved;
  }

  const saveDraft = form.handleSubmit(async (formValues) => {
    setBusy("save");
    setNotice(null);
    try {
      onChange(await persist(formValues));
      setNotice({ tone: "success", text: "Đã lưu nháp hồ sơ." });
    } catch (error) {
      fail(error);
    } finally {
      setBusy(null);
    }
  });

  const submit = form.handleSubmit(async (formValues) => {
    setBusy("submit");
    setNotice(null);
    try {
      await persist(formValues);
      onChange(await submitApplication(token));
    } catch (error) {
      fail(error);
    } finally {
      setBusy(null);
    }
  });

  async function upload(type: DocumentType, file: File) {
    const problem = documentFileProblem(file);
    setDocumentErrors((current) => ({ ...current, [type]: problem ?? undefined }));
    if (problem) {
      return;
    }
    setUploading(type);
    try {
      const objectKey = await uploadDocument(token, type, file);
      setDocuments((current) => [
        ...current.filter((document) => document.type !== type),
        { type, objectKey, fileName: file.name, uploadedAt: null }
      ]);
    } catch (error) {
      if (isLinkInvalid(error)) {
        onLinkInvalid();
        return;
      }
      setDocumentErrors((current) => ({ ...current, [type]: "Tải giấy tờ thất bại. Vui lòng thử lại." }));
    } finally {
      setUploading(null);
    }
  }

  const locked = busy !== null || uploading !== null;

  return (
    <form
      noValidate
      onSubmit={(event) => void submit(event)}
      className="grid w-full items-start gap-6 lg:grid-cols-[minmax(0,1fr)_300px]"
    >
      <div className="flex min-w-0 flex-col gap-6">
        <div className="flex items-start gap-3">
          <div className="flex min-w-0 flex-1 flex-col gap-1">
            <h1 className="text-2xl leading-8 font-semibold text-vxn-ink">Hồ sơ đăng ký {application.applicationCode}</h1>
            <p className="text-sm leading-5 text-muted-foreground">
              Email liên hệ đã được xác minh: {application.contactEmail}
            </p>
          </div>
          <Badge tone={application.status === "NEEDS_INFO" ? "warning" : "neutral"}>{STATUS_LABELS[application.status]}</Badge>
        </div>

        {application.status === "NEEDS_INFO" && application.reviewNote && (
          <div role="status" className="flex gap-3 rounded-lg bg-warning-50 p-4 text-warning-700">
            <CircleAlert className="mt-0.5 size-5 shrink-0" aria-hidden />
            <div className="flex flex-col gap-1 text-sm leading-5">
              <p className="font-semibold">Vé Xe Nhanh yêu cầu bổ sung hồ sơ</p>
              <p>{application.reviewNote}</p>
            </div>
          </div>
        )}

        <section aria-labelledby="business-heading" className={CARD}>
          <h2 id="business-heading" className={CARD_TITLE}>
            Thông tin doanh nghiệp
          </h2>
          <div className="grid gap-x-4 gap-y-5 sm:grid-cols-[minmax(0,1fr)_205px]">
            <FormField label="Tên pháp nhân *" error={errors.legalName?.message}>
              {(control) => <Input {...control} {...form.register("legalName")} maxLength={200} />}
            </FormField>
            <FormField label="Mã số thuế *" error={errors.taxCode?.message}>
              {(control) => <Input {...control} {...form.register("taxCode")} inputMode="numeric" maxLength={20} />}
            </FormField>
          </div>
          <div className="grid gap-x-4 gap-y-5 sm:grid-cols-[205px_minmax(0,1fr)]">
            <FormField label="Hotline *" error={errors.hotline?.message}>
              {(control) => <Input {...control} {...form.register("hotline")} inputMode="tel" maxLength={20} />}
            </FormField>
            <FormField label="Địa chỉ trụ sở *" error={errors.address?.message}>
              {(control) => <Input {...control} {...form.register("address")} maxLength={255} />}
            </FormField>
          </div>
        </section>

        <section aria-labelledby="public-heading" className={CARD}>
          <div className="flex flex-col gap-1">
            <h2 id="public-heading" className={CARD_TITLE}>
              Thông tin công khai
            </h2>
            <p className={HELPER}>Hiển thị cho hành khách sau khi nhà xe được duyệt.</p>
          </div>
          <FormField label="Tên hiển thị *" error={errors.displayName?.message}>
            {(control) => <Input {...control} {...form.register("displayName")} maxLength={100} />}
          </FormField>
          <FormField label="Mô tả" helper="Không bắt buộc" error={errors.description?.message}>
            {(control) => <Textarea {...control} {...form.register("description")} rows={3} maxLength={1000} />}
          </FormField>
        </section>

        <section aria-labelledby="documents-heading" className={CARD}>
          <div className="flex flex-col gap-1">
            <h2 id="documents-heading" className={CARD_TITLE}>
              Giấy tờ KYC
            </h2>
            <p className={HELPER}>Tệp được lưu riêng tư và chỉ nhân sự duyệt hồ sơ của Vé Xe Nhanh xem được.</p>
          </div>
          <DemoDataNotice />
          <ul className="flex flex-col gap-3">
            {DOCUMENT_TYPES.map(({ type, label }) => (
              <DocumentRow
                key={type}
                label={label}
                document={documents.find((document) => document.type === type)}
                uploading={uploading === type}
                disabled={locked}
                error={documentErrors[type]}
                onPick={(file) => void upload(type, file)}
                onView={() => onViewDocument(type)}
              />
            ))}
          </ul>
        </section>

        <section aria-labelledby="bank-heading" className={CARD}>
          <div className="flex flex-col gap-1">
            <h2 id="bank-heading" className={CARD_TITLE}>
              Tài khoản nhận tiền
            </h2>
            <p className={HELPER}>Dùng để nhận chi trả tiền vé sau khi chuyến hoàn thành.</p>
          </div>
          <div className="grid gap-4 sm:grid-cols-3">
            <FormField label="Ngân hàng *" error={errors.bankName?.message}>
              {(control) => (
                <Controller
                  control={form.control}
                  name="bankName"
                  render={({ field }) => (
                    <Select value={field.value || undefined} onValueChange={field.onChange}>
                      <SelectTrigger {...control} onBlur={field.onBlur}>
                        <SelectValue placeholder="Chọn ngân hàng" />
                      </SelectTrigger>
                      <SelectContent>
                        {bankOptions.map((bank) => (
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
            <FormField
              label="Số tài khoản *"
              helper={application.bankAccountNumberMasked ? `Đã lưu ${application.bankAccountNumberMasked} · để trống nếu không đổi` : undefined}
              error={errors.bankAccountNumber?.message}
            >
              {(control) => (
                <Input {...control} {...form.register("bankAccountNumber")} inputMode="numeric" maxLength={30} autoComplete="off" />
              )}
            </FormField>
            <FormField label="Tên chủ tài khoản *" error={errors.bankAccountHolder?.message}>
              {(control) => <Input {...control} {...form.register("bankAccountHolder")} maxLength={100} autoComplete="off" />}
            </FormField>
          </div>
        </section>
      </div>

      <aside aria-labelledby="progress-heading" className="flex flex-col gap-4 rounded-xl border bg-card p-5 lg:sticky lg:top-6">
        <h2 id="progress-heading" className="text-lg leading-7 font-semibold text-vxn-ink">
          Tiến độ hồ sơ
        </h2>
        <ul className="flex flex-col gap-2">
          {progress.groups.map((group) => (
            <li key={group.label} className="flex items-center gap-2 text-sm leading-5 text-vxn-fg-1">
              {group.done ? (
                <CircleCheck className="size-4 shrink-0 text-success-600" aria-label="Đã đủ" />
              ) : (
                <CircleAlert className="size-4 shrink-0 text-warning-700" aria-label="Còn thiếu" />
              )}
              {group.label}
            </li>
          ))}
        </ul>
        {progress.warning && (
          <p className="flex gap-2 rounded-lg bg-warning-50 p-3 text-xs leading-[18px] text-warning-700">
            <TriangleAlert className="mt-px size-4 shrink-0" aria-hidden />
            {progress.warning}
          </p>
        )}
        {notice && (
          <p
            role={notice.tone === "error" ? "alert" : "status"}
            className={cn(
              "rounded-lg p-3 text-xs leading-[18px]",
              notice.tone === "error" ? "bg-error-50 text-error-600" : "bg-success-50 text-success-600"
            )}
          >
            {notice.text}
          </p>
        )}
        <Button type="submit" className="h-10 rounded-lg text-sm font-semibold" disabled={locked || missing.length > 0}>
          {busy === "submit" ? <LoaderCircle className="size-[18px] animate-spin" /> : <Send className="size-[18px]" />}
          {busy === "submit" ? "Đang gửi duyệt…" : "Gửi duyệt"}
        </Button>
        <Button
          type="button"
          variant="outline"
          className="h-10 rounded-lg bg-card text-sm font-semibold"
          disabled={locked}
          onClick={() => void saveDraft()}
        >
          {busy === "save" && <LoaderCircle className="size-[18px] animate-spin" />}
          {busy === "save" ? "Đang lưu…" : "Lưu nháp"}
        </Button>
        <p className={HELPER}>Link này hết hạn lúc {formatTimeDate(application.linkExpiresAt)}.</p>
      </aside>
    </form>
  );
}

function DocumentRow({
  label,
  document,
  uploading,
  disabled,
  error,
  onPick,
  onView
}: {
  label: string;
  document: FormDocument | undefined;
  uploading: boolean;
  disabled: boolean;
  error: string | undefined;
  onPick: (file: File) => void;
  onView: () => void;
}) {
  const inputRef = useRef<HTMLInputElement>(null);
  const status: ReactNode = uploading
    ? "Đang tải lên…"
    : document
      ? `${document.fileName} · ${document.uploadedAt ? `tải lên ${formatShortDateTime(document.uploadedAt)}` : "chưa lưu"}`
      : "Chưa tải lên";
  return (
    <li
      className={cn(
        "flex flex-wrap items-center gap-3 rounded-lg border p-3",
        !document && !uploading && "border-warning-500 bg-warning-50"
      )}
    >
      <span
        className={cn(
          "flex size-9 shrink-0 items-center justify-center rounded-lg",
          document ? "bg-success-50 text-success-600" : "bg-card text-warning-700"
        )}
      >
        {document ? <FileText className="size-[18px]" aria-hidden /> : <Upload className="size-[18px]" aria-hidden />}
      </span>
      <div className="flex min-w-0 flex-1 flex-col gap-0.5">
        <p className="text-sm leading-5 font-semibold text-vxn-ink">{label} *</p>
        <p className={cn("truncate text-xs leading-[18px]", document ? "text-muted-foreground" : "text-warning-700")}>{status}</p>
        {error && (
          <p role="alert" className="text-xs leading-[18px] text-error-600">
            {error}
          </p>
        )}
      </div>
      <input
        ref={inputRef}
        type="file"
        aria-label={`Chọn tệp ${label}`}
        accept="application/pdf,image/jpeg,image/png"
        tabIndex={-1}
        className="sr-only"
        onChange={(event) => {
          const file = event.target.files?.[0];
          event.target.value = "";
          if (file) {
            onPick(file);
          }
        }}
      />
      {uploading ? (
        <LoaderCircle className="size-5 animate-spin text-vxn-teal-700" aria-hidden />
      ) : document ? (
        <div className="flex items-center gap-1">
          {document.uploadedAt && (
            <Button
              type="button"
              variant="ghost"
              aria-label={`Xem ${label}`}
              disabled={disabled}
              className="h-8 px-2 text-sm font-semibold text-vxn-teal-700"
              onClick={onView}
            >
              Xem
            </Button>
          )}
          <Button
            type="button"
            variant="ghost"
            aria-label={`Thay tệp ${label}`}
            disabled={disabled}
            className="h-8 px-2 text-sm font-semibold text-vxn-teal-700"
            onClick={() => inputRef.current?.click()}
          >
            Thay tệp
          </Button>
        </div>
      ) : (
        <Button
          type="button"
          variant="outline"
          aria-label={`Tải lên ${label}`}
          disabled={disabled}
          className="h-9 rounded-lg bg-card px-3 text-sm font-semibold"
          onClick={() => inputRef.current?.click()}
        >
          <Upload className="size-4" />
          Tải lên
        </Button>
      )}
    </li>
  );
}
