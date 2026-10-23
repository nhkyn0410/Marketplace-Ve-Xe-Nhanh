"use client";

import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { useCan } from "@vexenhanh/ui/components/auth/auth-context";
import { IdentityField, useIdentityField } from "@vexenhanh/ui/components/auth/identity-field";
import { Badge } from "@vexenhanh/ui/components/badge";
import { Button } from "@vexenhanh/ui/components/button";
import { TABLE, TABLE_CELL, TABLE_HEAD_CELL, TABLE_HEAD_ROW } from "@vexenhanh/ui/components/list-controls";
import { BUTTON } from "@vexenhanh/ui/components/list-parts";
import { Skeleton } from "@vexenhanh/ui/components/skeleton";
import { ApiError } from "@vexenhanh/ui/lib/auth/api-client";
import { hasRecentReauth, withReauth } from "@vexenhanh/ui/lib/auth/reauth";
import { ArrowLeft, Check, CircleAlert, CircleCheck, CircleX, Eye, FileX2, Hourglass, LoaderCircle, RefreshCw, RotateCcw } from "lucide-react";
import Link from "next/link";
import { useState, type ReactNode } from "react";

import { getPayout, releasePayout, revealPayoutBank, reviewPayout, type PayoutBankAccount, type PayoutDetail } from "../../lib/payout/payout-api";
import { checkItems, describePayoutError, PAYOUT_STATUS, periodLabel, rateLabel, signedVnd } from "../../lib/payout/payout-format";
import { PayoutConfirmDialog, PayoutReasonDialog } from "./payout-dialogs";

const VND = new Intl.NumberFormat("vi-VN");
const formatVnd = (amount: number) => `${VND.format(amount)} ₫`;
/** `2026-10-08T10:21:00Z` → `08/10 · 17:21` (giờ VN). */
function moment(iso: string): string {
  const [date, time] = new Date(new Date(iso).getTime() + 7 * 3_600_000).toISOString().split("T");
  return `${date.slice(8, 10)}/${date.slice(5, 7)} · ${time.slice(0, 5)}`;
}

/**
 * Chi trả — chi tiết và rà soát (Figma ADM-08b; TASK-BTP-006 / ADM-002, LLD §6.6 bước 4–5): chuyến trong kỳ, kiểm tra trước
 * khi chi, cách tính, tài khoản nhận tiền (số đã che — xem đầy đủ cần TOTP, ghi nhật ký), tiến trình. Thao tác theo trạng thái:
 * rà soát xong / giữ lại / mở lại / xác nhận đã chuyển khoản / hủy kỳ.
 */
export function PayoutDetailScreen({ payoutId }: { payoutId: string }) {
  const payout = useQuery({ queryKey: ["admin-payout", payoutId], queryFn: () => getPayout(payoutId), retry: (count, error) => !(error instanceof ApiError && error.status === 404) && count < 2 });
  if (payout.error instanceof ApiError && payout.error.status === 404) {
    return (
      <Shell>
        <Panel icon={<FileX2 className="size-6 text-vxn-fg-3" />} title="Không tìm thấy kỳ chi trả" description="Kỳ chi trả không tồn tại." />
      </Shell>
    );
  }
  if (payout.isError && !payout.data) {
    return (
      <Shell>
        <Panel
          icon={<CircleAlert className="size-6 text-warning-700" />}
          title="Không tải được kỳ chi trả"
          description="Không kết nối được máy chủ. Vui lòng kiểm tra kết nối và thử lại."
          action={
            <Button variant="outline" className={`${BUTTON} bg-card`} onClick={() => void payout.refetch()}>
              <RefreshCw className="size-[18px]" />
              Thử lại
            </Button>
          }
        />
      </Shell>
    );
  }
  if (!payout.data) {
    return (
      <Shell>
        <div role="status" aria-label="Đang tải kỳ chi trả" className="grid gap-6 xl:grid-cols-[minmax(0,1fr)_340px]">
          <Skeleton className="h-[480px] rounded-xl" />
          <Skeleton className="h-[480px] rounded-xl" />
        </div>
      </Shell>
    );
  }
  return <DetailBody payout={payout.data} />;
}

function DetailBody({ payout }: { payout: PayoutDetail }) {
  const queryClient = useQueryClient();
  // Xem: `payment:monitor`; giữ / mở / rà soát / xác nhận / hủy / xem đủ số tài khoản: `payout:manage` (TASK-IAM-007).
  const manage = useCan()("payout:manage");
  const [dialog, setDialog] = useState<"hold" | "cancel" | "confirm" | null>(null);
  const [notice, setNotice] = useState<{ tone: "success" | "error"; text: string } | null>(null);
  const status = PAYOUT_STATUS[payout.status];

  function applied(message: string, next: PayoutDetail | null) {
    setDialog(null);
    if (next) {
      queryClient.setQueryData(["admin-payout", payout.payoutId], next);
      setNotice({ tone: "success", text: message });
    } else {
      setNotice({ tone: "error", text: message });
    }
    void queryClient.invalidateQueries({ queryKey: ["admin-payouts"] });
    void queryClient.invalidateQueries({ queryKey: ["admin-payout-stats"] });
    if (!next) void queryClient.invalidateQueries({ queryKey: ["admin-payout", payout.payoutId] });
  }

  const quick = useMutation({
    mutationFn: (action: "review" | "release") => (action === "review" ? reviewPayout(payout.payoutId) : releasePayout(payout.payoutId)),
    onSuccess: (next, action) => applied(action === "review" ? `Đã rà soát ${payout.payoutCode} — sẵn sàng chuyển khoản.` : `Đã mở lại ${payout.payoutCode} — chờ rà soát.`, next),
    onError: (error) => applied(describePayoutError(error).message, null)
  });

  const open = payout.status !== "PAID" && payout.status !== "CANCELLED" && payout.status !== "FAILED";
  return (
    <Shell>
      <header className="flex flex-wrap items-start justify-between gap-4">
        <div className="flex flex-col gap-1.5">
          <h1 className="text-[30px] leading-[38px] font-semibold text-vxn-ink">Chi trả {payout.payoutCode}</h1>
          <p className="text-sm leading-5 text-muted-foreground">
            {payout.operatorName} · kỳ {periodLabel(payout.period)}
          </p>
        </div>
        <div className="flex flex-wrap items-center gap-3">
          <Badge tone={status.tone}>{status.label}</Badge>
          {manage && (payout.status === "PENDING_REVIEW" || payout.status === "READY_TO_TRANSFER") && (
            <Button variant="outline" className={`${BUTTON} bg-card`} onClick={() => setDialog("hold")}>
              <Hourglass className="size-[18px]" />
              Giữ lại
            </Button>
          )}
          {manage && payout.status === "ON_HOLD" && (
            <Button variant="outline" className={`${BUTTON} bg-card`} disabled={quick.isPending} onClick={() => quick.mutate("release")}>
              <RotateCcw className="size-[18px]" />
              Mở lại
            </Button>
          )}
          {manage && payout.status === "PENDING_REVIEW" && (
            <Button className={BUTTON} disabled={quick.isPending} onClick={() => quick.mutate("review")}>
              {quick.isPending ? <LoaderCircle className="size-[18px] animate-spin" /> : <Check className="size-[18px]" />}
              Rà soát xong
            </Button>
          )}
          {manage && (payout.status === "READY_TO_TRANSFER" || payout.status === "TRANSFERRING") && (
            <Button className={BUTTON} onClick={() => setDialog("confirm")}>
              <Check className="size-[18px]" />
              Xác nhận đã chuyển khoản
            </Button>
          )}
        </div>
      </header>
      {notice && (
        <div role={notice.tone === "success" ? "status" : "alert"} className={`rounded-lg px-5 py-3 text-sm leading-5 ${notice.tone === "success" ? "bg-success-50 text-success-700" : "bg-error-50 text-error-700"}`}>
          {notice.text}
        </div>
      )}
      {payout.status === "ON_HOLD" && payout.holdReason && (
        <p role="note" className="rounded-lg bg-warning-50 px-5 py-3 text-sm leading-5 text-warning-700">
          Đang giữ lại: {payout.holdReason}
        </p>
      )}
      <div className="grid items-start gap-6 xl:grid-cols-[minmax(0,1fr)_340px]">
        <div className="flex min-w-0 flex-col gap-6">
          <Card title="Chuyến trong kỳ" subtitle="Mỗi dòng truy được về đơn đặt vé, thanh toán, hoàn tiền và sổ giữ hộ.">
            <div className="overflow-x-auto">
              <table className={`${TABLE} min-w-[640px]`}>
                <thead>
                  <tr className={TABLE_HEAD_ROW}>
                    {["Chuyến", "Đơn", "Giá vé", `Hoa hồng ${rateLabel(payout.commissionRateBps)}`.trim(), "Hoàn / điều chỉnh", "Thực chi"].map((heading, index) => (
                      <th key={heading} scope="col" className={`${TABLE_HEAD_CELL} ${index >= 1 ? "text-right" : ""}`}>
                        {heading}
                      </th>
                    ))}
                  </tr>
                </thead>
                <tbody>
                  {payout.trips.map((trip) => (
                    <tr key={trip.tripId ?? "adjustment"} className="border-b last:border-b-0">
                      <td className={`${TABLE_CELL} min-w-[220px]`}>
                        <p className="font-medium">{trip.departureAt ? `${moment(trip.departureAt)} · ${trip.routeName}` : "Điều chỉnh"}</p>
                        <p className="text-xs leading-[18px] text-muted-foreground">{trip.vehiclePlateNumber ?? (trip.tripId ? "Chưa gắn xe" : "Không gắn chuyến")}</p>
                      </td>
                      <td className={`${TABLE_CELL} text-right tabular-nums`}>{trip.bookingCount}</td>
                      <td className={`${TABLE_CELL} text-right tabular-nums`}>{formatVnd(trip.grossAmount)}</td>
                      <td className={`${TABLE_CELL} text-right tabular-nums`}>{signedVnd(-trip.commissionAmount, formatVnd)}</td>
                      <td className={`${TABLE_CELL} text-right tabular-nums`}>{signedVnd(trip.refundAdjustmentAmount, formatVnd)}</td>
                      <td className={`${TABLE_CELL} text-right font-semibold tabular-nums`}>{formatVnd(trip.amount)}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
            <p className="mt-4 text-xs leading-[18px] text-muted-foreground">
              {payout.trips.filter((trip) => trip.tripId).length} chuyến · {payout.trips.reduce((sum, trip) => sum + trip.bookingCount, 0)} đơn
            </p>
          </Card>
          <Card title="Kiểm tra trước khi chi">
            <ul className="flex flex-col gap-3">
              {checkItems(payout.checks).map((item) => (
                <li key={item.label} className="flex items-center gap-2.5 text-sm leading-5">
                  {item.ok ? <CircleCheck className="size-[18px] text-success-600" aria-hidden /> : <CircleX className="size-[18px] text-error-600" aria-hidden />}
                  <span className={item.ok ? "text-vxn-fg-1" : "text-error-700"}>{item.label}</span>
                </li>
              ))}
            </ul>
          </Card>
          {manage && open && (
            <div className="flex justify-end">
              <Button variant="ghost" className="text-error-700 hover:text-error-700" onClick={() => setDialog("cancel")}>
                Hủy kỳ chi trả
              </Button>
            </div>
          )}
        </div>
        <div className="flex flex-col gap-6">
          <Card title="Cách tính">
            <dl className="flex flex-col gap-3">
              <Row label="Tổng đủ điều kiện" value={formatVnd(payout.grossAmount)} />
              <Row label={`Hoa hồng ${rateLabel(payout.commissionRateBps)}`.trim()} value={signedVnd(-payout.commissionAmount, formatVnd)} />
              <Row label="Hoàn tiền" value={signedVnd(-payout.refundAmount, formatVnd)} />
              <Row label="Điều chỉnh" value={signedVnd(payout.adjustmentAmount, formatVnd)} />
            </dl>
            <div className="mt-4 flex items-baseline justify-between gap-3 border-t pt-4">
              <span className="text-sm leading-5 font-semibold text-vxn-ink">Thực chi</span>
              <span className="text-[26px] leading-8 font-semibold text-primary tabular-nums">{formatVnd(payout.amount)}</span>
            </div>
          </Card>
          <BankCard payout={payout} />
          <Card title="Tiến trình">
            <ol className="flex flex-col">
              {[...payout.histories].reverse().map((history, index) => (
                <li key={index} className="flex gap-4 pb-4 last:pb-0">
                  <span className="mt-1.5 size-2.5 shrink-0 rounded-full bg-primary" aria-hidden />
                  <div className="flex min-w-0 flex-1 flex-col gap-0.5">
                    <p className="text-sm leading-5 font-semibold text-vxn-ink">{history.fromStatus === null ? "Tạo khoản chi trả" : PAYOUT_STATUS[history.toStatus].label}</p>
                    <p className="text-sm leading-5 text-muted-foreground">{[history.actor ?? "Hệ thống", history.reason].filter(Boolean).join(" · ")}</p>
                  </div>
                  <time className="shrink-0 text-xs leading-[18px] text-muted-foreground" dateTime={history.createdAt}>
                    {moment(history.createdAt)}
                  </time>
                </li>
              ))}
            </ol>
            {payout.bankReference && <p className="mt-4 text-sm leading-5 text-muted-foreground">Mã giao dịch ngân hàng: {payout.bankReference}</p>}
          </Card>
        </div>
      </div>
      <PayoutReasonDialog payout={payout} kind={dialog === "hold" || dialog === "cancel" ? dialog : null} onClose={() => setDialog(null)} onDone={applied} />
      <PayoutConfirmDialog key={dialog === "confirm" ? "open" : "closed"} payout={payout} open={dialog === "confirm"} onClose={() => setDialog(null)} onDone={applied} />
    </Shell>
  );
}

/** Tài khoản nhận tiền: số đã che; "Hiện đầy đủ số tài khoản" cần TOTP và máy chủ ghi nhật ký mỗi lần xem. */
function BankCard({ payout }: { payout: PayoutDetail }) {
  const manage = useCan()("payout:manage");
  const identity = useIdentityField();
  const [asking, setAsking] = useState(false);
  const [full, setFull] = useState<PayoutBankAccount | null>(null);
  const [error, setError] = useState<string | null>(null);
  const reveal = useMutation({
    mutationFn: (secret: string | null) => withReauth(secret, () => revealPayoutBank(payout.payoutId)),
    onSuccess: (account) => {
      setFull(account);
      setAsking(false);
    },
    onError: (failure) => {
      const described = describePayoutError(failure);
      if (described.field === "identity") {
        identity.require(described.message);
        return;
      }
      identity.sync();
      setError(described.message);
    }
  });
  return (
    <Card title="Tài khoản nhận tiền" action={payout.checks.bankVerified ? <Badge tone="success">Đã xác minh</Badge> : <Badge tone="warning">Chưa xác minh</Badge>}>
      {payout.bank ? (
        <>
          <dl className="flex flex-col gap-3">
            <Row label="Ngân hàng" value={payout.bank.bankName} />
            <Row label="Số tài khoản" value={full?.accountNumber ?? payout.bank.accountNumberMasked} />
            <Row label="Chủ tài khoản" value={payout.bank.accountHolder} />
          </dl>
          {manage && !full && (
            <div className="mt-4 flex flex-col gap-3">
              {asking && <IdentityField totp value={identity.value} error={identity.error} disabled={reveal.isPending} onChange={identity.change} />}
              <Button
                variant="outline"
                className={`${BUTTON} w-full bg-card`}
                disabled={reveal.isPending}
                onClick={() => {
                  setError(null);
                  // Xét lúc bấm: vừa xác nhận danh tính ở thao tác khác (5 phút) thì không hỏi lại mã.
                  if (!asking && hasRecentReauth()) {
                    reveal.mutate(null);
                    return;
                  }
                  if (!asking) {
                    setAsking(true);
                    return;
                  }
                  if (identity.check()) reveal.mutate(identity.secret);
                }}
              >
                {reveal.isPending ? <LoaderCircle className="size-[18px] animate-spin" /> : <Eye className="size-[18px]" />}
                Hiện đầy đủ số tài khoản
              </Button>
              <p className="text-xs leading-[18px] text-muted-foreground">Xem đầy đủ cần xác nhận lại danh tính và được ghi nhật ký audit.</p>
              {error && (
                <p role="alert" className="text-sm leading-5 text-error-600">
                  {error}
                </p>
              )}
            </div>
          )}
        </>
      ) : (
        <p className="text-sm leading-5 text-muted-foreground">Nhà xe chưa có tài khoản nhận tiền đã xác minh — không chi được kỳ này.</p>
      )}
    </Card>
  );
}

function Card({ title, subtitle, action, children }: { title: string; subtitle?: string; action?: ReactNode; children: ReactNode }) {
  return (
    <section aria-label={title} className="flex flex-col rounded-xl border bg-card p-6">
      <div className="mb-4 flex items-start justify-between gap-3">
        <div className="flex flex-col gap-0.5">
          <h2 className="text-lg leading-7 font-semibold text-vxn-ink">{title}</h2>
          {subtitle && <p className="text-xs leading-[18px] text-muted-foreground">{subtitle}</p>}
        </div>
        {action}
      </div>
      {children}
    </section>
  );
}

function Row({ label, value }: { label: string; value: string }) {
  return (
    <div className="flex items-baseline justify-between gap-4">
      <dt className="text-sm leading-5 text-muted-foreground">{label}</dt>
      <dd className="text-right text-sm leading-5 font-medium text-vxn-fg-1 tabular-nums">{value}</dd>
    </div>
  );
}

function Shell({ children }: { children: ReactNode }) {
  return (
    <div className="flex flex-col gap-6">
      <Link href="/payouts" className="flex w-fit items-center gap-1.5 text-sm leading-5 font-medium text-primary hover:underline">
        <ArrowLeft className="size-[18px]" />
        Quay lại danh sách kỳ chi trả
      </Link>
      {children}
    </div>
  );
}

function Panel({ icon, title, description, action }: { icon: ReactNode; title: string; description: string; action?: ReactNode }) {
  return (
    <div className="flex min-h-[420px] flex-col items-center justify-center gap-3 rounded-xl border bg-card px-4 text-center">
      {icon}
      <p className="text-base leading-6 font-semibold text-vxn-ink">{title}</p>
      <p className="max-w-md text-sm leading-5 text-muted-foreground">{description}</p>
      {action && <div className="mt-2">{action}</div>}
    </div>
  );
}
