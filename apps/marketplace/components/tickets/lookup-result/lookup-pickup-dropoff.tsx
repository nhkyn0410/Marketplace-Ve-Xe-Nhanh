import React from "react";
import { Badge } from "@vexenhanh/ui/components/badge";
import { Clock } from "lucide-react";
import type { TicketLookupResultData } from "../../../lib/data/types";

/**
 * Thuộc tính của LookupPickupDropoff
 */
export interface LookupPickupDropoffProps {
  readonly pickupPoint: TicketLookupResultData["pickupPoint"];
  readonly dropoffPoint: TicketLookupResultData["dropoffPoint"];
}

/**
 * Khối Điểm đón và điểm trả trong kết quả tra cứu vé chuẩn Figma node 1446:15578
 */
export const LookupPickupDropoff: React.FC<LookupPickupDropoffProps> = ({
  pickupPoint,
  dropoffPoint
}) => {
  return (
    <div className="rounded-2xl border border-border/80 bg-card p-5 sm:p-6 shadow-xs space-y-4">
      <h3 className="text-base font-bold text-foreground">
        Điểm đón và điểm trả
      </h3>

      {/* 2 Box Điểm đón & Điểm trả */}
      <div className="grid grid-cols-1 sm:grid-cols-2 gap-3.5">
        {/* Điểm đón */}
        <div className="p-4 rounded-xl bg-muted/40 border border-border/60 space-y-1.5">
          <div className="text-[11px] font-bold text-muted-foreground uppercase tracking-wider">
            ĐIỂM ĐÓN · {pickupPoint.time}
          </div>
          <div className="text-sm font-bold text-foreground">
            {pickupPoint.name}
          </div>
          <div className="text-xs text-muted-foreground leading-relaxed">
            {pickupPoint.address}
          </div>
          {pickupPoint.tagText && (
            <div className="pt-1">
              <Badge className="bg-amber-500/15 text-amber-900 dark:text-amber-200 border-amber-500/30 text-[10px] font-semibold py-0.5">
                {pickupPoint.tagText}
              </Badge>
            </div>
          )}
        </div>

        {/* Điểm trả */}
        <div className="p-4 rounded-xl bg-muted/40 border border-border/60 space-y-1.5">
          <div className="text-[11px] font-bold text-muted-foreground uppercase tracking-wider">
            ĐIỂM TRẢ · {dropoffPoint.time} ({dropoffPoint.noticeText})
          </div>
          <div className="text-sm font-bold text-foreground">
            {dropoffPoint.name}
          </div>
          <div className="text-xs text-muted-foreground leading-relaxed">
            {dropoffPoint.address}
          </div>
        </div>
      </div>

      {/* Dòng lưu ý xuất trình mã QR */}
      <div className="p-3.5 rounded-xl bg-teal-50/70 dark:bg-teal-950/20 border border-teal-200/60 dark:border-teal-900/40 flex items-start gap-2.5 text-xs text-teal-950 dark:text-teal-200">
        <Clock className="h-4 w-4 text-teal-700 dark:text-teal-400 shrink-0 mt-0.5" />
        <div className="leading-relaxed">
          Có mặt tại điểm đón trước giờ khởi hành ít nhất 30 phút và xuất trình mã QR của từng vé.
        </div>
      </div>
    </div>
  );
};
