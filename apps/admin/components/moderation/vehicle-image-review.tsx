"use client";

import { useInfiniteQuery } from "@tanstack/react-query";
import { Button } from "@vexenhanh/ui/components/button";
import { ALL, FilterSelect } from "@vexenhanh/ui/components/list-controls";
import { BUTTON, ListLoadMoreFooter, ListStatePanel } from "@vexenhanh/ui/components/list-parts";
import { CircleAlert, CircleCheck, ImageIcon, Images, RefreshCw, Trash2 } from "lucide-react";
import { useMemo, useState, type ReactNode } from "react";

import { submittedSince, formatShortDateTime } from "../../lib/operator-application/application-format";
import { formatPlateNumber, UPLOAD_WINDOWS } from "../../lib/moderation/moderation-format";
import {
  listVehicleImages,
  type AdminVehicleImage,
  type VehicleImageFilters
} from "../../lib/moderation/vehicle-image-api";
import { RemoveImageDialog } from "./remove-image-dialog";

/**
 * Tab "Ảnh phương tiện" của màn Kiểm duyệt (Figma ADM-10b; FR-ADM-20, BR-76): ảnh của mọi nhà xe, mới tải lên
 * trước, lọc nhà xe / thời gian tải lên; mỗi ảnh có nút "Gỡ ảnh" mở hộp thoại lý do (ADM-10c).
 */
export function VehicleImageReview() {
  const [operatorId, setOperatorId] = useState<string>(ALL);
  const [period, setPeriod] = useState<string>("7");
  const [target, setTarget] = useState<AdminVehicleImage | null>(null);
  const [notice, setNotice] = useState<string | null>(null);

  const filters = useMemo<VehicleImageFilters>(
    () => ({
      operatorId: operatorId === ALL ? undefined : operatorId,
      uploadedSince: period === ALL ? undefined : submittedSince(Number(period))
    }),
    [operatorId, period]
  );
  const pages = useInfiniteQuery({
    queryKey: ["admin-vehicle-images", filters],
    queryFn: ({ pageParam }) => listVehicleImages(filters, pageParam),
    initialPageParam: null as string | null,
    getNextPageParam: (last) => last.nextCursor
  });
  const images = pages.data?.pages.flatMap((page) => page.items) ?? [];
  const total = pages.data?.pages[0]?.total ?? 0;
  const operators = pages.data?.pages[0]?.operators ?? [];
  const filtered = operatorId !== ALL || period !== ALL;

  let body: ReactNode;
  let footer: ReactNode = null;
  if (pages.isError && images.length === 0) {
    body = (
      <ListStatePanel
        icon={<CircleAlert className="size-6 text-warning-700" />}
        title="Không tải được ảnh phương tiện"
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
    body = <ImageGridSkeleton />;
  } else if (images.length === 0) {
    body = (
      <ListStatePanel
        icon={<Images className="size-6 text-vxn-fg-3" />}
        title={filtered ? "Không có ảnh phù hợp" : "Chưa có ảnh phương tiện nào"}
        description={
          filtered ? "Đổi nhà xe hoặc thời gian tải lên để xem thêm ảnh." : "Ảnh nhà xe tải lên cho phương tiện sẽ hiện ở đây."
        }
        action={
          filtered ? (
            <Button
              variant="outline"
              className={`${BUTTON} bg-card`}
              onClick={() => {
                setOperatorId(ALL);
                setPeriod(ALL);
              }}
            >
              Bỏ lọc
            </Button>
          ) : undefined
        }
      />
    );
  } else {
    body = (
      <ul aria-label="Ảnh phương tiện" className="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4">
        {images.map((image) => (
          <ImageCard key={image.id} image={image} onRemove={() => setTarget(image)} />
        ))}
      </ul>
    );
    footer = (
      <ListLoadMoreFooter
        hasMore={pages.hasNextPage}
        loading={pages.isFetchingNextPage}
        failed={pages.isFetchNextPageError}
        loadedText={`Đã tải ${images.length} / ${total.toLocaleString("vi-VN")} ảnh`}
        endText={`Đã hiện tất cả ${images.length} ảnh`}
        errorText="Không tải thêm được ảnh. Kiểm tra kết nối rồi thử lại."
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
      <section aria-label="Ảnh phương tiện của các nhà xe" className="flex flex-col rounded-xl border bg-card p-6">
        <div className="flex flex-wrap items-end gap-x-4 gap-y-3 pb-5">
          <FilterSelect
            label="Nhà xe"
            allLabel="Tất cả nhà xe"
            value={operatorId}
            onChange={setOperatorId}
            options={operators.map((operator) => ({ value: operator.id, label: operator.name }))}
            className="w-60"
          />
          <FilterSelect
            label="Thời gian tải lên"
            allLabel="Mọi thời điểm"
            value={period}
            onChange={setPeriod}
            options={UPLOAD_WINDOWS.map((option) => ({ ...option }))}
            className="w-56"
          />
          <p className="ml-auto pb-2.5 text-sm leading-5 text-muted-foreground">Mới nhất trước</p>
        </div>
        <div className="min-h-[360px]">{body}</div>
        {footer && <div className="flex min-h-14 items-center pt-5">{footer}</div>}
      </section>
      <div className="flex items-center gap-4 rounded-lg bg-accent px-5 py-4">
        <ImageIcon className="size-5 shrink-0 text-accent-foreground" />
        <p className="min-w-0 flex-1 text-sm leading-5 text-accent-foreground">
          Ảnh phương tiện hiển thị công khai ngay khi nhà xe lưu, không qua bước duyệt trước. Ảnh không được chứa giấy tờ
          hoặc dữ liệu cá nhân.
        </p>
      </div>
      <RemoveImageDialog
        image={target}
        onClose={() => setTarget(null)}
        onRemoved={(image) => {
          setNotice(`Đã gỡ ảnh của xe ${formatPlateNumber(image.plateNumber)} (${image.operatorName}).`);
        }}
      />
    </>
  );
}

function ImageCard({ image, onRemove }: { image: AdminVehicleImage; onRemove: () => void }) {
  const plate = formatPlateNumber(image.plateNumber);
  return (
    <li className="flex flex-col overflow-hidden rounded-xl border bg-card">
      <div className="relative aspect-[258/150] bg-muted">
        {/* Ảnh ở kho công khai: <img> thường, không qua bộ tối ưu ảnh của Next. */}
        <img
          src={image.url}
          alt={`Ảnh xe ${plate} của ${image.operatorName}${image.caption ? ` — ${image.caption}` : ""}`}
          loading="lazy"
          className="absolute inset-0 size-full object-cover"
        />
        {image.isCover && (
          <span className="absolute top-2 left-2 rounded-md bg-vxn-ink/75 px-2 py-0.5 text-xs leading-[18px] font-medium text-white">
            Ảnh đại diện
          </span>
        )}
      </div>
      <div className="flex flex-col gap-1 px-4 pt-3.5 pb-4">
        <p className="truncate text-sm leading-5 font-semibold text-vxn-ink">{image.operatorName}</p>
        <p className="truncate text-xs leading-[18px] text-muted-foreground">
          {plate} · {image.caption ?? "Không có chú thích"}
        </p>
        <div className="flex items-center justify-between gap-3 pt-2">
          <span className="text-xs leading-[18px] text-muted-foreground">{formatShortDateTime(image.createdAt)}</span>
          <Button
            variant="outline"
            className={`${BUTTON} bg-card text-error-600 hover:text-error-700`}
            aria-label={`Gỡ ảnh xe ${plate} của ${image.operatorName}`}
            onClick={onRemove}
          >
            <Trash2 className="size-[18px]" />
            Gỡ ảnh
          </Button>
        </div>
      </div>
    </li>
  );
}

function ImageGridSkeleton() {
  return (
    <div role="status" aria-label="Đang tải ảnh phương tiện" className="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4">
      {Array.from({ length: 8 }, (_, index) => (
        <div key={index} className="flex flex-col overflow-hidden rounded-xl border">
          <div className="aspect-[258/150] animate-pulse bg-muted" />
          <div className="flex flex-col gap-2 p-4">
            <div className="h-4 w-2/3 animate-pulse rounded bg-muted" />
            <div className="h-3 w-1/2 animate-pulse rounded bg-muted" />
          </div>
        </div>
      ))}
    </div>
  );
}
