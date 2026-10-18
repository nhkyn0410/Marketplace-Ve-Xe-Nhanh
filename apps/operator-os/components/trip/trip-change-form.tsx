"use client";

import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { Button } from "@vexenhanh/ui/components/button";
import { Input } from "@vexenhanh/ui/components/input";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@vexenhanh/ui/components/select";
import { Skeleton } from "@vexenhanh/ui/components/skeleton";
import { Textarea } from "@vexenhanh/ui/components/textarea";
import { ArrowLeft, CircleAlert, Info, LoaderCircle, MapPinned, RefreshCw, Undo2 } from "lucide-react";
import Link from "next/link";
import { useRouter } from "next/navigation";
import { useId, useState, type ReactNode } from "react";

import { ApiError } from "../../lib/auth/api-client";
import { stopKey, type StopCandidate } from "../../lib/route/route-form";
import { changeTrip, getTrip, getTripSales, type Trip, type TripSales } from "../../lib/trip/trip-api";
import { CHANGE_REASON_MAX, describeTripChangeError, impactLabel, toChangeInput, type StopReplacement } from "../../lib/trip/trip-change";
import { arrivalIso, departureIso, toTripFormValues } from "../../lib/trip/trip-form";
import { formatTime, formatWeekdayDate, stopMetaLabel, TRIP_STATUS } from "../../lib/trip/trip-format";
import { listAllVehicles } from "../../lib/vehicle/vehicle-api";
import { formatPlateNumber } from "../../lib/vehicle/vehicle-format";
import { FormField } from "../form-field";
import { BUTTON } from "../list-parts";
import { PageHeader } from "../page-header";
import { StopPicker } from "../route/stop-picker";
import { TripStopRow } from "./trip-stop-row";

const CARD = "flex flex-col gap-5 rounded-xl border bg-card p-6";
const CARD_TITLE = "text-base leading-6 font-semibold text-vxn-ink";
const HELPER = "text-xs leading-[18px] text-muted-foreground";

/**
 * Đổi lịch chạy của chuyến đang bán / đã bán vé (TASK-TRN-008, FR-OPS-11..12, BR-10, BR-20, UC-14 A4): giờ đi / đến, xe, điểm
 * đón / trả. Bắt buộc lý do — lưu lịch sử, ghi audit và gửi email cho mọi khách bị ảnh hưởng. Đổi xe phải giữ được mọi chỗ đã
 * bán (cùng mã, cùng loại); giờ từng điểm chia lại theo thời gian chặng của tuyến.
 */
export function TripChangeForm({ tripId }: { tripId: string }) {
  const trip = useQuery({ queryKey: ["trip", tripId], queryFn: () => getTrip(tripId) });
  const sales = useQuery({ queryKey: ["trip-sales", tripId], queryFn: () => getTripSales(tripId) });
  if ((trip.isError && !trip.data) || (sales.isError && !sales.data)) {
    return (
      <Shell tripId={tripId}>
        <Panel
          icon={<CircleAlert className="size-6 text-warning-700" />}
          title={trip.error instanceof ApiError && trip.error.status === 404 ? "Không tìm thấy chuyến" : "Không tải được chuyến"}
          description="Vui lòng kiểm tra kết nối và thử lại."
          action={
            <Button variant="outline" className={`${BUTTON} bg-card`} onClick={() => void Promise.all([trip.refetch(), sales.refetch()])}>
              <RefreshCw className="size-[18px]" />
              Thử lại
            </Button>
          }
        />
      </Shell>
    );
  }
  if (!trip.data || !sales.data) {
    return (
      <Shell tripId={tripId}>
        <div role="status" aria-label="Đang tải chuyến" className="grid gap-6 xl:grid-cols-[minmax(0,1fr)_400px]">
          <Skeleton className="h-[520px] rounded-xl" />
          <Skeleton className="h-[320px] rounded-xl" />
        </div>
      </Shell>
    );
  }
  if (!["OPEN_FOR_SALE", "LOCKED", "SOLD_OUT"].includes(trip.data.status)) {
    return (
      <Shell tripId={tripId}>
        <Panel
          icon={<Info className="size-6 text-vxn-fg-3" />}
          title="Chuyến không đổi lịch chạy được"
          description={`Chuyến đang ở trạng thái ${TRIP_STATUS[trip.data.status].label}. Chuyến nháp sửa bằng "Sửa chuyến"; chuyến đã khởi hành / đã hủy không đổi được.`}
          action={
            <Button asChild variant="outline" className={`${BUTTON} bg-card`}>
              <Link href={`/trips/${tripId}`}>Về chi tiết chuyến</Link>
            </Button>
          }
        />
      </Shell>
    );
  }
  return <ChangeBody trip={trip.data} sales={sales.data} />;
}

function ChangeBody({ trip, sales }: { trip: Trip; sales: TripSales }) {
  const router = useRouter();
  const queryClient = useQueryClient();
  const initial = toTripFormValues(trip);
  const [departureDate, setDepartureDate] = useState(initial.departureDate);
  const [departureTime, setDepartureTime] = useState(initial.departureTime);
  const [arrivalDate, setArrivalDate] = useState(initial.arrivalDate);
  const [arrivalTime, setArrivalTime] = useState(initial.arrivalTime);
  const [vehicleId, setVehicleId] = useState(trip.vehicleId ?? "");
  const [reason, setReason] = useState("");
  const [replacements, setReplacements] = useState<Map<number, StopReplacement>>(new Map());
  const [picking, setPicking] = useState<number | null>(null);
  const [errors, setErrors] = useState<{ reason?: string; form?: string }>({});
  const ids = { departureDate: useId(), departureTime: useId(), arrivalDate: useId(), arrivalTime: useId() };
  const vehicles = useQuery({ queryKey: ["vehicles", "all"], queryFn: listAllVehicles });
  const usable = (vehicles.data ?? []).filter((vehicle) => vehicle.status === "ACTIVE" && vehicle.seatMap);

  const save = useMutation({
    mutationFn: () =>
      changeTrip(
        trip.id,
        toChangeInput(trip, { departureAt: departureIso({ departureDate, departureTime }), arrivalAt: arrivalIso({ arrivalDate, arrivalTime }), vehicleId, reason }, replacements)
      ),
    onSuccess: (updated) => {
      queryClient.setQueryData(["trip", trip.id], updated);
      void queryClient.invalidateQueries({ queryKey: ["trip-sales", trip.id] });
      void queryClient.invalidateQueries({ queryKey: ["trips"] });
      router.push(`/trips/${trip.id}?changed=1`);
    },
    onError: (failure) => setErrors({ form: describeTripChangeError(failure) })
  });

  function submit() {
    const reasonError = reason.trim().length < 3 ? "Nhập lý do thay đổi (3–500 ký tự) — lý do được gửi cho khách." : undefined;
    setErrors({ reason: reasonError });
    if (!reasonError && vehicleId) {
      save.mutate();
    }
  }

  const selectedKeys = new Set(trip.stops.map((stop) => stopKey(replacements.get(stop.sequence) ?? stop)));
  return (
    <Shell tripId={trip.id}>
      <PageHeader
        title="Đổi lịch chạy"
        description={`${trip.routeName} · khởi hành ${formatTime(trip.departureAt)} ${formatWeekdayDate(trip.departureAt)}. Mọi thay đổi cần lý do và được báo cho khách.`}
      />
      <div className="grid items-start gap-6 xl:grid-cols-[minmax(0,1fr)_400px]">
        <form
          id="trip-change-form"
          className="flex min-w-0 flex-col gap-6"
          onSubmit={(event) => {
            event.preventDefault();
            submit();
          }}
        >
          <section aria-labelledby="change-time" className={CARD}>
            <h2 id="change-time" className={CARD_TITLE}>
              Giờ chạy
            </h2>
            <div className="grid gap-4 sm:grid-cols-2">
              <TimeField id={ids.departureDate} label="Ngày khởi hành" type="date" value={departureDate} onChange={setDepartureDate} />
              <TimeField id={ids.departureTime} label="Giờ khởi hành" type="time" value={departureTime} onChange={setDepartureTime} />
              <TimeField id={ids.arrivalDate} label="Ngày đến" type="date" value={arrivalDate} onChange={setArrivalDate} />
              <TimeField id={ids.arrivalTime} label="Giờ đến" type="time" value={arrivalTime} onChange={setArrivalTime} />
            </div>
            <p className={HELPER}>Giờ tại các điểm ở giữa được chia lại theo thời gian chạy từng chặng của tuyến.</p>
          </section>

          <section aria-labelledby="change-vehicle" className={CARD}>
            <div className="flex flex-col gap-1">
              <h2 id="change-vehicle" className={CARD_TITLE}>
                Xe
              </h2>
              <p className={HELPER}>Xe mới phải có đúng các chỗ đã bán (cùng mã, cùng loại) và không chạy chuyến khác chồng giờ.</p>
            </div>
            <FormField label="Xe chạy chuyến">
              {(control) => (
                <Select value={vehicleId} onValueChange={setVehicleId} disabled={vehicles.isPending}>
                  <SelectTrigger id={control.id} aria-describedby={control["aria-describedby"]}>
                    <SelectValue placeholder={vehicles.isPending ? "Đang tải xe…" : "Chọn xe"} />
                  </SelectTrigger>
                  <SelectContent>
                    {usable.map((vehicle) => (
                      <SelectItem key={vehicle.id} value={vehicle.id}>
                        {formatPlateNumber(vehicle.plateNumber)}
                        {vehicle.seatMap ? ` · ${vehicle.seatMap.name}` : ""}
                        {vehicle.id === trip.vehicleId ? " (đang chạy)" : ""}
                      </SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              )}
            </FormField>
          </section>

          <section aria-labelledby="change-stops" className={CARD}>
            <div className="flex flex-col gap-1">
              <h2 id="change-stops" className={CARD_TITLE}>
                Điểm đón / trả
              </h2>
              <p className={HELPER}>Đổi điểm ở thứ tự có đón hoặc trả khách; vai trò đón / trả của từng thứ tự giữ nguyên.</p>
            </div>
            <ol aria-label="Điểm dừng của chuyến" className="flex flex-col gap-2">
              {trip.stops.map((stop) => {
                const next = replacements.get(stop.sequence);
                const changeable = stop.allowPickup || stop.allowDropoff;
                return (
                  <TripStopRow key={stop.sequence} order={stop.sequence} name={next ? next.name : stop.name} address={next ? `Thay cho ${stop.name}` : stop.address} meta={stopMetaLabel(stop)}>
                    {changeable && (
                      <div className="flex gap-2">
                        {next && (
                          <Button
                            type="button"
                            variant="ghost"
                            className="h-9 px-3"
                            onClick={() =>
                              setReplacements((current) => {
                                const copy = new Map(current);
                                copy.delete(stop.sequence);
                                return copy;
                              })
                            }
                          >
                            <Undo2 className="size-4" />
                            Giữ điểm cũ
                          </Button>
                        )}
                        <Button type="button" variant="outline" className="h-9 bg-card px-3" onClick={() => setPicking(stop.sequence)}>
                          <MapPinned className="size-4" />
                          Đổi điểm
                        </Button>
                      </div>
                    )}
                  </TripStopRow>
                );
              })}
            </ol>
            {picking !== null && (
              <StopPicker
                selectedKeys={selectedKeys}
                stopCount={trip.stops.length}
                onClose={() => setPicking(null)}
                onAdd={(candidate: StopCandidate) => {
                  setReplacements((current) => new Map(current).set(picking, { catalogStopPointId: candidate.catalogStopPointId, stopPointId: candidate.stopPointId, name: candidate.name }));
                  setPicking(null);
                }}
              />
            )}
          </section>

          <section aria-labelledby="change-reason" className={CARD}>
            <h2 id="change-reason" className={CARD_TITLE}>
              Lý do thay đổi
            </h2>
            <FormField label="Lý do *" helper="Khách nhận được lý do này trong email thông báo." error={errors.reason}>
              {(control) => (
                <Textarea {...control} rows={3} maxLength={CHANGE_REASON_MAX} value={reason} placeholder="Ví dụ: xe cũ hỏng điều hoà, đổi sang xe cùng sơ đồ ghế" onChange={(event) => setReason(event.target.value)} />
              )}
            </FormField>
          </section>
        </form>

        <aside className="flex flex-col gap-6">
          <section aria-labelledby="change-impact" className={CARD}>
            <h2 id="change-impact" className={CARD_TITLE}>
              Ảnh hưởng
            </h2>
            <p className="text-sm leading-5 text-vxn-fg-1">{impactLabel(sales)}</p>
            {sales.holdingSeats > 0 && (
              <p role="note" className="rounded-lg bg-warning-50 px-4 py-3 text-sm leading-5 text-warning-700">
                Có {sales.holdingSeats} chỗ đang chờ khách thanh toán — chưa đổi được cho tới khi các đơn này thanh toán xong hoặc hết hạn.
              </p>
            )}
            {errors.form && (
              <p role="alert" className="rounded-lg bg-error-50 px-4 py-3 text-sm leading-5 text-error-600">
                {errors.form}
              </p>
            )}
            <div className="flex flex-wrap gap-3">
              <Button asChild variant="outline" className={`${BUTTON} bg-card`}>
                <Link href={`/trips/${trip.id}`}>Hủy</Link>
              </Button>
              <Button type="submit" form="trip-change-form" className={BUTTON} disabled={save.isPending || !vehicleId}>
                {save.isPending && <LoaderCircle className="size-[18px] animate-spin" />}
                Lưu và báo khách
              </Button>
            </div>
          </section>
        </aside>
      </div>
    </Shell>
  );
}

function TimeField({ id, label, type, value, onChange }: { id: string; label: string; type: "date" | "time"; value: string; onChange: (value: string) => void }) {
  return (
    <div className="flex flex-col gap-1.5">
      <label htmlFor={id} className="text-sm leading-5 font-medium text-vxn-ink">
        {label}
      </label>
      <Input id={id} type={type} value={value} required onChange={(event) => onChange(event.target.value)} />
    </div>
  );
}

function Shell({ tripId, children }: { tripId: string; children: ReactNode }) {
  return (
    <div className="flex flex-col gap-6">
      <Link
        href={`/trips/${tripId}`}
        className="flex w-fit items-center gap-1.5 rounded text-sm leading-5 font-medium text-muted-foreground outline-none hover:text-vxn-fg-1 focus-visible:ring-[3px] focus-visible:ring-ring/50"
      >
        <ArrowLeft className="size-[18px]" />
        Chi tiết chuyến
      </Link>
      {children}
    </div>
  );
}

function Panel({ icon, title, description, action }: { icon: ReactNode; title: string; description: string; action: ReactNode }) {
  return (
    <div className="flex min-h-[420px] flex-col items-center justify-center gap-3 rounded-xl border bg-card px-4 text-center">
      {icon}
      <p className="text-base leading-6 font-semibold text-vxn-ink">{title}</p>
      <p className="max-w-md text-sm leading-5 text-muted-foreground">{description}</p>
      {action}
    </div>
  );
}
