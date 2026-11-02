// Gọi API danh mục chuẩn cho cổng Admin (05 API §7.5 `/admin/catalog/*`; TASK-ADM-001 phần catalog).
import type { components } from "@vexenhanh/api-client";
import { apiRequest } from "@vexenhanh/ui/lib/auth/api-client";

type Schemas = components["schemas"];

export type Province = Schemas["AdminProvinceDto_Output"];
export type ProvincePage = Schemas["AdminProvincePageDto_Output"];
export type Ward = Schemas["AdminWardDto_Output"];
export type WardPage = Schemas["AdminWardPageDto_Output"];
export type VehicleType = Schemas["AdminVehicleTypeDto_Output"];
export type VehicleTypeInput = Schemas["AdminVehicleTypeInputDto"];
export type Amenity = Schemas["AdminAmenityDto_Output"];
export type CatalogStatus = Province["status"];
export type VehicleForm = VehicleType["form"];
export type VehicleClass = VehicleType["class"];

/** Loại danh mục — cũng là đoạn đường dẫn của API và giá trị `?tab=` của màn hình. */
export type CatalogKind = "provinces" | "wards" | "vehicle-types" | "amenities";
/** Một mục bất kỳ của bốn danh mục (đủ cho hộp thoại ngừng dùng / dùng lại). */
export type CatalogItem = Province | Ward | VehicleType | Amenity;

const PAGE_SIZE = "20";

function query(params: Record<string, string | undefined | null>): string {
  const search = new URLSearchParams();
  for (const [key, value] of Object.entries(params)) {
    if (value) {
      search.set(key, value);
    }
  }
  return search.toString();
}

export function listProvinces(filters: { q?: string; status?: string }, cursor: string | null): Promise<ProvincePage> {
  return apiRequest<ProvincePage>(`/admin/catalog/provinces?${query({ ...filters, cursor, limit: PAGE_SIZE })}`);
}

/** Mọi tỉnh / thành (cho ô chọn tỉnh ở tab Phường / xã) — 34 dòng sau sắp xếp 2025, đi hết các trang. */
export async function listAllProvinces(): Promise<Province[]> {
  const items: Province[] = [];
  let cursor: string | null = null;
  do {
    const page: ProvincePage = await apiRequest<ProvincePage>(`/admin/catalog/provinces?${query({ cursor, limit: "100" })}`);
    items.push(...page.items);
    cursor = page.nextCursor;
  } while (cursor);
  return items;
}

export function listWards(
  filters: { q?: string; status?: string; provinceId?: string },
  cursor: string | null
): Promise<WardPage> {
  return apiRequest<WardPage>(`/admin/catalog/wards?${query({ ...filters, cursor, limit: PAGE_SIZE })}`);
}

export async function listVehicleTypes(status?: string): Promise<VehicleType[]> {
  return (await apiRequest<{ items: VehicleType[] }>(`/admin/catalog/vehicle-types?${query({ status })}`)).items;
}

export async function listAmenities(status?: string): Promise<Amenity[]> {
  return (await apiRequest<{ items: Amenity[] }>(`/admin/catalog/amenities?${query({ status })}`)).items;
}

export function createProvince(input: { code: string; name: string }): Promise<Province> {
  return apiRequest<Province>("/admin/catalog/provinces", { method: "POST", body: input });
}

export function createWard(input: { provinceId: string; code: string; name: string }): Promise<Ward> {
  return apiRequest<Ward>("/admin/catalog/wards", { method: "POST", body: input });
}

export function createVehicleType(input: VehicleTypeInput): Promise<VehicleType> {
  return apiRequest<VehicleType>("/admin/catalog/vehicle-types", { method: "POST", body: input });
}

export function createAmenity(input: { code: string; name: string }): Promise<Amenity> {
  return apiRequest<Amenity>("/admin/catalog/amenities", { method: "POST", body: input });
}

/** Đổi tên (loại xe: tên + mô tả). Mã, tỉnh của phường, dạng chỗ / hạng xe không đổi được. */
export function updateCatalogItem(
  kind: CatalogKind,
  id: string,
  input: { name: string; description?: string | null }
): Promise<CatalogItem> {
  const body = kind === "vehicle-types" ? { name: input.name, description: input.description ?? null } : { name: input.name };
  return apiRequest<CatalogItem>(`/admin/catalog/${kind}/${id}`, { method: "PUT", body });
}

export function deactivateCatalogItem(kind: CatalogKind, id: string, reason: string): Promise<void> {
  return apiRequest<void>(`/admin/catalog/${kind}/${id}/deactivate`, { method: "POST", body: { reason } });
}

export function activateCatalogItem(kind: CatalogKind, id: string): Promise<void> {
  return apiRequest<void>(`/admin/catalog/${kind}/${id}/activate`, { method: "POST" });
}
