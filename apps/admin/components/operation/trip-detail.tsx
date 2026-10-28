"use client";

import { useQuery } from "@tanstack/react-query";
import { useCan } from "@vexenhanh/ui/components/auth/auth-context";
import { Badge } from "@vexenhanh/ui/components/badge";
import { TABLE, TABLE_CELL, TABLE_HEAD_CELL, TABLE_HEAD_ROW } from "@vexenhanh/ui/components/list-controls";
import { Eye } from "lucide-react";
import Link from "next/link";

import { getTrip, type TripDetail } from "../../lib/operation/operation-api";
import { CHANNEL_LABEL, count, fillLabel, STAFF_ROLE, TICKET_STATUS, TRIP_STATUS, tripTime } from "../../lib/operation/operation-format";
import { formatVnd } from "../../lib/payment/payment-format";
import { Card, DetailHeader, DetailShell, detailState, retryUnlessFinal, Row, Rows, Stat } from "./detail-parts";

const BACK = { href: "/routes?tab=trips", label: "Quay lại danh sách chuyến" };

/**
 * Chi tiết chuyến (tự thiết kế 28/10/2026, chờ duyệt; chưa có Figma): thông tin chuyến, lịch trình, nhân viên phân công,
 * danh sách người đi — mỗi vé một người, gồm khách vãng lai và khách mua tại quầy (SĐT đã che). Mỗi lượt mở trang được ghi
 * nhật ký audit; không ghi được thì không hiện dữ liệu.
 */
export function TripDetailScreen({ tripId }: { tripId: string }) {
  // Không giữ bộ nhớ đệm: mỗi lần mở là một lượt xem có ghi nhật ký.
  const trip = useQuery({ queryKey: ["admin-trip", tripId], queryFn: () => getTrip(tripId), retry: retryUnlessFinal, gcTime: 0 });
  return <DetailShell back={BACK}>{detailState(trip, "chuyến") ?? <TripBody trip={trip.data!} />}</DetailShell>;
}

function TripBody({ trip }: { trip: TripDetail }) {
  const can = useCan();
  const showMoney = can("payment:monitor");
  const status = TRIP_STATUS[trip.status] ?? { label: trip.status, tone: "neutral" as const };
  return (
    <>
      <DetailHeader
        title={`${trip.routeName} · ${tripTime(trip.departureAt)}`}
        badges={<Badge tone={status.tone}>{status.label}</Badge>}
        subtitle={
          <>
            <Link href={`/operators/${trip.operatorId}`} className="font-medium text-primary hover:underline">
              {trip.operatorName}
            </Link>
            {" · "}
            <Link href={`/routes/${trip.routeId}`} className="font-medium text-primary hover:underline">
              Xem tuyến
            </Link>
          </>
        }
      />
      <div className="grid gap-4 sm:grid-cols-2 xl:grid-cols-4">
        <Stat label="Vé đã bán" value={`${count(trip.ticketsSold)} / ${count(trip.seats)}`} note={`Lấp đầy ${fillLabel(trip.ticketsSold, trip.seats)}`} />
        <Stat label="Đơn đặt vé" value={count(trip.bookingCount)} />
        {showMoney && <Stat label="Doanh thu vé" value={trip.ticketRevenue === null ? "—" : formatVnd(trip.ticketRevenue)} />}
        <Stat
          label="Chỗ đang giữ / bị khóa"
          value={`${count(trip.seatSummary.holding)} / ${count(trip.seatSummary.blocked)}`}
          note={`${count(trip.seatSummary.available)} chỗ còn trống · ${count(trip.seatSummary.checkedIn)} đã lên xe`}
        />
      </div>
      <div className="grid items-start gap-6 xl:grid-cols-3">
        <Card title="Thông tin chuyến">
          <Rows>
            <Row label="Giờ khởi hành" value={tripTime(trip.departureAt)} />
            <Row label="Giờ đến dự kiến" value={tripTime(trip.arrivalAt)} />
            <Row label="Xe" value={trip.vehiclePlate ? `${trip.vehiclePlate}${trip.vehicleTypeName ? ` · ${trip.vehicleTypeName}` : ""}` : "Chưa gắn xe"} />
            <Row label="Ngừng bán trực tuyến" value={`${trip.onlineSaleCutoffMinutes} phút trước giờ đi`} />
            <Row label="Khởi hành thực tế" value={trip.departedAt ? tripTime(trip.departedAt) : "—"} />
            <Row label="Hoàn thành" value={trip.completedAt ? tripTime(trip.completedAt) : "—"} />
            {trip.statusReason && <Row label="Lý do đổi trạng thái" value={trip.statusReason} />}
          </Rows>
        </Card>
        <Card title="Lịch trình">
          <ol className="flex flex-col">
            {trip.stops.map((stop) => (
              <li key={stop.sequence} className="flex gap-3 pb-3 last:pb-0">
                <span className="w-24 shrink-0 text-sm leading-5 font-semibold text-vxn-ink tabular-nums">{tripTime(stop.plannedAt).slice(0, 5)}</span>
                <div className="flex min-w-0 flex-col">
                  <span className="text-sm leading-5 font-medium text-vxn-fg-1">{stop.name}</span>
                  <span className="text-xs leading-[18px] text-muted-foreground">
                    {[stop.allowPickup ? "Đón" : null, stop.allowDropoff ? "Trả" : null].filter(Boolean).join(" · ") || "Dừng nghỉ"}
                  </span>
                </div>
              </li>
            ))}
          </ol>
        </Card>
        <Card title="Nhân viên phân công">
          {trip.staff.length === 0 ? (
            <p className="text-sm leading-5 text-muted-foreground">Chưa phân công nhân viên.</p>
          ) : (
            <Rows>
              {trip.staff.map((member) => (
                <Row key={`${member.role}-${member.username}`} label={STAFF_ROLE[member.role] ?? member.role} value={member.username} />
              ))}
            </Rows>
          )}
        </Card>
      </div>
      <Card
        title="Danh sách người đi"
        description="Mỗi vé là một người đi (chỗ đôi chở tối đa hai người nhưng ghi một tên). Gồm khách vãng lai và khách mua tại quầy; SĐT đã che."
        actions={
          <span className="flex items-center gap-1.5 text-xs leading-[18px] text-muted-foreground">
            <Eye className="size-4" />
            Lượt xem được ghi nhật ký
          </span>
        }
      >
        {trip.manifest.length === 0 ? (
          <p className="text-sm leading-5 text-muted-foreground">Chuyến chưa có vé.</p>
        ) : (
          <div className="relative overflow-x-auto">
            <table className={`${TABLE} min-w-[900px]`}>
              <thead>
                <tr className={TABLE_HEAD_ROW}>
                  {["Chỗ", "Người đi", "Mã vé", "Đơn", "Người đặt", "Trạng thái vé"].map((heading) => (
                    <th key={heading} scope="col" className={TABLE_HEAD_CELL}>
                      {heading}
                    </th>
                  ))}
                </tr>
              </thead>
              <tbody>
                {trip.manifest.map((ticket) => {
                  const ticketStatus = TICKET_STATUS[ticket.status] ?? { label: ticket.status, tone: "neutral" as const };
                  return (
                    <tr key={ticket.ticketCode} className="h-[60px] border-b">
                      <td className={`${TABLE_CELL} font-semibold`}>{ticket.seatCode}</td>
                      <td className={TABLE_CELL}>
                        <div className="flex min-w-0 flex-col">
                          <span className="truncate font-medium text-vxn-ink">{ticket.fullName}</span>
                          <span className="text-xs leading-[18px] text-muted-foreground tabular-nums">{ticket.phone ?? "Không có SĐT"}</span>
                        </div>
                      </td>
                      <td className={`${TABLE_CELL} tabular-nums`}>{ticket.ticketCode}</td>
                      <td className={TABLE_CELL}>
                        {ticket.bookingCode}
                        <span className="block text-xs leading-[18px] text-muted-foreground">{CHANNEL_LABEL[ticket.channel] ?? ticket.channel}</span>
                      </td>
                      <td className={TABLE_CELL}>
                        {ticket.userId ? (
                          <Link href={`/users/passengers/${encodeURIComponent(ticket.userId)}`} className="font-medium text-primary hover:underline">
                            Tài khoản hành khách
                          </Link>
                        ) : (
                          <span className="text-muted-foreground">{ticket.channel === "COUNTER" ? "Khách tại quầy" : "Khách vãng lai"}</span>
                        )}
                      </td>
                      <td className={TABLE_CELL}>
                        <Badge tone={ticketStatus.tone}>{ticketStatus.label}</Badge>
                      </td>
                    </tr>
                  );
                })}
              </tbody>
            </table>
          </div>
        )}
      </Card>
    </>
  );
}
