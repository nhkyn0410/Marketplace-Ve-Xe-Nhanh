// Gọi API Báo cáo / Tổng quan cho Admin (`/admin/reports/*`, `/admin/overview`; TASK-RPT-002, FR-NSR-13, FR-ADM-17). Kiểu lấy từ
// client sinh.
import type { components } from "@vexenhanh/api-client";
import { API_BASE_URL, ApiError, apiRequest, refreshSession } from "@vexenhanh/ui/lib/auth/api-client";

import type { PaymentProvider } from "../payment/payment-api";
import { listOperators, type OperatorPage } from "../user/user-api";

type Schemas = components["schemas"];

export type AdminReport = Schemas["AdminReportDto_Output"];
export type OperatorRow = AdminReport["byOperator"][number];
export type AdminOverview = Schemas["AdminOverviewDto_Output"];

export type AdminReportParams = { from: string; to: string; operatorId?: string; provider?: PaymentProvider };
/** Kiểu CSV: theo nhà xe (mặc định), theo tuyến, theo khu vực (chờ duyệt 28/10/2026). */
export type ReportGroup = "operator" | "route" | "region";

export function getAdminReport(params: AdminReportParams): Promise<AdminReport> {
  return apiRequest<AdminReport>(`/admin/reports/summary?${query(params)}`);
}

export function getAdminOverview(params: AdminReportParams): Promise<AdminOverview> {
  return apiRequest<AdminOverview>(`/admin/overview?${query(params)}`);
}

/**
 * Tải báo cáo theo nhà xe / tuyến / khu vực dạng CSV (máy chủ ghi nhật ký audit). Không đi qua `apiRequest` vì body là tệp: hết phiên thì làm mới
 * một lần rồi thử lại như `apiRequest`.
 */
export async function downloadAdminReportCsv(params: AdminReportParams, group: ReportGroup = "operator"): Promise<void> {
  const search = query(params);
  search.set("group", group);
  const send = () => fetch(`${API_BASE_URL}/admin/reports/export?${search}`, { credentials: "include", cache: "no-store" });
  let response = await send();
  if (response.status === 401 && (await refreshSession()) === "ok") {
    response = await send();
  }
  if (!response.ok) {
    const body = (await response.json().catch(() => ({}))) as { code?: string; detail?: string };
    throw new ApiError(response.status, body.code ?? "UNKNOWN_ERROR", body.detail ?? "Chưa xuất được báo cáo. Vui lòng thử lại.");
  }
  const filename = /filename="([^"]+)"/.exec(response.headers.get("content-disposition") ?? "")?.[1] ?? "bao-cao-he-thong.csv";
  const url = URL.createObjectURL(await response.blob());
  const link = document.createElement("a");
  link.href = url;
  link.download = filename;
  link.click();
  URL.revokeObjectURL(url);
}

function query(params: AdminReportParams): URLSearchParams {
  const search = new URLSearchParams();
  for (const [key, value] of Object.entries(params)) {
    if (value) {
      search.set(key, value);
    }
  }
  return search;
}

/** Nhà xe cho ô lọc "Nhà xe": đi hết các trang (tối đa 10 trang × 20). */
export async function listOperatorOptions(): Promise<{ value: string; label: string }[]> {
  const options: { value: string; label: string }[] = [];
  let cursor: string | null = null;
  for (let page = 0; page < 10; page++) {
    const result: OperatorPage = await listOperators({}, cursor);
    options.push(...result.items.map((item) => ({ value: item.id, label: item.name })));
    cursor = result.nextCursor;
    if (!cursor) {
      break;
    }
  }
  return options;
}
