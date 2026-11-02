"use client";

import { Badge } from "@vexenhanh/ui/components/badge";
import { Button } from "@vexenhanh/ui/components/button";
import { cn } from "@vexenhanh/ui/lib/utils";
import { CircleAlert, Eye, Hourglass, Pencil } from "lucide-react";
import { useState, type ReactNode } from "react";

import {
  type Application,
  DOCUMENT_TYPES,
  formatShortDateTime,
  formatTimeDate,
  STATUS_LABELS
} from "../../lib/register/application";

/** Ngày `13/10/2026` theo giờ Việt Nam. */
function formatDate(iso: string): string {
  return new Intl.DateTimeFormat("vi-VN", { timeZone: "Asia/Ho_Chi_Minh", day: "2-digit", month: "2-digit", year: "numeric" }).format(
    new Date(iso)
  );
}

/**
 * Trạng thái hồ sơ qua link bảo mật (Figma 05 "Chờ duyệt", 06 "Cần bổ sung"; UC-10 bước 8, A4). Hồ sơ chờ duyệt chỉ
 * xem được; cần bổ sung thì mở form để sửa.
 */
export function ApplicationStatus({
  application,
  onEdit,
  onViewDocument
}: {
  application: Application;
  onEdit?: () => void;
  onViewDocument: (type: Application["documents"][number]["type"]) => void;
}) {
  const [showDetails, setShowDetails] = useState(false);
  const needsInfo = application.status === "NEEDS_INFO";

  return (
    <section
      aria-labelledby="application-status-heading"
      className="flex w-full max-w-[720px] flex-col gap-5 rounded-2xl border bg-card p-6 shadow-xs"
    >
      <div className="flex items-start gap-3">
        <div className="flex min-w-0 flex-1 flex-col gap-1">
          <h1 id="application-status-heading" className="text-xl leading-7 font-semibold text-vxn-ink">
            Hồ sơ đăng ký {application.applicationCode}
          </h1>
          <p className="text-xs leading-[18px] text-muted-foreground">Cập nhật gần nhất {formatDate(application.updatedAt)}</p>
        </div>
        <Badge tone="warning">{STATUS_LABELS[application.status]}</Badge>
      </div>

      <div className={cn("flex items-start gap-4 rounded-lg p-4", needsInfo ? "bg-warning-50" : "bg-accent")}>
        <span className="flex size-9 shrink-0 items-center justify-center rounded-full bg-card">
          {needsInfo ? (
            <CircleAlert className="size-5 text-warning-700" aria-hidden />
          ) : (
            <Hourglass className="size-5 text-vxn-teal-700" aria-hidden />
          )}
        </span>
        <div className="flex flex-col gap-1" role="status">
          <p className="text-base leading-6 font-semibold text-vxn-ink">
            {needsInfo ? "Vé Xe Nhanh yêu cầu bổ sung hồ sơ" : "Hồ sơ đang chờ Vé Xe Nhanh duyệt"}
          </p>
          <p className="text-sm leading-5 text-vxn-fg-1">
            {needsInfo
              ? (application.reviewNote ?? "Vui lòng xem lại hồ sơ rồi gửi duyệt lại.")
              : "Trong lúc chờ, hồ sơ chỉ xem được. Kết quả sẽ được gửi tới email liên hệ."}
          </p>
        </div>
      </div>

      <dl className="flex flex-col gap-2 rounded-lg bg-muted/60 p-3 text-sm leading-5">
        <Row label="Nhà xe">{application.displayName ?? application.operatorName}</Row>
        <Row label="Người liên hệ">
          {application.contactName} · {application.contactEmail}
        </Row>
        {application.submittedAt && (
          <Row label="Gửi duyệt lúc">
            <span className="font-semibold">{formatTimeDate(application.submittedAt)}</span>
          </Row>
        )}
      </dl>

      {needsInfo ? (
        <div className="flex flex-wrap items-center gap-3">
          <Button type="button" className="h-10 rounded-lg px-4 text-sm font-semibold" onClick={onEdit}>
            <Pencil className="size-[18px]" />
            Bổ sung hồ sơ
          </Button>
          <p className="text-xs leading-[18px] text-muted-foreground">Bạn đã nhận link mới qua email để sửa hồ sơ.</p>
        </div>
      ) : (
        <>
          <ol aria-label="Lịch sử hồ sơ" className="flex flex-col">
            {application.submittedAt && (
              <Event
                title="Đã gửi duyệt"
                time={application.submittedAt}
                detail="Đủ thông tin doanh nghiệp, 3 giấy tờ và tài khoản nhận tiền"
                done
              />
            )}
            {application.contactEmailVerifiedAt && (
              <Event title="Đã xác minh email" time={application.contactEmailVerifiedAt} detail="Mở link bảo mật lần đầu" done />
            )}
            <Event title="Đã gửi đăng ký" time={application.createdAt} />
          </ol>
          <Button
            type="button"
            variant="outline"
            aria-expanded={showDetails}
            className="h-10 self-start rounded-lg bg-card px-4 text-sm font-semibold"
            onClick={() => setShowDetails((value) => !value)}
          >
            <Eye className="size-[18px]" />
            {showDetails ? "Ẩn hồ sơ đã gửi" : "Xem hồ sơ đã gửi"}
          </Button>
          {showDetails && <Details application={application} onViewDocument={onViewDocument} />}
        </>
      )}
    </section>
  );
}

function Row({ label, children }: { label: string; children: ReactNode }) {
  return (
    <div className="flex flex-wrap justify-between gap-x-4 gap-y-1">
      <dt className="text-muted-foreground">{label}</dt>
      <dd className="text-right text-vxn-fg-1">{children}</dd>
    </div>
  );
}

function Event({ title, time, detail, done = false }: { title: string; time: string; detail?: string; done?: boolean }) {
  return (
    <li className="relative flex gap-3 pb-3 pl-5 last:pb-0">
      <span aria-hidden className={cn("absolute top-1.5 left-0 size-2 rounded-full", done ? "bg-success-600" : "bg-vxn-fg-3")} />
      <span aria-hidden className="absolute top-4 bottom-0 left-[3px] w-px bg-border" />
      <div className="flex min-w-0 flex-1 flex-col gap-0.5">
        <p className="text-sm leading-5 font-semibold text-vxn-ink">{title}</p>
        {detail && <p className="text-xs leading-[18px] text-muted-foreground">{detail}</p>}
      </div>
      <p className="shrink-0 text-xs leading-5 text-muted-foreground">{formatShortDateTime(time)}</p>
    </li>
  );
}

/** Hồ sơ đã gửi, chỉ đọc. */
function Details({
  application,
  onViewDocument
}: {
  application: Application;
  onViewDocument: (type: Application["documents"][number]["type"]) => void;
}) {
  return (
    <div className="flex flex-col gap-4 border-t pt-4">
      <dl className="flex flex-col gap-2 text-sm leading-5">
        <Row label="Tên pháp nhân">{application.legalName}</Row>
        <Row label="Mã số thuế">{application.taxCode}</Row>
        <Row label="Hotline">{application.hotline}</Row>
        <Row label="Địa chỉ trụ sở">{application.address}</Row>
        <Row label="Tài khoản nhận tiền">
          {application.bankName} · {application.bankAccountNumberMasked} · {application.bankAccountHolder}
        </Row>
      </dl>
      <ul aria-label="Giấy tờ đã gửi" className="flex flex-col gap-2">
        {DOCUMENT_TYPES.map(({ type, label }) => {
          const document = application.documents.find((candidate) => candidate.type === type);
          return (
            <li key={type} className="flex items-center gap-3 rounded-lg border px-3 py-2">
              <div className="min-w-0 flex-1">
                <p className="text-sm leading-5 font-medium text-vxn-fg-1">{label}</p>
                <p className="truncate text-xs leading-[18px] text-muted-foreground">{document?.fileName ?? "Chưa có"}</p>
              </div>
              {document && (
                <Button
                  type="button"
                  variant="ghost"
                  aria-label={`Xem ${label}`}
                  className="h-8 px-2 text-sm font-semibold text-vxn-teal-700"
                  onClick={() => onViewDocument(type)}
                >
                  Xem
                </Button>
              )}
            </li>
          );
        })}
      </ul>
    </div>
  );
}
