import { Button } from "@vexenhanh/ui/components/button";
import { LoaderCircle } from "lucide-react";
import type { ReactNode } from "react";

/** Kiểu nút 40px dùng chung ở các màn nghiệp vụ (Figma "VXN / Button"). */
export const BUTTON = "h-10 rounded-lg px-4 text-sm font-semibold";

/** Khối giữa bảng cho trạng thái rỗng / lỗi: biểu tượng, tiêu đề, mô tả và một nút (Figma "Panel feedback"). */
export function ListStatePanel({
  icon,
  title,
  description,
  action
}: {
  icon: ReactNode;
  title: string;
  description: string;
  action: ReactNode;
}) {
  return (
    <div className="flex min-h-[504px] flex-col items-center justify-center gap-2 px-4 text-center">
      {icon}
      <p className="mt-1 text-base leading-6 font-semibold text-vxn-ink">{title}</p>
      <p className="max-w-md text-sm leading-5 text-muted-foreground">{description}</p>
      <div className="mt-4">{action}</div>
    </div>
  );
}

/** Dòng chữ nhỏ ở chân bảng. */
export function ListFooterNote({ children }: { children: ReactNode }) {
  return <p className="flex-1 text-xs leading-[18px] text-muted-foreground">{children}</p>;
}

/**
 * Chân bảng phân trang theo `nextCursor`: còn trang thì hiện "Tải thêm"; lỗi tải thêm vẫn giữ các dòng đã
 * tải và cho thử lại; hết dữ liệu thì chỉ còn dòng báo đã hiện tất cả.
 */
export function ListLoadMoreFooter({
  hasMore,
  loading,
  failed,
  loadedText,
  endText,
  errorText,
  onLoadMore
}: {
  hasMore: boolean;
  loading: boolean;
  failed: boolean;
  loadedText: string;
  endText: string;
  errorText: string;
  onLoadMore: () => void;
}) {
  if (failed) {
    return (
      <div role="alert" className="flex flex-1 flex-wrap items-center gap-3 rounded-lg bg-error-50 px-5 py-3">
        <p className="flex-1 text-sm leading-5 text-error-600">{errorText}</p>
        <Button variant="outline" className={`${BUTTON} w-36 bg-card`} onClick={onLoadMore}>
          Thử lại
        </Button>
      </div>
    );
  }
  if (!hasMore) {
    return <ListFooterNote>{endText}</ListFooterNote>;
  }
  return (
    <>
      <ListFooterNote>{loadedText}</ListFooterNote>
      <Button variant="outline" className={`${BUTTON} w-36 bg-card`} disabled={loading} onClick={onLoadMore}>
        {loading && <LoaderCircle className="size-[18px] animate-spin" />}
        {loading ? "Đang tải…" : "Tải thêm"}
      </Button>
    </>
  );
}
