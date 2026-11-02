"use client";

import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { Badge } from "@vexenhanh/ui/components/badge";
import { Button } from "@vexenhanh/ui/components/button";
import { Dialog, DialogContent, DialogDescription, DialogFooter, DialogHeader, DialogTitle } from "@vexenhanh/ui/components/dialog";
import { FormField } from "@vexenhanh/ui/components/form-field";
import { Input } from "@vexenhanh/ui/components/input";
import { BUTTON } from "@vexenhanh/ui/components/list-parts";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@vexenhanh/ui/components/select";
import { Skeleton } from "@vexenhanh/ui/components/skeleton";
import { Textarea } from "@vexenhanh/ui/components/textarea";
import { ApiError } from "@vexenhanh/ui/lib/auth/api-client";
import { ArrowLeft, Bell, Info, LoaderCircle, Send } from "lucide-react";
import Link from "next/link";
import { useRouter } from "next/navigation";
import { useState } from "react";

import {
  audienceLabel,
  CAMPAIGN_STATUS,
  CAMPAIGN_TIER,
  CAMPAIGN_TIERS,
  CAMPAIGN_TYPE,
  CAMPAIGN_TYPES,
  cancelCampaign,
  createCampaign,
  describeCampaignError,
  estimateAudience,
  getCampaign,
  getCampaignOptions,
  inQuietHours,
  sendCampaign,
  testCampaign,
  updateCampaign,
  type Campaign,
  type CampaignDetail,
  type CampaignFormValues,
  type CampaignTier
} from "../../lib/notification/campaign-api";
import { formatDateTime } from "../../lib/user/user-format";

const TITLE_MAX = 80;
const BODY_MAX = 500;
const COUNT = new Intl.NumberFormat("vi-VN");

const EMPTY: CampaignFormValues = { type: "SERVICE", title: "", body: "", audience: "ALL", tiers: [], promotionId: null, articleId: null };

function toValues(campaign: Campaign): CampaignFormValues {
  return { type: campaign.type, title: campaign.title, body: campaign.body, audience: campaign.audience, tiers: campaign.tiers, promotionId: campaign.promotionId, articleId: campaign.articleId };
}

/** Tạo / xem chiến dịch: bản nháp được sửa, gửi thử và gửi; đã gửi thì chỉ xem kết quả. */
export function CampaignEditor({ campaignId }: { campaignId?: string }) {
  const campaign = useQuery({
    queryKey: ["admin-campaign", campaignId],
    queryFn: () => getCampaign(campaignId!),
    enabled: Boolean(campaignId),
    retry: (count, error) => !(error instanceof ApiError && error.status === 404) && count < 2,
    // Đang gửi / chờ giờ gửi thì số liệu đổi liên tục.
    refetchInterval: (query) => (query.state.data?.status === "SENDING" || query.state.data?.status === "SCHEDULED" ? 5_000 : false)
  });
  return (
    <div className="flex flex-col gap-6">
      <Link href="/notifications" className="flex w-fit items-center gap-1.5 text-sm leading-5 font-medium text-primary hover:underline">
        <ArrowLeft className="size-[18px]" />
        Quay lại danh sách thông báo
      </Link>
      {!campaignId ? (
        <CampaignForm campaign={null} />
      ) : campaign.data ? (
        campaign.data.status === "DRAFT" ? (
          <CampaignForm key={campaign.data.id} campaign={campaign.data} />
        ) : (
          <CampaignResult campaign={campaign.data} />
        )
      ) : campaign.isError ? (
        <p role="alert" className="rounded-xl border bg-card px-6 py-10 text-center text-sm text-muted-foreground">
          {campaign.error instanceof ApiError && campaign.error.status === 404 ? "Không tìm thấy chiến dịch." : "Không tải được chiến dịch. Tải lại trang."}
        </p>
      ) : (
        <Skeleton role="status" aria-label="Đang tải chiến dịch" className="h-[520px] rounded-xl" />
      )}
    </div>
  );
}

function CampaignForm({ campaign }: { campaign: CampaignDetail | null }) {
  const router = useRouter();
  const queryClient = useQueryClient();
  const [values, setValues] = useState<CampaignFormValues>(campaign ? toValues(campaign) : EMPTY);
  const [error, setError] = useState<string | null>(null);
  const [notice, setNotice] = useState<string | null>(null);
  const [sending, setSending] = useState(false);
  const options = useQuery({ queryKey: ["admin-campaign-options"], queryFn: getCampaignOptions });
  const audienceReady = values.audience === "ALL" || values.tiers.length > 0;
  const estimate = useQuery({
    queryKey: ["admin-campaign-estimate", values.type, values.audience, values.tiers],
    queryFn: () => estimateAudience({ type: values.type, audience: values.audience, tiers: values.tiers }),
    enabled: audienceReady
  });
  const set = (patch: Partial<CampaignFormValues>) => {
    setValues((current) => ({ ...current, ...patch }));
    setNotice(null);
  };
  const chooseType = (type: CampaignFormValues["type"]) => {
    // Đổi dạng thì bỏ nội dung gắn của dạng cũ; dịch vụ luôn gửi mọi tài khoản.
    set({ type, promotionId: null, articleId: null, ...(type === "SERVICE" ? { audience: "ALL" as const, tiers: [] } : {}) });
  };
  const toggleTier = (tier: CampaignTier) => {
    set({ tiers: values.tiers.includes(tier) ? values.tiers.filter((item) => item !== tier) : [...values.tiers, tier] });
  };
  const titleError = values.title.trim().length > 0 && values.title.trim().length < 3 ? "Tiêu đề cần ít nhất 3 ký tự." : undefined;
  const bodyError = values.body.trim().length > 0 && values.body.trim().length < 3 ? "Nội dung cần ít nhất 3 ký tự." : undefined;
  const linkMissing = (values.type === "PROMOTION" && !values.promotionId) || (values.type === "NEWS" && !values.articleId);
  const complete = values.title.trim().length >= 3 && values.body.trim().length >= 3 && !linkMissing && audienceReady;
  const save = useMutation({
    mutationFn: () => (campaign ? updateCampaign(campaign.id, values) : createCampaign(values)),
    onSuccess: (next) => {
      setError(null);
      void queryClient.invalidateQueries({ queryKey: ["admin-campaigns"] });
      if (!campaign) {
        router.replace(`/notifications/${next.id}`);
        return;
      }
      // Máy chủ chuẩn hóa nội dung (cắt khoảng trắng), nên lấy bản đã lưu làm mốc so sánh để nút Gửi mở lại.
      queryClient.setQueryData<CampaignDetail>(["admin-campaign", next.id], { ...campaign, ...next });
      setValues(toValues(next));
      setNotice("Đã lưu bản nháp.");
    },
    onError: (failure) => setError(describeCampaignError(failure))
  });
  const dirty = !campaign || JSON.stringify(values) !== JSON.stringify(toValues(campaign));

  return (
    <>
      <header className="flex flex-wrap items-start justify-between gap-4">
        <div className="flex min-w-0 flex-1 basis-80 flex-col gap-1.5">
          <h1 className="text-[30px] leading-[38px] font-semibold text-vxn-ink">{campaign ? "Bản nháp thông báo" : "Tạo thông báo"}</h1>
          <p className="text-sm leading-5 text-muted-foreground">Lưu nháp, gửi thử cho một tài khoản, rồi gửi ngay hoặc hẹn giờ.</p>
        </div>
        <div className="flex flex-wrap items-center gap-3">
          <Button variant="outline" className={`${BUTTON} bg-card`} disabled={!complete || !dirty || save.isPending} onClick={() => save.mutate()}>
            {save.isPending && <LoaderCircle className="size-[18px] animate-spin" />}
            Lưu nháp
          </Button>
          {campaign && (
            <Button className={BUTTON} disabled={!complete || dirty} onClick={() => setSending(true)}>
              <Send className="size-[18px]" />
              Gửi
            </Button>
          )}
        </div>
      </header>
      {error && (
        <p role="alert" className="rounded-lg bg-error-50 px-5 py-3 text-sm leading-5 text-error-700">
          {error}
        </p>
      )}
      {notice && (
        <p role="status" className="rounded-lg bg-success-50 px-5 py-3 text-sm leading-5 text-success-700">
          {notice}
        </p>
      )}
      {campaign && dirty && (
        <p role="note" className="flex gap-2.5 rounded-lg bg-accent px-5 py-3 text-sm leading-5 text-accent-foreground">
          <Info className="mt-0.5 size-4 shrink-0" aria-hidden />
          Bạn có thay đổi chưa lưu. Lưu nháp trước khi gửi.
        </p>
      )}
      <div className="grid items-start gap-6 xl:grid-cols-[minmax(0,1fr)_380px]">
        <section aria-label="Nội dung thông báo" className="flex flex-col gap-5 rounded-xl border bg-card p-6">
          <fieldset className="flex flex-col gap-2">
            <legend className="pb-1.5 text-sm leading-5 font-medium">Dạng thông báo</legend>
            <div className="grid gap-3 md:grid-cols-3">
              {CAMPAIGN_TYPES.map((type) => (
                <label key={type} className={`flex cursor-pointer flex-col gap-1 rounded-lg border p-3 text-sm leading-5 ${values.type === type ? "border-primary bg-accent" : "bg-card"}`}>
                  <span className="flex items-center gap-2 font-semibold text-vxn-ink">
                    <input type="radio" name="campaign-type" value={type} checked={values.type === type} onChange={() => chooseType(type)} />
                    {CAMPAIGN_TYPE[type].label}
                  </span>
                  <span className="text-xs leading-[18px] text-muted-foreground">{CAMPAIGN_TYPE[type].description}</span>
                </label>
              ))}
            </div>
          </fieldset>
          {values.type === "PROMOTION" && (
            <FormField label="Khuyến mãi đang chạy" helper={options.isError ? "Không tải được danh sách khuyến mãi." : (options.data?.promotions.length ?? 1) === 0 ? "Chưa có khuyến mãi nào đang chạy." : undefined}>
              {(control) => (
                <Select value={values.promotionId ?? ""} onValueChange={(promotionId) => set({ promotionId })}>
                  <SelectTrigger {...control}>
                    <SelectValue placeholder="Chọn khuyến mãi" />
                  </SelectTrigger>
                  <SelectContent>
                    {options.data?.promotions.map((promotion) => (
                      <SelectItem key={promotion.id} value={promotion.id}>
                        {promotion.code} — {promotion.name}
                      </SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              )}
            </FormField>
          )}
          {values.type === "NEWS" && (
            <FormField label="Bài viết đã đăng" helper={options.isError ? "Không tải được danh sách bài viết." : (options.data?.articles.length ?? 1) === 0 ? "Chưa có bài viết nào đã đăng." : undefined}>
              {(control) => (
                <Select value={values.articleId ?? ""} onValueChange={(articleId) => set({ articleId })}>
                  <SelectTrigger {...control}>
                    <SelectValue placeholder="Chọn bài viết" />
                  </SelectTrigger>
                  <SelectContent>
                    {options.data?.articles.map((article) => (
                      <SelectItem key={article.id} value={article.id}>
                        {article.title}
                      </SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              )}
            </FormField>
          )}
          <FormField label="Tiêu đề" helper={`${values.title.length}/${TITLE_MAX} ký tự`} error={titleError}>
            {(control) => <Input {...control} value={values.title} maxLength={TITLE_MAX} onChange={(event) => set({ title: event.target.value })} placeholder="Vd: Bảo trì hệ thống tối 05/11" />}
          </FormField>
          <FormField label="Nội dung" helper={`${values.body.length}/${BODY_MAX} ký tự. Không ghi mật khẩu, mã OTP hay dữ liệu riêng của khách.`} error={bodyError}>
            {(control) => <Textarea {...control} rows={5} value={values.body} maxLength={BODY_MAX} onChange={(event) => set({ body: event.target.value })} />}
          </FormField>
          {values.type !== "SERVICE" && (
            <fieldset className="flex flex-col gap-2">
              <legend className="pb-1.5 text-sm leading-5 font-medium">Đối tượng</legend>
              <div className="flex flex-wrap gap-4 text-sm leading-5">
                <label className="flex items-center gap-2">
                  <input type="radio" name="campaign-audience" checked={values.audience === "ALL"} onChange={() => set({ audience: "ALL", tiers: [] })} />
                  Tất cả hành khách
                </label>
                <label className="flex items-center gap-2">
                  <input type="radio" name="campaign-audience" checked={values.audience === "LOYALTY_TIER"} onChange={() => set({ audience: "LOYALTY_TIER" })} />
                  Theo hạng VXN Plus
                </label>
              </div>
              {values.audience === "LOYALTY_TIER" && (
                <div className="flex flex-wrap gap-4 pt-1 text-sm leading-5">
                  {CAMPAIGN_TIERS.map((tier) => (
                    <label key={tier} className="flex items-center gap-2">
                      <input type="checkbox" checked={values.tiers.includes(tier)} onChange={() => toggleTier(tier)} />
                      {CAMPAIGN_TIER[tier]}
                    </label>
                  ))}
                </div>
              )}
            </fieldset>
          )}
        </section>
        <div className="flex flex-col gap-6">
          <CampaignPreview title={values.title} body={values.body} />
          <section aria-label="Người nhận" className="flex flex-col gap-3 rounded-xl border bg-card p-6 text-sm leading-5">
            <h2 className="text-lg leading-7 font-semibold text-vxn-ink">Người nhận dự kiến</h2>
            {!audienceReady ? (
              <p className="text-muted-foreground">Chọn ít nhất một hạng thành viên.</p>
            ) : estimate.isError ? (
              <p className="text-muted-foreground">Không ước tính được. Tải lại trang để thử lại.</p>
            ) : !estimate.data ? (
              <Skeleton role="status" aria-label="Đang ước tính" className="h-24 rounded-lg" />
            ) : (
              <>
                <Row label="Vào hộp thư" value={COUNT.format(estimate.data.recipients)} strong />
                <Row label="Có thiết bị nhận push" value={COUNT.format(estimate.data.withPush)} />
                {values.type !== "SERVICE" && <Row label="Đã tắt loại thông báo này" value={COUNT.format(estimate.data.optedOut)} />}
                {values.type === "PROMOTION" && <Row label="Đã nhận khuyến mãi trong 24 giờ" value={COUNT.format(estimate.data.capped)} />}
              </>
            )}
          </section>
          {campaign && <TestSender campaignId={campaign.id} disabled={dirty} />}
        </div>
      </div>
      {sending && campaign && (
        <SendDialog
          campaign={campaign}
          recipients={estimate.data?.recipients ?? null}
          onClose={() => setSending(false)}
          onSent={() => {
            setSending(false);
            void queryClient.invalidateQueries({ queryKey: ["admin-campaigns"] });
            void queryClient.invalidateQueries({ queryKey: ["admin-campaign", campaign.id] });
          }}
        />
      )}
    </>
  );
}

function Row({ label, value, strong = false }: { label: string; value: string; strong?: boolean }) {
  return (
    <p className="flex justify-between gap-3">
      <span className="text-muted-foreground">{label}</span>
      <span className={`tabular-nums ${strong ? "text-base font-semibold text-vxn-ink" : "font-medium"}`}>{value}</span>
    </p>
  );
}

function CampaignPreview({ title, body }: { title: string; body: string }) {
  return (
    <section aria-label="Khách sẽ thấy" className="flex flex-col gap-4 rounded-xl border bg-card p-6">
      <h2 className="text-lg leading-7 font-semibold text-vxn-ink">Khách sẽ thấy</h2>
      <div className="flex gap-3 rounded-lg border bg-muted p-3">
        <div className="flex size-9 shrink-0 items-center justify-center rounded-full bg-accent">
          <Bell className="size-[18px] text-primary" aria-hidden />
        </div>
        <div className="flex min-w-0 flex-col gap-0.5 text-xs leading-[18px]">
          <p className="text-muted-foreground">Vé xe nhanh · bây giờ</p>
          <p className="text-sm leading-5 font-semibold break-words text-vxn-ink">{title.trim() || "Tiêu đề thông báo"}</p>
          <p className="break-words whitespace-pre-line text-muted-foreground">{body.trim() || "Nội dung thông báo"}</p>
        </div>
      </div>
      <p className="text-xs leading-[18px] text-muted-foreground">Tin được lưu trong hộp thư của ứng dụng, kể cả khi khách không bật thông báo đẩy.</p>
    </section>
  );
}

function TestSender({ campaignId, disabled }: { campaignId: string; disabled: boolean }) {
  const [email, setEmail] = useState("");
  const [result, setResult] = useState<string | null>(null);
  const test = useMutation({
    mutationFn: () => testCampaign(campaignId, email.trim()),
    onSuccess: ({ pushDevices }) => setResult(pushDevices > 0 ? `Đã gửi thử tới hộp thư và ${pushDevices} thiết bị.` : "Đã gửi thử tới hộp thư. Tài khoản này chưa có thiết bị nhận push."),
    onError: (failure) => setResult(describeCampaignError(failure))
  });
  return (
    <section aria-label="Gửi thử" className="flex flex-col gap-3 rounded-xl border bg-card p-6">
      <h2 className="text-lg leading-7 font-semibold text-vxn-ink">Gửi thử</h2>
      <FormField label="Email tài khoản hành khách" helper="Tin thử có nhãn [Thử] và không tính vào số liệu.">
        {(control) => <Input {...control} type="email" value={email} onChange={(event) => setEmail(event.target.value)} placeholder="ban@example.com" />}
      </FormField>
      <Button variant="outline" className={`${BUTTON} w-fit bg-card`} disabled={disabled || test.isPending || !email.includes("@")} onClick={() => test.mutate()}>
        {test.isPending && <LoaderCircle className="size-[18px] animate-spin" />}
        Gửi thử
      </Button>
      {result && (
        <p role="status" className="text-xs leading-[18px] text-muted-foreground">
          {result}
        </p>
      )}
    </section>
  );
}

/** Đổi giá trị ô giờ (giờ máy) sang ISO; rỗng hoặc sai thì `null`. */
function toIso(local: string): string | null {
  const parsed = local ? new Date(local) : null;
  return parsed && !Number.isNaN(parsed.getTime()) ? parsed.toISOString() : null;
}

/** Màn xác nhận luôn hiện số người sẽ nhận, vì gửi rồi không thu hồi được. */
function SendDialog({ campaign, recipients, onClose, onSent }: { campaign: Campaign; recipients: number | null; onClose: () => void; onSent: () => void }) {
  const [mode, setMode] = useState<"now" | "later">("now");
  const [at, setAt] = useState("");
  const [error, setError] = useState<string | null>(null);
  const scheduledAt = mode === "later" ? toIso(at) : null;
  const when = mode === "later" ? (scheduledAt ? new Date(scheduledAt) : null) : new Date();
  const quiet = when ? inQuietHours(campaign.type, when) : false;
  const send = useMutation({
    mutationFn: () => sendCampaign(campaign.id, scheduledAt),
    onSuccess: onSent,
    onError: (failure) => setError(describeCampaignError(failure))
  });
  return (
    <Dialog open onOpenChange={(next) => !next && onClose()}>
      <DialogContent className="sm:max-w-[480px]">
        <DialogHeader>
          <DialogTitle>Gửi thông báo</DialogTitle>
          <DialogDescription>
            {recipients === null ? "Đang ước tính số người nhận." : `Khoảng ${COUNT.format(recipients)} hành khách sẽ nhận (${audienceLabel(campaign)}).`} Tin đã gửi không thu hồi được.
          </DialogDescription>
        </DialogHeader>
        <div className="flex flex-col gap-3 text-sm leading-5">
          <label className="flex items-center gap-2">
            <input type="radio" name="campaign-send-mode" checked={mode === "now"} onChange={() => setMode("now")} />
            Gửi ngay
          </label>
          <label className="flex items-center gap-2">
            <input type="radio" name="campaign-send-mode" checked={mode === "later"} onChange={() => setMode("later")} />
            Hẹn giờ
          </label>
          {mode === "later" && (
            <FormField label="Thời điểm gửi" helper="Trong vòng 30 ngày tới.">
              {(control) => <Input {...control} type="datetime-local" value={at} onChange={(event) => setAt(event.target.value)} />}
            </FormField>
          )}
          {quiet && (
            <p role="alert" className="rounded-lg bg-warning-50 px-3 py-2 text-xs leading-[18px] text-warning-700">
              Khuyến mãi và tin tức không gửi từ 21 giờ đến 8 giờ. Hãy chọn giờ khác.
            </p>
          )}
          {error && (
            <p role="alert" className="text-xs leading-[18px] text-error-600">
              {error}
            </p>
          )}
        </div>
        <DialogFooter>
          <Button variant="outline" className={`${BUTTON} bg-card`} onClick={onClose}>
            Để sau
          </Button>
          <Button className={BUTTON} disabled={send.isPending || quiet || (mode === "later" && !scheduledAt)} onClick={() => send.mutate()}>
            {send.isPending && <LoaderCircle className="size-[18px] animate-spin" />}
            {mode === "later" ? "Hẹn giờ gửi" : "Gửi ngay"}
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}

function CampaignResult({ campaign }: { campaign: CampaignDetail }) {
  const queryClient = useQueryClient();
  const [error, setError] = useState<string | null>(null);
  const status = CAMPAIGN_STATUS[campaign.status];
  const cancel = useMutation({
    mutationFn: () => cancelCampaign(campaign.id),
    onSuccess: () => {
      setError(null);
      void queryClient.invalidateQueries({ queryKey: ["admin-campaign", campaign.id] });
      void queryClient.invalidateQueries({ queryKey: ["admin-campaigns"] });
    },
    onError: (failure) => setError(describeCampaignError(failure))
  });
  const running = campaign.status === "SCHEDULED" || campaign.status === "SENDING";
  return (
    <>
      <header className="flex flex-wrap items-start justify-between gap-4">
        <div className="flex min-w-0 flex-1 basis-80 flex-col gap-1.5">
          <h1 className="text-[30px] leading-[38px] font-semibold break-words text-vxn-ink">{campaign.title}</h1>
          <p className="text-sm leading-5 text-muted-foreground">
            {CAMPAIGN_TYPE[campaign.type].label} · {audienceLabel(campaign)}
          </p>
        </div>
        <div className="flex flex-wrap items-center gap-3">
          <Badge tone={status.tone}>{status.label}</Badge>
          {running && (
            <Button variant="outline" className={`${BUTTON} bg-card text-error-600`} disabled={cancel.isPending} onClick={() => cancel.mutate()}>
              {campaign.status === "SENDING" ? "Dừng gửi" : "Hủy hẹn giờ"}
            </Button>
          )}
        </div>
      </header>
      {error && (
        <p role="alert" className="rounded-lg bg-error-50 px-5 py-3 text-sm leading-5 text-error-700">
          {error}
        </p>
      )}
      {campaign.note && (
        <p role="note" className="flex gap-2.5 rounded-lg bg-warning-50 px-5 py-3 text-sm leading-5 text-warning-700">
          <Info className="mt-0.5 size-4 shrink-0" aria-hidden />
          {campaign.note}
        </p>
      )}
      <div className="grid items-start gap-6 xl:grid-cols-[minmax(0,1fr)_380px]">
        <section aria-label="Kết quả gửi" className="flex flex-col gap-3 rounded-xl border bg-card p-6 text-sm leading-5">
          <h2 className="text-lg leading-7 font-semibold text-vxn-ink">Kết quả</h2>
          <Row label="Đã vào hộp thư" value={COUNT.format(campaign.recipientCount)} strong />
          <Row label="Đã đọc" value={COUNT.format(campaign.stats.read)} />
          <Row label="Push đã gửi" value={COUNT.format(campaign.stats.pushSent)} />
          <Row label="Push đang chờ" value={COUNT.format(campaign.stats.pushPending)} />
          <Row label="Push lỗi" value={COUNT.format(campaign.stats.pushFailed)} />
          <Row label="Push bỏ qua (thiết bị không còn)" value={COUNT.format(campaign.stats.pushSkipped)} />
          {campaign.type === "PROMOTION" && <Row label="Bỏ qua do đã nhận khuyến mãi trong 24 giờ" value={COUNT.format(campaign.cappedCount)} />}
          <div className="mt-2 flex flex-col gap-2 border-t pt-4">
            <Row label="Hẹn gửi" value={formatDateTime(campaign.scheduledAt)} />
            <Row label="Bắt đầu" value={formatDateTime(campaign.startedAt)} />
            <Row label="Hoàn tất" value={formatDateTime(campaign.completedAt)} />
            {campaign.cancelledAt && <Row label="Đã hủy" value={formatDateTime(campaign.cancelledAt)} />}
            {campaign.promotionLabel && <Row label="Khuyến mãi" value={campaign.promotionLabel} />}
            {campaign.articleLabel && <Row label="Bài viết" value={campaign.articleLabel} />}
          </div>
        </section>
        <CampaignPreview title={campaign.title} body={campaign.body} />
      </div>
    </>
  );
}
