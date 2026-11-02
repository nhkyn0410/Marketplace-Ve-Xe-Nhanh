"use client";

import { useQuery, useQueryClient } from "@tanstack/react-query";
import { useCan } from "@vexenhanh/ui/components/auth/auth-context";
import { Badge } from "@vexenhanh/ui/components/badge";
import { Button } from "@vexenhanh/ui/components/button";
import { TAB_TRIGGER, TABLE, TABLE_CELL, TABLE_HEAD_CELL, TABLE_HEAD_ROW, TableSkeleton } from "@vexenhanh/ui/components/list-controls";
import { BUTTON } from "@vexenhanh/ui/components/list-parts";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@vexenhanh/ui/components/tabs";
import { CircleCheck, FileText, Landmark, Lock, LockOpen } from "lucide-react";
import Link from "next/link";
import { usePathname, useRouter, useSearchParams } from "next/navigation";
import { useState } from "react";

import { getOperator, listOperatorVehicles, type OperatorDetail } from "../../lib/operation/operation-api";
import { count, dayLabel, fillLabel, ratingLabel, VEHICLE_STATUS } from "../../lib/operation/operation-format";
import { formatVnd } from "../../lib/payment/payment-format";
import { suspendOperator, unsuspendOperator } from "../../lib/user/user-api";
import { formatDate, OPERATOR_STATUS } from "../../lib/user/user-format";
import { Card, DetailHeader, DetailShell, detailState, retryUnlessFinal, Row, Rows, Stat } from "../operation/detail-parts";
import { RouteList } from "../operation/route-list";
import { TripList } from "../operation/trip-list";
import { AccountActionDialog, type AccountAction } from "../user/account-dialogs";
import { EmployeeList } from "../user/employee-list";
import { BankChangeDialog } from "./bank-change-dialog";

const TABS = ["info", "routes", "trips", "vehicles", "employees"] as const;
type Tab = (typeof TABS)[number];
const BACK = { href: "/operators?tab=operators", label: "Quay lại danh sách nhà xe" };

/**
 * Chi tiết nhà xe (tự thiết kế 28/10/2026, chờ duyệt; chưa có Figma — FR-ADM-02 "giám sát", SRS ma trận quyền): thẻ số 30
 * ngày, tab Thông tin / Tuyến / Chuyến / Đội xe / Nhân viên (`?tab=`). Thao tác giữ như danh sách: tạm khóa / mở khóa, xác
 * minh tài khoản nhận tiền, mở hồ sơ KYC.
 */
export function OperatorDetailScreen({ operatorId }: { operatorId: string }) {
  const operator = useQuery({ queryKey: ["admin-operator", operatorId], queryFn: () => getOperator(operatorId), retry: retryUnlessFinal });
  return <DetailShell back={BACK}>{detailState(operator, "nhà xe") ?? <OperatorBody operator={operator.data!} />}</DetailShell>;
}

function OperatorBody({ operator }: { operator: OperatorDetail }) {
  const router = useRouter();
  const pathname = usePathname();
  const params = useSearchParams();
  const queryClient = useQueryClient();
  const can = useCan();
  const showMoney = can("payment:monitor");
  const [action, setAction] = useState<AccountAction | null>(null);
  const [verifying, setVerifying] = useState(false);
  const [notice, setNotice] = useState<string | null>(null);
  const requested = params.get("tab") ?? "";
  const tab: Tab = (TABS as readonly string[]).includes(requested) ? (requested as Tab) : "info";
  const status = OPERATOR_STATUS[operator.status];
  const stats = operator.stats;
  const refresh = () => {
    void queryClient.invalidateQueries({ queryKey: ["admin-operator", operator.id] });
    void queryClient.invalidateQueries({ queryKey: ["admin-operators"] });
  };
  const done = (message: string) => {
    setNotice(message);
    refresh();
  };

  function suspend() {
    setAction({
      title: "Tạm khóa nhà xe",
      subtitle: `${operator.name} · ${operator.slug}`,
      warning: "Nhà xe sẽ không tạo hoặc mở bán chuyến mới. Mọi phiên đăng nhập của nhà xe bị thu hồi và nhà xe nhận thông báo kèm lý do.",
      withReason: true,
      confirmLabel: "Tạm khóa nhà xe",
      destructive: true,
      run: (reason) => suspendOperator(operator.id, reason),
      done: `Đã tạm khóa nhà xe ${operator.name}.`
    });
  }

  function unsuspend() {
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

  return (
    <>
      <DetailHeader
        title={operator.name}
        badges={<Badge tone={status.tone}>{status.label}</Badge>}
        subtitle={`Mã ${operator.slug} · duyệt ngày ${formatDate(operator.approvedAt)}`}
        actions={
          <>
            {operator.applicationId && can("kyc:review") && (
              <Button asChild variant="outline" className={`${BUTTON} bg-card`}>
                <Link href={`/operators/applications/${operator.applicationId}`}>
                  <FileText className="size-[18px]" />
                  Hồ sơ KYC
                </Link>
              </Button>
            )}
            {operator.status === "SUSPENDED" ? (
              <Button variant="outline" className={`${BUTTON} bg-card`} onClick={unsuspend}>
                <LockOpen className="size-[18px]" />
                Mở khóa
              </Button>
            ) : (
              <Button variant="destructive" className={BUTTON} onClick={suspend}>
                <Lock className="size-[18px]" />
                Tạm khóa
              </Button>
            )}
          </>
        }
      />
      {notice && (
        <div role="status" className="flex items-center gap-3 rounded-lg bg-success-50 px-5 py-3 text-sm leading-5 text-success-700">
          <CircleCheck className="size-5 shrink-0" />
          {notice}
        </div>
      )}
      {operator.status === "SUSPENDED" && operator.suspendedReason && (
        <div role="note" className="rounded-lg bg-error-50 px-5 py-3 text-sm leading-5 text-error-700">
          Tạm khóa từ {formatDate(operator.suspendedAt)}: {operator.suspendedReason}
        </div>
      )}
      {operator.bankChangePending && (
        <div role="note" className="flex flex-wrap items-center justify-between gap-3 rounded-lg bg-warning-50 px-5 py-3 text-sm leading-5 text-warning-700">
          <span className="flex items-center gap-2">
            <Landmark className="size-5 shrink-0" />
            Nhà xe đang chờ xác minh yêu cầu đổi tài khoản nhận tiền.
          </span>
          <Button variant="outline" className="h-9 bg-card" onClick={() => setVerifying(true)}>
            Xác minh tài khoản
          </Button>
        </div>
      )}
      <div className="flex flex-col gap-2">
        <p className="text-xs leading-[18px] text-muted-foreground">
          30 ngày gần nhất ({dayLabel(stats.from)} – {dayLabel(stats.to)}), tính trên chuyến đã khởi hành trong kỳ.
        </p>
        <div className="grid gap-4 sm:grid-cols-2 xl:grid-cols-5">
          <Stat label="Chuyến" value={count(stats.trips)} note={`${count(stats.completedTrips)} hoàn thành · ${count(stats.cancelledTrips)} đã hủy`} />
          <Stat label="Vé bán" value={count(stats.ticketsSold)} note={`Lấp đầy ${fillLabel(stats.ticketsSold, stats.seats)}`} />
          {showMoney && <Stat label="Doanh thu vé" value={stats.ticketRevenue === null ? "—" : formatVnd(stats.ticketRevenue)} />}
          {showMoney && <Stat label="Đã hoàn tiền" value={stats.refunded === null ? "—" : formatVnd(stats.refunded)} />}
          <Stat label="Đánh giá" value={ratingLabel(stats.averageRating, stats.reviewCount)} />
        </div>
      </div>
      <Tabs value={tab} onValueChange={(next) => router.replace(next === "info" ? pathname : `${pathname}?tab=${next}`, { scroll: false })} className="flex flex-col gap-6">
        <TabsList className="h-10 w-fit max-w-full overflow-x-auto" aria-label="Thông tin nhà xe">
          <TabsTrigger value="info" className={TAB_TRIGGER}>
            Thông tin
          </TabsTrigger>
          <TabsTrigger value="routes" className={TAB_TRIGGER}>
            Tuyến ({count(operator.routeCount)})
          </TabsTrigger>
          <TabsTrigger value="trips" className={TAB_TRIGGER}>
            Chuyến
          </TabsTrigger>
          <TabsTrigger value="vehicles" className={TAB_TRIGGER}>
            Đội xe ({count(operator.vehicleCount)})
          </TabsTrigger>
          <TabsTrigger value="employees" className={TAB_TRIGGER}>
            Nhân viên ({count(operator.employeeCount)})
          </TabsTrigger>
        </TabsList>
        <TabsContent value="info">
          <InfoTab operator={operator} />
        </TabsContent>
        <TabsContent value="routes" className="flex flex-col gap-6">
          {tab === "routes" && <RouteList operatorId={operator.id} />}
        </TabsContent>
        <TabsContent value="trips" className="flex flex-col gap-6">
          {tab === "trips" && <TripList operatorId={operator.id} />}
        </TabsContent>
        <TabsContent value="vehicles">{tab === "vehicles" && <VehicleTab operatorId={operator.id} />}</TabsContent>
        <TabsContent value="employees" className="flex flex-col gap-6">
          {tab === "employees" && <EmployeeList operatorId={operator.id} />}
        </TabsContent>
      </Tabs>
      <AccountActionDialog action={action} onClose={() => setAction(null)} onDone={done} onStale={refresh} />
      <BankChangeDialog operator={verifying ? operator : null} onClose={() => setVerifying(false)} onDone={done} onStale={refresh} />
    </>
  );
}

function InfoTab({ operator }: { operator: OperatorDetail }) {
  return (
    <div className="grid items-start gap-6 xl:grid-cols-3">
      <Card title="Thông tin công khai">
        <Rows>
          <Row label="Tên hiển thị" value={operator.name} />
          <Row label="Đường dây nóng" value={operator.hotline ?? "—"} />
          <Row label="Email công khai" value={operator.publicEmail ?? "—"} />
          <Row label="Địa chỉ" value={operator.address ?? "—"} />
        </Rows>
        {operator.description && <p className="text-sm leading-5 whitespace-pre-line text-vxn-fg-1">{operator.description}</p>}
      </Card>
      <Card title="Pháp lý & tài khoản nhận tiền">
        <Rows>
          <Row label="Tên pháp lý" value={operator.legalName ?? "—"} />
          <Row label="Mã số thuế" value={operator.taxCode ?? "—"} />
          <Row label="Ngân hàng" value={operator.bankAccount?.bankName ?? "Chưa có tài khoản đã xác minh"} />
          {operator.bankAccount && (
            <>
              <Row label="Số tài khoản" value={operator.bankAccount.accountNumber} />
              <Row label="Chủ tài khoản" value={operator.bankAccount.accountHolder} />
              <Row label="Xác minh ngày" value={formatDate(operator.bankAccount.verifiedAt)} />
            </>
          )}
        </Rows>
        <p className="text-xs leading-[18px] text-muted-foreground">Số tài khoản đã che. Số đầy đủ chỉ hiện trong hộp thoại xác minh (có ghi nhật ký).</p>
      </Card>
      <Card title="Chủ nhà xe & vận hành">
        <Rows>
          <Row label="Tài khoản chủ" value={operator.owner?.username ?? "—"} />
          <Row label="Email chủ" value={operator.owner?.email ?? "—"} />
          <Row label="Tuyến đang dùng" value={count(operator.routeCount)} />
          <Row label="Chuyến đang mở bán" value={count(operator.openTripCount)} />
          <Row label="Số xe" value={count(operator.vehicleCount)} />
          <Row label="Nhân viên" value={count(operator.employeeCount)} />
        </Rows>
        {operator.owner?.credentialDeliveryPending && (
          <p className="text-xs leading-[18px] text-warning-700">Chưa gửi được mật khẩu tạm cho chủ nhà xe — gửi lại ở hồ sơ KYC.</p>
        )}
      </Card>
    </div>
  );
}

function VehicleTab({ operatorId }: { operatorId: string }) {
  const vehicles = useQuery({ queryKey: ["admin-operator-vehicles", operatorId], queryFn: () => listOperatorVehicles(operatorId) });
  return (
    <section aria-label="Đội xe" className="flex flex-col rounded-xl border bg-card p-6">
      {vehicles.isPending ? (
        <TableSkeleton label="Đang tải đội xe" rows={4} />
      ) : vehicles.isError ? (
        <p className="text-sm leading-5 text-warning-700">Không tải được đội xe. Tải lại trang để thử lại.</p>
      ) : vehicles.data.length === 0 ? (
        <p className="text-sm leading-5 text-muted-foreground">Nhà xe chưa khai báo xe nào.</p>
      ) : (
        <div className="relative overflow-x-auto">
          <table className={`${TABLE} min-w-[640px]`}>
            <thead>
              <tr className={TABLE_HEAD_ROW}>
                {["Biển số", "Loại xe", "Số chỗ", "Chuyến sắp chạy", "Trạng thái"].map((heading) => (
                  <th key={heading} scope="col" className={TABLE_HEAD_CELL}>
                    {heading}
                  </th>
                ))}
              </tr>
            </thead>
            <tbody>
              {vehicles.data.map((vehicle) => {
                const status = VEHICLE_STATUS[vehicle.status] ?? { label: vehicle.status, tone: "neutral" as const };
                return (
                  <tr key={vehicle.id} className="h-[56px] border-b">
                    <td className={`${TABLE_CELL} font-semibold text-vxn-ink`}>{vehicle.plateNumber}</td>
                    <td className={TABLE_CELL}>{vehicle.vehicleTypeName}</td>
                    <td className={`${TABLE_CELL} tabular-nums`}>{vehicle.seatCount ?? "Chưa có sơ đồ ghế"}</td>
                    <td className={`${TABLE_CELL} tabular-nums`}>{count(vehicle.upcomingTripCount)}</td>
                    <td className={TABLE_CELL}>
                      <Badge tone={status.tone}>{status.label}</Badge>
                    </td>
                  </tr>
                );
              })}
            </tbody>
          </table>
        </div>
      )}
    </section>
  );
}
