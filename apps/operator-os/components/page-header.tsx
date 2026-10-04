import type { ReactNode } from "react";

/** Đầu trang của màn nghiệp vụ: tiêu đề, dòng mô tả và cụm nút bên phải (Figma "Page header"). */
export function PageHeader({
  title,
  description,
  actions
}: {
  title: string;
  description: string;
  actions?: ReactNode;
}) {
  return (
    <header className="flex min-h-[70px] flex-wrap items-center gap-x-6 gap-y-3">
      <div className="flex min-w-0 flex-1 flex-col gap-1.5">
        <h1 className="text-[30px] leading-[38px] font-semibold text-vxn-ink">{title}</h1>
        <p className="text-sm leading-5 text-muted-foreground">{description}</p>
      </div>
      {actions && <div className="flex shrink-0 items-center gap-3">{actions}</div>}
    </header>
  );
}
