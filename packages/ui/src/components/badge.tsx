import * as React from "react"
import { cva, type VariantProps } from "class-variance-authority"
import { cn } from "../lib/utils"

// Nhãn trạng thái (Figma "VXN / Badge"): luôn kèm chữ, màu chỉ là tín hiệu phụ.
const badgeVariants = cva(
  "inline-flex h-[26px] w-fit shrink-0 items-center justify-center rounded-lg px-2 text-xs leading-[18px] font-medium whitespace-nowrap",
  {
    variants: {
      tone: {
        neutral: "bg-muted text-muted-foreground",
        success: "bg-success-50 text-success-600",
        warning: "bg-warning-50 text-warning-700",
        danger: "bg-error-50 text-error-700",
      },
    },
    defaultVariants: {
      tone: "neutral",
    },
  }
)

function Badge({
  className,
  tone,
  ...props
}: React.ComponentProps<"span"> & VariantProps<typeof badgeVariants>) {
  return (
    <span
      data-slot="badge"
      className={cn(badgeVariants({ tone }), className)}
      {...props}
    />
  )
}

export { Badge, badgeVariants }
