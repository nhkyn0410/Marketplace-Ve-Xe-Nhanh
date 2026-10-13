"use client"

import * as React from "react"
import { cn } from "../lib/utils"
import { XIcon } from "lucide-react"
import { Dialog as DialogPrimitive } from "radix-ui"

/** Hộp thoại chứa form hoặc nội dung cần tập trung (Figma "Dialog / …"); khác AlertDialog ở chỗ đóng được bằng nút ✕, Esc và bấm ra ngoài. */
function Dialog({ ...props }: React.ComponentProps<typeof DialogPrimitive.Root>) {
  return <DialogPrimitive.Root data-slot="dialog" {...props} />
}

/** Khung hộp thoại kèm nền mờ và nút ✕; nội dung dài thì cuộn trong hộp thoại. */
function DialogContent({
  className,
  children,
  closeLabel = "Đóng",
  ...props
}: React.ComponentProps<typeof DialogPrimitive.Content> & {
  /** Tên nút ✕ cho trình đọc màn hình. */
  closeLabel?: string
}) {
  return (
    <DialogPrimitive.Portal>
      <DialogPrimitive.Overlay
        data-slot="dialog-overlay"
        className="fixed inset-0 z-50 bg-black/50 data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=open]:animate-in data-[state=open]:fade-in-0"
      />
      <DialogPrimitive.Content
        data-slot="dialog-content"
        className={cn(
          "fixed top-[50%] left-[50%] z-50 flex max-h-[calc(100dvh-2rem)] w-full max-w-[calc(100%-2rem)] translate-x-[-50%] translate-y-[-50%] flex-col gap-5 overflow-y-auto rounded-xl border bg-card p-6 shadow-xl duration-200 data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=closed]:zoom-out-95 data-[state=open]:animate-in data-[state=open]:fade-in-0 data-[state=open]:zoom-in-95 sm:max-w-lg",
          className
        )}
        {...props}
      >
        {children}
        <DialogPrimitive.Close
          data-slot="dialog-close"
          aria-label={closeLabel}
          className="absolute top-5 right-5 flex size-8 items-center justify-center rounded-lg text-muted-foreground outline-none hover:bg-muted focus-visible:ring-[3px] focus-visible:ring-ring/50 disabled:pointer-events-none"
        >
          <XIcon className="size-[18px]" />
        </DialogPrimitive.Close>
      </DialogPrimitive.Content>
    </DialogPrimitive.Portal>
  )
}

/** Khối tiêu đề + mô tả; chừa chỗ bên phải cho nút ✕. */
function DialogHeader({ className, ...props }: React.ComponentProps<"div">) {
  return (
    <div
      data-slot="dialog-header"
      className={cn("flex flex-col gap-1 pr-10", className)}
      {...props}
    />
  )
}

/** Hàng nút cuối hộp thoại, căn phải trên màn rộng. */
function DialogFooter({ className, ...props }: React.ComponentProps<"div">) {
  return (
    <div
      data-slot="dialog-footer"
      className={cn("flex flex-col-reverse gap-3 sm:flex-row sm:justify-end", className)}
      {...props}
    />
  )
}

/** Tiêu đề hộp thoại (bắt buộc để trình đọc màn hình gọi tên hộp thoại). */
function DialogTitle({
  className,
  ...props
}: React.ComponentProps<typeof DialogPrimitive.Title>) {
  return (
    <DialogPrimitive.Title
      data-slot="dialog-title"
      className={cn("text-lg leading-6 font-semibold text-vxn-ink", className)}
      {...props}
    />
  )
}

/** Dòng mô tả dưới tiêu đề hộp thoại. */
function DialogDescription({
  className,
  ...props
}: React.ComponentProps<typeof DialogPrimitive.Description>) {
  return (
    <DialogPrimitive.Description
      data-slot="dialog-description"
      className={cn("text-sm leading-5 text-muted-foreground", className)}
      {...props}
    />
  )
}

export {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
}
