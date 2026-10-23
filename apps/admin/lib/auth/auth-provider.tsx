"use client";

import { AuthProvider as PortalAuthProvider } from "@vexenhanh/ui/components/auth/auth-context";
import type { ReactNode } from "react";

import { ADMIN_PORTAL } from "./portal";

/** Phiên web của cổng Admin: chỉ tài khoản Platform (`PLATFORM_ADMIN`, `PLATFORM_SUPPORT`) mới được vào. */
export function AuthProvider({ children }: { children: ReactNode }) {
  return <PortalAuthProvider portal={ADMIN_PORTAL}>{children}</PortalAuthProvider>;
}
