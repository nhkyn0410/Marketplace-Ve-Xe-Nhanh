"use client";

import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { Badge } from "@vexenhanh/ui/components/badge";
import { Button } from "@vexenhanh/ui/components/button";
import { FormField } from "@vexenhanh/ui/components/form-field";
import { Input } from "@vexenhanh/ui/components/input";
import { BUTTON, ListStatePanel } from "@vexenhanh/ui/components/list-parts";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@vexenhanh/ui/components/select";
import { Textarea } from "@vexenhanh/ui/components/textarea";
import { ApiError } from "@vexenhanh/ui/lib/auth/api-client";
import { ArrowLeft, CircleAlert, CircleCheck, Eye, EyeOff, FileX2, ImageIcon, LoaderCircle, RefreshCw, Upload } from "lucide-react";
import Link from "next/link";
import { useRouter, useSearchParams } from "next/navigation";
import { useRef, useState, type FormEvent, type ReactNode } from "react";

import { uploadImageFile } from "../../lib/article/article-api";
import { formatDate, slugify } from "../../lib/article/article-format";
import { compressImage, imageFileProblem } from "../../lib/article/image-compress";
import {
  createContentPage,
  getContentPage,
  requestContentImageUpload,
  setContentPageStatus,
  updateContentPage,
  type ContentPage,
  type ContentPageStatus
} from "../../lib/content/content-page-api";
import {
  BODY_LABEL,
  changeType,
  CONTENT_BODY_MAX,
  CONTENT_SLUG_MAX,
  CONTENT_STATUS,
  CONTENT_TITLE_MAX,
  contentErrors,
  describeContentError,
  emptyContentValues,
  PLACEMENT_LABEL,
  PLACEMENTS_BY_TYPE,
  toContentInput,
  TYPE_LABEL,
  TYPE_ORDER,
  type ContentField,
  type ContentFormValues
} from "../../lib/content/content-page-format";
import { MarkdownPreview } from "../article/markdown-preview";

const BACK_HREF = "/moderation?tab=public-content";
const PUBLISHED_NOTICE = "Nội dung đang hiển thị công khai.";

/**
 * Trang Thêm / Sửa nội dung công khai (TASK-ADM-003 — chưa có khung Figma, dựng theo trang soạn bài viết ADM-13b): loại,
 * vị trí, tiêu đề, đường dẫn (trang tĩnh), ảnh + liên kết (banner), nội dung Markdown + xem trước; Hiển thị / Ẩn.
 */
export function ContentPageEditor({ id }: { id: string | null }) {
  const params = useSearchParams();
  const [notice, setNotice] = useState<string | null>(
    params.get("published") === "1" ? PUBLISHED_NOTICE : params.get("created") === "1" ? "Đã tạo nội dung (bản nháp)." : null
  );
  const detail = useQuery({ queryKey: ["admin-content-page", id], queryFn: () => getContentPage(id!), enabled: id !== null });

  if (id !== null && detail.isPending) {
    return (
      <div role="status" aria-label="Đang tải nội dung" className="flex flex-col gap-6">
        <BackLink />
        <div className="h-10 w-1/2 animate-pulse rounded bg-muted" />
        <div className="h-96 animate-pulse rounded-xl bg-muted" />
      </div>
    );
  }
  if (id !== null && detail.isError) {
    const missing = detail.error instanceof ApiError && detail.error.status === 404;
    return (
      <div className="flex flex-col gap-6">
        <BackLink />
        <section className="rounded-xl border bg-card">
          <ListStatePanel
            icon={missing ? <FileX2 className="size-6 text-vxn-fg-3" /> : <CircleAlert className="size-6 text-warning-700" />}
            title={missing ? "Không tìm thấy nội dung" : "Không tải được nội dung"}
            description={missing ? "Nội dung không tồn tại." : "Kiểm tra kết nối mạng rồi thử lại."}
            action={
              missing ? undefined : (
                <Button className={`${BUTTON} w-36`} onClick={() => void detail.refetch()}>
                  <RefreshCw className="size-[18px]" />
                  Thử lại
                </Button>
              )
            }
          />
        </section>
      </div>
    );
  }
  // Dựng lại form theo phiên bản đã lưu: sau mỗi lần lưu / đổi trạng thái form lấy đúng dữ liệu máy chủ.
  return <EditorForm key={detail.data?.updatedAt ?? "new"} page={detail.data ?? null} notice={notice} onNotice={setNotice} />;
}

function toValues(page: ContentPage): ContentFormValues {
  return {
    type: page.type,
    placement: page.placement,
    title: page.title,
    slug: page.slug ?? "",
    bodyMarkdown: page.bodyMarkdown,
    imageKey: page.imageKey,
    linkUrl: page.linkUrl ?? "",
    displayOrder: String(page.displayOrder)
  };
}

function EditorForm({ page, notice, onNotice }: { page: ContentPage | null; notice: string | null; onNotice: (message: string | null) => void }) {
  const router = useRouter();
  const queryClient = useQueryClient();
  const saved = page ? toValues(page) : emptyContentValues();
  const [values, setValues] = useState<ContentFormValues>(saved);
  const [slugTouched, setSlugTouched] = useState(page !== null);
  const [imageUrl, setImageUrl] = useState<string | null>(page?.imageUrl ?? null);
  const [errors, setErrors] = useState<Partial<Record<ContentField, string>>>({});
  const [uploading, setUploading] = useState(false);
  const fileInput = useRef<HTMLInputElement>(null);
  const status: ContentPageStatus = page?.status ?? "DRAFT";
  const dirty = page === null || JSON.stringify(values) !== JSON.stringify(saved);

  function set<K extends keyof ContentFormValues>(key: K, value: ContentFormValues[K]) {
    setValues((current) => ({ ...current, [key]: value }));
    setErrors((current) => ({ ...current, [key]: undefined, form: undefined }));
  }

  const save = useMutation({
    mutationFn: async (then: "save" | ContentPageStatus) => {
      let result = page;
      if (dirty || !result) {
        const input = toContentInput(values);
        result = result ? await updateContentPage(result.id, input) : await createContentPage(input);
      }
      if (then !== "save") {
        result = await setContentPageStatus(result.id, then);
      }
      return { result, then };
    },
    onSuccess: ({ result, then }) => {
      queryClient.setQueryData(["admin-content-page", result.id], result);
      void queryClient.invalidateQueries({ queryKey: ["admin-content-pages"] });
      if (!page) {
        router.replace(`/moderation/content/${result.id}?${then === "PUBLISHED" ? "published" : "created"}=1`);
        return;
      }
      onNotice(then === "PUBLISHED" ? PUBLISHED_NOTICE : then === "DRAFT" ? "Đã ẩn nội dung (về bản nháp)." : "Đã lưu thay đổi.");
    },
    onError: (error) => {
      const described = describeContentError(error);
      setErrors({ [described.field]: described.message });
    }
  });
  const busy = save.isPending || uploading;

  function submit(then: "save" | ContentPageStatus) {
    onNotice(null);
    const found = then === "DRAFT" ? {} : contentErrors(values);
    setErrors(found);
    if (Object.keys(found).length === 0) {
      save.mutate(then);
    }
  }

  async function upload(file: File) {
    const problem = imageFileProblem(file);
    if (problem) {
      setErrors((current) => ({ ...current, imageKey: problem }));
      return;
    }
    setUploading(true);
    try {
      const blob = await compressImage(file);
      const granted = await requestContentImageUpload("image/jpeg", blob.size);
      await uploadImageFile(granted.uploadUrl, blob);
      set("imageKey", granted.objectKey);
      setImageUrl(granted.publicUrl);
    } catch {
      setErrors((current) => ({ ...current, imageKey: "Không tải được ảnh lên. Kiểm tra tệp và kết nối rồi thử lại." }));
    } finally {
      setUploading(false);
    }
  }

  const statusLabel = CONTENT_STATUS[status];

  return (
    <form
      noValidate
      onSubmit={(event: FormEvent) => {
        event.preventDefault();
        submit("save");
      }}
      className="flex flex-col gap-6"
    >
      <BackLink />
      <header className="flex flex-wrap items-center gap-x-6 gap-y-3">
        <div className="flex min-w-0 flex-[1_1_18rem] flex-col gap-1.5">
          <h1 className="text-[30px] leading-[38px] font-semibold text-vxn-ink">{page ? "Sửa nội dung" : "Thêm nội dung"}</h1>
          <p className="text-sm leading-5 text-muted-foreground">
            {page
              ? `Cập nhật ${formatDate(page.updatedAt)}${page.updatedByName ? ` · ${page.updatedByName}` : ""}`
              : "Nội dung mới lưu ở dạng bản nháp, chưa hiện ngoài trang công khai."}
          </p>
        </div>
        <div className="flex flex-wrap items-center gap-3">
          <Badge tone={statusLabel.tone}>{page ? statusLabel.label : "Bản nháp"}</Badge>
          <Button type="submit" variant="outline" className={`${BUTTON} bg-card`} disabled={busy || (page !== null && !dirty)}>
            {save.isPending && save.variables === "save" && <LoaderCircle className="size-[18px] animate-spin" />}
            {page ? "Lưu thay đổi" : "Lưu nháp"}
          </Button>
          {status === "PUBLISHED" ? (
            <Button type="button" variant="outline" className={`${BUTTON} bg-card`} disabled={busy} onClick={() => submit("DRAFT")}>
              {save.isPending && save.variables === "DRAFT" ? <LoaderCircle className="size-[18px] animate-spin" /> : <EyeOff className="size-[18px]" />}
              Ẩn
            </Button>
          ) : (
            <Button type="button" className={BUTTON} disabled={busy} onClick={() => submit("PUBLISHED")}>
              {save.isPending && save.variables === "PUBLISHED" ? <LoaderCircle className="size-[18px] animate-spin" /> : <Eye className="size-[18px]" />}
              Hiển thị
            </Button>
          )}
        </div>
      </header>
      {notice && (
        <div role="status" className="flex items-center gap-3 rounded-lg bg-success-50 px-5 py-3 text-sm leading-5 text-success-700">
          <CircleCheck className="size-5 shrink-0" />
          {notice}
        </div>
      )}
      {errors.form && (
        <div role="alert" className="flex items-center gap-3 rounded-lg bg-error-50 px-5 py-3 text-sm leading-5 text-error-600">
          <CircleAlert className="size-5 shrink-0" />
          {errors.form}
        </div>
      )}

      <div className="grid items-start gap-6 lg:grid-cols-[minmax(0,1fr)_400px]">
        <Card>
          <div className="grid gap-4 sm:grid-cols-2">
            <FormField label="Loại nội dung *" helper={page ? "Không đổi được loại sau khi tạo." : undefined}>
              {(control) => (
                <Select
                  value={values.type}
                  onValueChange={(next) => next && setValues(changeType(values, next as ContentFormValues["type"]))}
                  disabled={page !== null || busy}
                >
                  <SelectTrigger {...control}>
                    <SelectValue />
                  </SelectTrigger>
                  <SelectContent>
                    {TYPE_ORDER.map((type) => (
                      <SelectItem key={type} value={type}>
                        {TYPE_LABEL[type]}
                      </SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              )}
            </FormField>
            <FormField label="Vị trí hiển thị *">
              {(control) => (
                // Radix Select báo giá trị rỗng khi danh sách vị trí đổi theo loại — bỏ qua, vị trí đã được đặt ở `changeType`.
                <Select value={values.placement} onValueChange={(next) => next && set("placement", next as ContentFormValues["placement"])} disabled={busy}>
                  <SelectTrigger {...control}>
                    <SelectValue />
                  </SelectTrigger>
                  <SelectContent>
                    {PLACEMENTS_BY_TYPE[values.type].map((placement) => (
                      <SelectItem key={placement} value={placement}>
                        {PLACEMENT_LABEL[placement]}
                      </SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              )}
            </FormField>
          </div>
          <FormField label={values.type === "FAQ" ? "Câu hỏi *" : "Tiêu đề *"} error={errors.title}>
            {(control) => (
              <Input
                {...control}
                value={values.title}
                maxLength={CONTENT_TITLE_MAX}
                disabled={busy}
                onChange={(event) => {
                  set("title", event.target.value);
                  if (values.type === "PAGE" && !slugTouched) {
                    set("slug", slugify(event.target.value, CONTENT_SLUG_MAX));
                  }
                }}
              />
            )}
          </FormField>
          {values.type === "PAGE" && (
            <FormField label="Đường dẫn *" helper="Duy nhất; chữ thường không dấu, số, gạch nối." error={errors.slug}>
              {(control) => (
                <div className="flex min-w-0 items-stretch overflow-hidden rounded-md border border-input focus-within:ring-[3px] focus-within:ring-ring/50">
                  <span className="flex shrink-0 items-center border-r bg-muted px-3 text-sm text-muted-foreground">/trang/</span>
                  <input
                    {...control}
                    value={values.slug}
                    maxLength={CONTENT_SLUG_MAX}
                    disabled={busy}
                    className="h-9 min-w-0 flex-1 bg-transparent px-3 text-sm outline-none"
                    onChange={(event) => {
                      setSlugTouched(true);
                      set("slug", event.target.value.toLowerCase());
                    }}
                  />
                </div>
              )}
            </FormField>
          )}
          {values.type === "BANNER" && (
            <>
              <div className="flex flex-col gap-1.5">
                <span className="text-sm leading-5 font-medium text-vxn-ink">Ảnh banner *</span>
                <div className="flex flex-wrap items-center gap-3">
                  <div className="relative h-20 w-40 shrink-0 overflow-hidden rounded-md bg-muted">
                    {imageUrl ? (
                      <img src={imageUrl} alt="Ảnh banner" className="absolute inset-0 size-full object-cover" />
                    ) : (
                      <ImageIcon className="absolute inset-0 m-auto size-5 text-muted-foreground" />
                    )}
                  </div>
                  <Button type="button" variant="outline" className={`${BUTTON} bg-card`} disabled={busy} onClick={() => fileInput.current?.click()}>
                    {uploading ? <LoaderCircle className="size-[18px] animate-spin" /> : <Upload className="size-[18px]" />}
                    {values.imageKey ? "Đổi ảnh" : "Tải ảnh lên"}
                  </Button>
                  <input
                    ref={fileInput}
                    type="file"
                    accept="image/jpeg,image/png,image/webp"
                    aria-label="Chọn ảnh banner"
                    className="sr-only"
                    onChange={(event) => {
                      const file = event.target.files?.[0];
                      event.target.value = "";
                      if (file) {
                        void upload(file);
                      }
                    }}
                  />
                </div>
                <p role={errors.imageKey ? "alert" : undefined} className={`text-xs leading-[18px] ${errors.imageKey ? "text-error-600" : "text-muted-foreground"}`}>
                  {errors.imageKey ?? "JPEG, PNG hoặc WebP; ảnh được thu nhỏ còn cạnh dài 1600 px trước khi tải lên."}
                </p>
              </div>
              <FormField label="Liên kết khi bấm" helper="Tuỳ chọn: /tim-chuyen hoặc https://…" error={errors.linkUrl}>
                {(control) => <Input {...control} value={values.linkUrl} maxLength={300} disabled={busy} onChange={(event) => set("linkUrl", event.target.value)} />}
              </FormField>
            </>
          )}
          <FormField
            label={BODY_LABEL[values.type]}
            helper={`Markdown · ${values.bodyMarkdown.length.toLocaleString("vi-VN")} / ${CONTENT_BODY_MAX.toLocaleString("vi-VN")} ký tự`}
            error={errors.bodyMarkdown}
          >
            {(control) => (
              <Textarea
                {...control}
                rows={values.type === "BANNER" ? 3 : 12}
                value={values.bodyMarkdown}
                maxLength={CONTENT_BODY_MAX}
                disabled={busy}
                className="font-mono text-[13px]"
                onChange={(event) => set("bodyMarkdown", event.target.value)}
              />
            )}
          </FormField>
          <FormField label="Thứ tự hiển thị *" helper="Số nhỏ hiện trước trong cùng vị trí." error={errors.displayOrder}>
            {(control) => (
              <Input {...control} inputMode="numeric" maxLength={3} className="w-28" value={values.displayOrder} disabled={busy} onChange={(event) => set("displayOrder", event.target.value)} />
            )}
          </FormField>
        </Card>

        <section aria-labelledby="content-preview-heading" className="flex min-w-0 flex-col gap-4 rounded-xl border bg-card p-6 lg:sticky lg:top-6">
          <div className="flex flex-col gap-1">
            <h2 id="content-preview-heading" className="text-base leading-6 font-semibold text-vxn-ink">
              Xem trước
            </h2>
            <p className="text-xs leading-[18px] text-muted-foreground">
              {TYPE_LABEL[values.type]} · {PLACEMENT_LABEL[values.placement]}
            </p>
          </div>
          {values.type === "BANNER" && imageUrl && <img src={imageUrl} alt="" className="aspect-[21/9] w-full rounded-lg object-cover" />}
          <p className="text-lg leading-7 font-semibold text-vxn-ink">{values.title || "Tiêu đề"}</p>
          <MarkdownPreview markdown={values.bodyMarkdown} />
        </section>
      </div>
    </form>
  );
}

function Card({ children }: { children: ReactNode }) {
  return <section className="flex min-w-0 flex-col gap-4 rounded-xl border bg-card p-6">{children}</section>;
}

function BackLink() {
  return (
    <Link href={BACK_HREF} className="flex w-fit items-center gap-2 text-sm leading-5 font-medium text-primary hover:underline">
      <ArrowLeft className="size-4" />
      Về Kiểm duyệt
    </Link>
  );
}
