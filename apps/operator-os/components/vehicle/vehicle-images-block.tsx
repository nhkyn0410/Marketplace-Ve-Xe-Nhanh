"use client";

import { Button } from "@vexenhanh/ui/components/button";
import { cn } from "@vexenhanh/ui/lib/utils";
import { CircleAlert, GripVertical, ImagePlus, LoaderCircle, RefreshCw, X } from "lucide-react";
import { useRef, useState, type Dispatch, type DragEvent, type KeyboardEvent, type SetStateAction } from "react";

import { compressImage } from "../../lib/vehicle/image-compress";
import {
  ACCEPTED_IMAGE_TYPES,
  CAPTION_MAX_LENGTH,
  countLabel,
  MAX_IMAGE_BYTES,
  MAX_VEHICLE_IMAGES,
  moveItem,
  OVERSIZE_MESSAGE,
  pickFiles,
  type ImageItem
} from "../../lib/vehicle/vehicle-images";

const CARD = "flex flex-col gap-5 rounded-xl border bg-card p-6";
const HELPER = "text-xs leading-[18px] text-muted-foreground";
const UNREADABLE_MESSAGE = "Không đọc được tệp ảnh. Hãy chọn ảnh JPEG, PNG hoặc WebP khác.";
/** Kiểu dữ liệu kéo thả riêng cho việc đổi chỗ ảnh — phân biệt với kéo tệp từ máy vào. */
const DRAG_TYPE = "application/x-vxn-vehicle-image";

/**
 * Khối "Ảnh phương tiện" của form xe (Figma 02 / 04 / 08, TASK-TRN-009): thêm ảnh (bấm hoặc kéo thả tệp), kéo thả
 * hoặc dùng phím mũi tên để đổi chỗ, sửa chú thích, xóa. Mọi thay đổi chỉ ở form; nút "Lưu phương tiện" mới lưu.
 */
export function VehicleImagesBlock({
  items,
  setItems,
  busy,
  notice,
  error,
  retrying,
  onRetry
}: {
  items: ImageItem[];
  setItems: Dispatch<SetStateAction<ImageItem[]>>;
  /** Đang lưu: khóa mọi thao tác để bộ ảnh gửi đi không đổi giữa chừng. */
  busy: boolean;
  /** Cảnh báo sau lần lưu có ảnh chưa lưu được; thay chỗ ghi chú "hiển thị công khai". */
  notice: string | null;
  /** Lỗi khi gắn bộ ảnh vào xe. */
  error: string | null;
  retrying: boolean;
  /** Thử lưu lại ảnh lỗi; không có khi xe chưa được tạo. */
  onRetry?: () => void;
}) {
  const inputRef = useRef<HTMLInputElement>(null);
  const listRef = useRef<HTMLOListElement>(null);
  const [problems, setProblems] = useState<string[]>([]);
  const [processing, setProcessing] = useState(false);
  const [dragging, setDragging] = useState<string | null>(null);
  const [announcement, setAnnouncement] = useState("");
  const locked = busy || retrying;
  const full = items.length >= MAX_VEHICLE_IMAGES;

  async function addFiles(files: File[]) {
    const { accepted, problems: found } = pickFiles(files, items.length);
    const next = [...found];
    setProcessing(true);
    const added: ImageItem[] = [];
    for (const file of accepted) {
      try {
        const blob = await compressImage(file);
        if (blob.size > MAX_IMAGE_BYTES) {
          next.push(OVERSIZE_MESSAGE);
          continue;
        }
        added.push({
          kind: "new",
          id: crypto.randomUUID(),
          file: blob,
          previewUrl: URL.createObjectURL(blob),
          caption: "",
          objectKey: null,
          failed: false
        });
      } catch {
        next.push(UNREADABLE_MESSAGE);
      }
    }
    setProcessing(false);
    setProblems([...new Set(next)]);
    // Cắt lại theo số ô còn trống tại thời điểm thêm: lúc nén ảnh, người dùng không thao tác được gì khác.
    setItems((current) => [...current, ...added].slice(0, MAX_VEHICLE_IMAGES));
  }

  function remove(item: ImageItem) {
    if (item.kind === "new") {
      URL.revokeObjectURL(item.previewUrl);
    }
    setItems((current) => current.filter((candidate) => candidate.id !== item.id));
    setProblems([]);
  }

  function move(from: number, to: number) {
    if (to < 0 || to >= items.length) {
      return;
    }
    const moved = items[from]!;
    setItems((current) => moveItem(current, from, to));
    setAnnouncement(`Đã chuyển ảnh tới vị trí ${to + 1}${to === 0 ? ", thành ảnh đại diện" : ""}.`);
    // Giữ tiêu điểm trên nút đổi chỗ của đúng ảnh vừa chuyển để bấm phím mũi tên tiếp được.
    requestAnimationFrame(() =>
      listRef.current?.querySelector<HTMLButtonElement>(`[data-grip="${moved.id}"]`)?.focus()
    );
  }

  function onGripKey(event: KeyboardEvent, index: number) {
    const step = { ArrowLeft: -1, ArrowUp: -1, ArrowRight: 1, ArrowDown: 1 }[event.key];
    if (step !== undefined) {
      event.preventDefault();
      move(index, index + step);
    }
  }

  function onTileDrop(event: DragEvent, index: number) {
    if (!event.dataTransfer.types.includes(DRAG_TYPE)) {
      return;
    }
    event.preventDefault();
    const from = items.findIndex((item) => item.id === event.dataTransfer.getData(DRAG_TYPE));
    setDragging(null);
    if (from >= 0) {
      move(from, index);
    }
  }

  function onFilesDrop(event: DragEvent) {
    if (event.dataTransfer.types.includes(DRAG_TYPE)) {
      onTileDrop(event, items.length - 1);
      return;
    }
    event.preventDefault();
    if (!locked && !processing) {
      void addFiles([...event.dataTransfer.files]);
    }
  }

  return (
    <section aria-labelledby="vehicle-images-heading" className={CARD}>
      <div className="flex items-start gap-3">
        <h2 id="vehicle-images-heading" className="flex-1 text-base leading-6 font-semibold text-vxn-ink">
          Ảnh phương tiện
        </h2>
        <p className="text-xs leading-[18px] font-medium text-muted-foreground">{countLabel(items)}</p>
      </div>
      <p className="text-sm leading-5 text-muted-foreground">Kéo thả để sắp xếp. Ảnh đầu tiên là ảnh đại diện.</p>

      <ol ref={listRef} aria-label="Ảnh của phương tiện" className="grid grid-cols-2 gap-4 sm:grid-cols-3">
        {items.map((item, index) => {
          const number = String(index + 1).padStart(2, "0");
          const failed = item.kind === "new" && item.failed;
          return (
            <li
              key={item.id}
              aria-label={`Ảnh ${index + 1}${index === 0 ? " · ảnh đại diện" : ""}`}
              draggable={!locked && !failed}
              onDragStart={(event) => {
                event.dataTransfer.setData(DRAG_TYPE, item.id);
                event.dataTransfer.effectAllowed = "move";
                setDragging(item.id);
              }}
              onDragEnd={() => setDragging(null)}
              onDragOver={(event) => {
                if (event.dataTransfer.types.includes(DRAG_TYPE)) {
                  event.preventDefault();
                }
              }}
              onDrop={(event) => onTileDrop(event, index)}
              className={cn("flex min-w-0 flex-col gap-2", dragging === item.id && "opacity-50")}
            >
              {failed ? (
                <div className="relative flex h-[120px] flex-col items-center justify-center gap-2 rounded-lg bg-error-50 px-3 text-center">
                  <CircleAlert className="size-5 text-error-600" aria-hidden />
                  <p className="text-xs leading-[18px] font-medium text-error-600">Tải ảnh thất bại</p>
                  {onRetry && (
                    <Button
                      type="button"
                      variant="outline"
                      className="h-8 rounded-lg bg-card px-3 text-sm font-semibold"
                      disabled={locked}
                      onClick={onRetry}
                    >
                      {retrying ? <LoaderCircle className="size-4 animate-spin" /> : <RefreshCw className="size-4" />}
                      Thử lại
                    </Button>
                  )}
                  <button
                    type="button"
                    aria-label={`Bỏ ảnh ${index + 1} chưa lưu được`}
                    disabled={locked}
                    onClick={() => remove(item)}
                    className="absolute top-1.5 right-1.5 rounded p-1 text-error-600 hover:bg-error-100 disabled:opacity-50"
                  >
                    <X className="size-4" />
                  </button>
                </div>
              ) : (
                <div className="relative h-[120px] overflow-hidden rounded-lg bg-muted">
                  {/* Ảnh ở kho công khai / blob trong trình duyệt: <img> thường, không qua bộ tối ưu ảnh của Next. */}
                  <img
                    src={item.kind === "saved" ? item.url : item.previewUrl}
                    alt={item.caption.trim() || `Ảnh phương tiện ${index + 1}`}
                    draggable={false}
                    className="size-full object-cover"
                  />
                  <div className="absolute inset-x-2 bottom-2 flex h-8 items-center gap-1 rounded-md bg-card/95 pr-1 shadow-sm">
                    <button
                      type="button"
                      data-grip={item.id}
                      aria-label={`Đổi vị trí ảnh ${index + 1} (phím mũi tên)`}
                      aria-describedby="vehicle-images-heading"
                      disabled={locked}
                      onKeyDown={(event) => onGripKey(event, index)}
                      className="flex h-8 w-7 cursor-grab items-center justify-center rounded-md text-vxn-fg-3 outline-none focus-visible:ring-[3px] focus-visible:ring-ring/50"
                    >
                      <GripVertical className="size-4" />
                    </button>
                    <span className="min-w-0 flex-1 truncate text-sm leading-5 text-vxn-fg-1">
                      {index === 0 ? "Đại diện" : "Đổi vị trí"}
                    </span>
                    <button
                      type="button"
                      aria-label={`Xóa ảnh ${index + 1}`}
                      disabled={locked}
                      onClick={() => remove(item)}
                      className="flex size-7 items-center justify-center rounded-md text-vxn-fg-3 hover:bg-muted disabled:opacity-50"
                    >
                      <X className="size-4" />
                    </button>
                  </div>
                </div>
              )}
              <div className="flex min-w-0 flex-wrap items-center gap-x-1 text-xs leading-[18px] text-muted-foreground">
                <span className="shrink-0">{number} ·</span>
                <input
                  aria-label={`Chú thích ảnh ${index + 1}`}
                  value={item.caption}
                  maxLength={CAPTION_MAX_LENGTH}
                  placeholder="Thêm chú thích"
                  disabled={locked}
                  onChange={(event) => {
                    const caption = event.target.value;
                    setItems((current) =>
                      current.map((candidate) => (candidate.id === item.id ? { ...candidate, caption } : candidate))
                    );
                  }}
                  // Co theo nội dung; hết chỗ thì "— chưa lưu" xuống dòng thay vì cắt cụt chú thích.
                  className="max-w-full min-w-0 rounded bg-transparent px-0.5 [field-sizing:content] text-xs leading-[18px] text-muted-foreground outline-none placeholder:text-vxn-fg-3 focus-visible:bg-muted focus-visible:text-vxn-fg-1"
                />
                {failed && <span className="shrink-0">— chưa lưu</span>}
              </div>
            </li>
          );
        })}
        {!full && (
          <li>
            <button
              type="button"
              disabled={locked || processing}
              onClick={() => inputRef.current?.click()}
              onDragOver={(event) => event.preventDefault()}
              onDrop={onFilesDrop}
              className="flex h-[120px] w-full flex-col items-center justify-center gap-2 rounded-lg border border-dashed bg-background outline-none focus-visible:ring-[3px] focus-visible:ring-ring/50 disabled:cursor-not-allowed"
            >
              {processing ? (
                <LoaderCircle className="size-6 animate-spin text-vxn-teal-700" aria-hidden />
              ) : (
                <ImagePlus className="size-6 text-vxn-teal-700" aria-hidden />
              )}
              <span className="text-sm leading-5 font-semibold text-vxn-teal-700">
                {processing ? "Đang xử lý ảnh…" : "Thêm ảnh"}
              </span>
              <span className={HELPER}>hoặc kéo thả vào đây</span>
            </button>
          </li>
        )}
      </ol>
      <input
        ref={inputRef}
        type="file"
        aria-label="Chọn ảnh phương tiện"
        accept={ACCEPTED_IMAGE_TYPES.join(",")}
        multiple
        tabIndex={-1}
        className="sr-only"
        onChange={(event) => {
          const files = [...(event.target.files ?? [])];
          // Cho phép chọn lại đúng tệp vừa chọn (sau khi xóa) — trình duyệt không bắn `change` nếu giá trị không đổi.
          event.target.value = "";
          void addFiles(files);
        }}
      />
      <p className="sr-only" aria-live="polite">
        {announcement}
      </p>

      <p className={HELPER}>JPEG, PNG hoặc WebP · Tối đa 5 MB / ảnh · Tối đa 8 ảnh</p>
      {problems.map((problem) => (
        <p key={problem} role="alert" className="flex items-center gap-3 rounded-lg bg-error-50 px-4 py-3 text-sm leading-5 text-error-600">
          <CircleAlert className="size-4 shrink-0" />
          {problem}
        </p>
      ))}
      {error && (
        <p role="alert" className="flex items-center gap-3 rounded-lg bg-error-50 px-4 py-3 text-sm leading-5 text-error-600">
          <CircleAlert className="size-4 shrink-0" />
          {error}
        </p>
      )}
      {notice ? (
        <p role="status" className="rounded-lg bg-warning-50 p-3 text-xs leading-[18px] text-warning-700">
          {notice}
        </p>
      ) : (
        <p className={`${HELPER} rounded-lg bg-muted p-3`}>Ảnh sẽ hiển thị công khai ngay sau khi lưu.</p>
      )}
    </section>
  );
}
