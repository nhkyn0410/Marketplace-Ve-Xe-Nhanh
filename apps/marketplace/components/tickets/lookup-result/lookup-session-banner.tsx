"use client";

import React, { useState, useEffect } from "react";
import { useRouter } from "next/navigation";
import { Button } from "@vexenhanh/ui/components/button";
import { ShieldCheck, Clock, LogOut } from "lucide-react";

/**
 * Thuộc tính của LookupSessionBanner
 */
export interface LookupSessionBannerProps {
  readonly maskedEmail: string;
  readonly bookingCode: string;
  readonly expiresInSeconds: number;
  readonly onEndSession?: () => void;
}

/**
 * Định dạng số giây thành MM:SS
 */
function formatTimer(totalSeconds: number): string {
  const m = Math.floor(totalSeconds / 60);
  const s = totalSeconds % 60;
  return `${m.toString().padStart(2, "0")}:${s.toString().padStart(2, "0")}`;
}

/**
 * Banner thông báo phiên xác minh tạm thời chuẩn Figma node 1446:15578
 */
export const LookupSessionBanner: React.FC<LookupSessionBannerProps> = ({
  maskedEmail,
  bookingCode,
  expiresInSeconds,
  onEndSession
}) => {
  const router = useRouter();
  const [secondsLeft, setSecondsLeft] = useState(expiresInSeconds);

  useEffect(() => {
    if (secondsLeft <= 0) return;
    const interval = setInterval(() => {
      setSecondsLeft((prev) => (prev > 0 ? prev - 1 : 0));
    }, 1000);
    return () => clearInterval(interval);
  }, [secondsLeft]);

  const handleEndSession = (): void => {
    if (onEndSession) {
      onEndSession();
    } else {
      router.push("/tickets/lookup");
    }
  };

  return (
    <div className="rounded-2xl border border-emerald-200/80 bg-emerald-50/60 dark:border-emerald-900/40 dark:bg-emerald-950/20 p-4 flex flex-col sm:flex-row sm:items-center sm:justify-between gap-3 text-xs">
      <div className="flex items-center gap-2.5 text-emerald-950 dark:text-emerald-200 font-medium">
        <ShieldCheck className="h-4 w-4 text-emerald-600 dark:text-emerald-400 shrink-0" />
        <span>
          Tra cứu bằng email <strong className="font-bold">{maskedEmail}</strong> · chỉ hiển thị đơn <strong className="font-bold">{bookingCode}</strong>
        </span>
      </div>

      <div className="flex items-center gap-3 self-end sm:self-auto">
        <div className="flex items-center gap-1.5 text-muted-foreground">
          <Clock className="h-3.5 w-3.5" />
          <span>Phiên còn <strong className="font-mono font-bold text-foreground">{formatTimer(secondsLeft)}</strong></span>
        </div>

        <Button
          type="button"
          variant="outline"
          size="sm"
          onClick={handleEndSession}
          className="h-8 gap-1.5 text-xs font-semibold border-border hover:bg-background"
        >
          <LogOut className="h-3.5 w-3.5" />
          <span>Kết thúc phiên</span>
        </Button>
      </div>
    </div>
  );
};
