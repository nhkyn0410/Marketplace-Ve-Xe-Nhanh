"use client";

import { FileText, LoaderCircle, Paperclip, X } from "lucide-react";
import { useRef, useState } from "react";

// Tệp minh chứng của khiếu nại / tranh chấp (TASK-TRUST-001) — dùng chung Admin + Operator OS. Mỗi app truyền hàm lấy URL xem
// (có hạn, server ghi nhật ký) và hàm tải tệp lên kho riêng tư của nó.

export type AttachmentFile = { attachmentId: string; fileName: string; sizeBytes: number };
export type UploadedFile = { objectKey: string; fileName: string; sizeBytes: number };

const ACCEPT = ["application/pdf", "image/jpeg", "image/png"];
const MAX_BYTES = 10 * 1024 * 1024;

/** `1,2 MB` / `320 KB`. */
export function formatFileSize(bytes: number): string {
  return bytes >= 1024 * 1024 ? `${(bytes / 1024 / 1024).toFixed(1).replace(".", ",")} MB` : `${Math.max(1, Math.round(bytes / 1024))} KB`;
}

/** Tệp đã gửi: bấm để mở bằng URL có hạn. */
export function AttachmentChips({ files, resolveUrl }: { files: AttachmentFile[]; resolveUrl: (attachmentId: string) => Promise<string> }) {
  const [failed, setFailed] = useState(false);
  if (files.length === 0) {
    return null;
  }
  const open = async (attachmentId: string) => {
    setFailed(false);
    // Mở tab trước khi chờ mạng để trình duyệt không chặn cửa sổ bật lên.
    const tab = window.open("", "_blank");
    try {
      const url = await resolveUrl(attachmentId);
      if (tab) tab.location.href = url;
    } catch {
      tab?.close();
      setFailed(true);
    }
  };
  return (
    <div className="flex flex-col gap-1.5">
      <ul className="flex flex-wrap gap-2">
        {files.map((file) => (
          <li key={file.attachmentId}>
            <button
              type="button"
              className="inline-flex items-center gap-1.5 rounded-md border bg-card px-2.5 py-1 text-xs leading-[18px] text-vxn-fg-1 hover:bg-muted"
              onClick={() => void open(file.attachmentId)}
            >
              <FileText className="size-3.5 text-muted-foreground" aria-hidden />
              {file.fileName} · {formatFileSize(file.sizeBytes)}
            </button>
          </li>
        ))}
      </ul>
      {failed && <p className="text-xs leading-[18px] text-error-600">Chưa mở được tệp. Vui lòng thử lại.</p>}
    </div>
  );
}

/**
 * Chọn + tải tệp minh chứng (PDF / JPEG / PNG ≤ 10 MB, tối đa `max` tệp). Mỗi tệp tải thẳng lên kho riêng tư ngay khi chọn; `value`
 * là các tệp đã tải để gửi kèm.
 */
export function AttachmentPicker({
  value,
  onChange,
  upload,
  disabled,
  label = "Đính kèm tệp",
  max = 5
}: {
  value: UploadedFile[];
  onChange: (next: UploadedFile[]) => void;
  upload: (file: File) => Promise<{ objectKey: string; fileName: string }>;
  disabled?: boolean;
  label?: string;
  max?: number;
}) {
  const input = useRef<HTMLInputElement>(null);
  const [pending, setPending] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const pick = async (files: File[]) => {
    setError(null);
    if (files.some((file) => !ACCEPT.includes(file.type) || file.size > MAX_BYTES)) {
      setError("Chỉ nhận PDF, JPEG, PNG, mỗi tệp tối đa 10 MB.");
      return;
    }
    if (value.length + files.length > max) {
      setError(`Tối đa ${max} tệp mỗi lần gửi.`);
      return;
    }
    setPending(true);
    try {
      const added: UploadedFile[] = [];
      for (const file of files) {
        added.push({ ...(await upload(file)), sizeBytes: file.size });
      }
      onChange([...value, ...added]);
    } catch {
      setError("Chưa tải được tệp lên. Vui lòng thử lại.");
    } finally {
      setPending(false);
    }
  };
  return (
    <div className="flex flex-col gap-2">
      <div className="flex flex-wrap items-center gap-2">
        <button
          type="button"
          className="inline-flex items-center gap-1.5 text-sm leading-5 text-muted-foreground hover:text-vxn-ink disabled:opacity-50"
          disabled={disabled || pending || value.length >= max}
          onClick={() => input.current?.click()}
        >
          {pending ? <LoaderCircle className="size-4 animate-spin" /> : <Paperclip className="size-4" aria-hidden />}
          {label}
        </button>
        <input
          ref={input}
          type="file"
          multiple
          accept={ACCEPT.join(",")}
          className="hidden"
          aria-label={label}
          onChange={(event) => {
            const files = Array.from(event.target.files ?? []);
            event.target.value = "";
            void pick(files);
          }}
        />
        {value.map((file) => (
          <span key={file.objectKey} className="inline-flex items-center gap-1 rounded-md border bg-card px-2 py-0.5 text-xs leading-[18px]">
            {file.fileName} · {formatFileSize(file.sizeBytes)}
            <button type="button" aria-label={`Bỏ ${file.fileName}`} disabled={disabled} onClick={() => onChange(value.filter((item) => item.objectKey !== file.objectKey))}>
              <X className="size-3.5 text-muted-foreground" />
            </button>
          </span>
        ))}
      </div>
      {error && (
        <p role="alert" className="text-xs leading-[18px] text-error-600">
          {error}
        </p>
      )}
    </div>
  );
}
