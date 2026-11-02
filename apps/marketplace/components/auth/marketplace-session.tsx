"use client";

import { createContext, useContext, useEffect, useState, type ReactNode } from "react";
import { usePathname, useRouter } from "next/navigation";
import { ensureMarketplaceSession, logoutAccount } from "../../lib/data/auth";

type SessionUser = { fullName: string; email: string };
const SessionContext = createContext<{ user: SessionUser | null; error: string | null; logout: () => Promise<void> }>({ user: null, error: null, logout: async () => {} });

/** Chia sẻ danh tính không chứa token và bootstrap lại RSC sau khi cookie phiên được xoay. */
export function MarketplaceSessionProvider({ children }: { readonly children: ReactNode }) {
  const router = useRouter();
  const pathname = usePathname();
  const [user, setUser] = useState<SessionUser | null>(null);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    let active = true;
    const check = async () => {
      if (document.visibilityState === "hidden") return;
      try {
        const run = () => ensureMarketplaceSession();
        // Web Locks tuần tự hóa refresh giữa các tab cùng origin khi trình duyệt hỗ trợ.
        const result = navigator.locks ? await navigator.locks.request("vxn-marketplace-session", run) : await run();
        if (!active) return;
        if (result.status === "ok") {
          setUser(result.data.user);
          setError(null);
          if (result.data.rotated) router.refresh();
        } else {
          setError(result.status === "error" ? result.message ?? "Không thể tải phiên đăng nhập." : "Phiên đăng nhập chưa khả dụng.");
        }
      } catch {
        if (active) setError("Không thể kiểm tra phiên đăng nhập. Vui lòng thử lại.");
      }
    };
    void check();
    const timer = setInterval(() => { void check(); }, 60_000);
    document.addEventListener("visibilitychange", check);
    return () => { active = false; clearInterval(timer); document.removeEventListener("visibilitychange", check); };
  }, [pathname, router]);

  const logout = async () => {
    const result = await logoutAccount();
    if (result.status === "ok") {
      setUser(null);
      setError(null);
      router.push("/login");
      router.refresh();
    } else {
      setError(result.status === "error" ? result.message ?? "Không thể đăng xuất." : "Chưa thể đăng xuất.");
    }
  };
  return <SessionContext.Provider value={{ user, error, logout }}>{children}</SessionContext.Provider>;
}

/** Đọc danh tính hành khách và thao tác đăng xuất trong giao diện. */
export function useMarketplaceSession() {
  return useContext(SessionContext);
}
