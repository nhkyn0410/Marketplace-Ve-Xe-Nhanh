"use client";

import { Button } from "@vexenhanh/ui/components/button";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle
} from "@vexenhanh/ui/components/dialog";
import { Textarea } from "@vexenhanh/ui/components/textarea";
import { CircleAlert, LoaderCircle, Lock, LockOpen } from "lucide-react";
import { useState, type FormEvent } from "react";

import type { SeatSelection } from "../../lib/trip/trip-sale";
import { FormField } from "../form-field";
import { BUTTON } from "../list-parts";

/** Lý do hủy / ghi chú khóa chỗ dài tối đa 500 ký tự (giống máy chủ). */
const TEXT_MAX_LENGTH = 500;

function DialogError({ message }: { message: string }) {
  return (
    <div role="alert" className="flex items-center gap-3 rounded-lg bg-error-50 px-4 py-3 text-sm leading-5 text-error-600">
      <CircleAlert className="size-5 shrink-0" />
      {message}
    </div>
  );
}

/**
 * Hộp thoại hủy chuyến chưa có vé (Figma "05 · Hộp thoại hủy chuyến"; SRS §17.3): bắt buộc nhập lý do, hủy xong
 * không mở bán lại được. `summary` là dòng giờ khởi hành + xe của chuyến.
 */
export function CancelTripDialog({
  open,
  routeName,
  summary,
  pending,
  error,
  onClose,
  onConfirm
}: {
  open: boolean;
  routeName: string;
  summary: string;
  pending: boolean;
  error: string | null;
  onClose: () => void;
  onConfirm: (reason: string) => void;
}) {
  return (
    // Đang gửi thì không cho đóng: kết quả về sau sẽ không còn chỗ hiện.
    <Dialog open={open} onOpenChange={(next) => !next && !pending && onClose()}>
      {/* Chỉ dựng khi mở để mỗi lần mở là một ô lý do trống. */}
      {open && (
        <CancelTripForm
          routeName={routeName}
          summary={summary}
          pending={pending}
          error={error}
          onClose={onClose}
          onConfirm={onConfirm}
        />
      )}
    </Dialog>
  );
}

function CancelTripForm({
  routeName,
  summary,
  pending,
  error,
  onClose,
  onConfirm
}: {
  routeName: string;
  summary: string;
  pending: boolean;
  error: string | null;
  onClose: () => void;
  onConfirm: (reason: string) => void;
}) {
  const [reason, setReason] = useState("");
  const [missing, setMissing] = useState(false);

  function submit(event: FormEvent) {
    event.preventDefault();
    const text = reason.trim();
    // Lý do gửi cho khách bị ảnh hưởng (TRN-008) — tối thiểu 3 ký tự như máy chủ.
    if (text.length < 3) {
      setMissing(true);
      return;
    }
    onConfirm(text);
  }

  return (
    <DialogContent>
      <DialogHeader>
        <DialogTitle>Hủy chuyến {routeName}?</DialogTitle>
        <DialogDescription>{summary}</DialogDescription>
      </DialogHeader>
      <form noValidate onSubmit={submit} className="flex flex-col gap-5">
        <FormField
          label="Lý do hủy *"
          helper={`Bắt buộc · tối đa ${TEXT_MAX_LENGTH} ký tự · lưu vào lịch sử thay đổi của chuyến`}
          error={missing ? "Nhập lý do hủy chuyến (tối thiểu 3 ký tự)." : undefined}
        >
          {(control) => (
            <Textarea
              {...control}
              rows={3}
              maxLength={TEXT_MAX_LENGTH}
              value={reason}
              autoFocus
              onChange={(event) => {
                setReason(event.target.value);
                setMissing(false);
              }}
            />
          )}
        </FormField>
        {error && <DialogError message={error} />}
        <DialogFooter>
          <Button type="button" variant="outline" className={`${BUTTON} bg-card`} disabled={pending} onClick={onClose}>
            Giữ chuyến
          </Button>
          <Button type="submit" variant="destructive" className={BUTTON} disabled={pending}>
            {pending && <LoaderCircle className="size-[18px] animate-spin" />}
            {pending ? "Đang hủy…" : "Hủy chuyến"}
          </Button>
        </DialogFooter>
      </form>
    </DialogContent>
  );
}

/**
 * Hộp thoại khóa / mở khóa lô chỗ đang chọn (Figma "06 · Hộp thoại khóa chỗ"; FR-OPS-13, BR-42). Ghi chú tùy
 * chọn, chỉ lưu trong lịch sử thay đổi.
 */
export function SeatLockDialog({
  open,
  selection,
  pending,
  error,
  onClose,
  onConfirm
}: {
  open: boolean;
  selection: SeatSelection | null;
  pending: boolean;
  error: string | null;
  onClose: () => void;
  onConfirm: (note: string | null) => void;
}) {
  return (
    <Dialog open={open && selection !== null} onOpenChange={(next) => !next && !pending && onClose()}>
      {open && selection && (
        <SeatLockForm selection={selection} pending={pending} error={error} onClose={onClose} onConfirm={onConfirm} />
      )}
    </Dialog>
  );
}

function SeatLockForm({
  selection,
  pending,
  error,
  onClose,
  onConfirm
}: {
  selection: SeatSelection;
  pending: boolean;
  error: string | null;
  onClose: () => void;
  onConfirm: (note: string | null) => void;
}) {
  const [note, setNote] = useState("");
  const locking = selection.mode === "lock";
  const count = selection.codes.length;

  return (
    <DialogContent>
      <DialogHeader>
        <DialogTitle>{locking ? `Khóa ${count} chỗ đã chọn?` : `Mở khóa ${count} chỗ đã chọn?`}</DialogTitle>
        <DialogDescription>
          {locking
            ? "Chỗ bị khóa không hiện cho khách đặt online. Dùng khi đã bán chỗ ngoài hệ thống hoặc chỗ gặp sự cố. Mở khóa lại được bất cứ lúc nào trước khi xe khởi hành."
            : "Chỗ mở khóa trở lại Còn trống và khách đặt online được khi chuyến đang mở bán."}
        </DialogDescription>
      </DialogHeader>
      <form
        noValidate
        onSubmit={(event) => {
          event.preventDefault();
          onConfirm(note.trim() || null);
        }}
        className="flex flex-col gap-5"
      >
        <ul aria-label="Chỗ đã chọn" className="flex flex-wrap gap-2">
          {selection.codes.map((code) => (
            <li
              key={code}
              className="rounded-lg border border-primary bg-accent px-3 py-1.5 text-sm leading-5 font-semibold text-vxn-teal-700"
            >
              {code}
            </li>
          ))}
        </ul>
        <FormField label="Ghi chú" helper={`Tùy chọn · tối đa ${TEXT_MAX_LENGTH} ký tự · chỉ lưu trong lịch sử thay đổi`}>
          {(control) => (
            <Textarea
              {...control}
              rows={3}
              maxLength={TEXT_MAX_LENGTH}
              value={note}
              onChange={(event) => setNote(event.target.value)}
            />
          )}
        </FormField>
        {error && <DialogError message={error} />}
        <DialogFooter>
          <Button type="button" variant="outline" className={`${BUTTON} bg-card`} disabled={pending} onClick={onClose}>
            Hủy
          </Button>
          <Button type="submit" className={BUTTON} disabled={pending}>
            {pending ? (
              <LoaderCircle className="size-[18px] animate-spin" />
            ) : locking ? (
              <Lock className="size-[18px]" />
            ) : (
              <LockOpen className="size-[18px]" />
            )}
            {locking ? "Khóa chỗ" : "Mở khóa chỗ"}
          </Button>
        </DialogFooter>
      </form>
    </DialogContent>
  );
}
