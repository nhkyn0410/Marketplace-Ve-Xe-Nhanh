"use client";

import { useMutation, useQueryClient } from "@tanstack/react-query";
import type { TripDeparture } from "@vexenhanh/types";
import { useCan } from "@vexenhanh/ui/components/auth/auth-context";
import { Button } from "@vexenhanh/ui/components/button";
import { Dialog, DialogContent, DialogDescription, DialogFooter, DialogHeader, DialogTitle } from "@vexenhanh/ui/components/dialog";
import { Textarea } from "@vexenhanh/ui/components/textarea";
import { Bus, LoaderCircle } from "lucide-react";
import { useState } from "react";

import { ApiError, apiRequest } from "../../lib/auth/api-client";
import type { Trip } from "../../lib/trip/trip-api";

/** Cho điều phối xác nhận xe thực sự khởi hành để đóng bán vé tại quầy. */
export function TripDeparturePanel({ trip }: { trip: Trip }) {
  const can = useCan();
  const queryClient = useQueryClient();
  const [open, setOpen] = useState(false);
  const [note, setNote] = useState("");
  const mutation = useMutation({
    mutationFn: () => apiRequest<TripDeparture>(`/operator/trips/${trip.id}/departure`, { method: "POST", body: { note: note.trim() || null } }),
    onSuccess: () => {
      setOpen(false);
      void queryClient.invalidateQueries({ queryKey: ["trip", trip.id] });
      void queryClient.invalidateQueries({ queryKey: ["trips"] });
      void queryClient.invalidateQueries({ queryKey: ["counter-trips"] });
    },
    onError: () => void queryClient.invalidateQueries({ queryKey: ["trip", trip.id] }),
  });
  if (!can("trip:dispatch") || trip.departedAt || !["OPEN_FOR_SALE", "LOCKED", "SOLD_OUT", "BOARDING"].includes(trip.status)) return null;
  const error = mutation.error instanceof ApiError ? mutation.error.message : "Chưa xác nhận được khởi hành. Kiểm tra kết nối rồi thử lại.";
  return (
    <section className="flex flex-col gap-3 rounded-xl border bg-card p-6" aria-label="Khởi hành thực tế">
      <h2 className="text-base font-semibold">Khởi hành thực tế</h2>
      <p className="text-sm text-muted-foreground">Quầy còn được bán đến khi tài xế hoặc điều phối xác nhận xe đã khởi hành, kể cả chuyến trễ giờ.</p>
      <Button variant="outline" onClick={() => { mutation.reset(); setOpen(true); }}><Bus className="size-4" />Xác nhận xe đã khởi hành</Button>
      <Dialog open={open} onOpenChange={(value) => !mutation.isPending && setOpen(value)}>
        <DialogContent>
          <DialogHeader><DialogTitle>Xác nhận xe đã khởi hành?</DialogTitle><DialogDescription>{trip.routeName} — thao tác này ghi giờ khởi hành thực tế và dừng bán vé tại quầy. Chỉ xác nhận khi xe đã xuất phát.</DialogDescription></DialogHeader>
          <label className="flex flex-col gap-2 text-sm">Ghi chú (không bắt buộc)<Textarea value={note} maxLength={500} disabled={mutation.isPending} onChange={(event) => setNote(event.target.value)} /></label>
          {mutation.isError && <p role="alert" className="text-sm text-error-600">{error}</p>}
          <DialogFooter><Button variant="outline" disabled={mutation.isPending} onClick={() => setOpen(false)}>Chưa khởi hành</Button><Button disabled={mutation.isPending} onClick={() => mutation.mutate()}>{mutation.isPending && <LoaderCircle className="size-4 animate-spin" />}Xe đã khởi hành</Button></DialogFooter>
        </DialogContent>
      </Dialog>
    </section>
  );
}
