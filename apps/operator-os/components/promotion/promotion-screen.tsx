"use client";

import { useInfiniteQuery, useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { Badge } from "@vexenhanh/ui/components/badge";
import { Button } from "@vexenhanh/ui/components/button";
import { Skeleton } from "@vexenhanh/ui/components/skeleton";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@vexenhanh/ui/components/tabs";
import { discountLabel, minOrderLabel, PROMOTION_DISPLAY, PROMOTION_DISPLAY_ORDER, usageLabel, windowLabel } from "@vexenhanh/ui/lib/promotion-format";
import { ChevronRight, CircleAlert, Info, LifeBuoy, Megaphone, Plus, RefreshCw } from "lucide-react";
import Link from "next/link";
import { usePathname, useRouter, useSearchParams } from "next/navigation";
import { useState, type ReactNode } from "react";

import { formatVnd } from "../../lib/fare/fare-format";
import { describePromotionError, getPermission, listPromotions, setParticipation, type Promotion, type PromotionDisplay } from "../../lib/promotion/promotion-api";
import { listAllRoutes } from "../../lib/route/route-api";
import { BUTTON, ListLoadMoreFooter, ListStatePanel } from "../list-parts";
import { PageHeader } from "../page-header";
import { ALL, FilterSelect, SearchField, TAB_TRIGGER, TABLE, TABLE_CELL, TABLE_HEAD_CELL, TABLE_HEAD_ROW, TableSkeleton, useDebouncedValue } from "../stop-point/list-controls";

const COUNT = new Intl.NumberFormat("vi-VN");

/**
 * Khuyến mãi (Figma "Nhà xe · Khuyến mãi" 01 / 03; TASK-PROM-001, FR-PROM-04): mã giảm giá của riêng nhà xe trong giới hạn Vé Xe Nhanh
 * cấp (chưa được cấp → màn hướng dẫn) và tab khuyến mãi của Vé Xe Nhanh để tham gia (Khanh 18/10/2026: nhà xe chịu phần giảm).
 */
export function PromotionScreen() {
  const router = useRouter();
  const pathname = usePathname();
  const params = useSearchParams();
  const tab = params.get("tab") === "platform" ? "platform" : "own";
  const permission = useQuery({ queryKey: ["operator-promotion-permission"], queryFn: getPermission });
  return (
    <div className="flex flex-col gap-6">
      <PageHeader
        title="Khuyến mãi"
        description="Mã giảm giá của riêng nhà xe, trong giới hạn Vé Xe Nhanh cho phép; tham gia khuyến mãi của Vé Xe Nhanh."
        actions={
          permission.data?.enabled ? (
            <Button asChild className={BUTTON}>
              <Link href="/promotions/new">
                <Plus className="size-[18px]" />
                Tạo khuyến mãi
              </Link>
            </Button>
          ) : undefined
        }
      />
      <Tabs value={tab} onValueChange={(next) => router.replace(next === "own" ? pathname : `${pathname}?tab=${next}`, { scroll: false })} className="flex flex-col gap-6">
        <TabsList className="h-10 w-fit max-w-full overflow-x-auto" aria-label="Nhóm khuyến mãi">
          <TabsTrigger value="own" className={TAB_TRIGGER}>
            Khuyến mãi của nhà xe
          </TabsTrigger>
          <TabsTrigger value="platform" className={TAB_TRIGGER}>
            Khuyến mãi Vé Xe Nhanh
          </TabsTrigger>
        </TabsList>
        <TabsContent value="own" className="flex flex-col gap-6">
          {permission.isPending ? (
            <Skeleton className="h-64 rounded-xl" />
          ) : permission.data && !permission.data.enabled ? (
            <div className="rounded-xl border bg-card">
              <ListStatePanel
                icon={
                  <span className="flex size-16 items-center justify-center rounded-full bg-accent">
                    <Megaphone className="size-6 text-vxn-teal-700" />
                  </span>
                }
                title="Nhà xe chưa được cấp quyền tạo khuyến mãi"
                description={`Vé Xe Nhanh chưa bật quyền tự tạo khuyến mãi cho ${permission.data.operatorName}. Khi được bật, bạn tạo chương trình trong giới hạn về mức giảm, tuyến và thời gian hiệu lực. Bạn vẫn có thể tham gia khuyến mãi của Vé Xe Nhanh.`}
                action={
                  <Button asChild variant="outline" className={`${BUTTON} bg-card`}>
                    <Link href="/support">
                      <LifeBuoy className="size-[18px]" />
                      Liên hệ hỗ trợ đối tác
                    </Link>
                  </Button>
                }
                compact
              />
            </div>
          ) : (
            <PromotionList scope="OPERATOR" />
          )}
        </TabsContent>
        <TabsContent value="platform" className="flex flex-col gap-6">
          <PromotionList scope="PLATFORM" />
        </TabsContent>
      </Tabs>
    </div>
  );
}

function Stat({ label, value, note }: { label: string; value: string | null; note: string }) {
  return (
    <div className="flex flex-col gap-1.5 rounded-xl border bg-card p-5">
      <p className="text-sm leading-5 text-muted-foreground">{label}</p>
      {value === null ? <Skeleton className="h-9 w-24" /> : <p className="text-[28px] leading-9 font-semibold text-vxn-ink tabular-nums">{value}</p>}
      <p className="text-xs leading-[18px] text-muted-foreground">{note}</p>
    </div>
  );
}

function PromotionList({ scope }: { scope: "OPERATOR" | "PLATFORM" }) {
  const own = scope === "OPERATOR";
  const queryClient = useQueryClient();
  const [display, setDisplay] = useState(ALL);
  const [routeId, setRouteId] = useState(ALL);
  const [search, setSearch] = useState("");
  const [notice, setNotice] = useState<string | null>(null);
  const q = useDebouncedValue(search.trim());
  const routes = useQuery({ queryKey: ["routes", "all"], queryFn: () => listAllRoutes(), enabled: own });
  const list = useInfiniteQuery({
    queryKey: ["operator-promotions", scope, display, routeId, q],
    queryFn: ({ pageParam }) =>
      listPromotions({ scope, display: display === ALL ? undefined : (display as PromotionDisplay), routeId: routeId === ALL ? undefined : routeId, q: q || undefined, cursor: pageParam ?? undefined }),
    initialPageParam: null as string | null,
    getNextPageParam: (page) => page.nextCursor
  });
  const join = useMutation({
    mutationFn: ({ promotion, joined }: { promotion: Promotion; joined: boolean }) => setParticipation(promotion.promotionId, joined),
    onSuccess: (next) => {
      setNotice(next.joined ? `Đã tham gia ${next.code} — nhà xe chịu phần giảm cho chuyến của mình.` : `Đã rời ${next.code}.`);
      void queryClient.invalidateQueries({ queryKey: ["operator-promotions"] });
    },
    onError: (failure) => setNotice(describePromotionError(failure))
  });
  const items = list.data?.pages.flatMap((page) => page.items) ?? [];
  const stats = list.data?.pages[0]?.stats;
  const total = list.data?.pages[0]?.total ?? 0;

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
    body = (
      <ListStatePanel
        icon={<Megaphone className="size-6 text-vxn-fg-3" />}
        title={own ? "Chưa có khuyến mãi" : "Chưa có khuyến mãi của Vé Xe Nhanh"}
        description={own ? "Tạo mã giảm giá cho tuyến / chuyến của nhà xe trong giới hạn được cấp." : "Khuyến mãi Vé Xe Nhanh mở cho nhà xe tham gia hiện ở đây."}
        compact
      />
    );
  } else {
    body = (
      <div className="overflow-x-auto">
        <table className={`${TABLE} min-w-[900px]`}>
          <thead>
            <tr className={TABLE_HEAD_ROW}>
              {["Mã và tên", "Mức giảm", own ? "Phạm vi" : "Tham gia", "Hiệu lực", "Lượt dùng", "Trạng thái", ""].map((heading, index) => (
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
                <td className={TABLE_CELL}>{own ? (promotion.routeName ?? "Mọi tuyến của nhà xe") : <>{promotion.joined ? <Badge tone="success">Đã tham gia</Badge> : <Badge>Chưa tham gia</Badge>}<p className="mt-1 text-xs text-muted-foreground">{promotion.routeIds.length > 0 ? promotion.routeNames.join(", ") : "Mọi tuyến của nhà xe tham gia"}</p></>}</td>
                <td className={`${TABLE_CELL} tabular-nums`}>{windowLabel(promotion.startsAt, promotion.endsAt)}</td>
                <td className={`${TABLE_CELL} text-right font-semibold tabular-nums`}>{usageLabel(promotion.usedCount, promotion.usageLimit)}</td>
                <td className={TABLE_CELL}>
                  <Badge tone={PROMOTION_DISPLAY[promotion.display].tone}>{PROMOTION_DISPLAY[promotion.display].label}</Badge>
                </td>
                <td className={TABLE_CELL}>
                  {own ? (
                    <Link href={`/promotions/${promotion.promotionId}`} className="inline-flex items-center font-semibold text-vxn-ink" aria-label={`Xem ${promotion.code}`}>
                      Xem
                      <ChevronRight className="size-4" />
                    </Link>
                  ) : promotion.display !== "ENDED" || promotion.joined ? (
                    <Button variant="outline" size="sm" className="bg-card" disabled={join.isPending} onClick={() => join.mutate({ promotion, joined: !promotion.joined })}>
                      {promotion.joined ? "Rời chương trình" : "Tham gia"}
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
        <Stat label="Đang chạy" value={stats ? COUNT.format(stats.running) : null} note={stats ? `${stats.drafts} bản nháp · ${stats.paused} tạm dừng` : ""} />
        <Stat label="Lượt áp dụng" value={stats ? COUNT.format(stats.redemptions) : null} note="30 ngày gần nhất · đơn của nhà xe" />
        <Stat label="Tổng giá trị giảm" value={stats ? formatVnd(stats.discount) : null} note="Trừ vào doanh thu của nhà xe" />
        <Stat label="Doanh thu có áp mã" value={stats ? formatVnd(stats.revenue) : null} note="30 ngày gần nhất" />
      </div>
      {notice && (
        <p role="status" className="rounded-lg bg-success-50 px-5 py-3 text-sm leading-5 text-success-700">
          {notice}
        </p>
      )}
      <section aria-label={own ? "Khuyến mãi của nhà xe" : "Khuyến mãi Vé Xe Nhanh"} className="flex flex-col rounded-xl border bg-card p-6">
        <div className="flex flex-wrap items-end gap-x-4 gap-y-3 pb-5">
          <SearchField value={search} onChange={setSearch} placeholder="Mã hoặc tên chương trình" />
          <FilterSelect label="Trạng thái" allLabel="Tất cả trạng thái" value={display} onChange={setDisplay} options={PROMOTION_DISPLAY_ORDER.map((value) => ({ value, label: PROMOTION_DISPLAY[value].label }))} className="w-44" />
          {own && <FilterSelect label="Tuyến" allLabel="Tất cả tuyến" value={routeId} onChange={setRouteId} options={(routes.data ?? []).map((route) => ({ value: route.id, label: route.name }))} />}
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
      <div role="note" className="flex items-center gap-3 rounded-lg bg-accent px-5 py-4 text-sm leading-5 text-vxn-teal-700">
        <Info className="size-[18px] shrink-0" aria-hidden />
        {own
          ? "Mỗi đơn chỉ áp dụng một mã. Khuyến mãi đã được dùng trong đơn thì không sửa điều kiện; hãy kết thúc và tạo chương trình mới."
          : "Khuyến mãi Vé Xe Nhanh chỉ áp cho chuyến của nhà xe đã tham gia; phần giảm trừ vào doanh thu của nhà xe. Rời chương trình không ảnh hưởng đơn đã đặt."}
      </div>
    </>
  );
}
