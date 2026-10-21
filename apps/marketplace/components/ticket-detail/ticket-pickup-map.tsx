import React from "react";
import { Button } from "@vexenhanh/ui/components/button";
import { MapPin, ExternalLink } from "lucide-react";

/**
 * Thuộc tính của TicketPickupMap
 */
export interface TicketPickupMapProps {
  readonly pointName: string;
  readonly address: string;
}

/**
 * Địa chỉ điểm đón và liên kết mở bản đồ bên ngoài.
 */
export const TicketPickupMap: React.FC<TicketPickupMapProps> = ({ pointName, address }) => {
  return (
    <div className="rounded-2xl border border-border/80 bg-card shadow-xs overflow-hidden">
      <div className="p-4 sm:p-5 pb-3 border-b border-border/50 flex items-center justify-between">
        <div className="text-base font-semibold text-foreground flex items-center gap-2">
          <MapPin className="h-4 w-4 text-rose-500" />
          <span>Vị trí điểm đón khách</span>
        </div>
      </div>

      <div className="p-0">
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
