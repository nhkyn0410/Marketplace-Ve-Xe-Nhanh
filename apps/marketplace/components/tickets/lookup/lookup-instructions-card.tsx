import React from "react";
import Link from "next/link";

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
              Kiểm tra thông tin liên hệ
            </h4>
            <p className="text-muted-foreground leading-relaxed">
              Email phải trùng với email liên hệ khi đặt vé.
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
              Xem thông tin vé
            </h4>
            <p className="text-muted-foreground leading-relaxed">
              Xem thông tin chuyến và mã QR vé trong phiên tra cứu.
            </p>
          </div>
        </div>
      </div>

      {/* Đường phân cách & hotline hỗ trợ */}
      <div className="pt-4 border-t border-teal-200/60 dark:border-teal-900/40 flex items-center gap-2.5 text-xs text-muted-foreground">
        <span>
          Hủy vé và gửi hỗ trợ cần trình duyệt đã đặt vé hoặc{" "}
          <Link href="/login?next=%2Fmy-tickets" className="font-bold text-foreground hover:text-teal-700 underline">đăng nhập tài khoản đặt vé</Link>.
        </span>
      </div>
    </div>
  );
};
