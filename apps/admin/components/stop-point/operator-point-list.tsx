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
import { FormField } from "@vexenhanh/ui/components/form-field";
import {
  ALL,
  FilterSelect,
  SearchField,
  TABLE,
  TABLE_CELL,
  TABLE_HEAD_CELL,
  TABLE_HEAD_ROW,
  TableSkeleton,
  useDebouncedValue
} from "@vexenhanh/ui/components/list-controls";
import { BUTTON, ListLoadMoreFooter, ListStatePanel } from "@vexenhanh/ui/components/list-parts";
import { Textarea } from "@vexenhanh/ui/components/textarea";
import { CircleAlert, FileX2, Info, LoaderCircle, Lock, LockOpen, RefreshCw, TriangleAlert } from "lucide-react";
import { useMemo, useState, type FormEvent, type ReactNode } from "react";

import {
  listOperatorStopPoints,
  listProvinces,
  suspendStopPoint,
  unsuspendStopPoint,
  type OperatorStopPoint
} from "../../lib/stop-point/stop-point-api";
import {
  describeStopPointError,
  formatCount,
  OPERATOR_POINT_STATUS,
  OPERATOR_POINT_TYPES,
  REASON_MAX_LENGTH,
  reasonError,
  STOP_POINT_TYPE_LABELS
} from "../../lib/stop-point/stop-point-format";

type Action = { kind: "suspend" | "unsuspend"; stopPoint: OperatorStopPoint };

/**
 * Tab "Của nhà xe" (Figma ADM-05d; BR-81): điểm riêng của mọi nhà xe, lọc loại / tỉnh / trạng thái, tìm không
 * dấu. Admin không sửa điểm riêng — chỉ khóa (kèm lý do) / mở khóa.
 */
export function OperatorPointList({ onNotice }: { onNotice: (message: string) => void }) {
  const [search, setSearch] = useState("");
  const [type, setType] = useState<string>(ALL);
  const [provinceId, setProvinceId] = useState<string>(ALL);
  const [status, setStatus] = useState<string>(ALL);
  const q = useDebouncedValue(search.trim());
  const [action, setAction] = useState<Action | null>(null);

  const filters = {
    q: q || undefined,
    type: type === ALL ? undefined : type,
    provinceId: provinceId === ALL ? undefined : provinceId,
    status: status === ALL ? undefined : status
  };
  const pages = useInfiniteQuery({
    queryKey: ["admin-stop-points", "operator", filters],
    queryFn: ({ pageParam }) => listOperatorStopPoints(filters, pageParam),
    initialPageParam: null as string | null,
    getNextPageParam: (last) => last.nextCursor
  });
  const provinces = useQuery({ queryKey: ["catalog", "provinces"], queryFn: listProvinces, staleTime: 300_000 });
  const items = useMemo(() => pages.data?.pages.flatMap((page) => page.items) ?? [], [pages.data]);
  const total = pages.data?.pages[0]?.total ?? 0;
  const filtered = q !== "" || type !== ALL || provinceId !== ALL || status !== ALL;

  let body: ReactNode;
  let footer: ReactNode = null;
  if (pages.isError && items.length === 0) {
    body = (
      <ListStatePanel
        compact
        icon={<CircleAlert className="size-6 text-warning-700" />}
        title="Không tải được điểm dừng của nhà xe"
        description="Kiểm tra kết nối mạng rồi thử lại."
        action={
          <Button className={`${BUTTON} w-36`} onClick={() => void pages.refetch()}>
            <RefreshCw className="size-[18px]" />
            Thử lại
          </Button>
        }
      />
    );
  } else if (pages.isPending) {
    body = <TableSkeleton label="Đang tải điểm dừng của nhà xe" rows={5} />;
  } else if (items.length === 0) {
    body = (
      <ListStatePanel
        compact
        icon={<FileX2 className="size-6 text-vxn-fg-3" />}
        title={filtered ? "Không có điểm dừng phù hợp" : "Nhà xe chưa có điểm dừng riêng"}
        description={filtered ? "Đổi từ khóa hoặc bộ lọc." : "Văn phòng trung chuyển và trạm dừng nghỉ nhà xe tự tạo sẽ hiện ở đây."}
      />
    );
  } else {
    body = <OperatorPointTable items={items} onAction={setAction} />;
    footer = (
      <ListLoadMoreFooter
        hasMore={pages.hasNextPage}
        loading={pages.isFetchingNextPage}
        failed={pages.isFetchNextPageError}
        loadedText={`Đã tải ${formatCount(items.length)} / ${formatCount(total)} điểm dừng`}
        endText={`Đã hiển thị tất cả ${formatCount(items.length)} điểm dừng`}
        errorText="Chưa tải thêm được. Các dòng đã tải vẫn được giữ lại."
        onLoadMore={() => void pages.fetchNextPage()}
      />
    );
  }

  return (
    <>
      <section aria-label="Điểm dừng của nhà xe" className="flex flex-col rounded-xl border bg-card p-6">
        <div className="flex flex-wrap items-end gap-4 pb-5">
          <SearchField label="Tìm điểm dừng" placeholder="Tên hoặc địa chỉ" value={search} onChange={setSearch} />
          <FilterSelect
            label="Loại điểm"
            allLabel="Tất cả"
            value={type}
            onChange={setType}
            options={OPERATOR_POINT_TYPES.map((value) => ({ value, label: STOP_POINT_TYPE_LABELS[value] }))}
            className="w-52"
          />
          <FilterSelect
            label="Tỉnh / thành"
            allLabel="Tất cả"
            value={provinceId}
            onChange={setProvinceId}
            options={(provinces.data ?? []).map((province) => ({ value: province.id, label: province.name }))}
            disabled={!provinces.data}
            className="w-52"
          />
          <FilterSelect
            label="Trạng thái"
            allLabel="Tất cả"
            value={status}
            onChange={setStatus}
            options={(["ACTIVE", "INACTIVE", "SUSPENDED"] as const).map((value) => ({
              value,
              label: OPERATOR_POINT_STATUS[value].label
            }))}
            className="w-44"
          />
        </div>
        <div className="min-h-[240px]">{body}</div>
        {footer && <div className="flex min-h-14 flex-wrap items-center gap-3 pt-5">{footer}</div>}
      </section>
      <div className="flex items-center gap-4 rounded-lg bg-accent px-5 py-4">
        <Info className="size-5 shrink-0 text-accent-foreground" />
        <p className="min-w-0 flex-1 text-sm leading-5 text-accent-foreground">
          Admin không sửa điểm dừng riêng của nhà xe, chỉ khóa khi sai lệch hoặc vi phạm. Điểm bị khóa không gắn mới vào
          tuyến và chuyến dùng điểm đó không mở bán mới được; nhà xe không tự mở lại điểm bị khóa.
        </p>
      </div>
      <SuspensionDialog action={action} onClose={() => setAction(null)} onDone={onNotice} />
    </>
  );
}

// Tỉ lệ cột theo Figma ADM-05d (tên co giãn / 165 / 165 / 150 / 60 / 165 / 90 trên bảng rộng 1056).
const COLUMNS = ["", "w-[15.5%]", "w-[15.5%]", "w-[14%]", "w-[6.5%]", "w-[16%]", "w-[104px]"];
const HEADINGS = ["Tên và địa chỉ", "Loại điểm", "Nhà xe", "Tỉnh / thành", "Số tuyến", "Trạng thái", ""];

function OperatorPointTable({ items, onAction }: { items: OperatorStopPoint[]; onAction: (action: Action) => void }) {
  return (
    <div className="relative overflow-x-auto">
      <table className={`${TABLE} min-w-[960px]`}>
        <colgroup>
          {COLUMNS.map((width, index) => (
            <col key={index} className={width} />
          ))}
        </colgroup>
        <thead>
          <tr className={TABLE_HEAD_ROW}>
            {HEADINGS.map((heading, index) => (
              <th key={index} scope="col" className={`${TABLE_HEAD_CELL} ${index === 4 ? "text-right" : ""}`}>
                {heading || <span className="sr-only">Thao tác</span>}
              </th>
            ))}
          </tr>
        </thead>
        <tbody>
          {items.map((item) => {
            const status = OPERATOR_POINT_STATUS[item.status];
            const suspended = item.status === "SUSPENDED";
            return (
              <tr key={item.id} className="h-[76px] border-b">
                <td className={TABLE_CELL}>
                  <div className="flex min-w-0 flex-col gap-1">
                    <span className="truncate font-semibold text-vxn-ink">{item.name}</span>
                    <span className="truncate text-xs leading-[18px] text-muted-foreground">{item.address}</span>
                  </div>
                </td>
                <td className={TABLE_CELL}>{STOP_POINT_TYPE_LABELS[item.type]}</td>
                <td className={`${TABLE_CELL} truncate`}>{item.operatorName}</td>
                <td className={`${TABLE_CELL} truncate`}>{item.provinceName}</td>
                <td className={`${TABLE_CELL} text-right`}>{item.routeCount}</td>
                <td className={TABLE_CELL}>
                  <div className="flex min-w-0 flex-col items-start gap-1">
                    <Badge tone={status.tone}>{status.label}</Badge>
                    {item.suspensionReason && (
                      <span className="line-clamp-2 text-xs leading-[18px] text-muted-foreground" title={item.suspensionReason}>
                        {item.suspensionReason}
                      </span>
                    )}
                  </div>
                </td>
                <td className={TABLE_CELL}>
                  <Button
                    variant="ghost"
                    className="h-9 px-2 text-sm font-semibold text-vxn-ink"
                    aria-label={suspended ? `Mở khóa ${item.name}` : `Khóa ${item.name}`}
                    onClick={() => onAction({ kind: suspended ? "unsuspend" : "suspend", stopPoint: item })}
                  >
                    {suspended ? "Mở khóa" : "Khóa"}
                    {suspended ? <LockOpen className="size-4" /> : <Lock className="size-4" />}
                  </Button>
                </td>
              </tr>
            );
          })}
        </tbody>
      </table>
    </div>
  );
}

/** Hộp thoại khóa (lý do bắt buộc, Figma ADM-05e) / mở khóa một điểm riêng. */
function SuspensionDialog({
  action,
  onClose,
  onDone
}: {
  action: Action | null;
  onClose: () => void;
  onDone: (message: string) => void;
}) {
  const [pending, setPending] = useState(false);
  return (
    <Dialog open={action !== null} onOpenChange={(open) => !open && !pending && onClose()}>
      {action && <SuspensionForm action={action} onClose={onClose} onDone={onDone} onPendingChange={setPending} />}
    </Dialog>
  );
}

function SuspensionForm({
  action,
  onClose,
  onDone,
  onPendingChange
}: {
  action: Action;
  onClose: () => void;
  onDone: (message: string) => void;
  onPendingChange: (pending: boolean) => void;
}) {
  const queryClient = useQueryClient();
  const suspend = action.kind === "suspend";
  const { stopPoint } = action;
  const [reason, setReason] = useState("");
  const [reasonMessage, setReasonMessage] = useState<string | null>(null);
  const [formError, setFormError] = useState<string | null>(null);
  const run = useMutation({
    mutationFn: () => (suspend ? suspendStopPoint(stopPoint.id, reason.trim()) : unsuspendStopPoint(stopPoint.id)),
    onMutate: () => onPendingChange(true),
    onSettled: () => onPendingChange(false),
    onSuccess: (saved) => {
      void queryClient.invalidateQueries({ queryKey: ["admin-stop-points"] });
      onDone(suspend ? `Đã khóa “${saved.name}”.` : `Đã mở khóa “${saved.name}”.`);
      onClose();
    },
    onError: (error) => {
      const described = describeStopPointError(error);
      setFormError(described.message);
      if (described.refresh) {
        void queryClient.invalidateQueries({ queryKey: ["admin-stop-points"] });
      }
    }
  });

  function submit(event: FormEvent) {
    event.preventDefault();
    setFormError(null);
    if (suspend) {
      const invalid = reasonError(reason);
      setReasonMessage(invalid);
      if (invalid) {
        return;
      }
    }
    run.mutate();
  }

  return (
    <DialogContent className="sm:max-w-[520px]">
      <DialogHeader>
        <DialogTitle>{suspend ? "Khóa điểm dừng" : "Mở khóa điểm dừng"}</DialogTitle>
        <DialogDescription>
          {stopPoint.name} · {stopPoint.operatorName}
        </DialogDescription>
      </DialogHeader>
      <form noValidate onSubmit={submit} className="flex flex-col gap-4">
        <div className="flex flex-col gap-2 rounded-lg bg-muted px-4 py-3 text-sm leading-5">
          <p className="font-semibold text-vxn-ink">Mức ảnh hưởng</p>
          <div className="flex justify-between gap-4">
            <span className="text-muted-foreground">Tuyến đang dùng điểm này</span>
            <span className="text-vxn-ink">{stopPoint.routeCount} tuyến</span>
          </div>
        </div>
        {suspend ? (
          <div role="note" className="flex gap-3 rounded-lg bg-warning-50 px-4 py-3 text-sm leading-5 text-warning-700">
            <TriangleAlert className="mt-px size-5 shrink-0" />
            <p>
              Sau khi khóa, điểm này không gắn mới vào tuyến và các chuyến dùng điểm này không mở bán mới. Chủ nhà xe nhận
              email kèm lý do và thấy lý do ở màn Điểm dừng; nhà xe không tự mở lại được.
            </p>
          </div>
        ) : (
          <p className="text-sm leading-5 text-vxn-fg-1">
            Điểm trở lại Hoạt động, nhà xe sửa và gắn vào tuyến được như trước. Lý do khóa cũ:{" "}
            <span className="font-medium">{stopPoint.suspensionReason}</span>
          </p>
        )}
        {suspend && (
          <FormField label="Lý do *" helper="Lý do được lưu vào nhật ký audit và hiện cho nhà xe." error={reasonMessage ?? undefined}>
            {(control) => (
              <Textarea
                {...control}
                name="reason"
                rows={3}
                maxLength={REASON_MAX_LENGTH}
                placeholder={`Nhập lý do (1–${REASON_MAX_LENGTH} ký tự)…`}
                value={reason}
                disabled={run.isPending}
                autoFocus
                onChange={(event) => {
                  setReason(event.target.value);
                  setReasonMessage(null);
                }}
              />
            )}
          </FormField>
        )}
        {formError && (
          <div role="alert" className="flex items-center gap-3 rounded-lg bg-error-50 px-4 py-3 text-sm leading-5 text-error-600">
            <CircleAlert className="size-5 shrink-0" />
            {formError}
          </div>
        )}
        <DialogFooter>
          <Button type="button" variant="outline" className={`${BUTTON} bg-card`} disabled={run.isPending} onClick={onClose}>
            Hủy
          </Button>
          <Button type="submit" variant={suspend ? "destructive" : "default"} className={BUTTON} disabled={run.isPending}>
            {run.isPending && <LoaderCircle className="size-[18px] animate-spin" />}
            {suspend ? "Khóa điểm dừng" : "Mở khóa"}
          </Button>
        </DialogFooter>
      </form>
    </DialogContent>
  );
}
