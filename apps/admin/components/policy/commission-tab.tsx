"use client";

import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { IdentityField, useIdentityField } from "@vexenhanh/ui/components/auth/identity-field";
import { Badge } from "@vexenhanh/ui/components/badge";
import { Button } from "@vexenhanh/ui/components/button";
import { Dialog, DialogContent, DialogDescription, DialogFooter, DialogHeader, DialogTitle } from "@vexenhanh/ui/components/dialog";
import { FormField } from "@vexenhanh/ui/components/form-field";
import { Input } from "@vexenhanh/ui/components/input";
import { TABLE, TABLE_CELL, TABLE_HEAD_CELL, TABLE_HEAD_ROW, TableSkeleton } from "@vexenhanh/ui/components/list-controls";
import { BUTTON, ListStatePanel } from "@vexenhanh/ui/components/list-parts";
import { Textarea } from "@vexenhanh/ui/components/textarea";
import { withReauth } from "@vexenhanh/ui/lib/auth/reauth";
import { Ban, Calculator, Check, CircleAlert, LoaderCircle, Percent, Pencil, RefreshCw } from "lucide-react";
import { useState } from "react";

import {
  cancelCommissionRule,
  type CommissionRule,
  createCommissionRule,
  getCommission,
  type OperatorOption,
  updateCommissionRule
} from "../../lib/policy/policy-api";
import {
  bpsToPercentInput,
  describePolicyError,
  formatRate,
  fromVnDateInput,
  percentToBps,
  STATE,
  toVnDateInput
} from "../../lib/policy/policy-format";
import { formatDate, LOCK_REASON_MAX, lockReasonError } from "../../lib/user/user-format";
import { AccountActionDialog, type AccountAction } from "../user/account-dialogs";
import { CARD, CARD_TITLE } from "./cancellation-tab";
import { OperatorPicker } from "./operator-picker";
import { CounterCommissionPanel } from "./counter-commission-panel";

const STAT = "flex flex-col gap-2 rounded-xl border bg-card p-5";

/**
 * Tab "Hoa hồng" (Figma ADM-06c; FR-ADM-07, BR-31): mức mặc định + mức riêng theo nhà xe có ngày hiệu lực. "Hoa hồng ghi
 * nhận tháng này" cần dữ liệu thanh toán (chưa có) nên hiện "—".
 */
export function CommissionTab({
  creating,
  onCloseCreate,
  onNotice
}: {
  creating: boolean;
  onCloseCreate: () => void;
  onNotice: (text: string) => void;
}) {
  const queryClient = useQueryClient();
  const commission = useQuery({ queryKey: ["admin-commission"], queryFn: getCommission });
  const [editing, setEditing] = useState<CommissionRule | null>(null);
  const [action, setAction] = useState<AccountAction | null>(null);
  const refresh = () => void queryClient.invalidateQueries({ queryKey: ["admin-commission"] });

  if (!commission.data) {
    return commission.isError ? (
      <ListStatePanel
        icon={<CircleAlert className="size-6 text-warning-700" />}
        title="Không tải được hoa hồng"
        description="Kiểm tra kết nối mạng rồi thử lại."
        action={
          <Button className={`${BUTTON} w-36`} onClick={() => void commission.refetch()}>
            <RefreshCw className="size-[18px]" />
            Thử lại
          </Button>
        }
      />
    ) : (
      <TableSkeleton label="Đang tải hoa hồng" />
    );
  }
  const data = commission.data;
  const active = data.overrides.filter((rule) => rule.state === "ACTIVE").length;
  const scheduled = data.overrides.filter((rule) => rule.state === "SCHEDULED").length;

  return (
    <>
      <div className="grid gap-4 md:grid-cols-3">
        <div className={STAT}>
          <p className="text-sm leading-5 text-muted-foreground">Hoa hồng online mặc định</p>
          <p className="text-[30px] leading-[38px] font-semibold text-vxn-ink">{data.default ? formatRate(data.default.rateBps) : "—"}</p>
          <p className="text-xs leading-[18px] text-muted-foreground">
            {data.default ? `Từ ${formatDate(data.default.effectiveFrom)} · Quầy mặc định 0%` : "Online chưa cấu hình · Quầy mặc định 0%"}
          </p>
        </div>
        <div className={STAT}>
          <p className="text-sm leading-5 text-muted-foreground">Nhà xe có mức riêng</p>
          <p className="text-[30px] leading-[38px] font-semibold text-vxn-ink">{active}</p>
          <p className="text-xs leading-[18px] text-muted-foreground">{scheduled} mức đã lên lịch</p>
        </div>
        <div className={STAT}>
          <p className="text-sm leading-5 text-muted-foreground">Hoa hồng ghi nhận tháng này</p>
          <p className="text-[30px] leading-[38px] font-semibold text-muted-foreground">—</p>
          <p className="text-xs leading-[18px] text-muted-foreground">Chưa có giao dịch: số liệu có khi bật thanh toán.</p>
        </div>
      </div>

      <section aria-labelledby="commission-overrides" className={CARD}>
        <div className="flex flex-col gap-1">
          <h2 id="commission-overrides" className={CARD_TITLE}>
            Mức riêng theo nhà xe
          </h2>
          <p className="text-sm leading-5 text-muted-foreground">Cấu hình riêng theo kênh bán và ngày hiệu lực. Mức quầy phải thấp hơn online; chưa cấu hình quầy dùng 0%.</p>
        </div>
        {data.overrides.length === 0 ? (
          <ListStatePanel
            compact
            icon={<Percent className="size-6 text-vxn-fg-3" />}
            title="Chưa có mức riêng"
            description="Mọi nhà xe đang dùng hoa hồng mặc định."
          />
        ) : (
          <>
            <div className="relative overflow-x-auto">
              <table className={`${TABLE} min-w-[920px]`}>
                <colgroup>
                  {["", "w-[8%]", "w-[13%]", "w-[13%]", "w-[14%]", "w-[24%]", "w-[88px]"].map((width, index) => (
                    <col key={index} className={width} />
                  ))}
                </colgroup>
                <thead>
                  <tr className={TABLE_HEAD_ROW}>
                    {["Nhà xe", "Tỷ lệ", "Hiệu lực từ", "Đến", "Trạng thái", "Lý do", ""].map((heading, index) => (
                      <th key={index} scope="col" className={`${TABLE_HEAD_CELL} ${index === 1 ? "text-right" : ""}`}>
                        {heading || <span className="sr-only">Thao tác</span>}
                      </th>
                    ))}
                  </tr>
                </thead>
                <tbody>
                  {data.overrides.map((rule) => {
                    const state = STATE[rule.state];
                    const open = rule.state === "ACTIVE" || rule.state === "SCHEDULED";
                    return (
                      <tr key={rule.id} className="h-[68px] border-b">
                        <td className={TABLE_CELL}>
                          <span className="flex min-w-0 flex-col">
                            <span className="truncate font-semibold text-vxn-ink">{rule.operatorName}</span>
                            <span className="truncate text-xs leading-[18px] text-muted-foreground">{rule.operatorSlug}</span>
                            <span className="text-xs text-muted-foreground">{rule.channel === "COUNTER" ? "Bán tại quầy" : "Bán online"}</span>
                          </span>
                        </td>
                        <td className={`${TABLE_CELL} text-right font-semibold`}>{formatRate(rule.rateBps)}</td>
                        <td className={TABLE_CELL}>{formatDate(rule.effectiveFrom)}</td>
                        <td className={TABLE_CELL}>{rule.effectiveTo ? toVnDateInput(rule.effectiveTo, true).split("-").reverse().join("/") : "Không thời hạn"}</td>
                        <td className={TABLE_CELL}>
                          <Badge tone={state.tone}>{state.label}</Badge>
                        </td>
                        <td className={TABLE_CELL}>
                          <span className="line-clamp-2">{rule.cancelReason ?? rule.reason}</span>
                        </td>
                        <td className={TABLE_CELL}>
                          {open && (
                            <div className="flex items-center gap-1">
                              <Button variant="ghost" className="size-8 p-0" aria-label={`Sửa mức của ${rule.operatorName}`} onClick={() => setEditing(rule)}>
                                <Pencil className="size-4" />
                              </Button>
                              <Button
                                variant="ghost"
                                className="size-8 p-0"
                                aria-label={`Ngừng mức của ${rule.operatorName}`}
                                onClick={() =>
                                  setAction({
                                    title: rule.state === "SCHEDULED" ? "Hủy mức hoa hồng riêng" : "Ngừng mức hoa hồng riêng",
                                    subtitle: `${rule.operatorName} · ${formatRate(rule.rateBps)}`,
                                    warning:
                                      rule.state === "SCHEDULED"
                                        ? "Mức này sẽ không bao giờ áp dụng."
                                        : "Mức kết thúc ngay bây giờ; giao dịch từ lúc này tính theo mức mặc định. Giao dịch đã ghi không đổi.",
                                    withReason: true,
                                    confirmLabel: rule.state === "SCHEDULED" ? "Hủy mức" : "Ngừng ngay",
                                    destructive: true,
                                    run: (reason) => cancelCommissionRule(rule.id, reason),
                                    done: `Đã ngừng mức hoa hồng riêng của ${rule.operatorName}.`
                                  })
                                }
                              >
                                <Ban className="size-4" />
                              </Button>
                            </div>
                          )}
                        </td>
                      </tr>
                    );
                  })}
                </tbody>
              </table>
            </div>
            <p className="text-sm leading-5 text-muted-foreground">Đã tải {data.overrides.length} mức riêng</p>
          </>
        )}
      </section>
      <div className="flex items-center gap-4 rounded-lg bg-accent px-5 py-4">
        <Calculator className="size-5 shrink-0 text-accent-foreground" />
        <p className="min-w-0 flex-1 text-sm leading-5 text-accent-foreground">
          Hoa hồng tính trên giá vé bán thành công, trước phần giảm do Vé Xe Nhanh chịu. Thay đổi tỷ lệ không áp ngược cho giao dịch đã ghi.
        </p>
      </div>
      <CounterCommissionPanel onNotice={onNotice} />
      <CommissionDialog
        open={creating || editing !== null}
        rule={editing}
        onClose={() => {
          setEditing(null);
          onCloseCreate();
        }}
        onDone={(text) => {
          onNotice(text);
          refresh();
        }}
        onStale={refresh}
      />
      <AccountActionDialog
        action={action}
        onClose={() => setAction(null)}
        onDone={(text) => {
          onNotice(text);
          refresh();
        }}
        onStale={refresh}
      />
    </>
  );
}

/** Hộp thoại thêm / sửa mức riêng: nhà xe, tỷ lệ, ngày bắt đầu / kết thúc, lý do, mã TOTP. */
function CommissionDialog({
  open,
  rule,
  onClose,
  onDone,
  onStale
}: {
  open: boolean;
  rule: CommissionRule | null;
  onClose: () => void;
  onDone: (text: string) => void;
  onStale: () => void;
}) {
  const [pending, setPending] = useState(false);
  return (
    <Dialog open={open} onOpenChange={(next) => !next && !pending && onClose()}>
      {open && <CommissionForm key={rule?.id ?? "new"} rule={rule} onClose={onClose} onDone={onDone} onStale={onStale} onPendingChange={setPending} />}
    </Dialog>
  );
}

type FormErrors = Partial<Record<"operator" | "rate" | "from" | "to" | "reason" | "form", string>>;

function CommissionForm({
  rule,
  onClose,
  onDone,
  onStale,
  onPendingChange
}: {
  rule: CommissionRule | null;
  onClose: () => void;
  onDone: (text: string) => void;
  onStale: () => void;
  onPendingChange: (pending: boolean) => void;
}) {
  const identity = useIdentityField();
  const started = rule?.state === "ACTIVE";
  const [operator, setOperator] = useState<OperatorOption | null>(
    rule ? { id: rule.operatorId, name: rule.operatorName, slug: rule.operatorSlug } : null
  );
  const [rate, setRate] = useState(rule ? bpsToPercentInput(rule.rateBps) : "");
  const [channel, setChannel] = useState<"ONLINE" | "COUNTER">(rule?.channel ?? "ONLINE");
  const [from, setFrom] = useState(rule ? toVnDateInput(rule.effectiveFrom) : "");
  const [to, setTo] = useState(rule?.effectiveTo ? toVnDateInput(rule.effectiveTo, true) : "");
  const [reason, setReason] = useState("");
  const [errors, setErrors] = useState<FormErrors>({});
  const save = useMutation({
    mutationFn: (input: { rateBps: number; effectiveFrom: string; effectiveTo: string | null }) =>
      withReauth(identity.secret, () =>
        rule
          ? updateCommissionRule(rule.id, { ...input, reason: reason.trim() })
          : createCommissionRule({ ...input, channel, operatorId: operator!.id, reason: reason.trim() })
      ),
    onMutate: () => onPendingChange(true),
    onSettled: () => onPendingChange(false),
    onSuccess: (saved) => {
      onDone(rule ? `Đã cập nhật mức hoa hồng của ${saved.operatorName}.` : `Đã thêm mức hoa hồng ${formatRate(saved.rateBps)} cho ${saved.operatorName}.`);
      onClose();
    },
    onError: (error) => {
      const described = describePolicyError(error);
      if (described.field === "identity") {
        identity.require(described.message);
        return;
      }
      identity.sync();
      setErrors({ form: described.message });
      if (described.refresh) {
        onStale();
      }
    }
  });

  function submit() {
    const rateBps = percentToBps(rate);
    // Mức đã bắt đầu giữ nguyên mốc bắt đầu chính xác (API so khớp từng mili-giây).
    const effectiveFrom = started ? rule!.effectiveFrom : fromVnDateInput(from);
    const effectiveTo = to ? fromVnDateInput(to, true) : null;
    const next: FormErrors = {
      operator: operator ? undefined : "Chọn nhà xe.",
      rate: rateBps === null ? "Tỷ lệ từ 0 đến 100, tối đa 2 chữ số thập phân." : undefined,
      from: !effectiveFrom ? "Chọn ngày bắt đầu." : !started && new Date(effectiveFrom).getTime() <= Date.now() ? "Ngày bắt đầu phải từ ngày mai trở đi." : undefined,
      to: effectiveTo && effectiveFrom && effectiveTo <= effectiveFrom ? "Ngày kết thúc phải từ ngày bắt đầu trở đi." : undefined,
      reason: lockReasonError(reason) ?? undefined
    };
    setErrors(next);
    const identityOk = identity.check();
    if (Object.values(next).some(Boolean) || !identityOk) {
      return;
    }
    save.mutate({ rateBps: rateBps!, effectiveFrom: effectiveFrom!, effectiveTo });
  }

  const busy = save.isPending;
  return (
    <DialogContent className="sm:max-w-[600px]">
      <DialogHeader>
        <DialogTitle>{rule ? "Sửa mức hoa hồng riêng" : "Thêm mức riêng cho nhà xe"}</DialogTitle>
        <DialogDescription>
          {started ? "Mức này đang áp dụng: chỉ đổi được ngày kết thúc." : "Mức riêng thay mức mặc định trong khoảng thời gian đã chọn."}
        </DialogDescription>
      </DialogHeader>
      <form noValidate onSubmit={(event) => { event.preventDefault(); submit(); }} className="flex flex-col gap-4">
        <FormField label="Nhà xe *" error={errors.operator}>
          {(control) =>
            rule ? (
              <Input {...control} readOnly value={`${rule.operatorName} · ${rule.operatorSlug}`} />
            ) : (
              <OperatorPicker id={control.id} value={operator} onChange={setOperator} disabled={busy} invalid={Boolean(errors.operator)} />
            )
          }
        </FormField>
        <FormField label="Kênh bán *" helper="Quầy chưa có mức riêng dùng 0%; mức cấu hình phải thấp hơn online.">
          {(control) => <select {...control} className="h-10 rounded-md border bg-background px-3 text-sm" value={channel} disabled={busy || Boolean(rule)} onChange={(event) => setChannel(event.target.value as "ONLINE" | "COUNTER")}><option value="ONLINE">Bán online</option><option value="COUNTER">Bán tại quầy</option></select>}
        </FormField>
        <div className="grid gap-4 sm:grid-cols-3">
          <FormField label="Tỷ lệ (%) *" error={errors.rate}>
            {(control) => <Input {...control} inputMode="decimal" placeholder="4,5" value={rate} disabled={busy || started} onChange={(event) => setRate(event.target.value)} />}
          </FormField>
          <FormField label="Hiệu lực từ *" error={errors.from}>
            {(control) => <Input {...control} type="date" value={from} disabled={busy || started} onChange={(event) => setFrom(event.target.value)} />}
          </FormField>
          <FormField label="Đến hết ngày" helper="Trống = không thời hạn" error={errors.to}>
            {(control) => <Input {...control} type="date" value={to} disabled={busy} onChange={(event) => setTo(event.target.value)} />}
          </FormField>
        </div>
        <FormField label="Lý do *" helper="Lý do được lưu vào nhật ký audit." error={errors.reason}>
          {(control) => (
            <Textarea {...control} rows={2} maxLength={LOCK_REASON_MAX} value={reason} disabled={busy} onChange={(event) => setReason(event.target.value)} />
          )}
        </FormField>
        {identity.needed && <IdentityField totp value={identity.value} error={identity.error} disabled={busy} onChange={identity.change} />}
        {errors.form && (
          <div role="alert" className="flex items-center gap-3 rounded-lg bg-error-50 px-4 py-3 text-sm leading-5 text-error-600">
            <CircleAlert className="size-5 shrink-0" />
            {errors.form}
          </div>
        )}
        <DialogFooter>
          <Button type="button" variant="outline" className={`${BUTTON} bg-card`} disabled={busy} onClick={onClose}>
            Hủy
          </Button>
          <Button type="submit" className={BUTTON} disabled={busy}>
            {busy ? <LoaderCircle className="size-[18px] animate-spin" /> : <Check className="size-[18px]" />}
            {rule ? "Lưu thay đổi" : "Thêm mức riêng"}
          </Button>
        </DialogFooter>
      </form>
    </DialogContent>
  );
}
