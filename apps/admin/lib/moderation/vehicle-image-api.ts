// Gọi API rà soát ảnh phương tiện cho cổng Admin (05 API §7.5 `/admin/vehicle-images`; TASK-ADM-003 phần ảnh xe).
import type { components } from "@vexenhanh/api-client";
import { apiRequest } from "@vexenhanh/ui/lib/auth/api-client";

type Schemas = components["schemas"];

export type VehicleImagePage = Schemas["AdminVehicleImageListDto_Output"];
export type AdminVehicleImage = VehicleImagePage["items"][number];
export type VehicleImageFilters = { operatorId?: string; uploadedSince?: string };

/** Lưới 4 cột (Figma ADM-10b): mỗi lần tải 3 hàng. */
const PAGE_SIZE = "12";

export function listVehicleImages(filters: VehicleImageFilters, cursor: string | null): Promise<VehicleImagePage> {
  const search = new URLSearchParams({ limit: PAGE_SIZE });
  for (const [key, value] of Object.entries({ ...filters, cursor })) {
    if (value) {
      search.set(key, value);
    }
  }
  return apiRequest<VehicleImagePage>(`/admin/vehicle-images?${search.toString()}`);
}

export function removeVehicleImage(imageId: string, reason: string): Promise<void> {
  return apiRequest<void>(`/admin/vehicle-images/${imageId}/remove`, { method: "POST", body: { reason } });
}
