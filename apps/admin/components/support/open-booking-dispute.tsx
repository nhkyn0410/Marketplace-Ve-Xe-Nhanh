"use client";

import { useMutation } from "@tanstack/react-query";
import { Button } from "@vexenhanh/ui/components/button";
import { Dialog, DialogContent, DialogDescription, DialogFooter, DialogHeader, DialogTitle } from "@vexenhanh/ui/components/dialog";
import { FormField } from "@vexenhanh/ui/components/form-field";
import { Input } from "@vexenhanh/ui/components/input";
import { Textarea } from "@vexenhanh/ui/components/textarea";
import { DirectDisputeInputSchema } from "@vexenhanh/types";
import { Flag, LoaderCircle } from "lucide-react";
import { useRouter } from "next/navigation";
import { useState } from "react";
import { openBookingDispute } from "../../lib/support/support-api";
import { describeCaseError } from "../../lib/support/support-format";

/** Mở tranh chấp trực tiếp từ đơn hiển thị trên thanh toán Admin. */
export function OpenBookingDispute({ bookingId, bookingCode }: { bookingId: string; bookingCode: string }) {
  const [open, setOpen] = useState(false);
  const [title, setTitle] = useState("");
  const [reason, setReason] = useState("");
  const [customerRequest, setCustomerRequest] = useState("");
  const [validation, setValidation] = useState<string | null>(null);
  const router = useRouter();
  const create = useMutation({ mutationFn: openBookingDispute, onSuccess: (dispute) => router.push(`/disputes/cases/${dispute.disputeId}`) });
  return <>
    <Button variant="outline" className="mt-4 w-full" onClick={() => { setValidation(null); create.reset(); setOpen(true); }}><Flag className="size-4" />Mở tranh chấp từ đơn</Button>
    <Dialog open={open} onOpenChange={(value) => { if (!create.isPending) setOpen(value); }}>
      <DialogContent><DialogHeader><DialogTitle>Mở tranh chấp · {bookingCode}</DialogTitle><DialogDescription>Vé Xe Nhanh xem xét vụ việc và thông báo cho khách, nhà xe.</DialogDescription></DialogHeader>
        <form onSubmit={(event) => {
          event.preventDefault();
          const result = DirectDisputeInputSchema.safeParse({ bookingId, title, reason, customerRequest: customerRequest.trim() || null });
          if (!result.success) { setValidation(result.error.issues[0]?.message ?? "Kiểm tra thông tin."); return; }
          setValidation(null); create.mutate(result.data);
        }} className="flex flex-col gap-4">
          <FormField label="Tiêu đề">{(control) => <Input {...control} value={title} maxLength={200} onChange={(event) => setTitle(event.target.value)} required />}</FormField>
          <FormField label="Yêu cầu của khách">{(control) => <Textarea {...control} value={customerRequest} maxLength={1000} onChange={(event) => setCustomerRequest(event.target.value)} />}</FormField>
          <FormField label="Lý do mở tranh chấp">{(control) => <Textarea {...control} value={reason} maxLength={500} onChange={(event) => setReason(event.target.value)} required />}</FormField>
          {(validation || create.error) && <p role="alert" className="text-sm text-error-600">{validation ?? describeCaseError(create.error).message}</p>}
          <DialogFooter><Button variant="outline" type="button" disabled={create.isPending} onClick={() => setOpen(false)}>Hủy</Button><Button type="submit" disabled={create.isPending}>{create.isPending && <LoaderCircle className="size-4 animate-spin" />}Mở tranh chấp</Button></DialogFooter>
        </form>
      </DialogContent>
    </Dialog>
  </>;
}
