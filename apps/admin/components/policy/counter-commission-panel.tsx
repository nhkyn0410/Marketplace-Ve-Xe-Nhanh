"use client";

import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { CounterCommissionSettlementInputSchema, type CounterCommissionSettlementInput } from "@vexenhanh/types";
import { IdentityField, useIdentityField } from "@vexenhanh/ui/components/auth/identity-field";
import { Button } from "@vexenhanh/ui/components/button";
import { FormField } from "@vexenhanh/ui/components/form-field";
import { Input } from "@vexenhanh/ui/components/input";
import { withReauth } from "@vexenhanh/ui/lib/auth/reauth";
import { useState } from "react";
import { getCounterCommission, settleCounterCommission, type OperatorOption } from "../../lib/policy/policy-api";
import { describePolicyError } from "../../lib/policy/policy-format";
import { CARD, CARD_TITLE } from "./cancellation-tab";
import { OperatorPicker } from "./operator-picker";

const money = (value: string) => `${BigInt(value).toLocaleString("vi-VN")} đ`;

/** Đối soát phí quầy phải thu và ghi nhận Platform đã nhận tiền theo kỳ thủ công. */
export function CounterCommissionPanel({ onNotice }: { onNotice: (text: string) => void }) {
  const [operator, setOperator] = useState<OperatorOption | null>(null);
  const [amount, setAmount] = useState("");
  const [reference, setReference] = useState("");
  const [reason, setReason] = useState("");
  const [attempt, setAttempt] = useState<CounterCommissionSettlementInput | null>(null);
  const [error, setError] = useState<string | null>(null);
  const identity = useIdentityField();
  const client = useQueryClient();
  const overview = useQuery({ queryKey: ["admin-counter-commission", operator?.id], queryFn: () => getCounterCommission(operator!.id), enabled: Boolean(operator) });
  const settlement = useMutation({
    mutationFn: (input: CounterCommissionSettlementInput) => withReauth(identity.secret, () => settleCounterCommission(input)),
    onSuccess: () => {
      onNotice("Đã ghi nhận khoản phí quầy Platform đã nhận.");
      setAttempt(null); setAmount(""); setReference(""); setReason(""); setError(null);
      void client.invalidateQueries({ queryKey: ["admin-counter-commission"] });
    },
    onError: (failure) => {
      const described = describePolicyError(failure);
      if (described.field === "identity") identity.require(described.message);
      else setError(described.message);
      void client.invalidateQueries({ queryKey: ["admin-counter-commission"] });
    },
  });

  function submit() {
    if (!operator) return;
    const candidate = CounterCommissionSettlementInputSchema.safeParse({ operatorId: operator.id, idempotencyKey: attempt?.idempotencyKey ?? crypto.randomUUID(), amount: amount.trim(), reference, reason });
    if (!candidate.success) { setError(candidate.error.issues[0]?.message ?? "Kiểm tra thông tin khoản thu."); return; }
    if (!identity.check()) return;
    // Cùng dữ liệu thử lại phải giữ khóa; sửa dữ liệu tạo lần ghi nhận mới.
    const next = attempt && (attempt.operatorId !== candidate.data.operatorId || attempt.amount !== candidate.data.amount || attempt.reference !== candidate.data.reference || attempt.reason !== candidate.data.reason)
      ? { ...candidate.data, idempotencyKey: crypto.randomUUID() } : candidate.data;
    setAttempt(next); setError(null); settlement.mutate(next);
  }

  return <section className={CARD} aria-labelledby="counter-commission-heading">
    <h2 id="counter-commission-heading" className={CARD_TITLE}>Phí bán vé quầy phải thu</h2>
    <p className="text-sm text-muted-foreground">Tiền vé do nhà xe thu trực tiếp. Phần này ghi phí phải thu và khoản Platform thực nhận, tách khỏi tiền chi trả online.</p>
    <FormField label="Nhà xe">{(control) => <OperatorPicker id={control.id} value={operator} onChange={(next) => { setOperator(next); setAttempt(null); setError(null); }} disabled={settlement.isPending} invalid={false} />}</FormField>
    {operator && overview.isPending && <p role="status">Đang tải phí quầy…</p>}
    {overview.isError && <div role="alert"><p>Không tải được phí quầy.</p><Button variant="outline" onClick={() => void overview.refetch()}>Thử lại</Button></div>}
    {overview.data && <>
      <dl className="grid gap-3 sm:grid-cols-3">{[["Tổng phí phát sinh", overview.data.accrued], ["Platform đã nhận", overview.data.settled], ["Còn phải thu", overview.data.outstanding]].map(([label, value]) => <div key={label} className="rounded-lg border p-3"><dt className="text-sm text-muted-foreground">{label}</dt><dd className="text-lg font-semibold">{money(value!)}</dd></div>)}</dl>
      <p className="text-xs text-muted-foreground">Tổng toàn bộ lịch sử. Hiển thị tối đa 200 khoản phát sinh và 200 khoản thu gần nhất.</p>
      {overview.data.items.length === 0 && <p className="text-sm text-muted-foreground">Chưa có phí quầy phát sinh.</p>}
      {overview.data.settlements.length > 0 && <div className="overflow-x-auto"><table className="w-full text-left text-sm"><caption className="sr-only">Các khoản phí quầy đã thu gần nhất</caption><thead><tr><th className="p-2">Ngày thu</th><th className="p-2">Tham chiếu</th><th className="p-2">Số tiền</th></tr></thead><tbody>{overview.data.settlements.map((row) => <tr key={row.id} className="border-t"><td className="p-2">{new Date(row.createdAt).toLocaleString("vi-VN", { timeZone: "Asia/Ho_Chi_Minh" })}</td><td className="p-2">{row.reference}</td><td className="p-2">{money(row.amount)}</td></tr>)}</tbody></table></div>}
      <form className="grid gap-4" noValidate onSubmit={(event) => { event.preventDefault(); submit(); }}>
        <div className="grid gap-4 sm:grid-cols-2"><FormField label="Số tiền Platform đã nhận (VND)">{(control) => <Input {...control} inputMode="numeric" value={amount} disabled={settlement.isPending} onChange={(event) => setAmount(event.target.value)} />}</FormField><FormField label="Mã giao dịch / chứng từ">{(control) => <Input {...control} maxLength={100} value={reference} disabled={settlement.isPending} onChange={(event) => setReference(event.target.value)} />}</FormField></div>
        <FormField label="Kỳ thu và lý do">{(control) => <Input {...control} maxLength={500} value={reason} disabled={settlement.isPending} onChange={(event) => setReason(event.target.value)} />}</FormField>
        {identity.needed && <IdentityField totp value={identity.value} error={identity.error} disabled={settlement.isPending} onChange={identity.change} />}
        {error && <p role="alert" className="text-sm text-error-600">{error}</p>}
        <Button type="submit" className="w-fit" disabled={settlement.isPending || overview.data.outstanding === "0"}>{settlement.isPending ? "Đang ghi nhận…" : "Xác nhận đã nhận phí"}</Button>
      </form>
    </>}
  </section>;
}
