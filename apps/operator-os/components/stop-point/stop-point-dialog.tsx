"use client";

import { zodResolver } from "@hookform/resolvers/zod";
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
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
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue
} from "@vexenhanh/ui/components/select";
import { Textarea } from "@vexenhanh/ui/components/textarea";
import { CircleAlert, LoaderCircle } from "lucide-react";
import { useMemo, useState } from "react";
import { Controller, useForm, type Resolver } from "react-hook-form";

import { ApiError } from "../../lib/auth/api-client";
import {
  createStopPoint,
  createStopPointProposal,
  listProvinces,
  listWards,
  resubmitStopPointProposal,
  updateStopPoint,
  type StopPoint,
  type StopPointProposal
} from "../../lib/stop-point/stop-point-api";
import {
  ADDRESS_MAX_LENGTH,
  describeSaveError,
  DESCRIPTION_MAX_LENGTH,
  EMPTY_PROPOSAL_FORM,
  EMPTY_STOP_POINT_FORM,
  LEGAL_BASIS_MAX_LENGTH,
  NAME_MAX_LENGTH,
  proposalFormSchema,
  stopPointFormSchema,
  toProposalFormValues,
  toProposalInput,
  toStopPointFormValues,
  toStopPointInput
} from "../../lib/stop-point/stop-point-form";
import {
  OWN_STOP_POINT_TYPES,
  PROPOSAL_STOP_POINT_TYPES,
  STOP_POINT_STATUS,
  STOP_POINT_TYPE_LABELS
} from "../../lib/stop-point/stop-point-format";
import { FormField } from "../form-field";
import { BUTTON } from "../list-parts";

/** Hộp thoại đang mở cho việc gì: thêm / sửa điểm riêng, gửi đề xuất mới hay sửa đề xuất bị từ chối. */
export type StopPointDialogTarget =
  | { kind: "create" }
  | { kind: "edit"; stopPoint: StopPoint }
  | { kind: "propose" }
  | { kind: "resubmit"; proposal: StopPointProposal };

// Một form cho cả điểm riêng lẫn đề xuất: hai loại chỉ khác ô trạng thái / căn cứ công bố. Zod schema của
// từng loại bỏ ô không thuộc về nó khi kiểm, nên kiểu của form là hợp các ô của cả hai.
type DialogValues = {
  name: string;
  type: string;
  status: string;
  address: string;
  provinceId: string;
  wardId: string;
  latitude: string;
  longitude: string;
  legalBasis: string;
  description: string;
};

const COPY = {
  create: {
    title: "Thêm điểm dừng",
    description: "Văn phòng trung chuyển hoặc trạm dừng nghỉ của nhà xe. Lưu xong dùng được ngay khi lập tuyến.",
    submit: "Lưu điểm dừng",
    pending: "Đang lưu…"
  },
  edit: {
    title: "Sửa điểm dừng",
    description: "Cập nhật thông tin điểm dừng của nhà xe.",
    submit: "Lưu điểm dừng",
    pending: "Đang lưu…"
  },
  propose: {
    title: "Đề xuất điểm dừng",
    description:
      "Dành cho bến xe hoặc điểm dừng đón trả khách chưa có trong danh mục. Platform kiểm tra và duyệt trước khi đưa điểm vào danh mục.",
    submit: "Gửi đề xuất",
    pending: "Đang gửi…"
  },
  resubmit: {
    title: "Sửa và gửi lại đề xuất",
    description: "Chỉnh thông tin theo lý do từ chối rồi gửi lại để Platform xem xét.",
    submit: "Gửi lại đề xuất",
    pending: "Đang gửi…"
  }
} as const;

/**
 * Hộp thoại Thêm / Sửa điểm dừng riêng và Đề xuất điểm dừng (Figma 03, 04; FR-OPS-17, BR-38). Bản đồ chọn
 * vị trí thuộc TASK-TRN-014 — trước đó tọa độ nhập tay.
 */
export function StopPointDialog({
  target,
  onClose,
  onSaved
}: {
  target: StopPointDialogTarget | null;
  onClose: () => void;
  /** Gọi sau khi lưu thành công, kèm câu báo để màn danh sách hiện. */
  onSaved: (message: string) => void;
}) {
  return (
    <Dialog open={target !== null} onOpenChange={(open) => !open && onClose()}>
      {target && <DialogForm target={target} onClose={onClose} onSaved={onSaved} />}
    </Dialog>
  );
}

function initialValues(target: StopPointDialogTarget): DialogValues {
  const blank = { status: "ACTIVE", legalBasis: "" };
  switch (target.kind) {
    case "create":
      return { ...blank, ...EMPTY_STOP_POINT_FORM };
    case "edit":
      return { ...blank, ...toStopPointFormValues(target.stopPoint) };
    case "propose":
      return { ...blank, ...EMPTY_PROPOSAL_FORM };
    case "resubmit":
      return { ...blank, ...toProposalFormValues(target.proposal) };
  }
}

function DialogForm({
  target,
  onClose,
  onSaved
}: {
  target: StopPointDialogTarget;
  onClose: () => void;
  onSaved: (message: string) => void;
}) {
  const queryClient = useQueryClient();
  const isProposal = target.kind === "propose" || target.kind === "resubmit";
  const copy = COPY[target.kind];
  const [formError, setFormError] = useState<string | null>(null);

  const form = useForm<DialogValues>({
    resolver: zodResolver(isProposal ? proposalFormSchema : stopPointFormSchema) as unknown as Resolver<DialogValues>,
    defaultValues: initialValues(target)
  });
  const { errors, isDirty } = form.formState;
  const provinceId = form.watch("provinceId");
  const legalBasis = form.watch("legalBasis");
  const description = form.watch("description");

  const provinces = useQuery({ queryKey: ["catalog", "provinces"], queryFn: listProvinces, staleTime: 300_000 });
  const wards = useQuery({
    queryKey: ["catalog", "wards", provinceId],
    queryFn: () => listWards(provinceId),
    enabled: provinceId !== "",
    staleTime: 300_000
  });

  // Tỉnh / phường đã bị ngừng trong danh mục vẫn giữ được trên điểm cũ (API cho phép) → thêm một lựa chọn
  // để không mất khi lưu lại.
  const stored = target.kind === "edit" ? target.stopPoint : target.kind === "resubmit" ? target.proposal : null;
  const provinceOptions = useMemo(() => {
    const options = (provinces.data ?? []).map((province) => ({ id: province.id, label: province.name }));
    if (provinces.data && stored && !options.some((option) => option.id === stored.provinceId)) {
      options.push({ id: stored.provinceId, label: "Tỉnh / thành đã ngừng dùng" });
    }
    return options;
  }, [provinces.data, stored]);
  const wardOptions = useMemo(() => {
    const options = (wards.data ?? []).map((ward) => ({ id: ward.id, label: ward.name }));
    if (wards.data && stored && stored.provinceId === provinceId && !options.some((option) => option.id === stored.wardId)) {
      options.push({ id: stored.wardId, label: "Phường / xã đã ngừng dùng" });
    }
    return options;
  }, [wards.data, stored, provinceId]);

  const save = useMutation({
    mutationFn: async (values: DialogValues): Promise<string> => {
      switch (target.kind) {
        case "create": {
          const saved = await createStopPoint(toStopPointInput(stopPointFormSchema.parse(values)));
          return `Đã thêm điểm dừng “${saved.name}”.`;
        }
        case "edit": {
          const saved = await updateStopPoint(target.stopPoint.id, toStopPointInput(stopPointFormSchema.parse(values)));
          return `Đã lưu điểm dừng “${saved.name}”.`;
        }
        case "propose": {
          const saved = await createStopPointProposal(toProposalInput(proposalFormSchema.parse(values)));
          return `Đã gửi đề xuất “${saved.name}”. Platform sẽ xem xét và phản hồi.`;
        }
        case "resubmit": {
          const saved = await resubmitStopPointProposal(
            target.proposal.id,
            toProposalInput(proposalFormSchema.parse(values))
          );
          return `Đã gửi lại đề xuất “${saved.name}”.`;
        }
      }
    },
    onSuccess: (message) => {
      void queryClient.invalidateQueries({ queryKey: [isProposal ? "stop-point-proposals" : "stop-points"] });
      onSaved(message);
      onClose();
    },
    onError: (error) => {
      const { field, message } = describeSaveError(error, isProposal ? "proposal" : "stopPoint");
      if (field) {
        form.setError(field, { message }, { shouldFocus: true });
      } else {
        setFormError(message);
      }
      if (error instanceof ApiError && error.code === "CATALOG_ITEM_UNAVAILABLE") {
        // Danh mục vừa đổi: tải lại để ô chọn không còn mục đã ngừng.
        void queryClient.invalidateQueries({ queryKey: ["catalog"] });
      }
    }
  });

  function submit(values: DialogValues) {
    setFormError(null);
    save.mutate(values);
  }

  const catalogFailed = provinces.isError || wards.isError;
  const typeOptions = isProposal ? PROPOSAL_STOP_POINT_TYPES : OWN_STOP_POINT_TYPES;

  return (
    <DialogContent
      className="sm:max-w-2xl"
      // Đang nhập dở thì bấm nhầm ra ngoài không làm mất dữ liệu; vẫn đóng được bằng ✕, Hủy hoặc Esc.
      onInteractOutside={(event) => isDirty && event.preventDefault()}
    >
      <DialogHeader>
        <DialogTitle>{copy.title}</DialogTitle>
        <DialogDescription>{copy.description}</DialogDescription>
      </DialogHeader>

      {target.kind === "resubmit" && target.proposal.rejectionReason && (
        <p className="rounded-lg bg-error-50 px-4 py-3 text-sm leading-5 text-error-600">
          Lý do bị từ chối: {target.proposal.rejectionReason}
        </p>
      )}
      {formError && (
        <div role="alert" className="flex items-center gap-3 rounded-lg bg-error-50 px-4 py-3 text-sm leading-5 text-error-600">
          <CircleAlert className="size-5 shrink-0" />
          {formError}
        </div>
      )}
      {catalogFailed && (
        <div role="alert" className="flex flex-wrap items-center gap-3 rounded-lg bg-error-50 px-4 py-3">
          <p className="min-w-0 flex-1 text-sm leading-5 text-error-600">Chưa tải được danh sách tỉnh / thành, phường / xã.</p>
          <Button
            type="button"
            variant="outline"
            className={`${BUTTON} bg-card`}
            onClick={() => [provinces, wards].filter((query) => query.isError).forEach((query) => void query.refetch())}
          >
            Thử lại
          </Button>
        </div>
      )}

      <form
        noValidate
        onSubmit={(event) => void form.handleSubmit(submit)(event)}
        className="grid gap-x-4 gap-y-4 sm:grid-cols-2"
      >
        <FormField
          label="Tên điểm dừng *"
          helper={`Tối đa ${NAME_MAX_LENGTH} ký tự${isProposal ? "" : " · không trùng tên trong nhà xe"}`}
          error={errors.name?.message}
          className="sm:col-span-2"
        >
          {(control) => <Input {...control} {...form.register("name")} autoComplete="off" maxLength={NAME_MAX_LENGTH} />}
        </FormField>

        <FormField
          label="Loại điểm *"
          helper={isProposal ? "Chỉ chọn được Bến xe hoặc Điểm dừng đón trả khách" : undefined}
          error={errors.type?.message}
          className={isProposal ? "sm:col-span-2" : undefined}
        >
          {(control) => (
            <Controller
              control={form.control}
              name="type"
              render={({ field }) => (
                <Select value={field.value} onValueChange={field.onChange}>
                  <SelectTrigger {...control} onBlur={field.onBlur}>
                    <SelectValue placeholder="Chọn loại điểm" />
                  </SelectTrigger>
                  <SelectContent>
                    {typeOptions.map((type) => (
                      <SelectItem key={type} value={type}>
                        {STOP_POINT_TYPE_LABELS[type]}
                      </SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              )}
            />
          )}
        </FormField>

        {!isProposal && (
          <FormField label="Trạng thái *" error={errors.status?.message}>
            {(control) => (
              <Controller
                control={form.control}
                name="status"
                render={({ field }) => (
                  <Select value={field.value} onValueChange={field.onChange}>
                    <SelectTrigger {...control} onBlur={field.onBlur}>
                      <SelectValue />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectItem value="ACTIVE">{STOP_POINT_STATUS.ACTIVE.label}</SelectItem>
                      <SelectItem value="INACTIVE">{STOP_POINT_STATUS.INACTIVE.label}</SelectItem>
                    </SelectContent>
                  </Select>
                )}
              />
            )}
          </FormField>
        )}

        <FormField label="Địa chỉ *" error={errors.address?.message} className="sm:col-span-2">
          {(control) => (
            <Input {...control} {...form.register("address")} autoComplete="off" maxLength={ADDRESS_MAX_LENGTH} />
          )}
        </FormField>

        <FormField label="Tỉnh / thành *" error={errors.provinceId?.message}>
          {(control) => (
            <Controller
              control={form.control}
              name="provinceId"
              render={({ field }) => (
                <Select
                  value={field.value}
                  onValueChange={(value) => {
                    field.onChange(value);
                    // Phường / xã thuộc tỉnh cũ không còn hợp lệ.
                    form.setValue("wardId", "", { shouldDirty: true });
                  }}
                  disabled={provinces.isPending}
                >
                  <SelectTrigger {...control} onBlur={field.onBlur}>
                    <SelectValue placeholder={provinces.isPending ? "Đang tải…" : "Chọn tỉnh / thành"} />
                  </SelectTrigger>
                  <SelectContent>
                    {provinceOptions.map((option) => (
                      <SelectItem key={option.id} value={option.id}>
                        {option.label}
                      </SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              )}
            />
          )}
        </FormField>

        <FormField label="Phường / xã *" error={errors.wardId?.message}>
          {(control) => (
            <Controller
              control={form.control}
              name="wardId"
              render={({ field }) => (
                <Select
                  value={field.value}
                  onValueChange={field.onChange}
                  disabled={provinceId === "" || wards.isPending}
                >
                  <SelectTrigger {...control} onBlur={field.onBlur}>
                    <SelectValue
                      placeholder={
                        provinceId === "" ? "Chọn tỉnh / thành trước" : wards.isPending ? "Đang tải…" : "Chọn phường / xã"
                      }
                    />
                  </SelectTrigger>
                  <SelectContent>
                    {wardOptions.map((option) => (
                      <SelectItem key={option.id} value={option.id}>
                        {option.label}
                      </SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              )}
            />
          )}
        </FormField>

        <FormField label="Vĩ độ *" helper="Từ -90 đến 90, ví dụ 11.9404" error={errors.latitude?.message}>
          {(control) => <Input {...control} {...form.register("latitude")} autoComplete="off" inputMode="decimal" />}
        </FormField>
        <FormField label="Kinh độ *" helper="Từ -180 đến 180, ví dụ 108.4583" error={errors.longitude?.message}>
          {(control) => <Input {...control} {...form.register("longitude")} autoComplete="off" inputMode="decimal" />}
        </FormField>

        {isProposal && (
          <FormField
            label="Căn cứ công bố *"
            helper={`Số và ngày văn bản công bố của cơ quan có thẩm quyền · ${legalBasis.length} / ${LEGAL_BASIS_MAX_LENGTH} ký tự`}
            error={errors.legalBasis?.message}
            className="sm:col-span-2"
          >
            {(control) => (
              <Textarea {...control} {...form.register("legalBasis")} rows={3} maxLength={LEGAL_BASIS_MAX_LENGTH} />
            )}
          </FormField>
        )}

        <FormField
          label="Ghi chú"
          helper={`Tùy chọn · ${description.length} / ${DESCRIPTION_MAX_LENGTH} ký tự`}
          error={errors.description?.message}
          className="sm:col-span-2"
        >
          {(control) => (
            <Textarea {...control} {...form.register("description")} rows={3} maxLength={DESCRIPTION_MAX_LENGTH} />
          )}
        </FormField>

        <DialogFooter className="sm:col-span-2">
          <Button type="button" variant="outline" className={`${BUTTON} bg-card`} disabled={save.isPending} onClick={onClose}>
            Hủy
          </Button>
          <Button type="submit" className={`${BUTTON} min-w-36`} disabled={save.isPending}>
            {save.isPending && <LoaderCircle className="size-[18px] animate-spin" />}
            {save.isPending ? copy.pending : copy.submit}
          </Button>
        </DialogFooter>
      </form>
    </DialogContent>
  );
}
