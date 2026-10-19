import React from "react";
import { Headphones } from "lucide-react";

/**
 * Khối hướng dẫn "Tra cứu vé trong 3 bước" chuẩn Figma node 1446:14982 & 1446:15277
 */
export const LookupInstructionsCard: React.FC = () => {
  return (
    <div className="rounded-2xl border border-teal-100 dark:border-teal-900/40 bg-teal-50/40 dark:bg-teal-950/20 p-6 sm:p-7 space-y-6">
      <h3 className="text-lg font-bold text-foreground">
        Tra cứu vé trong 3 bước
      </h3>

      <div className="space-y-5 text-xs">
        {/* Bước 1 */}
        <div className="flex items-start gap-3.5">
          <div className="flex h-6 w-6 shrink-0 items-center justify-center rounded-full bg-teal-600/15 text-teal-800 dark:text-teal-300 font-bold text-xs mt-0.5">
            1
          </div>
          <div className="space-y-0.5">
            <h4 className="font-bold text-foreground text-sm">
              Nhập mã đặt vé và email
            </h4>
            <p className="text-muted-foreground leading-relaxed">
              Mã đặt vé có trong email xác nhận, dạng VXN-XXXXXX.
            </p>
          </div>
        </div>

        {/* Bước 2 */}
        <div className="flex items-start gap-3.5">
          <div className="flex h-6 w-6 shrink-0 items-center justify-center rounded-full bg-teal-600/15 text-teal-800 dark:text-teal-300 font-bold text-xs mt-0.5">
            2
          </div>
          <div className="space-y-0.5">
            <h4 className="font-bold text-foreground text-sm">
              Nhập mã xác minh (OTP)
            </h4>
            <p className="text-muted-foreground leading-relaxed">
              Mã 6 số gửi tới email liên hệ của đơn, hiệu lực 5 phút.
            </p>
          </div>
        </div>

        {/* Bước 3 */}
        <div className="flex items-start gap-3.5">
          <div className="flex h-6 w-6 shrink-0 items-center justify-center rounded-full bg-teal-600/15 text-teal-800 dark:text-teal-300 font-bold text-xs mt-0.5">
            3
          </div>
          <div className="space-y-0.5">
            <h4 className="font-bold text-foreground text-sm">
              Xem vé và thao tác
            </h4>
            <p className="text-muted-foreground leading-relaxed">
              Xem mã QR, hủy vé / yêu cầu hoàn tiền hoặc gửi khiếu nại cho đơn đã xác minh.
            </p>
          </div>
        </div>
      </div>

      {/* Đường phân cách & hotline hỗ trợ */}
      <div className="pt-4 border-t border-teal-200/60 dark:border-teal-900/40 flex items-center gap-2.5 text-xs text-muted-foreground">
        <Headphones className="h-4 w-4 text-teal-700 dark:text-teal-400 shrink-0" />
        <span>
          Không tìm thấy email xác nhận? Gọi CSKH{" "}
          <a
            href="tel:19006067"
            className="font-bold text-foreground hover:text-teal-700 underline"
          >
            1900 6067
          </a>
          .
        </span>
      </div>
    </div>
  );
};
