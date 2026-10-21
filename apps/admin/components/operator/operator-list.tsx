"use client";

import { useInfiniteQuery, useQueryClient } from "@tanstack/react-query";
import { Badge } from "@vexenhanh/ui/components/badge";
import { Button } from "@vexenhanh/ui/components/button";
import {
  ALL,
  FilterSelect,
  SearchField,
  TABLE,
  TABLE_CELL,
  TABLE_HEAD_CELL,
  TABLE_HEAD_ROW,
  TableSkeleton,
  useDebouncedValue
} from "@vexenhanh/ui/components/list-controls";
import { BUTTON, ListLoadMoreFooter, ListStatePanel } from "@vexenhanh/ui/components/list-parts";
import { Building2, CircleAlert, CircleCheck, Landmark, Lock, LockOpen, Mail, RefreshCw } from "lucide-react";
import Link from "next/link";
import { useMemo, useState, type ReactNode } from "react";

import { listOperators, suspendOperator, unsuspendOperator, type AdminOperator, type OperatorStatus } from "../../lib/user/user-api";
import { formatDate, OPERATOR_STATUS, openSaleLabel } from "../../lib/user/user-format";
import { AccountActionDialog, type AccountAction } from "../user/account-dialogs";
import { BankChangeDialog } from "./bank-change-dialog";

/**
 * Tab "Nhà xe" của màn Nhà xe & KYC (Figma ADM-02e/f; FR-ADM-02/03, UC-23 A6): nhà xe đã duyệt, tìm tên / mã / chủ nhà
 * xe, lọc trạng thái; tạm khóa (lý do + TOTP) / mở khóa; "Gửi lại" mở hồ sơ để gửi lại mật khẩu tạm cho chủ nhà xe;
 * nhà xe gửi yêu cầu đổi tài khoản nhận tiền thì có nút "Xác minh TK" (TASK-OPR-001b).
 */
export function OperatorList() {
  const queryClient = useQueryClient();
  const [search, setSearch] = useState("");
  const [status, setStatus] = useState<string>(ALL);
  const [bankChange, setBankChange] = useState<string>(ALL);
  const [verifying, setVerifying] = useState<AdminOperator | null>(null);
  const [action, setAction] = useState<AccountAction | null>(null);
  const [notice, setNotice] = useState<string | null>(null);
  const q = useDebouncedValue(search.trim());
  const filters = useMemo(
    () => ({ q: q || undefined, status: status === ALL ? undefined : status, bankChange: bankChange === ALL ? undefined : bankChange }),
    [q, status, bankChange]
  );
  const pages = useInfiniteQuery({
    queryKey: ["admin-operators", filters],
    queryFn: ({ pageParam }) => listOperators(filters, pageParam),
    initialPageParam: null as string | null,
    getNextPageParam: (last) => last.nextCursor
  });
  const rows = pages.data?.pages.flatMap((page) => page.items) ?? [];
  const total = pages.data?.pages[0]?.total ?? 0;
  const filtered = q !== "" || status !== ALL || bankChange !== ALL;
  const refresh = () => void queryClient.invalidateQueries({ queryKey: ["admin-operators"] });

  function openSuspend(operator: AdminOperator) {
    setAction({
      title: "Tạm khóa nhà xe",
      subtitle: `${operator.name} · ${operator.slug}`,
      warning:
        "Nhà xe sẽ không tạo hoặc mở bán chuyến mới. Mọi phiên đăng nhập của nhà xe bị thu hồi và nhà xe nhận thông báo kèm lý do.",
      withReason: true,
      confirmLabel: "Tạm khóa nhà xe",
      destructive: true,
      run: (reason) => suspendOperator(operator.id, reason),
      done: `Đã tạm khóa nhà xe ${operator.name}.`
    });
  }

  function openUnsuspend(operator: AdminOperator) {
    setAction({
      title: "Mở khóa nhà xe",
      subtitle: `${operator.name} · ${operator.slug}`,
      note: "Nhà xe đăng nhập và mở bán chuyến lại được; chủ nhà xe nhận thông báo.",
      withReason: false,
      confirmLabel: "Mở khóa",
      run: () => unsuspendOperator(operator.id),
      done: `Đã mở khóa nhà xe ${operator.name}.`
    });
  }

  let body: ReactNode;
  let footer: ReactNode = null;
  if (pages.isError && rows.length === 0) {
    body = (
      <ListStatePanel
        icon={<CircleAlert className="size-6 text-warning-700" />}
        title="Không tải được nhà xe"
        description="Kiểm tra kết nối mạng rồi thử lại."
        action={
          <Button className={`${BUTTON} w-36`} onClick={() => void pages.refetch()}>
            <RefreshCw className="size-[18px]" />
            Thử lại
          </Button>
        }
      />
    );
  } else if (pages.isPending) {
    body = <TableSkeleton label="Đang tải nhà xe" />;
  } else if (rows.length === 0) {
    body = (
      <ListStatePanel
        icon={<Building2 className="size-6 text-vxn-fg-3" />}
        title={filtered ? "Không có nhà xe phù hợp" : "Chưa có nhà xe nào"}
        description={filtered ? "Đổi bộ lọc hoặc từ khóa." : "Nhà xe xuất hiện ở đây sau khi hồ sơ đăng ký được duyệt."}
      />
    );
  } else {
    body = <OperatorTable rows={rows} onSuspend={openSuspend} onUnsuspend={openUnsuspend} onVerifyBank={setVerifying} />;
    footer = (
      <ListLoadMoreFooter
        hasMore={pages.hasNextPage}
        loading={pages.isFetchingNextPage}
        failed={pages.isFetchNextPageError}
        loadedText={`Đã tải ${rows.length} / ${total.toLocaleString("vi-VN")} nhà xe`}
        endText={`Đã hiện tất cả ${rows.length} nhà xe`}
        errorText="Không tải thêm được nhà xe. Kiểm tra kết nối rồi thử lại."
        onLoadMore={() => void pages.fetchNextPage()}
      />
    );
  }

  return (
    <>
      {notice && (
        <div role="status" className="flex items-center gap-3 rounded-lg bg-success-50 px-5 py-3 text-sm leading-5 text-success-700">
          <CircleCheck className="size-5 shrink-0" />
          {notice}
        </div>
      )}
      <section aria-label="Danh sách nhà xe" className="flex flex-col rounded-xl border bg-card p-6">
        <div className="flex flex-wrap items-end gap-x-4 gap-y-3 pb-5">
          <SearchField label="Tìm nhà xe" placeholder="Tên, mã nhà xe hoặc email chủ nhà xe" value={search} onChange={setSearch} />
          <FilterSelect
            label="Trạng thái"
            allLabel="Tất cả trạng thái"
            value={status}
            onChange={setStatus}
            options={(["ACTIVE", "SUSPENDED"] as OperatorStatus[]).map((value) => ({ value, label: OPERATOR_STATUS[value].label }))}
            className="w-56"
          />
          <FilterSelect
            label="Tài khoản nhận tiền"
            allLabel="Tất cả"
            value={bankChange}
            onChange={setBankChange}
            options={[{ value: "PENDING", label: "Chờ xác minh đổi tài khoản" }]}
            className="w-64"
          />
        </div>
        <div className="min-h-[320px]">{body}</div>
        {footer && <div className="flex min-h-14 items-center pt-5">{footer}</div>}
      </section>
      <div className="flex items-center gap-4 rounded-lg bg-accent px-5 py-4">
        <Lock className="size-5 shrink-0 text-accent-foreground" />
        <p className="min-w-0 flex-1 text-sm leading-5 text-accent-foreground">
          Nhà xe bị tạm khóa không tạo hoặc mở bán chuyến mới; các phiên đăng nhập của nhà xe bị thu hồi và nhà xe nhận thông báo
          kèm lý do.
        </p>
      </div>
      <AccountActionDialog action={action} onClose={() => setAction(null)} onDone={(message) => {
        setNotice(message);
        refresh();
      }} onStale={refresh} />
      <BankChangeDialog
        operator={verifying}
        onClose={() => setVerifying(null)}
        onDone={(message) => {
          setNotice(message);
          refresh();
        }}
        onStale={refresh}
      />
    </>
  );
}

// Độ rộng cột theo Figma ADM-02e (co giãn ở cột Nhà xe).
const COLUMNS = ["", "w-[20%]", "w-[15%]", "w-[17%]", "w-[11%]", "w-[11%]"];
const HEADINGS = ["Nhà xe", "Chủ nhà xe", "Đang mở bán", "Trạng thái", "Duyệt ngày", ""];
const SUBLINE = "truncate text-xs leading-[18px] text-muted-foreground";

function OperatorTable({
  rows,
  onSuspend,
  onUnsuspend,
  onVerifyBank
}: {
  rows: AdminOperator[];
  onSuspend: (operator: AdminOperator) => void;
  onUnsuspend: (operator: AdminOperator) => void;
  onVerifyBank: (operator: AdminOperator) => void;
}) {
  return (
    <div className="relative overflow-x-auto">
      <table className={`${TABLE} min-w-[960px]`}>
        <colgroup>
          {COLUMNS.map((width, index) => (
            <col key={index} className={width} />
          ))}
        </colgroup>
        <thead>
          <tr className={TABLE_HEAD_ROW}>
            {HEADINGS.map((heading, index) => (
              <th key={index} scope="col" className={TABLE_HEAD_CELL}>
                {heading || <span className="sr-only">Thao tác</span>}
              </th>
            ))}
          </tr>
        </thead>
        <tbody>
          {rows.map((row) => {
            const status = OPERATOR_STATUS[row.status];
            return (
              <tr key={row.id} className="h-[72px] border-b">
                <td className={TABLE_CELL}>
                  <div className="flex min-w-0 flex-col">
                    <span className="truncate font-semibold text-vxn-ink">{row.name}</span>
                    <span className={SUBLINE}>{row.slug}</span>
                  </div>
                </td>
                <td className={TABLE_CELL}>
                  {row.owner ? (
                    <div className="flex min-w-0 flex-col">
                      <span className="truncate font-semibold text-vxn-ink">{row.owner.username}</span>
                      <span className={SUBLINE}>{row.owner.email ?? "—"}</span>
                    </div>
                  ) : (
                    "—"
                  )}
                </td>
                <td className={TABLE_CELL}>{openSaleLabel(row)}</td>
                <td className={TABLE_CELL}>
                  <div className="flex flex-col items-start gap-1">
                    <Badge tone={status.tone}>{status.label}</Badge>
                    {row.status === "SUSPENDED" && row.suspendedReason && (
                      <span className="line-clamp-2 text-xs leading-[18px] text-muted-foreground">
                        Từ {formatDate(row.suspendedAt)} · {row.suspendedReason}
                      </span>
                    )}
                    {row.status === "ACTIVE" && row.owner?.credentialDeliveryPending && (
                      <span className="text-xs leading-[18px] text-muted-foreground">Chưa gửi được mật khẩu tạm</span>
                    )}
                    {row.bankChangePending && (
                      <button
                        type="button"
                        className="inline-flex items-center gap-1 text-xs leading-[18px] font-semibold text-warning-700 underline-offset-2 hover:underline"
                        aria-label={`Xác minh tài khoản nhận tiền của ${row.name}`}
                        onClick={() => onVerifyBank(row)}
                      >
                        <Landmark className="size-3.5" />
                        Chờ xác minh TK nhận tiền
                      </button>
                    )}
                  </div>
                </td>
                <td className={TABLE_CELL}>{formatDate(row.approvedAt)}</td>
                <td className={TABLE_CELL}>
                  {row.status === "SUSPENDED" ? (
                    <Button variant="ghost" className="h-8 px-2 font-semibold" aria-label={`Mở khóa nhà xe ${row.name}`} onClick={() => onUnsuspend(row)}>
                      Mở khóa
                      <LockOpen className="size-4" />
                    </Button>
                  ) : row.owner?.credentialDeliveryPending && row.applicationId ? (
                    <Button asChild variant="ghost" className="h-8 px-2 font-semibold">
                      <Link href={`/operators/applications/${row.applicationId}`} aria-label={`Gửi lại mật khẩu tạm cho ${row.name}`}>
                        Gửi lại
                        <Mail className="size-4" />
                      </Link>
                    </Button>
                  ) : (
                    <Button variant="ghost" className="h-8 px-2 font-semibold" aria-label={`Tạm khóa nhà xe ${row.name}`} onClick={() => onSuspend(row)}>
                      Tạm khóa
                      <Lock className="size-4" />
                    </Button>
                  )}
                </td>
              </tr>
            );
          })}
        </tbody>
      </table>
    </div>
  );
}
