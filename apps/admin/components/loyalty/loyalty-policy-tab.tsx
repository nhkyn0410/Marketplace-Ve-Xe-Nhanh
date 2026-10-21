"use client";

import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { IdentityField, useIdentityField } from "@vexenhanh/ui/components/auth/identity-field";
import { Button } from "@vexenhanh/ui/components/button";
import { FormField } from "@vexenhanh/ui/components/form-field";
import { Input } from "@vexenhanh/ui/components/input";
import { BUTTON } from "@vexenhanh/ui/components/list-parts";
import { Skeleton } from "@vexenhanh/ui/components/skeleton";
import { Textarea } from "@vexenhanh/ui/components/textarea";
import { withReauth } from "@vexenhanh/ui/lib/auth/reauth";
import { Check, CircleAlert, CircleCheck, Info, LoaderCircle, TriangleAlert } from "lucide-react";
import Link from "next/link";
import { useState, type ReactNode } from "react";

import { TIERS, parseRulesForm, rulesToForm, type LoyaltyRules, type LoyaltyRulesErrors, type LoyaltyRulesForm } from "../../lib/loyalty/loyalty-format";
import { createPolicyDraft, getPolicyOverview, publishPolicyVersion, updatePolicyDraft, type PolicyVersion } from "../../lib/policy/policy-api";
import { describePolicyError, fromVnLocalInput, toVnLocalInput } from "../../lib/policy/policy-format";
import { formatDate, formatDateTime, LOCK_REASON_MAX, lockReasonError } from "../../lib/user/user-format";
import { CARD, CARD_TITLE } from "../policy/cancellation-tab";
import { VersionTable } from "../policy/version-table";
import { LoyaltyFrame, TierMark } from "./loyalty-screen";

type Errors = LoyaltyRulesErrors & Partial<Record<"effectiveFrom" | "reason" | "form", string>>;

/**
 * Tham số VXN Plus (Figma ADM-12a; FR-LOY-10): phiên bản có ngày hiệu lực, không áp ngược giao dịch đã ghi. Soạn từ nháp đang có
 * hoặc phiên bản đang áp dụng; "Lưu nháp" không cần xác nhận lại danh tính, "Kích hoạt phiên bản" lưu rồi kích hoạt (lý do + mã
 * xác thực). Dùng API chính sách chung (`finance:configure`).
 */
export function LoyaltyPolicyTab() {
  // Ở ngoài form: form dựng lại theo phiên bản mới sau khi lưu / kích hoạt, câu báo vẫn giữ.
  const [notice, setNotice] = useState<string | null>(null);
  const overview = useQuery({ queryKey: ["admin-policy", "LOYALTY", null], queryFn: () => getPolicyOverview("LOYALTY", null) });
  if (!overview.data) {
    return (
      <LoyaltyFrame tab="policy">
        {overview.isError ? (
          <div role="alert" className="flex items-center gap-3 rounded-lg bg-error-50 px-5 py-3 text-sm leading-5 text-error-600">
            <CircleAlert className="size-5 shrink-0" />
            {describePolicyError(overview.error).message}
          </div>
        ) : (
          <Skeleton className="h-[640px] rounded-xl" />
        )}
      </LoyaltyFrame>
    );
  }
  const versions = overview.data.versions;
  const draft = versions.find((version) => version.state === "DRAFT");
  const active = versions.find((version) => version.state === "ACTIVE");
  return <PolicyForm key={draft?.updatedAt ?? active?.id ?? "new"} versions={versions} draft={draft} base={draft ?? active} notice={notice} onNotice={setNotice} />;
}

function PolicyForm({
  versions,
  draft,
  base,
  notice,
  onNotice
}: {
  versions: PolicyVersion[];
  draft?: PolicyVersion;
  base?: PolicyVersion;
  notice: string | null;
  onNotice: (notice: string | null) => void;
}) {
  const queryClient = useQueryClient();
  const identity = useIdentityField();
  const [form, setForm] = useState<LoyaltyRulesForm>(() => rulesToForm(base ? (base.rules as LoyaltyRules) : null));
  const [effectiveFrom, setEffectiveFrom] = useState(toVnLocalInput(draft?.effectiveFrom ?? null));
  const [reason, setReason] = useState("");
  const [errors, setErrors] = useState<Errors>({});
  const active = versions.find((version) => version.state === "ACTIVE");
  const scheduled = versions.find((version) => version.state === "SCHEDULED");

  const save = useMutation({
    mutationFn: async ({ rules, publish }: { rules: LoyaltyRules; publish: boolean }) => {
      const body = { rules, description: null, effectiveFrom: fromVnLocalInput(effectiveFrom) };
      const version = draft ? await updatePolicyDraft(draft.id, body) : await createPolicyDraft("LOYALTY", { ...body, operatorId: null });
      return publish ? withReauth(identity.secret, () => publishPolicyVersion(version.id, reason.trim())) : version;
    },
    onMutate: () => {
      onNotice(null);
      setErrors({});
    },
    onSuccess: (version, { publish }) => {
      onNotice(publish ? `Đã kích hoạt phiên bản ${version.version}, hiệu lực từ ${formatDateTime(version.effectiveFrom)}.` : `Đã lưu nháp phiên bản ${version.version}.`);
      void queryClient.invalidateQueries({ queryKey: ["admin-policy", "LOYALTY"] });
    },
    onError: (error) => {
      const described = describePolicyError(error);
      if (described.field === "identity") {
        identity.require(described.message);
        return;
      }
      identity.sync();
      setErrors({ form: described.message });
    }
  });

  function submit(publish: boolean) {
    const parsed = parseRulesForm(form);
    const next: Errors = { ...parsed.errors };
    if (publish) {
      const iso = fromVnLocalInput(effectiveFrom);
      if (!iso || new Date(iso).getTime() <= Date.now()) {
        next.effectiveFrom = "Chọn thời điểm hiệu lực ở tương lai.";
      }
      next.reason = lockReasonError(reason) ?? undefined;
    }
    setErrors(next);
    const identityOk = publish ? identity.check() : true;
    if (!parsed.rules || next.effectiveFrom || next.reason || !identityOk) {
      return;
    }
    save.mutate({ rules: parsed.rules, publish });
  }

  const busy = save.isPending;
  const field = (key: keyof Omit<LoyaltyRulesForm, "tiers">) => ({
    value: form[key],
    disabled: busy,
    inputMode: "numeric" as const,
    placeholder: "Chưa thiết lập",
    onChange: (event: { target: { value: string } }) => setForm((current) => ({ ...current, [key]: event.target.value }))
  });
  const setTier = (index: number, key: "minPoints" | "multiplier", value: string) =>
    setForm((current) => ({ ...current, tiers: current.tiers.map((row, at) => (at === index ? { ...row, [key]: value } : row)) }));

  return (
    <LoyaltyFrame
      tab="policy"
      actions={
        <>
          <Button type="button" variant="outline" className={`${BUTTON} bg-card`} disabled={busy} onClick={() => submit(false)}>
            {busy && !save.variables?.publish && <LoaderCircle className="size-[18px] animate-spin" />}
            Lưu nháp
          </Button>
          <Button type="button" className={BUTTON} disabled={busy || Boolean(scheduled)} onClick={() => submit(true)}>
            {busy && save.variables?.publish ? <LoaderCircle className="size-[18px] animate-spin" /> : <Check className="size-[18px]" />}
            Kích hoạt phiên bản
          </Button>
        </>
      }
    >
      {notice && (
        <div role="status" className="flex items-center gap-3 rounded-lg bg-success-50 px-5 py-3 text-sm leading-5 text-success-700">
          <CircleCheck className="size-5 shrink-0" />
          {notice}
        </div>
      )}
      {errors.form && (
        <div role="alert" className="flex items-center gap-3 rounded-lg bg-error-50 px-5 py-3 text-sm leading-5 text-error-600">
          <CircleAlert className="size-5 shrink-0" />
          {errors.form}
        </div>
      )}
      {scheduled ? (
        <Banner tone="warning">
          Phiên bản {scheduled.version} đã lên lịch từ {formatDateTime(scheduled.effectiveFrom)}. Hủy lịch phiên bản đó trước khi kích hoạt phiên bản khác.{" "}
          <Link href={`/policies/versions/${scheduled.id}`} className="font-semibold underline">
            Xem phiên bản {scheduled.version}
          </Link>
        </Banner>
      ) : active ? (
        <Banner tone="info">
          Đang áp dụng phiên bản {active.version} từ {formatDate(active.effectiveFrom)}.{draft ? ` Đang sửa nháp phiên bản ${draft.version}.` : " Thay đổi dưới đây tạo phiên bản mới."}
        </Banner>
      ) : (
        <Banner tone="warning">Chưa có phiên bản chính sách nào đang áp dụng. Cần điền đủ các tham số dưới đây và chọn ngày hiệu lực trước khi kích hoạt chương trình.</Banner>
      )}

      <div className="grid items-start gap-6 xl:grid-cols-[minmax(0,1fr)_368px]">
        <div className="flex min-w-0 flex-col gap-6">
          <section aria-labelledby="loyalty-earn" className={CARD}>
            <CardHeading id="loyalty-earn" title="Tích điểm và đổi điểm" description="Điểm được cộng một lần cho mỗi đơn khi chuyến hoàn thành, tính trên số tiền hành khách thực trả." />
            <div className="grid gap-4 md:grid-cols-2">
              <FormField label="Đơn vị tích điểm (₫ cho 1 điểm) *" error={errors.earnUnit}>
                {(control) => <Input {...control} {...field("earnUnit")} />}
              </FormField>
              <FormField label="Giá trị quy đổi (₫ mỗi điểm) *" error={errors.pointValue}>
                {(control) => <Input {...control} {...field("pointValue")} />}
              </FormField>
            </div>
            <div className="grid gap-4 md:grid-cols-3">
              <FormField label="Số điểm đổi tối thiểu *" error={errors.minRedeemPoints}>
                {(control) => <Input {...control} {...field("minRedeemPoints")} />}
              </FormField>
              <FormField label="Hạn dùng điểm (tháng) *" error={errors.pointExpiryMonths}>
                {(control) => <Input {...control} {...field("pointExpiryMonths")} />}
              </FormField>
              <FormField label="Hạn dùng voucher (ngày) *" error={errors.voucherValidityDays}>
                {(control) => <Input {...control} {...field("voucherValidityDays")} />}
              </FormField>
            </div>
          </section>

          <section aria-labelledby="loyalty-tiers" className={CARD}>
            <CardHeading id="loyalty-tiers" title="Hạng thành viên" description="Hạng xét theo tổng điểm tích trong 12 tháng gần nhất. Ở phiên bản hiện tại, hạng chỉ quyết định hệ số tích điểm." />
            <div className="flex flex-col gap-4">
              {TIERS.map((tier, index) => (
                <div key={tier} className="grid items-end gap-4 md:grid-cols-[minmax(0,140px)_minmax(0,1fr)_minmax(0,1fr)]">
                  <div className="flex h-9 items-center">
                    <TierMark tier={tier} />
                  </div>
                  <FormField label="Từ (điểm tích trong 12 tháng) *" error={errors.tiers?.[index]?.minPoints}>
                    {(control) => (
                      <Input
                        {...control}
                        inputMode="numeric"
                        placeholder="Chưa thiết lập"
                        value={form.tiers[index]!.minPoints}
                        readOnly={index === 0}
                        disabled={busy}
                        className={index === 0 ? "bg-muted" : undefined}
                        onChange={(event) => setTier(index, "minPoints", event.target.value)}
                      />
                    )}
                  </FormField>
                  <FormField label="Hệ số tích điểm *" error={errors.tiers?.[index]?.multiplier}>
                    {(control) => (
                      <Input
                        {...control}
                        inputMode="decimal"
                        placeholder="Chưa thiết lập"
                        value={form.tiers[index]!.multiplier}
                        disabled={busy}
                        onChange={(event) => setTier(index, "multiplier", event.target.value)}
                      />
                    )}
                  </FormField>
                </div>
              ))}
            </div>
          </section>
        </div>

        <div className="flex min-w-0 flex-col gap-6">
          <section aria-labelledby="loyalty-confirm" className={CARD}>
            <h2 id="loyalty-confirm" className={CARD_TITLE}>
              Hiệu lực và xác nhận
            </h2>
            <FormField label="Hiệu lực từ *" helper="Giờ Việt Nam; phải ở tương lai khi kích hoạt." error={errors.effectiveFrom}>
              {(control) => <Input {...control} type="datetime-local" value={effectiveFrom} disabled={busy} onChange={(event) => setEffectiveFrom(event.target.value)} />}
            </FormField>
            <FormField label="Lý do *" helper="Lý do được lưu vào nhật ký audit." error={errors.reason}>
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
            {identity.needed && <IdentityField totp value={identity.value} error={identity.error} disabled={busy} onChange={identity.change} />}
          </section>
          <section aria-labelledby="loyalty-notes" className={CARD}>
            <h2 id="loyalty-notes" className={CARD_TITLE}>
              Lưu ý
            </h2>
            <Banner tone="info">Tham số mới không áp ngược cho điểm và voucher đã ghi.</Banner>
            <Banner tone="info">Phần giảm của voucher đổi điểm do Vé Xe Nhanh chịu và được ghi dòng riêng trong sổ giữ hộ.</Banner>
          </section>
        </div>
      </div>

      {versions.length > 0 && (
        <section aria-labelledby="loyalty-versions" className={CARD}>
          <h2 id="loyalty-versions" className={CARD_TITLE}>
            Lịch sử phiên bản
          </h2>
          <VersionTable versions={versions} />
        </section>
      )}
    </LoyaltyFrame>
  );
}

function CardHeading({ id, title, description }: { id: string; title: string; description: string }) {
  return (
    <div className="flex flex-col gap-1">
      <h2 id={id} className={CARD_TITLE}>
        {title}
      </h2>
      <p className="text-sm leading-5 text-muted-foreground">{description}</p>
    </div>
  );
}

function Banner({ tone, children }: { tone: "warning" | "info"; children: ReactNode }) {
  return (
    <div role="note" className={`flex gap-3 rounded-lg px-4 py-3 text-sm leading-5 ${tone === "warning" ? "bg-warning-50 text-warning-700" : "bg-accent text-accent-foreground"}`}>
      {tone === "warning" ? <TriangleAlert className="mt-px size-5 shrink-0" /> : <Info className="mt-px size-5 shrink-0" />}
      <p>{children}</p>
    </div>
  );
}
