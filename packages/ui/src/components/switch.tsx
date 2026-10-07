"use client"

import * as React from "react"
import { cn } from "../lib/utils"
import { Switch as SwitchPrimitive } from "radix-ui"

/** Công tắc bật / tắt (Figma "VXN / Switch"); trạng thái khóa hiện mờ và không bấm được. */
function Switch({
  className,
  ...props
}: React.ComponentProps<typeof SwitchPrimitive.Root>) {
  return (
    <SwitchPrimitive.Root
      data-slot="switch"
      className={cn(
        "peer inline-flex h-5 w-9 shrink-0 items-center rounded-full bg-border p-0.5 transition-colors outline-none focus-visible:ring-[3px] focus-visible:ring-ring/50 disabled:cursor-not-allowed disabled:opacity-50 data-[state=checked]:bg-primary",
        className
      )}
      {...props}
    >
      <SwitchPrimitive.Thumb
        data-slot="switch-thumb"
        className="pointer-events-none block size-4 rounded-full bg-card transition-transform data-[state=checked]:translate-x-4"
      />
    </SwitchPrimitive.Root>
  )
}

export { Switch }
