"use client";

import { useQuery, useQueryClient } from "@tanstack/react-query";
import { Badge } from "@vexenhanh/ui/components/badge";
import { Button } from "@vexenhanh/ui/components/button";
import { BUTTON } from "@vexenhanh/ui/components/list-parts";
import { Skeleton } from "@vexenhanh/ui/components/skeleton";
import { ArrowLeft, CircleAlert, CircleCheck, X } from "lucide-react";
import Link from "next/link";
import { useParams, useSearchParams } from "next/navigation";
import { useState } from "react";

import { cancelPolicyVersion, getPolicyVersion, type PolicyType, type PolicyVersion } from "../../lib/policy/policy-api";
import { describePolicyError, POLICY_TYPE_LABEL, STATE, tierLabels, type Tier } from "../../lib/policy/policy-format";
import { formatDate, formatDateTime } from "../../lib/user/user-format";
import { AccountActionDialog, type AccountAction } from "../user/account-dialogs";
import { CARD, CARD_TITLE } from "./cancellation-tab";
import { PolicyEditor } from "./policy-editor";
import { ruleRows } from "./simple-policy-tab";

const TAB_OF: Record<PolicyType, string> = { CANCELLATION: "", SEAT_HOLD: "?tab=seat-hold", PAYOUT: "?tab=payout" };
const NOTICE: Record<string, string> = {
  published: "Đã kích hoạt phiên bản. Phiên bản có hiệu lực từ thời điểm đã chọn.",
  draft: "Đã lưu nháp."
};

/** Trang `/policies/new?type=…&operatorId=…`: soạn phiên bản mới. */
export function NewPolicyPage() {
  const params = useSearchParams();
  const requested = params.get("type");
  const type: PolicyType = requested === "SEAT_HOLD" || requested === "PAYOUT" ? requested : "CANCELLATION";
  return <PolicyEditor type={type} operatorId={type === "CANCELLATION" ? params.get("operatorId") : null} />;
}

/** Trang `/policies/versions/{id}`: nháp → soạn tiếp; đã kích hoạt / đã hủy → chỉ xem (bản đã lên lịch hủy được). */
export function PolicyVersionPage() {
  const { versionId } = useParams<{ versionId: string }>();
  const params = useSearchParams();
  const version = useQuery({ queryKey: ["admin-policy-version", versionId], queryFn: () => getPolicyVersion(versionId) });
  const notice = NOTICE[params.get("notice") ?? ""];
  if (!version.data) {
    return version.isError ? (
      <div role="alert" className="flex items-center gap-3 rounded-lg bg-error-50 px-5 py-3 text-sm leading-5 text-error-600">
        <CircleAlert className="size-5 shrink-0" />
        {describePolicyError(version.error).message}
      </div>
    ) : (
      <Skeleton className="h-[480px] rounded-xl" />
    );
  }
  return (
    <div className="flex flex-col gap-6">
      {notice && (
        <div role="status" className="flex items-center gap-3 rounded-lg bg-success-50 px-5 py-3 text-sm leading-5 text-success-700">
          <CircleCheck className="size-5 shrink-0" />
          {notice}
        </div>
      )}
      {version.data.status === "DRAFT" ? (
        <PolicyEditor key={version.data.updatedAt} type={version.data.type} operatorId={version.data.operatorId} draft={version.data} />
      ) : (
        <VersionView version={version.data} />
      )}
    </div>
  );
}

function VersionView({ version }: { version: PolicyVersion }) {
  const queryClient = useQueryClient();
  const [action, setAction] = useState<AccountAction | null>(null);
  const [done, setDone] = useState<string | null>(null);
  const state = STATE[version.state];
  const tiers = "tiers" in version.rules ? (version.rules.tiers as Tier[]) : null;
  const sorted = tiers ? [...tiers].sort((a, b) => b.minHoursBefore - a.minHoursBefore) : [];
  const labels = tiers ? tierLabels(tiers) : [];
  const refresh = () => {
    void queryClient.invalidateQueries({ queryKey: ["admin-policy-version", version.id] });
    void queryClient.invalidateQueries({ queryKey: ["admin-policy"] });
  };
  return (
    <>
      <Link
        href={`/policies${TAB_OF[version.type]}${version.operatorId && !TAB_OF[version.type] ? `?operatorId=${version.operatorId}` : ""}`}
        className="inline-flex w-fit items-center gap-2 text-sm font-semibold text-primary hover:underline"
      >
        <ArrowLeft className="size-4" />
        Quay lại các phiên bản
      </Link>
      <header className="flex flex-wrap items-center gap-x-6 gap-y-3">
        <div className="flex min-w-0 flex-[1_1_18rem] flex-col gap-1.5">
          <h1 className="text-[30px] leading-[38px] font-semibold text-vxn-ink">
            Phiên bản {version.version} · {POLICY_TYPE_LABEL[version.type]}
          </h1>
          <p className="text-sm leading-5 text-muted-foreground">
            {version.operatorName ? `Riêng nhà xe ${version.operatorName}` : "Mặc định toàn nền tảng"} · hiệu lực từ{" "}
            {formatDateTime(version.effectiveFrom)}
          </p>
        </div>
        <div className="flex shrink-0 items-center gap-3">
          <Badge tone={state.tone}>{state.label}</Badge>
          {version.state === "SCHEDULED" && (
            <Button
              type="button"
              variant="outline"
              className={`${BUTTON} bg-card text-error-600 hover:bg-error-50 hover:text-error-600`}
              onClick={() =>
                setAction({
                  title: "Hủy phiên bản đã lên lịch",
                  subtitle: `Phiên bản ${version.version} · hiệu lực từ ${formatDateTime(version.effectiveFrom)}`,
                  warning: "Phiên bản sẽ không bao giờ có hiệu lực. Phiên bản đang áp dụng giữ nguyên.",
                  withReason: true,
                  confirmLabel: "Hủy phiên bản",
                  destructive: true,
                  run: (reason) => cancelPolicyVersion(version.id, reason),
                  done: `Đã hủy phiên bản ${version.version}.`
                })
              }
            >
              <X className="size-[18px]" />
              Hủy lịch
            </Button>
          )}
        </div>
      </header>
      {done && (
        <div role="status" className="flex items-center gap-3 rounded-lg bg-success-50 px-5 py-3 text-sm leading-5 text-success-700">
          <CircleCheck className="size-5 shrink-0" />
          {done}
        </div>
      )}
      <div className="grid items-start gap-6 xl:grid-cols-[minmax(0,1fr)_400px]">
        <section aria-labelledby="version-content" className={CARD}>
          <h2 id="version-content" className={CARD_TITLE}>
            Nội dung chính sách
          </h2>
          <dl className="flex flex-col gap-3 text-[15px] leading-[22px]">
            {tiers
              ? sorted.map((tier, index) => (
                  <Row key={tier.minHoursBefore} label={`Hủy ${labels[index]!.charAt(0).toLowerCase()}${labels[index]!.slice(1)}`} value={tier.refundPercent === 0 ? "Không hoàn" : `Hoàn ${tier.refundPercent}%`} />
                ))
              : ruleRows(version.type as "SEAT_HOLD" | "PAYOUT", version.rules).map(([label, value]) => <Row key={label} label={label} value={value} />)}
          </dl>
          {version.description && <p className="rounded-lg bg-muted px-4 py-3 text-sm leading-5 text-vxn-fg-1">{version.description}</p>}
        </section>
        <section aria-labelledby="version-meta" className={CARD}>
          <h2 id="version-meta" className={CARD_TITLE}>
            Thông tin phiên bản
          </h2>
          <dl className="flex flex-col gap-3 text-[15px] leading-[22px]">
            <Row label="Người tạo" value={version.createdBy ?? "Hệ thống"} />
            <Row label="Kích hoạt lúc" value={formatDateTime(version.publishedAt)} />
            <Row label="Hiệu lực từ" value={formatDate(version.effectiveFrom)} />
            <Row label="Lý do thay đổi" value={version.changeReason ?? "—"} />
          </dl>
        </section>
      </div>
      <AccountActionDialog
        action={action}
        onClose={() => setAction(null)}
        onDone={(message) => {
          setDone(message);
          refresh();
        }}
        onStale={refresh}
      />
    </>
  );
}

function Row({ label, value }: { label: string; value: string }) {
  return (
    <div className="flex items-baseline justify-between gap-4">
      <dt className="text-muted-foreground">{label}</dt>
      <dd className="text-right font-semibold break-words text-vxn-ink">{value}</dd>
    </div>
  );
}
