"use client";

import { useQuery } from "@tanstack/react-query";
import { useCan } from "@vexenhanh/ui/components/auth/auth-context";
import { Input } from "@vexenhanh/ui/components/input";
import { ALL, FilterSelect } from "@vexenhanh/ui/components/list-controls";
import { useId } from "react";

import { PROVIDER_LABEL } from "../../lib/payment/payment-format";
import type { PaymentProvider } from "../../lib/payment/payment-api";
import { listOperatorOptions, type AdminReportParams } from "../../lib/report/report-api";

export type ReportFilterState = { from: string; to: string; operatorId: string; provider: string };

/** Giá trị bộ lọc → tham số API (bỏ "Tất cả"). */
export function toParams(state: ReportFilterState): AdminReportParams {
  return {
    from: state.from,
    to: state.to,
    operatorId: state.operatorId === ALL ? undefined : state.operatorId,
    provider: state.provider === ALL ? undefined : (state.provider as PaymentProvider)
  };
}

/** Bộ lọc chung của Tổng quan / Báo cáo Admin (Figma ADM-01, ADM-14a): khoảng ngày, nhà xe, phương thức thanh toán. */
export function ReportFilters({ value, onChange }: { value: ReportFilterState; onChange: (next: ReportFilterState) => void }) {
  // Danh sách nhà xe là `/admin/operators` (`user:manage`) — tài khoản không có quyền đó lọc được theo ngày / phương thức.
  const canListOperators = useCan()("user:manage");
  const operators = useQuery({ queryKey: ["admin-report", "operators"], queryFn: listOperatorOptions, enabled: canListOperators });
  return (
    <div className="flex flex-wrap items-end gap-x-4 gap-y-3">
      <DateField label="Từ ngày" value={value.from} onChange={(from) => onChange({ ...value, from })} />
      <DateField label="Đến ngày" value={value.to} onChange={(to) => onChange({ ...value, to })} />
      {canListOperators && (
        <FilterSelect label="Nhà xe" allLabel="Tất cả nhà xe" value={value.operatorId} onChange={(operatorId) => onChange({ ...value, operatorId })} options={operators.data ?? []} />
      )}
      <FilterSelect
        label="Phương thức thanh toán"
        allLabel="Tất cả"
        value={value.provider}
        onChange={(provider) => onChange({ ...value, provider })}
        options={(Object.keys(PROVIDER_LABEL) as PaymentProvider[]).map((provider) => ({ value: provider, label: PROVIDER_LABEL[provider] }))}
      />
    </div>
  );
}

function DateField({ label, value, onChange }: { label: string; value: string; onChange: (value: string) => void }) {
  const id = useId();
  return (
    <div className="flex w-44 flex-col gap-1.5">
      <label htmlFor={id} className="text-xs leading-[18px] font-medium text-muted-foreground">
        {label}
      </label>
      <Input id={id} type="date" value={value} onChange={(event) => onChange(event.target.value)} />
    </div>
  );
}
