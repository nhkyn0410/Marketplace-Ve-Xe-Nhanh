"use client";

import { useInfiniteQuery, useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { AttachmentChips, AttachmentPicker, type UploadedFile } from "@vexenhanh/ui/components/attachments";
import { Badge } from "@vexenhanh/ui/components/badge";
import { Button } from "@vexenhanh/ui/components/button";
import { Skeleton } from "@vexenhanh/ui/components/skeleton";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@vexenhanh/ui/components/tabs";
import { Textarea } from "@vexenhanh/ui/components/textarea";
import { ApiError } from "@vexenhanh/ui/lib/auth/api-client";
import { CircleAlert, Clock, Info, LoaderCircle, MessageSquareWarning, RefreshCw, Scale, Send } from "lucide-react";
import { usePathname, useRouter, useSearchParams } from "next/navigation";
import { useState, type ReactNode } from "react";

import { formatVnd } from "../../lib/fare/fare-format";
import {
  attachmentUrl,
  getDispute,
  getTicket,
  listDisputes,
  listTickets,
  respondDispute,
  replyTicket,
  uploadAttachment,
  type DisputeDetail,
  type DisputeSummary,
  type TicketSummary
} from "../../lib/support/support-api";
import {
  CATEGORY_LABEL,
  dayOf,
  displayBookingCode,
  DISPUTE_STATUS,
  eventLines,
  fullMoment,
  OPEN_DISPUTE,
  pendingRequest,
  shortMoment,
  TICKET_STATUS
} from "../../lib/support/support-format";
import { TAB_TRIGGER } from "../stop-point/list-controls";
import { BUTTON, ListLoadMoreFooter, ListStatePanel } from "../list-parts";
import { PageHeader } from "../page-header";
import { ReviewPanel } from "./review-panel";
import { IncidentPanel } from "./incident-panel";

const TABS = ["tickets", "disputes", "reviews", "incidents"] as const;
type Tab = (typeof TABS)[number];

/**
 * Hỗ trợ (Figma "Nhà xe · Hỗ trợ" 01–03; TASK-TRUST-001, FR-NSR-07, FR-DSP-04): khiếu nại Vé Xe Nhanh chuyển cho nhà xe (phản hồi
 * khách kèm minh chứng), tranh chấp (giải trình + minh chứng theo yêu cầu, có hạn), đánh giá (phản hồi / báo vi phạm). Tab "Sự cố
 * và nhật trình" hiện báo cáo nhân viên gửi về. Tab + hồ sơ đang mở nằm trên URL (`?tab=…&id=…`).
 */
export function SupportScreen() {
  const router = useRouter();
  const pathname = usePathname();
  const params = useSearchParams();
  const requested = params.get("tab") ?? "";
  const tab: Tab = (TABS as readonly string[]).includes(requested) ? (requested as Tab) : "tickets";
  const selected = params.get("id");
  const tickets = useQuery({ queryKey: ["operator-tickets", "count"], queryFn: () => listTickets() });
  const disputes = useQuery({ queryKey: ["operator-disputes", "count"], queryFn: () => listDisputes() });
  const go = (next: Tab, id?: string) => router.replace(`${pathname}?tab=${next}${id ? `&id=${id}` : ""}`, { scroll: false });
  return (
    <div className="flex flex-col gap-6">
      <PageHeader title="Hỗ trợ" description="Khiếu nại, tranh chấp và đánh giá liên quan tới chuyến của nhà xe; sự cố và nhật trình do nhân viên gửi về." />
      <Tabs value={tab} onValueChange={(next) => go(next as Tab)} className="flex flex-col gap-6">
        <TabsList className="h-10 w-fit max-w-full overflow-x-auto" aria-label="Nhóm hỗ trợ">
          <TabsTrigger value="tickets" className={TAB_TRIGGER}>
            Khiếu nại{tickets.data ? ` (${tickets.data.total})` : ""}
          </TabsTrigger>
          <TabsTrigger value="disputes" className={TAB_TRIGGER}>
            Tranh chấp{disputes.data ? ` (${disputes.data.open})` : ""}
          </TabsTrigger>
          <TabsTrigger value="reviews" className={TAB_TRIGGER}>
            Đánh giá
          </TabsTrigger>
          <TabsTrigger value="incidents" className={TAB_TRIGGER}>
            Sự cố và nhật trình
          </TabsTrigger>
        </TabsList>
        <TabsContent value="tickets">
          <TicketTab selected={selected} onSelect={(id) => go("tickets", id)} />
        </TabsContent>
        <TabsContent value="disputes">
          <DisputeTab selected={selected} onSelect={(id) => go("disputes", id)} />
        </TabsContent>
        <TabsContent value="reviews" className="flex flex-col gap-6">
          <ReviewPanel />
        </TabsContent>
        <TabsContent value="incidents">
          <IncidentPanel />
        </TabsContent>
      </Tabs>
    </div>
  );
}

// ------------------------------------------------------------------ Khiếu nại

function TicketTab({ selected, onSelect }: { selected: string | null; onSelect: (id: string) => void }) {
  const list = useInfiniteQuery({
    queryKey: ["operator-tickets"],
    queryFn: ({ pageParam }) => listTickets(pageParam ?? undefined),
    initialPageParam: null as string | null,
    getNextPageParam: (page) => page.nextCursor
  });
  const items = list.data?.pages.flatMap((page) => page.items) ?? [];
  const current = selected ?? items[0]?.ticketId ?? null;
  return (
    <MasterDetail
      query={list}
      count={items.length}
      empty={{ title: "Chưa có khiếu nại", description: "Khiếu nại Vé Xe Nhanh chuyển cho nhà xe phản hồi hiện ở đây." }}
      list={items.map((item) => (
        <TicketCard key={item.ticketId} item={item} active={item.ticketId === current} onSelect={() => onSelect(item.ticketId)} />
      ))}
      detail={current ? <TicketPanel ticketId={current} /> : null}
    />
  );
}

function TicketCard({ item, active, onSelect }: { item: TicketSummary; active: boolean; onSelect: () => void }) {
  const status = TICKET_STATUS[item.status];
  return (
    <ListCard active={active} onSelect={onSelect} code={item.ticketCode} badge={<Badge tone={status.tone}>{status.label}</Badge>} title={item.subject} meta={`Đơn ${displayBookingCode(item.bookingCode)} · ${dayOf(item.createdAt)}`} />
  );
}

function TicketPanel({ ticketId }: { ticketId: string }) {
  const queryClient = useQueryClient();
  const ticket = useQuery({ queryKey: ["operator-ticket", ticketId], queryFn: () => getTicket(ticketId), retry: (count, error) => !(error instanceof ApiError && error.status === 404) && count < 2 });
  const [body, setBody] = useState("");
  const [files, setFiles] = useState<UploadedFile[]>([]);
  const [error, setError] = useState<string | null>(null);
  const send = useMutation({
    mutationFn: () => replyTicket(ticketId, { body: body.trim(), attachments: files.map(({ objectKey, fileName }) => ({ objectKey, fileName })) }),
    onSuccess: (next) => {
      queryClient.setQueryData(["operator-ticket", ticketId], next);
      void queryClient.invalidateQueries({ queryKey: ["operator-tickets"] });
      setBody("");
      setFiles([]);
      setError(null);
    },
    onError: (failure) => setError(failure instanceof ApiError && failure.status === 409 ? failure.message : "Chưa gửi được phản hồi. Vui lòng thử lại.")
  });
  const detail = ticket.data;
  if (!detail) {
    return <PanelState loading={!ticket.isError} label="khiếu nại" onRetry={() => void ticket.refetch()} />;
  }
  const status = TICKET_STATUS[detail.status];
  return (
    <DetailCard title={detail.subject} subtitle={`Mã ${detail.ticketCode} · tạo lúc ${fullMoment(detail.createdAt)}`} badge={<Badge tone={status.tone}>{status.label}</Badge>}>
      <InfoBox
        rows={[
          ["Đơn liên quan", displayBookingCode(detail.bookingCode)],
          ["Chuyến", `${shortMoment(detail.trip.departureAt)} · ${detail.trip.routeName}${detail.trip.vehiclePlateNumber ? ` · ${detail.trip.vehiclePlateNumber}` : ""}`],
          ["Hành khách", detail.reporterName],
          ["Danh mục", CATEGORY_LABEL[detail.category]]
        ]}
      />
      <section aria-label="Trao đổi" className="flex flex-col gap-3">
        <h3 className="text-base leading-6 font-semibold text-vxn-ink">Trao đổi</h3>
        <ul className="flex flex-col gap-3">
          {detail.messages.map((message) => (
            <li key={message.messageId} className="flex flex-col gap-2 rounded-lg bg-muted px-4 py-3">
              <p className="text-xs leading-[18px] text-muted-foreground">
                <span className="font-semibold text-vxn-ink">{message.party === "OPERATOR" ? "Nhà xe" : message.party === "PLATFORM" ? message.authorName : "Hành khách"}</span> {fullMoment(message.createdAt)}
              </p>
              <p className="text-sm leading-5 whitespace-pre-line text-vxn-fg-1">{message.body}</p>
              <AttachmentChips files={message.attachments} resolveUrl={attachmentUrl} />
            </li>
          ))}
        </ul>
      </section>
      {detail.status !== "CLOSED" && (
        <Composer
          label="Phản hồi cho hành khách"
          placeholder="Nhập phản hồi cho hành khách…"
          body={body}
          onBody={setBody}
          files={files}
          onFiles={setFiles}
          pending={send.isPending}
          error={error}
          onSubmit={() => (body.trim() ? send.mutate() : setError("Nhập nội dung phản hồi."))}
        />
      )}
      <Note icon={<Info className="size-4 shrink-0" aria-hidden />}>Nhà xe không quyết định hoàn tiền. Vụ việc cần phân xử sẽ được Vé Xe Nhanh chuyển thành tranh chấp.</Note>
    </DetailCard>
  );
}

// ------------------------------------------------------------------ Tranh chấp

function DisputeTab({ selected, onSelect }: { selected: string | null; onSelect: (id: string) => void }) {
  const list = useInfiniteQuery({
    queryKey: ["operator-disputes"],
    queryFn: ({ pageParam }) => listDisputes(pageParam ?? undefined),
    initialPageParam: null as string | null,
    getNextPageParam: (page) => page.nextCursor
  });
  const items = list.data?.pages.flatMap((page) => page.items) ?? [];
  const current = selected ?? items[0]?.disputeId ?? null;
  return (
    <MasterDetail
      query={list}
      count={items.length}
      empty={{ title: "Không có tranh chấp", description: "Tranh chấp Vé Xe Nhanh yêu cầu nhà xe giải trình hiện ở đây." }}
      list={items.map((item) => (
        <DisputeCard key={item.disputeId} item={item} active={item.disputeId === current} onSelect={() => onSelect(item.disputeId)} />
      ))}
      detail={current ? <DisputePanel disputeId={current} /> : null}
    />
  );
}

function DisputeCard({ item, active, onSelect }: { item: DisputeSummary; active: boolean; onSelect: () => void }) {
  const status = DISPUTE_STATUS[item.status];
  return <ListCard active={active} onSelect={onSelect} code={item.disputeCode} badge={<Badge tone={status.tone}>{status.label}</Badge>} title={item.title} meta={`Đơn ${displayBookingCode(item.bookingCode)} · mở ${dayOf(item.createdAt)}`} />;
}

function DisputePanel({ disputeId }: { disputeId: string }) {
  const queryClient = useQueryClient();
  const dispute = useQuery({ queryKey: ["operator-dispute", disputeId], queryFn: () => getDispute(disputeId), retry: (count, error) => !(error instanceof ApiError && error.status === 404) && count < 2 });
  const [body, setBody] = useState("");
  const [files, setFiles] = useState<UploadedFile[]>([]);
  const [error, setError] = useState<string | null>(null);
  const send = useMutation({
    mutationFn: () => respondDispute(disputeId, { body: body.trim(), attachments: files.map(({ objectKey, fileName }) => ({ objectKey, fileName })) }),
    onSuccess: (next: DisputeDetail) => {
      queryClient.setQueryData(["operator-dispute", disputeId], next);
      void queryClient.invalidateQueries({ queryKey: ["operator-disputes"] });
      setBody("");
      setFiles([]);
      setError(null);
    },
    onError: (failure) => setError(failure instanceof ApiError && failure.status === 409 ? failure.message : "Chưa gửi được giải trình. Vui lòng thử lại.")
  });
  const detail = dispute.data;
  if (!detail) {
    return <PanelState loading={!dispute.isError} label="tranh chấp" onRetry={() => void dispute.refetch()} />;
  }
  const status = DISPUTE_STATUS[detail.status];
  const request = pendingRequest(detail);
  const open = OPEN_DISPUTE.includes(detail.status);
  const ownEvidence = detail.events.filter((event) => event.kind === "EVIDENCE");
  return (
    <DetailCard title={detail.title} subtitle={`Mã ${detail.disputeCode}${detail.supportTicketCode ? ` · từ khiếu nại ${detail.supportTicketCode}` : ""}`} badge={<Badge tone={status.tone}>{status.label}</Badge>}>
      {request && (
        <Note tone="warning" icon={<Clock className="size-4 shrink-0" aria-hidden />}>
          Vé Xe Nhanh yêu cầu: {request.body}
          {request.dueAt ? ` Hạn phản hồi: ${fullMoment(request.dueAt)}.` : ""}
        </Note>
      )}
      <InfoBox
        rows={[
          ["Đơn liên quan", `${displayBookingCode(detail.bookingCode)} · ${formatVnd(detail.paidAmount)}`],
          ["Chuyến", `${shortMoment(detail.trip.departureAt)} · ${detail.trip.routeName}`],
          ["Yêu cầu của hành khách", detail.customerRequest ?? "—"]
        ]}
      />
      {detail.decision && (
        <Note icon={<Scale className="size-4 shrink-0" aria-hidden />}>
          Quyết định của Vé Xe Nhanh: {detail.decision.decision === "REFUND" ? `hoàn ${formatVnd(detail.decision.amount ?? 0)} cho khách (trừ vào tiền chi trả của nhà xe)` : detail.decision.decision === "NO_REFUND" ? "không hoàn tiền" : "phương án khác"} — {detail.decision.reason}
        </Note>
      )}
      {ownEvidence.length > 0 && (
        <section aria-label="Giải trình đã gửi" className="flex flex-col gap-3">
          <h3 className="text-base leading-6 font-semibold text-vxn-ink">Giải trình đã gửi</h3>
          {ownEvidence.map((event) => (
            <div key={event.eventId} className="flex flex-col gap-2 rounded-lg bg-muted px-4 py-3">
              <p className="text-xs leading-[18px] text-muted-foreground">{fullMoment(event.createdAt)}</p>
              {event.body && <p className="text-sm leading-5 whitespace-pre-line">{event.body}</p>}
              <AttachmentChips files={event.attachments} resolveUrl={attachmentUrl} />
            </div>
          ))}
        </section>
      )}
      {open && (
        <Composer
          label="Giải trình của nhà xe"
          placeholder="Giải trình của nhà xe…"
          attachLabel="Đính kèm minh chứng"
          body={body}
          onBody={setBody}
          files={files}
          onFiles={setFiles}
          pending={send.isPending}
          error={error}
          onSubmit={() => (body.trim() ? send.mutate() : setError("Nhập nội dung giải trình."))}
        />
      )}
      <ol aria-label="Lịch sử tranh chấp" className="flex flex-col">
        {[...detail.events].reverse().filter((event) => event.kind !== "EVIDENCE").map((event) => {
          const lines = eventLines(event);
          return (
            <li key={event.eventId} className="flex gap-3 pb-3 last:pb-0">
              <span className={`mt-1.5 size-2.5 shrink-0 rounded-full ${event.kind === "REQUEST" ? "bg-warning-600" : "bg-vxn-fg-3"}`} aria-hidden />
              <div className="flex min-w-0 flex-1 flex-col">
                <span className="text-sm leading-5 font-semibold text-vxn-ink">{lines.title}</span>
                {lines.detail && <span className="text-sm leading-5 text-muted-foreground">{lines.detail}</span>}
              </div>
              <time className="shrink-0 text-xs leading-[18px] text-muted-foreground" dateTime={event.createdAt}>
                {shortMoment(event.createdAt)}
              </time>
            </li>
          );
        })}
      </ol>
      <Note icon={<Scale className="size-4 shrink-0" aria-hidden />}>Vé Xe Nhanh là bên phân xử cuối cùng. Quá hạn phản hồi, hồ sơ sẽ được xử lý theo minh chứng đang có.</Note>
    </DetailCard>
  );
}

// ------------------------------------------------------------------ Phần dùng chung

type PageQuery = { isPending: boolean; isError: boolean; data?: unknown; refetch: () => unknown; hasNextPage: boolean; isFetchingNextPage: boolean; isFetchNextPageError: boolean; fetchNextPage: () => unknown };

function MasterDetail({ query, count, empty, list, detail }: { query: PageQuery; count: number; empty: { title: string; description: string }; list: ReactNode[]; detail: ReactNode }) {
  if (query.isPending) {
    return (
      <div role="status" aria-label="Đang tải" className="grid gap-6 lg:grid-cols-[320px_minmax(0,1fr)]">
        <Skeleton className="h-64 rounded-xl" />
        <Skeleton className="h-96 rounded-xl" />
      </div>
    );
  }
  if (query.isError && !query.data) {
    return (
      <div className="rounded-xl border bg-card">
        <ListStatePanel
          icon={<CircleAlert className="size-6 text-warning-700" />}
          title="Không tải được dữ liệu"
          description="Không kết nối được máy chủ. Vui lòng kiểm tra kết nối và thử lại."
          action={
            <Button variant="outline" className={`${BUTTON} bg-card`} onClick={() => void query.refetch()}>
              <RefreshCw className="size-[18px]" />
              Thử lại
            </Button>
          }
          compact
        />
      </div>
    );
  }
  if (count === 0) {
    return (
      <div className="rounded-xl border bg-card">
        <ListStatePanel icon={<MessageSquareWarning className="size-6 text-vxn-fg-3" />} title={empty.title} description={empty.description} compact />
      </div>
    );
  }
  return (
    <div className="grid items-start gap-6 lg:grid-cols-[320px_minmax(0,1fr)]">
      <div className="flex flex-col gap-3">
        <ul className="flex flex-col overflow-hidden rounded-xl border bg-card">{list}</ul>
        {query.hasNextPage && (
          <ListLoadMoreFooter
            hasMore={query.hasNextPage}
            loading={query.isFetchingNextPage}
            failed={query.isFetchNextPageError}
            loadedText={`Đã tải ${count}`}
            endText={`Đã hiển thị tất cả ${count}`}
            errorText="Chưa tải thêm được."
            onLoadMore={() => void query.fetchNextPage()}
          />
        )}
      </div>
      {detail}
    </div>
  );
}

function ListCard({ active, onSelect, code, badge, title, meta }: { active: boolean; onSelect: () => void; code: string; badge: ReactNode; title: string; meta: string }) {
  return (
    <li className="border-b last:border-b-0">
      <button type="button" aria-current={active ? "true" : undefined} onClick={onSelect} className={`flex w-full flex-col gap-1.5 px-4 py-4 text-left ${active ? "bg-accent" : "hover:bg-muted"}`}>
        <span className="flex items-center justify-between gap-2">
          <span className="text-xs leading-[18px] text-muted-foreground">{code}</span>
          {badge}
        </span>
        <span className="text-sm leading-5 font-semibold text-vxn-ink">{title}</span>
        <span className="text-xs leading-[18px] text-muted-foreground">{meta}</span>
      </button>
    </li>
  );
}

function DetailCard({ title, subtitle, badge, children }: { title: string; subtitle: string; badge: ReactNode; children: ReactNode }) {
  return (
    <section aria-label={title} className="flex min-w-0 flex-col gap-5 rounded-xl border bg-card p-6">
      <header className="flex flex-wrap items-start justify-between gap-3">
        <div className="flex min-w-0 flex-col gap-1">
          <h2 className="text-xl leading-7 font-semibold text-vxn-ink">{title}</h2>
          <p className="text-sm leading-5 text-muted-foreground">{subtitle}</p>
        </div>
        {badge}
      </header>
      {children}
    </section>
  );
}

function InfoBox({ rows }: { rows: [string, string][] }) {
  return (
    <dl className="flex flex-col gap-2 rounded-lg bg-muted px-4 py-3 text-sm leading-5">
      {rows.map(([label, value]) => (
        <div key={label} className="flex items-baseline justify-between gap-4">
          <dt className="text-muted-foreground">{label}</dt>
          <dd className="text-right font-medium text-vxn-fg-1">{value}</dd>
        </div>
      ))}
    </dl>
  );
}

function Note({ icon, tone = "info", children }: { icon: ReactNode; tone?: "info" | "warning"; children: ReactNode }) {
  return (
    <p role="note" className={`flex gap-2.5 rounded-lg px-4 py-3 text-sm leading-5 ${tone === "warning" ? "bg-warning-50 text-warning-700" : "bg-accent text-vxn-teal-700"}`}>
      <span className="mt-0.5">{icon}</span>
      <span>{children}</span>
    </p>
  );
}

function Composer({
  label,
  placeholder,
  attachLabel = "Đính kèm minh chứng",
  body,
  onBody,
  files,
  onFiles,
  pending,
  error,
  onSubmit
}: {
  label: string;
  placeholder: string;
  attachLabel?: string;
  body: string;
  onBody: (value: string) => void;
  files: UploadedFile[];
  onFiles: (value: UploadedFile[]) => void;
  pending: boolean;
  error: string | null;
  onSubmit: () => void;
}) {
  return (
    <div className="flex flex-col gap-3 rounded-lg border p-3">
      <Textarea aria-label={label} rows={3} maxLength={2000} value={body} disabled={pending} placeholder={placeholder} className="border-0 shadow-none focus-visible:ring-0" onChange={(event) => onBody(event.target.value)} />
      <div className="flex flex-wrap items-center justify-between gap-3">
        <AttachmentPicker value={files} onChange={onFiles} upload={uploadAttachment} disabled={pending} label={attachLabel} />
        <Button className={BUTTON} disabled={pending} onClick={onSubmit}>
          {pending ? <LoaderCircle className="size-[18px] animate-spin" /> : <Send className="size-[18px]" />}
          Gửi phản hồi
        </Button>
      </div>
      {error && (
        <p role="alert" className="text-sm leading-5 text-error-600">
          {error}
        </p>
      )}
    </div>
  );
}

function PanelState({ loading, label, onRetry }: { loading: boolean; label: string; onRetry: () => void }) {
  if (loading) {
    return <Skeleton role="status" aria-label={`Đang tải ${label}`} className="h-96 rounded-xl" />;
  }
  return (
    <div className="rounded-xl border bg-card">
      <ListStatePanel
        icon={<CircleAlert className="size-6 text-warning-700" />}
        title={`Không tải được ${label}`}
        description="Hồ sơ không còn hoặc không kết nối được máy chủ."
        action={
          <Button variant="outline" className={`${BUTTON} bg-card`} onClick={onRetry}>
            <RefreshCw className="size-[18px]" />
            Thử lại
          </Button>
        }
        compact
      />
    </div>
  );
}
