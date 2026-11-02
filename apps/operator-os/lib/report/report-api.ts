// Gọi API Báo cáo / Tổng quan cho Operator OS (`/operator/reports/*`, `/operator/overview`, TASK-RPT-001). Kiểu lấy từ client sinh.
import type { components } from "@vexenhanh/api-client";

import { API_BASE_URL, ApiError, apiRequest, refreshSession } from "../auth/api-client";
import type { TripStatus } from "../trip/trip-api";

type Schemas = components["schemas"];

export type OperatorReport = Schemas["OperatorReportDto_Output"];
export type ReportRouteRow = OperatorReport["byRoute"][number];
export type ReportEmployeeRow = OperatorReport["employees"][number];
export type OperatorOverview = Schemas["OperatorOverviewDto_Output"];
export type UpcomingTrip = OperatorOverview["upcoming"][number];

export type ReportParams = { from: string; to: string; routeId?: string; vehicleId?: string; status?: TripStatus };

/** Báo cáo của các chuyến khởi hành trong khoảng ngày (giờ VN, gồm hai đầu). */
export function getOperatorReport(params: ReportParams): Promise<OperatorReport> {
  return apiRequest<OperatorReport>(`/operator/reports/summary?${query(params)}`);
}

export function getOperatorOverview(): Promise<OperatorOverview> {
  return apiRequest<OperatorOverview>("/operator/overview");
}

/**
 * Tải báo cáo theo tuyến dạng CSV (máy chủ ghi nhật ký). Không đi qua `apiRequest` vì body là tệp: hết phiên thì làm mới một
 * lần rồi thử lại như `apiRequest`.
 */
export async function downloadReportCsv(params: ReportParams): Promise<void> {
  const send = () => fetch(`${API_BASE_URL}/operator/reports/export?${query(params)}`, { credentials: "include", cache: "no-store" });
  let response = await send();
  if (response.status === 401 && (await refreshSession()) === "ok") {
    response = await send();
  }
  if (!response.ok) {
    const body = (await response.json().catch(() => ({}))) as { code?: string; detail?: string };
    throw new ApiError(response.status, body.code ?? "UNKNOWN_ERROR", body.detail ?? "Chưa xuất được báo cáo. Vui lòng thử lại.");
  }
  const filename = /filename="([^"]+)"/.exec(response.headers.get("content-disposition") ?? "")?.[1] ?? "bao-cao.csv";
  const url = URL.createObjectURL(await response.blob());
  const link = document.createElement("a");
  link.href = url;
  link.download = filename;
  link.click();
  URL.revokeObjectURL(url);
}

function query(params: ReportParams): URLSearchParams {
  const search = new URLSearchParams();
  for (const [key, value] of Object.entries(params)) {
    if (value) {
      search.set(key, value);
    }
  }
  return search;
}
