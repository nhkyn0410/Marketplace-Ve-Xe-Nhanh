"use client";

import { AttachmentChips as SharedChips } from "@vexenhanh/ui/components/attachments";
import { Button } from "@vexenhanh/ui/components/button";
import { BUTTON } from "@vexenhanh/ui/components/list-parts";
import { Skeleton } from "@vexenhanh/ui/components/skeleton";
import { ArrowLeft, CircleAlert, RefreshCw } from "lucide-react";
import Link from "next/link";
import type { ReactNode } from "react";

import { attachmentUrl, type Attachment } from "../../lib/support/support-api";


export function Shell({ back, backLabel, children }: { back: string; backLabel: string; children: ReactNode }) {
  return (
    <div className="flex flex-col gap-6">
      <Link href={back} className="flex w-fit items-center gap-1.5 text-sm leading-5 font-medium text-primary hover:underline">
        <ArrowLeft className="size-[18px]" />
        {backLabel}
      </Link>
      {children}
    </div>
  );
}

export function Card({ title, description, children }: { title: string; description?: string; children: ReactNode }) {
  return (
    <section aria-label={title} className="flex min-w-0 flex-col gap-4 rounded-xl border bg-card p-6">
      <div className="flex flex-col gap-1">
        <h2 className="text-lg leading-7 font-semibold text-vxn-ink">{title}</h2>
        {description && <p className="text-sm leading-5 text-muted-foreground">{description}</p>}
      </div>
      {children}
    </section>
  );
}

export function Row({ label, value }: { label: string; value: ReactNode }) {
  return (
    <div className="flex items-baseline justify-between gap-4">
      <dt className="text-sm leading-5 text-muted-foreground">{label}</dt>
      <dd className="text-right text-sm leading-5 font-medium break-words text-vxn-fg-1 tabular-nums">{value}</dd>
    </div>
  );
}

/** Trạng thái tải / lỗi / không có của trang chi tiết. */
export function LoadState({ missing, failed, onRetry, label }: { missing: boolean; failed: boolean; onRetry: () => void; label: string }) {
  if (missing || failed) {
    return (
      <div className="flex min-h-[420px] flex-col items-center justify-center gap-3 rounded-xl border bg-card px-4 text-center">
        <CircleAlert className="size-6 text-warning-700" />
        <p className="text-base leading-6 font-semibold text-vxn-ink">{missing ? `Không tìm thấy ${label}` : `Không tải được ${label}`}</p>
        <p className="max-w-md text-sm leading-5 text-muted-foreground">{missing ? "Hồ sơ không tồn tại hoặc đã bị xóa." : "Không kết nối được máy chủ. Vui lòng kiểm tra kết nối và thử lại."}</p>
        {!missing && (
          <Button variant="outline" className={`${BUTTON} mt-2 bg-card`} onClick={onRetry}>
            <RefreshCw className="size-[18px]" />
            Thử lại
          </Button>
        )}
      </div>
    );
  }
  return (
    <div role="status" aria-label={`Đang tải ${label}`} className="grid gap-6 xl:grid-cols-[minmax(0,1fr)_340px]">
      <Skeleton className="h-[520px] rounded-xl" />
      <Skeleton className="h-[520px] rounded-xl" />
    </div>
  );
}

/** Tệp đính kèm của Admin: mở bằng URL có hạn của `/admin/support-attachments/*`. */
export function AttachmentChips({ files }: { files: Attachment[] }) {
  return <SharedChips files={files} resolveUrl={attachmentUrl} />;
}
