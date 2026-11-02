"use client";

import React, { useState } from "react";
import { Badge } from "@vexenhanh/ui/components/badge";
import { Button } from "@vexenhanh/ui/components/button";
import {
  AlertTriangle,
  Send,
  FileText,
  Check,
  AlertCircle
} from "lucide-react";
import { cn } from "@vexenhanh/ui/lib/utils";
import { getSupportDownloadUrl, replyComplaint } from "../../lib/data/support";
import type { SupportAttachment, SupportDetailData } from "../../lib/data/support-mappers";
import { SupportAttachments } from "./support-attachments";

/**
 * Thuộc tính của ComplaintDetailPanel
 */
export interface ComplaintDetailPanelProps {
  readonly complaint: SupportDetailData;
  readonly guestBookingId?: string;
  readonly onUpdated?: (detail: SupportDetailData) => void;
}

/**
 * Khung chi tiết khiếu nại và hộp trao đổi chuẩn Figma node 1446:16033
 */
export const ComplaintDetailPanel: React.FC<ComplaintDetailPanelProps> = ({
  complaint,
  guestBookingId,
  onUpdated
}) => {
  const [replyText, setReplyText] = useState("");
  const [errorMessage, setErrorMessage] = useState<string | null>(null);
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [attachments, setAttachments] = useState<readonly SupportAttachment[]>([]);
  const [uploading, setUploading] = useState(false);

  const handleSendReply = async () => {
    if (!replyText.trim()) {
      setErrorMessage("Vui lòng nhập nội dung phản hồi trước khi gửi.");
      return;
    }

    setIsSubmitting(true);
    setErrorMessage(null);

    try {
      const res = await replyComplaint(complaint.id, replyText, attachments, guestBookingId);
      if (res.status === "unavailable") {
        setErrorMessage("Gửi phản hồi tạm thời chưa khả dụng. Vui lòng thử lại sau.");
      } else if (res.status === "error") {
        setErrorMessage(res.message ?? "Không thể gửi phản hồi. Vui lòng thử lại.");
      } else {
        setReplyText("");
        setAttachments([]);
        onUpdated?.(res.data);
      }
    } catch {
      setErrorMessage("Đã xảy ra lỗi khi gửi phản hồi. Vui lòng thử lại.");
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <div className="rounded-2xl border border-border/80 bg-card p-6 shadow-xs space-y-6">
      {/* 1. Header chi tiết khiếu nại */}
      <div className="flex flex-col sm:flex-row sm:items-start justify-between gap-3 pb-5 border-b border-border/60">
        <div>
          <div className="flex items-center gap-2.5">
            <h2 className="text-xl font-bold tracking-tight text-foreground">
              {complaint.title}
            </h2>
            <Badge tone={complaint.statusTone} className="text-xs font-semibold px-2 py-0.5">
              {complaint.statusLabel}
            </Badge>
          </div>
          <p className="text-xs text-muted-foreground mt-1 font-medium">
            {complaint.createdAtText}
          </p>
        </div>
      </div>

      {/* 2. Thanh tiến trình xử lý (Stepper) */}
      <div className="py-1">
        <div className="flex items-center justify-between gap-1 sm:gap-2 overflow-x-auto pb-1 text-xs font-medium">
          {complaint.steps.map((step, idx) => {
            const isCompleted = step.state === "completed";
            const isCurrent = step.state === "current";

            return (
              <div
                key={idx}
                className={cn(
                  "flex items-center gap-1.5 px-2.5 py-1 rounded-lg shrink-0",
                  isCompleted && "bg-emerald-50 text-emerald-700 dark:bg-emerald-950/30 dark:text-emerald-300 font-semibold",
                  isCurrent && "bg-amber-50 text-amber-800 dark:bg-amber-950/30 dark:text-amber-300 border border-amber-300 font-bold",
                  step.state === "upcoming" && "bg-muted/50 text-muted-foreground"
                )}
              >
                {isCompleted && <Check className="w-3.5 h-3.5" />}
                <span>{step.label}</span>
              </div>
            );
          })}
        </div>
      </div>

      {/* 3. Bảng thông tin đơn liên quan & danh mục */}
      <div className="rounded-xl bg-slate-50/70 dark:bg-muted/20 p-4 border border-border/60 space-y-2 text-xs">
        <div className="flex items-center justify-between">
          <span className="text-muted-foreground">Đơn liên quan</span>
          <span className="font-bold text-foreground">{complaint.routeText}</span>
        </div>
        <div className="flex items-center justify-between">
          <span className="text-muted-foreground">Danh mục</span>
          <span className="font-medium text-foreground">{complaint.category}</span>
        </div>
      </div>

      {/* 4. Cảnh báo yêu cầu bổ sung thông tin từ nhà xe (nếu có) */}
      {complaint.noticeWarningText && (
        <div className="rounded-xl border border-amber-300/80 bg-amber-50/70 dark:bg-amber-950/20 p-3.5 flex items-start gap-2.5 text-xs text-amber-900 dark:text-amber-200">
          <AlertTriangle className="w-4 h-4 text-amber-600 shrink-0 mt-0.5" />
          <p className="leading-relaxed font-medium">{complaint.noticeWarningText}</p>
        </div>
      )}

      {/* 5. Khối Lịch sử trao đổi (Trao đổi) */}
      <div className="space-y-4 pt-2">
        <h3 className="text-sm font-bold text-foreground">Trao đổi</h3>

        {/* Danh sách các tin nhắn trao đổi */}
        <div className="space-y-3">
          {complaint.messages.map((msg) => {
            const isPassenger = msg.senderRole === "passenger";
            return (
              <div
                key={msg.id}
                className={cn(
                  "p-4 rounded-2xl border text-xs leading-relaxed space-y-2",
                  isPassenger
                    ? "bg-slate-50 dark:bg-muted/30 border-border/80"
                    : "bg-white dark:bg-card border-border/80 shadow-2xs"
                )}
              >
                <div className="flex items-center justify-between text-[11px] text-muted-foreground">
                  <span className="font-bold text-foreground">{msg.senderName}</span>
                  <span>{msg.createdAtText}</span>
                </div>

                <p className="text-foreground/90 font-medium whitespace-pre-line">
                  {msg.content}
                </p>

                {/* Tệp đính kèm trong tin nhắn */}
                {msg.attachments && msg.attachments.length > 0 && (
                  <div className="flex flex-wrap gap-2 pt-1">
                    {msg.attachments.map((file, fIdx) => (
                      <button
                        type="button"
                        disabled={!file.attachmentId}
                        onClick={async () => {
                          if (!file.attachmentId) return;
                          const result = await getSupportDownloadUrl(complaint.id, file.attachmentId, guestBookingId);
                          if (result.status === "ok") window.open(result.data.url, "_blank", "noopener,noreferrer");
                          else setErrorMessage(result.status === "error" ? result.message ?? "Không thể xem tệp." : "Tệp chưa khả dụng.");
                        }}
                        key={fIdx}
                        className="inline-flex items-center gap-1.5 px-2.5 py-1 bg-background rounded-lg border border-border text-[11px] font-medium text-muted-foreground"
                      >
                        <FileText className="w-3.5 h-3.5 text-teal-700" />
                        <span>{file.fileName} · {file.fileSizeText}</span>
                      </button>
                    ))}
                  </div>
                )}
              </div>
            );
          })}
        </div>

        {/* Form nhập phản hồi mới */}
        <div className="rounded-2xl border border-border/80 bg-background p-3.5 space-y-3 mt-4 focus-within:border-teal-700 transition-colors">
          <textarea
            rows={3}
            disabled={complaint.closed}
            maxLength={2000}
            value={replyText}
            onChange={(e) => {
              setReplyText(e.target.value);
              if (errorMessage) setErrorMessage(null);
            }}
            placeholder="Nhập phản hồi của bạn..."
            className="w-full text-xs text-foreground bg-transparent resize-none focus:outline-none placeholder:text-muted-foreground"
          />

          {errorMessage && (
            <div className="flex items-center gap-1.5 text-xs text-rose-600 font-medium">
              <AlertCircle className="w-3.5 h-3.5 shrink-0" />
              <span>{errorMessage}</span>
            </div>
          )}

          <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-2 pt-2 border-t border-border/50">
            {!complaint.closed && <SupportAttachments bookingCode={complaint.bookingCode} guestBookingId={guestBookingId} files={attachments} onChange={setAttachments} onBusyChange={setUploading} />}

            <Button
              type="button"
              size="sm"
              disabled={isSubmitting || uploading || complaint.closed}
              onClick={handleSendReply}
              className="gap-1.5 text-xs font-bold bg-teal-900 hover:bg-teal-950 text-white rounded-xl shadow-xs self-end sm:self-auto"
            >
              <Send className="w-3.5 h-3.5" />
              <span>Gửi phản hồi</span>
            </Button>
          </div>
        </div>
      </div>
    </div>
  );
};
