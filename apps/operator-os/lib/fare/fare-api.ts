// Gọi API Bảng giá cho Operator OS (05 API §7.3). Kiểu lấy từ client sinh tự OpenAPI nên DTO backend đổi
// mà chưa sửa ở đây thì typecheck đỏ.
import type { components } from "@vexenhanh/api-client";

import { apiRequest } from "../auth/api-client";

type Schemas = components["schemas"];

export type Fare = Schemas["FareResponseDto_Output"];
export type FareRule = Fare["rules"][number];
export type FareStatus = Fare["status"];
export type FarePage = Schemas["FareListResponseDto_Output"];
export type FareSummary = FarePage["items"][number];
export type FareCreateInput = Schemas["FareCreateInputDto"];
export type FareUpdateInput = Schemas["FareUpdateInputDto"];
export type FareRevisionPage = Schemas["FareRevisionListResponseDto_Output"];
export type FareRevision = FareRevisionPage["items"][number];

/** Số dòng lịch sử mỗi lần tải ở thẻ "Lịch sử thay đổi" (API cho tối đa 20). */
export const FARE_REVISION_PAGE_SIZE = 5;

/** Mọi bảng giá của nhà xe (không kèm quy tắc); đi hết các trang vì màn danh sách ghép với danh sách tuyến. */
export async function listAllFares(): Promise<FareSummary[]> {
  const items: FareSummary[] = [];
  let cursor: string | null = null;
  do {
    const query = new URLSearchParams({ limit: "100" });
    if (cursor) {
      query.set("cursor", cursor);
    }
    const page: FarePage = await apiRequest<FarePage>(`/operator/fares?${query}`);
    items.push(...page.items);
    cursor = page.nextCursor;
  } while (cursor);
  return items;
}

/** Chi tiết một bảng giá kèm toàn bộ quy tắc. */
export function getFare(fareId: string): Promise<Fare> {
  return apiRequest<Fare>(`/operator/fares/${fareId}`);
}

/** Tạo bảng giá cho một tuyến (mỗi tuyến một bảng giá). */
export function createFare(input: FareCreateInput): Promise<Fare> {
  return apiRequest<Fare>("/operator/fares", { method: "POST", body: input });
}

/** Thay toàn bộ trạng thái, ghi chú và quy tắc của một bảng giá (không đổi tuyến). */
export function updateFare(fareId: string, input: FareUpdateInput): Promise<Fare> {
  return apiRequest<Fare>(`/operator/fares/${fareId}`, { method: "PUT", body: input });
}

/** Một trang lịch sử thay đổi của bảng giá, mới nhất trước; `cursor` là `nextCursor` của trang trước. */
export function listFareRevisions(fareId: string, cursor?: string): Promise<FareRevisionPage> {
  const query = new URLSearchParams({ limit: String(FARE_REVISION_PAGE_SIZE) });
  if (cursor) {
    query.set("cursor", cursor);
  }
  return apiRequest<FareRevisionPage>(`/operator/fares/${fareId}/revisions?${query}`);
}
