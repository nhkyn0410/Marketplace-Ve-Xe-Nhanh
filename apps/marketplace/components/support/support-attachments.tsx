"use client";

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
  return <div className="space-y-2 text-xs">
    <label className="block font-medium">Đính kèm ảnh JPEG, PNG hoặc PDF · tối đa 10 MB/tệp, 5 tệp
      <input type="file" accept="image/jpeg,image/png,application/pdf" disabled={busy || files.length >= 5}
        className="mt-2 block w-full" onChange={async (event) => {
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
    {files.map((file) => <div key={file.objectKey} className="flex justify-between rounded-lg border p-2">
      <span>{file.fileName}</span><button type="button" onClick={() => onChange(files.filter((item) => item.objectKey !== file.objectKey))}>Xóa</button>
    </div>)}
  </div>;
}
