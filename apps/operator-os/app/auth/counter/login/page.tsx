"use client";

import { useRouter } from "next/navigation";
import { useEffect } from "react";

/** Sau khi xác thực ở cổng bán vé, chuyển đến bàn bán vé của tài khoản. */
export default function CounterLoginPage() {
  const router = useRouter();
  useEffect(() => { router.replace("/counter"); }, [router]);
  return <p role="status" className="p-6 text-center text-sm text-muted-foreground">Đang mở cổng bán vé…</p>;
}
