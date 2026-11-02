"use client";

import { useQuery, useQueryClient } from "@tanstack/react-query";
import { Badge } from "@vexenhanh/ui/components/badge";
import { Button } from "@vexenhanh/ui/components/button";
import { Skeleton } from "@vexenhanh/ui/components/skeleton";
import {
  TABLE,
  TABLE_CELL,
  TABLE_HEAD_CELL,
  TABLE_HEAD_ROW
} from "@vexenhanh/ui/components/list-controls";
import { BUTTON, ListStatePanel } from "@vexenhanh/ui/components/list-parts";
import { ApiError } from "@vexenhanh/ui/lib/auth/api-client";
import { cn } from "@vexenhanh/ui/lib/utils";
import {
  ArrowLeft,
  Check,
  CircleAlert,
  CircleCheck,
  ExternalLink,
  FileX2,
  Info,
  RefreshCw,
  TriangleAlert
} from "lucide-react";
import Link from "next/link";
import { useState, type ReactNode } from "react";

import {
  documentDownloadUrl,
  getApplication,
  type ApplicationDetail as Detail,
  type DocumentType
} from "../../lib/operator-application/application-api";
import {
  APPLICATION_STATUS,
  DOCUMENT_LABELS,
  formatLongDateTime,
  formatShortDateTime,
  formatTaxCode,
  HISTORY_LABELS
} from "../../lib/operator-application/application-format";
import { ReviewDialog, type ReviewAction, type ReviewOutcome } from "./review-dialogs";

type Notice = { tone: "success" | "warning"; text: string };

/**
 * Chi tiết hồ sơ đăng ký nhà xe (Figma ADM-02b; UC-23 bước 2–6): thông tin doanh nghiệp, giấy tờ KYC (mở bằng URL có
 * hạn, máy chủ ghi audit), tài khoản nhận tiền (che), kiểm tra trùng định danh, người liên hệ, lịch sử; hồ sơ Chờ
 * duyệt thì có ba quyết định.
 */
export function ApplicationDetail({ applicationId }: { applicationId: string }) {
  const queryClient = useQueryClient();
  const detail = useQuery({ queryKey: ["operator-application", applicationId], queryFn: () => getApplication(applicationId) });
  const [action, setAction] = useState<ReviewAction | null>(null);
  const [notice, setNotice] = useState<Notice | null>(null);

  function refresh() {
    void queryClient.invalidateQueries({ queryKey: ["operator-application", applicationId] });
    void queryClient.invalidateQueries({ queryKey: ["operator-applications"] });
  }

  function done(outcome: ReviewOutcome) {
    setAction(null);
    setNotice(noticeOf(outcome));
    refresh();
  }

  if (detail.isPending) {
    return <DetailSkeleton />;
  }
  if (detail.isError) {
    const missing = detail.error instanceof ApiError && detail.error.status === 404;
    return (
      <div className="flex flex-col gap-6">
        <BackLink />
        <section className="rounded-xl border bg-card">
          <ListStatePanel
            icon={
              missing ? <FileX2 className="size-6 text-vxn-fg-3" /> : <CircleAlert className="size-6 text-warning-700" />
            }
            title={missing ? "Không tìm thấy hồ sơ" : "Không tải được hồ sơ"}
            description={missing ? "Hồ sơ không tồn tại hoặc chưa được gửi duyệt." : "Kiểm tra kết nối mạng rồi thử lại."}
            action={
              missing ? undefined : (
                <Button className={`${BUTTON} w-36`} onClick={() => void detail.refetch()}>
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

  const application = detail.data;
  const status = APPLICATION_STATUS[application.status];
  const pending = application.status === "SUBMITTED";
  return (
    <div className="flex flex-col gap-6">
      <BackLink />
      <header className="flex flex-wrap items-center gap-x-6 gap-y-3">
        <div className="flex min-w-0 flex-1 flex-col gap-1.5">
          <h1 className="text-[30px] leading-[38px] font-semibold text-vxn-ink">
            Hồ sơ {application.applicationCode} · {application.operatorName}
          </h1>
          <p className="text-sm leading-5 text-muted-foreground">
            {application.submittedAt ? `Gửi duyệt lúc ${formatLongDateTime(application.submittedAt)}` : "Chưa gửi duyệt"}
          </p>
        </div>
        <div className="flex min-w-0 flex-wrap items-center gap-3">
          <Badge tone={status.tone}>{status.label}</Badge>
          {pending && (
            <>
              <Button variant="outline" className={`${BUTTON} bg-card`} onClick={() => setAction("request-info")}>
                Yêu cầu bổ sung
              </Button>
              <Button
                variant="outline"
                className={`${BUTTON} bg-card text-error-600 hover:text-error-700`}
                onClick={() => setAction("reject")}
              >
                Từ chối
              </Button>
              <Button className={BUTTON} onClick={() => setAction("approve")}>
                <Check className="size-[18px]" />
                Duyệt hồ sơ
              </Button>
            </>
          )}
        </div>
      </header>

      {notice && <Banner tone={notice.tone}>{notice.text}</Banner>}
      <DecisionBanner application={application} onResend={() => setAction("resend")} />

      <div className="grid items-start gap-6 lg:grid-cols-[minmax(0,1fr)_350px]">
        <div className="flex min-w-0 flex-col gap-6">
          <Card title="Thông tin doanh nghiệp">
            <dl className="grid gap-x-6 gap-y-5 sm:grid-cols-2">
              <Field label="Tên pháp nhân" value={application.legalName} />
              <Field label="Mã số thuế" value={application.taxCode && formatTaxCode(application.taxCode)} />
              <Field label="Tên hiển thị" value={application.displayName} />
              <Field label="Hotline" value={application.hotline} />
              <Field label="Địa chỉ trụ sở" value={application.address} wide />
              {application.description && <Field label="Mô tả" value={application.description} wide />}
            </dl>
          </Card>
          <DocumentsCard application={application} />
          <Card title="Tài khoản nhận tiền" subtitle="Số tài khoản được che, chỉ hiện 4 số cuối.">
            <dl className="grid gap-x-6 gap-y-5 sm:grid-cols-3">
              <Field label="Ngân hàng" value={application.bankName} />
              <Field label="Số tài khoản" value={application.bankAccountNumberMasked} />
              <Field label="Chủ tài khoản" value={application.bankAccountHolder} />
            </dl>
          </Card>
        </div>
        <div className="flex min-w-0 flex-col gap-6">
          <DuplicatesCard application={application} />
          <Card title="Người liên hệ">
            <dl className="flex flex-col gap-3 text-sm leading-5">
              <Row label="Họ tên">{application.contactName}</Row>
              <Row label="Email">
                <span className="break-all">{application.contactEmail}</span>
              </Row>
              <Row label="Xác minh email">
                {application.contactEmailVerifiedAt ? (
                  <Badge tone="success">Đã xác minh</Badge>
                ) : (
                  <Badge tone="warning">Chưa xác minh</Badge>
                )}
              </Row>
            </dl>
          </Card>
          <HistoryCard history={application.history} />
        </div>
      </div>

      <ReviewDialog
        action={action}
        application={application}
        onClose={() => setAction(null)}
        onDone={done}
        onStale={refresh}
      />
    </div>
  );
}

function noticeOf(outcome: ReviewOutcome): Notice {
  switch (outcome.action) {
    case "approve":
    case "resend": {
      const login = `${outcome.result.operatorSlug}/${outcome.result.ownerUsername}`;
      if (outcome.result.credentialDeliveryPending) {
        return {
          tone: "warning",
          text: `Đã duyệt và tạo tài khoản ${login}, nhưng chưa gửi được mật khẩu tạm. Hãy gửi lại mật khẩu tạm.`
        };
      }
      return outcome.action === "approve"
        ? { tone: "success", text: `Đã duyệt hồ sơ. Tài khoản chủ nhà xe ${login} và mật khẩu tạm đã được gửi tới email liên hệ.` }
        : { tone: "success", text: `Đã gửi lại mật khẩu tạm cho ${login}.` };
    }
    case "request-info":
    case "reject": {
      const what = outcome.action === "reject" ? "Đã từ chối hồ sơ" : "Đã gửi yêu cầu bổ sung";
      return outcome.result.emailDelivered
        ? { tone: "success", text: `${what}. Người nộp đã được báo qua email.` }
        : {
            tone: "warning",
            text:
              outcome.action === "reject"
                ? `${what}, nhưng chưa gửi được email báo kết quả tới người nộp.`
                : `${what}, nhưng chưa gửi được email. Người nộp có thể tự xin lại link bằng email và mã hồ sơ.`
          };
    }
  }
}

function BackLink() {
  return (
    <Link
      href="/operators"
      className="inline-flex w-fit items-center gap-2 rounded text-sm font-medium text-primary outline-none hover:underline focus-visible:ring-[3px] focus-visible:ring-ring/50"
    >
      <ArrowLeft className="size-4" />
      Quay lại hàng đợi hồ sơ
    </Link>
  );
}

/** Kết quả đã có của hồ sơ: nhà xe đã tạo, hoặc nội dung bổ sung / lý do từ chối. */
function DecisionBanner({ application, onResend }: { application: Detail; onResend: () => void }) {
  if (application.status === "APPROVED" && application.operator) {
    const { operatorSlug, ownerUsername, credentialDeliveryPending } = application.operator;
    return (
      <Banner tone={credentialDeliveryPending ? "warning" : "success"}>
        <span>
          Nhà xe <strong>{operatorSlug}</strong> đã được tạo. Tài khoản chủ nhà xe:{" "}
          <strong>
            {operatorSlug}/{ownerUsername}
          </strong>
          .{" "}
          {credentialDeliveryPending
            ? "Mật khẩu tạm chưa gửi được tới email liên hệ."
            : "Mật khẩu tạm đã gửi tới email liên hệ."}
        </span>
        {credentialDeliveryPending && (
          <Button variant="outline" className={`${BUTTON} ml-auto bg-card`} onClick={onResend}>
            Gửi lại mật khẩu tạm
          </Button>
        )}
      </Banner>
    );
  }
  if ((application.status === "NEEDS_INFO" || application.status === "REJECTED") && application.reviewNote) {
    return (
      <Banner tone="warning">
        <span>
          {application.status === "REJECTED" ? "Lý do từ chối: " : "Đã yêu cầu bổ sung: "}
          {application.reviewNote}
        </span>
      </Banner>
    );
  }
  return null;
}

function DocumentsCard({ application }: { application: Detail }) {
  const [error, setError] = useState<string | null>(null);

  async function open(type: DocumentType) {
    setError(null);
    // Mở tab trước khi chờ API: trình duyệt chặn cửa sổ mở sau một lời gọi bất đồng bộ.
    const tab = window.open("about:blank", "_blank");
    try {
      const { url } = await documentDownloadUrl(application.id, type);
      if (tab) {
        tab.opener = null;
        tab.location.href = url;
      }
    } catch {
      tab?.close();
      setError("Không mở được tệp. Vui lòng thử lại.");
    }
  }

  return (
    <Card title="Giấy tờ KYC" subtitle="Link xem tệp có hạn 5 phút; mỗi lần mở tệp được ghi nhật ký audit.">
      <div className="relative overflow-x-auto">
        <table className={`${TABLE} min-w-[600px]`}>
          <colgroup>
            <col />
            <col className="w-[30%]" />
            <col className="w-[18%]" />
            <col className="w-[110px]" />
          </colgroup>
          <thead>
            <tr className={TABLE_HEAD_ROW}>
              <th scope="col" className={TABLE_HEAD_CELL}>
                Loại giấy tờ
              </th>
              <th scope="col" className={TABLE_HEAD_CELL}>
                Tệp
              </th>
              <th scope="col" className={TABLE_HEAD_CELL}>
                Tải lên
              </th>
              <th scope="col" className={TABLE_HEAD_CELL}>
                <span className="sr-only">Thao tác</span>
              </th>
            </tr>
          </thead>
          <tbody>
            {application.documents.map((document) => (
              <tr key={document.type} className="h-12 border-b">
                <td className={`${TABLE_CELL} truncate font-semibold text-vxn-ink`}>{DOCUMENT_LABELS[document.type]}</td>
                <td className={`${TABLE_CELL} truncate`}>{document.fileName}</td>
                <td className={TABLE_CELL}>{formatShortDateTime(document.uploadedAt)}</td>
                <td className={TABLE_CELL}>
                  <button
                    type="button"
                    aria-label={`Mở tệp ${DOCUMENT_LABELS[document.type]}`}
                    className="inline-flex items-center gap-1.5 rounded text-sm font-semibold text-vxn-ink outline-none hover:underline focus-visible:ring-[3px] focus-visible:ring-ring/50"
                    onClick={() => void open(document.type)}
                  >
                    Mở tệp
                    <ExternalLink className="size-4 text-muted-foreground" />
                  </button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
      {error && (
        <p role="alert" className="pt-3 text-sm leading-5 text-error-600">
          {error}
        </p>
      )}
    </Card>
  );
}

function DuplicatesCard({ application }: { application: Detail }) {
  const checks = [
    { label: "Email liên hệ", rows: application.duplicates.contactEmail },
    { label: "Mã số thuế", rows: application.duplicates.taxCode },
    { label: "Tài khoản nhận tiền", rows: application.duplicates.bankAccount }
  ];
  return (
    <Card title="Kiểm tra trùng định danh">
      <ul className="flex flex-col gap-3 text-sm leading-5">
        {checks.map((check) => (
          <li key={check.label} className="flex gap-2.5">
            {check.rows.length === 0 ? (
              <CircleCheck className="mt-0.5 size-4 shrink-0 text-success-600" aria-hidden />
            ) : (
              <TriangleAlert className="mt-0.5 size-4 shrink-0 text-error-600" aria-hidden />
            )}
            <span className={check.rows.length === 0 ? "text-vxn-fg-1" : "text-error-700"}>
              {check.label}:{" "}
              {check.rows.length === 0 ? (
                "không trùng hồ sơ khác"
              ) : (
                <>
                  trùng{" "}
                  {check.rows.map((row, index) => (
                    <span key={row.id}>
                      {index > 0 && ", "}
                      <Link href={`/operators/applications/${row.id}`} className="font-semibold underline-offset-2 hover:underline">
                        {row.applicationCode}
                      </Link>{" "}
                      ({APPLICATION_STATUS[row.status].label.toLowerCase()})
                    </span>
                  ))}
                </>
              )}
            </span>
          </li>
        ))}
      </ul>
    </Card>
  );
}

function HistoryCard({ history }: { history: Detail["history"] }) {
  return (
    <Card title="Lịch sử hồ sơ">
      {history === null ? (
        <p className="text-sm leading-5 text-muted-foreground">Chưa tải được lịch sử hồ sơ. Tải lại trang để thử lại.</p>
      ) : (
        <ol className="flex flex-col">
          {history.map((item, index) => {
            const label = HISTORY_LABELS[item.event];
            return (
              <li key={`${item.event}-${item.at}-${index}`} className="relative flex gap-3 pb-4 last:pb-0">
                {index < history.length - 1 && (
                  <span className="absolute top-3 bottom-0 left-[4.5px] w-px bg-border" aria-hidden />
                )}
                <span
                  className={cn(
                    "mt-1.5 size-2.5 shrink-0 rounded-full",
                    index === 0 ? "bg-primary" : "bg-muted-foreground/60"
                  )}
                  aria-hidden
                />
                <div className="flex min-w-0 flex-1 flex-col gap-0.5">
                  <div className="flex items-baseline justify-between gap-3">
                    <span className="text-sm leading-5 font-semibold text-vxn-ink">{label.title}</span>
                    <span className="shrink-0 text-xs leading-[18px] text-muted-foreground">
                      {formatShortDateTime(item.at)}
                    </span>
                  </div>
                  <span className="text-xs leading-[18px] text-muted-foreground">{label.actor}</span>
                  {item.note && <span className="text-sm leading-5 text-vxn-fg-1">“{item.note}”</span>}
                </div>
              </li>
            );
          })}
        </ol>
      )}
    </Card>
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

function Field({ label, value, wide = false }: { label: string; value: string | null; wide?: boolean }) {
  return (
    <div className={cn("flex min-w-0 flex-col gap-1", wide && "sm:col-span-full")}>
      <dt className="text-xs leading-[18px] text-muted-foreground">{label}</dt>
      <dd className="text-sm leading-5 break-words text-vxn-ink">{value || "—"}</dd>
    </div>
  );
}

function Row({ label, children }: { label: string; children: ReactNode }) {
  return (
    <div className="flex items-center justify-between gap-4">
      <dt className="text-muted-foreground">{label}</dt>
      <dd className="min-w-0 text-right text-vxn-ink">{children}</dd>
    </div>
  );
}

function Banner({ tone, children }: { tone: "success" | "warning"; children: ReactNode }) {
  const Icon = tone === "success" ? CircleCheck : Info;
  return (
    <div
      role="status"
      className={cn(
        "flex flex-wrap items-center gap-3 rounded-lg px-5 py-4 text-sm leading-5",
        tone === "success" ? "bg-success-50 text-success-700" : "bg-warning-50 text-warning-700"
      )}
    >
      <Icon className="size-5 shrink-0" />
      {children}
    </div>
  );
}

function DetailSkeleton() {
  return (
    <div role="status" aria-label="Đang tải hồ sơ" className="flex flex-col gap-6">
      <Skeleton className="h-5 w-48" />
      <Skeleton className="h-10 w-2/3" />
      <div className="grid gap-6 lg:grid-cols-[minmax(0,1fr)_350px]">
        <Skeleton className="h-64 rounded-xl" />
        <Skeleton className="h-64 rounded-xl" />
      </div>
    </div>
  );
}
