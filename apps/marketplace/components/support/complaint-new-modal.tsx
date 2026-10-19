"use client";

import React, { useState } from "react";
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogFooter
} from "@vexenhanh/ui/components/dialog";
import { Button } from "@vexenhanh/ui/components/button";
import { UploadCloud, FileText, X, Send, AlertCircle } from "lucide-react";
import { submitComplaint } from "../../lib/data/support";
import type { NewComplaintPayload } from "../../lib/data/types";

/**
 * Thuộc tính của ComplaintNewModal (SCR-PSG-31)
 */
export interface ComplaintNewModalProps {
  readonly isOpen: boolean;
  readonly onClose: () => void;
  readonly defaultDraft?: NewComplaintPayload;
  readonly bookingOptions?: readonly { readonly bookingCode: string; readonly label: string }[];
}

/**
 * Hộp thoại tạo mới khiếu nại chuẩn Figma node 1446:16390
 */
export const ComplaintNewModal: React.FC<ComplaintNewModalProps> = ({
  isOpen,
  onClose,
  defaultDraft,
  bookingOptions = [
    {
      bookingCode: "VXN-8F3K2Q",
      label: "VXN-8F3K2Q · TP. Hồ Chí Minh → Đà Lạt · 16/10/2026"
    },
    {
      bookingCode: "VXN-7Q2L5B",
      label: "VXN-7Q2L5B · TP. Hồ Chí Minh → Nha Trang · 05/10/2026"
    }
  ]
}) => {
  const [bookingCode, setBookingCode] = useState(defaultDraft?.bookingCode ?? "VXN-8F3K2Q");
  const [category, setCategory] = useState(defaultDraft?.category ?? "Thanh toán / hoàn tiền");
  const [suggestedSeverity, setSuggestedSeverity] = useState(defaultDraft?.suggestedSeverity ?? "Trung bình");
  const [title, setTitle] = useState(defaultDraft?.title ?? "Bị trừ tiền hai lần cho một đơn");
  const [content, setContent] = useState(
    defaultDraft?.content ??
      "Tôi thanh toán đơn VXN-8F3K2Q qua VNPay lúc 14:12 ngày 08/10 nhưng tài khoản bị trừ 460.000đ hai lần. Nhờ kiểm tra và hoàn lại khoản trừ thừa."
  );
  const [attachedFiles, setAttachedFiles] = useState<readonly string[]>(
    defaultDraft?.attachmentFileNames ?? ["sao-ke-vnpay.pdf · 320 KB"]
  );
  const [errorMessage, setErrorMessage] = useState<string | null>(null);
  const [isSubmitting, setIsSubmitting] = useState(false);

  const handleRemoveFile = (fileName: string) => {
    setAttachedFiles((prev) => prev.filter((f) => f !== fileName));
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!title.trim() || !content.trim()) {
      setErrorMessage("Vui lòng nhập đầy đủ tiêu đề và nội dung khiếu nại.");
      return;
    }

    setIsSubmitting(true);
    setErrorMessage(null);

    try {
      const res = await submitComplaint({
        bookingCode,
        category,
        suggestedSeverity,
        title,
        content,
        attachmentFileNames: attachedFiles
      });

      if (res.status === "unavailable") {
        setErrorMessage("Chức năng gửi khiếu nại đang chờ kết nối cổng API backend (POST /me/complaints).");
      } else if (res.status === "error") {
        setErrorMessage(res.message ?? "Không thể gửi khiếu nại. Vui lòng thử lại sau.");
      } else {
        alert("Gửi khiếu nại thành công!");
        onClose();
      }
    } catch {
      setErrorMessage("Đã xảy ra sự cố khi gửi khiếu nại. Vui lòng thử lại.");
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <Dialog open={isOpen} onOpenChange={(open) => !open && onClose()}>
      <DialogContent className="sm:max-w-xl max-h-[90vh] overflow-y-auto">
        <DialogHeader>
          <DialogTitle className="text-xl font-bold">Gửi khiếu nại</DialogTitle>
        </DialogHeader>

        <form onSubmit={handleSubmit} className="space-y-4 pt-1">
          {/* 1. Chọn Đơn / vé liên quan */}
          <div className="space-y-1.5">
            <label className="text-xs font-semibold text-foreground">
              Đơn / vé liên quan <span className="text-rose-600">*</span>
            </label>
            <select
              value={bookingCode}
              onChange={(e) => setBookingCode(e.target.value)}
              className="w-full h-10 px-3 rounded-xl border border-border bg-background text-xs font-medium focus:outline-none focus:border-teal-700"
            >
              {bookingOptions.map((opt) => (
                <option key={opt.bookingCode} value={opt.bookingCode}>
                  {opt.label}
                </option>
              ))}
            </select>
          </div>

          {/* 2. Hai cột: Danh mục và Mức độ */}
          <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
            <div className="space-y-1.5">
              <label className="text-xs font-semibold text-foreground">
                Danh mục <span className="text-rose-600">*</span>
              </label>
              <select
                value={category}
                onChange={(e) => setCategory(e.target.value)}
                className="w-full h-10 px-3 rounded-xl border border-border bg-background text-xs font-medium focus:outline-none focus:border-teal-700"
              >
                <option value="Thanh toán / hoàn tiền">Thanh toán / hoàn tiền</option>
                <option value="Chất lượng dịch vụ">Chất lượng dịch vụ</option>
                <option value="Hủy chuyến / đổi chuyến">Hủy chuyến / đổi chuyến</option>
                <option value="Tài xế / nhân viên">Tài xế / nhân viên</option>
                <option value="Khác">Khác</option>
              </select>
            </div>

            <div className="space-y-1.5">
              <label className="text-xs font-semibold text-foreground">
                Mức độ (gợi ý)
              </label>
              <select
                value={suggestedSeverity}
                onChange={(e) => setSuggestedSeverity(e.target.value)}
                className="w-full h-10 px-3 rounded-xl border border-border bg-background text-xs font-medium focus:outline-none focus:border-teal-700"
              >
                <option value="Thấp">Thấp</option>
                <option value="Trung bình">Trung bình</option>
                <option value="Cao">Cao</option>
                <option value="Khẩn cấp">Khẩn cấp</option>
              </select>
            </div>
          </div>
          <p className="text-[11px] text-muted-foreground">
            Mức độ do bạn chọn chỉ là gợi ý; Vé Xe Nhanh sẽ phân loại khi tiếp nhận.
          </p>

          {/* 3. Tiêu đề */}
          <div className="space-y-1.5">
            <label className="text-xs font-semibold text-foreground">
              Tiêu đề <span className="text-rose-600">*</span>
            </label>
            <input
              type="text"
              maxLength={200}
              value={title}
              onChange={(e) => {
                setTitle(e.target.value);
                if (errorMessage) setErrorMessage(null);
              }}
              placeholder="Tóm tắt ngắn gọn vấn đề bạn gặp phải..."
              className="w-full h-10 px-3 rounded-xl border border-border bg-background text-xs font-medium focus:outline-none focus:border-teal-700"
            />
            <div className="text-right text-[11px] text-muted-foreground font-mono">
              {title.length} / 200 ký tự
            </div>
          </div>

          {/* 4. Mô tả chi tiết */}
          <div className="space-y-1.5">
            <label className="text-xs font-semibold text-foreground">
              Mô tả chi tiết <span className="text-rose-600">*</span>
            </label>
            <textarea
              rows={4}
              maxLength={2000}
              value={content}
              onChange={(e) => {
                setContent(e.target.value);
                if (errorMessage) setErrorMessage(null);
              }}
              placeholder="Mô tả cụ thể thời gian, địa điểm, sự việc để hỗ trợ xử lý nhanh chóng..."
              className="w-full p-3 rounded-xl border border-border bg-background text-xs font-medium focus:outline-none focus:border-teal-700 resize-none"
            />
            <div className="text-right text-[11px] text-muted-foreground font-mono">
              {content.length} / 2.000 ký tự
            </div>
          </div>

          {/* 5. Tệp đính kèm (Dropzone) */}
          <div className="space-y-2">
            <label className="text-xs font-semibold text-foreground">
              Tệp đính kèm
            </label>
            <div className="p-4 rounded-2xl border border-dashed border-border/80 bg-slate-50/50 dark:bg-muted/10 flex items-center justify-between gap-3">
              <div className="flex items-center gap-3">
                <div className="w-9 h-9 rounded-xl bg-teal-50 dark:bg-teal-950/40 text-teal-700 flex items-center justify-center shrink-0">
                  <UploadCloud className="w-5 h-5" />
                </div>
                <div>
                  <p className="text-xs font-bold text-foreground">Kéo thả hoặc chọn tệp</p>
                  <p className="text-[11px] text-muted-foreground">Ảnh, PDF, Word · tối đa 5 MB mỗi tệp</p>
                </div>
              </div>

              <Button
                type="button"
                variant="outline"
                size="sm"
                onClick={() => alert("Tính năng chọn tệp máy chủ đang được tích hợp")}
                className="text-xs font-semibold h-8 rounded-xl border-border"
              >
                Chọn tệp
              </Button>
            </div>

            {/* Danh sách tệp đã đính kèm */}
            {attachedFiles.map((f, idx) => (
              <div
                key={idx}
                className="flex items-center justify-between p-2.5 rounded-xl border border-border bg-card text-xs font-medium text-foreground"
              >
                <div className="flex items-center gap-2">
                  <FileText className="w-4 h-4 text-teal-700 shrink-0" />
                  <span>{f}</span>
                </div>
                <button
                  type="button"
                  onClick={() => handleRemoveFile(f)}
                  className="text-muted-foreground hover:text-foreground p-1"
                >
                  <X className="w-3.5 h-3.5" />
                </button>
              </div>
            ))}
          </div>

          {/* Thông báo lỗi tại chỗ */}
          {errorMessage && (
            <div className="p-3 rounded-xl bg-rose-50 border border-rose-200 text-rose-700 text-xs flex items-center gap-2">
              <AlertCircle className="w-4 h-4 shrink-0" />
              <span>{errorMessage}</span>
            </div>
          )}

          <DialogFooter className="flex-row justify-end gap-2 pt-2">
            <Button
              type="button"
              variant="outline"
              onClick={onClose}
              className="text-xs font-semibold rounded-xl"
            >
              Hủy
            </Button>
            <Button
              type="submit"
              disabled={isSubmitting}
              className="gap-1.5 text-xs font-bold bg-teal-900 hover:bg-teal-950 text-white rounded-xl shadow-xs"
            >
              <Send className="w-3.5 h-3.5" />
              <span>Gửi khiếu nại</span>
            </Button>
          </DialogFooter>
        </form>
      </DialogContent>
    </Dialog>
  );
};
