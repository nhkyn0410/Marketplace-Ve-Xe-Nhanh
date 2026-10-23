import { TriangleAlert } from "lucide-react";

import { isDemoMode } from "../lib/demo-mode";

/**
 * Cảnh báo ở ô tải giấy tờ / minh chứng khi production là môi trường demo (OQ-21): chỉ tải giấy tờ mẫu. Không bật demo → không
 * hiện gì.
 */
export function DemoDataNotice() {
  if (!isDemoMode()) {
    return null;
  }
  return (
    <p role="note" className="flex gap-2 rounded-lg bg-warning-50 px-3 py-2 text-xs leading-[18px] text-warning-700">
      <TriangleAlert className="mt-px size-4 shrink-0" aria-hidden />
      Môi trường demo — chỉ tải giấy tờ mẫu, không tải giấy tờ thật (CCCD, giấy phép, sao kê ngân hàng…).
    </p>
  );
}
