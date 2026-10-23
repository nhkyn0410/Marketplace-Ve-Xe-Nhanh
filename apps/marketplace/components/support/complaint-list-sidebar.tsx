"use client";

import React, { useState } from "react";
import { Badge } from "@vexenhanh/ui/components/badge";
import { cn } from "@vexenhanh/ui/lib/utils";
import type { ComplaintListItem } from "../../lib/data/types";

/**
 * Thuộc tính của ComplaintListSidebar
 */
export interface ComplaintListSidebarProps {
  readonly activeComplaints: readonly ComplaintListItem[];
  readonly closedComplaints: readonly ComplaintListItem[];
  readonly selectedId: string;
  readonly onSelectComplaint: (id: string) => void;
}

/**
 * Cột bên trái: Danh sách khiếu nại dạng tab Đang xử lý / Đã đóng chuẩn Figma node 1446:16033
 */
export const ComplaintListSidebar: React.FC<ComplaintListSidebarProps> = ({
  activeComplaints,
  closedComplaints,
  selectedId,
  onSelectComplaint
}) => {
  const [activeTab, setActiveTab] = useState<"active" | "closed">("active");

  const displayList = activeTab === "active" ? activeComplaints : closedComplaints;

  return (
    <div className="w-full space-y-4">
      {/* 2 Tabs chuyển đổi danh sách */}
      <div className="flex items-center gap-1.5 p-1 bg-muted/60 rounded-xl border border-border/60">
        <button
          type="button"
          onClick={() => setActiveTab("active")}
          className={cn(
            "flex-1 py-1.5 px-3 text-xs font-semibold rounded-lg transition-all",
            activeTab === "active"
              ? "bg-background text-foreground shadow-xs"
              : "text-muted-foreground hover:text-foreground"
          )}
        >
          Đang xử lý ({activeComplaints.length})
        </button>
        <button
          type="button"
          onClick={() => setActiveTab("closed")}
          className={cn(
            "flex-1 py-1.5 px-3 text-xs font-semibold rounded-lg transition-all",
            activeTab === "closed"
              ? "bg-background text-foreground shadow-xs"
              : "text-muted-foreground hover:text-foreground"
          )}
        >
          Đã đóng ({closedComplaints.length})
        </button>
      </div>

      {/* Danh sách các thẻ khiếu nại */}
      <div className="space-y-3">
        {displayList.length === 0 ? (
          <div className="p-6 text-center text-xs text-muted-foreground rounded-2xl border border-dashed border-border bg-card">
            Không có khiếu nại nào trong mục này.
          </div>
        ) : (
          displayList.map((item) => {
            const isSelected = item.id === selectedId;
            return (
              <div
                key={item.id}
                onClick={() => onSelectComplaint(item.id)}
                className={cn(
                  "p-4 rounded-2xl border transition-all cursor-pointer text-left",
                  isSelected
                    ? "border-teal-700/80 bg-teal-50/30 dark:bg-teal-950/20 shadow-xs ring-1 ring-teal-700/40"
                    : "border-border/80 bg-card hover:border-border hover:bg-muted/30"
                )}
              >
                <div className="flex items-center justify-between gap-2 mb-1.5">
                  <span className="text-[11px] font-mono text-muted-foreground font-semibold">
                    {item.code}
                  </span>
                  <Badge
                    tone={item.statusTone}
                    className="text-[10px] font-semibold px-2 py-0 h-5"
                  >
                    {item.statusLabel}
                  </Badge>
                </div>

                <h4 className="font-bold text-foreground text-sm line-clamp-1 mb-1">
                  {item.title}
                </h4>

                <div className="text-[11px] text-muted-foreground">
                  {item.bookingCode} · Cập nhật {item.updatedAtText}
                </div>
              </div>
            );
          })
        )}
      </div>
    </div>
  );
};
