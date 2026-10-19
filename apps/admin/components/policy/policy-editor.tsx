"use client";

import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { IdentityField, useIdentityField } from "@vexenhanh/ui/components/auth/identity-field";
import { Badge } from "@vexenhanh/ui/components/badge";
import { Button } from "@vexenhanh/ui/components/button";
import { FormField } from "@vexenhanh/ui/components/form-field";
import { Input } from "@vexenhanh/ui/components/input";
import { BUTTON } from "@vexenhanh/ui/components/list-parts";
import { Skeleton } from "@vexenhanh/ui/components/skeleton";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@vexenhanh/ui/components/select";
import { Textarea } from "@vexenhanh/ui/components/textarea";
import { withReauth } from "@vexenhanh/ui/lib/auth/reauth";
import { ArrowLeft, Check, CircleAlert, CircleCheck, LoaderCircle, Plus, Trash2, TriangleAlert } from "lucide-react";
import Link from "next/link";
import { useRouter } from "next/navigation";
import { useState } from "react";

import {
  createPolicyDraft,
  getPolicyOverview,
  type OperatorOption,
  publishPolicyVersion,
  type PolicyType,
  type PolicyVersion,
  updatePolicyDraft
} from "../../lib/policy/policy-api";
import {
  describePolicyError,
  fromVnLocalInput,
  POLICY_TYPE_LABEL,
  TIER_HOURS,
  tierLabels,
  tiersError,
  toVnLocalInput,
  type Tier
} from "../../lib/policy/policy-format";
import { formatDate, LOCK_REASON_MAX, lockReasonError } from "../../lib/user/user-format";
import { CARD, CARD_TITLE } from "./cancellation-tab";
import { OperatorPicker } from "./operator-picker";

// VXN Plus soạn ở màn riêng (`/loyalty`) — editor này không mở cho LOYALTY.
const TAB_OF: Record<PolicyType, string> = { CANCELLATION: "", SEAT_HOLD: "?tab=seat-hold", PAYOUT: "?tab=payout", LOYALTY: "" };

type Errors = Partial<Record<"rules" | "effectiveFrom" | "reason" | "scope" | "form", string>>;

/**
 * Soạn phiên bản chính sách (Figma ADM-06b): nội dung theo loại (mốc hủy / hoàn tiền, phút giữ chỗ, chu kỳ chi trả),
 * phạm vi + thời điểm hiệu lực, mô tả; cột phải tóm tắt ảnh hưởng + lý do + mã TOTP. "Lưu nháp" không cần xác nhận lại
 * danh tính; "Kích hoạt phiên bản" lưu nháp rồi kích hoạt (AS-23: chỉ hiệu lực ở tương lai). Phiên bản mới lấy nội dung
 * của phiên bản đang áp dụng làm điểm bắt đầu.
 */
export function PolicyEditor({ type, operatorId, draft }: { type: PolicyType; operatorId: string | null; draft?: PolicyVersion }) {
  const scopeId = draft ? draft.operatorId : operatorId;
  const initial = useQuery({ queryKey: ["admin-policy", type, scopeId], queryFn: () => getPolicyOverview(type, scopeId) });
  if (!initial.data) {
    return initial.isError ? (
      <div role="alert" className="flex items-center gap-3 rounded-lg bg-error-50 px-5 py-3 text-sm leading-5 text-error-600">
        <CircleAlert className="size-5 shrink-0" />
        {describePolicyError(initial.error).message}
      </div>
    ) : (
      <Skeleton className="h-[480px] rounded-xl" />
    );
  }
  const scope = scopeId ? { id: scopeId, name: initial.data.operatorName ?? "", slug: "" } : null;
  return (
    <EditorForm
      type={type}
      initialScope={scope}
      draft={draft}
      base={draft ?? initial.data.versions.find((version) => version.state === "ACTIVE")}
    />
  );
}

function EditorForm({
  type,
  initialScope,
  draft,
  base
}: {
  type: PolicyType;
  initialScope: OperatorOption | null;
  draft?: PolicyVersion;
  /** Nội dung khởi đầu: nháp đang sửa, hoặc phiên bản đang áp dụng. */
  base?: PolicyVersion;
}) {
  const router = useRouter();
  const queryClient = useQueryClient();
  const identity = useIdentityField();
  const [scope, setScope] = useState<OperatorOption | null>(initialScope);
  const overview = useQuery({
    queryKey: ["admin-policy", type, scope?.id ?? null],
    queryFn: () => getPolicyOverview(type, scope?.id ?? null)
  });
  const [tiers, setTiers] = useState<Tier[]>(() =>
    base && "tiers" in base.rules
      ? [...(base.rules.tiers as Tier[])].sort((a, b) => b.minHoursBefore - a.minHoursBefore)
      : [
          { minHoursBefore: 24, refundPercent: 90 },
          { minHoursBefore: 0, refundPercent: 0 }
        ]
  );
  const [holdMinutes, setHoldMinutes] = useState(() => String(base && "holdMinutes" in base.rules ? base.rules.holdMinutes : 10));
  const [delayDays, setDelayDays] = useState(() => String(base && "delayDays" in base.rules ? base.rules.delayDays : 3));
  const [effectiveFrom, setEffectiveFrom] = useState(toVnLocalInput(draft?.effectiveFrom ?? null));
  const [description, setDescription] = useState(draft?.description ?? "");
  const [reason, setReason] = useState("");
  const [errors, setErrors] = useState<Errors>({});
  const [saved, setSaved] = useState<string | null>(null);

  function rules(): { value: object | null; error: string | null } {
    if (type === "CANCELLATION") {
      const error = tiersError(tiers);
      return { value: error ? null : { tiers }, error };
    }
    if (type === "SEAT_HOLD") {
      const minutes = Number(holdMinutes);
      return Number.isInteger(minutes) && minutes >= 5 && minutes <= 30
        ? { value: { holdMinutes: minutes }, error: null }
        : { value: null, error: "Thời gian giữ chỗ là số phút nguyên từ 5 đến 30." };
    }
    const days = Number(delayDays);
    return Number.isInteger(days) && days >= 1 && days <= 30
      ? { value: { delayDays: days, channel: "BANK_TRANSFER", manualConfirmation: true, minimumAmount: null }, error: null }
      : { value: null, error: "Chu kỳ chi trả là số ngày nguyên từ 1 đến 30." };
  }

  async function saveDraft(ruleValue: object): Promise<PolicyVersion> {
    const body = { rules: ruleValue as PolicyVersion["rules"], description: description.trim() || null, effectiveFrom: fromVnLocalInput(effectiveFrom) };
    return draft
      ? updatePolicyDraft(draft.id, body)
      : createPolicyDraft(type, { ...body, operatorId: scope?.id ?? null });
  }

  const save = useMutation({
    mutationFn: async ({ publish }: { publish: boolean }) => {
      const value = rules().value!;
      const version = await saveDraft(value);
      return publish ? withReauth(identity.secret, () => publishPolicyVersion(version.id, reason.trim())) : version;
    },
    onMutate: () => {
      setSaved(null);
      setErrors({});
    },
    onSuccess: (version, { publish }) => {
      void queryClient.invalidateQueries({ queryKey: ["admin-policy"] });
      queryClient.setQueryData(["admin-policy-version", version.id], version);
      if (publish) {
        router.push(`/policies/versions/${version.id}?notice=published`);
      } else if (!draft) {
        router.replace(`/policies/versions/${version.id}?notice=draft`);
      } else {
        setSaved("Đã lưu nháp.");
      }
    },
    onError: (error) => {
      const described = describePolicyError(error);
      if (described.field === "identity") {
        identity.require(described.message);
        return;
      }
      identity.sync();
      setErrors({ form: described.message });
      if (described.refresh) {
        void overview.refetch();
      }
    }
  });

  function submit(publish: boolean) {
    const ruleCheck = rules();
    const next: Errors = { rules: ruleCheck.error ?? undefined };
    if (publish) {
      const iso = fromVnLocalInput(effectiveFrom);
      if (!iso || new Date(iso).getTime() <= Date.now()) {
        next.effectiveFrom = "Chọn thời điểm hiệu lực ở tương lai.";
      }
      next.reason = lockReasonError(reason) ?? undefined;
    }
    setErrors(next);
    const identityOk = publish ? identity.check() : true;
    if (Object.values(next).some(Boolean) || !identityOk) {
      return;
    }
    save.mutate({ publish });
  }

  const effectiveIso = fromVnLocalInput(effectiveFrom);
  const versions = overview.data?.versions ?? [];
  const scheduled = versions.find((version) => version.state === "SCHEDULED" && version.id !== draft?.id);
  const replaced = effectiveIso
    ? versions
        .filter((version) => version.status === "PUBLISHED" && version.effectiveFrom && version.effectiveFrom <= effectiveIso)
        .sort((a, b) => (a.effectiveFrom! < b.effectiveFrom! ? 1 : -1))[0]
    : undefined;
  const busy = save.isPending;
  const sortedTiers = [...tiers].sort((a, b) => b.minHoursBefore - a.minHoursBefore);
  const labels = tierLabels(tiers);

  return (
    <div className="flex flex-col gap-6">
      <Link href={`/policies${TAB_OF[type]}`} className="inline-flex w-fit items-center gap-2 text-sm font-semibold text-primary hover:underline">
        <ArrowLeft className="size-4" />
        Quay lại các phiên bản
      </Link>
      <header className="flex flex-wrap items-center gap-x-6 gap-y-3">
        <div className="flex min-w-0 flex-[1_1_18rem] flex-col gap-1.5">
          <h1 className="text-[30px] leading-[38px] font-semibold text-vxn-ink">
            {draft ? `Phiên bản ${draft.version} (nháp)` : "Phiên bản mới"} · {POLICY_TYPE_LABEL[type]}
          </h1>
          <p className="text-sm leading-5 text-muted-foreground">
            {base && !draft ? `Tạo từ phiên bản ${base.version}. ` : ""}Phiên bản chỉ có hiệu lực từ thời điểm bạn chọn.
          </p>
        </div>
        <div className="flex shrink-0 items-center gap-3">
          <Button type="button" variant="outline" className={`${BUTTON} bg-card`} disabled={busy} onClick={() => submit(false)}>
            {busy && !save.variables?.publish && <LoaderCircle className="size-[18px] animate-spin" />}
            Lưu nháp
          </Button>
          <Button type="button" className={BUTTON} disabled={busy} onClick={() => submit(true)}>
            {busy && save.variables?.publish ? <LoaderCircle className="size-[18px] animate-spin" /> : <Check className="size-[18px]" />}
            Kích hoạt phiên bản
          </Button>
        </div>
      </header>
      {saved && (
        <div role="status" className="flex items-center gap-3 rounded-lg bg-success-50 px-5 py-3 text-sm leading-5 text-success-700">
          <CircleCheck className="size-5 shrink-0" />
          {saved}
        </div>
      )}
      {errors.form && (
        <div role="alert" className="flex items-center gap-3 rounded-lg bg-error-50 px-5 py-3 text-sm leading-5 text-error-600">
          <CircleAlert className="size-5 shrink-0" />
          {errors.form}
        </div>
      )}

      <div className="grid items-start gap-6 xl:grid-cols-[minmax(0,1fr)_400px]">
        <div className="flex min-w-0 flex-col gap-6">
          <section aria-labelledby="policy-content" className={CARD}>
            <div className="flex flex-col gap-1">
              <h2 id="policy-content" className={CARD_TITLE}>
                Nội dung chính sách
              </h2>
              <p className="text-sm leading-5 text-muted-foreground">
                {type === "CANCELLATION"
                  ? "Các mốc tính theo thời gian còn lại trước giờ khởi hành."
                  : type === "SEAT_HOLD"
                    ? "Thời gian giữ chỗ khi hành khách đang thanh toán (mặc định 10 phút)."
                    : "Chi trả bằng chuyển khoản ngân hàng, Admin xác nhận thủ công; v1 không đặt ngưỡng tối thiểu."}
              </p>
            </div>
            {type === "CANCELLATION" && (
              <div className="flex flex-col gap-4">
                {tiers.map((tier, index) => (
                  <div key={index} className="grid items-start gap-3 sm:grid-cols-[minmax(0,1fr)_160px_36px]">
                    <FormField label="Hủy trước giờ khởi hành" helper={labels[sortedTiers.indexOf(tier)]}>
                      {(control) => (
                        <Select
                          value={String(tier.minHoursBefore)}
                          disabled={busy}
                          onValueChange={(next) => setTiers((all) => all.map((item, at) => (at === index ? { ...item, minHoursBefore: Number(next) } : item)))}
                        >
                          <SelectTrigger {...control} className="w-full">
                            <SelectValue />
                          </SelectTrigger>
                          <SelectContent>
                            {TIER_HOURS.map((hours) => (
                              <SelectItem key={hours} value={String(hours)}>
                                {hours === 0 ? "Từ 0 giờ (sát giờ khởi hành)" : `Từ ${hours} giờ`}
                              </SelectItem>
                            ))}
                          </SelectContent>
                        </Select>
                      )}
                    </FormField>
                    <FormField label="Mức hoàn (%)">
                      {(control) => (
                        <Input
                          {...control}
                          inputMode="numeric"
                          value={String(tier.refundPercent)}
                          disabled={busy}
                          onChange={(event) => {
                            const value = Number(event.target.value.replace(/\D/g, "") || "0");
                            setTiers((all) => all.map((item, at) => (at === index ? { ...item, refundPercent: value } : item)));
                          }}
                        />
                      )}
                    </FormField>
                    <Button
                      type="button"
                      variant="ghost"
                      className="size-9 p-0 sm:mt-7"
                      aria-label={`Xóa mốc ${index + 1}`}
                      disabled={busy || tiers.length === 1}
                      onClick={() => setTiers((all) => all.filter((_, at) => at !== index))}
                    >
                      <Trash2 className="size-4" />
                    </Button>
                  </div>
                ))}
                {errors.rules && (
                  <p role="alert" className="text-sm leading-5 text-error-600">
                    {errors.rules}
                  </p>
                )}
                <Button
                  type="button"
                  variant="outline"
                  className={`${BUTTON} w-fit bg-card`}
                  disabled={busy || tiers.length >= 10}
                  onClick={() => {
                    const free = TIER_HOURS.find((hours) => !tiers.some((tier) => tier.minHoursBefore === hours)) ?? 0;
                    setTiers((all) => [...all, { minHoursBefore: free, refundPercent: 0 }]);
                  }}
                >
                  <Plus className="size-[18px]" />
                  Thêm mốc
                </Button>
              </div>
            )}
            {type === "SEAT_HOLD" && (
              <FormField label="Thời gian giữ chỗ (phút) *" helper="Từ 5 đến 30 phút." error={errors.rules}>
                {(control) => (
                  <Input {...control} inputMode="numeric" className="max-w-40" value={holdMinutes} disabled={busy} onChange={(event) => setHoldMinutes(event.target.value)} />
                )}
              </FormField>
            )}
            {type === "PAYOUT" && (
              <div className="flex flex-col gap-4">
                <FormField label="Chu kỳ chi trả: T + số ngày sau khi chuyến hoàn thành *" helper="Từ 1 đến 30 ngày." error={errors.rules}>
                  {(control) => (
                    <Input {...control} inputMode="numeric" className="max-w-40" value={delayDays} disabled={busy} onChange={(event) => setDelayDays(event.target.value)} />
                  )}
                </FormField>
                <dl className="grid gap-2 rounded-lg bg-muted px-4 py-3 text-sm leading-5">
                  <div className="flex justify-between gap-3">
                    <dt className="text-muted-foreground">Kênh chi trả</dt>
                    <dd className="font-semibold text-vxn-ink">Chuyển khoản ngân hàng</dd>
                  </div>
                  <div className="flex justify-between gap-3">
                    <dt className="text-muted-foreground">Xác nhận</dt>
                    <dd className="font-semibold text-vxn-ink">Thủ công bởi Admin (bắt buộc)</dd>
                  </div>
                  <div className="flex justify-between gap-3">
                    <dt className="text-muted-foreground">Ngưỡng tối thiểu</dt>
                    <dd className="font-semibold text-vxn-ink">Không đặt</dd>
                  </div>
                </dl>
              </div>
            )}
          </section>

          <section aria-labelledby="policy-scope" className={CARD}>
            <h2 id="policy-scope" className={CARD_TITLE}>
              Phạm vi và hiệu lực
            </h2>
            <div className="grid gap-4 md:grid-cols-2">
              <FormField label="Phạm vi *">
                {(control) =>
                  type === "CANCELLATION" && !draft ? (
                    <OperatorPicker id={control.id} value={scope} onChange={setScope} disabled={busy} platformLabel="Mặc định toàn nền tảng" />
                  ) : (
                    <Input {...control} readOnly value={scope ? `Riêng: ${scope.name}` : "Mặc định toàn nền tảng"} />
                  )
                }
              </FormField>
              <FormField label="Hiệu lực từ *" helper="Giờ Việt Nam; phải ở tương lai khi kích hoạt." error={errors.effectiveFrom}>
                {(control) => (
                  <Input {...control} type="datetime-local" value={effectiveFrom} disabled={busy} onChange={(event) => setEffectiveFrom(event.target.value)} />
                )}
              </FormField>
            </div>
            <FormField label="Mô tả" helper="Hiển thị trong lịch sử phiên bản">
              {(control) => (
                <Textarea {...control} rows={3} maxLength={1000} value={description} disabled={busy} onChange={(event) => setDescription(event.target.value)} />
              )}
            </FormField>
          </section>
        </div>

        <div className="flex min-w-0 flex-col gap-6">
          <section aria-labelledby="policy-impact" className={CARD}>
            <div className="flex flex-col gap-1">
              <h2 id="policy-impact" className={CARD_TITLE}>
                Tóm tắt ảnh hưởng
              </h2>
              <p className="text-sm leading-5 text-muted-foreground">Xem lại trước khi kích hoạt.</p>
            </div>
            <dl className="flex flex-col gap-3 text-[15px] leading-[22px]">
              <Row label="Thay thế" value={replaced ? `Phiên bản ${replaced.version} (từ ${formatDate(replaced.effectiveFrom)})` : "Không có — phiên bản đầu"} />
              {overview.data &&
                (scope ? (
                  <Row label="Áp dụng cho" value={scope.name || overview.data.operatorName || "Nhà xe"} />
                ) : type === "CANCELLATION" ? (
                  <>
                    <Row label="Nhà xe áp dụng mặc định" value={`${Math.max(0, overview.data.activeOperatorCount - overview.data.overrides.length)} nhà xe`} />
                    <Row label="Nhà xe có chính sách riêng" value={`${overview.data.overrides.length} · không đổi`} />
                  </>
                ) : (
                  <Row label="Phạm vi" value={`Toàn nền tảng · ${overview.data.activeOperatorCount} nhà xe`} />
                ))}
              <Row label="Đơn đã đặt trước ngày hiệu lực" value="Không đổi" />
            </dl>
            {scheduled ? (
              <p className="flex gap-2 rounded-lg bg-warning-50 px-4 py-3 text-sm leading-5 text-warning-700">
                <TriangleAlert className="mt-0.5 size-4 shrink-0" />
                Phiên bản {scheduled.version} đã lên lịch từ {formatDate(scheduled.effectiveFrom)}. Hủy phiên bản đó trước khi kích hoạt phiên bản này.
              </p>
            ) : effectiveIso && new Date(effectiveIso).getTime() > Date.now() ? (
              <p className="flex gap-2 rounded-lg bg-success-50 px-4 py-3 text-sm leading-5 text-success-700">
                <CircleCheck className="mt-0.5 size-4 shrink-0" />
                Không trùng thời gian hiệu lực với phiên bản khác.
              </p>
            ) : (
              <p className="flex gap-2 rounded-lg bg-muted px-4 py-3 text-sm leading-5 text-muted-foreground">
                <CircleAlert className="mt-0.5 size-4 shrink-0" />
                Chọn thời điểm hiệu lực ở tương lai để kích hoạt.
              </p>
            )}
          </section>
          <section aria-labelledby="policy-confirm" className={CARD}>
            <h2 id="policy-confirm" className={CARD_TITLE}>
              Xác nhận
            </h2>
            <FormField label="Lý do thay đổi *" helper="Lý do được lưu vào nhật ký audit." error={errors.reason}>
              {(control) => (
                <Textarea
                  {...control}
                  rows={3}
                  maxLength={LOCK_REASON_MAX}
                  placeholder={`Nhập lý do (3–${LOCK_REASON_MAX} ký tự)…`}
                  value={reason}
                  disabled={busy}
                  onChange={(event) => setReason(event.target.value)}
                />
              )}
            </FormField>
            {identity.needed && (
              <IdentityField totp value={identity.value} error={identity.error} disabled={busy} onChange={identity.change} />
            )}
            {draft && <Badge tone="neutral">Đang sửa nháp · phiên bản {draft.version}</Badge>}
          </section>
        </div>
      </div>
    </div>
  );
}

function Row({ label, value }: { label: string; value: string }) {
  return (
    <div className="flex items-baseline justify-between gap-4">
      <dt className="text-muted-foreground">{label}</dt>
      <dd className="text-right font-semibold text-vxn-ink">{value}</dd>
    </div>
  );
}
