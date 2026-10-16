"use client";

import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import {
  AlertDialog,
  AlertDialogAction,
  AlertDialogCancel,
  AlertDialogContent,
  AlertDialogDescription,
  AlertDialogFooter,
  AlertDialogHeader,
  AlertDialogTitle
} from "@vexenhanh/ui/components/alert-dialog";
import { Badge } from "@vexenhanh/ui/components/badge";
import { Button } from "@vexenhanh/ui/components/button";
import { FormField } from "@vexenhanh/ui/components/form-field";
import { Input } from "@vexenhanh/ui/components/input";
import { BUTTON, ListStatePanel } from "@vexenhanh/ui/components/list-parts";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@vexenhanh/ui/components/select";
import { Switch } from "@vexenhanh/ui/components/switch";
import { Textarea } from "@vexenhanh/ui/components/textarea";
import { ApiError } from "@vexenhanh/ui/lib/auth/api-client";
import {
  ArrowLeft,
  CircleAlert,
  CircleCheck,
  FileX2,
  ImageIcon,
  ImagePlus,
  Info,
  LoaderCircle,
  RefreshCw,
  Send,
  Trash2,
  Upload
} from "lucide-react";
import Link from "next/link";
import { useRouter, useSearchParams } from "next/navigation";
import { useRef, useState, type FormEvent, type ReactNode } from "react";

import {
  archiveArticle,
  createArticle,
  getArticle,
  listArticleCategories,
  publishArticle,
  requestImageUpload,
  updateArticle,
  uploadImageFile,
  type Article,
  type ArticleInput
} from "../../lib/article/article-api";
import {
  ARTICLE_STATUS,
  articleErrors,
  CONTENT_MAX,
  describeArticleError,
  formatDate,
  insertAt,
  localInputToIso,
  savedLine,
  slugify,
  SUMMARY_MAX,
  TITLE_MAX,
  type ArticleField,
  type ArticleFormValues
} from "../../lib/article/article-format";
import { compressImage, imageFileProblem } from "../../lib/article/image-compress";
import { MarkdownPreview } from "./markdown-preview";

const EMPTY: ArticleFormValues = {
  title: "",
  slug: "",
  summary: "",
  contentMarkdown: "",
  categoryId: "",
  coverImageKey: null,
  featured: false
};

/** Trang Viết bài mới / Sửa bài viết (Figma ADM-13b; UC-40). `articleId` null = bài mới. */
export function ArticleEditor({ articleId }: { articleId: string | null }) {
  const params = useSearchParams();
  // Thông báo nằm ở đây, không ở form: form dựng lại sau mỗi lần lưu nên giữ trong form sẽ mất.
  const [notice, setNotice] = useState<string | null>(noticeFromParams(params));
  const detail = useQuery({
    queryKey: ["admin-article", articleId],
    queryFn: () => getArticle(articleId!),
    enabled: articleId !== null
  });

  if (articleId !== null && detail.isPending) {
    return (
      <div role="status" aria-label="Đang tải bài viết" className="flex flex-col gap-6">
        <BackLink />
        <div className="h-10 w-1/2 animate-pulse rounded bg-muted" />
        <div className="h-96 animate-pulse rounded-xl bg-muted" />
      </div>
    );
  }
  if (articleId !== null && detail.isError) {
    const missing = detail.error instanceof ApiError && detail.error.status === 404;
    return (
      <div className="flex flex-col gap-6">
        <BackLink />
        <section className="rounded-xl border bg-card">
          <ListStatePanel
            icon={missing ? <FileX2 className="size-6 text-vxn-fg-3" /> : <CircleAlert className="size-6 text-warning-700" />}
            title={missing ? "Không tìm thấy bài viết" : "Không tải được bài viết"}
            description={missing ? "Bài viết không tồn tại." : "Kiểm tra kết nối mạng rồi thử lại."}
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
  // Remount theo phiên bản đã lưu: sau mỗi lần lưu / đổi trạng thái form lấy lại đúng dữ liệu máy chủ.
  return (
    <EditorForm key={detail.data?.updatedAt ?? "new"} article={detail.data ?? null} notice={notice} onNotice={setNotice} />
  );
}

function EditorForm({
  article,
  notice,
  onNotice
}: {
  article: Article | null;
  notice: string | null;
  onNotice: (message: string | null) => void;
}) {
  const router = useRouter();
  const queryClient = useQueryClient();
  const categories = useQuery({ queryKey: ["admin-article-categories"], queryFn: listArticleCategories });
  const [values, setValues] = useState<ArticleFormValues>(
    article
      ? {
          title: article.title,
          slug: article.slug,
          summary: article.summary,
          contentMarkdown: article.contentMarkdown,
          categoryId: article.categoryId,
          coverImageKey: article.coverImageKey,
          featured: article.featured
        }
      : EMPTY
  );
  const [slugTouched, setSlugTouched] = useState(article !== null);
  const [coverUrl, setCoverUrl] = useState<string | null>(article?.coverImageUrl ?? null);
  const [publishAt, setPublishAt] = useState("");
  const [errors, setErrors] = useState<Partial<Record<ArticleField | "form", string>>>({});
  const [uploading, setUploading] = useState<"cover" | "inline" | null>(null);
  const [confirmArchive, setConfirmArchive] = useState(false);
  const contentRef = useRef<HTMLTextAreaElement>(null);
  const coverInput = useRef<HTMLInputElement>(null);
  const inlineInput = useRef<HTMLInputElement>(null);

  const status = article?.status ?? "DRAFT";
  const dirty =
    article === null ||
    values.title !== article.title ||
    values.slug !== article.slug ||
    values.summary !== article.summary ||
    values.contentMarkdown !== article.contentMarkdown ||
    values.categoryId !== article.categoryId ||
    values.coverImageKey !== article.coverImageKey ||
    values.featured !== article.featured;

  function set<K extends keyof ArticleFormValues>(key: K, value: ArticleFormValues[K]) {
    setValues((current) => ({ ...current, [key]: value }));
    setErrors((current) => ({ ...current, [key]: undefined, form: undefined }));
  }

  function input(): ArticleInput {
    return {
      title: values.title.trim(),
      slug: values.slug,
      summary: values.summary.trim(),
      contentMarkdown: values.contentMarkdown,
      categoryId: values.categoryId,
      coverImageKey: values.coverImageKey,
      featured: values.featured
    };
  }

  function refresh(saved: Article) {
    queryClient.setQueryData(["admin-article", saved.id], saved);
    void queryClient.invalidateQueries({ queryKey: ["admin-articles"] });
    void queryClient.invalidateQueries({ queryKey: ["admin-article-categories"] });
  }

  function fail(error: unknown) {
    const described = describeArticleError(error);
    setErrors({ [described.field]: described.message });
    if (described.refresh && article) {
      void queryClient.invalidateQueries({ queryKey: ["admin-article", article.id] });
      void queryClient.invalidateQueries({ queryKey: ["admin-article-categories"] });
    }
  }

  const save = useMutation({
    mutationFn: async (then: "save" | "publish") => {
      let saved = article;
      if (dirty || !saved) {
        saved = saved ? await updateArticle(saved.id, input()) : await createArticle(input());
      }
      if (then === "publish") {
        saved = await publishArticle(saved.id, localInputToIso(publishAt));
      }
      return { saved, then };
    },
    onSuccess: ({ saved, then }) => {
      refresh(saved);
      if (!article) {
        router.replace(`/articles/${saved.id}?${then === "publish" ? "published" : "created"}=1`);
        return;
      }
      onNotice(then === "publish" ? publishedNotice(saved) : "Đã lưu bài viết.");
    },
    onError: fail
  });
  const archive = useMutation({
    mutationFn: () => archiveArticle(article!.id),
    onSuccess: (saved) => {
      setConfirmArchive(false);
      refresh(saved);
      onNotice("Đã gỡ bài viết khỏi trang Khám phá.");
    },
    onError: (error) => {
      setConfirmArchive(false);
      fail(error);
    }
  });
  const busy = save.isPending || archive.isPending || uploading !== null;

  function submit(then: "save" | "publish") {
    onNotice(null);
    const found = articleErrors(values, then === "publish");
    setErrors(found);
    if (Object.keys(found).length === 0) {
      save.mutate(then);
    }
  }

  async function upload(file: File, kind: "cover" | "inline") {
    const problem = imageFileProblem(file);
    if (problem) {
      setErrors((current) => ({ ...current, [kind === "cover" ? "coverImageKey" : "contentMarkdown"]: problem }));
      return;
    }
    setUploading(kind);
    try {
      const blob = await compressImage(file);
      const granted = await requestImageUpload("image/jpeg", blob.size);
      await uploadImageFile(granted.uploadUrl, blob);
      if (kind === "cover") {
        set("coverImageKey", granted.objectKey);
        setCoverUrl(granted.publicUrl);
      } else {
        const area = contentRef.current;
        const start = area?.selectionStart ?? values.contentMarkdown.length;
        const end = area?.selectionEnd ?? start;
        const next = insertAt(values.contentMarkdown, start, end, `![Mô tả ảnh](${granted.publicUrl})`);
        set("contentMarkdown", next.text);
        requestAnimationFrame(() => {
          area?.focus();
          area?.setSelectionRange(next.cursor, next.cursor);
        });
      }
    } catch {
      setErrors((current) => ({
        ...current,
        [kind === "cover" ? "coverImageKey" : "contentMarkdown"]: "Không tải được ảnh lên. Kiểm tra tệp và kết nối rồi thử lại."
      }));
    } finally {
      setUploading(null);
    }
  }

  const categoryOptions = (categories.data ?? []).filter(
    (category) => category.status === "ACTIVE" || category.id === values.categoryId
  );
  const statusLabel = ARTICLE_STATUS[status];

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
          <h1 className="text-[30px] leading-[38px] font-semibold text-vxn-ink">{article ? "Sửa bài viết" : "Viết bài mới"}</h1>
          <p className="text-sm leading-5 text-muted-foreground">
            {article ? savedLine(article.updatedAt, article.updatedByName) : "Bài mới — chưa lưu"}
          </p>
        </div>
        <div className="flex flex-wrap items-center gap-3">
          <Badge tone={statusLabel.tone}>{article ? statusLabel.label : "Nháp"}</Badge>
          {status === "PUBLISHED" ? (
            <>
              <Button type="submit" variant="outline" className={`${BUTTON} bg-card`} disabled={busy || !dirty}>
                {save.isPending && <LoaderCircle className="size-[18px] animate-spin" />}
                Lưu thay đổi
              </Button>
              <Button type="button" variant="destructive" className={BUTTON} disabled={busy} onClick={() => setConfirmArchive(true)}>
                Gỡ bài
              </Button>
            </>
          ) : (
            <>
              <Button type="submit" variant="outline" className={`${BUTTON} bg-card`} disabled={busy || (article !== null && !dirty)}>
                {save.isPending && save.variables === "save" && <LoaderCircle className="size-[18px] animate-spin" />}
                {status === "ARCHIVED" ? "Lưu" : "Lưu nháp"}
              </Button>
              <Button type="button" className={BUTTON} disabled={busy} onClick={() => submit("publish")}>
                {save.isPending && save.variables === "publish" ? (
                  <LoaderCircle className="size-[18px] animate-spin" />
                ) : (
                  <Send className="size-[18px]" />
                )}
                {status === "ARCHIVED" ? "Xuất bản lại" : "Xuất bản"}
              </Button>
            </>
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

      <div className="grid items-start gap-6 lg:grid-cols-[minmax(0,1fr)_340px]">
        <div className="flex min-w-0 flex-col gap-6">
          <Card>
            <FormField label="Tiêu đề *" error={errors.title}>
              {(control) => (
                <Input
                  {...control}
                  value={values.title}
                  maxLength={TITLE_MAX}
                  disabled={busy}
                  onChange={(event) => {
                    set("title", event.target.value);
                    if (!slugTouched) {
                      set("slug", slugify(event.target.value));
                    }
                  }}
                />
              )}
            </FormField>
            <FormField label="Slug *" helper="Slug là duy nhất; trùng slug sẽ được báo khi lưu." error={errors.slug}>
              {(control) => (
                <div className="flex min-w-0 items-stretch overflow-hidden rounded-md border border-input focus-within:ring-[3px] focus-within:ring-ring/50">
                  <span className="flex shrink-0 items-center border-r bg-muted px-3 text-sm text-muted-foreground">/kham-pha/</span>
                  <input
                    {...control}
                    value={values.slug}
                    maxLength={120}
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
            <FormField label="Tóm tắt *" helper="Hiển thị trên thẻ bài viết." error={errors.summary}>
              {(control) => (
                <Textarea
                  {...control}
                  rows={3}
                  value={values.summary}
                  maxLength={SUMMARY_MAX}
                  disabled={busy}
                  onChange={(event) => set("summary", event.target.value)}
                />
              )}
            </FormField>
          </Card>

          <Card
            title="Nội dung"
            action={
              <Button
                type="button"
                variant="outline"
                className={`${BUTTON} bg-card`}
                disabled={busy}
                onClick={() => inlineInput.current?.click()}
              >
                {uploading === "inline" ? <LoaderCircle className="size-[18px] animate-spin" /> : <ImagePlus className="size-[18px]" />}
                Chèn ảnh
              </Button>
            }
          >
            <input
              ref={inlineInput}
              type="file"
              accept="image/jpeg,image/png,image/webp"
              hidden
              aria-label="Chọn ảnh để chèn vào nội dung"
              onChange={(event) => {
                const file = event.target.files?.[0];
                event.target.value = "";
                if (file) {
                  void upload(file, "inline");
                }
              }}
            />
            <div className="grid gap-4 md:grid-cols-2">
              <FormField label="Markdown" error={errors.contentMarkdown}>
                {(control) => (
                  <Textarea
                    {...control}
                    ref={contentRef}
                    rows={16}
                    value={values.contentMarkdown}
                    maxLength={CONTENT_MAX}
                    disabled={busy}
                    className="min-h-80 bg-muted font-mono text-[13px] leading-6"
                    onChange={(event) => set("contentMarkdown", event.target.value)}
                  />
                )}
              </FormField>
              <div className="flex min-w-0 flex-col gap-1.5">
                <span className="text-xs leading-[18px] font-medium text-muted-foreground">Xem trước</span>
                <div aria-label="Xem trước nội dung" className="min-h-80 overflow-auto rounded-lg border p-4">
                  <MarkdownPreview markdown={values.contentMarkdown} />
                </div>
              </div>
            </div>
            <p className="text-xs leading-[18px] text-muted-foreground">
              Nội dung được làm sạch trước khi hiển thị; mã script và HTML bị loại bỏ.
            </p>
          </Card>
        </div>

        <div className="flex flex-col gap-4">
          <Card title="Thiết lập">
            <FormField label="Chuyên mục *" error={errors.categoryId}>
              {(control) => (
                <Select value={values.categoryId} onValueChange={(value) => set("categoryId", value)} disabled={busy}>
                  <SelectTrigger id={control.id} aria-invalid={control["aria-invalid"]} aria-describedby={control["aria-describedby"]}>
                    <SelectValue placeholder="Chọn chuyên mục" />
                  </SelectTrigger>
                  <SelectContent>
                    {categoryOptions.map((category) => (
                      <SelectItem key={category.id} value={category.id}>
                        {category.name}
                        {category.status === "INACTIVE" ? " (ngừng dùng)" : ""}
                      </SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              )}
            </FormField>
            <div className="flex items-center justify-between gap-4">
              <div className="flex flex-col">
                <label htmlFor="article-featured" className="text-sm leading-5 font-medium text-vxn-ink">
                  Bài nổi bật
                </label>
                <span className="text-xs leading-[18px] text-muted-foreground">Hiện ở đầu trang Khám phá</span>
              </div>
              <Switch
                id="article-featured"
                checked={values.featured}
                disabled={busy}
                onCheckedChange={(checked) => set("featured", checked)}
              />
            </div>
            {status === "PUBLISHED" ? (
              <div className="flex flex-col gap-1.5">
                <span className="text-sm leading-5 font-medium text-vxn-ink">Thời điểm xuất bản</span>
                <span className="text-sm leading-5 text-vxn-fg-1">{formatDate(article?.publishedAt ?? null)}</span>
              </div>
            ) : (
              <FormField label="Thời điểm xuất bản" helper="Để trống = ngay khi bấm Xuất bản; chọn giờ sau để hẹn giờ.">
                {(control) => (
                  <Input
                    {...control}
                    type="datetime-local"
                    value={publishAt}
                    disabled={busy}
                    onChange={(event) => setPublishAt(event.target.value)}
                  />
                )}
              </FormField>
            )}
          </Card>

          <Card title="Ảnh bìa">
            <input
              ref={coverInput}
              type="file"
              accept="image/jpeg,image/png,image/webp"
              hidden
              aria-label="Chọn ảnh bìa"
              onChange={(event) => {
                const file = event.target.files?.[0];
                event.target.value = "";
                if (file) {
                  void upload(file, "cover");
                }
              }}
            />
            <div className="relative aspect-[298/160] overflow-hidden rounded-lg bg-muted">
              {coverUrl && values.coverImageKey ? (
                <img src={coverUrl} alt="Ảnh bìa" className="absolute inset-0 size-full object-cover" />
              ) : (
                <div className="absolute inset-0 flex flex-col items-center justify-center gap-1 text-xs text-muted-foreground">
                  <ImageIcon className="size-6" />
                  Chưa có ảnh bìa
                </div>
              )}
            </div>
            {errors.coverImageKey && <p className="text-xs leading-[18px] text-error-600">{errors.coverImageKey}</p>}
            <div className="flex gap-2">
              <Button
                type="button"
                variant="outline"
                className={`${BUTTON} flex-1 bg-card`}
                disabled={busy}
                onClick={() => coverInput.current?.click()}
              >
                {uploading === "cover" ? <LoaderCircle className="size-[18px] animate-spin" /> : <Upload className="size-[18px]" />}
                {values.coverImageKey ? "Đổi ảnh bìa" : "Tải ảnh bìa"}
              </Button>
              {values.coverImageKey && (
                <Button
                  type="button"
                  variant="outline"
                  size="icon"
                  className="size-10 bg-card"
                  aria-label="Bỏ ảnh bìa"
                  disabled={busy}
                  onClick={() => set("coverImageKey", null)}
                >
                  <Trash2 className="size-4" />
                </Button>
              )}
            </div>
          </Card>

          <div className="flex gap-3 rounded-lg bg-accent px-4 py-3 text-sm leading-5 text-accent-foreground">
            <Info className="mt-px size-4 shrink-0" />
            <p>Chỉ bài Đã xuất bản hiện công khai. Xuất bản và gỡ bài đều được ghi nhật ký audit.</p>
          </div>
        </div>
      </div>

      <AlertDialog open={confirmArchive} onOpenChange={(open) => !archive.isPending && setConfirmArchive(open)}>
        <AlertDialogContent>
          <AlertDialogHeader>
            <AlertDialogTitle>Gỡ bài “{article?.title}”?</AlertDialogTitle>
            <AlertDialogDescription>
              Bài không còn hiện trên trang Khám phá nhưng vẫn được giữ lại; bạn có thể xuất bản lại sau.
            </AlertDialogDescription>
          </AlertDialogHeader>
          <AlertDialogFooter>
            <AlertDialogCancel disabled={archive.isPending}>Hủy</AlertDialogCancel>
            <AlertDialogAction
              disabled={archive.isPending}
              onClick={(event) => {
                event.preventDefault();
                archive.mutate();
              }}
            >
              Gỡ bài
            </AlertDialogAction>
          </AlertDialogFooter>
        </AlertDialogContent>
      </AlertDialog>
    </form>
  );
}

function noticeFromParams(params: URLSearchParams): string | null {
  if (params.get("published")) {
    return "Đã xuất bản bài viết.";
  }
  return params.get("created") ? "Đã lưu bài nháp." : null;
}

function publishedNotice(article: Article): string {
  return article.publishedAt && new Date(article.publishedAt).getTime() > Date.now()
    ? `Đã hẹn xuất bản ngày ${formatDate(article.publishedAt)}.`
    : "Đã xuất bản bài viết.";
}

function BackLink() {
  return (
    <Link
      href="/articles"
      className="inline-flex w-fit items-center gap-2 rounded text-sm font-medium text-primary outline-none hover:underline focus-visible:ring-[3px] focus-visible:ring-ring/50"
    >
      <ArrowLeft className="size-4" />
      Quay lại danh sách bài viết
    </Link>
  );
}

function Card({ title, action, children }: { title?: string; action?: ReactNode; children: ReactNode }) {
  return (
    <section aria-label={title} className="flex flex-col gap-4 rounded-xl border bg-card p-6">
      {title && (
        <div className="flex items-center justify-between gap-4">
          <h2 className="text-lg leading-7 font-semibold text-vxn-ink">{title}</h2>
          {action}
        </div>
      )}
      {children}
    </section>
  );
}
