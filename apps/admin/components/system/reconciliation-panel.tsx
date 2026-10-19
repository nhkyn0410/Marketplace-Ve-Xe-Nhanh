"use client";

import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { ReconciliationRequestSchema, type ReconciliationRecord, type ReconciliationRequest } from "@vexenhanh/types";
import { IdentityField, useIdentityField } from "@vexenhanh/ui/components/auth/identity-field";
import { Badge } from "@vexenhanh/ui/components/badge";
import { Button } from "@vexenhanh/ui/components/button";
import { Dialog, DialogContent, DialogDescription, DialogFooter, DialogHeader, DialogTitle } from "@vexenhanh/ui/components/dialog";
import { FormField } from "@vexenhanh/ui/components/form-field";
import { Textarea } from "@vexenhanh/ui/components/textarea";
import { apiRequest } from "@vexenhanh/ui/lib/auth/api-client";
import { describeReauthError, withReauth } from "@vexenhanh/ui/lib/auth/reauth";
import { LoaderCircle, RefreshCw } from "lucide-react";
import { useState } from "react";
import { formatDateTime } from "../../lib/user/user-format";

const KEY = ["admin-system", "reconciliation"];
const STATES = { QUEUED: "Đang chờ", RUNNING: "Đang đối soát", COMPLETED: "Hoàn tất", FAILED: "Lỗi" } as const;
const CHECKPOINTS: Record<string, string> = {
  PAYMENT_CAPTURE: "Tiền thanh toán vào sổ", CAPTURE_STATUS: "Trạng thái thanh toán đã vào sổ",
  REFUND_LEDGER: "Tiền hoàn trên sổ", REFUND_STATUS: "Trạng thái hoàn tiền đã ghi sổ",
  PLATFORM_SUBSIDY: "Phần giảm nền tảng chịu", SUBSIDY_REVERSAL: "Thu hồi phần giảm nền tảng chịu",
  COMMISSION: "Hoa hồng", COMMISSION_REVERSAL: "Hoa hồng trả lại",
  PAYOUT_TOTAL: "Tổng kỳ chi trả", PAYOUT_ITEM: "Bút toán thuộc kỳ chi trả",
  PAID_PAYOUT: "Tiền đã chi trên sổ", PAYOUT_STATUS: "Trạng thái kỳ đã chi",
};

/** Lịch sử đối soát sổ giữ hộ, kỳ chi trả và nút chủ động chạy lại có xác nhận danh tính. */
export function ReconciliationPanel() {
  const [open, setOpen] = useState(false);
  const history = useQuery({ queryKey: KEY, queryFn: () => apiRequest<{ items: ReconciliationRecord[] }>("/admin/system/reconciliation"), refetchInterval: (query) => query.state.data?.items.some((item) => item.status === "QUEUED" || item.status === "RUNNING") ? 5000 : false });
  const recent = history.data?.items[0];
  return <section aria-label="Đối soát thanh toán và sổ giữ hộ" className="flex flex-col gap-4 rounded-xl border bg-card p-6">
    <div className="flex flex-wrap items-start justify-between gap-3"><div><h2 className="text-lg font-semibold">Đối soát thanh toán và sổ giữ hộ</h2><p className="text-sm text-muted-foreground">So khớp cổng thanh toán, hoàn tiền, sổ giữ hộ và các kỳ chi trả.</p></div><Button variant="outline" onClick={() => setOpen(true)} disabled={recent?.status === "QUEUED" || recent?.status === "RUNNING"}><RefreshCw className="size-4" />Chạy lại đối soát</Button></div>
    {history.isPending ? <p role="status">Đang tải lịch sử đối soát…</p> : history.isError ? <p role="alert">Chưa tải được lịch sử. <button type="button" className="underline" onClick={() => void history.refetch()}>Thử lại</button></p> : history.data.items.length === 0 ? <p className="text-sm text-muted-foreground">Chưa có lần đối soát nào được lưu.</p> : <ul className="flex flex-col gap-3">{history.data.items.map((run) => <li key={run.runId} className="rounded-lg border p-3">
      <div className="flex flex-wrap items-center gap-2"><span className="text-sm font-semibold">{formatDateTime(run.createdAt)} · {run.source === "MANUAL" ? "Thủ công" : "Theo lịch"}</span><Badge tone={run.status === "FAILED" || run.issueCount || run.paymentErrors ? "warning" : run.status === "COMPLETED" ? "success" : "neutral"}>{STATES[run.status]}{run.issueCount > 0 ? ` · ${run.issueCount} sai lệch` : ""}</Badge></div>
      <p className="mt-1 text-sm text-muted-foreground">{run.paymentsChecked} thanh toán · {run.ledgerEntriesChecked} bút toán · {run.payoutsChecked} kỳ chi trả{run.paymentErrors ? ` · ${run.paymentErrors} lỗi tra cổng cần thử lại` : ""}{run.error ? ` · ${run.error}` : ""}</p>
      {run.issues.length > 0 && <details className="mt-2 text-sm"><summary className="cursor-pointer font-medium">Xem sai lệch cần kiểm tra</summary><ul className="mt-2 flex flex-col gap-1">{run.issues.map((issue, index) => <li key={`${issue.checkpoint}-${issue.entityId}-${index}`} className="break-all">{CHECKPOINTS[issue.checkpoint] ?? issue.checkpoint} · {issue.entityId}: cần {issue.expected}, thực tế {issue.actual}</li>)}</ul>{run.issueCount > run.issues.length && <p>Hiển thị {run.issues.length} / {run.issueCount} sai lệch.</p>}</details>}
    </li>)}</ul>}
    <ReconciliationDialog key={open ? "open" : "closed"} open={open} onClose={() => setOpen(false)} />
  </section>;
}

function ReconciliationDialog({ open, onClose }: { open: boolean; onClose: () => void }) {
  const [reason, setReason] = useState("");
  const [requestId] = useState(() => crypto.randomUUID());
  const [error, setError] = useState<string | null>(null);
  const identity = useIdentityField();
  const queryClient = useQueryClient();
  const submit = useMutation({
    mutationFn: (input: ReconciliationRequest) => withReauth(identity.secret, () => apiRequest<ReconciliationRecord>("/admin/system/reconciliation", { method: "POST", body: input })),
    onSuccess: () => { void queryClient.invalidateQueries({ queryKey: KEY }); onClose(); },
    onError: (failure) => { const message = describeReauthError(failure); if (message) identity.require(message); else { identity.sync(); setError("Chưa xếp hàng được. Vui lòng thử lại."); } },
  });
  return <Dialog open={open} onOpenChange={(next) => { if (!next && !submit.isPending) onClose(); }}><DialogContent><DialogHeader><DialogTitle>Chạy lại đối soát</DialogTitle><DialogDescription>Kiểm tra thanh toán, bút toán và kỳ chi trả. Sai lệch được lưu để vận hành xác minh.</DialogDescription></DialogHeader>
    <form className="flex flex-col gap-4" onSubmit={(event) => { event.preventDefault(); const parsed = ReconciliationRequestSchema.safeParse({ requestId, reason }); if (!parsed.success) { setError("Nhập lý do 3–500 ký tự."); return; } setError(null); if (identity.check()) submit.mutate(parsed.data); }}>
      <FormField label="Lý do chạy lại">{(control) => <Textarea {...control} value={reason} maxLength={500} onChange={(event) => setReason(event.target.value)} disabled={submit.isPending} />}</FormField>
      {identity.needed && <IdentityField totp value={identity.value} error={identity.error} disabled={submit.isPending} onChange={identity.change} />}
      {error && <p role="alert" className="text-sm text-error-600">{error}</p>}
      <DialogFooter><Button type="button" variant="outline" disabled={submit.isPending} onClick={onClose}>Hủy</Button><Button type="submit" disabled={submit.isPending}>{submit.isPending && <LoaderCircle className="size-4 animate-spin" />}Chạy đối soát</Button></DialogFooter>
    </form>
  </DialogContent></Dialog>;
}
