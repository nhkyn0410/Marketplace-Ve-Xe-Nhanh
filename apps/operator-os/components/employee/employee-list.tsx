"use client";

import { useQuery, useQueryClient } from "@tanstack/react-query";
import { Badge } from "@vexenhanh/ui/components/badge";
import { Button } from "@vexenhanh/ui/components/button";
import { cn } from "@vexenhanh/ui/lib/utils";
import {
  CalendarCheck,
  CircleAlert,
  CircleCheck,
  FileX2,
  KeyRound,
  Lock,
  LockOpen,
  Pencil,
  Plus,
  RefreshCw,
  Users
} from "lucide-react";
import Link from "next/link";
import { useMemo, useState, type ReactNode } from "react";

import { useAuth } from "../../lib/auth/auth-context";
import { listAllEmployees, type Employee, type EmployeeRole, type EmployeeStatus } from "../../lib/employee/employee-api";
import {
  EMPLOYEE_ROLE,
  EMPLOYEE_ROLE_ORDER,
  EMPLOYEE_STATUS,
  EMPLOYEE_STATUS_ORDER,
  filterEmployees,
  loginName,
  passwordState,
  sortEmployees,
  type PasswordState
} from "../../lib/employee/employee-format";
import { BUTTON, ListFooterNote, ListStatePanel } from "../list-parts";
import { PageHeader } from "../page-header";
import {
  ALL,
  FilterSelect,
  SearchField,
  TABLE,
  TABLE_CELL,
  TABLE_HEAD_CELL,
  TABLE_HEAD_ROW,
  TableSkeleton
} from "../stop-point/list-controls";
import { EmployeeActionDialog, type EmployeeActionKind, type EmployeeActionTarget } from "./employee-action-dialog";
import { EmployeeFormDialog, type EmployeeFormTarget } from "./employee-form-dialog";

type Notice = { title: string; detail: string };

/**
 * Màn Nhân viên (Figma "01 · Nhân viên / Danh sách"; UC-16, TASK-IAM-005): chủ nhà xe cấp và quản lý tài khoản
 * nhân viên. API chưa có tìm / lọc nên tải hết rồi lọc ở giao diện. Phân công chuyến thuộc TASK-EMP-001.
 */
export function EmployeeList() {
  const queryClient = useQueryClient();
  const { state } = useAuth();
  const operatorSlug = state.status === "authenticated" ? (state.me.operatorSlug ?? "") : "";
  const [search, setSearch] = useState("");
  const [role, setRole] = useState<string>(ALL);
  const [status, setStatus] = useState<string>(ALL);
  const [form, setForm] = useState<EmployeeFormTarget | null>(null);
  const [action, setAction] = useState<EmployeeActionTarget | null>(null);
  const [notice, setNotice] = useState<Notice | null>(null);
  // Mốc "bây giờ" chụp lúc mở trang, để biết mật khẩu tạm nào đã hết hạn.
  const [nowMs] = useState(() => Date.now());

  const employees = useQuery({ queryKey: ["employees"], queryFn: listAllEmployees });
  const rows = useMemo(() => sortEmployees(employees.data ?? []), [employees.data]);
  const visible = useMemo(
    () =>
      filterEmployees(rows, {
        search,
        role: role === ALL ? null : (role as EmployeeRole),
        status: status === ALL ? null : (status as EmployeeStatus)
      }),
    [rows, search, role, status]
  );
  const filtered = search.trim() !== "" || role !== ALL || status !== ALL;

  function reload() {
    void queryClient.invalidateQueries({ queryKey: ["employees"] });
  }

  function open(target: EmployeeFormTarget | EmployeeActionTarget) {
    setNotice(null);
    if ("mode" in target) {
      setForm(target);
    } else {
      setAction(target);
    }
  }

  function saved(employee: Employee, mode: "create" | "edit") {
    const login = loginName(operatorSlug, employee.username);
    setForm(null);
    reload();
    if (mode === "create") {
      setNotice({
        title: `Đã tạo tài khoản ${login}`,
        detail: `Mật khẩu tạm đã gửi tới ${employee.contactEmail}. Nhân viên phải đổi mật khẩu ở lần đăng nhập đầu.`
      });
    } else {
      setNotice({
        title: `Đã cập nhật ${login}`,
        detail: employee.credentialDeliveryPending
          ? "Email liên hệ đã đổi: bấm cấp lại mật khẩu để gửi mật khẩu tạm tới email mới."
          : "Thay đổi có hiệu lực ngay."
      });
    }
  }

  function done({ kind, employee }: EmployeeActionTarget) {
    const login = loginName(operatorSlug, employee.username);
    setAction(null);
    reload();
    const notices: Record<EmployeeActionKind, Notice> = {
      reset: {
        title: `Đã cấp lại mật khẩu tạm cho ${login}`,
        detail: `Mật khẩu tạm mới đã gửi tới ${employee.contactEmail}.`
      },
      lock: { title: `Đã khóa ${login}`, detail: "Nhân viên đã bị đăng xuất khỏi mọi thiết bị." },
      unlock: { title: `Đã mở khóa ${login}`, detail: "Nhân viên đăng nhập lại được." }
    };
    setNotice(notices[kind]);
  }

  const addButton = (
    <Button type="button" className={`${BUTTON} w-48`} onClick={() => open({ mode: "create" })}>
      <Plus className="size-[18px]" />
      Thêm nhân viên
    </Button>
  );

  let body: ReactNode;
  let footer: ReactNode = null;
  if (employees.isError && !employees.data) {
    body = (
      <ListStatePanel
        icon={<CircleAlert className="size-6 text-warning-700" />}
        title="Không tải được danh sách nhân viên"
        description="Kiểm tra kết nối mạng rồi thử lại."
        action={
          <Button className={`${BUTTON} w-36`} onClick={() => void employees.refetch()}>
            <RefreshCw className="size-[18px]" />
            Thử lại
          </Button>
        }
      />
    );
  } else if (!employees.data) {
    body = <TableSkeleton label="Đang tải danh sách nhân viên" />;
    footer = <ListFooterNote>Đang tải danh sách nhân viên…</ListFooterNote>;
  } else if (rows.length === 0) {
    body = (
      <ListStatePanel
        icon={<Users className="size-6 text-vxn-fg-3" />}
        title="Chưa có nhân viên"
        description="Thêm tài xế, nhân viên soát vé, nhân viên bán vé hoặc nhân viên hỗ trợ của nhà xe."
        action={addButton}
      />
    );
  } else if (visible.length === 0) {
    body = (
      <ListStatePanel
        icon={<FileX2 className="size-6 text-vxn-fg-3" />}
        title="Không có nhân viên phù hợp"
        description="Đổi từ khóa, vai trò hoặc trạng thái, hoặc bỏ lọc để xem toàn bộ nhân viên."
        action={
          <Button
            variant="outline"
            className={`${BUTTON} bg-card`}
            onClick={() => {
              setSearch("");
              setRole(ALL);
              setStatus(ALL);
            }}
          >
            Bỏ lọc
          </Button>
        }
      />
    );
  } else {
    body = <EmployeeTable rows={visible} operatorSlug={operatorSlug} nowMs={nowMs} onOpen={open} />;
    footer = (
      <ListFooterNote>
        {filtered ? `Đang hiển thị ${visible.length} / ${rows.length} nhân viên` : `Đã tải ${rows.length} nhân viên`}
      </ListFooterNote>
    );
  }

  return (
    <div className="flex flex-col gap-6">
      <PageHeader
        title="Nhân viên"
        description="Nhân viên bán vé dùng cổng bán vé riêng; tài xế, soát vé và hỗ trợ dùng ứng dụng Nhân viên. Chủ nhà xe cấp và quản lý tài khoản."
        actions={
          <>
            {/* Figma "05 · Nhân viên / Phân công chuyến" (TASK-EMP-001). */}
            <Button asChild variant="outline" className={`${BUTTON} bg-card`}>
              <Link href="/employees/assignments">
                <CalendarCheck className="size-[18px]" />
                Phân công chuyến
              </Link>
            </Button>
            {addButton}
          </>
        }
      />

      {notice && (
        <div role="status" className="flex flex-wrap items-center gap-3 rounded-lg bg-success-50 px-5 py-3.5">
          <CircleCheck className="size-5 shrink-0 text-success-600" />
          <div className="min-w-0 flex-1">
            <p className="text-sm leading-5 font-semibold text-success-600">{notice.title}</p>
            <p className="text-sm leading-5 text-success-600">{notice.detail}</p>
          </div>
          <Button type="button" variant="outline" className={`${BUTTON} w-[100px] bg-card`} onClick={() => setNotice(null)}>
            Đóng
          </Button>
        </div>
      )}

      <section aria-label="Danh sách nhân viên" className="flex flex-col rounded-xl border bg-card p-6">
        <div className="flex flex-wrap items-end gap-x-4 gap-y-3 pb-5">
          <SearchField
            label="Tìm nhân viên"
            placeholder="Tên đăng nhập hoặc email"
            value={search}
            onChange={setSearch}
            className="max-w-xs"
          />
          <FilterSelect
            label="Vai trò"
            allLabel="Tất cả vai trò"
            value={role}
            onChange={setRole}
            options={EMPLOYEE_ROLE_ORDER.map((value) => ({ value: value as string, label: EMPLOYEE_ROLE[value].label }))}
            className="w-56"
          />
          <FilterSelect
            label="Trạng thái"
            allLabel="Tất cả trạng thái"
            value={status}
            onChange={setStatus}
            options={EMPLOYEE_STATUS_ORDER.map((value) => ({
              value: value as string,
              label: EMPLOYEE_STATUS[value].label
            }))}
            className="w-56"
          />
        </div>
        <div className="min-h-[360px]">{body}</div>
        {footer && <div className="flex min-h-14 items-center pt-5">{footer}</div>}
      </section>

      <div className="flex items-center gap-4 rounded-lg bg-accent px-5 py-4">
        <KeyRound className="size-5 shrink-0 text-vxn-teal-700" />
        <p className="min-w-0 flex-1 text-sm leading-5 text-vxn-teal-700">
          Mật khẩu tạm được gửi tới email liên hệ, có hiệu lực 24 giờ và phải đổi ở lần đăng nhập đầu. Nhân viên không
          tự đặt lại mật khẩu; chủ nhà xe cấp lại khi cần.
        </p>
      </div>

      <EmployeeFormDialog
        target={form}
        operatorSlug={operatorSlug}
        onClose={() => setForm(null)}
        onSaved={saved}
        onStale={reload}
      />
      <EmployeeActionDialog
        target={action}
        operatorSlug={operatorSlug}
        onClose={() => setAction(null)}
        onDone={done}
        onStale={reload}
      />
    </div>
  );
}

// Độ rộng cột theo Figma (co giãn / 170 / 150 / 260 / 130 trên bảng rộng 1086).
const COLUMNS = ["", "w-[15.7%]", "w-[13.8%]", "w-[24%]", "w-[136px]"];
const HEADINGS = ["Tài khoản", "Vai trò", "Trạng thái", "Mật khẩu", "Thao tác"];
const SUBLINE = "truncate text-xs leading-[18px] text-muted-foreground";
const STRONG = "truncate font-semibold text-vxn-ink";
const PASSWORD_TONE: Record<PasswordState["tone"], string> = {
  ok: "text-vxn-ink",
  warning: "text-warning-700",
  danger: "text-error-600",
  muted: "text-muted-foreground"
};
const ICON_BUTTON =
  "flex size-9 items-center justify-center rounded-lg text-vxn-fg-3 outline-none hover:bg-muted hover:text-vxn-fg-1 focus-visible:ring-[3px] focus-visible:ring-ring/50 disabled:pointer-events-none disabled:opacity-40";

function EmployeeTable({
  rows,
  operatorSlug,
  nowMs,
  onOpen
}: {
  rows: Employee[];
  operatorSlug: string;
  nowMs: number;
  onOpen: (target: EmployeeFormTarget | EmployeeActionTarget) => void;
}) {
  return (
    <div className="overflow-x-auto">
      <table className={`${TABLE} min-w-[940px]`}>
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
          {rows.map((employee) => {
            const login = loginName(operatorSlug, employee.username);
            const password = passwordState(employee, nowMs);
            // Tài khoản đã vô hiệu hóa không mở lại được (TASK-IAM-005 Q5) nên không còn thao tác nào.
            const disabled = employee.status === "DISABLED";
            const locked = employee.status === "LOCKED";
            return (
              <tr key={employee.id} className="h-[69px] border-b">
                <td className={TABLE_CELL}>
                  <div className="flex flex-col gap-0.5">
                    <span className={STRONG}>{login}</span>
                    <span className={SUBLINE}>{employee.contactEmail ?? "Chưa có email liên hệ"}</span>
                  </div>
                </td>
                <td className={TABLE_CELL}>
                  <Badge tone="neutral">{EMPLOYEE_ROLE[employee.role].label}</Badge>
                </td>
                <td className={TABLE_CELL}>
                  <Badge tone={EMPLOYEE_STATUS[employee.status].tone}>{EMPLOYEE_STATUS[employee.status].label}</Badge>
                </td>
                <td className={TABLE_CELL}>
                  <div className="flex flex-col gap-0.5">
                    <span className={cn("truncate font-semibold", PASSWORD_TONE[password.tone])}>{password.label}</span>
                    <span className={SUBLINE}>{password.detail}</span>
                  </div>
                </td>
                <td className={TABLE_CELL}>
                  <div className="flex items-center gap-1">
                    <button
                      type="button"
                      className={ICON_BUTTON}
                      aria-label={`Sửa ${login}`}
                      title="Sửa tài khoản"
                      disabled={disabled}
                      onClick={() => onOpen({ mode: "edit", employee })}
                    >
                      <Pencil className="size-[18px]" />
                    </button>
                    <button
                      type="button"
                      className={ICON_BUTTON}
                      aria-label={`Cấp lại mật khẩu tạm cho ${login}`}
                      title="Cấp lại mật khẩu tạm"
                      disabled={disabled}
                      onClick={() => onOpen({ kind: "reset", employee })}
                    >
                      <KeyRound className="size-[18px]" />
                    </button>
                    <button
                      type="button"
                      className={ICON_BUTTON}
                      aria-label={`${locked ? "Mở khóa" : "Khóa"} ${login}`}
                      title={locked ? "Mở khóa tài khoản" : "Khóa tài khoản"}
                      disabled={disabled}
                      onClick={() => onOpen({ kind: locked ? "unlock" : "lock", employee })}
                    >
                      {locked ? <LockOpen className="size-[18px]" /> : <Lock className="size-[18px]" />}
                    </button>
                  </div>
                </td>
              </tr>
            );
          })}
        </tbody>
      </table>
    </div>
  );
}
