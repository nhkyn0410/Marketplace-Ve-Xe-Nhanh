"use client";

import { zodResolver } from "@hookform/resolvers/zod";
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
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
import { BUTTON, ListStatePanel } from "@vexenhanh/ui/components/list-parts";
import { MapMarker, MapView } from "@vexenhanh/ui/components/map";
import { MapDot, MapLegend } from "@vexenhanh/ui/components/map-parts";
import { Skeleton } from "@vexenhanh/ui/components/skeleton";
import { Textarea } from "@vexenhanh/ui/components/textarea";
import { ApiError } from "@vexenhanh/ui/lib/auth/api-client";
import { GOONG_MAPTILES_KEY } from "@vexenhanh/ui/lib/map-config";
import { formatCoordinate, pointFromInputs, roundPoint } from "@vexenhanh/ui/lib/stop-map";
import { ArrowLeft, Check, CircleAlert, CircleCheck, FileX2, LoaderCircle, RefreshCw, TriangleAlert } from "lucide-react";
import Link from "next/link";
import { useMemo, useState, type FormEvent, type ReactNode } from "react";
import { useForm, type Resolver } from "react-hook-form";

import { formatLongDateTime } from "../../lib/operator-application/application-format";
import { approveProposal, getProposal, rejectProposal, type Proposal } from "../../lib/stop-point/stop-point-api";
import {
  approvalFormSchema,
  describeStopPointError,
  PROPOSAL_STATUS,
  PROPOSAL_TYPES,
  REASON_MAX_LENGTH,
  reasonError,
  toApprovalFormValues,
  toApprovalInput,
  type LocationFormValues
} from "../../lib/stop-point/stop-point-format";
import { LocationFields } from "./location-fields";

const BACK = "/stop-points?tab=proposals";
const MAP_LEGEND = [
  { kind: "restStop", label: "Điểm đề xuất" },
  { kind: "muted", label: "Điểm đã có" }
] as const;

/**
 * Xem xét một đề xuất điểm dừng (Figma ADM-05c; LLD §6.13 bước 3): chỉnh tên, loại, địa chỉ, tọa độ, căn cứ rồi
 * duyệt (tạo điểm dùng chung), hoặc từ chối kèm lý do. Cảnh báo điểm dùng chung cùng loại trong 200 m.
 */
export function ProposalReview({ proposalId }: { proposalId: string }) {
  const proposal = useQuery({ queryKey: ["admin-stop-points", "proposal", proposalId], queryFn: () => getProposal(proposalId) });
  // Nằm ở đây, không trong form: form dựng lại sau khi duyệt / từ chối (khóa `updatedAt`) mà câu báo phải còn.
  const [notice, setNotice] = useState<string | null>(null);

  if (proposal.isPending) {
    return (
      <div role="status" aria-label="Đang tải đề xuất" className="flex flex-col gap-6">
        <Skeleton className="h-5 w-48" />
        <Skeleton className="h-10 w-2/3" />
        <Skeleton className="h-96 rounded-xl" />
      </div>
    );
  }
  if (proposal.isError) {
    const missing = proposal.error instanceof ApiError && proposal.error.status === 404;
    return (
      <div className="flex flex-col gap-6">
        <BackLink />
        <section className="rounded-xl border bg-card">
          <ListStatePanel
            icon={missing ? <FileX2 className="size-6 text-vxn-fg-3" /> : <CircleAlert className="size-6 text-warning-700" />}
            title={missing ? "Không tìm thấy đề xuất" : "Không tải được đề xuất"}
            description={missing ? "Đề xuất không tồn tại." : "Kiểm tra kết nối mạng rồi thử lại."}
            action={
              missing ? undefined : (
                <Button className={`${BUTTON} w-36`} onClick={() => void proposal.refetch()}>
                  <RefreshCw className="size-[18px]" />
                  Thử lại
                </Button>
              )
            }
          />
        </section>
      </div>
    );
  }
  // Khóa theo `updatedAt`: duyệt / từ chối xong thì form dựng lại theo dữ liệu mới.
  return <ReviewForm key={proposal.data.updatedAt} proposal={proposal.data} notice={notice} onNotice={setNotice} />;
}

function ReviewForm({
  proposal,
  notice,
  onNotice
}: {
  proposal: Proposal;
  notice: string | null;
  onNotice: (message: string) => void;
}) {
  const queryClient = useQueryClient();
  const pending = proposal.status === "PENDING";
  const status = PROPOSAL_STATUS[proposal.status];
  const [formError, setFormError] = useState<string | null>(null);
  const [rejecting, setRejecting] = useState(false);
  const form = useForm<LocationFormValues>({
    resolver: zodResolver(approvalFormSchema) as unknown as Resolver<LocationFormValues>,
    defaultValues: toApprovalFormValues(proposal)
  });
  const position = pointFromInputs(form.watch("latitude"), form.watch("longitude"));
  const nearest = proposal.nearby[0];
  // Khung nhìn ban đầu: điểm đề xuất + các điểm cùng loại ở gần (không đổi khi kéo ghim).
  const fitPoints = useMemo(
    () => [
      { latitude: proposal.latitude, longitude: proposal.longitude },
      ...proposal.nearby.map((item) => ({ latitude: item.latitude, longitude: item.longitude }))
    ],
    [proposal]
  );

  function refresh() {
    void queryClient.invalidateQueries({ queryKey: ["admin-stop-points"] });
  }

  const approve = useMutation({
    mutationFn: (values: LocationFormValues) => approveProposal(proposal.id, toApprovalInput(approvalFormSchema.parse(values))),
    // Điểm dùng chung mang tên Admin vừa chỉnh; đề xuất giữ tên nhà xe gửi.
    onSuccess: (_saved, values) => {
      onNotice(`Đã duyệt và thêm “${values.name.trim()}” vào danh mục dùng chung.`);
      refresh();
    },
    onError: (error) => {
      const described = describeStopPointError(error);
      if (described.field === "form") {
        setFormError(described.message);
      } else {
        form.setError(described.field, { message: described.message }, { shouldFocus: true });
      }
      if (described.refresh) {
        refresh();
      }
    }
  });

  return (
    <div className="flex flex-col gap-6">
      <BackLink />
      <header className="flex flex-wrap items-center gap-x-6 gap-y-3">
        <div className="flex min-w-0 flex-1 flex-col gap-1.5">
          <h1 className="text-[30px] leading-[38px] font-semibold text-vxn-ink">Đề xuất · {proposal.name}</h1>
          <p className="text-sm leading-5 text-muted-foreground">
            {proposal.operatorName} đề xuất lúc {formatLongDateTime(proposal.createdAt)}
          </p>
        </div>
        <div className="flex min-w-0 flex-wrap items-center gap-3">
          <Badge tone={status.tone}>{status.label}</Badge>
          {pending && (
            <>
              <Button
                variant="outline"
                className={`${BUTTON} bg-card text-error-600 hover:text-error-700`}
                disabled={approve.isPending}
                onClick={() => setRejecting(true)}
              >
                Từ chối
              </Button>
              <Button type="submit" form="proposal-review-form" className={BUTTON} disabled={approve.isPending}>
                {approve.isPending ? <LoaderCircle className="size-[18px] animate-spin" /> : <Check className="size-[18px]" />}
                Duyệt và thêm vào danh mục
              </Button>
            </>
          )}
        </div>
      </header>

      {notice && <Banner tone="success">{notice}</Banner>}
      {!notice && proposal.status === "APPROVED" && <Banner tone="success">Đề xuất đã được duyệt và có trong danh mục dùng chung.</Banner>}
      {proposal.status === "REJECTED" && proposal.rejectionReason && (
        <Banner tone="warning">Đã từ chối: {proposal.rejectionReason}. Nhà xe sửa và gửi lại thì đề xuất trở về Chờ duyệt.</Banner>
      )}
      {pending && nearest && (
        <Banner tone="warning">
          Có điểm cùng loại ở gần: “{nearest.name}” cách khoảng {nearest.distanceMeters} m. Hãy kiểm tra để tránh tạo điểm trùng.
        </Banner>
      )}
      {formError && (
        <div role="alert" className="flex items-center gap-3 rounded-lg bg-error-50 px-4 py-3 text-sm leading-5 text-error-600">
          <CircleAlert className="size-5 shrink-0" />
          {formError}
        </div>
      )}

      <div className="grid items-start gap-6 lg:grid-cols-[minmax(0,1fr)_410px]">
        <Card title="Thông tin điểm dừng" subtitle={pending ? "Có thể chỉnh tên, địa chỉ và tọa độ trước khi duyệt." : undefined}>
          <form
            id="proposal-review-form"
            noValidate
            onSubmit={(event: FormEvent) =>
              void form.handleSubmit((values) => {
                setFormError(null);
                approve.mutate(values);
              })(event)
            }
          >
            <LocationFields
              form={form}
              typeOptions={PROPOSAL_TYPES}
              showStatus={false}
              showCoordinates
              stored={proposal}
              disabled={!pending || approve.isPending}
            />
          </form>
        </Card>
        <div className="flex min-w-0 flex-col gap-6">
          {GOONG_MAPTILES_KEY && (
            <Card title="Vị trí trên bản đồ" subtitle={pending ? "Kéo ghim vàng để chỉnh tọa độ." : undefined}>
              <div className="flex flex-col gap-3">
                <MapView
                  mapKey={GOONG_MAPTILES_KEY}
                  label="Bản đồ vị trí đề xuất"
                  className="h-64"
                  fitPoints={fitPoints}
                  onClick={
                    pending
                      ? (point) => {
                          const rounded = roundPoint(point);
                          form.setValue("latitude", formatCoordinate(rounded.latitude), { shouldDirty: true, shouldValidate: true });
                          form.setValue("longitude", formatCoordinate(rounded.longitude), { shouldDirty: true, shouldValidate: true });
                        }
                      : undefined
                  }
                >
                  {proposal.nearby.map((item) => (
                    <MapMarker key={item.id} point={{ latitude: item.latitude, longitude: item.longitude }}>
                      <MapDot kind="muted" />
                    </MapMarker>
                  ))}
                  {position && (
                    <MapMarker
                      point={position}
                      draggable={pending}
                      onDragEnd={(point) => {
                        const rounded = roundPoint(point);
                        form.setValue("latitude", formatCoordinate(rounded.latitude), { shouldDirty: true, shouldValidate: true });
                        form.setValue("longitude", formatCoordinate(rounded.longitude), { shouldDirty: true, shouldValidate: true });
                      }}
                    >
                      <MapDot kind="restStop" className={pending ? "cursor-grab active:cursor-grabbing" : undefined} />
                    </MapMarker>
                  )}
                </MapView>
                <MapLegend items={MAP_LEGEND} />
              </div>
            </Card>
          )}
          <Card title="Điểm cùng loại trong 200 m">
            {proposal.nearby.length === 0 ? (
              <p className="text-sm leading-5 text-muted-foreground">Không có điểm dùng chung cùng loại trong 200 m.</p>
            ) : (
              <ul className="flex flex-col gap-3">
                {proposal.nearby.map((item) => (
                  <li key={item.id} className="flex flex-col gap-0.5">
                    <span className="text-sm leading-5 font-semibold text-vxn-ink">{item.name}</span>
                    <span className="text-xs leading-[18px] text-muted-foreground">
                      Cách {item.distanceMeters} m · {item.routeCount} tuyến đang dùng
                    </span>
                  </li>
                ))}
              </ul>
            )}
          </Card>
        </div>
      </div>

      <RejectDialog
        open={rejecting}
        proposal={proposal}
        onClose={() => setRejecting(false)}
        onDone={(message) => {
          onNotice(message);
          refresh();
        }}
      />
    </div>
  );
}

function RejectDialog({
  open,
  proposal,
  onClose,
  onDone
}: {
  open: boolean;
  proposal: Proposal;
  onClose: () => void;
  onDone: (message: string) => void;
}) {
  const [reason, setReason] = useState("");
  const [reasonMessage, setReasonMessage] = useState<string | null>(null);
  const [formError, setFormError] = useState<string | null>(null);
  const run = useMutation({
    mutationFn: () => rejectProposal(proposal.id, reason.trim()),
    onSuccess: (saved) => {
      onDone(`Đã từ chối đề xuất “${saved.name}”. Nhà xe thấy lý do và có thể sửa rồi gửi lại.`);
      onClose();
    },
    onError: (error) => setFormError(describeStopPointError(error).message)
  });

  function submit(event: FormEvent) {
    event.preventDefault();
    setFormError(null);
    const invalid = reasonError(reason);
    setReasonMessage(invalid);
    if (!invalid) {
      run.mutate();
    }
  }

  return (
    <Dialog open={open} onOpenChange={(next) => !next && !run.isPending && onClose()}>
      <DialogContent className="sm:max-w-[520px]">
        <DialogHeader>
          <DialogTitle>Từ chối đề xuất</DialogTitle>
          <DialogDescription>
            {proposal.name} · {proposal.operatorName}
          </DialogDescription>
        </DialogHeader>
        <form noValidate onSubmit={submit} className="flex flex-col gap-4">
          <FormField label="Lý do *" helper="Chủ nhà xe nhận email kèm lý do này và sửa đề xuất theo đó." error={reasonMessage ?? undefined}>
            {(control) => (
              <Textarea
                {...control}
                name="reason"
                rows={3}
                maxLength={REASON_MAX_LENGTH}
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
          {formError && (
            <p role="alert" className="rounded-lg bg-error-50 px-4 py-3 text-sm leading-5 text-error-600">
              {formError}
            </p>
          )}
          <DialogFooter>
            <Button type="button" variant="outline" className={`${BUTTON} bg-card`} disabled={run.isPending} onClick={onClose}>
              Hủy
            </Button>
            <Button type="submit" variant="destructive" className={BUTTON} disabled={run.isPending}>
              {run.isPending && <LoaderCircle className="size-[18px] animate-spin" />}
              Từ chối đề xuất
            </Button>
          </DialogFooter>
        </form>
      </DialogContent>
    </Dialog>
  );
}

function BackLink() {
  return (
    <Link
      href={BACK}
      className="inline-flex w-fit items-center gap-2 rounded text-sm font-medium text-primary outline-none hover:underline focus-visible:ring-[3px] focus-visible:ring-ring/50"
    >
      <ArrowLeft className="size-4" />
      Quay lại danh sách chờ duyệt
    </Link>
  );
}

function Card({ title, subtitle, children }: { title: string; subtitle?: string; children: ReactNode }) {
  return (
    <section aria-label={title} className="flex flex-col gap-5 rounded-xl border bg-card p-6">
      <div className="flex flex-col gap-1">
        <h2 className="text-lg leading-7 font-semibold text-vxn-ink">{title}</h2>
        {subtitle && <p className="text-sm leading-5 text-muted-foreground">{subtitle}</p>}
      </div>
      {children}
    </section>
  );
}

function Banner({ tone, children }: { tone: "success" | "warning"; children: ReactNode }) {
  const Icon = tone === "success" ? CircleCheck : TriangleAlert;
  return (
    <div
      role="status"
      className={`flex items-center gap-3 rounded-lg px-5 py-3 text-sm leading-5 ${
        tone === "success" ? "bg-success-50 text-success-700" : "bg-warning-50 text-warning-700"
      }`}
    >
      <Icon className="size-5 shrink-0" />
      <span>{children}</span>
    </div>
  );
}
