"use client";

import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import {
  AlertDialog,
  AlertDialogAction,
  AlertDialogCancel,
  AlertDialogContent,
  AlertDialogDescription,
  AlertDialogFooter,
  AlertDialogHeader,
  AlertDialogTitle
} from "@vexenhanh/ui/components/alert-dialog";
import { Badge } from "@vexenhanh/ui/components/badge";
import { Button } from "@vexenhanh/ui/components/button";
import { CircleAlert, CircleCheck, Info, LoaderCircle, LogOut, RefreshCw } from "lucide-react";
import { useState, type ReactNode } from "react";

import { listAllSessions, revokeSession, type Session } from "../../lib/account/session-api";
import { lastUsedLabel, otherSessions, sortSessions } from "../../lib/account/session-format";
import { ApiError } from "../../lib/auth/api-client";
import { useAuth } from "../../lib/auth/auth-context";
import { formatDateTime } from "../../lib/route/route-format";
import { BUTTON, ListStatePanel } from "../list-parts";
import { PageHeader } from "../page-header";
import { TABLE, TABLE_CELL, TABLE_HEAD_CELL, TABLE_HEAD_ROW, TableSkeleton } from "../stop-point/list-controls";

const CARD = "flex flex-col gap-4 rounded-xl border bg-card p-6";
const CARD_TITLE = "text-base leading-6 font-semibold text-vxn-ink";
const HELPER = "text-sm leading-5 text-muted-foreground";

/** Thu hồi lần lượt; phiên đã mất (404) coi như đã thu hồi xong. */
async function revokeAll(sessionIds: string[]): Promise<void> {
  for (const sessionId of sessionIds) {
    try {
      await revokeSession(sessionId);
    } catch (error) {
      if (!(error instanceof ApiError && error.status === 404)) {
        throw error;
      }
    }
  }
}

/**
 * Màn Tài khoản và bảo mật của chủ nhà xe (Figma "01 · Tài khoản / Bảo mật"; FR-IAM-15): xem các thiết bị đang
 * đăng nhập và thu hồi phiên lạ. Chủ nhà xe không tự đổi mật khẩu hay đặt lại xác thực hai lớp ở đây — tài liệu
 * chưa có luồng đó. Tab Thông báo thuộc TASK-NSR-002.
 */
export function AccountSecurity() {
  const queryClient = useQueryClient();
  const { state } = useAuth();
  const me = state.status === "authenticated" ? state.me : null;
  const sessions = useQuery({ queryKey: ["auth-sessions"], queryFn: listAllSessions });
  const [confirmOthers, setConfirmOthers] = useState(false);
  const [notice, setNotice] = useState<string | null>(null);
  const [error, setError] = useState<string | null>(null);

  const rows = sortSessions(sessions.data ?? []);
  const others = otherSessions(rows);

  const revoke = useMutation({
    mutationFn: (sessionIds: string[]) => revokeAll(sessionIds),
    onMutate: () => {
      setNotice(null);
      setError(null);
    },
    onSuccess: (_result, sessionIds) => {
      setNotice(
        sessionIds.length === 1 ? "Đã thu hồi phiên. Thiết bị đó đã bị đăng xuất." : `Đã đăng xuất ${sessionIds.length} phiên khác.`
      );
    },
    onError: () => setError("Chưa thu hồi được phiên. Vui lòng kiểm tra kết nối và thử lại."),
    // Thành công hay lỗi giữa chừng đều tải lại để bảng đúng với máy chủ.
    onSettled: () => void queryClient.invalidateQueries({ queryKey: ["auth-sessions"] })
  });

  let body: ReactNode;
  if (sessions.isError && !sessions.data) {
    body = (
      <ListStatePanel
        compact
        icon={<CircleAlert className="size-6 text-warning-700" />}
        title="Không tải được phiên đăng nhập"
        description="Kiểm tra kết nối mạng rồi thử lại."
        action={
          <Button className={`${BUTTON} w-36`} onClick={() => void sessions.refetch()}>
            <RefreshCw className="size-[18px]" />
            Thử lại
          </Button>
        }
      />
    );
  } else if (!sessions.data) {
    body = <TableSkeleton label="Đang tải phiên đăng nhập" />;
  } else {
    body = (
      <SessionTable
        rows={rows}
        nowMs={sessions.dataUpdatedAt}
        busy={revoke.isPending}
        onRevoke={(session) => revoke.mutate([session.sessionId])}
      />
    );
  }

  return (
    <div className="flex flex-col gap-6">
      <PageHeader
        title="Tài khoản và bảo mật"
        description={me ? `${me.operatorSlug ?? ""}/${me.username} · Chủ nhà xe` : "Chủ nhà xe"}
      />

      {notice && (
        <div role="status" className="flex items-center gap-3 rounded-lg bg-success-50 px-5 py-3.5 text-sm leading-5 font-semibold text-success-600">
          <CircleCheck className="size-5 shrink-0" />
          {notice}
        </div>
      )}
      {error && (
        <div role="alert" className="flex items-center gap-3 rounded-lg bg-error-50 px-5 py-3.5 text-sm leading-5 text-error-600">
          <CircleAlert className="size-5 shrink-0" />
          {error}
        </div>
      )}

      <div className="grid items-start gap-6 xl:grid-cols-[minmax(0,1fr)_360px]">
        <section aria-labelledby="account-sessions-heading" className={CARD}>
          <div className="flex flex-wrap items-center gap-3">
            <div className="flex min-w-0 flex-1 flex-col gap-1">
              <h2 id="account-sessions-heading" className={CARD_TITLE}>
                Phiên đăng nhập
              </h2>
              <p className={HELPER}>Mỗi dòng là một thiết bị đang đăng nhập. Thu hồi phiên lạ để bảo vệ tài khoản.</p>
            </div>
            <Button
              type="button"
              variant="outline"
              className={`${BUTTON} bg-card text-error-600 hover:bg-error-50 hover:text-error-600`}
              disabled={others.length === 0 || revoke.isPending}
              onClick={() => setConfirmOthers(true)}
            >
              {revoke.isPending ? <LoaderCircle className="size-[18px] animate-spin" /> : <LogOut className="size-[18px]" />}
              Đăng xuất các phiên khác
            </Button>
          </div>
          {body}
        </section>

        <div className="flex min-w-0 flex-col gap-6">
          <section aria-labelledby="account-mfa-heading" className={CARD}>
            <div className="flex items-center gap-3">
              <h2 id="account-mfa-heading" className={`${CARD_TITLE} flex-1`}>
                Xác thực hai lớp
              </h2>
              <Badge tone={me?.mfaVerified ? "success" : "warning"}>{me?.mfaVerified ? "Đang bật" : "Chưa bật"}</Badge>
            </div>
            <div role="note" className="flex gap-3 rounded-lg bg-accent px-4 py-3 text-sm leading-5 text-vxn-teal-700">
              <Info className="mt-px size-5 shrink-0" />
              Xác thực hai lớp là bắt buộc với chủ nhà xe. Mất thiết bị xác thực và hết mã dự phòng? Liên hệ Vé Xe Nhanh
              để được đặt lại.
            </div>
          </section>

          <section aria-labelledby="account-password-heading" className={CARD}>
            <h2 id="account-password-heading" className={CARD_TITLE}>
              Mật khẩu
            </h2>
            <p className={HELPER}>
              Chủ nhà xe không tự đặt lại mật khẩu qua trang công khai. Cần cấp lại mật khẩu, hãy liên hệ Vé Xe Nhanh.
            </p>
          </section>
        </div>
      </div>

      <AlertDialog open={confirmOthers} onOpenChange={setConfirmOthers}>
        <AlertDialogContent>
          <AlertDialogHeader>
            <AlertDialogTitle>Đăng xuất {others.length} phiên khác?</AlertDialogTitle>
            <AlertDialogDescription>
              Mọi thiết bị khác đang đăng nhập tài khoản này sẽ bị đăng xuất. Phiên bạn đang dùng giữ nguyên.
            </AlertDialogDescription>
          </AlertDialogHeader>
          <AlertDialogFooter>
            <AlertDialogCancel>Hủy</AlertDialogCancel>
            <AlertDialogAction onClick={() => revoke.mutate(others.map((session) => session.sessionId))}>
              Đăng xuất các phiên khác
            </AlertDialogAction>
          </AlertDialogFooter>
        </AlertDialogContent>
      </AlertDialog>
    </div>
  );
}

const HEADINGS = ["Thiết bị", "Địa chỉ IP", "Đăng nhập", "Hoạt động", "Thao tác"];
// Cột Thiết bị co giãn; các cột còn lại đủ rộng để ngày giờ và nút nằm trên một dòng.
const COLUMNS = ["", "w-[120px]", "w-[150px]", "w-[120px]", "w-[112px]"];

function SessionTable({
  rows,
  nowMs,
  busy,
  onRevoke
}: {
  rows: Session[];
  nowMs: number;
  busy: boolean;
  onRevoke: (session: Session) => void;
}) {
  return (
    <div className="overflow-x-auto">
      <table className={`${TABLE} min-w-[660px]`}>
        <colgroup>
          {COLUMNS.map((width, index) => (
            <col key={index} className={width} />
          ))}
        </colgroup>
        <thead>
          <tr className={TABLE_HEAD_ROW}>
            {HEADINGS.map((heading) => (
              <th key={heading} scope="col" className={TABLE_HEAD_CELL}>
                {heading}
              </th>
            ))}
          </tr>
        </thead>
        <tbody>
          {rows.map((session) => (
            <tr key={session.sessionId} className="h-[61px] border-b">
              <td className={TABLE_CELL}>
                <div className="flex flex-col gap-0.5">
                  <span className="font-semibold break-words text-vxn-ink">{session.deviceLabel}</span>
                  {session.current && <span className="text-xs leading-[18px] text-muted-foreground">Phiên hiện tại</span>}
                </div>
              </td>
              <td className={TABLE_CELL}>{session.ipAddress ?? "—"}</td>
              <td className={TABLE_CELL}>{formatDateTime(session.createdAt)}</td>
              <td className={TABLE_CELL}>{lastUsedLabel(session.lastUsedAt, nowMs)}</td>
              <td className={TABLE_CELL}>
                {session.current ? (
                  <Badge tone="success">Đang dùng</Badge>
                ) : (
                  <Button
                    type="button"
                    variant="ghost"
                    className={`${BUTTON} gap-1.5 px-2 text-vxn-fg-1`}
                    disabled={busy}
                    aria-label={`Thu hồi phiên ${session.deviceLabel}, đăng nhập ${formatDateTime(session.createdAt)}`}
                    onClick={() => onRevoke(session)}
                  >
                    Thu hồi
                    <LogOut className="size-4" />
                  </Button>
                )}
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}
