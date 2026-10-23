"use client";

import { useInfiniteQuery, useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { Badge } from "@vexenhanh/ui/components/badge";
import { Button } from "@vexenhanh/ui/components/button";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle
} from "@vexenhanh/ui/components/dialog";
import { Input } from "@vexenhanh/ui/components/input";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@vexenhanh/ui/components/select";
import { Textarea } from "@vexenhanh/ui/components/textarea";
import { cn } from "@vexenhanh/ui/lib/utils";
import { ArrowLeft, CalendarX2, CircleAlert, Info, LoaderCircle, RefreshCw } from "lucide-react";
import Link from "next/link";
import { useId, useMemo, useState, type FormEvent } from "react";

import {
  assignDriver,
  listTripAssignments,
  type AssignmentState,
  type TripAssignment
} from "../../lib/employee/assignment-api";
import { assignmentState, conflictNote, describeAssignError, driverOptions } from "../../lib/employee/assignment-format";
import { listAllEmployees, type Employee } from "../../lib/employee/employee-api";
import { REASON_MAX_LENGTH } from "../../lib/employee/employee-form";
import { listAllRoutes } from "../../lib/route/route-api";
import { formatDuration } from "../../lib/route/route-format";
import { formatTime, todayLocalDate, toLocalParts } from "../../lib/trip/trip-format";
import { formatPlateNumber } from "../../lib/vehicle/vehicle-format";
import { FormField } from "../form-field";
import { BUTTON, ListLoadMoreFooter, ListStatePanel } from "../list-parts";
import { PageHeader } from "../page-header";
import {
  ALL,
  FilterSelect,
  TABLE,
  TABLE_CELL,
  TABLE_HEAD_CELL,
  TABLE_HEAD_ROW,
  TableSkeleton
} from "../stop-point/list-controls";

/** Giá trị ô chọn tài xế khi bỏ phân công (ô chọn không nhận chuỗi rỗng). */
const UNASSIGNED = "NONE";
// Độ rộng cột theo Figma (150 / 300 / 150 / 320 / co giãn trên bảng rộng 1086).
const COLUMNS = ["w-[13.8%]", "w-[27.6%]", "w-[13.8%]", "w-[29.5%]", ""];
const HEADINGS = ["Khởi hành", "Tuyến", "Xe", "Tài xế", "Tình trạng"];

/**
 * Màn Phân công chuyến (Figma "05 · Nhân viên / Phân công chuyến"; UC-16 bước 4–6, TASK-EMP-001 phía Operator OS): gán
 * tài xế cho từng chuyến trong ngày. Máy chủ chặn một tài xế chạy hai chuyến trùng giờ; chuyến sắp chạy / đang chạy đổi
 * phân công phải có lý do.
 */
export function TripAssignmentList() {
  const [date, setDate] = useState(todayLocalDate());
  const [routeId, setRouteId] = useState(ALL);
  const [state, setState] = useState(ALL);
  const routes = useQuery({ queryKey: ["routes", "all"], queryFn: () => listAllRoutes() });
  const employees = useQuery({ queryKey: ["employees", "all"], queryFn: listAllEmployees });
  const drivers = useMemo(() => driverOptions(employees.data ?? []), [employees.data]);
  const validDate = /^\d{4}-\d{2}-\d{2}$/.test(date);
  const assignments = useInfiniteQuery({
    queryKey: ["trip-assignments", date, routeId, state],
    queryFn: ({ pageParam }) =>
      listTripAssignments({
        date,
        routeId: routeId === ALL ? undefined : routeId,
        state: state === ALL ? undefined : (state as AssignmentState),
        cursor: pageParam ?? undefined
      }),
    initialPageParam: null as string | null,
    getNextPageParam: (page) => page.nextCursor,
    enabled: validDate
  });
  const items = assignments.data?.pages.flatMap((page) => page.items) ?? [];
  const filtered = routeId !== ALL || state !== ALL;

  let body;
  if (!validDate) {
    body = (
      <ListStatePanel icon={<CalendarX2 className="size-6 text-vxn-fg-3" />} title="Chọn ngày khởi hành" description="Chọn ngày để xem các chuyến cần phân công." compact />
    );
  } else if (assignments.isPending) {
    body = <TableSkeleton label="Đang tải chuyến" rows={5} />;
  } else if (assignments.isError && !assignments.data) {
    body = (
      <ListStatePanel
        icon={<CircleAlert className="size-6 text-warning-700" />}
        title="Không tải được chuyến"
        description="Không kết nối được máy chủ. Vui lòng kiểm tra kết nối và thử lại."
        action={
          <Button variant="outline" className={`${BUTTON} bg-card`} onClick={() => void assignments.refetch()}>
            <RefreshCw className="size-[18px]" />
            Thử lại
          </Button>
        }
      />
    );
  } else if (items.length === 0) {
    body = (
      <ListStatePanel
        icon={<CalendarX2 className="size-6 text-vxn-fg-3" />}
        title={filtered ? "Không có chuyến phù hợp" : "Không có chuyến trong ngày"}
        description={
          filtered
            ? "Đổi tuyến hoặc tình trạng, hoặc bỏ lọc để xem mọi chuyến trong ngày."
            : "Ngày này chưa có chuyến (chuyến đã hủy không hiện). Chọn ngày khác hoặc tạo chuyến ở mục Chuyến xe."
        }
        action={
          filtered ? (
            <Button
              variant="outline"
              className={`${BUTTON} bg-card`}
              onClick={() => {
                setRouteId(ALL);
                setState(ALL);
              }}
            >
              Bỏ lọc
            </Button>
          ) : undefined
        }
      />
    );
  } else {
    body = (
      <div className="overflow-x-auto">
        <table className={`${TABLE} min-w-[980px]`}>
          <colgroup>
            {COLUMNS.map((width, index) => (
              <col key={index} className={width} />
            ))}
          </colgroup>
          <thead>
            <tr className={TABLE_HEAD_ROW}>
              {HEADINGS.map((heading) => (
                <th key={heading} scope="col" className={TABLE_HEAD_CELL}>
                  {heading}
                </th>
              ))}
            </tr>
          </thead>
          <tbody>
            {items.map((item) => (
              <AssignmentRow key={item.tripId} item={item} drivers={drivers} />
            ))}
          </tbody>
        </table>
      </div>
    );
  }

  return (
    <div className="flex flex-col gap-6">
      <Link href="/employees" className="flex w-fit items-center gap-2 text-sm leading-5 font-medium text-vxn-teal-700 hover:underline">
        <ArrowLeft className="size-4" />
        Quay lại danh sách nhân viên
      </Link>
      <PageHeader title="Phân công chuyến" description="Gán tài xế cho các chuyến trong ngày. Mỗi chuyến một tài xế." />
      <section aria-label="Chuyến cần phân công" className="flex flex-col rounded-xl border bg-card p-6">
        <div className="flex flex-wrap items-end gap-x-4 gap-y-3 pb-5">
          <DateField value={date} onChange={setDate} />
          <FilterSelect
            label="Tuyến"
            allLabel="Tất cả tuyến"
            value={routeId}
            onChange={setRouteId}
            options={(routes.data ?? []).map((route) => ({ value: route.id, label: route.name }))}
          />
          <FilterSelect
            label="Tình trạng"
            allLabel="Tất cả"
            value={state}
            onChange={setState}
            options={[
              { value: "ASSIGNED", label: "Đã phân công" },
              { value: "UNASSIGNED", label: "Chưa phân công" }
            ]}
          />
        </div>
        {body}
        {items.length > 0 && (
          <div className="flex pt-5">
            <ListLoadMoreFooter
              hasMore={assignments.hasNextPage}
              loading={assignments.isFetchingNextPage}
              failed={assignments.isFetchNextPageError}
              loadedText={`Đã tải ${items.length} chuyến`}
              endText={`Đã hiển thị tất cả ${items.length} chuyến`}
              errorText="Chưa tải thêm được chuyến. Các chuyến đã tải vẫn được giữ lại."
              onLoadMore={() => void assignments.fetchNextPage()}
            />
          </div>
        )}
      </section>
      <div role="note" className="flex items-center gap-3 rounded-lg bg-accent px-5 py-4 text-vxn-teal-700">
        <Info className="size-5 shrink-0" />
        <p className="text-sm leading-5">
          Một tài xế không được phân công vào hai chuyến trùng thời gian chạy. Đổi phân công khi chuyến sắp khởi hành hoặc đang
          chạy cần nhập lý do.
        </p>
      </div>
    </div>
  );
}

function DateField({ value, onChange }: { value: string; onChange: (value: string) => void }) {
  const id = useId();
  return (
    <div className="flex w-52 flex-col gap-1.5">
      <label htmlFor={id} className="text-xs leading-[18px] font-medium text-muted-foreground">
        Ngày khởi hành
      </label>
      <Input id={id} type="date" value={value} onChange={(event) => onChange(event.target.value)} />
    </div>
  );
}

function AssignmentRow({ item, drivers }: { item: TripAssignment; drivers: Employee[] }) {
  const queryClient = useQueryClient();
  // Lựa chọn vừa bị máy chủ từ chối: giữ trên ô kèm lỗi (Figma: ô viền đỏ + "Trùng giờ chạy với chuyến …").
  const [rejected, setRejected] = useState<{ value: string; message: string } | null>(null);
  const [asking, setAsking] = useState<string | null>(null);
  const save = useMutation({
    mutationFn: ({ value, reason }: { value: string; reason: string | null }) =>
      assignDriver(item.tripId, value === UNASSIGNED ? null : value, reason),
    onSuccess: () => {
      setRejected(null);
      setAsking(null);
      void queryClient.invalidateQueries({ queryKey: ["trip-assignments"] });
    },
    onError: (error, { value }) => {
      setAsking(null);
      setRejected({ value, message: describeAssignError(error) });
    }
  });
  const current = item.driver?.employeeId ?? UNASSIGNED;
  const shown = rejected?.value ?? current;
  const status = assignmentState(item, rejected !== null);
  const note = rejected?.message ?? (item.conflict ? conflictNote(item.conflict) : null);
  const departure = toLocalParts(item.departureAt);
  const arrival = toLocalParts(item.arrivalAt);
  const arrivalLabel = `Đến ${formatTime(item.arrivalAt)}${arrival.date !== departure.date ? " hôm sau" : ""}`;
  const plate = item.vehiclePlateNumber ? formatPlateNumber(item.vehiclePlateNumber) : "Chưa gắn xe";
  const label = `Tài xế chuyến ${formatTime(item.departureAt)} ${item.routeName}`;

  function choose(value: string) {
    if (value === current) {
      setRejected(null);
      return;
    }
    if (item.reasonRequired) {
      setAsking(value);
      return;
    }
    save.mutate({ value, reason: null });
  }

  return (
    <tr className="border-b align-top">
      <td className={TABLE_CELL}>
        <TwoLines first={formatTime(item.departureAt)} second={arrivalLabel} />
      </td>
      <td className={TABLE_CELL}>
        <TwoLines first={item.routeName} second={formatDuration((Date.parse(item.arrivalAt) - Date.parse(item.departureAt)) / 1000)} />
      </td>
      <td className={cn(TABLE_CELL, "font-semibold text-vxn-ink")}>{plate}</td>
      <td className={TABLE_CELL}>
        <div className="flex flex-col gap-1">
          <div className="flex items-center gap-2">
            <Select value={shown} onValueChange={choose} disabled={!item.editable || save.isPending}>
              <SelectTrigger
                aria-label={label}
                aria-invalid={note !== null}
                className={cn("min-w-0 flex-1", note && "border-error-600")}
              >
                <SelectValue />
              </SelectTrigger>
              <SelectContent>
                <SelectItem value={UNASSIGNED}>Chưa phân công</SelectItem>
                {item.driver && !drivers.some((driver) => driver.id === item.driver!.employeeId) && (
                  <SelectItem value={item.driver.employeeId} disabled>
                    {item.driver.username} (không còn hoạt động)
                  </SelectItem>
                )}
                {drivers.map((driver) => (
                  <SelectItem key={driver.id} value={driver.id}>
                    {driver.username}
                  </SelectItem>
                ))}
              </SelectContent>
            </Select>
            {save.isPending && <LoaderCircle aria-label="Đang lưu phân công" className="size-4 shrink-0 animate-spin text-muted-foreground" />}
          </div>
          {note && (
            <p role="alert" className="text-xs leading-[18px] text-error-600">
              {note}
            </p>
          )}
        </div>
      </td>
      <td className={TABLE_CELL}>
        <Badge tone={status.tone}>{status.label}</Badge>
      </td>
      <ReasonDialog
        open={asking !== null}
        trip={`${formatTime(item.departureAt)} · ${item.routeName}`}
        pending={save.isPending}
        onCancel={() => setAsking(null)}
        onConfirm={(reason) => save.mutate({ value: asking!, reason })}
      />
    </tr>
  );
}

function ReasonDialog({
  open,
  trip,
  pending,
  onCancel,
  onConfirm
}: {
  open: boolean;
  trip: string;
  pending: boolean;
  onCancel: () => void;
  onConfirm: (reason: string) => void;
}) {
  const [reason, setReason] = useState("");
  const [error, setError] = useState<string | null>(null);
  function submit(event: FormEvent) {
    event.preventDefault();
    if (reason.trim().length < 3) {
      setError("Nhập lý do đổi phân công (ít nhất 3 ký tự).");
      return;
    }
    onConfirm(reason.trim());
  }
  return (
    <Dialog
      open={open}
      onOpenChange={(next) => {
        if (!next) {
          setReason("");
          setError(null);
          onCancel();
        }
      }}
    >
      <DialogContent>
        <form onSubmit={submit} noValidate className="flex flex-col gap-4">
          <DialogHeader>
            <DialogTitle>Đổi phân công chuyến sắp chạy?</DialogTitle>
            <DialogDescription>Chuyến {trip} sắp khởi hành hoặc đang chạy. Lý do được ghi vào nhật ký thay đổi.</DialogDescription>
          </DialogHeader>
          <FormField label="Lý do đổi phân công *" error={error ?? undefined}>
            {(control) => (
              <Textarea
                {...control}
                rows={3}
                maxLength={REASON_MAX_LENGTH}
                value={reason}
                onChange={(event) => {
                  setReason(event.target.value);
                  setError(null);
                }}
              />
            )}
          </FormField>
          <DialogFooter>
            <Button type="button" variant="outline" className={`${BUTTON} bg-card`} disabled={pending} onClick={onCancel}>
              Hủy
            </Button>
            <Button type="submit" className={BUTTON} disabled={pending}>
              {pending && <LoaderCircle className="size-[18px] animate-spin" />}
              Lưu phân công
            </Button>
          </DialogFooter>
        </form>
      </DialogContent>
    </Dialog>
  );
}

function TwoLines({ first, second }: { first: string; second: string }) {
  return (
    <div className="flex min-w-0 flex-col gap-0.5">
      <span className="truncate font-semibold text-vxn-ink">{first}</span>
      <span className="truncate text-xs leading-[18px] text-muted-foreground">{second}</span>
    </div>
  );
}
