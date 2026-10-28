"use client";

import { useMutation, useQuery } from "@tanstack/react-query";
import { SalesOfficeInputSchema } from "@vexenhanh/types";
import { Button } from "@vexenhanh/ui/components/button";
import { Dialog, DialogContent, DialogDescription, DialogFooter, DialogHeader, DialogTitle } from "@vexenhanh/ui/components/dialog";
import { Input } from "@vexenhanh/ui/components/input";
import { Textarea } from "@vexenhanh/ui/components/textarea";
import { CircleAlert, LoaderCircle } from "lucide-react";
import Link from "next/link";
import { useState, type FormEvent } from "react";

import { listAllEmployees } from "../../lib/employee/employee-api";
import {
  createSalesOffice,
  getSalesOffice,
  listOfficeAssignments,
  updateOfficeAssignments,
  updateSalesOffice,
  type SalesOffice
} from "../../lib/office/office-api";
import { describeOfficeError, officeAssignmentOptions } from "../../lib/office/office-format";
import { FormField } from "../form-field";
import { BUTTON } from "../list-parts";

export type OfficeDialog = { kind: "create" } | { kind: "edit" | "assign"; office: SalesOffice };
type DialogCallbacks = { onClose: () => void; onSaved: (message: string) => void; onPendingChange: (pending: boolean) => void };

/** Hộp thoại thêm, sửa và phân công tài khoản tại văn phòng bán vé. */
export function OfficeDialogs({ dialog, onClose, onSaved }: { dialog: OfficeDialog | null; onClose: () => void; onSaved: (message: string) => void }) {
  const [pending, setPending] = useState(false);
  const props = { onClose, onSaved, onPendingChange: setPending };
  return (
    <Dialog open={dialog !== null} onOpenChange={(open) => !open && !pending && onClose()}>
      {dialog?.kind === "create" && <OfficeForm key="create" {...props} />}
      {dialog?.kind === "edit" && <OfficeForm key={`${dialog.office.id}-${dialog.office.version}`} office={dialog.office} {...props} />}
      {dialog?.kind === "assign" && <AssignmentLoader key={dialog.office.id} office={dialog.office} {...props} />}
    </Dialog>
  );
}

function FormError({ message }: { message: string | null }) {
  return message ? <p role="alert" className="flex items-start gap-2 rounded-lg bg-error-50 px-3 py-2.5 text-sm leading-5 text-error-600"><CircleAlert className="mt-0.5 size-4 shrink-0" />{message}</p> : null;
}

function OfficeForm({ office, onClose, onSaved, onPendingChange }: DialogCallbacks & { office?: SalesOffice }) {
  const [code, setCode] = useState(office?.code ?? "");
  const [name, setName] = useState(office?.name ?? "");
  const [address, setAddress] = useState(office?.address ?? "");
  const [active, setActive] = useState(office?.active ?? true);
  const [errors, setErrors] = useState<Record<string, string>>({});
  const [formError, setFormError] = useState<string | null>(null);
  const [stale, setStale] = useState(false);
  const mutation = useMutation({
    mutationFn: async () => {
      const input = SalesOfficeInputSchema.parse({ code, name, address, active });
      return office ? updateSalesOffice(office.id, { ...input, version: office.version }) : createSalesOffice(input);
    },
    onMutate: () => onPendingChange(true),
    onSettled: () => onPendingChange(false),
    onSuccess: (saved) => {
      onSaved(office ? `Đã cập nhật văn phòng ${saved.name}.` : `Đã tạo văn phòng ${saved.name}.`);
      onClose();
    },
    onError: (error) => {
      const result = describeOfficeError(error);
      setFormError(result.message);
      setStale(result.stale);
    }
  });

  function submit(event: FormEvent) {
    event.preventDefault();
    setFormError(null);
    const parsed = SalesOfficeInputSchema.safeParse({ code, name, address, active });
    const next: Record<string, string> = {};
    if (!parsed.success) {
      for (const issue of parsed.error.issues) {
        const field = String(issue.path[0]);
        next[field] = field === "name" ? "Nhập tên văn phòng (tối đa 100 ký tự)." : field === "address" ? "Nhập địa chỉ (tối đa 255 ký tự)." : issue.message;
      }
    }
    setErrors(next);
    if (parsed.success && !stale) mutation.mutate();
  }

  return (
    <DialogContent className="sm:max-w-[560px]">
      <DialogHeader>
        <DialogTitle>{office ? "Chỉnh sửa văn phòng" : "Thêm văn phòng bán vé"}</DialogTitle>
        <DialogDescription>Địa điểm chịu trách nhiệm bán vé của nhà xe.</DialogDescription>
      </DialogHeader>
      <form noValidate onSubmit={submit} className="flex flex-col gap-4">
        <FormField label="Mã văn phòng *" helper="2–30 chữ, số, gạch ngang hoặc gạch dưới; mã viết hoa." error={errors.code}>
          {(control) => <Input {...control} value={code} maxLength={30} placeholder="VD: VP-MIEN-DONG" disabled={mutation.isPending || stale} onChange={(event) => setCode(event.target.value)} />}
        </FormField>
        <FormField label="Tên văn phòng *" error={errors.name}>
          {(control) => <Input {...control} value={name} maxLength={100} disabled={mutation.isPending || stale} onChange={(event) => setName(event.target.value)} />}
        </FormField>
        <FormField label="Địa chỉ *" error={errors.address}>
          {(control) => <Textarea {...control} value={address} rows={3} maxLength={255} disabled={mutation.isPending || stale} onChange={(event) => setAddress(event.target.value)} />}
        </FormField>
        <label className="flex items-start gap-3 rounded-lg border p-3 text-sm">
          <input type="checkbox" className="mt-0.5 size-4 shrink-0 accent-primary" checked={active} disabled={mutation.isPending || stale} onChange={(event) => setActive(event.target.checked)} />
          <span><span className="block font-medium">Văn phòng hoạt động</span><span className="mt-1 block text-xs text-muted-foreground">Ngừng hoạt động sẽ ẩn văn phòng khỏi cổng bán vé; thông tin và phân công vẫn được giữ lại.</span></span>
        </label>
        <FormError message={formError} />
        <DialogFooter>
          <Button type="button" variant="outline" className={BUTTON} disabled={mutation.isPending} onClick={onClose}>{stale ? "Đóng và tải lại" : "Hủy"}</Button>
          <Button type="submit" className={BUTTON} disabled={mutation.isPending || stale}>{mutation.isPending && <LoaderCircle className="size-4 animate-spin" />}{office ? "Lưu thay đổi" : "Tạo văn phòng"}</Button>
        </DialogFooter>
      </form>
    </DialogContent>
  );
}

function AssignmentLoader({ office, ...props }: DialogCallbacks & { office: SalesOffice }) {
  const query = useQuery({
    queryKey: ["office-assignments", office.id],
    queryFn: async () => {
      const [current, assignments, employees] = await Promise.all([getSalesOffice(office.id), listOfficeAssignments(office.id), listAllEmployees()]);
      return { office: current, options: officeAssignmentOptions(employees, assignments) };
    },
    staleTime: 0,
    gcTime: 0,
    refetchOnWindowFocus: false
  });

  return (
    <DialogContent className="sm:max-w-[560px]">
      <DialogHeader>
        <DialogTitle>Phân công văn phòng</DialogTitle>
        <DialogDescription>{office.name} · Chủ nhà xe luôn có quyền quản lý mọi văn phòng.</DialogDescription>
      </DialogHeader>
      {query.isPending ? <p role="status" className="flex items-center gap-2 py-8 text-sm text-muted-foreground"><LoaderCircle className="size-4 animate-spin" />Đang tải nhân viên bán vé…</p> : query.isError ? (
        <div className="flex flex-col gap-4"><FormError message="Chưa tải được phân công. Kiểm tra kết nối và quyền truy cập rồi thử lại." /><Button variant="outline" onClick={() => void query.refetch()}>Thử lại</Button></div>
      ) : <AssignmentForm key={query.data.office.version} {...query.data} {...props} />}
    </DialogContent>
  );
}

function AssignmentForm({ office, options, onClose, onSaved, onPendingChange }: DialogCallbacks & { office: SalesOffice; options: ReturnType<typeof officeAssignmentOptions> }) {
  const [selected, setSelected] = useState(() => options.filter((item) => item.assigned).map((item) => item.employeeId));
  const [formError, setFormError] = useState<string | null>(null);
  const [stale, setStale] = useState(false);
  const unavailableSelected = options.some((item) => item.status !== "ACTIVE" && selected.includes(item.employeeId));
  const mutation = useMutation({
    mutationFn: () => updateOfficeAssignments(office.id, selected, office.version),
    onMutate: () => onPendingChange(true),
    onSettled: () => onPendingChange(false),
    onSuccess: () => { onSaved(`Đã cập nhật phân công tại ${office.name}.`); onClose(); },
    onError: (error) => {
      const result = describeOfficeError(error);
      setFormError(result.message);
      setStale(result.stale);
    }
  });

  return (
    <form onSubmit={(event) => { event.preventDefault(); if (!unavailableSelected && !stale) { setFormError(null); mutation.mutate(); } }} className="flex flex-col gap-4">
      <p className="text-sm leading-5 text-muted-foreground">Chỉ chọn nhân viên bán vé đang hoạt động. Một nhân viên có thể được phân công nhiều văn phòng.</p>
      {options.length === 0 ? <p className="rounded-lg bg-muted p-4 text-sm">Chưa có nhân viên bán vé đang hoạt động. <Link href="/employees" className="font-medium text-primary underline">Tạo tài khoản nhân viên bán vé</Link> trước khi phân công.</p> : (
        <fieldset disabled={mutation.isPending || stale} className="flex max-h-72 flex-col gap-2 overflow-y-auto rounded-lg border p-3">
          <legend className="sr-only">Tài khoản được làm việc tại văn phòng</legend>
          {options.map((item) => {
            const checked = selected.includes(item.employeeId);
            const unavailable = item.status !== "ACTIVE";
            return (
              <label key={item.employeeId} className="flex items-start gap-3 rounded-md p-2 hover:bg-muted">
                <input type="checkbox" className="mt-0.5 size-4 shrink-0 accent-primary" checked={checked} disabled={unavailable && !checked} onChange={(event) => setSelected((current) => event.target.checked ? [...current, item.employeeId] : current.filter((id) => id !== item.employeeId))} />
                <span className="min-w-0 break-words text-sm"><span className="font-medium">{item.username}</span>{unavailable && <span className="mt-1 block text-xs text-error-600">{item.status === "LOCKED" ? "Tài khoản bị khóa" : "Tài khoản vô hiệu hóa"} — bỏ chọn để lưu phân công.</span>}</span>
              </label>
            );
          })}
        </fieldset>
      )}
      {unavailableSelected && <p role="alert" className="text-sm text-error-600">Bỏ chọn tài khoản không còn hoạt động trước khi lưu.</p>}
      <FormError message={formError} />
      <DialogFooter>
        <Button type="button" variant="outline" className={BUTTON} disabled={mutation.isPending} onClick={onClose}>{stale ? "Đóng và tải lại" : "Hủy"}</Button>
        <Button type="submit" className={BUTTON} disabled={mutation.isPending || stale || unavailableSelected}>{mutation.isPending && <LoaderCircle className="size-4 animate-spin" />}Lưu phân công</Button>
      </DialogFooter>
    </form>
  );
}
