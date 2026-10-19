"use client";

import { useQuery } from "@tanstack/react-query";
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
import { ListFooterNote, ListStatePanel } from "@vexenhanh/ui/components/list-parts";
import { KeyRound, Lock, LockOpen, RotateCcw, ShieldCheck, Users } from "lucide-react";
import { useState } from "react";

import {
  listPlatformAccounts,
  lockPlatformAccount,
  resetPlatformMfa,
  resetPlatformPassword,
  unlockPlatformAccount,
  type AccountStatus,
  type PlatformAccount,
  type PlatformRole
} from "../../lib/user/user-api";
import { ACCOUNT_STATUS, formatDateTime, PLATFORM_ROLE } from "../../lib/user/user-format";
import type { AccountAction } from "./account-dialogs";
import { ErrorPanel, StatusCell } from "./passenger-list";

/**
 * Tab "Tài khoản quản trị" (Figma ADM-03c): tài khoản `platform/…` chỉ được cấp ở đây. Mỗi dòng: cấp lại mật khẩu,
 * đặt lại xác thực hai lớp, khóa / mở khóa — đều cần lý do (khóa) và mã TOTP; không thao tác trên chính mình.
 */
export function PlatformAccountList({ onAction }: { onAction: (action: AccountAction) => void }) {
  const [search, setSearch] = useState("");
  const [role, setRole] = useState<string>(ALL);
  const [status, setStatus] = useState<string>(ALL);
  const q = useDebouncedValue(search.trim());
  const filters = { q: q || undefined, role: role === ALL ? undefined : role, status: status === ALL ? undefined : status };
  const accounts = useQuery({ queryKey: ["admin-platform-accounts", filters], queryFn: () => listPlatformAccounts(filters) });

  function resetPassword(account: PlatformAccount) {
    onAction({
      title: "Cấp lại mật khẩu tạm",
      subtitle: `${account.username} · ${account.email ?? "chưa có email"}`,
      note: "Mật khẩu tạm mới được gửi tới email nội bộ của tài khoản; mọi phiên đăng nhập hiện tại bị thu hồi.",
      withReason: false,
      confirmLabel: "Cấp lại mật khẩu",
      run: () => resetPlatformPassword(account.id),
      done: `Đã cấp lại mật khẩu tạm cho ${account.username}.`
    });
  }

  function resetMfa(account: PlatformAccount) {
    onAction({
      title: "Đặt lại xác thực hai lớp",
      subtitle: `${account.username} · ${account.email ?? "chưa có email"}`,
      warning:
        "Ứng dụng xác thực và mã dự phòng cũ hết hiệu lực. Mật khẩu tạm mới được gửi tới email của tài khoản để đăng nhập lại và thiết lập xác thực hai lớp.",
      withReason: false,
      confirmLabel: "Đặt lại",
      destructive: true,
      run: () => resetPlatformMfa(account.id),
      done: `Đã đặt lại xác thực hai lớp cho ${account.username}.`
    });
  }

  function lock(account: PlatformAccount) {
    onAction({
      title: "Khóa tài khoản quản trị",
      subtitle: `${account.username} · ${PLATFORM_ROLE[account.role].label}`,
      warning: "Tài khoản không đăng nhập được nữa và mọi phiên đăng nhập bị thu hồi.",
      withReason: true,
      confirmLabel: "Khóa tài khoản",
      destructive: true,
      run: (reason) => lockPlatformAccount(account.id, reason),
      done: `Đã khóa ${account.username}.`
    });
  }

  function unlock(account: PlatformAccount) {
    onAction({
      title: "Mở khóa tài khoản quản trị",
      subtitle: `${account.username} · ${PLATFORM_ROLE[account.role].label}`,
      note: "Tài khoản đăng nhập lại được bằng mật khẩu và xác thực hai lớp hiện có.",
      withReason: false,
      confirmLabel: "Mở khóa",
      run: () => unlockPlatformAccount(account.id),
      done: `Đã mở khóa ${account.username}.`
    });
  }

  let body;
  if (accounts.isError) {
    body = <ErrorPanel onRetry={() => void accounts.refetch()} />;
  } else if (accounts.isPending) {
    body = <TableSkeleton label="Đang tải tài khoản quản trị" rows={4} />;
  } else if (accounts.data.length === 0) {
    body = (
      <ListStatePanel
        icon={<Users className="size-6 text-vxn-fg-3" />}
        title="Không có tài khoản phù hợp"
        description="Đổi bộ lọc hoặc từ khóa."
      />
    );
  } else {
    body = (
      <div className="relative overflow-x-auto">
        <table className={`${TABLE} min-w-[920px]`}>
          <colgroup>
            <col />
            <col className="w-[18%]" />
            <col className="w-[13%]" />
            <col className="w-[17%]" />
            <col className="w-[16%]" />
            <col className="w-[12%]" />
          </colgroup>
          <thead>
            <tr className={TABLE_HEAD_ROW}>
              {["Tài khoản", "Vai trò", "Xác thực hai lớp", "Trạng thái", "Đăng nhập gần nhất", "Thao tác"].map((heading) => (
                <th key={heading} scope="col" className={TABLE_HEAD_CELL}>
                  {heading}
                </th>
              ))}
            </tr>
          </thead>
          <tbody>
            {accounts.data.map((account) => (
              <tr key={account.id} className="h-[64px] border-b">
                <td className={TABLE_CELL}>
                  <div className="flex min-w-0 flex-col">
                    <span className="truncate font-semibold text-vxn-ink">
                      {account.username}
                      {account.isSelf && <span className="ml-1 font-normal text-muted-foreground">(bạn)</span>}
                    </span>
                    <span className="truncate text-xs leading-[18px] text-muted-foreground">{account.email ?? "—"}</span>
                  </div>
                </td>
                <td className={TABLE_CELL}>{PLATFORM_ROLE[account.role].label}</td>
                <td className={TABLE_CELL}>
                  <Badge tone={account.mfaEnabled ? "success" : "warning"}>{account.mfaEnabled ? "Đang bật" : "Chưa thiết lập"}</Badge>
                </td>
                <td className={TABLE_CELL}>
                  <StatusCell status={account.status} reason={account.lockedReason} since={account.lockedAt} />
                  {account.status === "ACTIVE" && (account.credentialDeliveryPending || account.passwordChangeRequired) && (
                    <span className="mt-1 block text-xs leading-[18px] text-muted-foreground">
                      {account.credentialDeliveryPending ? "Chưa gửi được mật khẩu tạm" : "Chờ đổi mật khẩu tạm"}
                    </span>
                  )}
                </td>
                <td className={TABLE_CELL}>{formatDateTime(account.lastLoginAt)}</td>
                <td className={TABLE_CELL}>
                  {account.isSelf ? (
                    <span className="text-xs text-muted-foreground">—</span>
                  ) : (
                    <div className="flex items-center gap-1">
                      <Button
                        variant="ghost"
                        size="icon"
                        aria-label={`Cấp lại mật khẩu cho ${account.username}`}
                        title="Cấp lại mật khẩu tạm"
                        disabled={account.status !== "ACTIVE" || !account.email}
                        onClick={() => resetPassword(account)}
                      >
                        <KeyRound className="size-4" />
                      </Button>
                      <Button
                        variant="ghost"
                        size="icon"
                        aria-label={`Đặt lại xác thực hai lớp cho ${account.username}`}
                        title="Đặt lại xác thực hai lớp"
                        disabled={account.status !== "ACTIVE" || !account.email}
                        onClick={() => resetMfa(account)}
                      >
                        <RotateCcw className="size-4" />
                      </Button>
                      {account.status === "LOCKED" ? (
                        <Button variant="ghost" size="icon" aria-label={`Mở khóa ${account.username}`} title="Mở khóa" onClick={() => unlock(account)}>
                          <LockOpen className="size-4" />
                        </Button>
                      ) : (
                        <Button variant="ghost" size="icon" aria-label={`Khóa ${account.username}`} title="Khóa" onClick={() => lock(account)}>
                          <Lock className="size-4" />
                        </Button>
                      )}
                    </div>
                  )}
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
      <section aria-label="Danh sách tài khoản quản trị" className="flex flex-col rounded-xl border bg-card p-6">
        <div className="flex flex-wrap items-end gap-x-4 gap-y-3 pb-5">
          <SearchField label="Tìm tài khoản" placeholder="Tên đăng nhập hoặc email" value={search} onChange={setSearch} />
          <FilterSelect
            label="Vai trò"
            allLabel="Tất cả vai trò"
            value={role}
            onChange={setRole}
            options={(Object.keys(PLATFORM_ROLE) as PlatformRole[]).map((value) => ({ value, label: PLATFORM_ROLE[value].label }))}
            className="w-56"
          />
          <FilterSelect
            label="Trạng thái"
            allLabel="Tất cả"
            value={status}
            onChange={setStatus}
            options={(Object.keys(ACCOUNT_STATUS) as AccountStatus[]).map((value) => ({ value, label: ACCOUNT_STATUS[value].label }))}
            className="w-44"
          />
        </div>
        <div className="min-h-[240px]">{body}</div>
        {accounts.data && accounts.data.length > 0 && (
          <div className="flex min-h-14 items-center pt-5">
            <ListFooterNote>Đã tải {accounts.data.length} tài khoản</ListFooterNote>
          </div>
        )}
      </section>
      <div className="flex items-center gap-4 rounded-lg bg-accent px-5 py-4">
        <ShieldCheck className="size-5 shrink-0 text-accent-foreground" />
        <p className="min-w-0 flex-1 text-sm leading-5 text-accent-foreground">
          Tài khoản quản trị chỉ được tạo tại đây, không có đăng ký công khai. Cấp lại mật khẩu, đặt lại xác thực hai lớp và khóa
          tài khoản đều cần xác nhận danh tính và được ghi nhật ký audit.
        </p>
      </div>
    </>
  );
}
