"use client";

import { useInfiniteQuery, useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { Badge } from "@vexenhanh/ui/components/badge";
import { Button } from "@vexenhanh/ui/components/button";
import { Dialog, DialogContent, DialogDescription, DialogFooter, DialogHeader, DialogTitle } from "@vexenhanh/ui/components/dialog";
import { FormField } from "@vexenhanh/ui/components/form-field";
import { Input } from "@vexenhanh/ui/components/input";
import { ALL, FilterSelect, SearchField, TAB_TRIGGER, TABLE, TABLE_CELL, TABLE_HEAD_CELL, TABLE_HEAD_ROW, TableSkeleton, useDebouncedValue } from "@vexenhanh/ui/components/list-controls";
import { BUTTON, ListLoadMoreFooter, ListStatePanel } from "@vexenhanh/ui/components/list-parts";
import { Skeleton } from "@vexenhanh/ui/components/skeleton";
import { Switch } from "@vexenhanh/ui/components/switch";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@vexenhanh/ui/components/tabs";
import { capLabel, discountLabel, minOrderLabel, PROMOTION_DISPLAY, PROMOTION_DISPLAY_ORDER, usageLabel, windowLabel } from "@vexenhanh/ui/lib/promotion-format";
import { ChevronRight, CircleAlert, Info, LoaderCircle, Pencil, Plus, RefreshCw, TicketPercent } from "lucide-react";
import Link from "next/link";
import { usePathname, useRouter, useSearchParams } from "next/navigation";
import { useState, type ReactNode } from "react";

import { formatVnd } from "../../lib/payment/payment-format";
import { describePromotionError, listPermissions, listPromotions, savePermission, setPromotionStatus, type Permission, type Promotion, type PromotionDisplay } from "../../lib/promotion/promotion-api";
import { listOperatorOptions } from "../../lib/report/report-api";
import { PageHeader } from "../page-header";

const TABS = ["platform", "permissions", "operators"] as const;
type Tab = (typeof TABS)[number];
const COUNT = new Intl.NumberFormat("vi-VN");

/**
 * Khuyến mãi (Figma ADM-11a/b; TASK-PROM-001, FR-PROM-01..03, FR-ADM-12): khuyến mãi nền tảng (nhà xe tham gia sẽ chịu phần giảm —
 * Khanh 18/10/2026), quyền + giới hạn cho nhà xe tự tạo, khuyến mãi của các nhà xe (tạm dừng / kết thúc khi vi phạm).
 */
export function PromotionScreen() {
  const router = useRouter();
  const pathname = usePathname();
  const params = useSearchParams();
  const requested = params.get("tab") ?? "";
  const tab: Tab = (TABS as readonly string[]).includes(requested) ? (requested as Tab) : "platform";
  return (
    <div className="flex flex-col gap-6">
      <PageHeader
        title="Khuyến mãi"
        description="Chương trình cấp nền tảng và giới hạn cho phép nhà xe tự tạo khuyến mãi."
        actions={
          <Button asChild className={BUTTON}>
            <Link href="/promotions/new">
              <Plus className="size-[18px]" />
              Tạo khuyến mãi
            </Link>
          </Button>
        }
      />
      <Tabs value={tab} onValueChange={(next) => router.replace(next === "platform" ? pathname : `${pathname}?tab=${next}`, { scroll: false })} className="flex flex-col gap-6">
        <TabsList className="h-10 w-fit max-w-full overflow-x-auto" aria-label="Nhóm khuyến mãi">
          <TabsTrigger value="platform" className={TAB_TRIGGER}>
            Khuyến mãi nền tảng
          </TabsTrigger>
          <TabsTrigger value="permissions" className={TAB_TRIGGER}>
            Quyền của nhà xe
          </TabsTrigger>
          <TabsTrigger value="operators" className={TAB_TRIGGER}>
            Khuyến mãi của nhà xe
          </TabsTrigger>
        </TabsList>
        <TabsContent value="platform" className="flex flex-col gap-6">
          <PromotionList scope="PLATFORM" />
        </TabsContent>
        <TabsContent value="permissions" className="flex flex-col gap-6">
          <PermissionList />
        </TabsContent>
        <TabsContent value="operators" className="flex flex-col gap-6">
          <PromotionList scope="OPERATOR" />
        </TabsContent>
      </Tabs>
    </div>
  );
}

function Stat({ label, value, note }: { label: string; value: string | null; note: string }) {
  return (
    <div className="flex flex-col gap-2 rounded-xl border bg-card p-5">
      <p className="text-sm leading-5 text-muted-foreground">{label}</p>
      {value === null ? <Skeleton className="h-9 w-24" /> : <p className="text-[28px] leading-9 font-semibold text-vxn-ink tabular-nums">{value}</p>}
      <p className="text-xs leading-[18px] text-muted-foreground">{note}</p>
    </div>
  );
}

function PromotionList({ scope }: { scope: "PLATFORM" | "OPERATOR" }) {
  const queryClient = useQueryClient();
  const [display, setDisplay] = useState(ALL);
  const [operatorId, setOperatorId] = useState(ALL);
  const [search, setSearch] = useState("");
  const [notice, setNotice] = useState<string | null>(null);
  const q = useDebouncedValue(search.trim());
  const operators = useQuery({ queryKey: ["admin-report", "operators"], queryFn: listOperatorOptions, enabled: scope === "OPERATOR" });
  const list = useInfiniteQuery({
    queryKey: ["admin-promotions", scope, display, operatorId, q],
    queryFn: ({ pageParam }) =>
      listPromotions({ scope, display: display === ALL ? undefined : (display as PromotionDisplay), operatorId: operatorId === ALL ? undefined : operatorId, q: q || undefined, cursor: pageParam ?? undefined }),
    initialPageParam: null as string | null,
    getNextPageParam: (page) => page.nextCursor
  });
  const stop = useMutation({
    mutationFn: ({ promotion, status }: { promotion: Promotion; status: "PAUSED" | "ENDED" }) => setPromotionStatus(promotion.promotionId, status),
    onSuccess: (next) => {
      setNotice(`${next.code}: ${PROMOTION_DISPLAY[next.display].label.toLowerCase()}.`);
      void queryClient.invalidateQueries({ queryKey: ["admin-promotions"] });
    },
    onError: (failure) => setNotice(describePromotionError(failure))
  });
  const items = list.data?.pages.flatMap((page) => page.items) ?? [];
  const stats = list.data?.pages[0]?.stats;
  const total = list.data?.pages[0]?.total ?? 0;
  const platform = scope === "PLATFORM";

  let body: ReactNode;
  if (list.isPending) {
    body = <TableSkeleton label="Đang tải khuyến mãi" rows={5} />;
  } else if (list.isError && !list.data) {
    body = (
      <ListStatePanel
        icon={<CircleAlert className="size-6 text-warning-700" />}
        title="Không tải được khuyến mãi"
        description="Không kết nối được máy chủ. Vui lòng kiểm tra kết nối và thử lại."
        action={
          <Button variant="outline" className={`${BUTTON} bg-card`} onClick={() => void list.refetch()}>
            <RefreshCw className="size-[18px]" />
            Thử lại
          </Button>
        }
        compact
      />
    );
  } else if (items.length === 0) {
    body = <ListStatePanel icon={<TicketPercent className="size-6 text-vxn-fg-3" />} title="Chưa có khuyến mãi" description={platform ? "Tạo khuyến mãi nền tảng; nhà xe tham gia sẽ chịu phần giảm cho chuyến của mình." : "Khuyến mãi nhà xe tự tạo trong giới hạn được cấp hiện ở đây."} compact />;
  } else {
    body = (
      <div className="overflow-x-auto">
        <table className={`${TABLE} min-w-[980px]`}>
          <thead>
            <tr className={TABLE_HEAD_ROW}>
              {["Mã và tên", "Mức giảm", platform ? "Nhà xe tham gia" : "Nhà xe · phạm vi", "Hiệu lực", "Lượt dùng", "Trạng thái", ""].map((heading, index) => (
                <th key={index} scope="col" className={`${TABLE_HEAD_CELL} ${heading === "Lượt dùng" ? "text-right" : ""}`}>
                  {heading}
                </th>
              ))}
            </tr>
          </thead>
          <tbody>
            {items.map((promotion) => (
              <tr key={promotion.promotionId} className="border-b last:border-b-0">
                <td className={TABLE_CELL}>
                  <p className="font-semibold text-vxn-ink">{promotion.code}</p>
                  <p className="truncate text-xs leading-[18px] text-muted-foreground">{promotion.name}</p>
                </td>
                <td className={TABLE_CELL}>
                  <p className="font-semibold text-vxn-ink">{discountLabel(promotion)}</p>
                  <p className="text-xs leading-[18px] text-muted-foreground">{minOrderLabel(promotion.minOrder)}</p>
                </td>
                <td className={TABLE_CELL}>{platform ? <><span>{COUNT.format(promotion.participants ?? 0)} nhà xe</span><p className="mt-1 text-xs text-muted-foreground">{promotion.routeIds.length > 0 ? promotion.routeNames.join(", ") : "Mọi tuyến của nhà xe tham gia"}</p></> : `${promotion.operatorName ?? ""} · ${promotion.routeName ?? "Mọi tuyến"}`}</td>
                <td className={`${TABLE_CELL} tabular-nums`}>{windowLabel(promotion.startsAt, promotion.endsAt)}</td>
                <td className={`${TABLE_CELL} text-right font-semibold tabular-nums`}>{usageLabel(promotion.usedCount, promotion.usageLimit)}</td>
                <td className={TABLE_CELL}>
                  <Badge tone={PROMOTION_DISPLAY[promotion.display].tone}>{PROMOTION_DISPLAY[promotion.display].label}</Badge>
                </td>
                <td className={TABLE_CELL}>
                  {platform ? (
                    <Link href={`/promotions/${promotion.promotionId}`} className="inline-flex items-center font-semibold text-vxn-ink" aria-label={`Xem ${promotion.code}`}>
                      Xem
                      <ChevronRight className="size-4" />
                    </Link>
                  ) : promotion.display === "RUNNING" || promotion.display === "SCHEDULED" ? (
                    <Button variant="outline" size="sm" className="bg-card" disabled={stop.isPending} onClick={() => stop.mutate({ promotion, status: "PAUSED" })}>
                      Tạm dừng
                    </Button>
                  ) : promotion.display !== "ENDED" ? (
                    <Button variant="outline" size="sm" className="bg-card" disabled={stop.isPending} onClick={() => stop.mutate({ promotion, status: "ENDED" })}>
                      Kết thúc
                    </Button>
                  ) : null}
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    );
  }

  return (
    <>
      <div className="grid gap-4 sm:grid-cols-2 xl:grid-cols-4">
        <Stat label="Đang chạy" value={stats ? COUNT.format(stats.running) : null} note={stats ? `${stats.scheduled} đã lên lịch · ${stats.drafts} nháp · ${stats.paused} tạm dừng` : ""} />
        <Stat label="Lượt áp dụng" value={stats ? COUNT.format(stats.redemptions) : null} note="30 ngày gần nhất" />
        <Stat label="Tổng giá trị giảm" value={stats ? formatVnd(stats.discount) : null} note={platform ? "30 ngày gần nhất · nhà xe tham gia chịu" : "30 ngày gần nhất · trừ vào doanh thu nhà xe"} />
        <Stat label="Doanh thu có áp mã" value={stats ? formatVnd(stats.revenue) : null} note="30 ngày gần nhất" />
      </div>
      {notice && (
        <p role="status" className="rounded-lg bg-success-50 px-5 py-3 text-sm leading-5 text-success-700">
          {notice}
        </p>
      )}
      <section aria-label={platform ? "Khuyến mãi nền tảng" : "Khuyến mãi của nhà xe"} className="flex flex-col rounded-xl border bg-card p-6">
        <div className="flex flex-wrap items-end gap-x-4 gap-y-3 pb-5">
          <SearchField value={search} onChange={setSearch} placeholder="Mã hoặc tên chương trình" />
          <FilterSelect label="Trạng thái" allLabel="Tất cả trạng thái" value={display} onChange={setDisplay} options={PROMOTION_DISPLAY_ORDER.map((value) => ({ value, label: PROMOTION_DISPLAY[value].label }))} className="w-44" />
          {!platform && <FilterSelect label="Nhà xe" allLabel="Tất cả nhà xe" value={operatorId} onChange={setOperatorId} options={operators.data ?? []} className="w-48" />}
        </div>
        {body}
        {items.length > 0 && (
          <div className="flex pt-5">
            <ListLoadMoreFooter
              hasMore={list.hasNextPage}
              loading={list.isFetchingNextPage}
              failed={list.isFetchNextPageError}
              loadedText={`Đã tải ${items.length} / ${COUNT.format(total)} chương trình`}
              endText={`Đã tải ${COUNT.format(items.length)} chương trình`}
              errorText="Chưa tải thêm được."
              onLoadMore={() => void list.fetchNextPage()}
            />
          </div>
        )}
      </section>
      <div role="note" className="flex items-center gap-3 rounded-lg bg-accent px-5 py-4 text-sm leading-5 text-accent-foreground">
        <Info className="size-[18px] shrink-0" aria-hidden />
        Mỗi đơn chỉ áp dụng một mã. Khuyến mãi đã được dùng trong đơn thì không sửa điều kiện; hãy kết thúc và tạo chương trình mới.
        {platform ? " Khuyến mãi nền tảng chỉ áp cho chuyến của nhà xe đã tham gia — nhà xe chịu phần giảm." : ""}
      </div>
    </>
  );
}

function PermissionList() {
  const [enabled, setEnabled] = useState(ALL);
  const [search, setSearch] = useState("");
  const [editing, setEditing] = useState<Permission | null>(null);
  const q = useDebouncedValue(search.trim());
  const list = useInfiniteQuery({
    queryKey: ["admin-promotion-permissions", enabled, q],
    queryFn: ({ pageParam }) => listPermissions({ enabled: enabled === ALL ? undefined : (enabled as "yes" | "no"), q: q || undefined, cursor: pageParam ?? undefined }),
    initialPageParam: null as string | null,
    getNextPageParam: (page) => page.nextCursor
  });
  const items = list.data?.pages.flatMap((page) => page.items) ?? [];
  const total = list.data?.pages[0]?.total ?? 0;
  return (
    <>
      <section aria-label="Quyền của nhà xe" className="flex flex-col rounded-xl border bg-card p-6">
        <div className="flex flex-wrap items-end gap-x-4 gap-y-3 pb-5">
          <SearchField value={search} onChange={setSearch} placeholder="Tên hoặc mã nhà xe" />
          <FilterSelect
            label="Quyền tự tạo"
            allLabel="Tất cả"
            value={enabled}
            onChange={setEnabled}
            options={[
              { value: "yes", label: "Được tự tạo" },
              { value: "no", label: "Chưa được" }
            ]}
            className="w-44"
          />
        </div>
        {list.isPending ? (
          <TableSkeleton label="Đang tải quyền của nhà xe" rows={5} />
        ) : items.length === 0 ? (
          <ListStatePanel icon={<TicketPercent className="size-6 text-vxn-fg-3" />} title="Không có nhà xe phù hợp" description="Đổi bộ lọc để xem nhà xe khác." compact />
        ) : (
          <div className="overflow-x-auto">
            <table className={`${TABLE} min-w-[900px]`}>
              <thead>
                <tr className={TABLE_HEAD_ROW}>
                  {["Nhà xe", "Được tự tạo", "Mức giảm tối đa", "Tuyến / chuyến", "Hiệu lực tối đa", "Ngân sách", ""].map((heading, index) => (
                    <th key={index} scope="col" className={TABLE_HEAD_CELL}>
                      {heading}
                    </th>
                  ))}
                </tr>
              </thead>
              <tbody>
                {items.map((permission) => (
                  <tr key={permission.operatorId} className="border-b last:border-b-0">
                    <td className={TABLE_CELL}>
                      <p className="font-semibold text-vxn-ink">{permission.operatorName}</p>
                      <p className="text-xs leading-[18px] text-muted-foreground">{permission.operatorSlug}</p>
                    </td>
                    <td className={TABLE_CELL}>{permission.enabled ? <Badge tone="success">Được tự tạo</Badge> : <Badge>Chưa được</Badge>}</td>
                    <td className={TABLE_CELL}>{permission.enabled ? capLabel(permission.maxPercent, permission.maxAmount) : "—"}</td>
                    <td className={TABLE_CELL}>{permission.enabled ? (permission.routeIds.length === 0 ? "Mọi tuyến của nhà xe" : permission.routeNames.join(", ")) : "—"}</td>
                    <td className={TABLE_CELL}>{permission.enabled ? `${permission.maxDurationDays} ngày` : "—"}</td>
                    <td className={TABLE_CELL}>{permission.enabled ? (permission.monthlyBudget === null ? "Không giới hạn" : `${formatVnd(permission.monthlyBudget)} / tháng`) : "—"}</td>
                    <td className={TABLE_CELL}>
                      <Button variant="ghost" size="sm" onClick={() => setEditing(permission)} aria-label={`Sửa quyền ${permission.operatorName}`}>
                        Sửa
                        <Pencil className="size-4" />
                      </Button>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
        {items.length > 0 && (
          <div className="flex pt-5">
            <ListLoadMoreFooter
              hasMore={list.hasNextPage}
              loading={list.isFetchingNextPage}
              failed={list.isFetchNextPageError}
              loadedText={`Đã tải ${items.length} / ${COUNT.format(total)} nhà xe`}
              endText={`Đã tải ${COUNT.format(items.length)} nhà xe`}
              errorText="Chưa tải thêm được."
              onLoadMore={() => void list.fetchNextPage()}
            />
          </div>
        )}
      </section>
      <div role="note" className="flex items-center gap-3 rounded-lg bg-accent px-5 py-4 text-sm leading-5 text-accent-foreground">
        <Info className="size-[18px] shrink-0" aria-hidden />
        Thay đổi giới hạn chỉ áp dụng cho khuyến mãi nhà xe tạo / kích hoạt sau thời điểm lưu; chương trình đang chạy giữ nguyên điều kiện đã tạo.
      </div>
      {editing && <PermissionDialog permission={editing} onClose={() => setEditing(null)} />}
    </>
  );
}

function PermissionDialog({ permission, onClose }: { permission: Permission; onClose: () => void }) {
  const queryClient = useQueryClient();
  const [enabled, setEnabled] = useState(permission.enabled);
  const [maxPercent, setMaxPercent] = useState(permission.maxPercent?.toString() ?? "");
  const [maxAmount, setMaxAmount] = useState(permission.maxAmount?.toString() ?? "");
  const [duration, setDuration] = useState(String(permission.maxDurationDays));
  const [budget, setBudget] = useState(permission.monthlyBudget?.toString() ?? "");
  const [error, setError] = useState<string | null>(null);
  const number = (value: string) => (value.replace(/\D/g, "") ? Number(value.replace(/\D/g, "")) : null);
  const save = useMutation({
    mutationFn: () =>
      savePermission(permission.operatorId, {
        enabled,
        maxPercent: number(maxPercent),
        maxAmount: number(maxAmount),
        routeIds: permission.routeIds,
        maxDurationDays: number(duration) ?? 30,
        monthlyBudget: number(budget)
      }),
    onSuccess: () => {
      void queryClient.invalidateQueries({ queryKey: ["admin-promotion-permissions"] });
      onClose();
    },
    onError: (failure) => setError(describePromotionError(failure))
  });
  return (
    <Dialog open onOpenChange={(next) => !next && onClose()}>
      <DialogContent className="sm:max-w-[520px]">
        <DialogHeader>
          <DialogTitle>Quyền tạo khuyến mãi</DialogTitle>
          <DialogDescription>
            {permission.operatorName} · {permission.operatorSlug}
          </DialogDescription>
        </DialogHeader>
        <form
          className="flex flex-col gap-4"
          onSubmit={(event) => {
            event.preventDefault();
            if (enabled && number(maxPercent) === null && number(maxAmount) === null) {
              setError("Bật quyền cần ít nhất một mức giảm tối đa.");
              return;
            }
            save.mutate();
          }}
        >
          <label className="flex items-center justify-between gap-3 rounded-lg border px-4 py-3 text-sm leading-5">
            <span className="font-medium text-vxn-ink">Cho phép nhà xe tự tạo khuyến mãi</span>
            <Switch checked={enabled} onCheckedChange={setEnabled} aria-label="Cho phép nhà xe tự tạo khuyến mãi" />
          </label>
          <div className="grid gap-4 sm:grid-cols-2">
            <FormField label="Mức giảm tối đa (%)">{(control) => <Input {...control} inputMode="numeric" value={maxPercent} disabled={!enabled} onChange={(event) => setMaxPercent(event.target.value)} />}</FormField>
            <FormField label="Hoặc tối đa mỗi đơn (₫)">{(control) => <Input {...control} inputMode="numeric" value={maxAmount} disabled={!enabled} onChange={(event) => setMaxAmount(event.target.value)} />}</FormField>
            <FormField label="Hiệu lực tối đa (ngày)">{(control) => <Input {...control} inputMode="numeric" value={duration} disabled={!enabled} onChange={(event) => setDuration(event.target.value)} />}</FormField>
            <FormField label="Ngân sách / tháng (₫)" helper="Để trống = không giới hạn.">
              {(control) => <Input {...control} inputMode="numeric" value={budget} disabled={!enabled} onChange={(event) => setBudget(event.target.value)} />}
            </FormField>
          </div>
          <p className="text-xs leading-[18px] text-muted-foreground">Tuyến được áp dụng: {permission.routeIds.length === 0 ? "mọi tuyến của nhà xe" : permission.routeNames.join(", ")}.</p>
          {error && (
            <p role="alert" className="text-sm leading-5 text-error-600">
              {error}
            </p>
          )}
          <DialogFooter>
            <Button type="button" variant="outline" className={BUTTON} disabled={save.isPending} onClick={onClose}>
              Hủy
            </Button>
            <Button type="submit" className={BUTTON} disabled={save.isPending}>
              {save.isPending && <LoaderCircle className="size-[18px] animate-spin" />}
              Lưu quyền
            </Button>
          </DialogFooter>
        </form>
      </DialogContent>
    </Dialog>
  );
}
