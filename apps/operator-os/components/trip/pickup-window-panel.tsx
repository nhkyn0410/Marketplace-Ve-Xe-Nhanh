"use client";

import { useMutation, useQueryClient } from "@tanstack/react-query";
import { Button } from "@vexenhanh/ui/components/button";
import { Input } from "@vexenhanh/ui/components/input";
import { ApiError } from "@vexenhanh/ui/lib/auth/api-client";
import { useState } from "react";
import { apiRequest } from "../../lib/auth/api-client";
import type { Trip, TripStop } from "../../lib/trip/trip-api";

/** Cửa sổ đón riêng từng điểm của chuyến theo giờ Việt Nam. */
export function PickupWindowPanel({ trip }: { trip: Trip }) {
  return <section aria-label="Cửa sổ đón theo điểm" className="flex flex-col gap-5 rounded-xl border bg-card p-6">
    <div><h2 className="text-base font-semibold">Cửa sổ đón theo điểm</h2><p className="mt-1 text-xs text-muted-foreground">Giờ Việt Nam. Chỉ ghi vắng mặt sau khi kết thúc cửa sổ tại điểm đón của khách.</p></div>
    {trip.stops.filter((stop) => stop.allowPickup).map((stop) => <WindowForm key={`${stop.sequence}:${stop.pickupWindowStart}:${stop.pickupWindowEnd}`} trip={trip} stop={stop} />)}
  </section>;
}

function WindowForm({ trip, stop }: { trip: Trip; stop: TripStop }) {
  const client = useQueryClient();
  const [start, setStart] = useState(localTime(stop.pickupWindowStart));
  const [end, setEnd] = useState(localTime(stop.pickupWindowEnd));
  const mutation = useMutation({ mutationFn: () => apiRequest<Trip>(`/operator/trips/${trip.id}/stops/${stop.sequence}/pickup-window`, { method: "PUT", body: { start: start ? `${start}:00+07:00` : null, end: end ? `${end}:00+07:00` : null } }), onSuccess: (result) => client.setQueryData(["trip", trip.id], result) });
  const valid = (!start && !end) || (Boolean(start && end) && start <= end);
  const disabled = trip.status === "COMPLETED" || trip.status === "CANCELLED" || mutation.isPending;
  return <form className="flex flex-col gap-2 rounded-lg border p-3" onSubmit={(event) => { event.preventDefault(); mutation.mutate(); }}>
    <p className="text-sm font-medium">{stop.sequence}. {stop.name}</p>
    <div className="flex flex-wrap items-end gap-2"><label className="flex flex-1 flex-col gap-1 text-xs">Từ<Input type="datetime-local" aria-label={`Bắt đầu đón tại ${stop.name}`} value={start} disabled={disabled} onChange={(event) => setStart(event.target.value)} /></label><label className="flex flex-1 flex-col gap-1 text-xs">Đến<Input type="datetime-local" aria-label={`Kết thúc đón tại ${stop.name}`} value={end} disabled={disabled} onChange={(event) => setEnd(event.target.value)} /></label><Button type="submit" variant="outline" disabled={disabled || !valid}>Lưu</Button></div>
    {!valid && <p role="alert" className="text-xs text-error-600">Nhập đủ hai mốc; kết thúc phải sau hoặc bằng bắt đầu.</p>}
    {mutation.isError && <p role="alert" className="text-xs text-error-600">{mutation.error instanceof ApiError ? mutation.error.message : "Chưa lưu được cửa sổ đón. Vui lòng thử lại."}</p>}
    {!start && !end && <p className="text-xs text-muted-foreground">Chưa đặt cửa sổ riêng.</p>}
  </form>;
}
function localTime(iso: string | null): string { return iso ? new Date(Date.parse(iso) + 7 * 3_600_000).toISOString().slice(0, 16) : ""; }
