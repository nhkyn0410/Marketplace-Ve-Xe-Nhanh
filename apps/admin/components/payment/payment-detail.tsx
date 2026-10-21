"use client";

import { useQuery } from "@tanstack/react-query";
import { Badge } from "@vexenhanh/ui/components/badge";
import { Button } from "@vexenhanh/ui/components/button";
import { TABLE, TABLE_CELL, TABLE_HEAD_CELL, TABLE_HEAD_ROW } from "@vexenhanh/ui/components/list-controls";
import { BUTTON } from "@vexenhanh/ui/components/list-parts";
import { Skeleton } from "@vexenhanh/ui/components/skeleton";
import { ApiError } from "@vexenhanh/ui/lib/auth/api-client";
import { ArrowLeft, ChevronRight, CircleAlert, FileX2, ReceiptText, RefreshCw } from "lucide-react";
import Link from "next/link";
import { useState, type ReactNode } from "react";

import { getPayment, type PaymentDetail } from "../../lib/payment/payment-api";
import {
  allocationRows,
  formatVnd,
  moment,
  PAYMENT_STATUS,
  paymentTimeline,
  PROVIDER_LABEL,
  reconcileReasonLabel,
  REFUND_STATUS,
  tripMoment
} from "../../lib/payment/payment-format";
import { PaymentRefundDialog, RefundDialog } from "./refund-dialog";
import { OpenBookingDispute } from "../support/open-booking-dispute";

/**
 * Chi tiết thanh toán (Figma ADM-07b; TASK-ADM-002, FR-BTP-17, NFR-AUDIT-04): dòng thời gian booking → thanh toán → cổng →
 * sổ giữ hộ → vé → hoàn tiền → chi trả; phân bổ số tiền theo sổ; cổng thanh toán; hoàn tiền của giao dịch. Thanh toán cần đối
 * soát chưa xử lý: "Hoàn toàn bộ cho khách".
 */
export function PaymentDetailScreen({ paymentId }: { paymentId: string }) {
  const payment = useQuery({
    queryKey: ["admin-payment", paymentId],
    queryFn: () => getPayment(paymentId),
    retry: (count, error) => !(error instanceof ApiError && error.status === 404) && count < 2
  });
  if (payment.error instanceof ApiError && payment.error.status === 404) {
    return (
      <Shell>
        <Panel icon={<FileX2 className="size-6 text-vxn-fg-3" />} title="Không tìm thấy giao dịch" description="Giao dịch thanh toán không tồn tại." />
      </Shell>
    );
  }
  if (payment.isError && !payment.data) {
    return (
      <Shell>
        <Panel
          icon={<CircleAlert className="size-6 text-warning-700" />}
          title="Không tải được giao dịch"
          description="Không kết nối được máy chủ. Vui lòng kiểm tra kết nối và thử lại."
          action={
            <Button variant="outline" className={`${BUTTON} bg-card`} onClick={() => void payment.refetch()}>
              <RefreshCw className="size-[18px]" />
              Thử lại
            </Button>
          }
        />
      </Shell>
    );
  }
  if (!payment.data) {
    return (
      <Shell>
        <div role="status" aria-label="Đang tải giao dịch" className="grid gap-6 xl:grid-cols-[minmax(0,1fr)_380px]">
          <Skeleton className="h-[520px] rounded-xl" />
          <Skeleton className="h-[520px] rounded-xl" />
        </div>
      </Shell>
    );
  }
  return <DetailBody payment={payment.data} />;
}

function DetailBody({ payment }: { payment: PaymentDetail }) {
  const [refunding, setRefunding] = useState(false);
  const [openRefund, setOpenRefund] = useState<string | null>(null);
  const [notice, setNotice] = useState<string | null>(null);
  const status = PAYMENT_STATUS[payment.status];
  const provider = PROVIDER_LABEL[payment.provider];
  const timeline = paymentTimeline(payment);
  return (
    <Shell>
      <header className="flex flex-wrap items-start justify-between gap-4">
        <div className="flex flex-col gap-1.5">
          <h1 className="text-[30px] leading-[38px] font-semibold text-vxn-ink">Thanh toán {payment.paymentCode}</h1>
          <p className="text-sm leading-5 text-muted-foreground">
            Đơn {payment.bookingCode} · {payment.operatorName} · chuyến {tripMoment(payment.booking.departureAt)}
          </p>
        </div>
        <Badge tone={status.tone}>{status.label}</Badge>
      </header>
      {notice && (
        <div role="status" className="rounded-lg bg-success-50 px-5 py-3 text-sm leading-5 text-success-700">
          {notice}
        </div>
      )}
      {payment.status === "RECONCILING" && (
        <div role="note" className="rounded-lg bg-error-50 px-5 py-3 text-sm leading-5 text-error-700">
          Cần đối soát: {reconcileReasonLabel(payment.reconcileReason)}. Khách đã bị trừ tiền nhưng thanh toán không được nhận vào đơn.
          {payment.reconcileResolved ? " Đã có yêu cầu hoàn tiền." : payment.canRefund ? "" : " Đối chiếu với cổng trước khi xử lý ngoài hệ thống."}
        </div>
      )}
      <div className="grid items-start gap-6 xl:grid-cols-[minmax(0,1fr)_380px]">
        <div className="flex min-w-0 flex-col gap-6">
          <Card title="Dòng thời gian giao dịch">
            <ol className="flex flex-col">
              {timeline.map((event, index) => (
                <li key={index} className="flex gap-4 pb-4 last:pb-0">
                  <span
                    className={`mt-1.5 size-2.5 shrink-0 rounded-full ${event.tone === "success" ? "bg-success-600" : event.tone === "muted" ? "bg-vxn-fg-3" : "bg-primary"}`}
                    aria-hidden
                  />
                  <div className="flex min-w-0 flex-1 flex-col gap-0.5">
                    <p className="text-sm leading-5 font-semibold text-vxn-ink">{event.title}</p>
                    {event.detail && <p className="text-sm leading-5 break-words text-muted-foreground">{event.detail}</p>}
                  </div>
                  <time className="shrink-0 text-xs leading-[18px] text-muted-foreground" dateTime={event.at}>
                    {event.future ? `Dự kiến ${moment(event.at)}` : moment(event.at)}
                  </time>
                </li>
              ))}
            </ol>
          </Card>
          <Card title="Phân bổ số tiền">
            <table className={TABLE}>
              <thead>
                <tr className={TABLE_HEAD_ROW}>
                  <th scope="col" className={TABLE_HEAD_CELL}>
                    Khoản
                  </th>
                  <th scope="col" className={`${TABLE_HEAD_CELL} text-right`}>
                    Số tiền
                  </th>
                </tr>
              </thead>
              <tbody>
                {allocationRows(payment).map((row) => (
                  <tr key={row.label} className="border-b last:border-b-0">
                    <td className={TABLE_CELL}>{row.label}</td>
                    <td className={`${TABLE_CELL} text-right tabular-nums ${row.strong ? "font-semibold text-vxn-ink" : ""}`}>{formatVnd(row.amount)}</td>
                  </tr>
                ))}
              </tbody>
            </table>
            {!payment.allocation && <p className="mt-4 text-xs leading-[18px] text-muted-foreground">Tiền chưa vào sổ giữ hộ của nhà xe (thanh toán chưa thành công hoặc cần đối soát).</p>}
          </Card>
        </div>
        <div className="flex flex-col gap-6">
          <Card title="Cổng thanh toán">
            <dl className="flex flex-col gap-3">
              <Row label="Cổng" value={provider} />
              <Row label="Mã giao dịch cổng" value={payment.providerTxnId ?? "—"} />
              <Row label="Callback gần nhất" value={payment.lastCallbackAt ? `${moment(payment.lastCallbackAt)} · hợp lệ` : "Chưa có"} />
              <Row
                label="Số tiền so với đơn"
                value={payment.amountMatches === null ? "—" : <Badge tone={payment.amountMatches ? "success" : "danger"}>{payment.amountMatches ? "Khớp" : "Lệch"}</Badge>}
              />
            </dl>
          </Card>
          <Card title="Hoàn tiền">
            {payment.refunds.length === 0 ? (
              <p className="text-sm leading-5 text-muted-foreground">Chưa có yêu cầu hoàn tiền cho giao dịch này.</p>
            ) : (
              <ul className="flex flex-col gap-2">
                {payment.refunds.map((refund) => (
                  <li key={refund.refundId}>
                    <button
                      type="button"
                      onClick={() => setOpenRefund(refund.refundId)}
                      className="flex w-full items-center justify-between gap-3 rounded-lg border px-3 py-2 text-left text-sm leading-5 hover:bg-muted"
                    >
                      <span className="flex flex-col">
                        <span className="font-semibold text-vxn-ink">{refund.refundCode}</span>
                        <span className="text-xs leading-[18px] text-muted-foreground">
                          {formatVnd(refund.amount)} · {moment(refund.createdAt)}
                        </span>
                      </span>
                      <span className="flex items-center gap-1">
                        <Badge tone={REFUND_STATUS[refund.status].tone}>{REFUND_STATUS[refund.status].label}</Badge>
                        <ChevronRight className="size-4 text-muted-foreground" aria-hidden />
                      </span>
                    </button>
                  </li>
                ))}
              </ul>
            )}
            {payment.canRefund && (
              <Button variant="outline" className={`${BUTTON} mt-4 w-full bg-card`} onClick={() => setRefunding(true)}>
                <ReceiptText className="size-[18px]" />
                Hoàn toàn bộ cho khách
              </Button>
            )}
          </Card>
          <Card title="Liên kết">
            <dl className="flex flex-col gap-3">
              <Row label="Đơn đặt vé" value={payment.bookingCode} />
              <Row label="Người liên hệ" value={payment.booking.contactName} />
              <Row label="Chỗ" value={payment.booking.seatCodes.join(", ")} />
              <Row label="Tuyến" value={payment.booking.routeName} />
            </dl>
            <OpenBookingDispute bookingId={payment.bookingId} bookingCode={payment.bookingCode} />
          </Card>
        </div>
      </div>
      <PaymentRefundDialog
        key={refunding ? "open" : "closed"}
        payment={payment}
        open={refunding}
        onClose={() => setRefunding(false)}
        onDone={(message) => {
          setRefunding(false);
          setNotice(message);
        }}
      />
      <RefundDialog refundId={openRefund} onClose={() => setOpenRefund(null)} />
    </Shell>
  );
}

function Card({ title, children }: { title: string; children: ReactNode }) {
  return (
    <section aria-label={title} className="flex flex-col rounded-xl border bg-card p-6">
      <h2 className="mb-4 text-lg leading-7 font-semibold text-vxn-ink">{title}</h2>
      {children}
    </section>
  );
}

function Row({ label, value }: { label: string; value: ReactNode }) {
  return (
    <div className="flex items-baseline justify-between gap-4">
      <dt className="text-sm leading-5 text-muted-foreground">{label}</dt>
      <dd className="text-right text-sm leading-5 font-medium break-all text-vxn-fg-1 tabular-nums">{value}</dd>
    </div>
  );
}

function Shell({ children }: { children: ReactNode }) {
  return (
    <div className="flex flex-col gap-6">
      <Link href="/payments" className="flex w-fit items-center gap-1.5 text-sm leading-5 font-medium text-primary hover:underline">
        <ArrowLeft className="size-[18px]" />
        Quay lại danh sách giao dịch
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
