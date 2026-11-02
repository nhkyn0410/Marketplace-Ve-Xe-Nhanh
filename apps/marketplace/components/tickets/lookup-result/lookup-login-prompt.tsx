"use client";

import React, { useEffect, useState } from "react";
import Link from "next/link";
import { UserRound } from "lucide-react";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle
} from "@vexenhanh/ui/components/dialog";
import { Button } from "@vexenhanh/ui/components/button";

/** Mỗi phiên trình duyệt chỉ hỏi một lần (danh sách → chi tiết không hỏi lại). */
const SHOWN_KEY = "vxn_lookup_login_prompt_shown";

/**
 * Thuộc tính của LookupLoginPrompt
 */
export interface LookupLoginPromptProps {
  readonly maskedEmail: string;
  /** Email đã có tài khoản; `false` = chỉ có đơn đặt khi đã đăng nhập (tài khoản có thể dùng email khác). */
  readonly hasAccount: boolean;
}

/**
 * Hỏi khách có muốn đăng nhập không khi email vừa xác minh đã có tài khoản hoặc có đơn đặt bằng tài khoản (Khanh 27/10/2026).
 */
export const LookupLoginPrompt: React.FC<LookupLoginPromptProps> = ({ maskedEmail, hasAccount }) => {
  const [isOpen, setIsOpen] = useState(false);

  useEffect(() => {
    try {
      if (window.sessionStorage.getItem(SHOWN_KEY)) return;
      window.sessionStorage.setItem(SHOWN_KEY, "1");
    } catch {
      // Không đọc / ghi được bộ nhớ phiên: vẫn hỏi, chỉ là có thể hỏi lại ở trang sau.
    }
    setIsOpen(true);
  }, []);

  return (
    <Dialog open={isOpen} onOpenChange={setIsOpen}>
      <DialogContent className="sm:max-w-md">
        <DialogHeader>
          <div className="mb-1 flex size-11 items-center justify-center rounded-full bg-teal-50 text-teal-800">
            <UserRound className="size-5" />
          </div>
          <DialogTitle className="text-xl font-bold">Bạn có muốn đăng nhập không?</DialogTitle>
          <DialogDescription className="pt-1 text-sm leading-relaxed text-muted-foreground">
            {hasAccount ? (
              <>
                Email <strong className="font-semibold text-foreground">{maskedEmail}</strong> đã có tài khoản Vé Xe Nhanh. Đăng nhập để
                quản lý các đơn đặt bằng tài khoản: hủy vé, gửi khiếu nại và tích điểm VXN Plus.
              </>
            ) : (
              <>Một số đơn được đặt khi đã đăng nhập. Đăng nhập tài khoản đó để quản lý đầy đủ: hủy vé, gửi khiếu nại và tích điểm VXN Plus.</>
            )}
          </DialogDescription>
        </DialogHeader>
        <DialogFooter className="gap-2 sm:gap-2">
          <Button type="button" variant="outline" onClick={() => setIsOpen(false)} className="h-10 rounded-xl text-sm font-semibold">
            Tiếp tục tra cứu
          </Button>
          <Button asChild className="h-10 rounded-xl bg-teal-900 text-sm font-semibold text-white hover:bg-teal-950">
            <Link href="/login" onClick={() => setIsOpen(false)}>Đăng nhập</Link>
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
};
