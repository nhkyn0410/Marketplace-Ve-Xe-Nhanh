import { Label } from "@vexenhanh/ui/components/label";
import { cn } from "@vexenhanh/ui/lib/utils";
import { useId, type ReactNode } from "react";

/** Thuộc tính nối ô nhập với nhãn và dòng gợi ý / lỗi của nó. */
export type FieldControlProps = { id: string; "aria-invalid": boolean; "aria-describedby": string | undefined };

/** Nhãn + ô nhập + dòng gợi ý; có lỗi thì lỗi thay chỗ gợi ý, ngay dưới ô (06 UI §10). */
export function FormField({
  label,
  helper,
  error,
  className,
  children
}: {
  label: string;
  helper?: string;
  error?: string;
  className?: string;
  children: (control: FieldControlProps) => ReactNode;
}) {
  const id = useId();
  const noteId = `${id}-note`;
  const note = error ?? helper;
  return (
    <div className={cn("flex min-w-0 flex-col gap-1.5", className)}>
      <Label htmlFor={id}>{label}</Label>
      {children({ id, "aria-invalid": Boolean(error), "aria-describedby": note ? noteId : undefined })}
      {note && (
        <p
          id={noteId}
          role={error ? "alert" : undefined}
          className={cn("text-xs leading-[18px]", error ? "text-error-600" : "text-muted-foreground")}
        >
          {note}
        </p>
      )}
    </div>
  );
}
