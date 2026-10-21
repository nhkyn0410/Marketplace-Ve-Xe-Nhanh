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
import { Ban, Check, CircleAlert, Info, LoaderCircle, RefreshCw, Scale } from "lucide-react";
import { useState } from "react";

import { cancelFareBand, createFareBand, listFareBands } from "../../lib/policy/policy-api";
import { describePolicyError, formatVnd, fromVnDateInput, parseVnd, STATE, toVnDateInput } from "../../lib/policy/policy-format";
import { formatDate, LOCK_REASON_MAX, lockReasonError } from "../../lib/user/user-format";
import { AccountActionDialog, type AccountAction } from "../user/account-dialogs";
import { CARD, CARD_TITLE } from "./cancellation-tab";

/**
 * Tab "Khung giá vé" (FR-ADM-09, OQ-17; Figma ADM-06d thẻ Khung giá vé): khung giá trần / sàn mỗi chỗ theo dịp. Nhà xe
 * được cảnh báo ở màn Bảng giá khi giá nằm ngoài khung — cảnh báo không chặn việc lưu / mở bán.
 */
export function FareBandTab({
  creating,
  onCloseCreate,
  onNotice
}: {
  creating: boolean;
  onCloseCreate: () => void;
  onNotice: (text: string) => void;
}) {
  const queryClient = useQueryClient();
  const bands = useQuery({ queryKey: ["admin-fare-bands"], queryFn: listFareBands });
  const [action, setAction] = useState<AccountAction | null>(null);
  const refresh = () => void queryClient.invalidateQueries({ queryKey: ["admin-fare-bands"] });

  let body;
  if (!bands.data) {
    body = bands.isError ? (
      <ListStatePanel
        compact
        icon={<CircleAlert className="size-6 text-warning-700" />}
        title="Không tải được khung giá"
        description="Kiểm tra kết nối mạng rồi thử lại."
        action={
          <Button className={`${BUTTON} w-36`} onClick={() => void bands.refetch()}>
            <RefreshCw className="size-[18px]" />
            Thử lại
          </Button>
        }
      />
    ) : (
      <TableSkeleton label="Đang tải khung giá" />
    );
  } else if (bands.data.length === 0) {
    body = (
      <ListStatePanel
        compact
        icon={<Scale className="size-6 text-vxn-fg-3" />}
        title="Chưa có khung giá nào đang áp dụng"
        description="Khi có khung trần / sàn, hệ thống cảnh báo nhà xe lúc lưu bảng giá. Cảnh báo không chặn việc lưu."
      />
    );
  } else {
    body = (
      <div className="relative overflow-x-auto">
        <table className={`${TABLE} min-w-[920px]`}>
          <colgroup>
            {["", "w-[13%]", "w-[13%]", "w-[19%]", "w-[13%]", "w-[22%]", "w-[56px]"].map((width, index) => (
              <col key={index} className={width} />
            ))}
          </colgroup>
          <thead>
            <tr className={TABLE_HEAD_ROW}>
              {["Dịp", "Giá sàn", "Giá trần", "Thời gian", "Trạng thái", "Cảnh báo cho nhà xe", ""].map((heading, index) => (
                <th key={index} scope="col" className={TABLE_HEAD_CELL}>
                  {heading || <span className="sr-only">Thao tác</span>}
                </th>
              ))}
            </tr>
          </thead>
          <tbody>
            {bands.data.map((band) => {
              const state = STATE[band.state];
              return (
                <tr key={band.id} className="h-[68px] border-b">
                  <td className={TABLE_CELL}>
                    <span className="flex min-w-0 flex-col">
                      <span className="truncate font-semibold text-vxn-ink">{band.name}</span>
                      <span className="truncate text-xs leading-[18px] text-muted-foreground">{band.cancelReason ?? band.reason}</span>
                    </span>
                  </td>
                  <td className={TABLE_CELL}>{band.minPrice === null ? "—" : formatVnd(band.minPrice)}</td>
                  <td className={TABLE_CELL}>{band.maxPrice === null ? "—" : formatVnd(band.maxPrice)}</td>
                  <td className={TABLE_CELL}>
                    {formatDate(band.effectiveFrom)} – {toVnDateInput(band.effectiveTo, true).split("-").reverse().join("/")}
                  </td>
                  <td className={TABLE_CELL}>
                    <Badge tone={state.tone}>{state.label}</Badge>
                  </td>
                  <td className={TABLE_CELL}>
                    <span className="line-clamp-2">{band.message}</span>
                  </td>
                  <td className={TABLE_CELL}>
                    {(band.state === "ACTIVE" || band.state === "SCHEDULED") && (
                      <Button
                        variant="ghost"
                        className="size-8 p-0"
                        aria-label={`Hủy khung giá ${band.name}`}
                        onClick={() =>
                          setAction({
                            title: "Hủy khung giá",
                            subtitle: band.name,
                            warning: "Nhà xe thôi nhận cảnh báo theo khung giá này.",
                            withReason: true,
                            confirmLabel: "Hủy khung giá",
                            destructive: true,
                            run: (reason) => cancelFareBand(band.id, reason),
                            done: `Đã hủy khung giá ${band.name}.`
                          })
                        }
                      >
                        <Ban className="size-4" />
                      </Button>
                    )}
                  </td>
                </tr>
              );
            })}
          </tbody>
        </table>
      </div>
    );
  }

  return (
    <>
      <section aria-labelledby="fare-bands" className={CARD}>
        <div className="flex flex-col gap-1">
          <h2 id="fare-bands" className={CARD_TITLE}>
            Khung giá vé
          </h2>
          <p className="text-sm leading-5 text-muted-foreground">
            Khung giá trần / sàn mỗi chỗ cho các dịp theo quy định. Áp dụng cho mọi tuyến; quy tắc giá có khung giờ chỉ xét khi giao với thời gian của khung.
          </p>
        </div>
        {body}
      </section>
      <div role="note" className="flex items-center gap-3 rounded-lg bg-accent px-5 py-4 text-sm leading-5 text-accent-foreground">
        <Info className="size-5 shrink-0" />
        Cảnh báo không chặn việc lưu bảng giá hay mở bán; mỗi lần nhà xe lưu giá ngoài khung được ghi nhật ký để kiểm tra (OQ-17).
      </div>
      <FareBandDialog
        open={creating}
        onClose={onCloseCreate}
        onDone={(text) => {
          onNotice(text);
          refresh();
        }}
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

function FareBandDialog({ open, onClose, onDone }: { open: boolean; onClose: () => void; onDone: (text: string) => void }) {
  const [pending, setPending] = useState(false);
  return (
    <Dialog open={open} onOpenChange={(next) => !next && !pending && onClose()}>
      {open && <FareBandForm onClose={onClose} onDone={onDone} onPendingChange={setPending} />}
    </Dialog>
  );
}

type FormErrors = Partial<Record<"name" | "price" | "from" | "to" | "message" | "reason" | "form", string>>;

function FareBandForm({
  onClose,
  onDone,
  onPendingChange
}: {
  onClose: () => void;
  onDone: (text: string) => void;
  onPendingChange: (pending: boolean) => void;
}) {
  const identity = useIdentityField();
  const [name, setName] = useState("");
  const [minPrice, setMinPrice] = useState("");
  const [maxPrice, setMaxPrice] = useState("");
  const [from, setFrom] = useState("");
  const [to, setTo] = useState("");
  const [message, setMessage] = useState("");
  const [reason, setReason] = useState("");
  const [errors, setErrors] = useState<FormErrors>({});
  const save = useMutation({
    mutationFn: (input: Parameters<typeof createFareBand>[0]) => withReauth(identity.secret, () => createFareBand(input)),
    onMutate: () => onPendingChange(true),
    onSettled: () => onPendingChange(false),
    onSuccess: (band) => {
      onDone(`Đã thiết lập khung giá ${band.name}.`);
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
    }
  });

  function submit() {
    const min = parseVnd(minPrice);
    const max = parseVnd(maxPrice);
    const effectiveFrom = fromVnDateInput(from);
    const effectiveTo = fromVnDateInput(to, true);
    const next: FormErrors = {
      name: name.trim().length < 3 ? "Nhập tên dịp (ít nhất 3 ký tự)." : undefined,
      price:
        Number.isNaN(min) || Number.isNaN(max)
          ? "Giá là số nguyên đồng."
          : min === null && max === null
            ? "Nhập giá sàn hoặc giá trần."
            : min !== null && max !== null && min > max
              ? "Giá trần phải lớn hơn hoặc bằng giá sàn."
              : (min ?? 0) > 100_000_000 || (max ?? 0) > 100_000_000
                ? "Giá tối đa 100.000.000 đ."
                : undefined,
      from: effectiveFrom ? undefined : "Chọn ngày bắt đầu.",
      to: !effectiveTo ? "Chọn ngày kết thúc." : effectiveFrom && effectiveTo <= effectiveFrom ? "Ngày kết thúc phải từ ngày bắt đầu trở đi." : undefined,
      message: message.trim().length < 3 ? "Nhập nội dung cảnh báo (ít nhất 3 ký tự)." : undefined,
      reason: lockReasonError(reason) ?? undefined
    };
    setErrors(next);
    const identityOk = identity.check();
    if (Object.values(next).some(Boolean) || !identityOk) {
      return;
    }
    save.mutate({
      name: name.trim(),
      minPrice: min,
      maxPrice: max,
      effectiveFrom: effectiveFrom!,
      effectiveTo: effectiveTo!,
      message: message.trim(),
      reason: reason.trim()
    });
  }

  const busy = save.isPending;
  return (
    <DialogContent className="sm:max-w-[600px]">
      <DialogHeader>
        <DialogTitle>Thiết lập khung giá</DialogTitle>
        <DialogDescription>Giá mỗi chỗ; nhà xe được cảnh báo khi giá nằm ngoài khung trong thời gian này.</DialogDescription>
      </DialogHeader>
      <form noValidate onSubmit={(event) => { event.preventDefault(); submit(); }} className="flex flex-col gap-4">
        <FormField label="Tên dịp *" error={errors.name}>
          {(control) => <Input {...control} maxLength={100} placeholder="Tết Nguyên đán 2027" value={name} disabled={busy} onChange={(event) => setName(event.target.value)} />}
        </FormField>
        <div className="grid gap-4 sm:grid-cols-2">
          <FormField label="Giá sàn (đ)" error={errors.price}>
            {(control) => <Input {...control} inputMode="numeric" value={minPrice} disabled={busy} onChange={(event) => setMinPrice(event.target.value)} />}
          </FormField>
          <FormField label="Giá trần (đ)" helper="Nhập ít nhất một trong hai.">
            {(control) => <Input {...control} inputMode="numeric" value={maxPrice} disabled={busy} onChange={(event) => setMaxPrice(event.target.value)} />}
          </FormField>
          <FormField label="Từ ngày *" error={errors.from}>
            {(control) => <Input {...control} type="date" value={from} disabled={busy} onChange={(event) => setFrom(event.target.value)} />}
          </FormField>
          <FormField label="Đến hết ngày *" error={errors.to}>
            {(control) => <Input {...control} type="date" value={to} disabled={busy} onChange={(event) => setTo(event.target.value)} />}
          </FormField>
        </div>
        <FormField label="Nội dung cảnh báo cho nhà xe *" error={errors.message}>
          {(control) => <Textarea {...control} rows={2} maxLength={500} value={message} disabled={busy} onChange={(event) => setMessage(event.target.value)} />}
        </FormField>
        <FormField label="Lý do *" helper="Căn cứ / văn bản; lưu vào nhật ký audit." error={errors.reason}>
          {(control) => <Textarea {...control} rows={2} maxLength={LOCK_REASON_MAX} value={reason} disabled={busy} onChange={(event) => setReason(event.target.value)} />}
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
            Lưu khung giá
          </Button>
        </DialogFooter>
      </form>
    </DialogContent>
  );
}
