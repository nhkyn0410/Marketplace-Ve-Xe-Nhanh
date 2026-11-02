"use client";

import { useQuery } from "@tanstack/react-query";
import { Button } from "@vexenhanh/ui/components/button";
import { FormField } from "@vexenhanh/ui/components/form-field";
import { Input } from "@vexenhanh/ui/components/input";
import { BUTTON } from "@vexenhanh/ui/components/list-parts";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@vexenhanh/ui/components/select";
import { Textarea } from "@vexenhanh/ui/components/textarea";
import { useMemo } from "react";
import { Controller, type UseFormReturn } from "react-hook-form";

import { listProvinces, listWards, type StopPointType } from "../../lib/stop-point/stop-point-api";
import {
  ADDRESS_MAX_LENGTH,
  DESCRIPTION_MAX_LENGTH,
  LEGAL_BASIS_MAX_LENGTH,
  NAME_MAX_LENGTH,
  SHARED_STATUS,
  STOP_POINT_TYPE_LABELS,
  type LocationFormValues
} from "../../lib/stop-point/stop-point-format";

/** Tỉnh / phường đang lưu trên điểm — giữ được lựa chọn dù danh mục đã ngừng dùng chúng. */
export type StoredLocation = { provinceId: string; wardId: string } | null;

/**
 * Các ô thông tin một điểm dừng (Figma ADM-05c "Thông tin điểm dừng"): tên, loại, [trạng thái], địa chỉ, tỉnh /
 * thành, phường / xã, [tọa độ], căn cứ công bố, ghi chú. Dùng cho hộp thoại điểm dùng chung và trang duyệt đề xuất.
 */
export function LocationFields({
  form,
  typeOptions,
  showStatus,
  showCoordinates,
  stored,
  disabled
}: {
  form: UseFormReturn<LocationFormValues>;
  typeOptions: readonly StopPointType[];
  showStatus: boolean;
  /** `false` khi tọa độ nằm ở cột bản đồ bên cạnh. */
  showCoordinates: boolean;
  stored: StoredLocation;
  disabled?: boolean;
}) {
  const { errors } = form.formState;
  const provinceId = form.watch("provinceId");
  const legalBasis = form.watch("legalBasis");
  const description = form.watch("description");

  const provinces = useQuery({ queryKey: ["catalog", "provinces"], queryFn: listProvinces, staleTime: 300_000 });
  const wards = useQuery({
    queryKey: ["catalog", "wards", provinceId],
    queryFn: () => listWards(provinceId),
    enabled: provinceId !== "",
    staleTime: 300_000
  });
  const provinceOptions = useMemo(() => {
    const options = (provinces.data ?? []).map((province) => ({ id: province.id, label: province.name }));
    if (provinces.data && stored && !options.some((option) => option.id === stored.provinceId)) {
      options.push({ id: stored.provinceId, label: "Tỉnh / thành đã ngừng dùng" });
    }
    return options;
  }, [provinces.data, stored]);
  const wardOptions = useMemo(() => {
    const options = (wards.data ?? []).map((ward) => ({ id: ward.id, label: ward.name }));
    if (wards.data && stored && stored.provinceId === provinceId && !options.some((option) => option.id === stored.wardId)) {
      options.push({ id: stored.wardId, label: "Phường / xã đã ngừng dùng" });
    }
    return options;
  }, [wards.data, stored, provinceId]);

  return (
    <div className="grid content-start gap-x-4 gap-y-4 sm:grid-cols-2">
      {(provinces.isError || wards.isError) && (
        <div role="alert" className="flex flex-wrap items-center gap-3 rounded-lg bg-error-50 px-4 py-3 sm:col-span-2">
          <p className="min-w-0 flex-1 text-sm leading-5 text-error-600">Chưa tải được danh sách tỉnh / thành, phường / xã.</p>
          <Button
            type="button"
            variant="outline"
            className={`${BUTTON} bg-card`}
            onClick={() => [provinces, wards].filter((query) => query.isError).forEach((query) => void query.refetch())}
          >
            Thử lại
          </Button>
        </div>
      )}

      <FormField label="Tên điểm dừng *" helper={`Tối đa ${NAME_MAX_LENGTH} ký tự`} error={errors.name?.message} className="sm:col-span-2">
        {(control) => (
          <Input {...control} {...form.register("name")} autoComplete="off" maxLength={NAME_MAX_LENGTH} disabled={disabled} />
        )}
      </FormField>

      <FormField label="Loại điểm *" error={errors.type?.message} className={showStatus ? undefined : "sm:col-span-2"}>
        {(control) => (
          <Controller
            control={form.control}
            name="type"
            render={({ field }) => (
              <Select value={field.value} onValueChange={field.onChange} disabled={disabled}>
                <SelectTrigger {...control} onBlur={field.onBlur}>
                  <SelectValue placeholder="Chọn loại điểm" />
                </SelectTrigger>
                <SelectContent>
                  {typeOptions.map((type) => (
                    <SelectItem key={type} value={type}>
                      {STOP_POINT_TYPE_LABELS[type]}
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
            )}
          />
        )}
      </FormField>

      {showStatus && (
        <FormField label="Trạng thái *" error={errors.status?.message}>
          {(control) => (
            <Controller
              control={form.control}
              name="status"
              render={({ field }) => (
                <Select value={field.value} onValueChange={field.onChange} disabled={disabled}>
                  <SelectTrigger {...control} onBlur={field.onBlur}>
                    <SelectValue />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="ACTIVE">{SHARED_STATUS.ACTIVE.label}</SelectItem>
                    <SelectItem value="INACTIVE">{SHARED_STATUS.INACTIVE.label}</SelectItem>
                  </SelectContent>
                </Select>
              )}
            />
          )}
        </FormField>
      )}

      <FormField label="Địa chỉ *" error={errors.address?.message} className="sm:col-span-2">
        {(control) => (
          <Input {...control} {...form.register("address")} autoComplete="off" maxLength={ADDRESS_MAX_LENGTH} disabled={disabled} />
        )}
      </FormField>

      <FormField label="Tỉnh / thành *" error={errors.provinceId?.message}>
        {(control) => (
          <Controller
            control={form.control}
            name="provinceId"
            render={({ field }) => (
              <Select
                value={field.value}
                onValueChange={(value) => {
                  field.onChange(value);
                  // Phường / xã thuộc tỉnh cũ không còn hợp lệ.
                  form.setValue("wardId", "", { shouldDirty: true });
                }}
                disabled={disabled || provinces.isPending}
              >
                <SelectTrigger {...control} onBlur={field.onBlur}>
                  <SelectValue placeholder={provinces.isPending ? "Đang tải…" : "Chọn tỉnh / thành"} />
                </SelectTrigger>
                <SelectContent>
                  {provinceOptions.map((option) => (
                    <SelectItem key={option.id} value={option.id}>
                      {option.label}
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
            )}
          />
        )}
      </FormField>

      <FormField label="Phường / xã *" error={errors.wardId?.message}>
        {(control) => (
          <Controller
            control={form.control}
            name="wardId"
            render={({ field }) => (
              <Select value={field.value} onValueChange={field.onChange} disabled={disabled || provinceId === "" || wards.isPending}>
                <SelectTrigger {...control} onBlur={field.onBlur}>
                  <SelectValue
                    placeholder={provinceId === "" ? "Chọn tỉnh / thành trước" : wards.isPending ? "Đang tải…" : "Chọn phường / xã"}
                  />
                </SelectTrigger>
                <SelectContent>
                  {wardOptions.map((option) => (
                    <SelectItem key={option.id} value={option.id}>
                      {option.label}
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
            )}
          />
        )}
      </FormField>

      {showCoordinates && <CoordinateFields form={form} disabled={disabled} />}

      <FormField
        label="Căn cứ công bố"
        helper={`Bắt buộc với bến xe và điểm dừng đón trả · số, ngày văn bản của cơ quan có thẩm quyền · ${legalBasis.length} / ${LEGAL_BASIS_MAX_LENGTH} ký tự`}
        error={errors.legalBasis?.message}
        className="sm:col-span-2"
      >
        {(control) => (
          <Textarea {...control} {...form.register("legalBasis")} rows={3} maxLength={LEGAL_BASIS_MAX_LENGTH} disabled={disabled} />
        )}
      </FormField>

      <FormField
        label="Ghi chú"
        helper={`Tùy chọn · ${description.length} / ${DESCRIPTION_MAX_LENGTH} ký tự`}
        error={errors.description?.message}
        className="sm:col-span-2"
      >
        {(control) => (
          <Textarea {...control} {...form.register("description")} rows={2} maxLength={DESCRIPTION_MAX_LENGTH} disabled={disabled} />
        )}
      </FormField>
    </div>
  );
}

/** Hai ô vĩ độ / kinh độ (gõ tay hoặc lấy từ bản đồ). */
export function CoordinateFields({ form, disabled }: { form: UseFormReturn<LocationFormValues>; disabled?: boolean }) {
  const { errors } = form.formState;
  return (
    <>
      <FormField label="Vĩ độ *" helper="Từ -90 đến 90, ví dụ 10.8787" error={errors.latitude?.message}>
        {(control) => (
          <Input {...control} {...form.register("latitude")} autoComplete="off" inputMode="decimal" disabled={disabled} />
        )}
      </FormField>
      <FormField label="Kinh độ *" helper="Từ -180 đến 180, ví dụ 106.8164" error={errors.longitude?.message}>
        {(control) => (
          <Input {...control} {...form.register("longitude")} autoComplete="off" inputMode="decimal" disabled={disabled} />
        )}
      </FormField>
    </>
  );
}
