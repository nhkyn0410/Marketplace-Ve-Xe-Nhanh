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
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle
} from "@vexenhanh/ui/components/dialog";
import { FormField } from "@vexenhanh/ui/components/form-field";
import { Input } from "@vexenhanh/ui/components/input";
import { TABLE, TABLE_CELL, TABLE_HEAD_CELL, TABLE_HEAD_ROW, TableSkeleton } from "@vexenhanh/ui/components/list-controls";
import { BUTTON, ListFooterNote, ListStatePanel } from "@vexenhanh/ui/components/list-parts";
import { ApiError } from "@vexenhanh/ui/lib/auth/api-client";
import { Ban, CircleAlert, FolderOpen, Info, LoaderCircle, Pencil, RefreshCw, RotateCcw } from "lucide-react";
import { useState, type FormEvent } from "react";

import {
  createArticleCategory,
  listArticleCategories,
  updateArticleCategory,
  type ArticleCategory,
  type ArticleCategoryInput
} from "../../lib/article/article-api";
import { slugError, slugify } from "../../lib/article/article-format";

/** Tab "Chuyên mục" (Figma ADM-13c): thứ tự hiển thị, số bài, ngừng dùng / dùng lại; hộp thoại thêm / sửa. */
export function CategoryPanel({
  editing,
  onEdit,
  onCloseEdit,
  onDone
}: {
  /** `null` = đóng hộp thoại; `"new"` = thêm mới. */
  editing: ArticleCategory | "new" | null;
  onEdit: (category: ArticleCategory) => void;
  onCloseEdit: () => void;
  onDone: (message: string) => void;
}) {
  const queryClient = useQueryClient();
  const categories = useQuery({ queryKey: ["admin-article-categories"], queryFn: listArticleCategories });
  const [toggling, setToggling] = useState<ArticleCategory | null>(null);
  const toggle = useMutation({
    mutationFn: (category: ArticleCategory) =>
      updateArticleCategory(category.id, {
        name: category.name,
        slug: category.slug,
        displayOrder: category.displayOrder,
        status: category.status === "ACTIVE" ? "INACTIVE" : "ACTIVE"
      }),
    onSuccess: (saved) => {
      void queryClient.invalidateQueries({ queryKey: ["admin-article-categories"] });
      onDone(saved.status === "ACTIVE" ? `Đã dùng lại chuyên mục “${saved.name}”.` : `Đã ngừng dùng chuyên mục “${saved.name}”.`);
      setToggling(null);
    }
  });

  let body;
  if (categories.isError) {
    body = (
      <ListStatePanel
        icon={<CircleAlert className="size-6 text-warning-700" />}
        title="Không tải được chuyên mục"
        description="Kiểm tra kết nối mạng rồi thử lại."
        action={
          <Button className={`${BUTTON} w-36`} onClick={() => void categories.refetch()}>
            <RefreshCw className="size-[18px]" />
            Thử lại
          </Button>
        }
      />
    );
  } else if (categories.isPending) {
    body = <TableSkeleton label="Đang tải chuyên mục" rows={5} />;
  } else if (categories.data.length === 0) {
    body = (
      <ListStatePanel
        icon={<FolderOpen className="size-6 text-vxn-fg-3" />}
        title="Chưa có chuyên mục"
        description="Thêm chuyên mục để xếp bài viết trên trang Khám phá."
      />
    );
  } else {
    body = (
      <div className="relative overflow-x-auto">
        <table className={`${TABLE} min-w-[720px]`}>
          <colgroup>
            <col />
            <col className="w-[26%]" />
            <col className="w-[14%]" />
            <col className="w-[9%]" />
            <col className="w-[13%]" />
            <col className="w-[10%]" />
          </colgroup>
          <thead>
            <tr className={TABLE_HEAD_ROW}>
              <th scope="col" className={TABLE_HEAD_CELL}>
                Tên chuyên mục
              </th>
              <th scope="col" className={TABLE_HEAD_CELL}>
                Slug
              </th>
              <th scope="col" className={`${TABLE_HEAD_CELL} text-right`}>
                Thứ tự hiển thị
              </th>
              <th scope="col" className={`${TABLE_HEAD_CELL} text-right`}>
                Số bài
              </th>
              <th scope="col" className={TABLE_HEAD_CELL}>
                Trạng thái
              </th>
              <th scope="col" className={TABLE_HEAD_CELL}>
                <span className="sr-only">Thao tác</span>
              </th>
            </tr>
          </thead>
          <tbody>
            {categories.data.map((category) => (
              <tr key={category.id} className="h-14 border-b">
                <td className={`${TABLE_CELL} font-semibold text-vxn-ink`}>{category.name}</td>
                <td className={TABLE_CELL}>{category.slug}</td>
                <td className={`${TABLE_CELL} text-right`}>{category.displayOrder}</td>
                <td className={`${TABLE_CELL} text-right`}>{category.articleCount}</td>
                <td className={TABLE_CELL}>
                  <Badge tone={category.status === "ACTIVE" ? "success" : "neutral"}>
                    {category.status === "ACTIVE" ? "Đang dùng" : "Ngừng dùng"}
                  </Badge>
                </td>
                <td className={TABLE_CELL}>
                  <div className="flex items-center justify-end gap-1">
                    <Button variant="ghost" size="icon" aria-label={`Sửa chuyên mục ${category.name}`} onClick={() => onEdit(category)}>
                      <Pencil className="size-4" />
                    </Button>
                    <Button
                      variant="ghost"
                      size="icon"
                      aria-label={`${category.status === "ACTIVE" ? "Ngừng dùng" : "Dùng lại"} chuyên mục ${category.name}`}
                      onClick={() => setToggling(category)}
                    >
                      {category.status === "ACTIVE" ? <Ban className="size-4" /> : <RotateCcw className="size-4" />}
                    </Button>
                  </div>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    );
  }

  return (
    <>
      <section aria-label="Chuyên mục bài viết" className="flex flex-col rounded-xl border bg-card p-6">
        <div className="min-h-[240px]">{body}</div>
        {categories.data && categories.data.length > 0 && (
          <div className="flex min-h-14 items-center pt-5">
            <ListFooterNote>{categories.data.length} chuyên mục</ListFooterNote>
          </div>
        )}
      </section>
      <div className="flex items-center gap-4 rounded-lg bg-accent px-5 py-4">
        <Info className="size-5 shrink-0 text-accent-foreground" />
        <p className="min-w-0 flex-1 text-sm leading-5 text-accent-foreground">
          Thứ tự hiển thị quyết định vị trí chuyên mục trên trang Khám phá. Chuyên mục ngừng dùng không chọn được cho bài mới.
        </p>
      </div>
      <AlertDialog open={toggling !== null} onOpenChange={(open) => !open && !toggle.isPending && setToggling(null)}>
        {toggling && (
          <AlertDialogContent>
            <AlertDialogHeader>
              <AlertDialogTitle>
                {toggling.status === "ACTIVE" ? `Ngừng dùng chuyên mục “${toggling.name}”?` : `Dùng lại chuyên mục “${toggling.name}”?`}
              </AlertDialogTitle>
              <AlertDialogDescription>
                {toggling.status === "ACTIVE"
                  ? `Chuyên mục ẩn khỏi trang Khám phá và không chọn được cho bài mới. ${toggling.articleCount} bài đang thuộc chuyên mục giữ nguyên.`
                  : "Chuyên mục hiện lại trên trang Khám phá và chọn được cho bài mới."}
              </AlertDialogDescription>
            </AlertDialogHeader>
            {toggle.isError && <p className="text-sm text-error-600">Chưa lưu được. Vui lòng thử lại.</p>}
            <AlertDialogFooter>
              <AlertDialogCancel disabled={toggle.isPending}>Hủy</AlertDialogCancel>
              <AlertDialogAction
                disabled={toggle.isPending}
                onClick={(event) => {
                  event.preventDefault();
                  toggle.mutate(toggling);
                }}
              >
                {toggling.status === "ACTIVE" ? "Ngừng dùng" : "Dùng lại"}
              </AlertDialogAction>
            </AlertDialogFooter>
          </AlertDialogContent>
        )}
      </AlertDialog>
      <CategoryDialog
        target={editing}
        nextOrder={Math.max(0, ...(categories.data ?? []).map((category) => category.displayOrder)) + 1}
        onClose={onCloseEdit}
        onDone={onDone}
      />
    </>
  );
}

function CategoryDialog({
  target,
  nextOrder,
  onClose,
  onDone
}: {
  target: ArticleCategory | "new" | null;
  nextOrder: number;
  onClose: () => void;
  onDone: (message: string) => void;
}) {
  const [pending, setPending] = useState(false);
  return (
    <Dialog open={target !== null} onOpenChange={(open) => !open && !pending && onClose()}>
      {target && (
        <CategoryForm
          key={target === "new" ? "new" : target.id}
          category={target === "new" ? null : target}
          nextOrder={nextOrder}
          onClose={onClose}
          onDone={onDone}
          onPendingChange={setPending}
        />
      )}
    </Dialog>
  );
}

function CategoryForm({
  category,
  nextOrder,
  onClose,
  onDone,
  onPendingChange
}: {
  category: ArticleCategory | null;
  nextOrder: number;
  onClose: () => void;
  onDone: (message: string) => void;
  onPendingChange: (pending: boolean) => void;
}) {
  const queryClient = useQueryClient();
  const [name, setName] = useState(category?.name ?? "");
  const [slug, setSlug] = useState(category?.slug ?? "");
  const [slugTouched, setSlugTouched] = useState(category !== null);
  const [order, setOrder] = useState(String(category?.displayOrder ?? nextOrder));
  const [errors, setErrors] = useState<{ name?: string; slug?: string; order?: string; form?: string }>({});
  const save = useMutation({
    mutationFn: (input: ArticleCategoryInput) => (category ? updateArticleCategory(category.id, input) : createArticleCategory(input)),
    onMutate: () => onPendingChange(true),
    onSettled: () => onPendingChange(false),
    onSuccess: (saved) => {
      void queryClient.invalidateQueries({ queryKey: ["admin-article-categories"] });
      onDone(category ? `Đã lưu chuyên mục “${saved.name}”.` : `Đã thêm chuyên mục “${saved.name}”.`);
      onClose();
    },
    onError: (error) => {
      if (error instanceof ApiError && error.code === "ARTICLE_CATEGORY_SLUG_CONFLICT") {
        setErrors({ slug: "Slug này đã được dùng cho chuyên mục khác." });
      } else {
        setErrors({ form: "Chưa lưu được. Kiểm tra kết nối rồi thử lại." });
      }
    }
  });

  function submit(event: FormEvent) {
    event.preventDefault();
    const next: typeof errors = {};
    if (name.trim() === "" || name.trim().length > 60) {
      next.name = "Tên gồm 1–60 ký tự.";
    }
    const slugProblem = slugError(slug, 60);
    if (slugProblem) {
      next.slug = slugProblem;
    }
    const orderValue = Number(order);
    if (!Number.isInteger(orderValue) || orderValue < 0 || orderValue > 999) {
      next.order = "Thứ tự là số nguyên 0–999.";
    }
    setErrors(next);
    if (Object.keys(next).length === 0) {
      save.mutate({ name: name.trim(), slug, displayOrder: orderValue, status: category?.status ?? "ACTIVE" });
    }
  }

  return (
    <DialogContent className="sm:max-w-[480px]">
      <DialogHeader>
        <DialogTitle>{category ? "Sửa chuyên mục" : "Thêm chuyên mục"}</DialogTitle>
        <DialogDescription>Chuyên mục xếp bài viết trên trang Khám phá.</DialogDescription>
      </DialogHeader>
      <form noValidate onSubmit={submit} className="flex flex-col gap-4">
        <FormField label="Tên chuyên mục *" error={errors.name}>
          {(control) => (
            <Input
              {...control}
              value={name}
              maxLength={60}
              autoFocus
              disabled={save.isPending}
              onChange={(event) => {
                setName(event.target.value);
                if (!slugTouched) {
                  setSlug(slugify(event.target.value, 60));
                }
              }}
            />
          )}
        </FormField>
        <FormField label="Slug *" helper="Chữ thường không dấu, số và gạch ngang." error={errors.slug}>
          {(control) => (
            <Input
              {...control}
              value={slug}
              maxLength={60}
              disabled={save.isPending}
              onChange={(event) => {
                setSlug(event.target.value.toLowerCase());
                setSlugTouched(true);
              }}
            />
          )}
        </FormField>
        <FormField label="Thứ tự hiển thị *" helper="Nhỏ đứng trước." error={errors.order}>
          {(control) => (
            <Input
              {...control}
              type="number"
              min={0}
              max={999}
              value={order}
              disabled={save.isPending}
              onChange={(event) => setOrder(event.target.value)}
            />
          )}
        </FormField>
        {errors.form && (
          <div role="alert" className="flex items-center gap-3 rounded-lg bg-error-50 px-4 py-3 text-sm leading-5 text-error-600">
            <CircleAlert className="size-5 shrink-0" />
            {errors.form}
          </div>
        )}
        <DialogFooter>
          <Button type="button" variant="outline" className={`${BUTTON} bg-card`} disabled={save.isPending} onClick={onClose}>
            Hủy
          </Button>
          <Button type="submit" className={BUTTON} disabled={save.isPending}>
            {save.isPending && <LoaderCircle className="size-[18px] animate-spin" />}
            Lưu
          </Button>
        </DialogFooter>
      </form>
    </DialogContent>
  );
}
