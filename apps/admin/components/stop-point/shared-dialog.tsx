"use client";

import { zodResolver } from "@hookform/resolvers/zod";
import { useMutation, useQueryClient } from "@tanstack/react-query";
import { Button } from "@vexenhanh/ui/components/button";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle
} from "@vexenhanh/ui/components/dialog";
import { BUTTON } from "@vexenhanh/ui/components/list-parts";
import { LocationPickerMap } from "@vexenhanh/ui/components/location-picker-map";
import { GOONG_MAPTILES_KEY } from "@vexenhanh/ui/lib/map-config";
import { formatCoordinate, markerKind, pointFromInputs } from "@vexenhanh/ui/lib/stop-map";
import { CircleAlert, LoaderCircle } from "lucide-react";
import { useState } from "react";
import { useForm, type Resolver } from "react-hook-form";

import {
  createSharedStopPoint,
  updateSharedStopPoint,
  type SharedStopPoint,
  type StopPointType
} from "../../lib/stop-point/stop-point-api";
import {
  describeStopPointError,
  EMPTY_SHARED_FORM,
  SHARED_TYPES,
  sharedFormSchema,
  toSharedFormValues,
  toSharedInput,
  type LocationFormValues
} from "../../lib/stop-point/stop-point-format";
import { CoordinateFields, LocationFields } from "./location-fields";

export type SharedDialogTarget = { kind: "create" } | { kind: "edit"; stopPoint: SharedStopPoint };

/**
 * Hộp thoại Thêm / Sửa điểm dùng chung (Figma ADM-05a "Thêm điểm dừng"; UC-24). Có khóa bản đồ thì cột phải là
 * bản đồ để bấm / kéo ghim lấy tọa độ (TASK-TRN-014); chưa có khóa thì tọa độ nhập tay.
 */
export function SharedDialog({
  target,
  onClose,
  onSaved
}: {
  target: SharedDialogTarget | null;
  onClose: () => void;
  onSaved: (message: string) => void;
}) {
  return (
    <Dialog open={target !== null} onOpenChange={(open) => !open && onClose()}>
      {target && <DialogForm target={target} onClose={onClose} onSaved={onSaved} />}
    </Dialog>
  );
}

function DialogForm({
  target,
  onClose,
  onSaved
}: {
  target: SharedDialogTarget;
  onClose: () => void;
  onSaved: (message: string) => void;
}) {
  const queryClient = useQueryClient();
  const [formError, setFormError] = useState<string | null>(null);
  const form = useForm<LocationFormValues>({
    resolver: zodResolver(sharedFormSchema) as unknown as Resolver<LocationFormValues>,
    defaultValues: target.kind === "edit" ? toSharedFormValues(target.stopPoint) : EMPTY_SHARED_FORM
  });
  const { isDirty } = form.formState;
  const selectedType = form.watch("type");
  const position = pointFromInputs(form.watch("latitude"), form.watch("longitude"));
  const mapKey = GOONG_MAPTILES_KEY;

  const save = useMutation({
    mutationFn: async (values: LocationFormValues) => {
      const input = toSharedInput(sharedFormSchema.parse(values));
      const saved =
        target.kind === "edit" ? await updateSharedStopPoint(target.stopPoint.id, input) : await createSharedStopPoint(input);
      return target.kind === "edit" ? `Đã lưu điểm dừng “${saved.name}”.` : `Đã thêm điểm dừng “${saved.name}”.`;
    },
    onSuccess: (message) => {
      void queryClient.invalidateQueries({ queryKey: ["admin-stop-points"] });
      onSaved(message);
      onClose();
    },
    onError: (error) => {
      const described = describeStopPointError(error);
      if (described.field === "form") {
        setFormError(described.message);
      } else {
        form.setError(described.field, { message: described.message }, { shouldFocus: true });
      }
      if (described.field === "wardId") {
        void queryClient.invalidateQueries({ queryKey: ["catalog"] });
      }
    }
  });

  return (
    <DialogContent
      className={mapKey ? "sm:max-w-2xl lg:max-w-[920px]" : "sm:max-w-2xl"}
      // Đang nhập dở thì bấm nhầm ra ngoài không làm mất dữ liệu; vẫn đóng được bằng ✕, Hủy hoặc Esc.
      onInteractOutside={(event) => isDirty && event.preventDefault()}
    >
      <DialogHeader>
        <DialogTitle>{target.kind === "edit" ? "Sửa điểm dừng dùng chung" : "Thêm điểm dừng dùng chung"}</DialogTitle>
        <DialogDescription>
          Bến xe, điểm dừng đón trả khách hoặc trạm dừng nghỉ mọi nhà xe dùng được khi lập tuyến. Không xóa được — chuyển
          sang Ngừng dùng để không gắn mới.
        </DialogDescription>
      </DialogHeader>
      {formError && (
        <div role="alert" className="flex items-center gap-3 rounded-lg bg-error-50 px-4 py-3 text-sm leading-5 text-error-600">
          <CircleAlert className="size-5 shrink-0" />
          {formError}
        </div>
      )}
      <form
        noValidate
        onSubmit={(event) =>
          void form.handleSubmit((values) => {
            setFormError(null);
            save.mutate(values);
          })(event)
        }
        className="flex flex-col gap-5"
      >
        <div className={mapKey ? "grid gap-x-6 gap-y-4 lg:grid-cols-[minmax(0,1fr)_380px]" : undefined}>
          <LocationFields
            form={form}
            typeOptions={SHARED_TYPES}
            showStatus
            showCoordinates={!mapKey}
            stored={target.kind === "edit" ? target.stopPoint : null}
          />
          {mapKey && (
            <div className="flex min-w-0 flex-col gap-4">
              <div className="flex flex-col gap-1.5">
                <p className="text-sm leading-none font-medium text-vxn-fg-1">Vị trí trên bản đồ</p>
                <LocationPickerMap
                  mapKey={mapKey}
                  value={position}
                  kind={selectedType === "" ? "busStation" : markerKind(selectedType as StopPointType)}
                  onChange={(point) => {
                    form.setValue("latitude", formatCoordinate(point.latitude), { shouldDirty: true, shouldValidate: true });
                    form.setValue("longitude", formatCoordinate(point.longitude), { shouldDirty: true, shouldValidate: true });
                  }}
                />
              </div>
              <div className="grid grid-cols-2 gap-4">
                <CoordinateFields form={form} />
              </div>
            </div>
          )}
        </div>
        <DialogFooter>
          <Button type="button" variant="outline" className={`${BUTTON} bg-card`} disabled={save.isPending} onClick={onClose}>
            Hủy
          </Button>
          <Button type="submit" className={`${BUTTON} min-w-36`} disabled={save.isPending}>
            {save.isPending && <LoaderCircle className="size-[18px] animate-spin" />}
            {save.isPending ? "Đang lưu…" : "Lưu điểm dừng"}
          </Button>
        </DialogFooter>
      </form>
    </DialogContent>
  );
}
