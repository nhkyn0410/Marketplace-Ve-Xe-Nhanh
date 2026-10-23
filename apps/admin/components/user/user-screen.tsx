"use client";

import { useQueryClient } from "@tanstack/react-query";
import { useCan } from "@vexenhanh/ui/components/auth/auth-context";
import { Button } from "@vexenhanh/ui/components/button";
import { TAB_TRIGGER } from "@vexenhanh/ui/components/list-controls";
import { BUTTON } from "@vexenhanh/ui/components/list-parts";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@vexenhanh/ui/components/tabs";
import { CircleCheck, Plus, TriangleAlert } from "lucide-react";
import { usePathname, useRouter, useSearchParams } from "next/navigation";
import { useState } from "react";

import { PageHeader } from "../page-header";
import { AccountActionDialog, type AccountAction } from "./account-dialogs";
import { EmployeeList } from "./employee-list";
import { PassengerList } from "./passenger-list";
import { PlatformAccountDialog } from "./platform-account-dialog";
import { PlatformAccountList } from "./platform-account-list";
import { PlatformPermissionsDialog } from "./platform-permissions-dialog";
import type { Permission } from "../../lib/user/permission-catalog";
import type { PlatformAccount } from "../../lib/user/user-api";

const TABS = ["passengers", "employees", "admins"] as const;
type Tab = (typeof TABS)[number];

/**
 * Màn Người dùng (Figma ADM-03a…03d): tab Hành khách / Nhân viên nhà xe / Tài khoản quản trị (`?tab=`). Hai tab đầu cần
 * `user:manage`, tab cuối cần `access:manage` (TASK-IAM-007) — chỉ hiện tab được cấp.
 */
export function UserScreen() {
  const router = useRouter();
  const pathname = usePathname();
  const params = useSearchParams();
  const queryClient = useQueryClient();
  const can = useCan();
  const tabs = TABS.filter((value) => can(value === "admins" ? "access:manage" : "user:manage"));
  const requested = params.get("tab") ?? "";
  const tab: Tab = (tabs as readonly string[]).includes(requested) ? (requested as Tab) : (tabs[0] ?? "passengers");
  const [action, setAction] = useState<AccountAction | null>(null);
  const [editing, setEditing] = useState<{ account: PlatformAccount; grantable: Permission[] } | null>(null);
  const [creating, setCreating] = useState(false);
  const [notice, setNotice] = useState<{ tone: "success" | "warning"; text: string } | null>(null);
  const refresh = () => {
    void queryClient.invalidateQueries({ queryKey: ["admin-passengers"] });
    void queryClient.invalidateQueries({ queryKey: ["admin-platform-accounts"] });
  };

  return (
    <div className="flex flex-col gap-6">
      <PageHeader
        title="Người dùng"
        description="Tài khoản hành khách, nhân viên nhà xe (chỉ xem) và tài khoản quản trị nội bộ."
        actions={
          tab === "admins" ? (
            <Button className={`${BUTTON} min-w-52`} onClick={() => setCreating(true)}>
              <Plus className="size-[18px]" />
              Thêm tài khoản quản trị
            </Button>
          ) : undefined
        }
      />
      {notice && (
        <div
          role="status"
          className={`flex items-center gap-3 rounded-lg px-5 py-3 text-sm leading-5 ${
            notice.tone === "success" ? "bg-success-50 text-success-700" : "bg-warning-50 text-warning-700"
          }`}
        >
          {notice.tone === "success" ? <CircleCheck className="size-5 shrink-0" /> : <TriangleAlert className="size-5 shrink-0" />}
          {notice.text}
        </div>
      )}
      <Tabs
        value={tab}
        onValueChange={(next) => {
          setNotice(null);
          router.replace(next === tabs[0] ? pathname : `${pathname}?tab=${next}`, { scroll: false });
        }}
        className="flex flex-col gap-6"
      >
        <TabsList className="h-10 w-fit max-w-full overflow-x-auto" aria-label="Loại tài khoản">
          {tabs.includes("passengers") && (
            <TabsTrigger value="passengers" className={TAB_TRIGGER}>
              Hành khách
            </TabsTrigger>
          )}
          {tabs.includes("employees") && (
            <TabsTrigger value="employees" className={TAB_TRIGGER}>
              Nhân viên nhà xe
            </TabsTrigger>
          )}
          {tabs.includes("admins") && (
            <TabsTrigger value="admins" className={TAB_TRIGGER}>
              Tài khoản quản trị
            </TabsTrigger>
          )}
        </TabsList>
        <TabsContent value="passengers" className="flex flex-col gap-6">
          <PassengerList onAction={setAction} />
        </TabsContent>
        <TabsContent value="employees" className="flex flex-col gap-6">
          <EmployeeList />
        </TabsContent>
        <TabsContent value="admins" className="flex flex-col gap-6">
          <PlatformAccountList onAction={setAction} onEditPermissions={(account, grantable) => setEditing({ account, grantable })} />
        </TabsContent>
      </Tabs>
      <AccountActionDialog
        action={action}
        onClose={() => setAction(null)}
        onDone={(text) => {
          setNotice({ tone: "success", text });
          refresh();
        }}
        onStale={refresh}
      />
      <PlatformPermissionsDialog
        target={editing}
        onClose={() => setEditing(null)}
        onDone={(text) => {
          setNotice({ tone: "success", text });
          refresh();
        }}
        onStale={refresh}
      />
      <PlatformAccountDialog
        open={creating}
        onClose={() => setCreating(false)}
        onCreated={(account) => {
          refresh();
          setNotice(
            account.credentialDeliveryPending
              ? {
                  tone: "warning",
                  text: `Đã tạo ${account.username} nhưng chưa gửi được mật khẩu tạm. Dùng "Cấp lại mật khẩu" để gửi lại.`
                }
              : { tone: "success", text: `Đã tạo ${account.username}; mật khẩu tạm đã gửi tới ${account.email}.` }
          );
        }}
      />
    </div>
  );
}
