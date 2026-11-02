"use client";

import { useQuery, useQueryClient } from "@tanstack/react-query";
import { Badge } from "@vexenhanh/ui/components/badge";
import { Button } from "@vexenhanh/ui/components/button";
import { permissionLabel } from "@vexenhanh/ui/lib/permission-matrix";
import { CircleCheck, KeyRound, ListChecks, Lock, LockOpen, Plus, RefreshCw, RotateCcw, ShieldCheck, UserCog } from "lucide-react";
import { useState } from "react";

import { useAuth } from "../../lib/auth/auth-context";
import { listManagers, type Manager } from "../../lib/manager/manager-api";
import { MANAGER_PERMISSION_GROUPS, managerPermissionSummary } from "../../lib/manager/manager-format";
import { BUTTON, ListFooterNote, ListStatePanel } from "../list-parts";
import { PageHeader } from "../page-header";
import { TABLE, TABLE_CELL, TABLE_HEAD_CELL, TABLE_HEAD_ROW, TableSkeleton } from "../stop-point/list-controls";
import { ManagerDialogs, type ManagerDialog } from "./manager-dialogs";

const STATUS: Record<Manager["status"], { label: string; tone: "success" | "danger" | "neutral" }> = {
  ACTIVE: { label: "Hoạt động", tone: "success" },
  LOCKED: { label: "Bị khóa", tone: "danger" },
  DISABLED: { label: "Vô hiệu hóa", tone: "neutral" }
};

/** `13/10/2026 · 07:58` giờ Việt Nam; không có → "—". */
function formatDateTime(iso: string | null): string {
  if (!iso) {
    return "—";
  }
  const shifted = new Date(new Date(iso).getTime() + 7 * 3_600_000);
  const pad = (value: number) => String(value).padStart(2, "0");
  return `${pad(shifted.getUTCDate())}/${pad(shifted.getUTCMonth() + 1)}/${shifted.getUTCFullYear()} · ${pad(shifted.getUTCHours())}:${pad(shifted.getUTCMinutes())}`;
}

/**
 * Màn Tài khoản quản lý (TASK-IAM-007 — Figma chưa có khung, dựng theo màn Nhân viên): chủ nhà xe cấp tài khoản dùng trang
 * quản lý cho kế toán, điều hành, CSKH… và tick quyền từng người. Mọi thao tác cần lý do + xác nhận lại danh tính.
 */
export function ManagerList() {
  const queryClient = useQueryClient();
  const { state } = useAuth();
  const operatorSlug = state.status === "authenticated" ? (state.me.operatorSlug ?? "") : "";
  const [dialog, setDialog] = useState<ManagerDialog | null>(null);
  const [notice, setNotice] = useState<string | null>(null);
  const managers = useQuery({ queryKey: ["managers"], queryFn: listManagers });

  function reload() {
    void queryClient.invalidateQueries({ queryKey: ["managers"] });
  }

  function open(next: ManagerDialog) {
    setNotice(null);
    setDialog(next);
  }

  let body;
  if (managers.isError) {
    body = (
      <ListStatePanel
        icon={<RefreshCw className="size-6 text-vxn-fg-3" />}
        title="Chưa tải được danh sách"
        description="Kiểm tra kết nối rồi thử lại."
        action={
          <Button variant="outline" className={`${BUTTON} bg-card`} onClick={() => void managers.refetch()}>
            Thử lại
          </Button>
        }
      />
    );
  } else if (managers.isPending) {
    body = <TableSkeleton label="Đang tải tài khoản quản lý" rows={3} />;
  } else if (managers.data.length === 0) {
    body = (
      <ListStatePanel
        icon={<UserCog className="size-6 text-vxn-fg-3" />}
        title="Chưa có tài khoản quản lý"
        description="Tạo tài khoản cho người cùng quản lý nhà xe (kế toán, điều hành, CSKH…) thay vì dùng chung tài khoản chủ nhà xe."
      />
    );
  } else {
    body = (
      <div className="relative overflow-x-auto">
        <table className={`${TABLE} min-w-[960px]`}>
          <colgroup>
            <col />
            <col className="w-[16%]" />
            <col className="w-[13%]" />
            <col className="w-[15%]" />
            <col className="w-[16%]" />
            <col className="w-[17%]" />
          </colgroup>
          <thead>
            <tr className={TABLE_HEAD_ROW}>
              {["Tài khoản", "Quyền", "Xác thực hai lớp", "Trạng thái", "Đăng nhập gần nhất", "Thao tác"].map((heading) => (
                <th key={heading} scope="col" className={TABLE_HEAD_CELL}>
                  {heading}
                </th>
              ))}
            </tr>
          </thead>
          <tbody>
            {managers.data.map((manager) => (
              <tr key={manager.id} className="h-[64px] border-b">
                <td className={TABLE_CELL}>
                  <div className="flex min-w-0 flex-col">
                    <span className="truncate font-semibold text-vxn-ink">{manager.username}</span>
                    <span className="truncate text-xs leading-[18px] text-muted-foreground">{manager.contactEmail ?? "—"}</span>
                  </div>
                </td>
                <td className={TABLE_CELL}>
                  <span title={manager.permissions.map((permission) => permissionLabel(MANAGER_PERMISSION_GROUPS, permission)).join("\n")}>
                    {managerPermissionSummary(manager.permissions)}
                  </span>
                </td>
                <td className={TABLE_CELL}>
                  <Badge tone={manager.mfaEnabled ? "success" : "warning"}>{manager.mfaEnabled ? "Đang bật" : "Chưa thiết lập"}</Badge>
                </td>
                <td className={TABLE_CELL}>
                  <Badge tone={STATUS[manager.status].tone}>{STATUS[manager.status].label}</Badge>
                  {manager.status === "ACTIVE" && (manager.credentialDeliveryPending || manager.passwordChangeRequired) && (
                    <span className="mt-1 block text-xs leading-[18px] text-muted-foreground">
                      {manager.credentialDeliveryPending ? "Chưa gửi được mật khẩu tạm" : "Chờ đổi mật khẩu tạm"}
                    </span>
                  )}
                </td>
                <td className={TABLE_CELL}>{formatDateTime(manager.lastLoginAt)}</td>
                <td className={TABLE_CELL}>
                  <div className="flex items-center gap-1">
                    <Button variant="ghost" size="icon" aria-label={`Phân quyền ${manager.username}`} title="Phân quyền" disabled={manager.status === "DISABLED"} onClick={() => open({ kind: "permissions", manager })}>
                      <ListChecks className="size-4" />
                    </Button>
                    <Button
                      variant="ghost"
                      size="icon"
                      aria-label={`Cấp lại mật khẩu cho ${manager.username}`}
                      title="Cấp lại mật khẩu tạm"
                      disabled={manager.status !== "ACTIVE" || !manager.contactEmail}
                      onClick={() => open({ kind: "reset", manager })}
                    >
                      <KeyRound className="size-4" />
                    </Button>
                    <Button
                      variant="ghost"
                      size="icon"
                      aria-label={`Đặt lại xác thực hai lớp cho ${manager.username}`}
                      title="Đặt lại xác thực hai lớp"
                      disabled={manager.status !== "ACTIVE" || !manager.contactEmail}
                      onClick={() => open({ kind: "mfa", manager })}
                    >
                      <RotateCcw className="size-4" />
                    </Button>
                    {manager.status === "LOCKED" ? (
                      <Button variant="ghost" size="icon" aria-label={`Mở khóa ${manager.username}`} title="Mở khóa" onClick={() => open({ kind: "unlock", manager })}>
                        <LockOpen className="size-4" />
                      </Button>
                    ) : (
                      <Button
                        variant="ghost"
                        size="icon"
                        aria-label={`Khóa ${manager.username}`}
                        title="Khóa"
                        disabled={manager.status === "DISABLED"}
                        onClick={() => open({ kind: "lock", manager })}
                      >
                        <Lock className="size-4" />
                      </Button>
                    )}
                  </div>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    );
  }

  return (
    <div className="flex flex-col gap-6">
      <PageHeader
        title="Tài khoản quản lý"
        description="Người cùng quản lý nhà xe, mỗi người chỉ dùng được các mục bạn cấp."
        actions={
          <Button className={`${BUTTON} min-w-52`} onClick={() => open({ kind: "create" })}>
            <Plus className="size-[18px]" />
            Thêm tài khoản quản lý
          </Button>
        }
      />
      {notice && (
        <div role="status" className="flex items-center gap-3 rounded-lg bg-success-50 px-5 py-3 text-sm leading-5 text-success-700">
          <CircleCheck className="size-5 shrink-0" />
          {notice}
        </div>
      )}
      <section aria-label="Danh sách tài khoản quản lý" className="flex flex-col rounded-xl border bg-card p-6">
        <div className="min-h-[200px]">{body}</div>
        {managers.data && managers.data.length > 0 && (
          <div className="flex min-h-14 items-center pt-5">
            <ListFooterNote>{managers.data.length} tài khoản quản lý</ListFooterNote>
          </div>
        )}
      </section>
      <div className="flex items-center gap-4 rounded-lg bg-accent px-5 py-4">
        <ShieldCheck className="size-5 shrink-0 text-accent-foreground" />
        <p className="min-w-0 flex-1 text-sm leading-5 text-accent-foreground">
          Tài khoản quản lý đăng nhập bằng <span className="font-medium">{operatorSlug}/tên-đăng-nhập</span>, bắt buộc xác thực hai lớp. Đổi
          quyền, khóa, cấp lại mật khẩu đều được ghi nhật ký và có hiệu lực ngay.
        </p>
      </div>
      <ManagerDialogs
        dialog={dialog}
        operatorSlug={operatorSlug}
        onClose={() => setDialog(null)}
        onDone={(message) => {
          setNotice(message);
          reload();
        }}
        onStale={reload}
      />
    </div>
  );
}
