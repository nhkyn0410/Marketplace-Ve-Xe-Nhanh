"use client";

import { Construction } from "lucide-react";
import { notFound, usePathname } from "next/navigation";

import { PageHeader } from "../../components/page-header";
import { navItemOf } from "../../lib/nav";

/**
 * Mục có trên thanh bên (Figma) nhưng chưa làm: giữ chỗ để thấy đủ cấu trúc cổng Admin. Đường dẫn ngoài thanh bên → 404.
 */
export default function UpcomingSectionPage() {
  const item = navItemOf(usePathname());
  if (!item) {
    notFound();
  }
  return (
    <div className="flex flex-col gap-6">
      <PageHeader title={item.label} description="Mục này đang được xây dựng." />
      <div className="flex flex-col items-center gap-3 rounded-xl border bg-card px-4 py-16 text-center">
        <Construction className="size-6 text-muted-foreground" aria-hidden />
        <p className="text-base leading-6 font-semibold text-vxn-ink">Chưa có trong phiên bản này</p>
        <p className="max-w-md text-sm leading-5 text-muted-foreground">
          Mục “{item.label}” sẽ được bổ sung theo kế hoạch phát triển cổng quản trị.
        </p>
      </div>
    </div>
  );
}
