"use client";

import { useInfiniteQuery, useQuery } from "@tanstack/react-query";
import { Badge } from "@vexenhanh/ui/components/badge";
import { Button } from "@vexenhanh/ui/components/button";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue
} from "@vexenhanh/ui/components/select";
import { Skeleton } from "@vexenhanh/ui/components/skeleton";
import {
  Armchair,
  ArrowUpRight,
  CircleAlert,
  FileX2,
  ImageOff,
  LoaderCircle,
  Pencil,
  Plus,
  RefreshCw
} from "lucide-react";
import Link from "next/link";
import { useId, useMemo, useState, type ReactNode } from "react";

import {
  listAmenities,
  listVehicles,
  listVehicleTypes,
  type Vehicle,
  type VehicleStatus
} from "../../lib/vehicle/vehicle-api";
import {
  amenitySummary,
  formatPlateNumber,
  seatMapSummaryLine,
  VEHICLE_STATUS,
  VEHICLE_STATUS_ORDER,
  vehicleTypeLabel
} from "../../lib/vehicle/vehicle-format";
import { PageHeader } from "../page-header";

const ALL_STATUSES = "ALL";
const BUTTON = "h-10 rounded-lg px-4 text-sm font-semibold";

/** Màn danh sách phương tiện của nhà xe (Figma 01, 05–07 + "Tải thêm"; FR-OPS-01..02). */
export function VehicleList() {
  const [status, setStatus] = useState<VehicleStatus | typeof ALL_STATUSES>(ALL_STATUSES);
  const filterId = useId();

  const vehicles = useInfiniteQuery({
    queryKey: ["vehicles", status],
    queryFn: ({ pageParam }) =>
      listVehicles({ status: status === ALL_STATUSES ? undefined : status, cursor: pageParam }),
    initialPageParam: undefined as string | undefined,
    getNextPageParam: (lastPage) => lastPage.nextCursor ?? undefined
  });
  // Catalog ít đổi: giữ lâu để chuyển qua lại giữa danh sách và form không gọi lại.
  const vehicleTypes = useQuery({ queryKey: ["catalog", "vehicle-types"], queryFn: listVehicleTypes, staleTime: 300_000 });
  const amenities = useQuery({ queryKey: ["catalog", "amenities"], queryFn: listAmenities, staleTime: 300_000 });

  const typeLabels = useMemo(
    () => new Map((vehicleTypes.data ?? []).map((type) => [type.id, vehicleTypeLabel(type)])),
    [vehicleTypes.data]
  );
  const items = useMemo(() => vehicles.data?.pages.flatMap((page) => page.items) ?? [], [vehicles.data]);

  const pending = vehicles.isPending || vehicleTypes.isPending || amenities.isPending;
  // Lỗi khi tải thêm KHÔNG thuộc nhánh này: các xe đã tải vẫn được giữ lại (xem chân bảng).
  const failed = (vehicles.isError && !vehicles.data) || vehicleTypes.isError || amenities.isError;
  const filtered = status !== ALL_STATUSES;

  function retry() {
    for (const query of [vehicles, vehicleTypes, amenities]) {
      if (query.isError) {
        void query.refetch();
      }
    }
  }

  let subtitle: string;
  let body: ReactNode;
  let footer: ReactNode;
  if (failed) {
    subtitle = "Chưa tải được dữ liệu";
    body = (
      <StatePanel
        icon={<CircleAlert className="size-6 text-warning-700" />}
        title="Không tải được phương tiện"
        description="Không kết nối được máy chủ. Vui lòng kiểm tra kết nối và thử lại."
        action={
          <Button variant="outline" className={`${BUTTON} bg-card`} onClick={retry}>
            <RefreshCw className="size-[18px]" />
            Thử lại
          </Button>
        }
      />
    );
    footer = <FooterNote>Thử lại để tải danh sách phương tiện của nhà xe.</FooterNote>;
  } else if (pending) {
    subtitle = "Đang tải phương tiện…";
    body = <LoadingRows />;
    footer = <FooterNote>Đang tải danh sách phương tiện…</FooterNote>;
  } else if (items.length === 0) {
    subtitle = filtered ? "Không có phương tiện ở trạng thái này" : "Nhà xe chưa có phương tiện";
    body = filtered ? (
      <StatePanel
        icon={<FileX2 className="size-6 text-vxn-fg-3" />}
        title="Không có phương tiện ở trạng thái này"
        description="Chọn trạng thái khác hoặc bỏ lọc để xem toàn bộ phương tiện."
        action={
          <Button variant="outline" className={`${BUTTON} bg-card`} onClick={() => setStatus(ALL_STATUSES)}>
            Bỏ lọc
          </Button>
        }
      />
    ) : (
      <StatePanel
        icon={<FileX2 className="size-6 text-vxn-fg-3" />}
        title="Thêm phương tiện đầu tiên"
        description="Bắt đầu với biển số, loại xe và ảnh. Bạn có thể bổ sung sơ đồ ghế sau."
        action={
          <Button asChild variant="outline" className={`${BUTTON} bg-card`}>
            <Link href="/vehicles/new">
              <Plus className="size-[18px]" />
              Thêm phương tiện
            </Link>
          </Button>
        }
      />
    );
    footer = <FooterNote>{filtered ? "Không có phương tiện phù hợp bộ lọc" : "Chưa có dữ liệu phương tiện"}</FooterNote>;
  } else {
    subtitle = `Đang hiển thị ${items.length} phương tiện`;
    body = (
      <VehicleTable
        items={items}
        typeLabels={typeLabels}
        amenityNames={(amenities.data ?? []).map((amenity) => [amenity.id, amenity.name])}
      />
    );
    footer = (
      <LoadMoreFooter
        count={items.length}
        hasMore={vehicles.hasNextPage}
        loading={vehicles.isFetchingNextPage}
        failed={vehicles.isFetchNextPageError}
        onLoadMore={() => void vehicles.fetchNextPage()}
      />
    );
  }

  return (
    <div className="flex flex-col gap-6">
      <PageHeader
        title="Phương tiện"
        description="Quản lý thông tin, ảnh và sơ đồ ghế của từng xe."
        actions={
          <Button asChild className={`${BUTTON} w-52`}>
            <Link href="/vehicles/new">
              <Plus className="size-[18px]" />
              Thêm phương tiện
            </Link>
          </Button>
        }
      />

      <section aria-labelledby="vehicle-list-heading" className="flex flex-col gap-5 rounded-xl border bg-card p-6">
        <div className="flex flex-wrap items-center gap-x-5 gap-y-3">
          <div className="flex min-w-0 flex-1 flex-col gap-1">
            <h2 id="vehicle-list-heading" className="text-base leading-6 font-semibold text-vxn-ink">
              Danh sách phương tiện
            </h2>
            <p className="text-xs leading-[18px] text-muted-foreground" aria-live="polite">
              {subtitle}
            </p>
          </div>
          <div className="flex w-60 flex-col gap-1.5">
            <label htmlFor={filterId} className="text-xs leading-[18px] font-medium text-muted-foreground">
              Trạng thái
            </label>
            <Select
              value={status}
              onValueChange={(value) => setStatus(value as VehicleStatus | typeof ALL_STATUSES)}
              disabled={pending && !failed}
            >
              <SelectTrigger id={filterId}>
                <SelectValue />
              </SelectTrigger>
              <SelectContent>
                <SelectItem value={ALL_STATUSES}>Tất cả trạng thái</SelectItem>
                {VEHICLE_STATUS_ORDER.map((value) => (
                  <SelectItem key={value} value={value}>
                    {VEHICLE_STATUS[value].label}
                  </SelectItem>
                ))}
              </SelectContent>
            </Select>
          </div>
        </div>

        <div className="min-h-[524px]">{body}</div>
        <div className="flex min-h-10 flex-wrap items-center gap-3">{footer}</div>
      </section>

      <div className="flex flex-wrap items-center gap-x-4 gap-y-2 rounded-lg bg-accent px-5 py-3.5">
        <Armchair className="size-5 shrink-0 text-vxn-teal-700" />
        <p className="min-w-0 flex-1 text-sm leading-5 text-vxn-teal-700">
          Sơ đồ ghế có thể dùng chung cho nhiều xe. Tạo bản sao khi cần một bố cục riêng.
        </p>
        <Button asChild variant="ghost" className={`${BUTTON} text-vxn-fg-1 hover:bg-vxn-teal-100`}>
          <Link href="/seat-maps">
            <ArrowUpRight className="size-[18px]" />
            Sơ đồ ghế
          </Link>
        </Button>
      </div>
    </div>
  );
}

// Tỉ lệ cột theo Figma (242 / 210 / 238 / 162 / 140 / 96 trên bảng rộng 1088).
const COLUMNS = ["w-[22.2%]", "w-[19.3%]", "w-[21.9%]", "w-[14.9%]", "w-[12.9%]", "w-24"];
const HEADINGS = ["Phương tiện", "Dạng chỗ · Hạng xe", "Sơ đồ ghế", "Tiện ích", "Trạng thái"];

function VehicleTable({
  items,
  typeLabels,
  amenityNames
}: {
  items: Vehicle[];
  typeLabels: Map<string, string>;
  /** Theo thứ tự catalog, để cột tiện ích hiện cùng một thứ tự ở mọi xe. */
  amenityNames: [string, string][];
}) {
  return (
    <div className="overflow-x-auto">
      <table className="w-full min-w-[880px] table-fixed border-collapse text-left">
        <colgroup>
          {COLUMNS.map((width) => (
            <col key={width} className={width} />
          ))}
        </colgroup>
        <thead>
          <tr className="h-11 text-xs leading-[18px] text-muted-foreground">
            {HEADINGS.map((heading) => (
              <th key={heading} scope="col" className="bg-muted font-medium first:rounded-l-lg">
                {heading}
              </th>
            ))}
            <th scope="col" className="rounded-r-lg bg-muted">
              <span className="sr-only">Thao tác</span>
            </th>
          </tr>
        </thead>
        <tbody>
          {items.map((vehicle) => {
            const plate = formatPlateNumber(vehicle.plateNumber);
            const names = amenityNames.filter(([id]) => vehicle.amenityIds.includes(id)).map(([, name]) => name);
            const amenity = amenitySummary(names);
            const state = VEHICLE_STATUS[vehicle.status];
            return (
              <tr key={vehicle.id} className="h-20 border-b">
                <td>
                  <div className="flex items-center gap-3 pr-3">
                    {/* Ảnh xe thuộc TASK-TRN-009: chưa có API nên mọi dòng hiện hình thay thế. */}
                    <span className="flex h-12 w-[60px] shrink-0 items-center justify-center rounded-lg bg-muted">
                      <ImageOff className="size-5 text-vxn-fg-3" aria-hidden />
                    </span>
                    <span className="flex min-w-0 flex-col gap-1">
                      <span className="truncate text-sm leading-5 font-semibold text-vxn-teal-700">{plate}</span>
                      <span className="text-xs leading-[18px] text-muted-foreground">Chưa có ảnh</span>
                    </span>
                  </div>
                </td>
                <td className="pr-4 text-sm leading-5 font-medium text-vxn-fg-1">
                  {typeLabels.get(vehicle.vehicleTypeId) ?? "Loại xe đã ngừng dùng"}
                </td>
                <td className="pr-4">
                  <TwoLines
                    first={vehicle.seatMap?.name ?? "Chưa gán sơ đồ"}
                    second={vehicle.seatMap ? seatMapSummaryLine(vehicle.seatMap) : "Chưa có số chỗ / sức chứa"}
                  />
                </td>
                {/* `title`: tên bị cắt vì cột hẹp vẫn đọc được đầy đủ khi rê chuột. */}
                <td className="pr-4" title={names.length > 0 ? names.join(" · ") : undefined}>
                  <TwoLines
                    first={amenity.first}
                    second={amenity.second}
                    suffix={amenity.more > 0 ? ` · +${amenity.more} tiện ích` : undefined}
                  />
                </td>
                <td>
                  <Badge tone={state.tone}>{state.label}</Badge>
                </td>
                <td>
                  <Button asChild variant="ghost" className={`${BUTTON} w-24 text-vxn-fg-1`}>
                    <Link href={`/vehicles/${vehicle.id}`} aria-label={`Sửa phương tiện ${plate}`}>
                      <Pencil className="size-[18px]" />
                      Sửa
                    </Link>
                  </Button>
                </td>
              </tr>
            );
          })}
        </tbody>
      </table>
    </div>
  );
}

/** `suffix` không bị cắt: tên dài thì cắt tên, phần "+N tiện ích" vẫn hiện đủ. */
function TwoLines({ first, second, suffix }: { first: string; second: string; suffix?: string }) {
  return (
    <div className="flex flex-col gap-1.5">
      <span className="truncate text-sm leading-5 font-medium text-vxn-fg-1">{first}</span>
      {second && (
        <span className="flex text-xs leading-[18px] text-muted-foreground">
          <span className="truncate">{second}</span>
          {suffix && <span className="shrink-0 whitespace-pre">{suffix}</span>}
        </span>
      )}
    </div>
  );
}

function LoadingRows() {
  return (
    <div role="status" aria-label="Đang tải danh sách phương tiện" className="flex flex-col">
      {Array.from({ length: 6 }, (_, row) => (
        <div key={row} className="flex h-20 items-center gap-5">
          <Skeleton className="h-12 w-[60px] shrink-0" />
          <div className="flex w-[14%] flex-col gap-2.5">
            <Skeleton className="h-4" />
            <Skeleton className="h-2.5 w-3/5" />
          </div>
          <Skeleton className="ml-4 h-4 w-[11%]" />
          <Skeleton className="h-4 w-[19%]" />
          <Skeleton className="h-4 w-[20%]" />
          <Skeleton className="h-4 w-[13%]" />
          <Skeleton className="h-4 flex-1" />
        </div>
      ))}
    </div>
  );
}

function StatePanel({
  icon,
  title,
  description,
  action
}: {
  icon: ReactNode;
  title: string;
  description: string;
  action: ReactNode;
}) {
  return (
    <div className="flex min-h-[524px] flex-col items-center justify-center gap-3 px-4 text-center">
      {icon}
      <p className="text-base leading-6 font-semibold text-vxn-ink">{title}</p>
      <p className="max-w-md text-sm leading-5 text-muted-foreground">{description}</p>
      {action}
    </div>
  );
}

function FooterNote({ children }: { children: ReactNode }) {
  return <p className="flex-1 text-xs leading-[18px] text-muted-foreground">{children}</p>;
}

/** Chân bảng theo `nextCursor`: còn trang thì hiện "Tải thêm"; lỗi tải thêm vẫn giữ các xe đã tải. */
function LoadMoreFooter({
  count,
  hasMore,
  loading,
  failed,
  onLoadMore
}: {
  count: number;
  hasMore: boolean;
  loading: boolean;
  failed: boolean;
  onLoadMore: () => void;
}) {
  if (failed) {
    return (
      <div role="alert" className="flex flex-1 flex-wrap items-center gap-3 rounded-lg bg-error-50 px-5 py-3">
        <p className="flex-1 text-sm leading-5 text-error-600">
          Chưa tải thêm được phương tiện. Các xe đã tải vẫn được giữ lại.
        </p>
        <Button variant="outline" className={`${BUTTON} w-36 bg-card`} onClick={onLoadMore}>
          Thử lại
        </Button>
      </div>
    );
  }
  if (!hasMore) {
    return <FooterNote>Đã hiển thị tất cả phương tiện</FooterNote>;
  }
  return (
    <>
      <FooterNote>Đã tải {count} phương tiện</FooterNote>
      <Button variant="outline" className={`${BUTTON} w-36 bg-card`} disabled={loading} onClick={onLoadMore}>
        {loading && <LoaderCircle className="size-[18px] animate-spin" />}
        {loading ? "Đang tải thêm…" : "Tải thêm"}
      </Button>
    </>
  );
}
