// Hằng class dùng chung (file thường, không "use client") để cả server component lẫn view client đều import được.
/** Kiểu chữ và control của modal xác thực theo kit Figma `Auth / *` (Email Input, Primary Button). */
export const AUTH_TITLE = "text-2xl/9 font-semibold tracking-[-0.24px] text-vxn-ink";
export const AUTH_SUBTITLE = "text-sm/5 text-vxn-fg-5";
export const AUTH_LABEL = "text-sm/[21px] font-medium text-[#1c1e22]";
export const AUTH_INPUT =
  "h-14 w-full rounded-2xl border bg-white px-4 text-base text-[#1c1e22] transition-colors placeholder:text-vxn-fg-5 focus:border-vxn-teal-500 focus:outline-none focus:ring-2 focus:ring-vxn-teal-500/20";
export const AUTH_PRIMARY_BUTTON =
  "h-14 w-full rounded-2xl bg-vxn-teal-500 text-base font-semibold text-white shadow-none hover:bg-vxn-teal-600 disabled:opacity-60";
export const AUTH_LINK = "font-semibold text-primary hover:underline";
