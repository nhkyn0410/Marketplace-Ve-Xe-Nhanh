import React from "react";
import { Button } from "@vexenhanh/ui/components/button";
import { MapPin, ExternalLink, Navigation } from "lucide-react";

/**
 * Thuộc tính của TicketPickupMap
 */
export interface TicketPickupMapProps {
  readonly pointName: string;
  readonly address: string;
}

/**
 * Bản đồ điểm đón mô phỏng Goong Maps vector tuân thủ quy tắc A3 #4
 */
export const TicketPickupMap: React.FC<TicketPickupMapProps> = ({ pointName, address }) => {
  return (
    <div className="rounded-2xl border border-border/80 bg-card shadow-xs overflow-hidden">
      <div className="p-4 sm:p-5 pb-3 border-b border-border/50 flex items-center justify-between">
        <div className="text-base font-semibold text-foreground flex items-center gap-2">
          <MapPin className="h-4 w-4 text-rose-500" />
          <span>Vị trí điểm đón khách</span>
        </div>
        <span className="text-xs text-muted-foreground">Goong Map Vector</span>
      </div>

      <div className="p-0">
        {/* Bản đồ vector mô phỏng bản đồ Goong */}
        <div className="relative h-48 w-full bg-slate-100 dark:bg-slate-900 overflow-hidden flex items-center justify-center">
          {/* Lớp mạng lưới đường phố vector cách điệu */}
          <svg
            className="absolute inset-0 h-full w-full opacity-40 dark:opacity-20"
            xmlns="http://www.w3.org/2000/svg"
          >
            <defs>
              <pattern id="grid-pattern" width="40" height="40" patternUnits="userSpaceOnUse">
                <path d="M 40 0 L 0 0 0 40" fill="none" stroke="currentColor" strokeWidth="1" className="text-slate-300 dark:text-slate-700" />
              </pattern>
            </defs>
            <rect width="100%" height="100%" fill="url(#grid-pattern)" />
            
            {/* Tuyến đường chính Hoàng Hữu Nam & Xa Lộ Hà Nội */}
            <line x1="0" y1="90" x2="100%" y2="90" stroke="#cbd5e1" strokeWidth="14" />
            <line x1="0" y1="90" x2="100%" y2="90" stroke="#f8fafc" strokeWidth="10" />

            <line x1="180" y1="0" x2="320" y2="200" stroke="#cbd5e1" strokeWidth="12" />
            <line x1="180" y1="0" x2="320" y2="200" stroke="#f8fafc" strokeWidth="8" />

            {/* Tuyến đường phụ */}
            <line x1="40" y1="0" x2="40" y2="200" stroke="#e2e8f0" strokeWidth="6" />
            <line x1="450" y1="0" x2="450" y2="200" stroke="#e2e8f0" strokeWidth="6" />
          </svg>

          {/* Vùng công viên / khuôn viên bến xe */}
          <div className="absolute left-[38%] top-[25%] w-36 h-28 rounded-xl bg-emerald-100/60 dark:bg-emerald-950/30 border border-emerald-300/40 -rotate-3 flex items-center justify-center">
            <span className="text-[10px] font-semibold text-emerald-800/70 dark:text-emerald-400/60 tracking-wider uppercase text-center px-2">
              Khuôn viên Bến xe
            </span>
          </div>

          {/* Pin đánh dấu điểm đón */}
          <div className="relative z-10 flex flex-col items-center">
            <div className="flex items-center gap-1.5 px-3 py-1.5 rounded-full bg-slate-900 text-white dark:bg-white dark:text-slate-900 shadow-lg text-xs font-bold border border-rose-500/30 animate-bounce">
              <Navigation className="h-3.5 w-3.5 text-rose-500 fill-rose-500" />
              <span>{pointName}</span>
            </div>
            <div className="w-2.5 h-2.5 bg-rose-500 rounded-full ring-4 ring-rose-500/30 -mt-1" />
          </div>

          {/* Badge nguồn bản đồ góc dưới */}
          <div className="absolute bottom-2 right-2 px-2 py-0.5 rounded bg-background/80 backdrop-blur-xs text-[10px] text-muted-foreground border border-border">
            © Goong Map
          </div>
        </div>

        {/* Thông tin địa chỉ & nút mở ứng dụng bản đồ */}
        <div className="p-4 bg-muted/20 flex flex-col sm:flex-row sm:items-center sm:justify-between gap-3 border-t border-border/50">
          <div className="space-y-0.5">
            <div className="text-xs font-semibold text-foreground">{pointName}</div>
            <div className="text-xs text-muted-foreground">{address}</div>
          </div>

          <Button
            type="button"
            variant="outline"
            size="sm"
            className="text-xs h-8 gap-1.5 self-start sm:self-auto"
            onClick={() => {
              // Mở link ngoài bản đồ Goong theo địa chỉ
              window.open(`https://maps.goong.io/?q=${encodeURIComponent(address)}`, "_blank", "noopener,noreferrer");
            }}
          >
            <ExternalLink className="h-3 w-3" />
            <span>Mở chỉ đường Goong</span>
          </Button>
        </div>
      </div>
    </div>
  );
};
