"use client";

import { useInfiniteQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import type { Incident } from "@vexenhanh/types";
import { Badge } from "@vexenhanh/ui/components/badge";
import { Button } from "@vexenhanh/ui/components/button";
import { Textarea } from "@vexenhanh/ui/components/textarea";
import { Skeleton } from "@vexenhanh/ui/components/skeleton";
import { ApiError } from "@vexenhanh/ui/lib/auth/api-client";
import { Siren } from "lucide-react";
import Link from "next/link";
import { useState } from "react";
import { incidentEvidenceUrl, listIncidents, listJourneyLogs, resolveIncident } from "../../lib/support/operations-api";
import { fullMoment } from "../../lib/support/support-format";
import { BUTTON, ListStatePanel } from "../list-parts";

const TYPE = { VEHICLE: "Phương tiện", TRAFFIC: "Giao thông", PASSENGER: "Hành khách", SAFETY: "An toàn", OTHER: "Khác" };
const SEVERITY = { LOW: "Nhẹ", MEDIUM: "Trung bình", HIGH: "Nghiêm trọng", CRITICAL: "Khẩn cấp" };

/** Sự cố và nhật trình do nhân viên gửi về, cùng kết quả nhà xe xử lý. */
export function IncidentPanel() {
  const incidents = useInfiniteQuery({ queryKey: ["operator-incidents"], queryFn: ({ pageParam }) => listIncidents(pageParam ?? undefined), initialPageParam: null as string | null, getNextPageParam: (page) => page.nextCursor });
  const logs = useInfiniteQuery({ queryKey: ["operator-journey-logs"], queryFn: ({ pageParam }) => listJourneyLogs(pageParam ?? undefined), initialPageParam: null as string | null, getNextPageParam: (page) => page.nextCursor });
  const items = incidents.data?.pages.flatMap((page) => page.items) ?? [];
  const journal = logs.data?.pages.flatMap((page) => page.items) ?? [];
  return <div className="grid items-start gap-6 xl:grid-cols-2">
    <section aria-label="Sự cố đã báo" className="flex flex-col gap-4 rounded-xl border bg-card p-6">
      <h2 className="text-lg font-semibold">Sự cố đã báo</h2>
      <p className="text-sm text-muted-foreground">Sự cố nghiêm trọng và khẩn cấp tự động báo tới quản trị viên Vé Xe Nhanh.</p>
      {incidents.isPending ? <Skeleton className="h-24" /> : incidents.isError ? <Failure retry={() => void incidents.refetch()} /> : items.length === 0 ? <Empty title="Chưa có sự cố" /> : items.map((item) => <IncidentCard key={item.id} item={item} />)}
      {incidents.hasNextPage && <Button variant="outline" disabled={incidents.isFetchingNextPage} onClick={() => void incidents.fetchNextPage()}>Xem thêm sự cố</Button>}
    </section>
    <section aria-label="Nhật trình chuyến" className="flex flex-col gap-4 rounded-xl border bg-card p-6">
      <h2 className="text-lg font-semibold">Nhật trình chuyến</h2>
      {logs.isPending ? <Skeleton className="h-24" /> : logs.isError ? <Failure retry={() => void logs.refetch()} /> : journal.length === 0 ? <Empty title="Chưa có nhật trình" /> : journal.map((item) => <article key={item.id} className="flex flex-col gap-2 rounded-lg border p-4 text-sm">
        <div className="flex flex-wrap justify-between gap-2"><strong>{item.stopSequence ? `Điểm ${item.stopSequence}` : "Ghi nhận vận hành"}</strong><Link className="text-primary underline" href={`/trips/${item.tripId}`}>Xem chuyến</Link></div>
        <p className="text-muted-foreground">{fullMoment(item.actualAt)}{item.delayMinutes > 0 ? ` · Trễ ${item.delayMinutes} phút` : ""}</p>
        {item.vehicleStatus && <p>Tình trạng xe: {item.vehicleStatus}</p>}{item.note && <p className="whitespace-pre-wrap">{item.note}</p>}
      </article>)}
      {logs.hasNextPage && <Button variant="outline" disabled={logs.isFetchingNextPage} onClick={() => void logs.fetchNextPage()}>Xem thêm nhật trình</Button>}
    </section>
  </div>;
}

function IncidentCard({ item }: { item: Incident }) {
  const client = useQueryClient();
  const [resolution, setResolution] = useState("");
  const [evidenceUrl, setEvidenceUrl] = useState<{ url: string; fileName: string } | null>(null);
  const save = useMutation({ mutationFn: () => resolveIncident(item.id, resolution), onSuccess: () => void client.invalidateQueries({ queryKey: ["operator-incidents"] }) });
  const evidence = useMutation({ mutationFn: async (index: number) => ({ ...(await incidentEvidenceUrl(item.id, index)), fileName: item.evidence[index]!.fileName }), onSuccess: setEvidenceUrl });
  return <article className="flex flex-col gap-3 rounded-lg border p-4 text-sm">
    <div className="flex flex-wrap items-center gap-2"><strong>{TYPE[item.type]}</strong><Badge tone={item.severity === "HIGH" || item.severity === "CRITICAL" ? "danger" : "neutral"}>{SEVERITY[item.severity]}</Badge><Link className="ml-auto text-primary underline" href={`/trips/${item.tripId}`}>Xem chuyến</Link></div>
    <p className="text-muted-foreground">{fullMoment(item.occurredAt)}{item.location ? ` · ${item.location}` : ""}</p>
    <p className="whitespace-pre-wrap">{item.description}</p>
    {item.evidence.length > 0 && <div className="flex flex-wrap gap-2">{item.evidence.map((file, index) => <Button key={file.objectKey} size="sm" variant="outline" disabled={evidence.isPending} onClick={() => evidence.mutate(index)}>{file.fileName}</Button>)}</div>}
    {evidenceUrl && <a className="text-primary underline" target="_blank" rel="noreferrer" href={evidenceUrl.url}>Mở {evidenceUrl.fileName}</a>}
    {evidence.isError && <p role="alert" className="text-error-600">Chưa mở được minh chứng. Vui lòng thử lại.</p>}
    {item.resolvedAt ? <p className="rounded-md bg-success-50 p-3 text-success-700">Đã xử lý · {fullMoment(item.resolvedAt)}<br />{item.resolution}</p> : <form className="flex flex-col gap-2" onSubmit={(event) => { event.preventDefault(); save.mutate(); }}>
      <label htmlFor={`resolution-${item.id}`} className="font-medium">Kết quả xử lý</label><Textarea id={`resolution-${item.id}`} value={resolution} onChange={(event) => setResolution(event.target.value)} minLength={3} maxLength={3000} required />
      {save.isError && <p role="alert" className="text-error-600">{save.error instanceof ApiError ? save.error.message : "Chưa lưu được kết quả. Vui lòng thử lại."}</p>}
      <Button className={`${BUTTON} self-start`} type="submit" disabled={save.isPending || resolution.trim().length < 3}>Ghi nhận đã xử lý</Button>
    </form>}
  </article>;
}
function Empty({ title }: { title: string }) { return <ListStatePanel icon={<Siren className="size-6 text-vxn-fg-3" />} title={title} description="Dữ liệu nhân viên gửi từ ứng dụng Nhân viên sẽ hiện tại đây." compact />; }
function Failure({ retry }: { retry: () => void }) { return <div role="alert" className="flex items-center gap-3 text-sm text-error-600">Không tải được dữ liệu.<Button variant="outline" onClick={retry}>Thử lại</Button></div>; }
