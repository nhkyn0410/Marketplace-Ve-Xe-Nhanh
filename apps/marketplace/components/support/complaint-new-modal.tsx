"use client";

import { useState } from "react";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogFooter } from "@vexenhanh/ui/components/dialog";
import { Button } from "@vexenhanh/ui/components/button";
import { submitComplaint } from "../../lib/data/support";
import type { NewComplaintPayload } from "../../lib/data/types";
import type { SupportAttachment } from "../../lib/data/support-mappers";
import { SupportAttachments } from "./support-attachments";

/** Dữ liệu mở hộp thoại gửi yêu cầu gắn với một đơn vé thực tế. */
export interface ComplaintNewModalProps {
  readonly isOpen: boolean;
  readonly onClose: () => void;
  readonly defaultDraft?: NewComplaintPayload;
  readonly bookingOptions?: readonly { readonly bookingCode: string; readonly label: string }[];
  readonly guestBookingId?: string;
  readonly onSubmitted?: (id: string) => void;
}

/** Hộp thoại gửi yêu cầu; không điền sẵn đơn, nội dung hoặc tệp mẫu trên luồng thật. */
export function ComplaintNewModal({ isOpen, onClose, defaultDraft, bookingOptions = [], guestBookingId, onSubmitted }: ComplaintNewModalProps) {
  const [bookingCode, setBookingCode] = useState(defaultDraft?.bookingCode ?? bookingOptions[0]?.bookingCode ?? "");
  const [category, setCategory] = useState(defaultDraft?.category ?? "Thanh toán / hoàn tiền");
  const [suggestedSeverity, setSuggestedSeverity] = useState(defaultDraft?.suggestedSeverity ?? "Trung bình");
  const [title, setTitle] = useState(defaultDraft?.title ?? "");
  const [content, setContent] = useState(defaultDraft?.content ?? "");
  const [attachments, setAttachments] = useState<readonly SupportAttachment[]>([]);
  const [error, setError] = useState<string | null>(null);
  const [busy, setBusy] = useState(false);
  const [uploading, setUploading] = useState(false);
  const fieldClass = "mt-1.5 w-full rounded-xl border border-vxn-border bg-white px-3 py-2.5 text-[13px] font-normal text-vxn-ink focus:border-vxn-teal-700 focus:outline-none";
  const labelClass = "block text-[13px] font-semibold text-vxn-ink";
  const counterClass = "mt-1 block text-xs font-normal text-vxn-fg-5";

  return <Dialog open={isOpen} onOpenChange={(open) => !open && onClose()}>
    <DialogContent className="sm:max-w-xl max-h-[calc(var(--vxn-vh)*0.9)] overflow-y-auto">
      <DialogHeader><DialogTitle className="text-lg/6 font-semibold text-vxn-ink">Gửi khiếu nại</DialogTitle></DialogHeader>
      <form className="space-y-4" onSubmit={async (event) => {
        event.preventDefault(); setBusy(true); setError(null);
        try {
          const result = await submitComplaint({ bookingCode, category, suggestedSeverity, title, content }, attachments, guestBookingId);
          if (result.status !== "ok") { setError(result.status === "error" ? result.message ?? "Không thể gửi yêu cầu." : "Gửi yêu cầu chưa khả dụng."); return; }
          setTitle(""); setContent(""); setAttachments([]);
          onSubmitted?.(result.data.complaintId); onClose();
        } catch { setError("Không thể gửi yêu cầu. Vui lòng thử lại."); }
        finally { setBusy(false); }
      }}>
        {!guestBookingId && <label className={labelClass}>Đơn / vé liên quan *
          <input required disabled={uploading} value={bookingCode} maxLength={100} onChange={(event) => { setBookingCode(event.target.value); setAttachments([]); }} placeholder="Nhập mã đơn trong tài khoản của bạn" className={fieldClass} />
        </label>}
        <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
          <label className={labelClass}>Danh mục
            <select value={category} onChange={(event) => setCategory(event.target.value)} className={fieldClass}>
              {["Thanh toán / hoàn tiền", "Lịch trình", "Chất lượng dịch vụ", "Đổi vé", "Khác"].map((value) => <option key={value}>{value}</option>)}
            </select>
          </label>
          <label className={labelClass}>Mức độ (gợi ý)
            <select value={suggestedSeverity} onChange={(event) => setSuggestedSeverity(event.target.value)} className={fieldClass}>
              {["Thấp", "Trung bình", "Cao", "Khẩn cấp"].map((value) => <option key={value}>{value}</option>)}
            </select>
          </label>
        </div>
        <label className={labelClass}>Tiêu đề *
          <input required minLength={3} maxLength={200} value={title} onChange={(event) => setTitle(event.target.value)} className={fieldClass} />
          <span className={counterClass}>{title.length} / 200 ký tự</span>
        </label>
        <label className={labelClass}>Mô tả chi tiết *
          <textarea required maxLength={2000} rows={5} value={content} onChange={(event) => setContent(event.target.value)} className={fieldClass} />
          <span className={counterClass}>{content.length} / 2.000 ký tự</span>
        </label>
        <SupportAttachments bookingCode={bookingCode} guestBookingId={guestBookingId} files={attachments} onChange={setAttachments} onBusyChange={setUploading} />
        {error && <p role="alert" className="rounded-xl bg-rose-50 p-3 text-xs text-rose-700">{error}</p>}
        <DialogFooter>
          <Button type="button" variant="outline" onClick={onClose}>Hủy</Button>
          <Button type="submit" disabled={busy || uploading} className="bg-vxn-teal-700 text-white hover:bg-vxn-teal-800">{busy ? "Đang gửi…" : "Gửi khiếu nại"}</Button>
        </DialogFooter>
      </form>
    </DialogContent>
  </Dialog>;
}
