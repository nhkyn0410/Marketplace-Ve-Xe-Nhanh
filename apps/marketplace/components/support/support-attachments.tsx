"use client";

import { Paperclip, X } from "lucide-react";
import { useState } from "react";
import { getSupportUploadUrl } from "../../lib/data/support";
import type { SupportAttachment } from "../../lib/data/support-mappers";

/** Bộ chọn tệp hỗ trợ, chỉ đính kèm các tệp đã tải thành công lên kho riêng tư. */
export function SupportAttachments({ bookingCode, guestBookingId, files, onChange, onBusyChange }: {
  readonly bookingCode: string;
  readonly guestBookingId?: string;
  readonly files: readonly SupportAttachment[];
  readonly onChange: (files: readonly SupportAttachment[]) => void;
  readonly onBusyChange?: (busy: boolean) => void;
}) {
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const full = busy || files.length >= 5;
  return <div className="space-y-2 text-xs">
    {/* Figma: dòng "kẹp giấy + Đính kèm tệp" thay cho ô chọn tệp mặc định của trình duyệt */}
    <label className={`inline-flex items-center gap-1.5 text-vxn-fg-5 transition-colors focus-within:text-vxn-teal-700 ${full ? "cursor-not-allowed opacity-60" : "cursor-pointer hover:text-vxn-teal-700"}`}>
      <Paperclip className="size-3.5 shrink-0" />
      <span>Đính kèm tệp (ảnh JPEG, PNG hoặc PDF · tối đa 10 MB/tệp, 5 tệp)</span>
      <input type="file" accept="image/jpeg,image/png,application/pdf" disabled={full}
        className="sr-only" onChange={async (event) => {
          const file = event.target.files?.[0];
          event.target.value = "";
          if (!file) return;
          setBusy(true); onBusyChange?.(true); setError(null);
          try {
            const result = await getSupportUploadUrl(bookingCode, file.type, file.size, guestBookingId);
            if (result.status !== "ok") { setError(result.status === "error" ? result.message ?? "Không thể tải tệp." : "Tải tệp chưa khả dụng."); return; }
            const response = await fetch(result.data.uploadUrl, { method: "PUT", headers: { "Content-Type": file.type }, body: file });
            if (!response.ok) throw new Error("upload");
            onChange([...files, { objectKey: result.data.objectKey, fileName: file.name }]);
          } catch { setError("Không thể tải tệp lên. Vui lòng thử lại."); }
          finally { setBusy(false); onBusyChange?.(false); }
        }} />
    </label>
    {busy && <p role="status">Đang tải tệp… Vui lòng chờ trước khi gửi yêu cầu.</p>}
    {error && <p role="alert" className="text-rose-700">{error}</p>}
    {files.length > 0 && <div className="flex flex-wrap gap-2">
      {files.map((file) => <span key={file.objectKey} className="inline-flex max-w-full items-center gap-1.5 rounded-lg border border-vxn-border bg-white py-1 pr-1 pl-2.5 text-vxn-ink">
        <Paperclip className="size-3 shrink-0 text-vxn-fg-5" />
        <span className="truncate">{file.fileName}</span>
        <button type="button" aria-label={`Xóa tệp ${file.fileName}`} className="rounded p-0.5 text-vxn-fg-5 hover:bg-muted hover:text-vxn-ink" onClick={() => onChange(files.filter((item) => item.objectKey !== file.objectKey))}>
          <X className="size-3.5" />
        </button>
      </span>)}
    </div>}
  </div>;
}
