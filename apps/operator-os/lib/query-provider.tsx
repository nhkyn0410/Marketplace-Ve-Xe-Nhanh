"use client";

import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { useState, type ReactNode } from "react";

import { ApiError } from "./auth/api-client";

/**
 * Cấp QueryClient cho các màn nghiệp vụ (HLD §6.3). Đặt BÊN TRONG `AuthGate`: đăng xuất thì cây này bị gỡ,
 * lần đăng nhập sau dựng client mới — dữ liệu của nhà xe trước không còn trong cache.
 */
export function QueryProvider({ children }: { children: ReactNode }) {
  const [client] = useState(
    () =>
      new QueryClient({
        defaultOptions: {
          queries: {
            staleTime: 30_000,
            refetchOnWindowFocus: false,
            // Lỗi 4xx (không có quyền, không tìm thấy, dữ liệu sai) thử lại cũng vậy; chỉ thử lại một lần
            // cho lỗi mạng / máy chủ.
            retry: (failureCount, error) =>
              failureCount < 1 && !(error instanceof ApiError && error.status < 500)
          }
        }
      })
  );
  return <QueryClientProvider client={client}>{children}</QueryClientProvider>;
}
