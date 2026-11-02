"use client";

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
import { FormField } from "@vexenhanh/ui/components/form-field";
import { BUTTON } from "@vexenhanh/ui/components/list-parts";
import { Textarea } from "@vexenhanh/ui/components/textarea";
import { CircleAlert, LoaderCircle, TriangleAlert } from "lucide-react";
import { useState, type FormEvent } from "react";

import { formatLongDateTime } from "../../lib/operator-application/application-format";
import {
  describeRemoveError,
  formatPlateNumber,
  REMOVE_REASON_MAX_LENGTH,
  removeReasonError
} from "../../lib/moderation/moderation-format";
import { removeVehicleImage, type AdminVehicleImage } from "../../lib/moderation/vehicle-image-api";

/** Hộp thoại gỡ ảnh phương tiện (Figma ADM-10c): lý do bắt buộc 3–500 ký tự, gỡ là xóa hẳn. */
export function RemoveImageDialog({
  image,
  onClose,
  onRemoved
}: {
  image: AdminVehicleImage | null;
  onClose: () => void;
  onRemoved: (image: AdminVehicleImage) => void;
}) {
  const [pending, setPending] = useState(false);
  return (
    <Dialog open={image !== null} onOpenChange={(open) => !open && !pending && onClose()}>
      {image && (
        <RemoveForm key={image.id} image={image} onClose={onClose} onRemoved={onRemoved} onPendingChange={setPending} />
      )}
    </Dialog>
  );
}

function RemoveForm({
  image,
  onClose,
  onRemoved,
  onPendingChange
}: {
  image: AdminVehicleImage;
  onClose: () => void;
  onRemoved: (image: AdminVehicleImage) => void;
  onPendingChange: (pending: boolean) => void;
}) {
  const queryClient = useQueryClient();
  const [reason, setReason] = useState("");
  const [reasonMessage, setReasonMessage] = useState<string | null>(null);
  const [formError, setFormError] = useState<string | null>(null);
  const plate = formatPlateNumber(image.plateNumber);
  const run = useMutation({
    mutationFn: () => removeVehicleImage(image.id, reason.trim()),
    onMutate: () => onPendingChange(true),
    onSettled: () => onPendingChange(false),
    onSuccess: () => {
      void queryClient.invalidateQueries({ queryKey: ["admin-vehicle-images"] });
      onRemoved(image);
      onClose();
    },
    onError: (error) => {
      const described = describeRemoveError(error);
      setFormError(described.message);
      if (described.refresh) {
        void queryClient.invalidateQueries({ queryKey: ["admin-vehicle-images"] });
      }
    }
  });

  function submit(event: FormEvent) {
    event.preventDefault();
    setFormError(null);
    const invalid = removeReasonError(reason);
    setReasonMessage(invalid);
    if (!invalid) {
      run.mutate();
    }
  }

  return (
    <DialogContent className="sm:max-w-[560px]">
      <DialogHeader>
        <DialogTitle>Gỡ ảnh phương tiện</DialogTitle>
        <DialogDescription>
          {image.operatorName} · xe {plate}
          {image.caption ? ` · “${image.caption}”` : ""}
        </DialogDescription>
      </DialogHeader>
      <form noValidate onSubmit={submit} className="flex flex-col gap-4">
        <div className="flex items-center gap-4 rounded-lg bg-muted p-3">
          <img src={image.url} alt="" className="h-[60px] w-[104px] shrink-0 rounded-md object-cover" />
          <div className="flex min-w-0 flex-col gap-0.5 text-sm leading-5">
            <span className="text-vxn-ink">Tải lên {formatLongDateTime(image.createdAt)}</span>
            <span className="text-xs leading-[18px] text-muted-foreground">
              {image.isCover ? "Ảnh đại diện của xe — ảnh kế tiếp sẽ thành ảnh đại diện" : `Ảnh thứ ${image.position + 1} của xe`}
            </span>
          </div>
        </div>
        <div role="note" className="flex gap-3 rounded-lg bg-warning-50 px-4 py-3 text-sm leading-5 text-warning-700">
          <TriangleAlert className="mt-px size-5 shrink-0" />
          <p>Ảnh bị gỡ sẽ bị xóa khỏi trang công khai và không khôi phục được. Nhà xe nhận thông báo kèm lý do.</p>
        </div>
        <FormField label="Lý do gỡ ảnh *" helper="Lý do được lưu vào nhật ký audit." error={reasonMessage ?? undefined}>
          {(control) => (
            <Textarea
              {...control}
              name="reason"
              rows={3}
              maxLength={REMOVE_REASON_MAX_LENGTH}
              placeholder={`Nhập lý do (3–${REMOVE_REASON_MAX_LENGTH} ký tự)…`}
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
          <div role="alert" className="flex items-center gap-3 rounded-lg bg-error-50 px-4 py-3 text-sm leading-5 text-error-600">
            <CircleAlert className="size-5 shrink-0" />
            {formError}
          </div>
        )}
        <DialogFooter>
          <Button type="button" variant="outline" className={`${BUTTON} bg-card`} disabled={run.isPending} onClick={onClose}>
            Hủy
          </Button>
          <Button type="submit" variant="destructive" className={BUTTON} disabled={run.isPending}>
            {run.isPending && <LoaderCircle className="size-[18px] animate-spin" />}
            Gỡ ảnh
          </Button>
        </DialogFooter>
      </form>
    </DialogContent>
  );
}
