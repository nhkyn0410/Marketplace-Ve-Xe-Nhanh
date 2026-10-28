"use client";

import { useQuery, useQueryClient } from "@tanstack/react-query";
import { useCan } from "@vexenhanh/ui/components/auth/auth-context";
import { Badge } from "@vexenhanh/ui/components/badge";
import { Button } from "@vexenhanh/ui/components/button";
import { Building2, CircleAlert, CircleCheck, MapPin, Pencil, Plus, RefreshCw, ShieldOff, Users } from "lucide-react";
import { useState } from "react";

import { useAuth } from "../../lib/auth/auth-context";
import { listSalesOffices } from "../../lib/office/office-api";
import { BUTTON, ListStatePanel } from "../list-parts";
import { PageHeader } from "../page-header";
import { TableSkeleton } from "../stop-point/list-controls";
import { OfficeDialogs, type OfficeDialog } from "./office-dialogs";

/** Quản lý nhiều văn phòng bán vé và xem các văn phòng tài khoản được phân công. */
export function OfficeScreen() {
  const can = useCan();
  const { state } = useAuth();
  const canRead = can("office:read");
  const canManage = state.status === "authenticated" && state.me.role === "OPERATOR_OWNER" && can("office:manage");
  const [dialog, setDialog] = useState<OfficeDialog | null>(null);
  const [notice, setNotice] = useState<string | null>(null);
  const queryClient = useQueryClient();
  const offices = useQuery({ queryKey: ["sales-offices"], queryFn: listSalesOffices, enabled: canRead });

  function reload() {
    void queryClient.invalidateQueries({ queryKey: ["sales-offices"] });
    void queryClient.invalidateQueries({ queryKey: ["office-assignments"] });
  }

  function open(target: OfficeDialog) {
    setNotice(null);
    setDialog(target);
  }

  const addButton = canManage ? (
    <Button className={BUTTON} onClick={() => open({ kind: "create" })}>
      <Plus className="size-[18px]" />
      Thêm văn phòng
    </Button>
  ) : undefined;

  let body;
  if (!canRead) {
    body = <ListStatePanel icon={<ShieldOff className="size-6" />} title="Bạn không có quyền xem văn phòng" description="Liên hệ chủ nhà xe để được cấp quyền phù hợp." />;
  } else if (offices.isError) {
    body = (
      <ListStatePanel
        icon={<CircleAlert className="size-6 text-warning-700" />}
        title="Chưa tải được danh sách văn phòng"
        description="Kiểm tra kết nối và quyền truy cập rồi thử lại."
        action={<Button variant="outline" className={BUTTON} onClick={() => void offices.refetch()}><RefreshCw className="size-4" />Thử lại</Button>}
      />
    );
  } else if (offices.isPending) {
    body = <TableSkeleton label="Đang tải văn phòng bán vé" rows={3} />;
  } else if (offices.data.length === 0) {
    body = (
      <ListStatePanel
        icon={<Building2 className="size-6 text-vxn-fg-3" />}
        title={canManage ? "Chưa có văn phòng bán vé" : "Chưa được phân công văn phòng"}
        description={canManage ? "Thêm văn phòng và phân công nhân viên bán vé của nhà xe." : "Chủ nhà xe cần phân công bạn vào văn phòng đang hoạt động để văn phòng xuất hiện ở đây."}
        action={addButton}
      />
    );
  } else {
    body = (
      <div className="grid gap-4 md:grid-cols-2 xl:grid-cols-3">
        {offices.data.map((office) => (
          <article key={office.id} className="flex min-w-0 flex-col gap-4 rounded-xl border bg-card p-5">
            <div className="flex items-start justify-between gap-3">
              <span className="flex size-10 shrink-0 items-center justify-center rounded-lg bg-accent text-accent-foreground"><Building2 className="size-5" /></span>
              <Badge tone={office.active ? "success" : "neutral"}>{office.active ? "Hoạt động" : "Ngừng hoạt động"}</Badge>
            </div>
            <div className="min-w-0">
              <h2 className="break-words text-base font-semibold text-vxn-ink">{office.name}</h2>
              <p className="mt-1 break-words text-xs text-muted-foreground">Mã: {office.code}</p>
            </div>
            <p className="flex flex-1 items-start gap-2 text-sm leading-5 text-muted-foreground"><MapPin className="mt-0.5 size-4 shrink-0" /><span className="break-words">{office.address}</span></p>
            {canManage && (
              <div className="flex flex-wrap gap-2 border-t pt-4">
                <Button variant="outline" size="sm" onClick={() => open({ kind: "edit", office })}><Pencil className="size-4" />Chỉnh sửa</Button>
                <Button variant="outline" size="sm" onClick={() => open({ kind: "assign", office })}><Users className="size-4" />Phân công</Button>
              </div>
            )}
          </article>
        ))}
      </div>
    );
  }

  return (
    <div className="flex flex-col gap-6">
      <PageHeader title="Văn phòng bán vé" description={canManage ? "Quản lý địa điểm bán vé và phạm vi làm việc của nhân viên bán vé." : "Các văn phòng đang hoạt động bạn được phân công."} actions={addButton} />
      {notice && <p role="status" className="flex items-center gap-3 rounded-lg bg-success-50 px-5 py-3 text-sm text-success-700"><CircleCheck className="size-5 shrink-0" />{notice}</p>}
      <section aria-label="Danh sách văn phòng bán vé">{body}</section>
      {canManage && <OfficeDialogs dialog={dialog} onClose={() => { setDialog(null); reload(); }} onSaved={(message) => { setNotice(message); reload(); }} />}
    </div>
  );
}
