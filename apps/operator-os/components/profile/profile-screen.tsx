"use client";

import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { Badge } from "@vexenhanh/ui/components/badge";
import { Button } from "@vexenhanh/ui/components/button";
import { Skeleton } from "@vexenhanh/ui/components/skeleton";
import { CircleAlert, CircleCheck, Clock, ExternalLink, Eye, Info, LoaderCircle, Pencil, RefreshCw, Upload } from "lucide-react";
import { useRef, useState, type ReactNode } from "react";

import { kycDocumentUrl, type KycDocumentType, type OperatorProfile, getProfile, replaceKycDocument } from "../../lib/profile/profile-api";
import { describeProfileError, formatDate, initialsOf } from "../../lib/profile/profile-format";
import { DOCUMENT_TYPES, documentFileProblem } from "../../lib/register/application";
import { BUTTON, ListStatePanel } from "../list-parts";
import { PageHeader } from "../page-header";
import { TABLE, TABLE_CELL, TABLE_HEAD_CELL, TABLE_HEAD_ROW } from "../stop-point/list-controls";
import { BankChangeDialog, ProfileEditDialog } from "./profile-dialogs";

const CARD = "flex flex-col gap-5 rounded-xl border bg-card p-6";
const CARD_TITLE = "text-lg leading-7 font-semibold text-vxn-ink";
const HELPER = "text-sm leading-5 text-muted-foreground";
const QUERY_KEY = ["operator-profile"];

type Notice = { tone: "success" | "error"; text: string };

/**
 * Màn Hồ sơ & KYC của chủ nhà xe (Figma 1667:27240; TASK-OPR-001b, UC-11, FR-OPR-02..05): hồ sơ doanh nghiệp (sửa
 * thông tin công khai), giấy tờ KYC (xem / tải bản mới, kho riêng tư), trạng thái hoạt động, tài khoản nhận tiền
 * (đổi = gửi yêu cầu chờ Admin xác minh). Trang công khai chờ Marketplace nên nút mở trang tắt.
 */
export function ProfileScreen() {
  const queryClient = useQueryClient();
  const profile = useQuery({ queryKey: QUERY_KEY, queryFn: getProfile });
  const [editing, setEditing] = useState(false);
  const [changingBank, setChangingBank] = useState(false);
  const [notice, setNotice] = useState<Notice | null>(null);
  const saved = (next: OperatorProfile, text: string) => {
    queryClient.setQueryData(QUERY_KEY, next);
    setNotice({ tone: "success", text });
  };

  if (!profile.data) {
    return (
      <div className="flex flex-col gap-6">
        <PageHeader title="Hồ sơ & KYC" description="Thông tin công khai của nhà xe, giấy tờ pháp lý và tài khoản nhận tiền." />
        {profile.isError ? (
          <ListStatePanel
            icon={<CircleAlert className="size-6 text-warning-700" />}
            title="Không tải được hồ sơ nhà xe"
            description="Kiểm tra kết nối mạng rồi thử lại."
            action={
              <Button className={`${BUTTON} w-36`} onClick={() => void profile.refetch()}>
                <RefreshCw className="size-[18px]" />
                Thử lại
              </Button>
            }
          />
        ) : (
          <div aria-label="Đang tải hồ sơ" className="grid gap-6 xl:grid-cols-[minmax(0,1fr)_360px]">
            <Skeleton className="h-[356px] rounded-xl" />
            <Skeleton className="h-[356px] rounded-xl" />
          </div>
        )}
      </div>
    );
  }

  const data = profile.data;
  const active = data.status === "ACTIVE";
  return (
    <div className="flex flex-col gap-6">
      <PageHeader
        title="Hồ sơ & KYC"
        description="Thông tin công khai của nhà xe, giấy tờ pháp lý và tài khoản nhận tiền."
        actions={<Badge tone={active ? "success" : "danger"}>{active ? "Đang hoạt động" : "Tạm khóa"}</Badge>}
      />
      {notice && (
        <div
          role={notice.tone === "success" ? "status" : "alert"}
          className={`flex items-center gap-3 rounded-lg px-5 py-3.5 text-sm leading-5 ${
            notice.tone === "success" ? "bg-success-50 font-semibold text-success-600" : "bg-error-50 text-error-600"
          }`}
        >
          {notice.tone === "success" ? <CircleCheck className="size-5 shrink-0" /> : <CircleAlert className="size-5 shrink-0" />}
          {notice.text}
        </div>
      )}

      <div className="grid items-start gap-6 xl:grid-cols-[minmax(0,1fr)_360px]">
        <div className="flex min-w-0 flex-col gap-6">
          <BusinessCard profile={data} onEdit={() => setEditing(true)} />
          <DocumentsCard
            profile={data}
            onSaved={(next, text) => saved(next, text)}
            onError={(text) => setNotice({ tone: "error", text })}
          />
        </div>
        <div className="flex min-w-0 flex-col gap-6">
          <StatusCard profile={data} />
          <BankCard profile={data} onChange={() => setChangingBank(true)} />
          <PublicPageCard />
        </div>
      </div>

      <ProfileEditDialog
        profile={data}
        open={editing}
        onClose={() => setEditing(false)}
        onSaved={(next) => saved(next, "Đã lưu hồ sơ doanh nghiệp.")}
      />
      <BankChangeDialog
        profile={data}
        open={changingBank}
        onClose={() => setChangingBank(false)}
        onSent={(next) => saved(next, "Đã gửi yêu cầu đổi tài khoản. Tài khoản cũ vẫn dùng cho tới khi được xác minh.")}
      />
    </div>
  );
}

function Field({ label, children, wide = false }: { label: string; children: ReactNode; wide?: boolean }) {
  return (
    <div className={`flex min-w-0 flex-col gap-1 ${wide ? "sm:col-span-2" : ""}`}>
      <dt className="text-xs leading-[18px] text-muted-foreground">{label}</dt>
      <dd className="text-[15px] leading-[22px] font-medium break-words whitespace-pre-line text-vxn-ink">{children}</dd>
    </div>
  );
}

const missing = <span className="font-normal text-muted-foreground">Chưa có</span>;

function BusinessCard({ profile, onEdit }: { profile: OperatorProfile; onEdit: () => void }) {
  return (
    <section aria-labelledby="business-heading" className={CARD}>
      <div className="flex flex-wrap items-start gap-3">
        <div className="flex min-w-0 flex-1 flex-col gap-1">
          <h2 id="business-heading" className={CARD_TITLE}>
            Hồ sơ doanh nghiệp
          </h2>
          <p className={HELPER}>Hiển thị trên trang nhà xe và thẻ chuyến.</p>
        </div>
        <Button type="button" variant="outline" className={`${BUTTON} bg-card`} onClick={onEdit}>
          <Pencil className="size-[18px]" />
          Chỉnh sửa
        </Button>
      </div>
      <div className="flex flex-wrap gap-5">
        <span
          aria-hidden
          className="flex size-[88px] shrink-0 items-center justify-center rounded-2xl bg-accent text-2xl font-semibold text-vxn-teal-700"
        >
          {initialsOf(profile.displayName)}
        </span>
        <dl className="grid min-w-[240px] flex-1 gap-x-6 gap-y-4 sm:grid-cols-2">
          <Field label="Tên nhà xe">{profile.displayName}</Field>
          <Field label="Mã nhà xe">{profile.slug}</Field>
          <Field label="Hotline">{profile.hotline ?? missing}</Field>
          <Field label="Email">{profile.publicEmail ?? missing}</Field>
        </dl>
      </div>
      <dl className="grid gap-4 sm:grid-cols-2">
        <Field label="Địa chỉ" wide>
          {profile.address ?? missing}
        </Field>
        <Field label="Mô tả" wide>
          {profile.description ?? missing}
        </Field>
      </dl>
    </section>
  );
}

function DocumentsCard({
  profile,
  onSaved,
  onError
}: {
  profile: OperatorProfile;
  onSaved: (profile: OperatorProfile, text: string) => void;
  onError: (text: string) => void;
}) {
  const [busy, setBusy] = useState<KycDocumentType | null>(null);
  const [viewing, setViewing] = useState<KycDocumentType | null>(null);
  async function view(type: KycDocumentType) {
    // Mở tab trước khi chờ API: trình duyệt chặn cửa sổ mở sau một lời gọi bất đồng bộ.
    const tab = window.open("about:blank", "_blank");
    setViewing(type);
    try {
      const url = await kycDocumentUrl(type);
      if (tab) {
        tab.opener = null;
        tab.location.href = url;
      }
    } catch (error) {
      tab?.close();
      onError(describeProfileError(error).message);
    } finally {
      setViewing(null);
    }
  }
  const replace = useMutation({
    mutationFn: ({ type, file }: { type: KycDocumentType; file: File }) => replaceKycDocument(type, file),
    onMutate: ({ type }) => setBusy(type),
    onSettled: () => setBusy(null),
    onSuccess: (next, { file }) => onSaved(next, `Đã cập nhật giấy tờ ${file.name}.`),
    onError: (error) => onError(describeProfileError(error).message)
  });

  return (
    <section aria-labelledby="kyc-heading" className={CARD}>
      <div className="flex flex-col gap-1">
        <h2 id="kyc-heading" className={CARD_TITLE}>
          Giấy tờ KYC
        </h2>
        <p className={HELPER}>Tệp được lưu riêng tư; mỗi lần mở tệp được ghi nhật ký.</p>
      </div>
      {/* `relative`: ô chọn tệp ẩn (định vị tuyệt đối) nằm trong vùng cuộn, không làm trang tràn ngang. */}
      <div className="relative overflow-x-auto">
        <table className={`${TABLE} min-w-[640px]`}>
          <thead>
            <tr className={TABLE_HEAD_ROW}>
              <th scope="col" className={`${TABLE_HEAD_CELL} w-[30%]`}>
                Loại giấy tờ
              </th>
              <th scope="col" className={TABLE_HEAD_CELL}>
                Tệp
              </th>
              <th scope="col" className={`${TABLE_HEAD_CELL} w-[16%]`}>
                Cập nhật
              </th>
              <th scope="col" className={`${TABLE_HEAD_CELL} w-[230px]`}>
                <span className="sr-only">Thao tác</span>
              </th>
            </tr>
          </thead>
          <tbody>
            {DOCUMENT_TYPES.map(({ type, label }) => (
              <DocumentRow
                key={type}
                label={label}
                document={profile.documents.find((document) => document.type === type)}
                uploading={busy === type}
                disabled={replace.isPending}
                viewing={viewing === type}
                onView={() => void view(type)}
                onPick={(file) => {
                  const problem = documentFileProblem(file);
                  if (problem) {
                    onError(problem);
                    return;
                  }
                  replace.mutate({ type, file });
                }}
              />
            ))}
          </tbody>
        </table>
      </div>
    </section>
  );
}

function DocumentRow({
  label,
  document,
  uploading,
  disabled,
  viewing,
  onView,
  onPick
}: {
  label: string;
  document: OperatorProfile["documents"][number] | undefined;
  uploading: boolean;
  disabled: boolean;
  viewing: boolean;
  onView: () => void;
  onPick: (file: File) => void;
}) {
  const inputRef = useRef<HTMLInputElement>(null);
  return (
    <tr className="border-b last:border-b-0">
      <td className={`${TABLE_CELL} font-semibold`}>
        <span className="line-clamp-2">{label}</span>
      </td>
      <td className={TABLE_CELL}>
        {document ? (
          <span className="flex min-w-0 flex-col">
            <span className="truncate font-medium text-vxn-ink">{document.fileName}</span>
            <span className="text-xs leading-[18px] text-muted-foreground">Tệp riêng tư</span>
          </span>
        ) : (
          <span className="text-warning-700">Chưa có tệp</span>
        )}
      </td>
      <td className={TABLE_CELL}>{document ? formatDate(document.uploadedAt) : "—"}</td>
      <td className={TABLE_CELL}>
        <div className="flex items-center justify-end gap-1">
          {document && (
            <Button type="button" variant="ghost" className="h-9 px-3 font-semibold" disabled={viewing} onClick={onView} aria-label={`Xem ${label}`}>
              Xem
              {viewing ? <LoaderCircle className="size-4 animate-spin" /> : <Eye className="size-4" />}
            </Button>
          )}
          <input
            ref={inputRef}
            type="file"
            aria-label={`Chọn tệp ${label}`}
            accept="application/pdf,image/jpeg,image/png"
            tabIndex={-1}
            className="sr-only"
            onChange={(event) => {
              const file = event.target.files?.[0];
              event.target.value = "";
              if (file) {
                onPick(file);
              }
            }}
          />
          <Button
            type="button"
            variant="ghost"
            className="h-9 px-3 font-semibold"
            disabled={disabled}
            onClick={() => inputRef.current?.click()}
            aria-label={`Tải bản mới ${label}`}
          >
            Tải bản mới
            {uploading ? <LoaderCircle className="size-4 animate-spin" /> : <Upload className="size-4" />}
          </Button>
        </div>
      </td>
    </tr>
  );
}

function StatusCard({ profile }: { profile: OperatorProfile }) {
  const active = profile.status === "ACTIVE";
  return (
    <section aria-labelledby="status-heading" className={CARD}>
      <div className="flex flex-col gap-2">
        <h2 id="status-heading" className={CARD_TITLE}>
          Trạng thái hoạt động
        </h2>
        <div className="flex flex-wrap items-center gap-2">
          <Badge tone={active ? "success" : "danger"}>{active ? "Đang hoạt động" : "Tạm khóa"}</Badge>
          {profile.approvedAt && <span className={HELPER}>Được duyệt ngày {formatDate(profile.approvedAt)}</span>}
        </div>
      </div>
      {!active && profile.suspendedReason && (
        <p className="rounded-lg bg-error-50 px-4 py-3 text-sm leading-5 text-error-700">Lý do: {profile.suspendedReason}</p>
      )}
      <div role="note" className="flex gap-2 rounded-lg bg-accent px-4 py-3 text-sm leading-5 text-vxn-teal-700">
        <Info className="mt-0.5 size-4 shrink-0" />
        Khi bị tạm khóa, nhà xe không tạo hoặc mở bán chuyến mới.
      </div>
    </section>
  );
}

function BankRow({ label, value }: { label: string; value: string }) {
  return (
    <div className="flex items-baseline justify-between gap-4 text-[15px] leading-[22px]">
      <dt className="shrink-0 text-muted-foreground">{label}</dt>
      <dd className="min-w-0 text-right font-medium break-words text-vxn-ink">{value}</dd>
    </div>
  );
}

function BankCard({ profile, onChange }: { profile: OperatorProfile; onChange: () => void }) {
  const account = profile.bankAccount;
  const change = profile.bankChange;
  const pending = change?.status === "PENDING";
  return (
    <section aria-labelledby="bank-heading" className={CARD}>
      <div className="flex items-center justify-between gap-3">
        <h2 id="bank-heading" className={CARD_TITLE}>
          Tài khoản nhận tiền
        </h2>
        {account && <Badge tone="success">Đã xác minh</Badge>}
      </div>
      {account ? (
        <dl className="flex flex-col gap-3">
          <BankRow label="Ngân hàng" value={account.bankName} />
          <BankRow label="Số tài khoản" value={account.accountNumberMasked} />
          <BankRow label="Chủ tài khoản" value={account.accountHolder} />
        </dl>
      ) : (
        <p className={HELPER}>Nhà xe chưa có tài khoản nhận tiền đã xác minh.</p>
      )}
      {change && pending && (
        <div role="status" className="flex gap-2 rounded-lg bg-warning-50 px-4 py-3 text-sm leading-5 text-warning-700">
          <Clock className="mt-0.5 size-4 shrink-0" />
          <span>
            Đang chờ xác minh: {change.bankName} · {change.accountNumberMasked} (gửi ngày {formatDate(change.requestedAt)}). Tài khoản
            hiện tại vẫn dùng cho tới khi được duyệt.
          </span>
        </div>
      )}
      {change && !pending && (
        <div role="note" className="flex gap-2 rounded-lg bg-error-50 px-4 py-3 text-sm leading-5 text-error-700">
          <CircleAlert className="mt-0.5 size-4 shrink-0" />
          <span>
            Yêu cầu đổi sang {change.bankName} · {change.accountNumberMasked} không được duyệt
            {change.reviewNote ? `: ${change.reviewNote}` : "."}
          </span>
        </div>
      )}
      <div className="flex flex-col gap-2">
        <Button type="button" variant="outline" className={`${BUTTON} w-full bg-card`} disabled={pending} onClick={onChange}>
          <Pencil className="size-[18px]" />
          Đổi tài khoản nhận tiền
        </Button>
        <p className="text-xs leading-[18px] text-muted-foreground">
          Đổi tài khoản cần xác nhận lại danh tính và qua bước xác minh bổ sung.
        </p>
      </div>
    </section>
  );
}

function PublicPageCard() {
  return (
    <section aria-labelledby="public-heading" className={CARD}>
      <div className="flex flex-col gap-1">
        <h2 id="public-heading" className={CARD_TITLE}>
          Trang công khai
        </h2>
        <p className={HELPER}>Hành khách xem hồ sơ, tuyến tiêu biểu và đánh giá của nhà xe tại đây.</p>
      </div>
      <div className="flex flex-col gap-2">
        <Button type="button" variant="outline" className={`${BUTTON} w-full bg-card`} disabled>
          <ExternalLink className="size-[18px]" />
          Mở trang nhà xe
        </Button>
        <p className="text-xs leading-[18px] text-muted-foreground">Trang công khai mở khi trang đặt vé cho hành khách ra mắt.</p>
      </div>
    </section>
  );
}
