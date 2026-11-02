"use client";

import { useInfiniteQuery, useMutation, useQuery } from "@tanstack/react-query";
import type { IncidentPage } from "@vexenhanh/types";
import { Badge } from "@vexenhanh/ui/components/badge";
import { Button } from "@vexenhanh/ui/components/button";
import { Skeleton } from "@vexenhanh/ui/components/skeleton";
import { apiRequest } from "@vexenhanh/ui/lib/auth/api-client";
import { listOperatorOptions } from "../../lib/report/report-api";
import { shortMoment } from "../../lib/support/support-format";
import { useState } from "react";

const TYPE = { VEHICLE: "Phương tiện", TRAFFIC: "Giao thông", PASSENGER: "Hành khách", SAFETY: "An toàn", OTHER: "Khác" };
const SEVERITY = { LOW: "Nhẹ", MEDIUM: "Trung bình", HIGH: "Nghiêm trọng", CRITICAL: "Khẩn cấp" };

/** Admin xem sự cố vận hành và minh chứng, gồm sự cố nghiêm trọng được tự động báo. */
export function IncidentPanel() {
  const list = useInfiniteQuery({ queryKey: ["admin-incidents"], queryFn: ({ pageParam }) => apiRequest<IncidentPage>(`/admin/incidents${pageParam ? `?cursor=${pageParam}` : ""}`), initialPageParam: null as string | null, getNextPageParam: (page) => page.nextCursor });
  const operators = useQuery({ queryKey: ["admin-report", "operators"], queryFn: listOperatorOptions });
  const [link, setLink] = useState<{ url: string; name: string } | null>(null);
  const file = useMutation({ mutationFn: async ({ id, index, name }: { id: string; index: number; name: string }) => ({ ...(await apiRequest<{ url: string }>(`/admin/incidents/${id}/evidence/${index}`)), name }), onSuccess: setLink });
  const items = list.data?.pages.flatMap((page) => page.items) ?? [];
  return <section aria-label="Sự cố vận hành" className="flex flex-col gap-4 rounded-xl border bg-card p-6">
    <h2 className="text-lg font-semibold">Sự cố vận hành</h2><p className="text-sm text-muted-foreground">Sự cố nghiêm trọng và khẩn cấp được tự động gửi cảnh báo cho Admin. Nhà xe ghi kết quả xử lý tại Operator OS.</p>
    {list.isPending ? <Skeleton className="h-28" /> : list.isError ? <div role="alert" className="flex items-center gap-3 text-sm text-error-600">Không tải được sự cố.<Button variant="outline" onClick={() => void list.refetch()}>Thử lại</Button></div> : items.length === 0 ? <p className="py-6 text-sm text-muted-foreground">Chưa có sự cố được báo cáo.</p> : items.map((item) => <article key={item.id} className="flex flex-col gap-3 rounded-lg border p-4 text-sm">
      <div className="flex flex-wrap items-center gap-2"><strong>{operators.data?.find((operator) => operator.value === item.operatorId)?.label ?? "Nhà xe"} · {TYPE[item.type]}</strong><Badge tone={item.severity === "HIGH" || item.severity === "CRITICAL" ? "danger" : "neutral"}>{SEVERITY[item.severity]}</Badge></div>
      <p className="text-muted-foreground">{shortMoment(item.occurredAt)}{item.location ? ` · ${item.location}` : ""}</p><p className="whitespace-pre-wrap">{item.description}</p>
      <div className="flex flex-wrap gap-2">{item.evidence.map((evidence, index) => <Button key={evidence.objectKey} size="sm" variant="outline" disabled={file.isPending} onClick={() => file.mutate({ id: item.id, index, name: evidence.fileName })}>{evidence.fileName}</Button>)}</div>
      {item.resolvedAt && <p className="rounded-lg bg-success-50 p-3 text-success-700">Nhà xe đã xử lý · {shortMoment(item.resolvedAt)}<br />{item.resolution}</p>}
    </article>)}
    {file.isError && <p role="alert" className="text-sm text-error-600">Chưa mở được minh chứng. Vui lòng thử lại.</p>}{link && <a href={link.url} target="_blank" rel="noreferrer" className="text-sm text-primary underline">Mở {link.name}</a>}
    {list.hasNextPage && <Button variant="outline" disabled={list.isFetchingNextPage} onClick={() => void list.fetchNextPage()}>Xem thêm sự cố</Button>}
  </section>;
}
