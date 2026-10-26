"use client";

import { Button } from "@vexenhanh/ui/components/button";
import { ArrowLeft, FileX, Home } from "lucide-react";
import Link from "next/link";
import { useRouter } from "next/navigation";

import { PassengerTopBar } from "../components/passenger-topbar";

/**
 * Trang lỗi 404 hiển thị khi không tìm thấy trang theo thiết kế Figma 1449:21608 (SCR-PSG-05).
 */
export default function NotFound() {
  const router = useRouter();

  return (
    <div data-no-footer="true" className="flex min-h-[calc(var(--vxn-vh)_-_4rem)] flex-col bg-white">
      <PassengerTopBar
        breadcrumbs={[
          { label: "Trang chủ", href: "/" },
          { label: "Không tìm thấy trang" }
        ]}
      />

      <div className="flex flex-1 flex-col items-center justify-center px-4 py-20 text-center">
        {/* Vòng tròn biểu tượng */}
        <div className="mb-6 flex size-24 items-center justify-center rounded-full bg-[#e0f2fe] text-vxn-teal-700">
          <FileX className="size-11 stroke-[2.2]" />
        </div>

        {/* Nhãn mã lỗi */}
        <span className="text-xs font-semibold uppercase tracking-widest text-vxn-fg-4">
          LỖI 404
        </span>

        {/* Tiêu đề lỗi */}
        <h1 className="mt-3 text-2xl/9 font-semibold tracking-[-0.24px] text-vxn-ink">
          Không tìm thấy trang
        </h1>

        {/* Mô tả chi tiết */}
        <p className="mt-3 max-w-lg text-sm leading-relaxed text-vxn-fg-3">
          Đường dẫn không tồn tại hoặc nội dung đã được gỡ. Hãy kiểm tra lại địa chỉ hoặc quay về trang chủ để tìm chuyến.
        </p>

        {/* Các nút hành động */}
        <div className="mt-8 flex flex-wrap items-center justify-center gap-3">
          <Button
            type="button"
            variant="outline"
            onClick={() => router.back()}
            className="h-11 rounded-lg border-vxn-border bg-white px-5 text-sm font-medium text-vxn-ink hover:bg-vxn-bg-2"
          >
            <ArrowLeft className="mr-2 size-4" />
            Về trang trước
          </Button>

          <Button
            asChild
            className="h-11 rounded-lg bg-vxn-teal-700 px-5 text-sm font-medium text-white shadow-xs hover:bg-vxn-teal-800"
          >
            <Link href="/">
              <Home className="mr-2 size-4" />
              Về trang chủ
            </Link>
          </Button>
        </div>
      </div>
    </div>
  );
}
