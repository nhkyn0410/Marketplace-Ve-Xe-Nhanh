import React from "react";
import { ShieldAlert, CheckCircle2 } from "lucide-react";

/**
 * Thuộc tính của TicketBoardingRules
 */
export interface TicketBoardingRulesProps {
  readonly rules: readonly string[];
}

/**
 * Khối lưu ý và quy định quan trọng khi lên xe
 */
export const TicketBoardingRules: React.FC<TicketBoardingRulesProps> = ({ rules }) => {
  return (
    <div className="rounded-2xl border border-border/80 bg-card p-5 sm:p-6 shadow-xs space-y-4">
      <div className="flex items-center gap-2 pb-3 border-b border-border/50">
        <ShieldAlert className="h-4 w-4 text-amber-500" />
        <h3 className="text-base font-semibold text-foreground">
          Quy định khi lên xe
        </h3>
      </div>

      <div>
        <ul className="space-y-2.5 text-xs text-muted-foreground leading-relaxed">
          {rules.map((rule, idx) => (
            <li key={idx} className="flex items-start gap-2.5">
              <CheckCircle2 className="h-4 w-4 text-emerald-600 dark:text-emerald-400 shrink-0 mt-0.5" />
              <span>{rule}</span>
            </li>
          ))}
        </ul>
      </div>
    </div>
  );
};
