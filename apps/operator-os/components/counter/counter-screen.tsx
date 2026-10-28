"use client";

import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { CounterBookingInputSchema } from "@vexenhanh/types";
import { useCan } from "@vexenhanh/ui/components/auth/auth-context";
import { Badge } from "@vexenhanh/ui/components/badge";
import { Button } from "@vexenhanh/ui/components/button";
import { Input } from "@vexenhanh/ui/components/input";
import { Textarea } from "@vexenhanh/ui/components/textarea";
import { Armchair, ArrowLeft, Building2, Bus, CircleAlert, LoaderCircle, RefreshCw, Ticket } from "lucide-react";
import { useState, type FormEvent, type ReactNode } from "react";

import { createCounterBooking, createCounterHold, listCounterBookings, listCounterTrips, releaseCounterHold, type CounterHold, type CounterTrip } from "../../lib/counter/counter-api";
import { counterBookingLabel, counterError, counterMoney, counterToday, selectedCounterTotal } from "../../lib/counter/counter-format";
import { listSalesOffices } from "../../lib/office/office-api";
import { formatDateTime } from "../../lib/route/route-format";
import { formatTime } from "../../lib/trip/trip-format";
import { FormField } from "../form-field";
import { ApiError } from "../../lib/auth/api-client";
import { CounterBookingPanel } from "./counter-booking-panel";
import { CounterReportPanel } from "./counter-report";

const CARD = "rounded-xl border bg-card p-5 sm:p-6";
const SELECT = "h-10 w-full rounded-lg border border-input bg-card px-3 text-sm outline-none focus-visible:ring-2 focus-visible:ring-ring disabled:opacity-60";

/** Bàn bán vé quầy với văn phòng, kho ghế chung và lịch sử đơn có thể mở lại sau timeout. */
export function CounterScreen() {
  const can = useCan();
  const queryClient = useQueryClient();
  const [officeId, setOfficeId] = useState("");
  const [date, setDate] = useState(() => counterToday());
  const [tripId, setTripId] = useState<string | null>(null);
  const [held, setHeld] = useState<{ hold: CounterHold; trip: CounterTrip } | null>(null);
  const [bookingId, setBookingId] = useState<string | null>(null);
  const offices = useQuery({ queryKey: ["sales-offices"], queryFn: listSalesOffices, enabled: can("office:read") });
  const activeOffices = offices.data?.filter((office) => office.active) ?? [];
  const office = activeOffices.find((item) => item.id === officeId) ?? activeOffices[0];
  const activeOfficeId = office?.id ?? "";
  const trips = useQuery({ queryKey: ["counter-trips", activeOfficeId, date], queryFn: () => listCounterTrips(activeOfficeId, date), enabled: Boolean(activeOfficeId) && can("counter:sell"), refetchInterval: 15_000 });
  const bookings = useQuery({ queryKey: ["counter-bookings", activeOfficeId], queryFn: () => listCounterBookings(activeOfficeId), enabled: Boolean(activeOfficeId) && can("counter:read"), refetchInterval: 30_000 });
  const trip = trips.data?.find((item) => item.tripId === tripId);

  function resetSale() {
    setHeld(null);
    setBookingId(null);
    setTripId(null);
    void queryClient.invalidateQueries({ queryKey: ["counter-trips"] });
    void queryClient.invalidateQueries({ queryKey: ["counter-bookings"] });
  }

  if (!can("counter:sell")) return <Message>Không có quyền bán vé tại quầy. Liên hệ chủ nhà xe để kiểm tra tài khoản.</Message>;
  if (offices.isPending) return <Busy>Đang tải văn phòng được cấp…</Busy>;
  if (offices.isError) return <Message action={<Button variant="outline" onClick={() => void offices.refetch()}>Thử lại</Button>}>{counterError(offices.error)}</Message>;
  if (!office) return <Message>Chưa có văn phòng đang hoạt động được cấp cho tài khoản. Chủ nhà xe cần tạo văn phòng và phân công nhân viên bán vé.</Message>;

  return (
    <div className="flex flex-col gap-6">
      <div className="flex flex-col gap-4 print:hidden">
        <div className="flex flex-wrap items-center justify-between gap-3"><div><h1 className="text-xl font-semibold">Bán vé tại quầy</h1><p className="mt-1 text-sm text-muted-foreground">Dùng chung kho ghế với mọi văn phòng và khách đặt online.</p></div>{(held || bookingId) && <Button variant="outline" disabled={Boolean(held)} onClick={resetSale}><Ticket className="size-4" />Bán đơn mới</Button>}</div>
        <section className={`${CARD} grid gap-4 sm:grid-cols-2`} aria-label="Văn phòng và ngày chạy">
          <FormField label="Văn phòng đang làm việc">{(control) => <select {...control} className={SELECT} value={activeOfficeId} disabled={Boolean(held || bookingId)} onChange={(event) => { setOfficeId(event.target.value); setTripId(null); }}>
            {activeOffices.map((item) => <option key={item.id} value={item.id}>{item.code} · {item.name}</option>)}
          </select>}</FormField>
          <FormField label="Ngày chạy tại Việt Nam" helper="Có thể chọn chuyến trễ lịch chưa được xác nhận khởi hành.">{(control) => <Input {...control} type="date" value={date} disabled={Boolean(held || bookingId)} onChange={(event) => { setDate(event.target.value); setTripId(null); }} />}</FormField>
          <p className="flex items-start gap-2 text-xs text-muted-foreground sm:col-span-2"><Building2 className="size-4 shrink-0" />{office.address}</p>
        </section>
      </div>

      {bookingId ? <CounterBookingPanel key={bookingId} bookingId={bookingId} onChanged={() => { void bookings.refetch(); void trips.refetch(); void queryClient.invalidateQueries({ queryKey: ["counter-report"] }); }} /> : held ? (
        <CustomerForm key={held.hold.holdId} {...held} onCreated={(id) => { setBookingId(id); setHeld(null); void bookings.refetch(); void trips.refetch(); }} onBack={async () => { try { await releaseCounterHold(held.hold.holdId); } catch (error) { if (!(error instanceof ApiError && error.status === 404)) throw error; } setHeld(null); void trips.refetch(); void bookings.refetch(); }} />
      ) : trip ? (
        <SeatPicker key={`${activeOfficeId}-${trip.tripId}`} officeId={activeOfficeId} trip={trip} onBack={() => setTripId(null)} onHeld={(hold) => setHeld({ hold, trip })} />
      ) : (
        <section className={`${CARD} flex flex-col gap-4 print:hidden`} aria-label="Chọn chuyến">
          <div className="flex items-center justify-between gap-3"><h2 className="font-semibold">1. Chọn chuyến</h2><Button variant="ghost" size="sm" onClick={() => void trips.refetch()} disabled={trips.isFetching}><RefreshCw className={`size-4 ${trips.isFetching ? "animate-spin" : ""}`} />Tải lại</Button></div>
          {trips.isPending ? <Busy>Đang tải chuyến còn bán quầy…</Busy> : trips.isError ? <Message>{counterError(trips.error)}</Message> : !trips.data.length ? <Message>Không có chuyến còn bán quầy trong ngày này. Thử ngày khác hoặc kiểm tra trạng thái chuyến.</Message> : <div className="grid gap-3 md:grid-cols-2">{trips.data.map((item) => {
            const available = item.seats.filter((seat) => seat.status === "AVAILABLE" && seat.price !== null).length;
            return <button key={item.tripId} type="button" className="flex flex-col items-start gap-2 rounded-lg border p-4 text-left outline-none hover:border-primary hover:bg-accent/30 focus-visible:ring-2 focus-visible:ring-ring disabled:cursor-not-allowed disabled:opacity-60" disabled={available === 0} onClick={() => setTripId(item.tripId)}>
              <span className="flex w-full items-start justify-between gap-2"><span className="font-semibold">{item.routeName}</span><Badge tone={available ? "success" : "neutral"}>{available} ghế trống</Badge></span>
              <span className="text-sm">{formatTime(item.departureAt)} → {formatTime(item.arrivalAt)}</span><span className="flex items-center gap-2 text-xs text-muted-foreground"><Bus className="size-4" />{item.vehiclePlateNumber ?? "Chưa gắn xe"}</span>
            </button>;
          })}</div>}
        </section>
      )}

      {!held && <section className={`${CARD} flex flex-col gap-4 print:hidden`} aria-label="Đơn quầy của văn phòng">
        <div className="flex items-center justify-between gap-3"><h2 className="font-semibold">Đơn quầy gần đây</h2><Button variant="ghost" size="sm" onClick={() => void bookings.refetch()} disabled={bookings.isFetching}><RefreshCw className="size-4" />Tải lại</Button></div>
        {bookings.isPending ? <Busy>Đang tải đơn…</Busy> : bookings.isError ? <Message>{counterError(bookings.error)}</Message> : !bookings.data?.length ? <p className="text-sm text-muted-foreground">Chưa có đơn tại văn phòng này.</p> : (
          <div className="overflow-x-auto">
            <table className="w-full min-w-[620px] text-left text-sm">
              <thead><tr className="border-b text-xs text-muted-foreground"><th className="px-2 py-3">Mã đơn / khách</th><th className="px-2 py-3">Người bán</th><th className="px-2 py-3">Tổng tiền</th><th className="px-2 py-3">Trạng thái</th><th className="px-2 py-3"><span className="sr-only">Thao tác</span></th></tr></thead>
              <tbody>{bookings.data.map((item) => (
                <tr key={item.bookingId} className="border-b last:border-0">
                  <td className="px-2 py-3 font-medium">{item.bookingCode}<span className="mt-1 block font-normal text-muted-foreground">{item.contact.fullName}</span></td>
                  <td className="px-2 py-3">{item.seller}</td>
                  <td className="px-2 py-3">{counterMoney(item.total)}</td>
                  <td className="px-2 py-3">{item.tickets.length ? "Đã phát vé" : item.receipts.some((receipt) => receipt.status === "EXCEPTION") ? "Khoản thu cần xử lý" : counterBookingLabel(item.status)}</td>
                  <td className="px-2 py-3"><Button variant="outline" size="sm" onClick={() => setBookingId(item.bookingId)}>Mở đơn</Button></td>
                </tr>
              ))}</tbody>
            </table>
          </div>
        )}
      </section>}
      {!held && can("counter:read") && <CounterReportPanel officeId={activeOfficeId} />}
    </div>
  );
}

function SeatPicker({ officeId, trip, onBack, onHeld }: { officeId: string; trip: CounterTrip; onBack: () => void; onHeld: (hold: CounterHold) => void }) {
  const [selected, setSelected] = useState<string[]>([]);
  const [pickupSequence, setPickup] = useState(trip.stops.find((stop) => stop.allowPickup)?.sequence ?? 1);
  const [dropoffSequence, setDropoff] = useState([...trip.stops].reverse().find((stop) => stop.allowDropoff)?.sequence ?? 2);
  const mutation = useMutation({ mutationFn: () => createCounterHold({ officeId, tripId: trip.tripId, seatCodes: selected, pickupSequence, dropoffSequence }), onSuccess: onHeld });
  const total = selectedCounterTotal(trip.seats, selected);
  function changePickup(sequence: number) {
    setPickup(sequence);
    if (dropoffSequence <= sequence) setDropoff(trip.stops.find((stop) => stop.allowDropoff && stop.sequence > sequence)?.sequence ?? sequence);
  }
  return (
    <section className={`${CARD} flex flex-col gap-5 print:hidden`}>
      <div className="flex flex-wrap items-center justify-between gap-3"><h2 className="font-semibold">2. Chọn ghế · {trip.routeName}</h2><Button variant="ghost" size="sm" disabled={mutation.isPending} onClick={onBack}><ArrowLeft className="size-4" />Đổi chuyến</Button></div>
      <div className="grid gap-4 sm:grid-cols-2"><FormField label="Điểm đón">{(control) => <select {...control} className={SELECT} value={pickupSequence} disabled={mutation.isPending} onChange={(event) => changePickup(Number(event.target.value))}>{trip.stops.filter((stop) => stop.allowPickup).map((stop) => <option key={stop.sequence} value={stop.sequence}>{stop.name}</option>)}</select>}</FormField><FormField label="Điểm trả">{(control) => <select {...control} className={SELECT} value={dropoffSequence} disabled={mutation.isPending} onChange={(event) => setDropoff(Number(event.target.value))}>{trip.stops.filter((stop) => stop.allowDropoff && stop.sequence > pickupSequence).map((stop) => <option key={stop.sequence} value={stop.sequence}>{stop.name}</option>)}</select>}</FormField></div>
      <fieldset disabled={mutation.isPending} className="grid grid-cols-2 gap-3 sm:grid-cols-4 lg:grid-cols-6"><legend className="mb-3 text-sm text-muted-foreground">Ghế không còn trống sẽ không chọn được. Mỗi đơn tối đa 10 ghế, giá theo bảng giá của chuyến.</legend>{trip.seats.map((seat) => {
        const checked = selected.includes(seat.code);
        const available = seat.status === "AVAILABLE" && seat.price !== null;
        return <button key={seat.code} type="button" aria-pressed={checked} disabled={!available || (!checked && selected.length >= 10)} onClick={() => setSelected((value) => checked ? value.filter((code) => code !== seat.code) : [...value, seat.code])} className={`flex flex-col items-center gap-1 rounded-lg border p-3 text-sm outline-none focus-visible:ring-2 focus-visible:ring-ring disabled:cursor-not-allowed disabled:bg-muted disabled:text-muted-foreground ${checked ? "border-primary bg-accent text-primary" : "hover:bg-muted"}`}><Armchair className="size-5" /><span className="font-semibold">{seat.code}</span><span className="text-xs">{available ? counterMoney(seat.price!) : "Không khả dụng"}</span></button>;
      })}</fieldset>
      {mutation.isError && <Message>{counterError(mutation.error)}</Message>}
      <div className="flex flex-wrap items-center justify-between gap-3 border-t pt-4"><p className="text-sm">{selected.length} ghế · <strong>{counterMoney(total)}</strong></p><Button disabled={!selected.length || pickupSequence >= dropoffSequence || mutation.isPending} onClick={() => mutation.mutate()}>{mutation.isPending && <LoaderCircle className="size-4 animate-spin" />}Giữ ghế và nhập khách</Button></div>
    </section>
  );
}

function CustomerForm({ hold, trip, onCreated, onBack }: { hold: CounterHold; trip: CounterTrip; onCreated: (bookingId: string) => void; onBack: () => Promise<void> }) {
  const [name, setName] = useState("");
  const [phone, setPhone] = useState("");
  const [email, setEmail] = useState("");
  const [note, setNote] = useState("");
  const [passengerNames, setPassengerNames] = useState<Record<string, string>>({});
  const [formError, setFormError] = useState<string | null>(null);
  const mutation = useMutation({ mutationFn: createCounterBooking, onSuccess: (booking) => onCreated(booking.bookingId) });
  const release = useMutation({ mutationFn: onBack });

  function submit(event: FormEvent) {
    event.preventDefault();
    setFormError(null);
    if (new Date(hold.expiresAt).getTime() <= Date.now()) { setFormError("Phiên giữ ghế đã hết hạn. Quay lại chọn ghế trước khi tạo đơn."); return; }
    const input = CounterBookingInputSchema.safeParse({ holdId: hold.holdId, contact: { fullName: name.trim(), phone: phone.trim(), email: email.trim() || null }, passengers: hold.seats.map((seat) => ({ seatCode: seat.code, fullName: passengerNames[seat.code]?.trim() || name.trim(), phone: null })), note: note.trim() || null, expectedTotal: hold.subtotal });
    if (!input.success) { setFormError(input.error.issues.map((issue) => issue.message).join(" ")); return; }
    mutation.mutate(input.data);
  }

  return <section className={`${CARD} flex flex-col gap-5 print:hidden`}><div className="flex flex-wrap items-center justify-between gap-3"><h2 className="font-semibold">3. Thông tin khách</h2><Button variant="ghost" disabled={mutation.isPending || release.isPending} onClick={() => release.mutate()}><ArrowLeft className="size-4" />Đổi ghế</Button></div><p className="rounded-lg bg-accent/50 p-3 text-sm">{trip.routeName} · Ghế {hold.seats.map((seat) => seat.code).join(", ")} · Giữ đến {formatDateTime(hold.expiresAt)}. Vé chỉ được phát sau khi xác nhận thu đủ tiền và xe chưa khởi hành.</p><form onSubmit={submit} noValidate className="flex flex-col gap-4"><fieldset disabled={mutation.isPending || release.isPending} className="grid gap-4 sm:grid-cols-2"><FormField label="Họ tên liên hệ *">{(control) => <Input {...control} value={name} autoComplete="name" maxLength={120} onChange={(event) => setName(event.target.value)} />}</FormField><FormField label="Số điện thoại *">{(control) => <Input {...control} value={phone} type="tel" autoComplete="tel" onChange={(event) => setPhone(event.target.value)} />}</FormField><FormField label="Email (không bắt buộc)">{(control) => <Input {...control} value={email} type="email" autoComplete="email" onChange={(event) => setEmail(event.target.value)} />}</FormField><FormField label="Ghi chú">{(control) => <Textarea {...control} rows={2} value={note} maxLength={500} onChange={(event) => setNote(event.target.value)} />}</FormField>{hold.seats.map((seat) => <FormField key={seat.code} label={`Hành khách ghế ${seat.code}`} helper="Để trống sẽ dùng tên liên hệ.">{(control) => <Input {...control} value={passengerNames[seat.code] ?? ""} maxLength={120} onChange={(event) => setPassengerNames((current) => ({ ...current, [seat.code]: event.target.value }))} />}</FormField>)}</fieldset>{formError && <Message>{formError}</Message>}{mutation.isError && <Message>{counterError(mutation.error)}</Message>}{release.isError && <Message>{counterError(release.error)}</Message>}<div className="flex flex-wrap items-center justify-between gap-3 border-t pt-4"><strong>{counterMoney(hold.subtotal)}</strong><Button type="submit" disabled={mutation.isPending || release.isPending}>{mutation.isPending && <LoaderCircle className="size-4 animate-spin" />}Tạo đơn và thu tiền</Button></div></form></section>;
}

function Message({ children, action }: { children: ReactNode; action?: ReactNode }) {
  return <div role="status" className="flex flex-col gap-3 rounded-lg bg-muted px-4 py-3 text-sm leading-6"><p className="flex items-start gap-2"><CircleAlert className="mt-1 size-4 shrink-0" /><span>{children}</span></p>{action}</div>;
}

function Busy({ children }: { children: ReactNode }) {
  return <p role="status" className="flex items-center gap-2 py-5 text-sm text-muted-foreground"><LoaderCircle className="size-4 animate-spin" />{children}</p>;
}
