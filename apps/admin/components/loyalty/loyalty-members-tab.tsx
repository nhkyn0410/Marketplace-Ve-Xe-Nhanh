"use client";

import { useInfiniteQuery, useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { IdentityField, useIdentityField } from "@vexenhanh/ui/components/auth/identity-field";
import { Badge } from "@vexenhanh/ui/components/badge";
import { Button } from "@vexenhanh/ui/components/button";
import { Dialog, DialogContent, DialogDescription, DialogFooter, DialogHeader, DialogTitle } from "@vexenhanh/ui/components/dialog";
import { FormField } from "@vexenhanh/ui/components/form-field";
import { Input } from "@vexenhanh/ui/components/input";
import { TABLE, TABLE_CELL, TABLE_HEAD_CELL, TABLE_HEAD_ROW, TableSkeleton } from "@vexenhanh/ui/components/list-controls";
import { BUTTON, ListLoadMoreFooter, ListStatePanel } from "@vexenhanh/ui/components/list-parts";
import { Skeleton } from "@vexenhanh/ui/components/skeleton";
import { Textarea } from "@vexenhanh/ui/components/textarea";
import { ApiError } from "@vexenhanh/ui/lib/auth/api-client";
import { withReauth } from "@vexenhanh/ui/lib/auth/reauth";
import { CircleAlert, CircleCheck, History, Info, LoaderCircle, Pencil, RefreshCw, Search, UserSearch } from "lucide-react";
import { useState, type FormEvent } from "react";

import { adjustPoints, describeLoyaltyError, getMember, listTransactions, TRANSACTION_PAGE, type LoyaltyMember } from "../../lib/loyalty/loyalty-api";
import { formatPoints, parseCount, TIER_LABEL, TYPE_LABEL } from "../../lib/loyalty/loyalty-format";
import { formatDate, LOCK_REASON_MAX, lockReasonError } from "../../lib/user/user-format";
import { CARD, CARD_TITLE } from "../policy/cancellation-tab";
import { LoyaltyFrame } from "./loyalty-screen";

const COLUMNS = ["w-[15%]", "w-[14%]", "", "w-[18%]", "w-[11%]"];

/** Tài khoản thành viên (Figma ADM-12b; FR-LOY-11): tra cứu theo email, thẻ hạng / điểm, sổ điểm chỉ ghi thêm, điều chỉnh điểm. */
export function LoyaltyMembersTab() {
  const [input, setInput] = useState("");
  const [email, setEmail] = useState<string | null>(null);
  const [inputError, setInputError] = useState<string | null>(null);
  const [notice, setNotice] = useState<string | null>(null);
  const [adjusting, setAdjusting] = useState(false);
  const member = useQuery({ queryKey: ["admin-loyalty-member", email], queryFn: () => getMember(email!), enabled: email !== null, retry: false });

  function lookup(event: FormEvent) {
    event.preventDefault();
    const value = input.trim().toLowerCase();
    if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(value)) {
      setInputError("Nhập email hợp lệ của hành khách.");
      return;
    }
    setInputError(null);
    setNotice(null);
    setEmail(value);
  }

  const notFound = member.error instanceof ApiError && member.error.code === "LOYALTY_MEMBER_NOT_FOUND";
  return (
    <LoyaltyFrame tab="members">
      <form noValidate onSubmit={lookup} className="flex flex-wrap items-start gap-4">
        <FormField label="Tra cứu hành khách" error={inputError ?? undefined} className="w-full max-w-[408px]">
          {(control) => <Input {...control} type="email" placeholder="Email hành khách" value={input} onChange={(event) => setInput(event.target.value)} />}
        </FormField>
        <Button type="submit" variant="outline" className={`${BUTTON} bg-card sm:mt-7`} disabled={member.isFetching}>
          {member.isFetching ? <LoaderCircle className="size-[18px] animate-spin" /> : <Search className="size-[18px]" />}
          Tra cứu
        </Button>
      </form>
      {notice && (
        <div role="status" className="flex items-center gap-3 rounded-lg bg-success-50 px-5 py-3 text-sm leading-5 text-success-700">
          <CircleCheck className="size-5 shrink-0" />
          {notice}
        </div>
      )}
      {email === null ? (
        <section className="rounded-xl border bg-card">
          <ListStatePanel icon={<UserSearch className="size-6 text-vxn-fg-3" />} title="Tra cứu tài khoản thành viên" description="Nhập email hành khách để xem hạng, điểm và lịch sử giao dịch điểm." compact />
        </section>
      ) : member.isPending ? (
        <Skeleton className="h-[104px] rounded-xl" />
      ) : member.isError ? (
        <section className="rounded-xl border bg-card">
          <ListStatePanel
            icon={<CircleAlert className="size-6 text-warning-700" />}
            title={notFound ? "Không tìm thấy hành khách" : "Không tải được tài khoản"}
            description={notFound ? "Không có hành khách có tài khoản với email này. Khách đặt vé không đăng nhập không tham gia VXN Plus." : describeLoyaltyError(member.error).message}
            action={
              notFound ? undefined : (
                <Button variant="outline" className={`${BUTTON} bg-card`} onClick={() => void member.refetch()}>
                  <RefreshCw className="size-[18px]" />
                  Thử lại
                </Button>
              )
            }
            compact
          />
        </section>
      ) : (
        <>
          <MemberCard member={member.data} onAdjust={() => setAdjusting(true)} />
          <TransactionHistory userId={member.data.userId} />
          <AdjustDialog
            member={adjusting ? member.data : null}
            onClose={() => setAdjusting(false)}
            onDone={(message) => {
              setNotice(message);
              setAdjusting(false);
            }}
          />
        </>
      )}
    </LoyaltyFrame>
  );
}

function initials(member: LoyaltyMember): string {
  const words = (member.name ?? member.email).trim().split(/\s+/);
  return ((words.length > 1 ? words[0]![0]! + words[words.length - 1]![0]! : words[0]!.slice(0, 2)) || "?").toUpperCase();
}

function MemberCard({ member, onAdjust }: { member: LoyaltyMember; onAdjust: () => void }) {
  return (
    <section aria-label="Tài khoản thành viên" className="flex flex-wrap items-center gap-x-8 gap-y-4 rounded-xl border bg-card px-6 py-5">
      <div className="flex min-w-0 flex-[1_1_20rem] items-center gap-5">
        <span aria-hidden className="flex size-14 shrink-0 items-center justify-center rounded-full bg-warning-500 text-lg font-semibold text-white">
          {initials(member)}
        </span>
        <div className="flex min-w-0 flex-col gap-1">
          <p className="flex flex-wrap items-center gap-3">
            <span className="text-lg leading-7 font-semibold text-vxn-ink">{member.name ?? member.email}</span>
            <Badge tone="neutral">Hạng {TIER_LABEL[member.tier]}</Badge>
            {member.status !== "ACTIVE" && <Badge tone="danger">Tài khoản bị khóa</Badge>}
          </p>
          <p className="text-sm leading-5 break-all text-muted-foreground">
            {member.email} · thành viên từ {formatDate(member.memberSince)}
          </p>
          {member.policyVersion === null ? (
            <p className="text-xs leading-[18px] text-warning-700">Chương trình chưa có phiên bản chính sách đang áp dụng.</p>
          ) : (
            member.nextTier && (
              <p className="text-xs leading-[18px] text-muted-foreground">
                Còn {formatPoints(member.nextTier.remaining)} điểm tích để lên hạng {TIER_LABEL[member.nextTier.tier]}.
              </p>
            )
          )}
        </div>
      </div>
      <dl className="flex items-end gap-8">
        <div className="flex flex-col items-end gap-1">
          <dt className="text-xs leading-[18px] text-muted-foreground">Điểm khả dụng</dt>
          <dd className="text-2xl leading-8 font-semibold text-primary tabular-nums">{formatPoints(member.availablePoints)}</dd>
        </div>
        <div className="flex flex-col items-end gap-1">
          <dt className="text-xs leading-[18px] text-muted-foreground">Tích trong 12 tháng</dt>
          <dd className="text-2xl leading-8 font-semibold text-vxn-ink tabular-nums">{formatPoints(member.earned12m)}</dd>
        </div>
      </dl>
      <Button type="button" className={BUTTON} onClick={onAdjust}>
        <Pencil className="size-[18px]" />
        Điều chỉnh điểm
      </Button>
    </section>
  );
}

function TransactionHistory({ userId }: { userId: string }) {
  const history = useInfiniteQuery({
    queryKey: ["admin-loyalty-transactions", userId],
    queryFn: ({ pageParam }) => listTransactions(userId, pageParam),
    initialPageParam: 0,
    getNextPageParam: (last, pages) => {
      const loaded = pages.reduce((sum, page) => sum + page.items.length, 0);
      return loaded < last.total ? loaded : undefined;
    }
  });
  const items = history.data?.pages.flatMap((page) => page.items) ?? [];
  const total = history.data?.pages[0]?.total ?? 0;
  return (
    <section aria-labelledby="loyalty-history" className={CARD}>
      <div className="flex flex-col gap-1">
        <h2 id="loyalty-history" className={CARD_TITLE}>
          Lịch sử giao dịch điểm
        </h2>
        <p className="text-sm leading-5 text-muted-foreground">Giao dịch chỉ ghi thêm, không sửa hoặc xóa.</p>
      </div>
      {history.isPending ? (
        <TableSkeleton label="Đang tải lịch sử điểm" rows={4} />
      ) : history.isError && items.length === 0 ? (
        <ListStatePanel
          icon={<CircleAlert className="size-6 text-warning-700" />}
          title="Không tải được lịch sử điểm"
          description="Không kết nối được máy chủ. Vui lòng thử lại."
          action={
            <Button variant="outline" className={`${BUTTON} bg-card`} onClick={() => void history.refetch()}>
              <RefreshCw className="size-[18px]" />
              Thử lại
            </Button>
          }
          compact
        />
      ) : items.length === 0 ? (
        <ListStatePanel icon={<History className="size-6 text-vxn-fg-3" />} title="Chưa có giao dịch điểm" description="Điểm được cộng khi chuyến của hành khách hoàn thành." compact />
      ) : (
        <>
          <div className="relative overflow-x-auto">
            <table className={`${TABLE} min-w-[720px]`}>
              <colgroup>
                {COLUMNS.map((width, index) => (
                  <col key={index} className={width} />
                ))}
              </colgroup>
              <thead>
                <tr className={TABLE_HEAD_ROW}>
                  <th scope="col" className={TABLE_HEAD_CELL}>
                    Ngày
                  </th>
                  <th scope="col" className={TABLE_HEAD_CELL}>
                    Loại
                  </th>
                  <th scope="col" className={TABLE_HEAD_CELL}>
                    Nguồn
                  </th>
                  <th scope="col" className={TABLE_HEAD_CELL}>
                    Phiên bản chính sách
                  </th>
                  <th scope="col" className={`${TABLE_HEAD_CELL} text-right`}>
                    Điểm
                  </th>
                </tr>
              </thead>
              <tbody>
                {items.map((item) => {
                  const type = TYPE_LABEL[item.type];
                  return (
                    <tr key={item.id} className="h-[53px] border-b">
                      <td className={TABLE_CELL}>{formatDate(item.createdAt)}</td>
                      <td className={TABLE_CELL}>
                        <Badge tone={type.tone}>{type.label}</Badge>
                      </td>
                      <td className={TABLE_CELL}>
                        <span className="block break-words">{item.sourceLabel}</span>
                        {item.type === "REVERSAL" && item.reason && <span className="block text-xs leading-[18px] text-warning-700">{item.reason}</span>}
                      </td>
                      <td className={TABLE_CELL}>{item.policyVersion === null ? "—" : `Phiên bản ${item.policyVersion}`}</td>
                      <td className={`${TABLE_CELL} text-right font-semibold tabular-nums`}>
                        <span className={item.points > 0 ? "text-success-700" : "text-vxn-ink"}>{formatPoints(item.points, true)}</span>
                      </td>
                    </tr>
                  );
                })}
              </tbody>
            </table>
          </div>
          <ListLoadMoreFooter
            hasMore={history.hasNextPage}
            loading={history.isFetchingNextPage}
            failed={history.isFetchNextPageError}
            loadedText={`Đã tải ${items.length} / ${total} giao dịch`}
            endText={`Đã tải hết ${total} giao dịch`}
            errorText="Không tải thêm được giao dịch. Vui lòng thử lại."
            onLoadMore={() => void history.fetchNextPage()}
          />
        </>
      )}
      <span className="sr-only">Mỗi lần tải {TRANSACTION_PAGE} giao dịch.</span>
    </section>
  );
}

/** Hộp thoại "Điều chỉnh điểm" (Figma ADM-12c): cộng / trừ, số điểm (xem trước số dư), lý do, mã xác thực. */
function AdjustDialog({ member, onClose, onDone }: { member: LoyaltyMember | null; onClose: () => void; onDone: (message: string) => void }) {
  const [pending, setPending] = useState(false);
  return (
    <Dialog open={member !== null} onOpenChange={(open) => !open && !pending && onClose()}>
      {member && <AdjustForm member={member} onClose={onClose} onDone={onDone} onPendingChange={setPending} />}
    </Dialog>
  );
}

function AdjustForm({
  member,
  onClose,
  onDone,
  onPendingChange
}: {
  member: LoyaltyMember;
  onClose: () => void;
  onDone: (message: string) => void;
  onPendingChange: (pending: boolean) => void;
}) {
  const queryClient = useQueryClient();
  const identity = useIdentityField();
  // Một khóa chống trùng cho mỗi lần mở hộp thoại: bấm lại / mạng chập chờn không cộng hai lần.
  const [idempotencyKey] = useState(() => crypto.randomUUID());
  const [direction, setDirection] = useState<"CREDIT" | "DEBIT">("CREDIT");
  const [points, setPoints] = useState("");
  const [reason, setReason] = useState("");
  const [errors, setErrors] = useState<Partial<Record<"points" | "reason" | "form", string>>>({});
  const amount = parseCount(points);
  const after = amount === null ? null : member.availablePoints + (direction === "CREDIT" ? amount : -amount);
  const run = useMutation({
    mutationFn: () => withReauth(identity.secret, () => adjustPoints(member.userId, { direction, points: amount!, reason: reason.trim() }, idempotencyKey)),
    onMutate: () => onPendingChange(true),
    onSettled: () => onPendingChange(false),
    onSuccess: (updated) => {
      queryClient.setQueryData(["admin-loyalty-member", member.email], updated);
      void queryClient.invalidateQueries({ queryKey: ["admin-loyalty-transactions", member.userId] });
      onDone(`Đã ${direction === "CREDIT" ? "cộng" : "trừ"} ${formatPoints(amount!)} điểm cho ${member.name ?? member.email}. Điểm khả dụng: ${formatPoints(updated.availablePoints)}.`);
    },
    onError: (error) => {
      const described = describeLoyaltyError(error);
      if (described.field === "identity") {
        identity.require(described.message);
        return;
      }
      identity.sync();
      setErrors({ form: described.message });
    }
  });

  function submit(event: FormEvent) {
    event.preventDefault();
    const next: typeof errors = {};
    if (amount === null || amount < 1 || amount > 1_000_000) {
      next.points = "Số điểm nguyên từ 1 đến 1.000.000.";
    } else if (after !== null && after < 0) {
      next.points = `Không trừ quá điểm khả dụng (${formatPoints(member.availablePoints)}).`;
    }
    next.reason = lockReasonError(reason) ?? undefined;
    setErrors(next);
    if (!identity.check() || next.points || next.reason) {
      return;
    }
    run.mutate();
  }

  const option = (value: "CREDIT" | "DEBIT", title: string, hint: string) => (
    <button
      type="button"
      role="radio"
      aria-checked={direction === value}
      disabled={run.isPending}
      onClick={() => setDirection(value)}
      className={`flex flex-1 items-start gap-3 rounded-lg border px-4 py-3 text-left transition-colors ${direction === value ? "border-2 border-primary bg-accent" : "bg-card hover:bg-muted"}`}
    >
      <span aria-hidden className={`mt-0.5 flex size-4 shrink-0 items-center justify-center rounded-full border-2 ${direction === value ? "border-primary" : "border-input"}`}>
        {direction === value && <span className="size-2 rounded-full bg-primary" />}
      </span>
      <span className="flex flex-col gap-0.5">
        <span className="text-sm leading-5 font-semibold text-vxn-ink">{title}</span>
        <span className="text-[13px] leading-5 text-muted-foreground">{hint}</span>
      </span>
    </button>
  );

  return (
    <DialogContent className="sm:max-w-[544px]">
      <DialogHeader>
        <DialogTitle>Điều chỉnh điểm</DialogTitle>
        <DialogDescription>
          {member.name ?? "Hành khách"} · {member.email}
        </DialogDescription>
      </DialogHeader>
      <form noValidate onSubmit={submit} className="flex flex-col gap-4">
        <div role="radiogroup" aria-label="Loại điều chỉnh" className="flex flex-col gap-3 sm:flex-row">
          {option("CREDIT", "Cộng điểm", "Bù điểm cho thành viên.")}
          {option("DEBIT", "Trừ điểm", "Thu lại điểm ghi sai.")}
        </div>
        <FormField label="Số điểm *" error={errors.points}>
          {(control) => <Input {...control} inputMode="numeric" value={points} disabled={run.isPending} autoFocus onChange={(event) => setPoints(event.target.value)} />}
        </FormField>
        <dl className="flex flex-col gap-2 rounded-lg bg-muted px-4 py-3 text-sm leading-5">
          <div className="flex justify-between gap-3">
            <dt className="text-muted-foreground">Điểm khả dụng hiện tại</dt>
            <dd className="font-semibold text-vxn-ink tabular-nums">{formatPoints(member.availablePoints)}</dd>
          </div>
          <div className="flex justify-between gap-3">
            <dt className="text-muted-foreground">Sau điều chỉnh</dt>
            <dd className={`text-base font-semibold tabular-nums ${after !== null && after < 0 ? "text-error-600" : "text-primary"}`}>{after === null ? "—" : formatPoints(after)}</dd>
          </div>
        </dl>
        <div role="note" className="flex gap-3 rounded-lg bg-accent px-4 py-3 text-sm leading-5 text-accent-foreground">
          <Info className="mt-px size-5 shrink-0" />
          <p>Điều chỉnh được ghi thành một giao dịch mới trong lịch sử điểm. Số dư không được âm.</p>
        </div>
        <FormField label="Lý do *" helper="Lý do được lưu vào nhật ký audit." error={errors.reason}>
          {(control) => (
            <Textarea
              {...control}
              rows={3}
              maxLength={LOCK_REASON_MAX}
              placeholder={`Nhập lý do (3–${LOCK_REASON_MAX} ký tự)…`}
              value={reason}
              disabled={run.isPending}
              onChange={(event) => setReason(event.target.value)}
            />
          )}
        </FormField>
        {identity.needed && <IdentityField totp value={identity.value} error={identity.error} disabled={run.isPending} onChange={identity.change} />}
        {errors.form && (
          <div role="alert" className="flex items-center gap-3 rounded-lg bg-error-50 px-4 py-3 text-sm leading-5 text-error-600">
            <CircleAlert className="size-5 shrink-0" />
            {errors.form}
          </div>
        )}
        <DialogFooter>
          <Button type="button" variant="outline" className={`${BUTTON} bg-card`} disabled={run.isPending} onClick={onClose}>
            Hủy
          </Button>
          <Button type="submit" className={BUTTON} disabled={run.isPending}>
            {run.isPending && <LoaderCircle className="size-[18px] animate-spin" />}
            Xác nhận điều chỉnh
          </Button>
        </DialogFooter>
      </form>
    </DialogContent>
  );
}
