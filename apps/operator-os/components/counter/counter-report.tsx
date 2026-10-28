"use client";

import { useQuery } from "@tanstack/react-query";
import { Button } from "@vexenhanh/ui/components/button";
import { Input } from "@vexenhanh/ui/components/input";
import { LoaderCircle, RefreshCw } from "lucide-react";
import { useState } from "react";

import { getCounterReport } from "../../lib/counter/counter-api";
import { counterError, counterMoney, counterToday } from "../../lib/counter/counter-format";

/** Đối soát trong ngày theo phương thức thu và người xác nhận tại một văn phòng. */
export function CounterReportPanel({ officeId }: { officeId: string }) {
  const [date, setDate] = useState(() => counterToday());
  const report = useQuery({ queryKey: ["counter-report", officeId, date], queryFn: () => getCounterReport(officeId, date), refetchInterval: 30_000 });
  return <section className="flex flex-col gap-4 rounded-xl border bg-card p-5 sm:p-6 print:hidden" aria-label="Đối soát thu tại quầy">
    <div className="flex flex-wrap items-center justify-between gap-3"><div><h2 className="font-semibold">Thu tại quầy trong ngày</h2><p className="mt-1 text-xs text-muted-foreground">Theo ngày xác nhận thu, tách khỏi ngày chạy của chuyến. Tiền cần xử lý hiển thị riêng.</p></div><div className="flex items-end gap-2"><label className="flex flex-col gap-1 text-xs">Ngày thu tiền<Input type="date" value={date} onChange={(event) => setDate(event.target.value)} /></label><Button variant="ghost" size="sm" disabled={report.isFetching} onClick={() => void report.refetch()}><RefreshCw className="size-4" />Tải lại</Button></div></div>
    {report.isPending ? <p role="status" className="flex items-center gap-2 text-sm"><LoaderCircle className="size-4 animate-spin" />Đang tải đối soát…</p> : report.isError ? <p role="alert" className="text-sm text-error-600">{counterError(report.error)}</p> : <>
      <dl className="grid gap-3 sm:grid-cols-2 lg:grid-cols-4">{[
        ["Tiền mặt đã xác nhận", report.data.cash], ["Chuyển khoản đã xác nhận", report.data.bankTransfer], ["Tiền cần xử lý ngoại lệ", report.data.exceptions], ["Hoa hồng phát sinh", report.data.commission],
      ].map(([label, value]) => <div key={label} className="rounded-lg bg-muted p-3"><dt className="text-xs text-muted-foreground">{label}</dt><dd className="mt-2 text-lg font-semibold">{counterMoney(value!)}</dd></div>)}</dl>
      {report.data.sellers.length > 0 && <div className="overflow-x-auto"><table className="w-full min-w-[640px] text-left text-sm"><thead><tr className="border-b text-xs text-muted-foreground"><th className="px-2 py-3">Người xác nhận thu</th><th className="px-2 py-3">Tiền mặt</th><th className="px-2 py-3">Chuyển khoản</th><th className="px-2 py-3">Ngoại lệ</th><th className="px-2 py-3">Hoa hồng</th></tr></thead><tbody>{report.data.sellers.map((seller) => <tr key={seller.seller} className="border-b last:border-0"><td className="px-2 py-3">{seller.seller}</td>{[seller.cash, seller.bankTransfer, seller.exceptions, seller.commission].map((value, index) => <td key={index} className="px-2 py-3">{counterMoney(value)}</td>)}</tr>)}</tbody></table></div>}
    </>}
  </section>;
}
